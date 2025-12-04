FROM nginx:alpine
RUN echo "<h1>This build was triggered automatically! Version 3</h1>" > /usr/share/nginx/html/index.html
