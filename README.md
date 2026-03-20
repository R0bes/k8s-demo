# K8s Demo

A kubernetes demo projec to showcase Kubernetes, containerization, and platform engineering skills.

## Planned Stack
- Frontend: Next.js
- Backend: FastAPI
- Database: PostgreSQL
- CI: GitHub Actions
- Local Kubernetes: KIND
- Packaging: Helm
- GitOps: Argo CD
- Monitoring: Prometheus + Grafana
- Cloud Deployment: AKS/EKS

## Roadmap

- [x] Initialize repository
- [x] Backend service
- [x] PostgreSQL setup
- [x] Docker Compose local environment
- [x] Frontend service
- [x] Kubernetes manifests
- [x] Local cluster with KIND
- [x] Ingress controller
- [x] Helm chart
- [x] GitOps with Argo CD
- [x] CI workflows
- [x] CD workflows
- [ ] Monitoring stack
- [ ] Deploy to AKS or EKS
- [ ] Optional: Terraform infrastructure

## Run locally with Docker Compose

```bash
cp .env.example .env
docker compose up --build
```

## Run on Kubernetes with KIND

Make sure the local host entry exists:

```bash
echo "127.0.0.1 k8s-demo.local" | sudo tee -a /etc/hosts
```


Start the full Kubernetes environment:

```bash
./scripts/k8s-up.sh
```


Open the application:

```bash
http://k8s-demo.local
```


Stop and remove the cluster:

```bash
./scripts/k8s-down.sh
```


## Run with helm

```bash
./scripts/helm-up.sh
./scripts/helm-down.sh
```
