"""Chinese-to-English query translation.

Phase 1: dictionary-based lookup.
Phase 6: will add LLM/API-backed translation as a fallback.
"""

import json
import re
from pathlib import Path

DATA_PATH = Path(__file__).resolve().parent.parent / "data" / "dictionary.json"

_dictionary: dict[str, str] | None = None


def _load_dictionary() -> dict[str, str]:
    global _dictionary
    if _dictionary is None:
        raw = json.loads(DATA_PATH.read_text(encoding="utf-8"))
        _dictionary = {k: v for k, v in raw.items()}
    return _dictionary


def _is_chinese(text: str) -> bool:
    return bool(re.search(r"[\u4e00-\u9fff]", text))


def translate_query(query: str) -> str:
    """Translate a Chinese query to English keywords.

    Strategy:
    1. If the entire query matches a dictionary entry, return that.
    2. Try longest-match greedy substitution for sub-phrases.
    3. If nothing matched, return the original query as-is
       (passthrough for English input or unknown terms).
    """
    query = query.strip()
    if not query or not _is_chinese(query):
        return query

    d = _load_dictionary()

    if query in d:
        return d[query]

    result_parts: list[str] = []
    remaining = query

    while remaining:
        matched = False
        for length in range(len(remaining), 0, -1):
            sub = remaining[:length]
            if sub in d:
                result_parts.append(d[sub])
                remaining = remaining[length:]
                matched = True
                break
        if not matched:
            result_parts.append(remaining[0])
            remaining = remaining[1:]

    translated = " ".join(result_parts)
    translated = re.sub(r"\s+", " ", translated).strip()
    return translated
