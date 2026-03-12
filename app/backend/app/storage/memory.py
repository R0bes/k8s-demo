from app.schemas.task import Task, CreateTaskRequest

tasks: list[Task] = []
next_task_id = 1


def list_tasks() -> list[Task]:
    return tasks


def create_task(payload: CreateTaskRequest) -> Task:
    global next_task_id

    task = Task(id=next_task_id, title=payload.title)
    tasks.append(task)
    next_task_id += 1
    return task