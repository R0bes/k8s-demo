from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db import init_db
from app.routes.tasks import router as tasks_router
from app.version import get_app_version

APP_VERSION = get_app_version()

app = FastAPI(
    title="Kubernetes Demo Backend",
    version=APP_VERSION,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def on_startup() -> None:
    init_db()


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/version")
def version() -> dict[str, str]:
    return {"version": APP_VERSION}


app.include_router(tasks_router, prefix="/tasks", tags=["tasks"])
