# Task7: PodSecurity Admission + OPA Gatekeeper

## Структура

```
Task7/
├── 01-create-namespace.yaml      # Namespace с PodSecurity restricted
├── insecure-manifests/           # Небезопасные поды (для демонстрации блокировки)
│   ├── 01-privileged-pod.yaml    # privileged: true
│   ├── 02-hostpath-pod.yaml      # hostPath volume
│   └── 03-root-user-pod.yaml     # runAsUser: 0
├── secure-manifests/             # Безопасные поды (проходят валидацию)
│   ├── 01-secure.yaml
│   ├── 02-secure.yaml
│   └── 03-secure.yaml
├── gatekeeper/
│   ├── constraint-templates/     # Шаблоны ограничений
│   │   ├── privileged.yaml
│   │   ├── hostpath.yaml
│   │   └── runasnonroot.yaml
│   └── constraints/              # Применение ограничений к audit-zone
│       ├── privileged.yaml
│       ├── hostpath.yaml
│       └── runasnonroot.yaml
├── verify/
│   ├── verify-admission.sh       # Проверка PodSecurity Admission
│   └── validate-security.sh      # Проверка Gatekeeper
├── audit-policy.yaml             # Политика аудита
└── README_FOR_REVIEWER.md
```

## Как проверить

### 1. Установка Gatekeeper
```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
```

### 2. Применение конфигурации
```bash
kubectl apply -f 01-create-namespace.yaml
kubectl apply -f gatekeeper/constraint-templates/
kubectl apply -f gatekeeper/constraints/
```

### 3. Проверка блокировки небезопасных подов
```bash
kubectl apply -f insecure-manifests/01-privileged-pod.yaml
# Ожидается: Error - pod rejected by PodSecurity
```

### 4. Проверка создания безопасных подов
```bash
kubectl apply -f secure-manifests/
kubectl get pods -n audit-zone
# Ожидается: pods running
```

## Политики

| Правило | ConstraintTemplate | Описание |
|---------|-------------------|----------|
| Запрет privileged | K8sPSPPrivileged | Блокирует privileged: true |
| Запрет hostPath | K8sPSPHostPath | Блокирует монтирование hostPath |
| Требование nonroot | K8sPSPRunAsNonRoot | Требует runAsNonRoot: true, readOnlyRootFilesystem: true |
