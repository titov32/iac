# Используем официальный образ Python
FROM python:3.12-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы в контейнер
COPY . .

# Устанавливаем зависимости
RUN pip install flask

# Открываем порт
EXPOSE 5000

# Запускаем приложение
CMD ["python", "app.py"]
