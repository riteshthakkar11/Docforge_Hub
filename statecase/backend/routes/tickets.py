import os
import json
import time
import logging
from fastapi import APIRouter, HTTPException
from notion_client import Client
from dotenv import load_dotenv
from statecase.backend.models.ticket_models import (
    TicketRequest,
    TicketResponse
)
from statecase.backend.redis_client import set_ticket_lock
from statecase.backend.database import get_connection, release_connection

load_dotenv()
router = APIRouter()
logger = logging.getLogger("statecase.tickets")

notion        = Client(auth=os.getenv("NOTION_TOKEN"))
TICKETS_DB_ID = os.getenv("NOTION_TICKETS_DB_ID")


@router.post("/tickets", response_model=TicketResponse)
def create_ticket(data: TicketRequest):
    if not set_ticket_lock(data.question):
        logger.warning(
            f"Duplicate ticket prevented | "
            f"session={data.session_id}"
        )
        raise HTTPException(
            status_code=409,
            detail="Ticket already created for this question recently."
        )

    try:
        notion_page = None

        for attempt in range(3):
            try:
                notion_page = notion.pages.create(
                    parent={"database_id": TICKETS_DB_ID},
                    properties={
                        "Name": {
                            "title": [{"text": {"content": data.question[:100]}}]
                        },
                        "Status":   {"select": {"name": "Open"}},
                        "Priority": {"select": {"name": data.priority}},
                        "Session ID": {
                            "rich_text": [{"text": {"content": data.session_id}}]
                        },
                        "Assigned Owner": {
                            "rich_text": [{"text": {"content": data.assigned_owner}}]
                        },
                    },
                    children=[
                        {
                            "object": "block",
                            "type":   "heading_2",
                            "heading_2": {
                                "rich_text": [{"text": {"content": "Question"}}]
                            }
                        },
                        {
                            "object": "block",
                            "type":   "paragraph",
                            "paragraph": {
                                "rich_text": [{"text": {"content": data.question}}]
                            }
                        },
                        {
                            "object": "block",
                            "type":   "heading_2",
                            "heading_2": {
                                "rich_text": [{"text": {"content": "Sources Attempted"}}]
                            }
                        },
                        {
                            "object": "block",
                            "type":   "paragraph",
                            "paragraph": {
                                "rich_text": [{"text": {"content": (
                                    ", ".join(data.sources_tried)
                                    if data.sources_tried
                                    else "No matching sources found"
                                )}}]
                            }
                        },
                        {
                            "object": "block",
                            "type":   "heading_2",
                            "heading_2": {
                                "rich_text": [{"text": {"content": "Summary"}}]
                            }
                        },
                        {
                            "object": "block",
                            "type":   "paragraph",
                            "paragraph": {
                                "rich_text": [{"text": {"content": data.summary}}]
                            }
                        },
                    ]
                )
                logger.info(f"Notion page created on attempt {attempt + 1}")
                break

            except Exception as e:
                if attempt < 2:
                    wait_time = 2 ** attempt
                    logger.warning(
                        f"Notion attempt {attempt + 1} failed | "
                        f"retrying in {wait_time}s | {e}"
                    )
                    time.sleep(wait_time)
                else:
                    logger.error(f"Notion failed after 3 attempts | {e}")
                    raise HTTPException(
                        status_code=500,
                        detail=f"Notion API failed: {str(e)}"
                    )

        if not notion_page:
            raise HTTPException(
                status_code=500,
                detail="Failed to create Notion page"
            )

        notion_ticket_id = notion_page["id"]
        notion_url = (
            f"https://notion.so/"
            f"{notion_ticket_id.replace('-', '')}"
        )

        conn   = get_connection()
        cursor = conn.cursor()
        try:
            cursor.execute(
                """
                INSERT INTO sc_tickets
                (session_id, notion_ticket_id, question,
                 attempted_sources, summary, priority,
                 status, assigned_owner)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
                """,
                (
                    data.session_id,
                    notion_ticket_id,
                    data.question,
                    json.dumps(data.sources_tried),
                    data.summary,
                    data.priority,
                    "Open",
                    data.assigned_owner
                )
            )
            conn.commit()
            logger.info(f"Ticket saved to DB | notion_id={notion_ticket_id}")
        finally:
            cursor.close()
            release_connection(conn)

        logger.info(
            f"Ticket created | "
            f"notion_id={notion_ticket_id} | "
            f"priority={data.priority}"
        )

        return TicketResponse(
            status="created",
            notion_ticket_id=notion_ticket_id,
            notion_url=notion_url,
            priority=data.priority
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Ticket creation failed | {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/tickets")
def get_tickets(session_id: str = None):
    conn   = get_connection()
    cursor = conn.cursor()
    try:
        if session_id:
            cursor.execute(
                """
                SELECT id, notion_ticket_id, question,
                       priority, status, assigned_owner,
                       created_at
                FROM sc_tickets
                WHERE session_id=%s
                ORDER BY created_at DESC
                """,
                (session_id,)
            )
        else:
            cursor.execute(
                """
                SELECT id, notion_ticket_id, question,
                       priority, status, assigned_owner,
                       created_at
                FROM sc_tickets
                ORDER BY created_at DESC
                LIMIT 50
                """
            )
        rows = cursor.fetchall()
        return [
            {
                "id":               r[0],
                "notion_ticket_id": r[1],
                "question":         r[2],
                "priority":         r[3],
                "status":           r[4],
                "assigned_owner":   r[5],
                "created_at":       str(r[6]),
                "notion_url": (
                    f"https://notion.so/{r[1].replace('-','')}"
                    if r[1] else None
                )
            }
            for r in rows
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        release_connection(conn)


@router.get("/tickets/analytics")
def get_ticket_analytics():
    """
    Ticket analytics dashboard data
    Unique feature: priority trends + daily chart!
    """
    conn   = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT priority, COUNT(*) FROM sc_tickets GROUP BY priority"
        )
        priority_dist = {r[0]: r[1] for r in cursor.fetchall()}

        cursor.execute(
            "SELECT status, COUNT(*) FROM sc_tickets GROUP BY status"
        )
        status_dist = {r[0]: r[1] for r in cursor.fetchall()}

        cursor.execute(
            """
            SELECT DATE(created_at) as date, COUNT(*) as count
            FROM sc_tickets
            WHERE created_at >= NOW() - INTERVAL '7 days'
            GROUP BY DATE(created_at)
            ORDER BY date ASC
            """
        )
        daily = [
            {"date": str(r[0]), "count": r[1]}
            for r in cursor.fetchall()
        ]

        cursor.execute("SELECT COUNT(*) FROM sc_tickets")
        total = cursor.fetchone()[0]

        cursor.execute(
            "SELECT COUNT(*) FROM sc_tickets WHERE status='Open'"
        )
        open_count = cursor.fetchone()[0]

        return {
            "total_tickets":          total,
            "open_tickets":           open_count,
            "priority_distribution":  priority_dist,
            "status_distribution":    status_dist,
            "daily_tickets":          daily
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        release_connection(conn)