#!/bin/bash
# Проверка Gatekeeper constraints

echo "=== Проверка OPA Gatekeeper ==="

echo ""
echo "1. Статус Gatekeeper:"
kubectl get pods -n gatekeeper-system

echo ""
echo "2. Применённые ConstraintTemplates:"
kubectl get constrainttemplates

echo ""
echo "3. Применённые Constraints:"
kubectl get constraints

echo ""
echo "4. Проверка нарушений:"
kubectl get k8spspprivileged deny-privileged-containers -o yaml | grep -A20 "status:"
kubectl get k8spsphostpath deny-hostpath-volumes -o yaml | grep -A20 "status:"
kubectl get k8spsprunasnonroot require-run-as-nonroot -o yaml | grep -A20 "status:"

echo ""
echo "=== Проверка завершена ==="
