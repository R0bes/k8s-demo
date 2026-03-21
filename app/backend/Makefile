.PHONY: setup run-dev lint lint-fix format test chec check-fix

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

format-check:
	uv run ruff format --check .

test:
	DB_URL=sqlite:///./test.db uv run pytest

check: lint format-check test

check-fix: lint-fix format test
