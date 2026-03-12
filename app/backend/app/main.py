from fastapi import FastAPI

from app.routes.tasks import router as tasks_router

app = FastAPI(title="Kubernetes Demo Backend", version="0.1.0")

@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}

app.include_router(tasks_router, prefix="/tasks", tags=["tasks"])