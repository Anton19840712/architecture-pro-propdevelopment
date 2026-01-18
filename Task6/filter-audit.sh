#!/bin/bash
# Скрипт фильтрации подозрительных событий из audit.log
# Использование: ./filter-audit.sh /var/log/audit.log

AUDIT_LOG="${1:-/var/log/audit.log}"
OUTPUT_FILE="audit-extract.json"

echo "Анализ файла: $AUDIT_LOG"
echo "[]" > $OUTPUT_FILE

# 1. Доступ к secrets
echo "=== Поиск доступа к secrets ==="
jq -c 'select(.objectRef.resource=="secrets" and .verb=="get")' $AUDIT_LOG 2>/dev/null | head -5

# 2. Создание привилегированных подов
echo ""
echo "=== Поиск привилегированных подов ==="
jq -c 'select(.objectRef.resource=="pods" and .verb=="create" and .requestObject.spec.containers[].securityContext.privileged==true)' $AUDIT_LOG 2>/dev/null | head -5

# 3. Exec в поды
echo ""
echo "=== Поиск kubectl exec ==="
jq -c 'select(.verb=="create" and .objectRef.subresource=="exec")' $AUDIT_LOG 2>/dev/null | head -5

# 4. Создание RoleBinding с cluster-admin
echo ""
echo "=== Поиск эскалации привилегий ==="
jq -c 'select(.objectRef.resource=="rolebindings" and .verb=="create" and .requestObject.roleRef.name=="cluster-admin")' $AUDIT_LOG 2>/dev/null | head -5

# 5. Попытки удаления audit-policy
echo ""
echo "=== Поиск попыток удаления audit-policy ==="
grep -i 'audit-policy' $AUDIT_LOG 2>/dev/null | head -5

# Сохранение всех подозрительных событий в JSON
echo ""
echo "=== Сохранение результатов в $OUTPUT_FILE ==="

jq -s '[
  (.[] | select(.objectRef.resource=="secrets" and .verb=="get")),
  (.[] | select(.objectRef.resource=="pods" and .verb=="create" and .requestObject.spec.containers[].securityContext.privileged==true)),
  (.[] | select(.verb=="create" and .objectRef.subresource=="exec")),
  (.[] | select(.objectRef.resource=="rolebindings" and .verb=="create" and .requestObject.roleRef.name=="cluster-admin"))
] | unique' $AUDIT_LOG > $OUTPUT_FILE 2>/dev/null

echo "Готово. Результаты сохранены в $OUTPUT_FILE"
