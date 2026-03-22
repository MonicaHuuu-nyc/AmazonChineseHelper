import json
from pathlib import Path

from app.services.product_mapper import map_detail_item, map_search_item

FIXTURES = Path(__file__).resolve().parent / "fixtures"


def _load_fixture(name: str) -> dict:
    return json.loads((FIXTURES / name).read_text(encoding="utf-8"))


def test_map_search_item_basic_fields():
    data = _load_fixture("mock_search_response.json")
    raw = data["SearchResult"]["Items"][0]
    dto = map_search_item(raw, "cnshophelper-20")
    assert dto.asin == "B09JB8KPNW"
    assert dto.price == 179.95
    assert dto.currency == "USD"
    assert dto.source == "Amazon"
    assert "cnshophelper-20" in dto.amazon_url


def test_map_search_item_chinese_title():
    data = _load_fixture("mock_search_response.json")
    raw = data["SearchResult"]["Items"][0]
    dto = map_search_item(raw, "cnshophelper-20")
    assert dto.title != dto.original_title
    assert "JBL" in dto.title


def test_map_search_item_ratings():
    data = _load_fixture("mock_search_response.json")
    raw = data["SearchResult"]["Items"][0]
    dto = map_search_item(raw, "cnshophelper-20")
    assert dto.rating == 4.7
    assert dto.review_count == 58420


def test_map_search_item_on_sale():
    data = _load_fixture("mock_search_response.json")
    raw = data["SearchResult"]["Items"][0]
    dto = map_search_item(raw, "cnshophelper-20")
    assert dto.is_on_sale is True
    assert dto.original_price == 199.95


def test_map_search_item_tags():
    data = _load_fixture("mock_search_response.json")
    raw = data["SearchResult"]["Items"][0]
    dto = map_search_item(raw, "cnshophelper-20")
    assert len(dto.tags) > 0
    tag_labels = [t.label for t in dto.tags]
    assert any("热门" in l or "省" in l or "口碑" in l for l in tag_labels)


def test_map_search_item_category():
    data = _load_fixture("mock_search_response.json")
    raw = data["SearchResult"]["Items"][0]
    dto = map_search_item(raw, "cnshophelper-20")
    assert dto.category_id == "electronics"


def test_map_detail_item_has_highlights():
    data = _load_fixture("mock_detail_response.json")
    raw = data["ItemsResult"]["Items"][0]
    dto = map_detail_item(raw, "cnshophelper-20")
    assert len(dto.highlights) > 0
    assert dto.highlights[0].icon
    assert dto.highlights[0].title


def test_map_detail_item_has_features():
    data = _load_fixture("mock_detail_response.json")
    raw = data["ItemsResult"]["Items"][0]
    dto = map_detail_item(raw, "cnshophelper-20")
    assert len(dto.features) >= 3


def test_map_detail_item_has_image_urls():
    data = _load_fixture("mock_detail_response.json")
    raw = data["ItemsResult"]["Items"][0]
    dto = map_detail_item(raw, "cnshophelper-20")
    assert len(dto.image_urls) >= 2


def test_map_detail_item_has_description():
    data = _load_fixture("mock_detail_response.json")
    raw = data["ItemsResult"]["Items"][0]
    dto = map_detail_item(raw, "cnshophelper-20")
    assert len(dto.description) > 0
