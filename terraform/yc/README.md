# README for Terraform Yandex Cloud Module

Необходимые условия для запуска

Аккаунт в яндекс облаке
Для регистрации зайти в консоль и ответить на ряд вопросов. Адрес консоли тут https://console.yandex.cloud. При регистрации платежного аккаунта, первый раз, дают 4000 рублей на тестирование сервисов. Грант действует два месяца. Нужно привязать банковскую карту.

# Перед запуском
Инструкции по запуску как настроить и запустить модуль Terraform Yandex Cloud - https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart#cli_2
also setup environment for terraform bucket:
AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID

Требуемые инструменты:
- Terraform
- Yandex Cloud CLI
- Ansible
- kubectl

# Что делает данная штука?
Она разворачивает 3 виртуальных машины в Yandex Cloud. 1 мастер и 2 рабочих. Производит преднастройку через cloud-init. Позже разворачивает кластер kubernetes и настраивает его.
Также она формирует динамический inventory для ansible, после отработки появится файл inventory.yml в данном каталоге. По которому можно будет до настроить ВМ.

Также используется backend для хранения состояния Terraform. Это позволяет сохранять и восстанавливать состояние ресурсов, что упрощает управление и отслеживание изменений в инфраструктуре.

# Kubernetes
## Использование
После того как отработает ansible будет доступен файл для подключения к кластеру kubernetes. Ниже его исполнение.
Domain name master nodesis variable
```bash
export KUBECONFIG=$(pwd)/kubeconfig
```
# ArgoCD
ArgoCD - это система для развертывания и управления приложениями в Kubernetes. Она позволяет автоматизировать процесс развертывания и обновления приложений, а также обеспечивает контроль над состоянием приложений и их репликацией.
## Получение пароля
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
## быстрый доступ
```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
```
