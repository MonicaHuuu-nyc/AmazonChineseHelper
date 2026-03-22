from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.routers import categories, health, products, search

app = FastAPI(
    title="Amazon Chinese Helper API",
    version="1.0.0",
    description="Backend for the Amazon Chinese Helper iOS app",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] if settings.app_env == "development" else [],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(search.router)
app.include_router(products.router)
app.include_router(categories.router)
