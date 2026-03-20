from fastapi import APIRouter, HTTPException
from backend.database import get_connection
from backend.models import GenerateSectionRequest
from backend.llm import llm

router = APIRouter()


@router.post("/generate_section")
def generate_section(data: GenerateSectionRequest):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT template_id FROM documents WHERE id=%s",
        (data.document_id,)
    )
    template_id = cursor.fetchone()[0]

    cursor.execute(
        """
        SELECT section_title FROM template_sections
        WHERE template_id=%s AND section_order=%s
        """,
        (template_id, data.section_order)
    )
    section_title = cursor.fetchone()[0]

    answers_text = "\n".join(
        [f"{a.question}: {a.answer}" for a in data.answers]
    )

    prompt = f"""
You are an enterprise SaaS documentation assistant.
Generate professional content for the following section.

Section: {section_title}

User Answers:
{answers_text}

Guidelines:
- Keep it professional
- Strictly use the user's answers
- Expand only for clarity and professionalism
- Do not add assumptions or new policies
"""

    response = llm.invoke(prompt)
    content = response.content or "No content generated"

    cursor.execute(
        """
        DELETE FROM document_sections
        WHERE document_id=%s AND section_order=%s
        """,
        (data.document_id, data.section_order)
    )

    cursor.execute(
        """
        INSERT INTO document_sections
        (document_id, section_title, section_content, section_order, is_completed)
        VALUES (%s,%s,%s,%s,TRUE)
        """,
        (data.document_id, section_title, content, data.section_order)
    )

    conn.commit()
    cursor.close()
    conn.close()

    return {"section": section_title, "content": content}