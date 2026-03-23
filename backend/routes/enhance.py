from fastapi import APIRouter, HTTPException
from backend.database import get_connection
from backend.llm import llm

router = APIRouter()

ACTION_MAP = {
    "Longer": "Make the content more detailed and comprehensive",
    "Shorter": "Make the content shorter and to the point",
    "Formal": "Make the tone more formal and professional",
    "Concise": "Make the content concise without losing meaning",
    "Examples": "Add relevant examples",
    "Table": "Add structured table if applicable",
    "Clarity": "Improve clarity and readability",
    "Grammar": "Fix grammar and improve sentence structure"
}


@router.post("/enhance_section")
def enhance_section(data: dict):
    conn = get_connection()
    cursor = conn.cursor()

    document_id        = data.get("document_id")
    section_order      = data.get("section_order")
    action             = data.get("action")
    custom_instruction = data.get("custom_instruction", "")

    if not document_id:
        raise HTTPException(status_code=400, detail="document_id required")

    instruction = ACTION_MAP.get(action, "")

    if section_order is not None:
        cursor.execute(
            """
            SELECT section_title, section_content
            FROM document_sections
            WHERE document_id=%s AND section_order=%s
            """,
            (document_id, section_order)
        )
        section = cursor.fetchone()
        if not section:
            cursor.close()
            conn.close()
            raise HTTPException(status_code=404, detail="Section not found")

        section_title, content = section

        prompt = f"""
You are an expert AI document editor.

Section: {section_title}
Content: {content}

Instruction: {instruction}
{custom_instruction}

Rules:
- Keep meaning same
- Improve quality only
- Do not add fake policies
- Return improved content only.
"""
        response = llm.invoke(prompt)
        cursor.close()
        conn.close()
        return {
            "section": section_title,
            "enhanced_content": response.content
        }

    else:
        cursor.execute(
            """
            SELECT section_title, section_content
            FROM document_sections
            WHERE document_id=%s
            ORDER BY section_order
            """,
            (document_id,)
        )
        sections = cursor.fetchall()
        if not sections:
            cursor.close()
            conn.close()
            raise HTTPException(status_code=404, detail="Document empty")

        full_text = "\n\n".join([f"{s[0]}:\n{s[1]}" for s in sections])

        prompt = f"""
You are an expert document editor.
Improve the full document.

Instruction: {instruction}
{custom_instruction}

Document: {full_text}

Return only improved document.
"""
        response = llm.invoke(prompt)
        cursor.close()
        conn.close()
        return {"enhanced_document": response.content}


@router.post("/save_enhanced_section")
def save_enhanced_section(data: dict):
    conn = get_connection()
    cursor = conn.cursor()

    document_id   = data.get("document_id")
    section_order = data.get("section_order")
    content       = data.get("content")

    cursor.execute(
        """
        UPDATE document_sections
        SET section_content=%s
        WHERE document_id=%s AND section_order=%s
        """,
        (content, document_id, section_order)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return {"message": "Section updated successfully"}