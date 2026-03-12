# K8s Demo 

A kubernetes demo projec to showcase Kubernetes, containerization, and platform engineering skills.

## Planned Stack
- Frontend: Next.js
- Backend: FastAPI
- Database: PostgreSQL
- Local Kubernetes: KIND
- Packaging: Helm
- GitOps: Argo CD
- Monitoring: Prometheus + Grafana
- CI: GitHub Actions
- Cloud Deployment: AKS/EKS

## Roadmap

[x] Initialize repository
[x] Backend service
[x] PostgreSQL setup
[x] Docker Compose local environment
[ ] Frontend service
[ ] Kubernetes manifests
[ ] Local cluster with KIND
[ ] Ingress controller
[ ] Helm chart
[ ] GitOps with Argo CD
[ ] Monitoring stack
[ ] CI pipeline
[ ] Deploy to AKS or EKS
[ ] Optional: Terraform infrastructure

## Run locally with Docker Compose

```bash
cp .env.example .env
docker compose up --build
```