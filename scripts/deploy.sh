#!/bin/bash
set -e
cd /opt/kpmg-infra
echo "=== Generating Nginx config ==="
./scripts/generate-nginx.sh .env.production
echo "=== Ensuring RAGFlow network exists ==="
docker network create docker_ragflow 2>/dev/null || true
echo "=== Pulling latest images ==="
docker compose --env-file .env.production pull --ignore-buildable
echo "=== Building and starting services ==="
docker compose --env-file .env.production up -d --build --remove-orphans
echo "=== Restarting Nginx to pick up fresh IPs ==="
docker compose --env-file .env.production up -d --force-recreate nginx
echo "=== Status ==="
docker compose --env-file .env.production ps
echo "=== Deploy complete ==="