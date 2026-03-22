# Amazon Chinese Helper — Backend

Python FastAPI backend for the Amazon Chinese Helper iOS app.
Handles product search, detail fetching, Chinese query translation,
and caching, powered by the Amazon Creators API.

## Local Development

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env   # then fill in real values
uvicorn app.main:app --reload
```

Open http://localhost:8000/docs for the interactive Swagger UI.

## Running Tests

```bash
pytest
```

## Deployment

Push to GitHub. Railway auto-deploys from the `Procfile`.

## Environment Variables

See `.env.example` for required variables.
