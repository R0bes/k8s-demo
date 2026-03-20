import os

def get_app_version() -> str:
    return os.getenv("APP_VERSION", "0.0.0")
