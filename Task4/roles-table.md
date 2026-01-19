# Матрица ролей Kubernetes для PropDevelopment

## Роли и права доступа

| Роль | Namespace | Ресурсы | Права | Назначение |
|------|-----------|---------|-------|------------|
| viewer | app-* | pods, services, configmaps | get, list, watch | Просмотр для разработчиков |
| developer | app-dev | pods, deployments, services, configmaps, secrets | get, list, watch, create, update, delete | Разработка в dev-окружении |
| operator | app-* | pods, deployments, services, configmaps | get, list, watch, update, patch | Управление в prod |
| cluster-admin | * | * | * | Администрирование кластера |
| security-auditor | * | pods, secrets, networkpolicies, events | get, list, watch | Аудит безопасности |

## Принцип минимальных привилегий

- **viewer**: только чтение, без доступа к secrets
- **developer**: полный доступ только в dev namespace
- **operator**: update/patch без delete в prod
- **cluster-admin**: ограничен до 2 человек
- **security-auditor**: read-only для аудита

## Соответствие требованиям

| Требование | Реализация |
|------------|------------|
| Разделение dev/prod | Namespace-based RBAC |
| Минимальные привилегии | Роли ограничены по ресурсам |
| Аудит доступа | security-auditor role |
