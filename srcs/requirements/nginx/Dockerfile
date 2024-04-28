FROM debian:bullseye

# Install Nginx and the necessary software
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Create a directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate and private key
RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=juandrie.42.fr/UID=juandrie" \
    -newkey rsa:2048 -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt

# Copy your configurations
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Ensure nginx.conf contains the "daemon off;" directive
#RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Exposing HTTP and HTTPS ports
EXPOSE 80 443

# Starting NGINX in foreground mode
CMD ["nginx", "-g", "daemon off;"]
