# Роли и полномочия при работе с Kubernetes

## Таблица ролей

| Роль | Права роли | Группы пользователей |
|------|------------|----------------------|
| `viewer` | get, list, watch на pods, services, deployments, configmaps | Менеджеры, Бизнес-аналитики |
| `developer` | get, list, watch, create, update, patch, delete на pods, services, deployments, configmaps, ingress | Разработчики |
| `operator` | Все права developer + get, list на secrets, + exec в pods | Инженеры по эксплуатации |
| `cluster-admin` | Полный доступ ко всем ресурсам кластера | DevOps-инженеры |
| `security-auditor` | get, list, watch на все ресурсы + просмотр audit logs | Специалист по ИБ |

## Обоснование

1. **viewer** — минимальные права для просмотра состояния. Менеджеры и аналитики могут мониторить без риска изменений.

2. **developer** — права на управление приложениями в рамках namespace. Без доступа к secrets для защиты конфиденциальных данных.

3. **operator** — расширенные права для эксплуатации: доступ к secrets для диагностики, exec для отладки.

4. **cluster-admin** — полный доступ для DevOps. Используется для настройки кластера, управления RBAC.

5. **security-auditor** — read-only доступ ко всему для проведения аудита. Решает проблему изоляции ИБ-специалиста.

## Принцип минимальных привилегий

- Роли применяются на уровне namespace (кроме cluster-admin и security-auditor)
- Каждый домен (продажи, ЖКУ, финансы, дата) имеет свой namespace
- Пользователь получает роль только в namespace своего домена
