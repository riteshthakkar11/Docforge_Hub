import json
from fastapi import APIRouter, HTTPException
from backend.database import get_connection
from backend.llm import llm

router = APIRouter()


@router.post("/generate_questions")
def generate_questions(template_id: int):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT name FROM document_templates WHERE id=%s",
        (template_id,)
    )
    result = cursor.fetchone()
    if not result:
        raise HTTPException(status_code=404, detail="Template not found")
    template_name = result[0]

    cursor.execute(
        """
        SELECT section_title, section_order
        FROM template_sections
        WHERE template_id=%s
        ORDER BY section_order
        """,
        (template_id,)
    )
    sections = cursor.fetchall()

    prompt = f"""
You are an enterprise SaaS documentation assistant.

Generate around 40-45 questions required to create the following document.

Document: {template_name}

Sections:
{sections}

IMPORTANT:
- Generate 2-3 questions PER SECTION
- Map each question to its section
- Total questions should be 40-45

Return ONLY JSON format:
{{
 "sections":[
  {{
   "section":"Overview",
   "questions":["question 1","question 2"]
  }}
 ]
}}

Only return JSON. No explanations.
"""

    response = llm.invoke(prompt)

    try:
        data = json.loads(response.content)
    except json.JSONDecodeError:
        raise HTTPException(status_code=500, detail="LLM returned invalid JSON. Try again.")

    cursor.execute(
        "DELETE FROM template_questions WHERE template_id = %s",
        (template_id,)
    )

    for sec in data["sections"]:
        section_title = sec["section"]
        cursor.execute(
            """
            SELECT section_order FROM template_sections
            WHERE template_id=%s AND section_title=%s
            """,
            (template_id, section_title)
        )
        result = cursor.fetchone()
        if not result:
            continue
        section_order = result[0]

        for i, q in enumerate(sec["questions"], start=1):
            cursor.execute(
                """
                INSERT INTO template_questions
                (template_id, section_title, question, section_order, question_order)
                VALUES (%s,%s,%s,%s,%s)
                """,
                (template_id, section_title, q, section_order, i)
            )

    conn.commit()
    cursor.close()
    conn.close()
    return {"message": "Questions generated and stored"}


@router.get("/next_questions")
def get_next_questions(document_id: str, section_order: int):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT template_id FROM documents WHERE id=%s",
        (document_id,)
    )
    result = cursor.fetchone()
    if not result:
        raise HTTPException(status_code=404, detail="Document not found")
    template_id = result[0]

    cursor.execute(
        """
        SELECT question FROM template_questions
        WHERE template_id=%s AND section_order=%s
        ORDER BY question_order
        """,
        (template_id, section_order)
    )
    questions = [row[0] for row in cursor.fetchall()]

    cursor.execute(
        """
        SELECT section_title FROM template_sections
        WHERE template_id=%s AND section_order=%s
        """,
        (template_id, section_order)
    )
    section = cursor.fetchone()

    cursor.close()
    conn.close()

    return {
        "section": section[0] if section else "",
        "questions": questions
    }