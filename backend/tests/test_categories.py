from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_categories_returns_list():
    resp = client.get("/api/v1/categories")
    assert resp.status_code == 200
    data = resp.json()
    assert "categories" in data
    assert len(data["categories"]) >= 6


def test_category_has_required_fields():
    resp = client.get("/api/v1/categories")
    cat = resp.json()["categories"][0]
    assert "id" in cat
    assert "name" in cat
    assert "icon" in cat
