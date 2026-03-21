.PHONY: setup run-dev lint lint-fix format test

setup:
	uv sync --dev

run-dev:
	uv run uvicorn app.main:app --reload

lint:
	uv run ruff check .

lint-fix:
	uv run ruff check --fix .

format:
	uv run ruff format .

test:
	uv run pytest
