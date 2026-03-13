from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db import init_db
from app.models.task import TaskModel
from app.routes.tasks import router as tasks_router

app = FastAPI(title="Kubernetes Demo Backend", version="0.1.0")

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

app.include_router(tasks_router, prefix="/tasks", tags=["tasks"])