PYTHON := python3
VENV := .venv
VENV_PYTHON := $(VENV)/bin/python
VENV_PIP := $(VENV)/bin/pip
PRE_COMMIT := $(VENV)/bin/pre-commit

.PHONY: setup setup-python setup-frontend setup-hooks lint test clean

setup: setup-python setup-frontend setup-hooks
	@echo "Repository setup complete."

setup-python:
	test -d $(VENV) || $(PYTHON) -m venv $(VENV)
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(VENV_PIP) install -r app/backend/requirements-dev.txt

setup-frontend:
	$(MAKE) -C app/frontend setup

setup-hooks:
	$(PRE_COMMIT) install

lint:
	$(MAKE) -C app/frontend lint
	$(MAKE) -C app/backend lint

test:
	$(MAKE) -C app/backend test

clean:
	rm -rf $(VENV)


# Run

k8s-up:
	./scripts/k8s-up.sh

k8s-down:
	./scripts/k8s-down.sh

k8s-reset:
	./scripts/k8s-reset.sh

k8s-status:
	kubectl get pods -n k8s-demo
	kubectl get ingress -n k8s-demo

k8s-logs-backend:
	kubectl logs -n k8s-demo deployment/backend

k8s-logs-frontend:
	kubectl logs -n k8s-demo deployment/frontend


helm-up:
	./scripts/helm-up.sh

helm-down:
	./scripts/helm-down.sh

helm-reset:
	./scripts/helm-reset.sh

helm-status:
	helm list -n k8s-demo
	kubectl get pods -n k8s-demo
	kubectl get ingress -n k8s-demo


argocd-install:
	./scripts/argocd-install.sh

argocd-uninstall:
	./scripts/argocd-uninstall.sh

argocd-port-forward:
	kubectl port-forward svc/argocd-server -n argocd 8081:443

argocd-status:
	argocd app list -n argocd
	kubectl get pods -n argocd
	kubectl get ingress -n argocd
