# Sử dụng Nginx Alpine để serve file tĩnh
FROM nginx:alpine

# Copy toàn bộ code vào thư mục của Nginx
COPY . /usr/share/nginx/html

# Expose cổng 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
