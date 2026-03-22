from datetime import datetime, timezone

from fastapi import APIRouter, Query

from app.models.dtos import (
    ProductSummaryDTO,
    ProductTag,
    SearchResponse,
    SortOption,
    TagStyle,
)
from app.services.translation import translate_query

router = APIRouter(prefix="/api/v1", tags=["search"])

STUB_PRODUCTS = [
    ProductSummaryDTO(
        asin="B0EXAMPLE01",
        title="便携蓝牙音箱 防水户外",
        original_title="Portable Bluetooth Speaker Waterproof Outdoor",
        price=29.99,
        currency="USD",
        rating=4.5,
        review_count=12800,
        image_url="https://via.placeholder.com/300",
        source="Amazon",
        amazon_url="https://www.amazon.com/dp/B0EXAMPLE01?tag=cnshophelper-20",
        category_id="electronics",
        is_prime=True,
        tags=[ProductTag(label="热门", style=TagStyle.popular)],
    ),
    ProductSummaryDTO(
        asin="B0EXAMPLE02",
        title="不锈钢保温杯 500ml",
        original_title="Stainless Steel Insulated Water Bottle 500ml",
        price=18.99,
        currency="USD",
        original_price=24.99,
        rating=4.7,
        review_count=34200,
        image_url="https://via.placeholder.com/300",
        source="Amazon",
        amazon_url="https://www.amazon.com/dp/B0EXAMPLE02?tag=cnshophelper-20",
        category_id="home",
        is_prime=True,
        is_on_sale=True,
        tags=[ProductTag(label="超值", style=TagStyle.value)],
    ),
    ProductSummaryDTO(
        asin="B0EXAMPLE03",
        title="无线降噪耳机 头戴式",
        original_title="Wireless Noise Cancelling Headphones Over-Ear",
        price=59.99,
        currency="USD",
        rating=4.3,
        review_count=8900,
        image_url="https://via.placeholder.com/300",
        source="Amazon",
        amazon_url="https://www.amazon.com/dp/B0EXAMPLE03?tag=cnshophelper-20",
        category_id="electronics",
        is_prime=True,
        tags=[ProductTag(label="科技", style=TagStyle.high_tech)],
    ),
]


@router.get("/search", response_model=SearchResponse)
async def search_products(
    q: str = Query(min_length=1, max_length=200),
    sort: SortOption = SortOption.smart,
    page: int = Query(default=1, ge=1, le=10),
    category: str | None = None,
) -> SearchResponse:
    """Search for products. Currently returns stub data (Phase 2 will add
    mock Amazon upstream; Phase 3 will wire real Creators API)."""
    translated = translate_query(q)

    results = STUB_PRODUCTS
    if category:
        results = [p for p in results if p.category_id == category]

    if sort == SortOption.price_asc:
        results = sorted(results, key=lambda p: p.price)
    elif sort == SortOption.price_desc:
        results = sorted(results, key=lambda p: p.price, reverse=True)

    return SearchResponse(
        products=results,
        total_estimate=len(results),
        translated_query=translated,
        fetched_at=datetime.now(timezone.utc),
    )
