# Sử dụng Nginx làm server để chạy các file web tĩnh
FROM nginx:alpine

# Copy toàn bộ nội dung trong thư mục frontend của bạn vào thư mục phục vụ của Nginx
# Lưu ý: Hãy đảm bảo thư mục 'frontend' chứa file 'index.html' của bạn
COPY ./frontend /usr/share/nginx/html

# Mở cổng 80 để truy cập web
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
