import os
import re
import time
import logging
from fastapi import APIRouter, HTTPException
from notion_client import Client
from dotenv import load_dotenv
from backend.database import get_connection

load_dotenv()

router = APIRouter()
logger = logging.getLogger("docforge.notion")

notion = Client(auth=os.getenv("NOTION_TOKEN"))
DB_ID  = os.getenv("NOTION_DB_ID")


def chunk_blocks(blocks, size=100):
    for i in range(0, len(blocks), size):
        yield blocks[i:i + size]


def notion_create_with_retry(notion, **kwargs):
    for attempt in range(3):
        try:
            return notion.pages.create(**kwargs)
        except Exception as e:
            if "rate_limited" in str(e).lower() or "429" in str(e):
                wait = 2 ** attempt
                logger.warning(
                    f"Notion rate limited | "
                    f"attempt={attempt+1} | waiting={wait}s"
                )
                time.sleep(wait)
            else:
                raise e
    raise HTTPException(
        status_code=429,
        detail="Notion rate limit exceeded"
    )


def notion_append_with_retry(notion, block_id, children):
    for attempt in range(3):
        try:
            return notion.blocks.children.append(
                block_id=block_id,
                children=children
            )
        except Exception as e:
            if "rate_limited" in str(e).lower() or "429" in str(e):
                wait = 2 ** attempt
                logger.warning(
                    f"Notion append rate limited | "
                    f"attempt={attempt+1} | waiting={wait}s"
                )
                time.sleep(wait)
            else:
                raise e
    raise HTTPException(
        status_code=429,
        detail="Notion rate limit exceeded"
    )


def is_table_row(line: str) -> bool:
    """Check if line is a pipe table row"""
    stripped = line.strip()
    return stripped.startswith("|") and stripped.endswith("|")


def is_separator_row(line: str) -> bool:
    """Check if line is a table separator like |---|---|"""
    stripped = line.strip()
    if not stripped.startswith("|"):
        return False
    # Remove pipes and check if only dashes, colons, spaces remain
    inner = stripped.strip("|")
    cells = inner.split("|")
    return all(
        re.match(r'^[\s\-:]+$', cell)
        for cell in cells
        if cell.strip()
    )


def parse_table_cells(line: str) -> list:
    """Extract cell contents from pipe table row"""
    stripped = line.strip().strip("|")
    cells = [cell.strip() for cell in stripped.split("|")]
    return [cell for cell in cells if cell != ""]


def make_rich_text(text: str) -> list:
    """Create Notion rich_text array from plain text"""
    text = text[:1990] if len(text) > 1990 else text
    return [{"type": "text", "text": {"content": text}}]


def parse_inline_formatting(text: str) -> list:
    """
    Parse bold (**text**) and underline (__text__)
    into Notion rich_text annotations
    """
    rich_text = []
    # Pattern matches **bold** and __underline__
    pattern = r'(\*\*.*?\*\*|__.*?__)'
    parts = re.split(pattern, text)

    for part in parts:
        if not part:
            continue
        if part.startswith("**") and part.endswith("**"):
            content = part[2:-2]
            rich_text.append({
                "type": "text",
                "text": {"content": content[:1990]},
                "annotations": {"bold": True}
            })
        elif part.startswith("__") and part.endswith("__"):
            content = part[2:-2]
            rich_text.append({
                "type": "text",
                "text": {"content": content[:1990]},
                "annotations": {"underline": True}
            })
        else:
            if part:
                rich_text.append({
                    "type": "text",
                    "text": {"content": part[:1990]}
                })

    return rich_text if rich_text else make_rich_text(text)


def build_notion_table_block(table_rows: list) -> dict:
    """
    Convert list of table rows into Notion table block

    table_rows = [
        ["Aspect", "Description"],          ← header row
        ["Feature Based", "Code organized"],← data rows
        ...
    ]
    """
    if not table_rows:
        return None

    col_count = max(len(row) for row in table_rows)

    notion_rows = []
    for row in table_rows:
        # Pad row if fewer cells than max columns
        while len(row) < col_count:
            row.append("")

        cells = []
        for cell in row:
            cells.append(make_rich_text(cell))

        notion_rows.append({
            "type": "table_row",
            "table_row": {"cells": cells}
        })

    return {
        "object": "block",
        "type": "table",
        "table": {
            "table_width":      col_count,
            "has_column_header": True,   # First row = header
            "has_row_header":    False,
            "children":          notion_rows
        }
    }


def build_bullet_block(line: str) -> dict:
    """Convert bullet line to Notion bulleted list block"""
    # Remove bullet symbol
    content = line.strip()
    if content.startswith("•"):
        content = content[1:].strip()
    elif content.startswith("-"):
        content = content[1:].strip()

    return {
        "object": "block",
        "type":   "bulleted_list_item",
        "bulleted_list_item": {
            "rich_text": parse_inline_formatting(content)
        }
    }


