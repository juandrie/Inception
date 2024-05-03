SRC_DIR = srcs

SRC_FILES = docker-compose.yml

# Chemin complet des fichiers sources
SRC = $(addprefix $(SRC_DIR)/,$(SRC_FILES))

# Commande pour exécuter tous les services Docker définis dans le fichier docker-compose.yml
all:
	docker compose -f ${SRC} up --build -d

# Commande pour nettoyer l'environnement Docker en arrêtant les conteneurs et en supprimant le réseau
clean:
	docker container stop nginx mariadb wordpress
	docker network rm inception

show:
	docker ps
	docker volume ls -q
	docker container ls -q

see:
	docker logs wordpress
	docker logs mariadb
	docker logs nginx

# Commande pour nettoyer l'environnement Docker en supprimant également les données persistantes
fclean: clean
	@sudo rm -rf /home/juandrie/data/mariadb/*
	@sudo rm -rf /home/juandrie/data/wordpress/*
	@docker system prune -af

# Commande pour reconstruire l'environnement Docker à partir de zéro
re: fclean all

# Cibles spéciales qui ne correspondent pas à des fichiers réels
.PHONY: all clean fclean re
