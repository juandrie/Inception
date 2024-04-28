#!/bin/bash

# Wait for the database to be ready
sleep 10

# Check if wp-config.php exists
if [ ! -f '/var/www/html/wp-config.php' ]; then

# Télécharge WP-CLI (outil en ligne de commande pour WordPress)
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    wp core download --allow-root --version=6.4 --path=/var/www/html/
    wp config create --allow-root --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${MYSQL_HOST} --path=/var/www/html/

    wp core install --url="${WP_URL}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN_LOGIN}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}" --skip-email --allow-root --path=/var/www/html/
    # Add a second user
    wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --allow-root --path=/var/www/html/
fi

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F