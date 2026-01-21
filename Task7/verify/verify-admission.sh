#!/bin/bash
# Проверка работы PodSecurity Admission

echo "=== Проверка PodSecurity Admission ==="

echo ""
echo "1. Проверка namespace audit-zone:"
kubectl get ns audit-zone -o jsonpath='{.metadata.labels}' | jq .

echo ""
echo "2. Попытка создать privileged pod (должен быть отклонён):"
kubectl apply -f insecure-manifests/01-privileged-pod.yaml 2>&1 || echo "OK: Pod отклонён"

echo ""
echo "3. Попытка создать hostPath pod (должен быть отклонён):"
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml 2>&1 || echo "OK: Pod отклонён"

echo ""
echo "4. Попытка создать root user pod (должен быть отклонён):"
kubectl apply -f insecure-manifests/03-root-user-pod.yaml 2>&1 || echo "OK: Pod отклонён"

echo ""
echo "5. Создание безопасных подов (должны быть приняты):"
kubectl apply -f secure-manifests/

echo ""
echo "6. Проверка созданных подов:"
kubectl get pods -n audit-zone
