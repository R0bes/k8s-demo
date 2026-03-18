ROOT_DIR := $(abspath ../..)
PYTHON := $(ROOT_DIR)/.venv/bin/python
RUFF := $(ROOT_DIR)/.venv/bin/ruff
PYTEST := $(ROOT_DIR)/.venv/bin/pytest
PIP := $(ROOT_DIR)/.venv/bin/pip


.PHONY: setup run-dev lint format test

setup:
	$(PIP) install -r requirements-dev.txt

run-dev:
	$(PYTHON) -m uvicorn app.main:app --reload

lint:
	$(RUFF) check .

lint-fix:
	@echo "No linting with auto fix implemented yet"

format:
	$(RUFF) format .

test:
	$(PYTEST)
