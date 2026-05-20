# Giai đoạn 1: Dùng Node để build Angular
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Lệnh này sẽ tạo ra thư mục dist/ltw-frontend
RUN npm run build 

# Giai đoạn 2: Đưa code đã build vào Nginx để chạy
FROM nginx:alpine
# Copy từ "build" (giai đoạn 1) sang Nginx
# Đảm bảo đường dẫn này khớp với cấu hình trong angular.json của bạn
COPY --from=build /app/dist/ltw-frontend /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
