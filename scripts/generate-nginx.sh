#!/bin/bash
set -e

ENV_FILE="${1:-.env.production}"
TEMPLATE="nginx/templates/nginx.conf.template"
OUTPUT="nginx/nginx.conf"

# Load env vars
export $(grep -v '^#' "$ENV_FILE" | xargs)

# Generate config — only substitute our variables, leave nginx $variables alone
envsubst '${SERVER_NAME} ${RAGFLOW_HOST} ${RAGFLOW_PORT}' < "$TEMPLATE" > "$OUTPUT"

echo "Generated $OUTPUT from $TEMPLATE using $ENV_FILE"

