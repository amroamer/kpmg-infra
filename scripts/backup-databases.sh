#!/bin/bash
set -e

BACKUP_DIR="/opt/kpmg-infra/backups/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "=== Backing up databases to $BACKUP_DIR ==="

# Slides Generator Postgres
docker exec slides-db pg_dump -U ${SG_POSTGRES_USER:-kpmg_slides} ${SG_POSTGRES_DB:-slides_generator} > "$BACKUP_DIR/slides-generator.sql" 2>/dev/null && echo "OK: slides-generator" || echo "SKIP: slides-generator (not running)"

# Sahab Postgres
docker exec sahab-db pg_dump -U ${SAHAB_POSTGRES_USER:-postgres} ${SAHAB_POSTGRES_DB:-cloudsahab} > "$BACKUP_DIR/sahab.sql" 2>/dev/null && echo "OK: sahab" || echo "SKIP: sahab (not running)"

# Data Owner Agent Postgres
docker exec dataowner-db pg_dump -U ${DOA_POSTGRES_USER:-zatca} ${DOA_POSTGRES_DB:-zatca} > "$BACKUP_DIR/data-owner-agent.sql" 2>/dev/null && echo "OK: data-owner-agent" || echo "SKIP: data-owner-agent (not running)"

# AI Badges Postgres
docker exec badges-db pg_dump -U ${BADGES_POSTGRES_USER:-aibadges} ${BADGES_POSTGRES_DB:-aibadges} > "$BACKUP_DIR/ai-badges.sql" 2>/dev/null && echo "OK: ai-badges" || echo "SKIP: ai-badges (not running)"

# RAGFlow MySQL
docker exec docker-mysql-1 mysqldump -uroot -p${MYSQL_PASSWORD:-infini_rag_flow} --all-databases > "$BACKUP_DIR/ragflow-mysql.sql" 2>/dev/null && echo "OK: ragflow-mysql" || echo "SKIP: ragflow-mysql (not running)"

# Cleanup backups older than 7 days
find /opt/kpmg-infra/backups -type d -mtime +7 -exec rm -rf {} + 2>/dev/null || true

echo "=== Backup complete ==="
ls -lh "$BACKUP_DIR"
