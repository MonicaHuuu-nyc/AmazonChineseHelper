from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_search_returns_products():
    resp = client.get("/api/v1/search", params={"q": "蓝牙音箱"})
    assert resp.status_code == 200
    data = resp.json()
    assert "products" in data
    assert "translated_query" in data
    assert data["translated_query"] == "bluetooth speaker"
    assert len(data["products"]) > 0


def test_search_with_category_filter():
    resp = client.get("/api/v1/search", params={"q": "speaker", "category": "electronics"})
    assert resp.status_code == 200
    for p in resp.json()["products"]:
        assert p["category_id"] == "electronics"


def test_search_empty_query_rejected():
    resp = client.get("/api/v1/search", params={"q": ""})
    assert resp.status_code == 422


def test_search_sort_price_asc():
    resp = client.get("/api/v1/search", params={"q": "test", "sort": "price_asc"})
    assert resp.status_code == 200
    prices = [p["price"] for p in resp.json()["products"]]
    assert prices == sorted(prices)
