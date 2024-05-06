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