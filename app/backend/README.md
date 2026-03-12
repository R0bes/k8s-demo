# Backend Service

## Features

- Health check endpoint
- In-memory task API
- OpenAPI documentation via Swagger UI

## Run locally

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Run with docker

```bash
docker build -t k8s-demo-backend .
docker run --rm -p 8000:8000 k8s-demo-backend
```


## Endpoints

- `GET /health`
- `GET /tasks`
- `POST /tasks`
- `GET /docs`