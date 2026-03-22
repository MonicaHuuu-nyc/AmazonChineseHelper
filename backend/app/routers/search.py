from datetime import datetime, timezone

from fastapi import APIRouter, Query

from app.models.dtos import SearchResponse, SortOption
from app.services.amazon_client import AmazonClient, CATEGORY_NODE_MAP
from app.services.cache import cache
from app.services.product_mapper import map_search_item
from app.services.translation import translate_query

router = APIRouter(prefix="/api/v1", tags=["search"])

_client = AmazonClient()

SORT_MAP = {
    SortOption.smart: None,
    SortOption.price_asc: "Price:LowToHigh",
    SortOption.price_desc: "Price:HighToLow",
}


@router.get("/search", response_model=SearchResponse)
async def search_products(
    q: str = Query(min_length=1, max_length=200),
    sort: SortOption = SortOption.smart,
    page: int = Query(default=1, ge=1, le=10),
    category: str | None = None,
) -> SearchResponse:
    """Search products via Amazon upstream (mock in Phase 2, real in Phase 3)."""
    translated = translate_query(q)

    cache_key = f"search:{translated}:{sort.value}:{page}:{category or 'all'}"
    cached = await cache.get(cache_key)
    if cached is not None:
        return cached

    search_index = "All"
    if category and category in CATEGORY_NODE_MAP:
        search_index = category

    raw = await _client.search_items(
        translated,
        search_index=search_index,
        item_count=10,
        item_page=page,
        sort_by=SORT_MAP.get(sort),
    )

    raw_items = raw.get("SearchResult", {}).get("Items", [])
    total = raw.get("SearchResult", {}).get("TotalResultCount", 0)

    products = [map_search_item(item, _client.associate_tag) for item in raw_items]

    response = SearchResponse(
        products=products,
        total_estimate=total,
        translated_query=translated,
        fetched_at=datetime.now(timezone.utc),
    )

    await cache.set(cache_key, response, ttl=3600)
    return response
