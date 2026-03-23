from fastapi import APIRouter
from backend.database import get_connection

router = APIRouter()

@router.get("/departments")
def get_departments():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM departments")
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return {"departments": data}