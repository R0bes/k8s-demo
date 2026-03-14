.PHONY: k8s-up k8s-down k8s-reset k8s-status k8s-logs-backend k8s-logs-frontend

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