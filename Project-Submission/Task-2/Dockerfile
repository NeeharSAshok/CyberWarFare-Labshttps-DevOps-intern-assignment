# Use lightweight official nginx image as the base
FROM nginx:alpine

# Remove default nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy our custom index.html into the nginx web root
COPY index.html /usr/share/nginx/html/index.html

# Change nginx default port from 80 to 8000
RUN sed -i 's/listen\s*80;/listen 8000;/g' /etc/nginx/conf.d/default.conf

# Expose port 8000
EXPOSE 8000

# Start nginx in foreground (required for Docker)
CMD ["nginx", "-g", "daemon off;"]
