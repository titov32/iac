# Используем официальный образ Node.js
FROM node:20-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы в контейнер
COPY . .

# Устанавливаем зависимости
RUN npm install express

# Открываем порт
EXPOSE 5000

# Запускаем приложение
CMD ["node", "app.js"]

