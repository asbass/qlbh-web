# Giai đoạn 1: Build code
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build  # Hoặc lệnh build cụ thể của dự án bạn

# Giai đoạn 2: Serve bằng Nginx
FROM nginx:alpine
# Copy file từ giai đoạn build vào thư mục của Nginx
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
