from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_search_returns_products_with_chinese_titles():
    resp = client.get("/api/v1/search", params={"q": "蓝牙音箱"})
    assert resp.status_code == 200
    data = resp.json()
    assert data["translated_query"] == "bluetooth speaker"
    assert len(data["products"]) > 0
    first = data["products"][0]
    assert first["asin"]
    assert first["title"]
    assert first["original_title"]
    assert first["price"] > 0
    assert first["amazon_url"]
    assert "cnshophelper-20" in first["amazon_url"]


def test_search_products_have_tags():
    resp = client.get("/api/v1/search", params={"q": "speaker"})
    data = resp.json()
    products_with_tags = [p for p in data["products"] if p["tags"]]
    assert len(products_with_tags) > 0


def test_search_with_category_filter():
    resp = client.get("/api/v1/search", params={"q": "home", "category": "home"})
    assert resp.status_code == 200
    data = resp.json()
    assert len(data["products"]) > 0
    for p in data["products"]:
        assert p["category_id"] == "home"


def test_search_empty_query_rejected():
    resp = client.get("/api/v1/search", params={"q": ""})
    assert resp.status_code == 422


def test_search_sort_price_asc():
    resp = client.get("/api/v1/search", params={"q": "test", "sort": "price_asc"})
    assert resp.status_code == 200
    prices = [p["price"] for p in resp.json()["products"]]
    assert prices == sorted(prices)


def test_search_sort_price_desc():
    resp = client.get("/api/v1/search", params={"q": "test", "sort": "price_desc"})
    assert resp.status_code == 200
    prices = [p["price"] for p in resp.json()["products"]]
    assert prices == sorted(prices, reverse=True)


def test_search_english_passthrough():
    resp = client.get("/api/v1/search", params={"q": "yoga mat"})
    assert resp.status_code == 200
    data = resp.json()
    assert data["translated_query"] == "yoga mat"
    assert len(data["products"]) > 0


def test_search_includes_fetched_at():
    resp = client.get("/api/v1/search", params={"q": "speaker"})
    data = resp.json()
    assert "fetched_at" in data


def test_search_on_sale_products():
    resp = client.get("/api/v1/search", params={"q": "all products"})
    data = resp.json()
    on_sale = [p for p in data["products"] if p["is_on_sale"]]
    assert len(on_sale) > 0
    for p in on_sale:
        assert p["original_price"] is not None
        assert p["original_price"] > p["price"]
