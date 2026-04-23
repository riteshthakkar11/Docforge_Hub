# CiteRAG Lab

> RAG-powered document intelligence platform. Ask questions about your enterprise Notion document library and get grounded answers with citations, confidence scores and source links — without hallucination.

---

## 1. What It Is

After generating documents with DocForge Hub, enterprises need a way to query and extract knowledge from those documents instantly. CiteRAG Lab solves this by ingesting all Notion documents into a vector database and enabling semantic search with grounded Q&A.

Every answer includes citations showing the exact document and section it came from, a confidence score, and a direct Notion link. When evidence is insufficient, the system explicitly says so instead of hallucinating — a critical feature for enterprise use. The platform also includes a Knowledge Gap Report to reveal what is missing from the document library, and a RAGAS evaluation dashboard to measure RAG quality objectively.

---

## 2. Architecture

```
User (Streamlit UI)
       |
       v
FastAPI Backend (port 8001)
       |
       |---> Notion API (fetch documents and pages)
       |---> Azure OpenAI Embeddings (text-embedding-3-large, 3072 dims)
       |---> Qdrant (vector storage and semantic search)
       |---> Azure OpenAI GPT-4.1 Mini (answer generation)
       |---> Redis (retrieval cache, session memory, rate limiting)
       |---> PostgreSQL (chunk metadata, sessions, eval runs)
```

- **Chunker** reads Notion pages, splits content into 500-char chunks with stable citation metadata
- **Embedder** converts chunks to 3072-dim vectors using text-embedding-3-large and stores in Qdrant
- **Retriever** converts user query to vector, finds top-5 similar chunks via cosine similarity
- **Answer** generates grounded response using only retrieved chunks with no hallucination
- **Anti-hallucination guard** returns a clear insufficient-information message when confidence is below 0.60

---

## 3. Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Streamlit |
| Backend | FastAPI |
| Vector Database | Qdrant v1.17.1 |
| Embeddings | Azure OpenAI text-embedding-3-large (3072 dims) |
| LLM | Azure OpenAI GPT-4.1 Mini |
| RAG Framework | LangChain |
| Cache and Rate Limiting | Redis |
| Knowledge Base Source | Notion API (notion-client 3.0.0) |
| Evaluation Framework | RAGAS |
| Database | PostgreSQL |
| Validation | Pydantic |
| Python Version | 3.10 |

---

## 4. Unique Features

| Feature | Description |
|---|---|
| Confidence Score | Every retrieved chunk shows a 0–100% confidence score |
| Anti-Hallucination Guard | Returns "I don't know" when average chunk confidence is below 60% |
| Retrieval Inspector | See exactly which chunks and sections were used for any answer |
| Document Comparison | Side-by-side semantic comparison of two documents on any query |
| Query Refinement Tool | Improve vague or broad queries using natural language feedback |
| Knowledge Gap Report | Identifies questions that could not be answered — reveals missing documents |
| Document Health Score | Coverage analysis showing chunk density and section count per document |
| RAGAS Evaluation | Batch evaluation with faithfulness, answer relevancy and context precision scores |
| Metadata Filters | Filter retrieval by industry, document type or version |
| Session Memory | Follow-up questions retain context within the same conversation session |

---

## 5. Setup and Run

### Prerequisites

- Python 3.10+
- PostgreSQL running locally
- Redis running locally
- Qdrant running via Docker
- Azure OpenAI account with embedding and chat deployments
- Notion integration token with access to your document database

### Start Qdrant

```bash
sudo docker run -p 6333:6333 -p 6334:6334 qdrant/qdrant
```

### Environment variables

Add to your `.env` file in the project root:

```env
# Azure Embeddings
AZURE_OPENAI_EMB_KEY=your_embedding_key
AZURE_EMB_ENDPOINT=https://your-endpoint.openai.azure.com/
AZURE_EMB_API_VERSION=2024-12-01-preview
AZURE_EMBEDDINGS_DEPLOYMENT=text-embedding-3-large

# CiteRAG
CITERAG_API_URL=http://localhost:8001
```

### Database setup

```bash
psql -U postgres -d DocForge_Hub -h localhost \
  -f citerag/database/schema.sql
```

### Run the backend

```bash
PYTHONPATH=/path/to/DocForge_Hub \
  uvicorn citerag.backend.main:app --port 8001 --reload
```

### Run the frontend

```bash
PYTHONPATH=/path/to/DocForge_Hub \
  streamlit run citerag/frontend/app.py --server.port 8502
```

### Ingest Notion documents

```bash
curl -X POST "http://localhost:8001/ingest" \
  -H "Content-Type: application/json" \
  -d '{"database_id": "your_notion_db_id", "force_reingest": false}'
```

---

## 6. API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | /ingest | Ingest Notion documents into Qdrant |
| GET | /ingest/status | Get ingestion status and chunk count |
| POST | /retrieve | Semantic search with optional metadata filters |
| GET | /retrieve/filters | Get available filter values from ingested docs |
| GET | /docs/health | Document health scores and coverage analysis |
| POST | /answer | Grounded Q&A with citations and confidence |
| POST | /tools/search | Smart semantic search tool |
| POST | /tools/refine | Query refinement using feedback |
| POST | /tools/compare | Side-by-side document comparison |
| POST | /evaluate | Run RAGAS evaluation on a batch of questions |
| GET | /evaluate/history | Retrieve past evaluation run results |
| GET | /knowledge-gaps | Questions with low confidence — knowledge gap report |
| GET | /health | API health check |

---

## 7. Frontend Pages

| Page | URL | Description |
|---|---|---|
| Dashboard | localhost:8502 | Stats, ingestion control, knowledge gap report, document health score |
| Q&A Chat | localhost:8502/pages/chat | Ask questions and get cited answers with confidence scores |
| Retrieval Inspector | localhost:8502/pages/inspector | Inspect retrieved chunks, metadata and document comparison |
| RAGAS Evaluation | localhost:8502/pages/evaluation | Run and compare evaluation batches with quality metrics |

---

## 8. How It Works

### Ingestion flow

1. Fetch all pages from Notion database using search API
2. Extract block content and split into 500-character chunks
3. Each chunk retains stable citation info (page ID and section title)
4. Convert chunks to 3072-dim vectors via Azure text-embedding-3-large
5. Store vectors and metadata payload in Qdrant collection
6. Save chunk metadata to PostgreSQL for filter queries

### Query flow

1. Convert user question to 3072-dim vector via Azure embeddings
2. Search Qdrant for top-5 most similar chunks using cosine similarity
3. Check evidence strength — calculate average confidence across chunks
4. If confidence below 0.60 — return anti-hallucination message
5. Build context string from retrieved chunks with section labels
6. Generate grounded answer via GPT-4.1 Mini using only the context
7. Build user-friendly citations with Notion deep links
8. Cache result in Redis for 1 hour to reduce latency on repeat queries

---

## 9. Limits and Next Steps

### Current limits

- Ingestion is one-way — Notion edits after ingestion require re-ingestion to reflect changes
- Qdrant vector data is lost on container restart without a Docker volume mount
- English only — no multi-language semantic search support
- No user authentication — open access to all users

### Next steps

- Add Docker volume mount to persist Qdrant data across restarts
- Add incremental ingestion — only re-ingest pages modified after last ingest
- Add a reranking layer (cross-encoder) for improved retrieval precision
- Support multi-language embeddings for non-English document libraries
- Add LangSmith tracing for full RAG pipeline observability
- Support PDF and DOCX file ingestion in addition to Notion
