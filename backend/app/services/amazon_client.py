"""Thin wrapper around the Amazon Creators API.

Phase 1: stub that returns empty results.
Phase 3: will call the real Creators API via python-amazon-paapi.
"""

from app.config import settings


class AmazonClient:
    def __init__(self) -> None:
        self._credential_id = settings.amazon_credential_id
        self._credential_secret = settings.amazon_credential_secret
        self._associate_tag = settings.amazon_associate_tag
        self._country = settings.amazon_country
        self._mock = settings.amazon_mock

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
            return {"SearchResult": {"Items": [], "TotalResultCount": 0}}

        # Phase 3: real API call goes here
        raise NotImplementedError("Real API not wired yet")

    async def get_items(self, asins: list[str]) -> dict:
        """Fetch item details by ASINs. Returns raw API-shaped dict."""
        if self._mock:
            return {"ItemsResult": {"Items": []}}

        raise NotImplementedError("Real API not wired yet")
