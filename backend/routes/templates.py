from fastapi import APIRouter
from backend.database import get_connection

router = APIRouter()

@router.get("/templates/{department_id}")
def get_templates(department_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT id, name FROM document_templates WHERE department_id=%s",
        (department_id,)
    )
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return {"templates": data}


@router.get("/sections/{template_id}")
def get_sections(template_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT section_title, section_order
        FROM template_sections
        WHERE template_id=%s
        ORDER BY section_order
        """,
        (template_id,)
    )
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return {"sections": data}