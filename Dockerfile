FROM nginx:alpine
# This replaces the default Nginx page with our custom message
RUN echo "<h1>Hello Yash! This is Version 1</h1>" > /usr/share/nginx/html/index.html
