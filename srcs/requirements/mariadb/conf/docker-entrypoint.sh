#!/bin/bash


echo "Adjusting data directory permissions..."
chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

echo "Vérification de l'initialisation du répertoire de la base de données..."
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    echo "Démarre le service MariaDB..."
    service mariadb start
    
    echo "Pause pour laisser le temps au service de démarrer..."
    sleep 5

   # echo "Configuring root user for password authentication..."
   # mysql -u root --skip-password -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root'; FLUSH PRIVILEGES;"
    
    echo "Création de la base de données..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

    echo "Création de l'utilisateur..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
   
    echo "Création de l'utilisateur pour localhost..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"

    echo "Attribution des privilèges..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%';"

    echo "Attribution des privilèges pour localhost..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost';"

    echo "Rafraîchissement des privilèges..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
    echo "Arrêt du service MySQL..."
    mysqladmin -u root --password="${MYSQL_ROOT_PASSWORD}" shutdown
    
    echo "Pause pour laisser le temps au service de s'arrêter..."
    sleep 5
else
    echo "La base de données a déjà été initialisée."
fi

echo "Démarrage du serveur MariaDB en tant que processus principal..."
exec mysqld_safe

