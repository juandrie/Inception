FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y mariadb-server \
                          gettext \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Copie du fichier de configuration personnalisé
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copie du script d'initialisation de la base de données
COPY conf/init.sql /docker-entrypoint-initdb.d/init.sql

# Copie et autorisation du script entrypoint
COPY conf/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Création du répertoire run (si nécessaire)
RUN mkdir -p var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && chmod 755 /var/run/mysqld

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
