FROM debian:bullseye

# Mise à jour du système et installation de nginx et openssl
RUN apt update &&\
    apt upgrade -y &&\
    apt install -y nginx\
    openssl

# Génération d'un certificat SSL auto-signé pour nginx
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/L=Paris/O=42/CN=juandrie.42.fr"

# Exposition du port 443 (HTTPS)
EXPOSE 443

# Copie du fichier de configuration nginx dans le répertoire approprié
COPY conf/nginx.conf /etc/nginx/sites-available/

# Configuration des sites disponibles et création d'un répertoire pour le serveur web
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/ && \
    rm -f /etc/nginx/sites-enabled/default


# Attribution des permissions pour le répertoire du serveur web
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Définition de la commande d'entrée pour démarrer nginx en mode démon
ENTRYPOINT ["nginx", "-g", "daemon off;"]

# FROM debian:bullseye

# # Install Nginx and the necessary software
# RUN apt-get update && \
#     apt-get install -y nginx openssl && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* 

# # Create a directory for SSL certificates
# RUN mkdir -p /etc/nginx/ssl

# # Generate a self-signed SSL certificate and private key
# RUN openssl req -x509 -nodes -days 365 \
#     -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=juandrie.42.fr/UID=juandrie" \
#     -newkey rsa:2048 -keyout /etc/nginx/ssl/inception.key \
#     -out /etc/nginx/ssl/inception.crt

# # Copy your configurations
# COPY conf/default.conf /etc/nginx/conf.d/default.conf

# # Ensure nginx.conf contains the "daemon off;" directive
# #RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# # Exposing HTTP and HTTPS ports
# EXPOSE 80 443

# # Starting NGINX in foreground mode
# CMD ["nginx", "-g", "daemon off;"]
