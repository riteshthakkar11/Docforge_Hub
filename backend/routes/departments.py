from fastapi import APIRouter
from backend.database import get_connection
from backend.redis_client import cache_get, cache_set

router = APIRouter()

@router.get("/departments")
def get_departments():

    # Check cache first 
    cached = cache_get("departments")
    if cached:
        return {"departments": cached}

    conn   = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM departments")
    data = cursor.fetchall()
    cursor.close()
    conn.close()

    # Cache for 1 hour (departments never change)
    cache_set("departments", data, ttl=3600)

    return {"departments": data}