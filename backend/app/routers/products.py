from datetime import datetime, timezone

from fastapi import APIRouter, HTTPException

from app.models.dtos import (
    BatchResponse,
    ProductDetailDTO,
    ProductDetailResponse,
    ProductHighlight,
    ProductSummaryDTO,
    ProductTag,
    TagStyle,
)

router = APIRouter(prefix="/api/v1", tags=["products"])

STUB_DETAIL = ProductDetailDTO(
    asin="B0EXAMPLE01",
    title="便携蓝牙音箱 防水户外",
    original_title="Portable Bluetooth Speaker Waterproof Outdoor",
    price=29.99,
    currency="USD",
    rating=4.5,
    review_count=12800,
    image_url="https://via.placeholder.com/300",
    image_urls=[
        "https://via.placeholder.com/600",
        "https://via.placeholder.com/600",
    ],
    source="Amazon",
    amazon_url="https://www.amazon.com/dp/B0EXAMPLE01?tag=cnshophelper-20",
    category_id="electronics",
    is_prime=True,
    tags=[ProductTag(label="热门", style=TagStyle.popular)],
    description="高品质便携蓝牙音箱，支持IPX7级防水，适合户外活动。"
    "电池续航可达12小时，支持TWS双音箱配对。",
    highlights=[
        ProductHighlight(
            icon="speaker.wave.3.fill",
            title="360度环绕立体声",
            subtitle="全方位高品质音效",
        ),
        ProductHighlight(
            icon="drop.fill",
            title="IPX7级防水",
            subtitle="水下1米可浸泡30分钟",
        ),
        ProductHighlight(
            icon="battery.100",
            title="12小时续航",
            subtitle="Type-C快速充电",
        ),
    ],
    warnings=["第三方卖家发货，非Amazon自营"],
    features=[
        "蓝牙5.3连接",
        "内置麦克风支持免提通话",
        "支持TF卡 / AUX输入",
        "重量仅380克，便于携带",
    ],
)


@router.get(
    "/products/{asin}",
    response_model=ProductDetailResponse,
)
async def get_product_detail(asin: str) -> ProductDetailResponse:
    """Get product detail by ASIN. Currently returns stub data."""
    if not asin.startswith("B0"):
        raise HTTPException(status_code=404, detail="Product not found")

    detail = STUB_DETAIL.model_copy(update={"asin": asin})
    return ProductDetailResponse(
        product=detail,
        fetched_at=datetime.now(timezone.utc),
    )


@router.post("/products/batch", response_model=BatchResponse)
async def get_products_batch(asins: list[str]) -> BatchResponse:
    """Batch fetch product summaries by ASINs. Currently returns stub data."""
    products = [
        ProductSummaryDTO(
            asin=asin,
            title=f"商品 {asin}",
            original_title=f"Product {asin}",
            price=19.99,
            currency="USD",
            rating=4.0,
            review_count=100,
            image_url="https://via.placeholder.com/300",
            source="Amazon",
            amazon_url=f"https://www.amazon.com/dp/{asin}?tag=cnshophelper-20",
        )
        for asin in asins[:50]
    ]
    return BatchResponse(
        products=products,
        fetched_at=datetime.now(timezone.utc),
    )
