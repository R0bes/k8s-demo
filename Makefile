FRONTEND_DIR := ./app/frontend
BACKEND_DIR := ./app/backend

COMPOSE_FILE := ./ops/compose/docker-compose.yml
HELM_DIR=./ops/helm

ENV_FILE ?= ./.env

ifneq (,$(wildcard $(ENV_FILE)))
include $(ENV_FILE)
export $(shell sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' $(ENV_FILE))
endif

APP_NAME ?= k8s-demo
CLUSTER_NAME ?= $(APP_NAME)
KIND_CONFIG ?= ./ops/kind/config.yaml
HELM_NAMESPACE ?= $(APP_NAME)
HELM_RELEASE ?= $(APP_NAME)
INGRESS_NAME ?= ingress-nginx




.PHONY: help \
	setup-repo clean \
	setup-be setup-fe \
    dev-be dev-fe \
    lint format test  \
	docker-build-be docker-build-fe docker-build \
	db-up db-down \
	compose-up compose-down compose-restart compose-logs \
	kind-up kind-down kind-load-images kind-status \
	helm-install-ingress helm-up helm-down helm-status \
	argocd-install

.DEFAULT_GOAL := help


### ------------------------
###          Repo
### ------------------------

help:
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "  Repo setup"
	@echo "    setup-repo           Setup virtualenv and pre-commit hooks"
	@echo "    clean                Remove virtualenv"
	@echo ""
	@echo "  Local development"
	@echo "    setup-be             Setup backend for local development"
	@echo "    setup-fe             Setup frontend for local development"
	@echo "    dev-be               Start backend in dev mode (local DB via docker)"
	@echo "    dev-fe               Start frontend in dev mode"
	@echo "    lint                 Run frontend and backend linters"
	@echo "    format               Run frontend and backend formatters"
	@echo "    test                 Run frontend and backend tests"
	@echo ""
	@echo "  Docker"
	@echo "    docker-build-be      Build backend image with docker compose"
	@echo "    docker-build-fe      Build frontend image with docker compose"
	@echo "    docker-build         Build backend and frontend images"
	@echo ""
	@echo "  Docker Compose"
	@echo "    db-up                Start database container"
	@echo "    db-down              Stop database container"
	@echo "    compose-up           Start full compose stack"
	@echo "    compose-down         Stop full compose stack"
	@echo "    compose-restart      Restart full compose stack"
	@echo "    compose-logs         Follow compose logs"
	@echo ""
	@echo "  kind (Cluster)"
	@echo "    kind-up              Create local kind cluster if needed"
	@echo "    kind-down            Delete local kind cluster"
	@echo "    kind-load-images     Load app images into kind (build if necessary)"
	@echo "    kind-status          Show kind cluster status"
	@echo ""
	@echo "  Helm (App)"
	@echo "    helm-install-ingress Install ingress-nginx via Helm"
	@echo "    helm-up              Deploy application chart"
	@echo "    helm-down            Remove application chart"
	@echo "    helm-status          Show Helm release and Kubernetes resources"
	@echo ""

setup-repo:
	@echo "Installing pre-commit..."
	uv tool install pre-commit
	@echo "Setup hooks..."
	uvx pre-commit install

clean:
	rm -rf app/backend/.venv



### ------------------------
###      Local dev
### ------------------------

DEV_DB_URL ?= postgresql+psycopg://$(DB_USER):$(DB_PASSWORD)@localhost:$(DB_PORT)/$(DB_NAME)

setup-be:
	@echo "Setting up backend..."
	$(MAKE) -C $(BACKEND_DIR) setup

setup-fe:
	@echo "Setting up frontend..."
	$(MAKE) -C $(FRONTEND_DIR) setup

dev-be: db-up setup-be
	$(MAKE) -C $(BACKEND_DIR) run-dev DB_URL="$(DEV_DB_URL)"

dev-fe: setup-fe
	$(MAKE) -C $(FRONTEND_DIR) run-dev


lint:
	$(MAKE) -C $(FRONTEND_DIR) lint
	$(MAKE) -C $(BACKEND_DIR) lint

format:
	$(MAKE) -C $(FRONTEND_DIR) format
	$(MAKE) -C $(BACKEND_DIR) format

format-check:
	$(MAKE) -C $(BACKEND_DIR) format-check

test-be:
	$(MAKE) -C $(BACKEND_DIR) test

test-fe:
	$(MAKE) -C $(FRONTEND_DIR) test

test: test-be test-fe

check-be:
	$(MAKE) -C $(BACKEND_DIR) check

check-fe:
	$(MAKE) -C $(FRONTEND_DIR) check

check: check-be check-fe





### ------------------------
###         Docker
### ------------------------


docker-build-be:
	docker compose -f $(COMPOSE_FILE) build backend

docker-build-fe:
	docker compose -f $(COMPOSE_FILE) build frontend

docker-build:
	docker compose -f $(COMPOSE_FILE) build backend frontend



### ------------------------
###     Docker Compose
### ------------------------

db-up:
	docker compose -f $(COMPOSE_FILE) up db -d

db-down:
	docker compose -f $(COMPOSE_FILE) down db

compose-up:
	docker compose -f $(COMPOSE_FILE) up -d

compose-down:
	docker compose -f $(COMPOSE_FILE) down
compose-down-v:
	docker compose -f $(COMPOSE_FILE) down -v

compose-restart: compose-down compose-up

compose-logs:
	docker compose -f $(COMPOSE_FILE) logs
compose-logs-f:
	docker compose -f $(COMPOSE_FILE) logs -f



### ------------------------
###       Kind Cluster
### ------------------------

INGRESS_MANIFEST = https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kind-up:
	@if ! kind get clusters | grep -qx "$(CLUSTER_NAME)"; then \
		kind create cluster \
			--name "$(CLUSTER_NAME)" \
			--config "$(KIND_CONFIG)"; \
	else \
		echo "Cluster already exists"; \
	fi

kind-down:
	-kind delete cluster --name "$(CLUSTER_NAME)"

kind-load-images: kind-up docker-build
	kind load docker-image "$(FE_IMAGE):$(IMAGE_TAG)" --name "$(CLUSTER_NAME)"
	kind load docker-image "$(BE_IMAGE):$(IMAGE_TAG)" --name "$(CLUSTER_NAME)"

# replaced by helm-ingress-install
kind-install-ingress: kind-up
	kubectl apply -f "$(INGRESS_MANIFEST)"
	kubectl rollout status deployment/ingress-nginx-controller -n "$(INGRESS_NAME)" --timeout=180s

kind-status:
	kubectl cluster-info --context kind-$(CLUSTER_NAME)
	kubectl get nodes --context kind-$(CLUSTER_NAME)




### ------------------------
###         Helm
### ------------------------


helm-install-ingress: kind-up
	helm repo add $(INGRESS_NAME) https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
	helm repo update
	helm upgrade --install $(INGRESS_NAME) ingress-nginx/ingress-nginx \
  		--namespace $(INGRESS_NAME) \
  		--create-namespace \
  		--version 4.15.0 \
		--set controller.hostPort.enabled=true \
		--set controller.hostPort.ports.http=80 \
		--set controller.hostPort.ports.https=443 \
		--set controller.extraArgs.publish-status-address=localhost
	kubectl rollout status deployment/ingress-nginx-controller -n $(INGRESS_NAME) --timeout=180s


helm-up: kind-install-ingress kind-load-images
	helm upgrade --install $(HELM_RELEASE) $(HELM_DIR) \
		--namespace $(HELM_NAMESPACE) \
		--create-namespace
	kubectl rollout status deployment/postgres -n $(HELM_NAMESPACE) --timeout=180s
	kubectl rollout status deployment/backend -n $(HELM_NAMESPACE) --timeout=180s
	kubectl rollout status deployment/frontend -n $(HELM_NAMESPACE) --timeout=180s

helm-down:
	-helm uninstall $(HELM_RELEASE) -n $(HELM_NAMESPACE)


helm-status:
	helm list -n $(HELM_NAMESPACE)
	kubectl get pods -n $(HELM_NAMESPACE)
	kubectl get ingress -n $(HELM_NAMESPACE)






### ------------------------
###        ArgoCD
### ------------------------

ARGOCD_NAMESPACE ?= argocd
ARGOCD_INSTALL_MANIFEST ?= https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argocd-install: kind-install-ingress
	kubectl create namespace $(ARGOCD_NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n $(ARGOCD_NAMESPACE) -f $(ARGOCD_INSTALL_MANIFEST) --server-side --force-conflicts
	kubectl rollout status deployment/argocd-server -n $(ARGOCD_NAMESPACE) --timeout=180s

#	argocd app sync k8s-demo-dev
argocd-up-dev: argocd-install kind-load-images
	kubectl apply -f ops/argocd/app-dev.yaml
	kubectl get application k8s-demo-dev -n $(ARGOCD_NAMESPACE)

argocd-up-prod: argocd-install
	kubectl apply -f ops/argocd/app-prod.yaml
	kubectl get application k8s-demo-prod -n $(ARGOCD_NAMESPACE)


argocd-ui:
	argocd admin initial-password -n argocd
	kubectl port-forward svc/argocd-server -n $(ARGOCD_NAMESPACE) 8081:443

argocd-uninstall:
	kubectl delete namespace $(ARGOCD_NAMESPACE)

argocd-status:
	argocd app list -n $(ARGOCD_NAMESPACE)
	kubectl get pods -n $(ARGOCD_NAMESPACE)
	kubectl get ingress -n $(ARGOCD_NAMESPACE)
