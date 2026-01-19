#!/bin/bash
# Скрипт фильтрации Kubernetes audit log

AUDIT_LOG="${1:-/var/log/kubernetes/audit.log}"
OUTPUT_DIR="${2:-./audit-analysis}"

mkdir -p "$OUTPUT_DIR"

# 1. Доступ к secrets
echo "Filtering secrets access..."
jq 'select(.objectRef.resource == "secrets")' "$AUDIT_LOG" > "$OUTPUT_DIR/secrets-access.json"

# 2. Ошибки авторизации (403)
echo "Filtering authorization errors..."
jq 'select(.responseStatus.code == 403)' "$AUDIT_LOG" > "$OUTPUT_DIR/forbidden.json"

# 3. Операции delete
echo "Filtering delete operations..."
jq 'select(.verb == "delete")' "$AUDIT_LOG" > "$OUTPUT_DIR/deletions.json"

# 4. Действия с RBAC
echo "Filtering RBAC changes..."
jq 'select(.objectRef.resource | test("role|binding"))' "$AUDIT_LOG" > "$OUTPUT_DIR/rbac-changes.json"

# 5. Ночные операции (00:00-06:00)
echo "Filtering night operations..."
jq 'select(.requestReceivedTimestamp | split("T")[1] | split(":")[0] | tonumber < 6)' "$AUDIT_LOG" > "$OUTPUT_DIR/night-ops.json"

echo "Analysis complete. Results in $OUTPUT_DIR"
