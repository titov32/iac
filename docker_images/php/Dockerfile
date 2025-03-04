# Используем официальный образ PHP
FROM php:8.2-apache

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Копируем файлы в контейнер
COPY . .

# Открываем порт
EXPOSE 80

# Запускаем Apache
CMD ["apache2-foreground"]
