import html
import re
from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse
from backend.database import get_connection
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib import colors
from reportlab.lib.units import inch


router = APIRouter()

@router.get("/download/pdf/{document_id}")
def download_pdf(document_id: str):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT dt.name FROM documents d
        JOIN document_templates dt ON d.template_id = dt.id
        WHERE d.id=%s
        """,
        (document_id,)
    )
    result = cursor.fetchone()
    if not result:
        raise HTTPException(status_code=404, detail="Document not found")
    title = result[0]

    cursor.execute(
        """
        SELECT DISTINCT ON (section_order)
            section_title, section_content, section_order
        FROM document_sections
        WHERE document_id=%s
        ORDER BY section_order, id DESC
        """,
        (document_id,)
    )
    sections = cursor.fetchall()
    if not sections:
        raise HTTPException(status_code=404, detail="No content found")

    cursor.close()
    conn.close()

    file_name = title.lower().replace(" ", "_") + ".pdf"
    file_path = f"/tmp/{file_name}"

    doc = SimpleDocTemplate(
        file_path,
        rightMargin=60,
        leftMargin=60,
        topMargin=60,
        bottomMargin=60
    )

    styles     = getSampleStyleSheet()
    story      = []

    # ── Custom styles ──
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Heading1'],
        fontSize=22,
        fontName='Helvetica-Bold',
        textColor=colors.HexColor('#1a1a3a'),
        alignment=TA_CENTER,
        spaceAfter=6
    )
    section_style = ParagraphStyle(
        'SectionTitle',
        parent=styles['Heading2'],
        fontSize=14,
        fontName='Helvetica-Bold',
        textColor=colors.HexColor('#7F77DD'),
        spaceBefore=16,
        spaceAfter=6
    )
    body_style = ParagraphStyle(
        'Body',
        parent=styles['Normal'],
        fontSize=11,
        fontName='Helvetica',
        textColor=colors.HexColor('#2a2a4a'),
        leading=18,
        spaceAfter=6
    )
    table_header_style = ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontSize=10,
        fontName='Helvetica-Bold',
        textColor=colors.white
    )
    table_cell_style = ParagraphStyle(
        'TableCell',
        parent=styles['Normal'],
        fontSize=10,
        fontName='Helvetica',
        textColor=colors.HexColor('#2a2a4a')
    )

    # ── Document title ──
    story.append(Spacer(1, 20))
    story.append(Paragraph(html.escape(title), title_style))
    story.append(Spacer(1, 4))
    story.append(HRFlowable(
        width="100%",
        thickness=2,
        color=colors.HexColor('#7F77DD')
    ))
    story.append(Spacer(1, 16))

    def parse_table(lines):
        """Parse markdown table lines into list of rows"""
        rows = []
        for line in lines:
            line = line.strip()
            if not line or re.match(r'\|[-:\s|]+\|', line):
                continue
            if line.startswith('|') and line.endswith('|'):
                cells = [c.strip() for c in line.strip('|').split('|')]
                # Clean markdown from each cell
                cleaned_cells = []
                for cell in cells:
                    cell = re.sub(r'\*{1,3}(.*?)\*{1,3}', r'\1', cell)
                    cell = re.sub(r'_{1,3}(.*?)_{1,3}', r'\1', cell)
                    cell = re.sub(r'#{1,6}\s*', '', cell)
                    cell = cell.strip()
                    cleaned_cells.append(cell)
                rows.append(cleaned_cells)
        return rows

    def build_pdf_table(rows):
        """Build a ReportLab table from rows"""
        if not rows:
            return None

        # Clean cell text
        pdf_rows = []
        for i, row in enumerate(rows):
            pdf_row = []
            for cell in row:
                style = table_header_style if i == 0 else table_cell_style
                pdf_row.append(Paragraph(html.escape(str(cell)), style))
            pdf_rows.append(pdf_row)

        col_count = max(len(r) for r in pdf_rows)
        col_width  = (doc.width) / col_count

        t = Table(pdf_rows, colWidths=[col_width] * col_count)
        t.setStyle(TableStyle([
            # Header row
            ('BACKGROUND',  (0, 0), (-1, 0),  colors.HexColor('#7F77DD')),
            ('TEXTCOLOR',   (0, 0), (-1, 0),  colors.white),
            ('FONTNAME',    (0, 0), (-1, 0),  'Helvetica-Bold'),
            ('FONTSIZE',    (0, 0), (-1, 0),  10),
            # Data rows
            ('BACKGROUND',  (0, 1), (-1, -1), colors.HexColor('#f5f5ff')),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1),
             [colors.HexColor('#f5f5ff'), colors.white]),
            # Grid
            ('GRID',        (0, 0), (-1, -1), 0.5, colors.HexColor('#c0c0d8')),
            ('LINEBELOW',   (0, 0), (-1, 0),  1.5, colors.HexColor('#534AB7')),
            # Padding
            ('TOPPADDING',  (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING',(0, 0), (-1, -1), 8),
            ('LEFTPADDING', (0, 0), (-1, -1), 10),
            ('RIGHTPADDING',(0, 0), (-1, -1), 10),
            # Align
            ('VALIGN',      (0, 0), (-1, -1), 'MIDDLE'),
        ]))
        return t

    # ── Process sections ──
    for row in sections:
        sec_title   = row[0] or "Untitled Section"
        sec_content = row[1] or "No content available"

        # Section heading
        story.append(Paragraph(html.escape(sec_title), section_style))
        story.append(HRFlowable(
            width="100%",
            thickness=0.5,
            color=colors.HexColor('#e0e0f0')
        ))
        story.append(Spacer(1, 8))

        # Process content line by line
        lines     = sec_content.split('\n')
        i         = 0
        table_buf = []

        while i < len(lines):
            line = lines[i]

            # Detect table start
            if line.strip().startswith('|') and line.strip().endswith('|'):
                table_buf.append(line)
                i += 1
                while i < len(lines) and lines[i].strip().startswith('|'):
                    table_buf.append(lines[i])
                    i += 1
                # Build table
                table_rows = parse_table(table_buf)
                if table_rows:
                    pdf_table = build_pdf_table(table_rows)
                    if pdf_table:
                        story.append(Spacer(1, 8))
                        story.append(pdf_table)
                        story.append(Spacer(1, 12))
                table_buf = []
                continue

            # Regular text line
            clean_line = line.strip()
            # Remove all markdown
            clean_line = re.sub(r'#{1,6}\s*', '', clean_line)
            clean_line = re.sub(r'\*{1,3}(.*?)\*{1,3}', r'\1', clean_line)
            clean_line = re.sub(r'_{1,3}(.*?)_{1,3}', r'\1', clean_line)
            clean_line = re.sub(r'`{1,3}(.*?)`{1,3}', r'\1', clean_line)
            clean_line = clean_line.strip()

            if clean_line:
                safe = html.escape(clean_line)
                story.append(Paragraph(safe, body_style))

            i += 1

        story.append(Spacer(1, 12))

    doc.build(story)

    return FileResponse(
        path=file_path,
        filename=file_name,
        media_type="application/pdf"
    )


@router.get("/download/docx/{document_id}")
def download_docx(document_id: str):
    conn = get_connection()
    cursor = conn.cursor()

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

    doc = Document()
    for row in sections:
        sec_title = row[0] or "Untitled Section"
        sec_text  = row[1] or "No content available"
        sec_text  = sec_text.replace("###", "")

        lines = sec_text.split("\n")
        if lines and lines[0].strip().lower() == sec_title.lower():
            lines = lines[1:]
        sec_text = "\n".join(lines).strip()

        doc.add_heading(sec_title, level=1)
        doc.add_paragraph("")
        for line in sec_text.split("\n"):
            if line.strip():
                doc.add_paragraph(line)

    file_path = f"/tmp/{document_id}.docx"
    doc.save(file_path)

    cursor.close()
    conn.close()

    return FileResponse(
        path=file_path,
        filename=f"{document_id}.docx",
        media_type="application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    )