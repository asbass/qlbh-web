# Sử dụng Nginx để phục vụ file tĩnh
FROM nginx:alpine

# Thay vì COPY ./frontend, hãy dùng dấu chấm (.) 
# Dấu chấm (.) nghĩa là "Copy TẤT CẢ mọi thứ đang đứng cùng cấp với Dockerfile này"
COPY . /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
