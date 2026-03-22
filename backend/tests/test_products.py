from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_product_detail_stub():
    resp = client.get("/api/v1/products/B0EXAMPLE01")
    assert resp.status_code == 200
    data = resp.json()
    assert data["product"]["asin"] == "B0EXAMPLE01"
    assert "highlights" in data["product"]
    assert "fetched_at" in data


def test_product_detail_not_found():
    resp = client.get("/api/v1/products/INVALID_ASIN")
    assert resp.status_code == 404


def test_batch_products():
    resp = client.post(
        "/api/v1/products/batch",
        json=["B0EXAMPLE01", "B0EXAMPLE02"],
    )
    assert resp.status_code == 200
    data = resp.json()
    assert len(data["products"]) == 2
