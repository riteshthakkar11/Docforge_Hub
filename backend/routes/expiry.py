from fastapi import APIRouter
from backend.database import get_connection
from datetime import datetime

router = APIRouter()


def calculate_expiry_status(expiry_date) -> str:
    if not expiry_date:
        return "active"
    days_left = (expiry_date - datetime.now()).days
    if days_left < 0:
        return "expired"
    elif days_left <= 30:
        return "expiring_soon"
    else:
        return "active"


def get_days_left(expiry_date) -> int:
    if not expiry_date:
        return 365
    return (expiry_date - datetime.now()).days


@router.get("/expiry/document/{document_id}")
def get_document_expiry(document_id: str):
    conn   = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT d.id, dt.name, d.created_at, d.expiry_date
        FROM documents d
        JOIN document_templates dt ON d.template_id = dt.id
        WHERE d.id = %s
        """,
        (document_id,)
    )
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    if not row:
        return {"error": "Document not found"}

    expiry_date = row[3]
    return {
        "document_id": document_id,
        "title":       row[1],
        "created_at":  row[2].strftime("%B %d, %Y") if row[2] else "",
        "expiry_date": expiry_date.strftime("%B %d, %Y") if expiry_date else "",
        "days_left":   get_days_left(expiry_date),
        "status":      calculate_expiry_status(expiry_date)
    }


@router.get("/expiry/alerts")
def get_expiry_alerts():
    conn   = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT
            d.id, dt.name, cc.company_name,
            d.created_at, d.expiry_date
        FROM documents d
        JOIN document_templates dt ON d.template_id = dt.id
        LEFT JOIN company_context cc ON d.company_id = cc.id
        WHERE d.expiry_date IS NOT NULL
        ORDER BY d.expiry_date ASC
        """
    )
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    expired       = []
    expiring_soon = []
    active        = []

    for row in rows:
        expiry_date = row[4]
        status      = calculate_expiry_status(expiry_date)
        days_left   = get_days_left(expiry_date)
        doc_info    = {
            "document_id":  str(row[0]),
            "title":        row[1],
            "company_name": row[2] or "—",
            "created_at":   row[3].strftime("%B %d, %Y") if row[3] else "",
            "expiry_date":  expiry_date.strftime("%B %d, %Y") if expiry_date else "",
            "days_left":    days_left,
            "status":       status
        }
        if status == "expired":
            expired.append(doc_info)
        elif status == "expiring_soon":
            expiring_soon.append(doc_info)
        else:
            active.append(doc_info)

    return {
        "expired":        expired,
        "expiring_soon":  expiring_soon,
        "active":         active,
        "total_expired":  len(expired),
        "total_expiring": len(expiring_soon),
        "total_active":   len(active)
    }


@router.post("/expiry/extend/{document_id}")
def extend_expiry(document_id: str, months: int = 12):
    conn   = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        """
        UPDATE documents
        SET expiry_date = expiry_date + INTERVAL '1 year'
        WHERE id = %s
        RETURNING expiry_date
        """,
        (document_id,)
    )
    row = cursor.fetchone()
    conn.commit()
    cursor.close()
    conn.close()
    return {
        "message":    f"Expiry extended by {months} months",
        "new_expiry": row[0].strftime("%B %d, %Y") if row else ""
    }