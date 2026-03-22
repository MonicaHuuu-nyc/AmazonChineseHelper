from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    amazon_credential_id: str = ""
    amazon_credential_secret: str = ""
    amazon_associate_tag: str = "cnshophelper-20"
    amazon_country: str = "US"

    redis_url: str = "redis://localhost:6379"

    app_env: str = "development"
    amazon_mock: bool = True
    log_level: str = "debug"

    translation_api_key: str = ""

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
