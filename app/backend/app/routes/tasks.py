from fastapi import APIRouter

from app.schemas.task import Task, CreateTaskRequest
from app.storage.postgres import create_task, list_tasks

router = APIRouter()


@router.get("/", response_model=list[Task])
def get_tasks() -> list[Task]:
    return list_tasks()


@router.post("/", response_model=Task, status_code=201)
def add_task(payload: CreateTaskRequest) -> Task:
    return create_task(payload)
