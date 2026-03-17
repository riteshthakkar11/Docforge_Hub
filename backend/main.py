from fastapi import FastAPI
import uuid

from streamlit import cursor
from backend.llm import llm
from backend.models import CompanyContext, SubmitAnswersRequest
from backend.database import get_connection

app=FastAPI()

# Testing Purpose
@app.get("/")
def home():
    return {"message":"DocForge API Running"}


# Get Departments
@app.get("/departments")

def get_departments():

    conn=get_connection()
    cursor=conn.cursor()

    cursor.execute("SELECT * FROM departments")

    data=cursor.fetchall()

    cursor.close()
    conn.close()

    return {"departments":data}

# Get Templates
@app.get("/templates/{department_id}")

def get_templates(department_id : int):

    conn=get_connection()
    cursor=conn.cursor()

    cursor.execute(
        "SELECT id,name FROM document_templates WHERE department_id=%s",
        (department_id,)
    )

    data=cursor.fetchall()

    cursor.close()
    conn.close()

    return {"templates":data}

# Get Sections
@app.get("/sections/{template_id}")

def get_sections(template_id: int):

     conn=get_connection()
     cursor=conn.cursor()

     cursor.execute(
         "SELECT section_title FROM template_sections WHERE template_id=%s ORDER BY section_order",
         (template_id,)
     )

     data=cursor.fetchall()

     cursor.close()
     conn.close()

     return {"sections": data}

# Company Context
@app.post("/company-context")
def save_company_context(data: CompanyContext):

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        """
        INSERT INTO company_context
        (company_name, company_location, company_size,
        company_stage, product_type, target_customers,
        company_mission, company_vision)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
        RETURNING id
        """,
        (
            data.company_name,
            data.company_location,
            data.company_size,
            data.company_stage,
            data.product_type,
            data.target_customers,
            data.company_mission,
            data.company_vision
        )
    )

    company_id = cursor.fetchone()[0]

    conn.commit()
    cursor.close()
    conn.close()

    return {"company_id": company_id}


# Create Document

@app.post("/create-document")

def create_document(template_id : int, company_id: int):

    conn=get_connection()
    cursor=conn.cursor()

    document_id=str(uuid.uuid4())

    cursor.execute(
        """
        INSERT INTO documents
        (id,template_id,company_id,title)
        VALUES (%s,%s,%s,%s)
        """,
        (
            document_id,
            template_id,
            company_id,
            "Generated Document"
        )
    )

    conn.commit()
    cursor.close()
    conn.close()

    return {"document_id": document_id}


# Generate Questions

@app.post("/generate_questions")

def generate_questions(template_id : int):

    conn=get_connection()
    cursor=conn.cursor()

    #Get Doc Name
    cursor.execute(
        " SELECT name FROM document_templates WHERE id=%s",
        (template_id,)
    )

    template_name=cursor.fetchone()[0]

    #Get Doc Section
    cursor.execute(
        """
        SELECT section_title
        FROM template_sections
        WHERE template_id=%s
        ORDER BY section_order
        """,
        (template_id,)
    )

    sections=[row[0] for row in cursor.fetchall()]

    cursor.close()
    conn.close()

    #Create Prompt

    prompt = f"""
You are an enterprise SaaS documentation assistant.

Generate around 24-25 questions required to create the following document.

Document: {template_name}

Sections:
{sections}

Return the output ONLY in JSON format like this:

{{
 "questions":[
  "question 1",
  "question 2",
  "question 3"
 ]
}}

Do not include explanations.
Only return JSON.
"""
    response=llm.invoke(prompt)

    return {
        "document": template_name,
        "questions": response.content
    }


# Submit Answers

@app.post("/submit_answers")
def submit_answers(data: SubmitAnswersRequest):

    conn=get_connection()
    cursor=conn.cursor()

    for item in data.answers:
        cursor.execute(
            """
            INSERT INTO question_answers (document_id, questions, answer)
            VALUES (%s,%s,%s)
            """,
            (
                str(data.document_id),
                item.question,
                item.answer
            )
        )
    conn.commit()
    cursor.close()
    conn.close()

    return {"message":"Answers saved successfully"}


# Generate Document
@app.post("/generate_document")
def generate_document(document_id: str):

    conn = get_connection()
    cursor=conn.cursor()

    # Delete Old sections
    cursor.execute(
        "DELETE FROM document_sections WHERE document_id=%s",
        (document_id,)
    )
    
    # Get template id
    cursor.execute(
        " SELECT template_id, company_id FROM documents WHERE id=%s",
        (document_id,)
    )
    doc = cursor.fetchone()

    template_id = doc[0]
    company_id = doc[1]

    
    # Get sections
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

    # Get answers
    cursor.execute(
        """
        SELECT questions,answer FROM question_answers
        WHERE document_id=%s
        """,
        (document_id,)
    )
    answers = cursor.fetchall()

    answers_text = "\n".join([f"{q}: {a}" for q,a in answers])

    generated_sections = []

    for section_title, section_order in sections:

        prompt = f"""
You are an Enterprise SaaS Documentation assistant.

User Answers : 
{answers_text}

Generate Professional Content for this section:

Section : {section_title}
"""
        response = llm.invoke(prompt)

        content = response.content

        cursor.execute(
            """
            INSERT INTO document_sections
            (document_id, section_title, section_content, section_order)
            VALUES (%s,%s,%s,%s)
            """,
            (document_id, section_title, content, section_order)
        )

        generated_sections.append(section_title)

    conn.commit()
    cursor.close()
    conn.close()

    return {
        "message" : "Document is Generated",
        "sections_created" : len(generated_sections)
    }


# Full Document

@app.get("/document/{document_id}")
def get_document(document_id: str):

    conn=get_connection()
    cursor=conn.cursor()


    # Get Document Title

    cursor.execute(
        """
        SELECT title
        FROM documents
        WHERE id=%s
        """,
        (document_id,)
    )

    doc=cursor.fetchone()

    if not doc:
        return {"Error": "Sorry, Document Not Found!"}
    
    title = doc[0]


    # Get document sections

    cursor.execute(
        """
        SELECT section_title, section_content, section_order
        FROM document_sections
        WHERE document_id = %s
        ORDER BY section_order
        """,
        (document_id,)
    )

    rows=cursor.fetchall()

    sections = []

    for row in rows:
        sections.append({
            "section_title" : row[0],
            "content" : row[1],
            "order" : row[2]
        })

    cursor.close()
    conn.close()

    return {
        "document_id" : document_id,
        "title" : title,
        "sections" : sections
    }
