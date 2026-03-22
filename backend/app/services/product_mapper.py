"""Maps raw Amazon API responses to app DTOs.

Phase 2: full mapping with Chinese title generation, tag inference,
highlight extraction, and warning detection from mock data.
Phase 3: same logic applied to real Creators API responses.
"""

import json
import re
from pathlib import Path

from app.models.dtos import (
    ProductDetailDTO,
    ProductHighlight,
    ProductSummaryDTO,
    ProductTag,
    TagStyle,
)

_TITLE_MAP: dict[str, str] | None = None
_TITLE_MAP_PATH = Path(__file__).resolve().parent.parent / "data" / "title_translations.json"

BROWSE_NODE_TO_CATEGORY = {
    "172282": "electronics",
    "1055398": "home",
    "3760911": "beauty",
    "165793011": "toys",
    "7141123011": "clothing",
    "165796011": "baby",
    "3375251": "sports",
    "16310101": "food",
    "2619533011": "pets",
    "1064954": "office",
}

FEATURE_ICON_MAP = [
    (r"waterproof|water.?proof|IP\d+", "drop.fill", "防水设计"),
    (r"battery|hour.+playtime|hour.+battery|charge", "battery.100", "持久续航"),
    (r"noise cancel", "ear.fill", "降噪功能"),
    (r"bluetooth|wireless", "antenna.radiowaves.left.and.right", "无线连接"),
    (r"vitamins?|nutrients?|health", "heart.fill", "健康营养"),
    (r"stainless steel|insulated|vacuum", "thermometer.snowflake", "保温设计"),
    (r"dishwasher.safe|easy.clean", "sparkles", "易清洁"),
    (r"organic|natural|non.toxic", "leaf.fill", "天然成分"),
    (r"microphone|hands?.free|calling", "mic.fill", "内置麦克风"),
    (r"usb.c|fast.charg", "bolt.fill", "快速充电"),
    (r"lightweight|portable|compact", "scalemass.fill", "轻便携带"),
    (r"recycled|eco|sustainable", "globe.americas.fill", "环保材质"),
]

WARNING_PATTERNS = [
    (r"third.party|3rd.party", "第三方卖家发货，请注意查看退换货政策"),
    (r"not sold by amazon", "非Amazon自营商品"),
    (r"imported|international", "可能为进口商品，请确认兼容性"),
    (r"requires? (subscription|membership)", "需要订阅服务"),
]


def _load_title_map() -> dict[str, str]:
    global _TITLE_MAP
    if _TITLE_MAP is None:
        if _TITLE_MAP_PATH.exists():
            _TITLE_MAP = json.loads(_TITLE_MAP_PATH.read_text(encoding="utf-8"))
        else:
            _TITLE_MAP = {}
    return _TITLE_MAP


def _generate_chinese_title(english_title: str, asin: str) -> str:
    """Generate a Chinese title from the English title.

    Priority: pre-mapped title > keyword-based construction > English passthrough.
    """
    title_map = _load_title_map()
    if asin in title_map:
        return title_map[asin]

    title_lower = english_title.lower()
    parts: list[str] = []

    brand_keywords = {
        "jbl": "JBL", "sony": "索尼", "apple": "苹果", "airpods": "AirPods",
        "samsung": "三星", "bose": "Bose", "anker": "安克", "stanley": "Stanley",
        "ninja": "Ninja", "lego": "乐高", "cerave": "CeraVe", "pampers": "帮宝适",
        "manduka": "Manduka", "hanes": "Hanes", "iams": "IAMS",
        "nature made": "Nature Made",
    }
    for eng, cn in brand_keywords.items():
        if eng in title_lower:
            parts.append(cn)
            break

    product_keywords = {
        "bluetooth speaker": "蓝牙音箱", "headphones": "头戴式耳机",
        "earbuds": "无线耳机", "airpods": "无线耳机", "tumbler": "保温杯",
        "water bottle": "保温杯", "air fryer": "空气炸锅",
        "moisturizing cream": "保湿面霜", "moisturizer": "保湿乳液",
        "brick box": "经典积木套装", "building": "积木",
        "sweatshirt": "卫衣", "pullover": "套头衫", "fleece": "抓绒",
        "diapers": "纸尿裤", "yoga mat": "瑜伽垫",
        "multivitamin": "复合维生素", "dog food": "狗粮", "cat food": "猫粮",
        "phone case": "手机壳", "charger": "充电器", "laptop": "笔记本电脑",
        "keyboard": "键盘", "mouse": "鼠标", "vacuum": "吸尘器",
        "rice cooker": "电饭煲", "pillow": "枕头",
    }
    for eng, cn in product_keywords.items():
        if eng in title_lower:
            parts.append(cn)
            break

    attribute_keywords = {
        "portable": "便携", "wireless": "无线", "waterproof": "防水",
        "noise cancel": "降噪", "stainless steel": "不锈钢",
        "insulated": "保温", "organic": "有机",
    }
    for eng, cn in attribute_keywords.items():
        if eng in title_lower:
            parts.append(cn)

    if parts:
        return " ".join(parts)
    return english_title


