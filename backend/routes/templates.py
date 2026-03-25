from fastapi import APIRouter
from backend.database import get_connection
from backend.redis_client import cache_get, cache_set

router = APIRouter()

@router.get("/templates/{department_id}")
def get_templates(department_id: int):

    cache_key = f"templates_{department_id}"
    cached    = cache_get(cache_key)
    if cached:
        return {"templates": cached}

    conn   = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT id, name FROM document_templates WHERE department_id=%s",
        (department_id,)
    )
    data = cursor.fetchall()
    cursor.close()
    conn.close()

    # Cache for 1 hour
    cache_set(cache_key, data, ttl=3600)

    return {"templates": data}


@router.get("/sections/{template_id}")
def get_sections(template_id: int):

    cache_key = f"sections_{template_id}"
    cached    = cache_get(cache_key)
    if cached:
        return {"sections": cached}

    conn   = get_connection()
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

    # Cache for 1 hour
    cache_set(cache_key, data, ttl=3600)

    return {"sections": data}