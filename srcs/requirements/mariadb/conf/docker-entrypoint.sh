#!/bin/sh

envsubst < /docker-entrypoint-initdb.d/init.sql > /docker-entrypoint-initdb.d/init_new.sql

if [ ! -d "/var/lib/mysql/wordpress" ]; then
    service mariadb start
    sleep 10       # Attendre que MariaDB soit prêt

    echo "Configuration initiale de la base de données..."
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -h localhost < /docker-entrypoint-initdb.d/init_new.sql
    rm -f init_new.sql && rm -f init.sql

    echo "Arrêt de MariaDB..."
    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

    sleep 5  # Petite pause
fi

echo "Démarrage permanent de MariaDB..."
exec mysqld_safe
