import logging
from fastapi import APIRouter, HTTPException
from langchain_core.prompts import PromptTemplate
from backend.database import get_connection
from backend.models import GenerateSectionRequest
from backend.llm import llm, get_memory, save_to_memory
from backend.utils.version_helper import bump_document_version
from backend.utils.text_cleaner import clean_content
from backend.redis_client import set_job_status, check_rate_limit

router = APIRouter()
logger = logging.getLogger("docforge.sections")


SECTION_PROMPT = PromptTemplate(
    input_variables=["section_title", "answers_text", "chat_history"],
    template="""
You are an enterprise documentation assistant for Indian B2B companies.
Your job is to generate professional business document sections.

Previous sections context:
{chat_history}

Current Section: {section_title}

User Answers:
{answers_text}

Your task:
- If user answers are provided, use them to generate the section content
- If no answers are provided or answers are empty, generate content
  strictly based on what the QUESTIONS are asking about
- Read each question carefully and generate answer content
  relevant to that specific question topic
- Do not generate generic definitions, purposes or objectives
- Generate practical, specific, actionable content

Output format rules:
- Always generate content in the same format the user used
- If user wrote bullet points, output bullet points using the symbol
- If user wrote paragraphs, output paragraphs
- If user wrote a table, output a pipe table
- If no user answers, generate professional bullet points by default

Bullet point rules:
- Use bullet symbol for each point
- Every bullet point MUST have a bold label before the colon
- Bold label MUST use ** ** on both sides like this: **Label**
- Format: • **Label:** description here
- The label must be 1 to 3 words extracted from the content
- Keep full content as the user wrote it, do not shorten anything
- Each bullet point on its own line

Table rules:
- Use proper pipe format
- | Column 1 | Column 2 | Column 3 |
- | Value 1  | Value 2  | Value 3  |

Paragraph rules:
- Split long paragraphs into chunks of maximum 4 lines
- Add blank line between each chunk
- Never cut a sentence in the middle

Bold and underline rules:
- Every bullet label MUST be bold using ** **
- Additional bold using ** **: key terms, product names, policy names,
  role names, important numbers, feature names
- Underline using __ __: warnings, legal requirements, mandatory items
- Do not bold or underline every word in description

Do not include:
- Generic labels like "Definition:" or "Purpose:" or "Objective:"
- Questions in the output
- Markdown headers using ##
- Any preamble or explanation before the content
- Any closing remarks after the content

Example of correct output:
- **Cost Control:** Establish clear spending boundaries ensuring all
  employee expenses align with company budget guidelines
- **Transparency:** Create a fair and consistent framework for expense
  reporting and reimbursement across all departments
- **Compliance:** Ensure all business expenses meet Indian financial
  regulations and statutory tax requirements

Generate the section content now:
"""
)


@router.post("/generate_section")
def generate_section(data: GenerateSectionRequest):
    logger.info(
        f"Section generation started | "
        f"doc={data.document_id} | section={data.section_order}"
    )

    # Rate limiting
    if not check_rate_limit(
        f"generate_section_{data.document_id}",
        max_calls=20,
        window_seconds=60
    ):
        logger.warning(f"Rate limit exceeded | doc={data.document_id}")
        raise HTTPException(
            status_code=429,
            detail="Rate limit exceeded. Please wait before generating again."
        )

    # Job tracking
    job_id = f"section_{data.document_id}_{data.section_order}"
    set_job_status(job_id, "processing", {
        "document_id":   data.document_id,
        "section_order": data.section_order
    })

    conn   = get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT template_id FROM documents WHERE id=%s",
            (data.document_id,)
        )
        result = cursor.fetchone()
        if not result:
            logger.error(f"Document not found | doc={data.document_id}")
            raise HTTPException(status_code=404, detail="Document not found")
        template_id = result[0]

        cursor.execute(
            """
            SELECT section_title FROM template_sections
            WHERE template_id=%s AND section_order=%s
            """,
            (template_id, data.section_order)
        )
        result = cursor.fetchone()
        if not result:
            logger.error(
                f"Section not found | "
                f"template={template_id} | order={data.section_order}"
            )
            raise HTTPException(status_code=404, detail="Section not found")
        section_title = result[0]

        # Handle empty answers gracefully
        if data.answers and len(data.answers) > 0:
            answers_text = "\n".join(
                [
                    f"{a.question}: {a.answer}"
                    for a in data.answers
                    if a.answer and a.answer.strip()
                ]
            )
            if not answers_text.strip():
                answers_text = "No answers provided. Generate professional content based on section title."
        else:
            answers_text = "No answers provided. Generate professional content based on section title."

        memory       = get_memory(data.document_id)
        chat_history = ""
        messages     = memory.messages
        if messages:
            recent_messages = messages[-4:]
            chat_history    = "\n".join([m.content for m in recent_messages])

        chain = SECTION_PROMPT | llm

        try:
            response = chain.invoke({
                "section_title": section_title,
                "answers_text":  answers_text,
                "chat_history":  chat_history or "No previous sections yet."
            })
            content = response.content or "No content generated"
            logger.info(
                f"LLM generation successful | "
                f"doc={data.document_id} | section={section_title}"
            )
        except Exception as e:
            logger.error(
                f"LLM generation failed | "
                f"doc={data.document_id} | error={str(e)}"
            )
            set_job_status(job_id, "failed", {"error": str(e)})
            raise HTTPException(
                status_code=500,
                detail=f"LLM generation failed: {str(e)}"
            )

        content = clean_content(content)
        save_to_memory(data.document_id, section_title, content)

        # Get current version
        cursor.execute(
            "SELECT current_version FROM documents WHERE id=%s",
            (data.document_id,)
        )
        ver_row     = cursor.fetchone()
        current_ver = ver_row[0] if ver_row and ver_row[0] else "v1.0"

        # Check if section already exists
        cursor.execute(
            """
            SELECT COUNT(*) FROM document_sections
            WHERE document_id=%s AND section_order=%s
            """,
            (data.document_id, data.section_order)
        )
        exists = cursor.fetchone()[0]

        if exists:
            new_ver = bump_document_version(data.document_id)
        else:
            new_ver = current_ver

        # Mark old versions as not latest
        cursor.execute(
            """
            UPDATE document_sections
            SET is_latest = FALSE
            WHERE document_id=%s AND section_order=%s
            """,
            (data.document_id, data.section_order)
        )

        # Insert new version
        cursor.execute(
            """
            INSERT INTO document_sections
            (document_id, section_title, section_content,
             section_order, version, is_latest, is_completed)
            VALUES (%s, %s, %s, %s, %s, TRUE, TRUE)
            """,
            (
                data.document_id,
                section_title,
                content,
                data.section_order,
                new_ver
            )
        )

        conn.commit()

        set_job_status(job_id, "completed", {
            "document_id":   data.document_id,
            "section_order": data.section_order,
            "section_title": section_title
        })

        logger.info(
            f"Section saved | doc={data.document_id} | "
            f"section={section_title} | version={new_ver}"
        )

        return {
            "section": section_title,
            "content": content,
            "version": new_ver
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Unexpected error | doc={data.document_id} | {e}")
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()