# Amazon Chinese Shopping Helper (亚马逊中文购物助手)

An iOS app that helps Chinese-speaking users in the US browse and evaluate Amazon products entirely in Chinese. Amazon US does not offer Chinese language support despite millions of non-English-speaking shoppers — this app fills that gap.

## Features

**Frontend (iOS) — Complete**
- Search products in Chinese with automatic query translation
- Browse translated product listings with Chinese titles, descriptions, and tags
- View product detail with image gallery, feature highlights, and seller warnings
- Save favorite items locally
- Open the real Amazon product page with one tap
- Settings: larger text mode and USD/CNY currency switching
- Clean, modern UI with bottom tab navigation (Home, Favorites, Settings)

**Backend (Python/FastAPI) — In Progress**
- RESTful API with search, product detail, batch, and categories endpoints
- Chinese-to-English dictionary-based query translation (110+ terms)
- Product mapper: auto-generates Chinese titles, infers discount/popularity tags, extracts highlights, detects seller warnings
- In-memory caching with TTL (Redis planned)
- Mock Amazon upstream with 12 realistic products across 10 categories
- 35 passing tests

**Upcoming**
- Real Amazon Creators API integration (pending Associates account approval)
- iOS-to-backend integration testing
- Redis caching and production deployment

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| iOS | Swift, SwiftUI, MVVM, Observation framework, async/await |
| Backend | Python, FastAPI, Pydantic, Uvicorn |
| Persistence | UserDefaults (favorites, settings) |
| Planned | Amazon Creators API, Redis, Railway |

## Project Structure

```
AmazonChineseHelper/
├── AmazonChineseHelper/     # iOS app (SwiftUI)
│   ├── Views/               # Home, Search, ProductDetail, Favorites, Settings
│   ├── ViewModels/           # @Observable view models
│   ├── Models/               # Domain models
│   ├── Services/             # Protocol-based service layer (Mock + Remote)
│   ├── Components/           # Reusable UI components
│   ├── Theme/                # Colors, typography, spacing
│   └── MockData/             # Bundled JSON for offline mode
└── backend/                  # Python FastAPI server
    ├── app/
    │   ├── routers/          # health, search, products, categories
    │   ├── services/         # amazon_client, translation, product_mapper, cache
    │   ├── models/           # Pydantic DTOs
    │   └── data/             # Categories, dictionary, title translations
    └── tests/                # 35 tests with fixtures
```

## Local Development

**Backend:**
```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

**iOS:** Open `AmazonChineseHelper.xcodeproj` in Xcode and run on simulator.

Toggle `ServiceContainer.useRemoteBackend` to switch between mock data and the live backend.
