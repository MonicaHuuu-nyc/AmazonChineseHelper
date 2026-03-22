from datetime import datetime, timezone

from fastapi import APIRouter, HTTPException

from app.models.dtos import BatchResponse, ProductDetailResponse
from app.services.amazon_client import AmazonClient
from app.services.cache import cache
from app.services.product_mapper import map_detail_item, map_search_item

router = APIRouter(prefix="/api/v1", tags=["products"])

_client = AmazonClient()


@router.get("/products/{asin}", response_model=ProductDetailResponse)
async def get_product_detail(asin: str) -> ProductDetailResponse:
    """Get full product detail by ASIN."""
    cache_key = f"product:{asin}"
    cached = await cache.get(cache_key)
    if cached is not None:
        return cached

    raw = await _client.get_items([asin])
    items = raw.get("ItemsResult", {}).get("Items", [])

    if not items:
        raise HTTPException(status_code=404, detail="Product not found")

    detail = map_detail_item(items[0], _client.associate_tag)
    response = ProductDetailResponse(
        product=detail,
        fetched_at=datetime.now(timezone.utc),
    )

    await cache.set(cache_key, response, ttl=3600)
    return response


@router.post("/products/batch", response_model=BatchResponse)
async def get_products_batch(asins: list[str]) -> BatchResponse:
    """Batch fetch product summaries by ASINs (max 50)."""
    trimmed = asins[:50]

    raw = await _client.get_items(trimmed)
    items = raw.get("ItemsResult", {}).get("Items", [])

    products = [map_search_item(item, _client.associate_tag) for item in items]

    return BatchResponse(
        products=products,
        fetched_at=datetime.now(timezone.utc),
    )
