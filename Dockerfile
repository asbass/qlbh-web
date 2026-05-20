# Sử dụng Nginx để phục vụ file tĩnh
FROM nginx:alpine
# Copy các file sau khi build từ thư mục 'dist' vào Nginx
# Hãy đảm bảo thư mục 'dist/ltw-frontend' trùng với tên sau khi bạn build angular
COPY ./dist/ltw-frontend /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]