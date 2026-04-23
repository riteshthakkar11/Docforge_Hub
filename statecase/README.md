# StateCase Assistant

> Stateful conversational AI assistant with persistent memory and automatic Notion ticket creation. Answers questions from the CiteRAG document library and raises structured support tickets when knowledge is missing.

---

## 1. What It Is

CiteRAG answers questions from documents. But what happens when a question cannot be answered because the knowledge simply does not exist in the library yet? StateCase solves this with an intelligent assistant that remembers conversation context and automatically creates a structured support ticket in Notion when it cannot find a confident answer.

The assistant uses a LangGraph state machine to decide in real time whether to ask for clarification, search the document library, return a cited answer, or create a ticket — all transparently and without the user needing to do anything extra. Every unanswered question becomes a ticket with full context, LLM-generated priority, and a professional summary attached.

---

## 2. Architecture

```
User (Streamlit UI)
       |
       v
FastAPI Backend (port 8002)
       |
       |---> LangGraph State Machine
       |       |---> Clarify Node  (detect vague questions)
       |       |---> Retrieve Node (call CiteRAG API at port 8001)
       |       |---> Answer Node   (format and return cited answer)
       |       |---> Ticket Node   (create Notion support ticket)
       |
       |---> Redis (short-term session memory, TTL 2 hours)
       |---> PostgreSQL (long-term conversation history, permanent)
       |---> Notion API (ticket creation and management)
       |---> CiteRAG API (document retrieval at port 8001)
```

- **LangGraph** orchestrates 4 nodes with intelligent routing between them based on state
- **Clarify node** uses LLM to detect if a question is too vague before searching
- **Retrieve node** calls CiteRAG `/answer` endpoint for grounded semantic retrieval
- **Answer node** returns the cited answer with confidence score to the user
- **Ticket node** generates a professional summary and creates a structured Notion ticket
- **Memory** is layered — Redis for speed and PostgreSQL for durability across restarts

---

## 3. Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Streamlit |
| Backend | FastAPI |
| State Machine | LangGraph |
| LLM | Azure OpenAI GPT-4.1 Mini |
| RAG Source | CiteRAG Lab (Project 2, port 8001) |
| Short-term Memory | Redis (TTL 2 hours) |
| Long-term Memory | PostgreSQL (permanent) |
| Ticketing | Notion API |
| Duplicate Prevention | Redis NX atomic lock |
| Validation | Pydantic |
| Python Version | 3.10 |

---

## 4. LangGraph State Machine

```
START
  |
  v
[CLARIFY NODE]
  Is the question clear enough to search?
  YES --> go to RETRIEVE
  NO  --> ask one focused clarifying question --> wait --> back to CLARIFY

[RETRIEVE NODE]
  Call CiteRAG /answer with user query + industry filter
  Evidence found? (confidence >= 0.60)
  YES --> go to ANSWER
  NO  --> go to TICKET

[ANSWER NODE]
  Format cited answer with source links
  Return to user with confidence score
  END

[TICKET NODE]
  Generate professional summary via LLM
  Auto-detect priority (High / Medium / Low)
  Create Notion ticket with full context
  Return ticket link to user
  END
```

---

## 5. Unique Features

| Feature | Description |
|---|---|
| LangGraph State Machine | 4-node intelligent flow with conditional routing |
| Smart Clarification | Only asks follow-up when question is genuinely too vague to search |
| Auto Ticket Creation | Notion ticket created automatically when no confident answer is found |
| LLM Priority Detection | GPT-4.1 Mini auto-detects ticket priority as High, Medium or Low |
| Duplicate Prevention | Redis NX atomic lock prevents the same ticket being created twice |
| Layered Memory | Redis for speed combined with PostgreSQL for permanent session storage |
| Ticket Analytics Dashboard | Priority distribution bar chart and 7-day ticket trend line chart |
| Dynamic Industry Filter | Available industries fetched live from CiteRAG — no hardcoded values |
| Sources Attempted | Every ticket shows which documents were searched before failing |
| Full Context in Ticket | Each Notion ticket includes the original question, sources tried and LLM summary |

