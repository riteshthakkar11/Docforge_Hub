from pydantic import BaseModel
from typing import List
from uuid import UUID

class CompanyContext(BaseModel):
    company_name: str
    company_location: str
    company_size: str
    company_stage: str
    product_type: str
    target_customers: str
    company_mission: str
    company_vision: str

class AnswerItem(BaseModel):
    question: str
    answer: str

class SubmitAnswersRequest(BaseModel):
    document_id: UUID
    answers: List[AnswerItem]