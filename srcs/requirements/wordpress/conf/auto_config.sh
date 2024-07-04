#!/bin/sh

echo "Vérification de l'existence du fichier wp-config.php..."
if [ -f "/var/www/html/wordpress/wp-config.php" ];
then 
    echo "Le fichier wp-config.php existe déjà."
    sleep 5
else
    echo "Le fichier wp-config.php n'existe pas. Installation de WordPress en cours..."
    sleep 20

    echo "Téléchargement de WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    # Télécharge et installe la version 6.4 de WordPress
    echo "Téléchargement de WordPress..."
    wp core download --allow-root --version=6.4 --path=/var/www/html/wordpress
    echo "Configuration de WordPress..."

    # Crée le fichier de configuration de WordPress
    cd /var/www/html/wordpress
    echo "Création du fichier de configuration wp-config.php..."
    wp config create --allow-root --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${MYSQL_HOST}

    echo "Installation de WordPress..."
    wp core install --allow-root --url="${DOMAIN_NAME}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN_LOGIN}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}" --skip-email

fi
echo "Vérification de l'existence de l'utilisateur WordPress..."
if ! wp user get "${WP_ADMIN_LOGIN}" --allow-root --field=user_login; then
    echo "Création d'un utilisateur WordPress..."
    wp user create --allow-root ${WP_ADMIN_LOGIN} ${WP_ADMIN_EMAIL} --role=author --user_pass=${WP_ADMIN_PASSWORD}
else
    echo "L'utilisateur WordPress existe déjà."
fi
echo "Vérification de l'existence de l'utilisateur secondaire WordPress..."
if ! wp user get "${WP_USER}" --allow-root --field=user_login; then
    echo "Création de l'utilisateur secondaire WordPress..."
    wp user create ${WP_USER} ${WP_USER_EMAIL} --role=author --user_pass=${WP_USER_PASSWORD} --allow-root
else
    echo "L'utilisateur secondaire WordPress existe déjà."
fi
echo "Démarrage de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F

