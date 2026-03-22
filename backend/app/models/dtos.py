from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Shared enums
# ---------------------------------------------------------------------------

class SortOption(str, Enum):
    smart = "smart"
    price_asc = "price_asc"
    price_desc = "price_desc"


class TagStyle(str, Enum):
    popular = "popular"
    premium = "premium"
    high_tech = "high_tech"
    value = "value"
    bundle = "bundle"
    kids = "kids"
    basic = "basic"


# ---------------------------------------------------------------------------
# Nested structures
# ---------------------------------------------------------------------------

class ProductTag(BaseModel):
    label: str
    style: TagStyle


class ProductHighlight(BaseModel):
    icon: str
    title: str
    subtitle: str


# ---------------------------------------------------------------------------
# Product DTOs
# ---------------------------------------------------------------------------

class ProductSummaryDTO(BaseModel):
    asin: str
    title: str
    original_title: str
    price: float
    currency: str = "USD"
    original_price: float | None = None
    rating: float = 0.0
    review_count: int = 0
    image_url: str = ""
    source: str = ""
    amazon_url: str = ""
    category_id: str = ""
    is_prime: bool = False
    is_on_sale: bool = False
    tags: list[ProductTag] = Field(default_factory=list)


class ProductDetailDTO(ProductSummaryDTO):
    image_urls: list[str] = Field(default_factory=list)
    description: str = ""
    highlights: list[ProductHighlight] = Field(default_factory=list)
    warnings: list[str] = Field(default_factory=list)
    features: list[str] = Field(default_factory=list)


# ---------------------------------------------------------------------------
# Request models
# ---------------------------------------------------------------------------

class SearchRequest(BaseModel):
    query: str = Field(min_length=1, max_length=200)
    sort: SortOption = SortOption.smart
    page: int = Field(default=1, ge=1, le=10)
    category: str | None = None


class BatchRequest(BaseModel):
    asins: list[str] = Field(min_length=1, max_length=50)


# ---------------------------------------------------------------------------
# Response models
# ---------------------------------------------------------------------------

class SearchResponse(BaseModel):
    products: list[ProductSummaryDTO]
    total_estimate: int = 0
    translated_query: str = ""
    fetched_at: datetime


class ProductDetailResponse(BaseModel):
    product: ProductDetailDTO
    fetched_at: datetime


class BatchResponse(BaseModel):
    products: list[ProductSummaryDTO]
    fetched_at: datetime


class CategoryDTO(BaseModel):
    id: str
    name: str
    icon: str
    browse_node_id: str = ""


class CategoriesResponse(BaseModel):
    categories: list[CategoryDTO]


class HealthResponse(BaseModel):
    status: str = "ok"
    version: str = "1.0.0"


class ErrorResponse(BaseModel):
    error: str
    message: str
