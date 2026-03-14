from sqlalchemy import select

from app.db import SessionLocal
from app.models.task import TaskModel
from app.schemas.task import CreateTaskRequest, Task


def list_tasks() -> list[Task]:
    with SessionLocal() as session:
        result = session.execute(select(TaskModel).order_by(TaskModel.id))
        tasks = result.scalars().all()

    return [Task(id=task.id, title=task.title) for task in tasks]


def create_task(payload: CreateTaskRequest) -> Task:
    with SessionLocal() as session:
        task = TaskModel(title=payload.title)
        session.add(task)
        session.commit()
        session.refresh(task)

    return Task(id=task.id, title=task.title)
