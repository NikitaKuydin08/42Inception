# need to add a check and make sure that docker and docker compose are installed, otherwise install them

-include srcs/.env

TOOLS_DIR = ./srcs/requirements/tools
# srcs/.env:
# 	@bash ${TOOLS_DIR}/setup.sh
DOMAIN = ${DOMAIN_NAME}
PATH_COMPOSE = ./srcs/docker-compose.yml
COMPOSE = docker compose -f ${PATH_COMPOSE}
HOME_PATH = ${HOME}

.PHONY: all 
all: up

.PHONY: setup_secrets
setup_secrets:
	bash ${TOOLS_DIR}/setup.sh

# create required directories, DNS resolving
.PHONY: setup
setup:
	@if ! grep -q ${DOMAIN} "/etc/hosts"; then \
		echo "127.0.0.1       ${DOMAIN}" | sudo tee -a /etc/hosts > /dev/null; \
 	fi
	mkdir -p ${HOME_PATH}/data/wp_content
	mkdir -p ${HOME_PATH}/data/db_data

# Build everything to run the project
#	- rebuilds the image after the change of Dockerfile
#	- setting up the project for 1st time, builds images
#	- updated dependencies
.PHONY: build
build: setup
	${COMPOSE} build

# Bring up the development environment
.PHONY: up
up: setup
	${COMPOSE} up --detach

# Run the development server
.PHONY: start
start:
	${COMPOSE} start --wait

# Stop the external services
.PHONY: down
down:
	${COMPOSE} down

# status of services
.PHONY: status
status:
	${COMPOSE} ps -a

# Shut down and remove services
.PHONY: clean
clean:	
	-${COMPOSE} down -v --rmi all --remove-orphans
	-docker builder prune -af
	sudo rm -rf ${HOME_PATH}/data

# Shut down and remove services, as well as networks and volumes
.PHONY: fclean
fclean: clean
	-docker system prune -af --volumes
	sudo sed -i '/$(DOMAIN)/d' /etc/hosts

# clean up the project and launch from 0
.PHONY: re
re: fclean all