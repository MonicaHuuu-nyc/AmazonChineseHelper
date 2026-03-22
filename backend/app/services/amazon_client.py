"""Thin wrapper around the Amazon Creators API.

Phase 2: returns rich mock fixture data with keyword filtering.
Phase 3: will call the real Creators API via python-amazon-paapi.
"""

import json
from pathlib import Path

from app.config import settings

FIXTURES_DIR = Path(__file__).resolve().parent.parent.parent / "tests" / "fixtures"

_mock_search_data: dict | None = None
_mock_detail_data: dict | None = None

CATEGORY_NODE_MAP = {
    "electronics": "172282",
    "home": "1055398",
    "beauty": "3760911",
    "toys": "165793011",
    "clothing": "7141123011",
    "baby": "165796011",
    "sports": "3375251",
    "food": "16310101",
    "pets": "2619533011",
    "office": "1064954",
}


def _load_mock_search() -> dict:
    global _mock_search_data
    if _mock_search_data is None:
        path = FIXTURES_DIR / "mock_search_response.json"
        _mock_search_data = json.loads(path.read_text(encoding="utf-8"))
    return _mock_search_data


def _load_mock_detail() -> dict:
    global _mock_detail_data
    if _mock_detail_data is None:
        path = FIXTURES_DIR / "mock_detail_response.json"
        _mock_detail_data = json.loads(path.read_text(encoding="utf-8"))
    return _mock_detail_data


class AmazonClient:
    def __init__(self) -> None:
        self._credential_id = settings.amazon_credential_id
        self._credential_secret = settings.amazon_credential_secret
        self._associate_tag = settings.amazon_associate_tag
        self._country = settings.amazon_country
        self._mock = settings.amazon_mock

    @property
    def associate_tag(self) -> str:
        return self._associate_tag

    async def search_items(
        self,
        keywords: str,
        *,
        search_index: str = "All",
        item_count: int = 10,
        item_page: int = 1,
        sort_by: str | None = None,
    ) -> dict:
        """Search Amazon by keyword. Returns raw API-shaped dict."""
        if self._mock:
            return self._mock_search(
                keywords,
                search_index=search_index,
                item_count=item_count,
                item_page=item_page,
                sort_by=sort_by,
            )

        raise NotImplementedError("Real API not wired yet — coming in Phase 3")

    async def get_items(self, asins: list[str]) -> dict:
        """Fetch item details by ASINs. Returns raw API-shaped dict."""
        if self._mock:
            return self._mock_get_items(asins)

        raise NotImplementedError("Real API not wired yet — coming in Phase 3")

    # ------------------------------------------------------------------
    # Mock implementations
    # ------------------------------------------------------------------

    def _mock_search(
        self,
        keywords: str,
        *,
        search_index: str,
        item_count: int,
        item_page: int,
        sort_by: str | None,
    ) -> dict:
        data = _load_mock_search()
        all_items: list[dict] = data.get("SearchResult", {}).get("Items", [])

        filtered = all_items
        kw_lower = keywords.lower()

        if search_index != "All":
            node_id = CATEGORY_NODE_MAP.get(search_index, search_index)
            filtered = [
                item for item in filtered
                if self._item_matches_node(item, node_id)
            ]

        if kw_lower:
            scored = []
            for item in filtered:
                score = self._keyword_score(item, kw_lower)
                if score > 0:
                    scored.append((score, item))
            if scored:
                scored.sort(key=lambda x: x[0], reverse=True)
                filtered = [item for _, item in scored]

        if sort_by == "Price:LowToHigh":
            filtered.sort(key=lambda i: self._get_price(i))
        elif sort_by == "Price:HighToLow":
            filtered.sort(key=lambda i: self._get_price(i), reverse=True)

        start = (item_page - 1) * item_count
        page_items = filtered[start : start + item_count]

        return {
            "SearchResult": {
                "TotalResultCount": len(filtered),
                "Items": page_items,
            }
        }

    def _mock_get_items(self, asins: list[str]) -> dict:
        data = _load_mock_search()
        all_items: list[dict] = data.get("SearchResult", {}).get("Items", [])

        detail_data = _load_mock_detail()
        detail_items: list[dict] = detail_data.get("ItemsResult", {}).get("Items", [])

        index: dict[str, dict] = {}
        for item in all_items:
            index[item["ASIN"]] = item
        for item in detail_items:
            index[item["ASIN"]] = item

        matched = [index[asin] for asin in asins if asin in index]

        if not matched:
            template = detail_items[0] if detail_items else (all_items[0] if all_items else {})
            for asin in asins:
                stub = json.loads(json.dumps(template))
                stub["ASIN"] = asin
                if "DetailPageURL" in stub:
                    stub["DetailPageURL"] = f"https://www.amazon.com/dp/{asin}"
                matched.append(stub)

        return {"ItemsResult": {"Items": matched}}

    @staticmethod
    def _item_matches_node(item: dict, node_id: str) -> bool:
        nodes = item.get("BrowseNodeInfo", {}).get("BrowseNodes", [])
        return any(str(n.get("Id")) == node_id for n in nodes)

    @staticmethod
    def _keyword_score(item: dict, keywords_lower: str) -> int:
        title = (
            item.get("ItemInfo", {})
            .get("Title", {})
            .get("DisplayValue", "")
            .lower()
        )
        features_raw = (
            item.get("ItemInfo", {})
            .get("Features", {})
            .get("DisplayValues", [])
        )
        features = " ".join(features_raw).lower()
        category = (
            item.get("BrowseNodeInfo", {})
            .get("BrowseNodes", [{}])[0]
            .get("DisplayName", "")
            .lower()
        )

        terms = keywords_lower.split()
        score = 0
        for term in terms:
            if term in title:
                score += 3
            if term in features:
                score += 1
            if term in category:
                score += 2
        return score

    @staticmethod
    def _get_price(item: dict) -> float:
        return (
            item.get("Offers", {})
            .get("Listings", [{}])[0]
            .get("Price", {})
            .get("Amount", 0.0)
        )