def _infer_tags(item: dict, price: float, original_price: float | None, rating: float, review_count: int) -> list[ProductTag]:
    tags: list[ProductTag] = []

    if original_price and original_price > price:
        discount = round((1 - price / original_price) * 100)
        if discount >= 10:
            tags.append(ProductTag(label=f"省{discount}%", style=TagStyle.value))

    if review_count >= 50000:
        tags.append(ProductTag(label="热门", style=TagStyle.popular))
    elif review_count >= 10000:
        tags.append(ProductTag(label="好评如潮", style=TagStyle.popular))

    if rating >= 4.7:
        tags.append(ProductTag(label="口碑优秀", style=TagStyle.premium))

    title = item.get("ItemInfo", {}).get("Title", {}).get("DisplayValue", "").lower()
    if any(kw in title for kw in ("kid", "children", "baby", "toddler")):
        tags.append(ProductTag(label="亲子", style=TagStyle.kids))

    return tags[:3]


def _extract_highlights(item: dict) -> list[ProductHighlight]:
    features = (
        item.get("ItemInfo", {})
        .get("Features", {})
        .get("DisplayValues", [])
    )
    all_text = " ".join(features)
    highlights: list[ProductHighlight] = []

    for pattern, icon, cn_label in FEATURE_ICON_MAP:
        match = re.search(pattern, all_text, re.IGNORECASE)
        if match:
            matched_feature = ""
            for f in features:
                if re.search(pattern, f, re.IGNORECASE):
                    matched_feature = f
                    break
            highlights.append(ProductHighlight(
                icon=icon,
                title=cn_label,
                subtitle=matched_feature[:60] if matched_feature else "",
            ))
        if len(highlights) >= 4:
            break

    return highlights


def _detect_warnings(item: dict) -> list[str]:
    merchant = (
        item.get("Offers", {})
        .get("Listings", [{}])[0]
        .get("MerchantInfo", {})
        .get("Name", "")
    )
    warnings: list[str] = []
    if merchant and merchant.lower() not in ("amazon.com", "amazon"):
        warnings.append(f"由 {merchant} 销售发货，非Amazon自营")

    title = item.get("ItemInfo", {}).get("Title", {}).get("DisplayValue", "")
    features = " ".join(
        item.get("ItemInfo", {}).get("Features", {}).get("DisplayValues", [])
    )
    combined = f"{title} {features}"

    for pattern, warning_cn in WARNING_PATTERNS:
        if re.search(pattern, combined, re.IGNORECASE):
            warnings.append(warning_cn)

    return warnings


def _extract_category_id(item: dict) -> str:
    nodes = item.get("BrowseNodeInfo", {}).get("BrowseNodes", [])
    for node in nodes:
        node_id = str(node.get("Id", ""))
        if node_id in BROWSE_NODE_TO_CATEGORY:
            return BROWSE_NODE_TO_CATEGORY[node_id]
    return ""


def _get_price_info(item: dict) -> tuple[float, str, float | None, bool]:
    listing = item.get("Offers", {}).get("Listings", [{}])[0]
    price_data = listing.get("Price", {})
    price = price_data.get("Amount", 0.0)
    currency = price_data.get("Currency", "USD")

    saving_basis = listing.get("SavingBasis", {})
    original_price = saving_basis.get("Amount") if saving_basis else None

    is_prime = listing.get("DeliveryInfo", {}).get("IsPrimeEligible", False)
    return price, currency, original_price, is_prime


def map_search_item(raw_item: dict, associate_tag: str) -> ProductSummaryDTO:
    """Convert a single raw Amazon search-result item to a ProductSummaryDTO."""
    asin = raw_item.get("ASIN", "")
    original_title = raw_item.get("ItemInfo", {}).get("Title", {}).get("DisplayValue", "")
    price, currency, original_price, is_prime = _get_price_info(raw_item)

    reviews = raw_item.get("CustomerReviews", {})
    rating = reviews.get("StarRating", {}).get("Value", 0.0)
    review_count = reviews.get("Count", 0)

    image = (
        raw_item.get("Images", {})
        .get("Primary", {})
        .get("Large", {})
        .get("URL", "")
    )

    chinese_title = _generate_chinese_title(original_title, asin)
    category_id = _extract_category_id(raw_item)
    is_on_sale = original_price is not None and original_price > price
    tags = _infer_tags(raw_item, price, original_price, rating, review_count)

    return ProductSummaryDTO(
        asin=asin,
        title=chinese_title,
        original_title=original_title,
        price=price,
        currency=currency,
        original_price=original_price,
        rating=rating,
        review_count=review_count,
        image_url=image,
        source="Amazon",
        amazon_url=f"https://www.amazon.com/dp/{asin}?tag={associate_tag}",
        category_id=category_id,
        is_prime=is_prime,
        is_on_sale=is_on_sale,
        tags=tags,
    )


def map_detail_item(raw_item: dict, associate_tag: str) -> ProductDetailDTO:
    """Convert a raw Amazon item to a ProductDetailDTO with full detail."""
    summary = map_search_item(raw_item, associate_tag)

    image_urls = [summary.image_url] if summary.image_url else []
    variants = raw_item.get("Images", {}).get("Variants", [])
    for v in variants:
        url = v.get("Large", {}).get("URL", "")
        if url:
            image_urls.append(url)

    features = (
        raw_item.get("ItemInfo", {})
        .get("Features", {})
        .get("DisplayValues", [])
    )

    highlights = _extract_highlights(raw_item)
    warnings = _detect_warnings(raw_item)

    description_parts = [summary.title]
    if features:
        description_parts.append("。".join(features[:2]))
    description = "。".join(description_parts)

    return ProductDetailDTO(
        **summary.model_dump(),
        image_urls=image_urls,
        description=description,
        highlights=highlights,
        warnings=warnings,
        features=features,
    )
