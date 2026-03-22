from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_product_detail_returns_full_data():
    resp = client.get("/api/v1/products/B09JB8KPNW")
    assert resp.status_code == 200
    data = resp.json()
    product = data["product"]
    assert product["asin"] == "B09JB8KPNW"
    assert product["title"]
    assert product["original_title"]
    assert product["price"] > 0
    assert "cnshophelper-20" in product["amazon_url"]
    assert "fetched_at" in data


def test_product_detail_has_highlights():
    resp = client.get("/api/v1/products/B09JB8KPNW")
    product = resp.json()["product"]
    assert len(product["highlights"]) > 0
    h = product["highlights"][0]
    assert "icon" in h
    assert "title" in h
    assert "subtitle" in h


def test_product_detail_has_features():
    resp = client.get("/api/v1/products/B09JB8KPNW")
    product = resp.json()["product"]
    assert len(product["features"]) > 0


def test_product_detail_has_image_urls():
    resp = client.get("/api/v1/products/B09JB8KPNW")
    product = resp.json()["product"]
    assert len(product["image_urls"]) >= 1


def test_product_detail_unknown_asin_returns_fallback():
    resp = client.get("/api/v1/products/B0UNKNOWNASIN")
    assert resp.status_code == 200
    product = resp.json()["product"]
    assert product["asin"] == "B0UNKNOWNASIN"


def test_batch_products():
    resp = client.post(
        "/api/v1/products/batch",
        json=["B09JB8KPNW", "B0CXKJM8X3"],
    )
    assert resp.status_code == 200
    data = resp.json()
    assert len(data["products"]) == 2
    asins = {p["asin"] for p in data["products"]}
    assert "B09JB8KPNW" in asins
    assert "B0CXKJM8X3" in asins


def test_batch_products_have_chinese_titles():
    resp = client.post(
        "/api/v1/products/batch",
        json=["B09JB8KPNW"],
    )
    product = resp.json()["products"][0]
    assert product["title"] != product["original_title"]
