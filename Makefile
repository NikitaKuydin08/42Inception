# need to add a check and make sure that docker and docker compose are installed, otherwise install them

PATH_COMPOSE = ./srcs/docker-compose.yml
COMPOSE = docker compose -f ${PATH_COMPOSE}
# PATH_STORAGE = /home/nkuydin/data
PATH_STORAGE = /Users/nkuydin

.PHONY: all 
all: up

.PHONY: fclean
fclean: clean

.PHONY: re
re: fclean all

.PHONY: setup
setup:
	mkdir -p ${PATH_STORAGE}/data/wp_content
	mkdir -p ${PATH_STORAGE}/data/db_data

# creates everything and starts the services, builds images if required
.PHONY: up
up: setup
	${COMPOSE} up --detach

# stops and removes the containers and networks
.PHONY: down
down:
	${COMPOSE} down

.PHONY: clean
clean:
	${COMPOSE} down -v --rmi all --remove-orphans || true
	docker builder prune -af || true
