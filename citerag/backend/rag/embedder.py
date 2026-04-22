import uuid
import logging
from qdrant_client import QdrantClient
from qdrant_client.models import (
    VectorParams,
    Distance,
    PointStruct,
    Filter,
    FieldCondition,
    MatchValue
)
from citerag.backend.llm import embeddings
from citerag.backend.constants import (
    QDRANT_HOST,
    QDRANT_PORT,
    QDRANT_COLLECTION,
    VECTOR_SIZE
)

logger = logging.getLogger("citerag.embedder")

# Qdrant client — connects to local Docker container
client = QdrantClient(
    host=QDRANT_HOST,
    port=QDRANT_PORT
)


def ensure_collection():
    """
    Create Qdrant collection if it doesn't exist
    Called once before any embedding operation
    """
    try:
        existing = [
            c.name
            for c in client.get_collections().collections
        ]
        if QDRANT_COLLECTION not in existing:
            client.create_collection(
                collection_name=QDRANT_COLLECTION,
                vectors_config=VectorParams(
                    size=VECTOR_SIZE,
                    distance=Distance.COSINE
                )
            )
            logger.info(f"Qdrant collection created: {QDRANT_COLLECTION}")
        else:
            logger.debug(f"Qdrant collection exists: {QDRANT_COLLECTION}")
    except Exception as e:
        logger.error(f"Ensure collection failed | {e}")
        raise


def embed_and_store(chunks: list) -> list:
    """
    Embed chunks and store in Qdrant
    Returns list of qdrant_ids for PostgreSQL storage

    Each point in Qdrant has:
    → id      = UUID (for reference)
    → vector  = 1536 float numbers
    → payload = all metadata for filtering + display
    """
    ensure_collection()

    points     = []
    qdrant_ids = []

    for chunk in chunks:
        try:
            # Convert text to vector
            vector    = embeddings.embed_query(chunk["chunk_text"])
            point_id  = str(uuid.uuid4())
            qdrant_ids.append(point_id)

            points.append(PointStruct(
                id=point_id,
                vector=vector,
                payload={
                    "notion_page_id": chunk["notion_page_id"],
                    "doc_title":      chunk["doc_title"],
                    "section_title":  chunk["section_title"],
                    "chunk_text":     chunk["chunk_text"],
                    "chunk_index":    chunk["chunk_index"],
                    "industry":       chunk["industry"],
                    "doc_type":       chunk["doc_type"],
                    "version":        chunk["version"],
                }
            ))
        except Exception as e:
            logger.error(f"Embed failed | chunk={chunk.get('chunk_index')} | {e}")
            continue

    if points:
        client.upsert(
            collection_name=QDRANT_COLLECTION,
            points=points
        )
        logger.info(f"Stored {len(points)} vectors in Qdrant")

    return qdrant_ids


def delete_page_vectors(notion_page_id: str):
    """
    Delete all vectors for a specific Notion page
    Used when force re-ingesting a document
    """
    try:
        client.delete(
            collection_name=QDRANT_COLLECTION,
            points_selector=Filter(
                must=[
                    FieldCondition(
                        key="notion_page_id",
                        match=MatchValue(value=notion_page_id)
                    )
                ]
            )
        )
        logger.info(f"Deleted vectors | page={notion_page_id}")
    except Exception as e:
        logger.error(f"Delete vectors failed | {e}")
        raise


def get_collection_stats() -> dict:
    """Get Qdrant collection statistics"""
    try:
        info = client.get_collection(QDRANT_COLLECTION)
        return {
            "total_vectors": info.points_count,
            "collection":    QDRANT_COLLECTION,
            "vector_size":   VECTOR_SIZE
        }
    except Exception as e:
        logger.error(f"Stats failed | {e}")
        return {"total_vectors": 0}