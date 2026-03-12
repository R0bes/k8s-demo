from fastapi import FastAPI

from app.db import init_db
from app.models.task import TaskModel
from app.routes.tasks import router as tasks_router

app = FastAPI(title="Kubernetes Demo Backend", version="0.1.0")

@app.on_event("startup")
def on_startup() -> None:
    init_db()

@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}

app.include_router(tasks_router, prefix="/tasks", tags=["tasks"])