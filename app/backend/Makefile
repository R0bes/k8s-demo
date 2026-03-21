UV := uv

.PHONY: setup run-dev lint lint-fix format test chec check-fix

setup:
	$(UV) sync --dev

run-dev:
	$(UV) run uvicorn app.main:app --reload

lint:
	$(UV) run ruff check .

lint-fix:
	$(UV) run ruff check --fix .

format:
	$(UV) run ruff format .

format-check:
	$(UV) run ruff format --check .

test:
	DB_URL=sqlite:///./test.db $(UV) run pytest

check: lint format-check test

check-fix: lint-fix format test
