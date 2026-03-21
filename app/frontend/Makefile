NPM := npm

.PHONY: setup run-dev lint lint-fix format format-check build test check check-fix

setup:
	$(NPM) ci

run-dev:
	$(NPM) run dev

lint:
	$(NPM) run lint

lint-fix:
	$(NPM) run lint:fix

format:
	$(NPM) run format

format-check:
	$(NPM) run format:check

build:
	$(NPM) run build

test:
	$(NPM) run test

check: lint format-check build

check-fix: lint-fix format build
