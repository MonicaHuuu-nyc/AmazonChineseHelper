"""Maps raw Amazon API responses to app DTOs.

Phase 1: stub — not called yet (routers use inline stub data).
Phase 3: will parse real Creators API response shapes.
"""

from app.models.dtos import ProductDetailDTO, ProductSummaryDTO


def map_search_item(raw_item: dict, associate_tag: str) -> ProductSummaryDTO:
    """Convert a single raw Amazon search-result item to a ProductSummaryDTO."""
    asin = raw_item.get("ASIN", "")
    title = raw_item.get("ItemInfo", {}).get("Title", {}).get("DisplayValue", "")
    price_info = (
        raw_item.get("Offers", {})
        .get("Listings", [{}])[0]
        .get("Price", {})
    )
    price = price_info.get("Amount", 0.0)
    currency = price_info.get("Currency", "USD")
    image = (
        raw_item.get("Images", {})
        .get("Primary", {})
        .get("Large", {})
        .get("URL", "")
    )

    return ProductSummaryDTO(
        asin=asin,
        title=title,
        original_title=title,
        price=price,
        currency=currency,
        image_url=image,
        source="Amazon",
        amazon_url=f"https://www.amazon.com/dp/{asin}?tag={associate_tag}",
    )


def map_detail_item(raw_item: dict, associate_tag: str) -> ProductDetailDTO:
    """Convert a raw Amazon item to a ProductDetailDTO."""
    summary = map_search_item(raw_item, associate_tag)
    features = (
        raw_item.get("ItemInfo", {})
        .get("Features", {})
        .get("DisplayValues", [])
    )

    return ProductDetailDTO(
        **summary.model_dump(),
        features=features,
    )
