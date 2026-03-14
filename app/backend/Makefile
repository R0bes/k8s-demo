PYTHON := ../../.venv/bin/python
RUFF := ../../.venv/bin/ruff
PYTEST := ../../.venv/bin/pytest

.PHONY: lint format test

lint:
	$(RUFF) check .

format:
	$(RUFF) format .

test:
	$(PYTEST)