def build_paragraph_block(line: str) -> dict:
    """Convert text line to Notion paragraph block"""
    return {
        "object": "block",
        "type":   "paragraph",
        "paragraph": {
            "rich_text": parse_inline_formatting(line[:1990])
        }
    }


def content_to_notion_blocks(content: str) -> list:
    """
    Convert section content string to list of Notion blocks.
    Handles:
    → Pipe tables → Notion table blocks
    → Bullet points → Notion bulleted list blocks
    → Bold/underline → Notion rich text annotations
    → Regular text → Notion paragraph blocks
    """
    blocks = []
    lines  = content.split("\n")

    i = 0
    while i < len(lines):
        line = lines[i]

        # Detect pipe table 
        if is_table_row(line) and not is_separator_row(line):
            table_rows  = []
            header_done = False

            while i < len(lines):
                current = lines[i]

                if is_separator_row(current):
                    # Skip separator row |---|---|
                    i += 1
                    header_done = True
                    continue

                if is_table_row(current):
                    cells = parse_table_cells(current)
                    if cells:
                        table_rows.append(cells)
                    i += 1
                else:
                    break

            if table_rows:
                table_block = build_notion_table_block(table_rows)
                if table_block:
                    blocks.append(table_block)
                    logger.debug(
                        f"Table block created | "
                        f"rows={len(table_rows)}"
                    )
            continue

        # Detect bullet points 
        stripped = line.strip()
        if stripped.startswith("•") or stripped.startswith("- "):
            blocks.append(build_bullet_block(stripped))
            i += 1
            continue

        # Regular paragraph 
        if stripped:
            blocks.append(build_paragraph_block(stripped))

        i += 1

    return blocks


@router.post("/push_to_notion")
def push_to_notion(document_id: str):
    logger.info(f"Notion publish started | doc={document_id}")

    conn   = get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            SELECT d.title, d.created_at, d.version,
                   dt.industry, dty.name, dep.name
            FROM documents d
            JOIN document_templates dt ON d.template_id = dt.id
            JOIN document_types dty ON dt.document_type_id = dty.id
            JOIN departments dep ON dt.department_id = dep.id
            WHERE d.id = %s
            """,
            (document_id,)
        )
        result = cursor.fetchone()
        if not result:
            logger.error(f"Document not found | doc={document_id}")
            raise HTTPException(
                status_code=404,
                detail="Document not found"
            )

        title      = result[0]
        created_at = result[1]
        version    = result[2] or "v1.0"
        industry   = result[3] or "SaaS"
        doc_type   = result[4]
        department = result[5]
        created_by = "DocForge"

        cursor.execute(
            """
            SELECT section_title, section_content
            FROM document_sections
            WHERE document_id=%s AND is_latest=TRUE
            ORDER BY section_order
            """,
            (document_id,)
        )
        sections = cursor.fetchall()
        if not sections:
            logger.error(f"No sections | doc={document_id}")
            raise HTTPException(
                status_code=400,
                detail="No sections to publish"
            )

        # Build all blocks 
        children = []
        for sec_title, sec_content in sections:

            # Section heading
            children.append({
                "object": "block",
                "type":   "heading_2",
                "heading_2": {
                    "rich_text": make_rich_text(sec_title)
                }
            })

            # Section content with smart block detection
            if sec_content:
                content_blocks = content_to_notion_blocks(sec_content)
                children.extend(content_blocks)
                logger.debug(
                    f"Section blocks built | "
                    f"section={sec_title} | "
                    f"blocks={len(content_blocks)}"
                )

        # Create Notion page
        response = notion_create_with_retry(
            notion,
            parent={"database_id": DB_ID},
            properties={
                "Name":       {"title":       [{"type": "text", "text": {"content": str(title)}}]},
                "Type":       {"select":      {"name": str(doc_type)}},
                "Industry":   {"select":      {"name": str(industry)}},
                "Version":    {"rich_text":   [{"type": "text", "text": {"content": str(version)}}]},
                "Tags":       {"multi_select": [{"name": str(department)}]},
                "Created_By": {"rich_text":   [{"type": "text", "text": {"content": created_by}}]},
                "Created_at": {"date":        {"start": str(created_at)}}
            }
        )

        page_id = response["id"]
        logger.info(
            f"Notion page created | "
            f"doc={document_id} | page_id={page_id}"
        )

        # Append blocks in chunks of 100 
        for block_chunk in chunk_blocks(children):
            notion_append_with_retry(
                notion,
                block_id=page_id,
                children=block_chunk
            )
            time.sleep(0.3)

        # Save page_id to DB
        cursor.execute(
            "UPDATE documents SET notion_page_id=%s WHERE id=%s",
            (page_id, document_id)
        )
        conn.commit()

        logger.info(
            f"Notion publish completed | "
            f"doc={document_id} | title={title}"
        )

        return {
            "message":        "Published to Notion",
            "notion_page_id": page_id,
            "title":          title,
            "type":           doc_type,
            "industry":       industry,
            "version":        version,
            "department":     department,
            "template_id":    document_id
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Notion publish failed | doc={document_id} | {e}")
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        conn.close()