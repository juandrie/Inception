FROM debian:bullseye

#Mettre a jour les paquets et installer MariaDB
RUN apt-get update \
 && apt-get install -y mariadb-server \
 && apt-get clean \ 
 && rm -rf /var/lib/apt/lists/* \


# Copie du fichier de configuration personnalisé dans le répertoire approprié
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Setup directory for init scripts
COPY conf/init_db.sql /docker-entrypoint-initdb.d/

# Assurez-vous que le répertoire de MySQL est prêt à être utilisé
#RUN mkdir -p /var/lib/mysql /var/run/mysqld \
#    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
#    && chmod 777 /var/run/mysqld

# Création du répertoire pour les fichiers temporaires de MySQL et attribution des permissions appropriées
RUN mkdir /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Exposition du port 3306 pour permettre les connexions à la base de données
EXPOSE 3306

# Script d'entrée modifié (s'il est toujours nécessaire)
COPY conf/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
