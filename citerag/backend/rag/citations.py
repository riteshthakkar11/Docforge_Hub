import logging

logger = logging.getLogger("citerag.citations")


def build_citations(chunks: list) -> list:
    """
    Build user-friendly citation list from chunks

    Deduplicates same doc+section combinations
    Adds ref_number for inline citation like [1] [2]
    Generates Notion URL for direct page access
    """
    citations = []
    seen      = set()

    for i, chunk in enumerate(chunks):
        doc_title      = chunk.get("doc_title", "Unknown Document")
        section_title  = chunk.get("section_title", "General")
        notion_page_id = chunk.get("notion_page_id", "")
        confidence     = chunk.get("confidence", 0.0)
        chunk_index    = chunk.get("chunk_index", 0)

        # Deduplicate same doc + section
        key = f"{doc_title}|{section_title}"
        if key in seen:
            continue
        seen.add(key)

        # Build Notion URL
        clean_id    = notion_page_id.replace("-", "")
        notion_url  = f"https://notion.so/{clean_id}"

        citations.append({
            "ref_number":     len(citations) + 1,
            "display":        f"{doc_title} → {section_title}",
            "doc_title":      doc_title,
            "section_title":  section_title,
            "notion_page_id": notion_page_id,
            "chunk_index":    chunk_index,
            "confidence":     confidence,
            "notion_url":     notion_url
        })

    logger.debug(f"Built {len(citations)} citations")
    return citations


def format_citations_for_prompt(citations: list) -> str:
    """
    Format citations as text for LLM prompt injection
    LLM uses this to add [1] [2] inline citations

    Example output:
    Sources:
    [1] Leave Policy Document → Section 3 (92.3% confidence)
    [2] HR Policy → Introduction (87.1% confidence)
    """
    if not citations:
        return ""

    lines = ["\nSources:"]
    for c in citations:
        lines.append(
            f"[{c['ref_number']}] {c['display']} "
            f"({c['confidence']}% confidence)"
        )
    return "\n".join(lines)


def get_avg_confidence(chunks: list) -> float:
    """Calculate average confidence across all chunks"""
    if not chunks:
        return 0.0
    return round(
        sum(c.get("confidence", 0) for c in chunks) / len(chunks),
        1
    )