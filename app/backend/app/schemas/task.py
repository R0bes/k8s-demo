from pydantic import BaseModel


class CreateTaskRequest(BaseModel):
    title: str


class Task(BaseModel):
    id: int
    title: str