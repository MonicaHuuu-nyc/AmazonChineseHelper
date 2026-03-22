import json
from pathlib import Path

from fastapi import APIRouter

from app.models.dtos import CategoriesResponse, CategoryDTO

router = APIRouter(prefix="/api/v1", tags=["categories"])

DATA_PATH = Path(__file__).resolve().parent.parent / "data" / "categories.json"


def _load_categories() -> list[CategoryDTO]:
    raw = json.loads(DATA_PATH.read_text(encoding="utf-8"))
    return [CategoryDTO(**c) for c in raw]


@router.get("/categories", response_model=CategoriesResponse)
async def list_categories() -> CategoriesResponse:
    """Return the curated set of product categories."""
    return CategoriesResponse(categories=_load_categories())
