"""Lightweight cache abstraction.

Phase 1: in-memory dict with TTL (no Redis dependency required locally).
Phase 3: will swap to Redis via REDIS_URL.
"""

import time
from typing import Any


class MemoryCache:
    def __init__(self, default_ttl: int = 3600) -> None:
        self._store: dict[str, tuple[Any, float]] = {}
        self._default_ttl = default_ttl

    async def get(self, key: str) -> Any | None:
        entry = self._store.get(key)
        if entry is None:
            return None
        value, expires_at = entry
        if time.time() > expires_at:
            del self._store[key]
            return None
        return value

    async def set(self, key: str, value: Any, ttl: int | None = None) -> None:
        ttl = ttl or self._default_ttl
        self._store[key] = (value, time.time() + ttl)

    async def delete(self, key: str) -> None:
        self._store.pop(key, None)

    async def clear(self) -> None:
        self._store.clear()


cache = MemoryCache()