---

## 6. Setup and Run

### Prerequisites

- Python 3.10+
- PostgreSQL running locally
- Redis running locally
- CiteRAG Lab running at port 8001 with documents already ingested
- Notion integration with a dedicated Tickets database

### Create Notion Tickets Database

1. Open Notion and create a new full-page table database named **StateCase Tickets**
2. Add the following properties to the table:

| Property Name | Type | Options |
|---|---|---|
| Name | Title | (default) |
| Status | Select | Open, In Progress, Resolved |
| Priority | Select | High, Medium, Low |
| Session ID | Text | — |
| Assigned Owner | Text | — |

3. Open the database, click the three-dot menu, select **Connect to** and add your Notion integration

### Environment variables

Add to your `.env` file in the project root:

```env
NOTION_TICKETS_DB_ID=your_tickets_database_id
STATECASE_API_URL=http://localhost:8002
```

### Database setup

```bash
psql -U postgres -d DocForge_Hub -h localhost \
  -f statecase/database/schema.sql
```

### Run the backend

```bash
PYTHONPATH=/path/to/DocForge_Hub \
  uvicorn statecase.backend.main:app --port 8002 --reload
```

### Run the frontend

```bash
PYTHONPATH=/path/to/DocForge_Hub \
  streamlit run statecase/frontend/app.py --server.port 8503
```

---

## 7. API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | /chat | Main LangGraph orchestration endpoint |
| POST | /tickets | Create a Notion support ticket |
| GET | /tickets | List all tickets (with optional session filter) |
| GET | /tickets/analytics | Ticket analytics — priority, status, daily trend |
| GET | /state/{session_id} | Get current session state |
| DELETE | /state/{session_id} | Reset a session |
| GET | /state/history/{session_id} | Full conversation history for a session |
| GET | /health | API health check |

---

## 8. Frontend Pages

| Page | URL | Description |
|---|---|---|
| Dashboard | localhost:8503 | Welcome page with how-it-works overview |
| Chat | localhost:8503/pages/chat | Conversational assistant with state badges |
| My Tickets | localhost:8503/pages/tickets | Ticket list, details and analytics dashboard |

---

## 9. Session Memory Model

| Layer | Storage | TTL | Contents |
|---|---|---|---|
| Short-term | Redis | 2 hours | Current state, last 6 messages, industry preference, last action |
| Long-term | PostgreSQL | Permanent | Full message history, all sessions, all tickets |

When Redis expires, session data is automatically reloaded from PostgreSQL on the next request.

---

## 10. Ticket Structure in Notion

Every auto-created ticket in Notion contains:

| Field | Value |
|---|---|
| Title | User's original question (truncated to 100 characters) |
| Status | Open (default on creation) |
| Priority | Auto-detected by LLM — High, Medium or Low |
| Session ID | Links ticket back to the original conversation |
| Assigned Owner | Support Team (configurable) |
| Question block | Full question text as page content |
| Sources Attempted block | Documents and sections searched before failing |
| Summary block | LLM-generated 2–3 sentence professional summary |

---

## 11. Limits and Next Steps

### Current limits

- Requires CiteRAG Lab running at port 8001 with documents ingested
- Session ID cannot be manually entered — new session generated on each browser open
- Notion ticket status updates must be done manually inside Notion
- No email or Slack notification when a ticket is created
- No user authentication — open access to all users

### Next steps

- Add Slack and email notification on ticket creation
- Allow users to update ticket status directly from the Streamlit UI
- Add Notion webhook to sync ticket status changes back into StateCase
- Support manual session ID entry so users can resume past conversations
- Add LangSmith tracing for full LangGraph node observability
- Add multi-turn conversation export as PDF for record keeping
