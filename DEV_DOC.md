<<<<<<< HEAD
Developer documentation
This file must describe how a developer can:
◦ Set up the environment from scratch (prerequisites, configuration files, secrets).
◦ Build and launch the project using the Makefile and Docker Compose.
◦ Use relevant commands to manage the containers and volumes.
◦ Identify where the project data is stored and how it persists.
=======
# Developer documentation
 
This document explains how to set the project up from scratch, build it, manage it, and where its data lives. For the project overview and design choices, see [README.md](README.md). For day-to-day usage, see [USER_DOC.md](USER_DOC.md).
 
## 1. Set up the environment from scratch
 
### Prerequisites
 
- A Linux virtual machine with `make`, `sudo`, **Docker** and the **Docker Compose plugin** (`docker compose version` must work). The Makefile does not install them.
- The Docker daemon running, and your user allowed to run `docker` without `sudo` (member of the `docker` group). `sudo` is only used by the Makefile to edit `/etc/hosts` and to delete the data folder.
### Repository layout
 
```
.
├── Makefile                      # entry point
├── secrets/                      # credentials (created locally, ignored by Git)
│   ├── db_credentials.txt
│   └── wp_credentials.txt
└── srcs/
    ├── docker-compose.yml        # services, network, volumes, secrets
    ├── .env                      # local variables (ignored by Git)
    └── requirements/
        ├── mariadb/              # Dockerfile, conf/50-server.cnf, tools/init.sh
        ├── wordpress/            # Dockerfile, conf/configure_wp.sh
        ├── nginx/                # Dockerfile, conf/nkuydin-nginx.conf
        └── tools/setup.sh        # generates the secret templates
```
 
All the images are built from `debian:12`, and each service has its own Dockerfile.
 
### Configuration files and secrets
 
`secrets/` and `srcs/.env` are listed in `.gitignore`, so they do not exist after a fresh clone. Generate the secret templates, then fill them in:
 
```sh
make setup_secrets
```
 
> `make setup_secrets` **overwrites** the two files. Run it only once, or you lose the values already filled in.
 
Format: one `KEY=value` per line, no quotes, no spaces around `=`.
 
| File | Keys |
|---|---|
| `secrets/wp_credentials.txt` | `URL` (`https://nkuydin.42.fr`), `TITLE` (a single word), `ADMIN_USER`, `ADMIN_PASS`, `ADMIN_EMAIL`, `WP_USER`, `WP_PASS`, `WP_EMAIL`, `WP_ROLE` |
| `secrets/db_credentials.txt` | `DB_NAME`, `DB_USER`, `DB_ROOT` (root password), `DB_PASS`, `DB_MAIL` |
 
- `ADMIN_USER` must not contain `admin` or `administrator` (in any case).
- Compose declares them as the secrets `wordpress` and `database` (`srcs/docker-compose.yml`). Inside the containers they appear as `/run/secrets/wordpress` and `/run/secrets/database`, and the entrypoint scripts read the values from there at start-up. No password is written in a Dockerfile or in the image.
- The `wordpress` container receives both secrets, `mariadb` receives only `database`, and `nginx` receives none.
### Domain name
 
The domain `nkuydin.42.fr` is defined in three places, which must be changed together if the login changes: `DOMAIN` in the `Makefile`, `server_name` in `srcs/requirements/nginx/conf/nkuydin-nginx.conf`, and `URL` in `secrets/wp_credentials.txt`. `make setup` adds it to `/etc/hosts` pointing to `127.0.0.1`.
 
## 2. Build and launch
 
```sh
make
```
 
This runs two steps:
 
1. `make setup`: adds the domain to `/etc/hosts` if missing, and creates `~/data/db_data` and `~/data/wp_content`. These folders must exist **before** Compose starts, because the volumes point to them.
2. `docker compose -f srcs/docker-compose.yml up --detach`: builds the missing images, creates the network and the volumes, and starts the containers.
The same thing by hand:
 
```sh
mkdir -p ~/data/db_data ~/data/wp_content
docker compose -f srcs/docker-compose.yml build
docker compose -f srcs/docker-compose.yml up --detach
```
 
### Makefile targets
 
| Target | Effect |
|---|---|
| `make` / `make up` | `setup`, then build (if needed) and start everything in the background |
| `make build` | `setup`, then rebuild the images (after changing a Dockerfile or a config file) |
| `make start` | Start the existing containers and wait for them |
| `make down` | Stop and remove the containers and the network. Volumes and data are **kept** |
| `make status` | `docker compose ps -a` |
| `make setup` | Domain in `/etc/hosts` and data folders |
| `make setup_secrets` | Generate the empty secret templates |
| `make clean` | `down -v --rmi all --remove-orphans`, prune the build cache, delete `~/data`. **Erases all data** |
| `make fclean` | `clean`, then `docker system prune -af --volumes` (everything unused on the Docker host) and remove the domain from `/etc/hosts` |
| `make re` | `fclean`, then `all` |
 
## 3. Manage containers and volumes
 
```sh
# containers
docker compose -f srcs/docker-compose.yml ps -a                 # state of the services
docker compose -f srcs/docker-compose.yml logs -f wordpress     # follow the logs of one service
docker compose -f srcs/docker-compose.yml restart nginx         # restart one service
docker compose -f srcs/docker-compose.yml up -d --build nginx   # rebuild and relaunch one service
docker exec -it mariadb bash                                    # shell in a container
docker exec nginx nginx -t                                      # test the NGINX configuration
 
# database (prompts for the root password, DB_ROOT)
docker exec -it mariadb mariadb -u root -p
 
# volumes and network
docker volume ls
docker volume inspect srcs_db_data
docker network ls
docker network inspect srcs_default
```
 
Compose prefixes the resource names with the project name, which is `srcs` here (the folder of the Compose file). That is why the volumes are `srcs_db_data` and `srcs_wp_content`, and the network is `srcs_default`.
 
Useful checks of the requirements:
 
```sh
openssl s_client -connect nkuydin.42.fr:443 -tls1_3 </dev/null   # works
openssl s_client -connect nkuydin.42.fr:443 -tls1_2 </dev/null   # must fail: TLSv1.3 only
curl -I http://nkuydin.42.fr                                      # must fail: port 80 is not open
docker kill mariadb && sleep 5 && docker ps                       # restarted by Docker?
```
 
## 4. Where the data is stored and how it persists
 
| Volume | Used by | Path in the container | Path on the host |
|---|---|---|---|
| `db_data` | `mariadb` | `/var/lib/mysql/` | `~/data/db_data` |
| `wp_content` | `wordpress`, `nginx` | `/var/www/html/wordpress` | `~/data/wp_content` |
 
`~` is the home directory of the user running `make` (`/home/<login>`). The `wp_content` volume is shared: WordPress writes the site files, and NGINX reads them to serve the static content.
 
Both are Docker **named volumes**, declared in `docker-compose.yml` with the `local` driver and `driver_opts` (`type: none`, `o: bind`, `device: $HOME/data/...`). Docker manages them as volumes, while their content is stored in the chosen host folder.
 
What happens to the data:
 
| Action | Data (`~/data`) |
|---|---|
| Container crash, `restart`, `make start` | kept |
| `make down`, reboot of the machine | kept |
| `make build` / rebuilding an image | kept |
| `make clean`, `make fclean`, `make re` | **deleted** |
 
Since the data lives outside the containers and images, a container can be destroyed and recreated without losing the database or the website files. The first start initialises the database and installs WordPress from the secrets; the following starts reuse the data that is already there. Files in `~/data` are owned by the users of the containers (for example `mysql`, `www-data`), which is why the Makefile uses `sudo rm -rf` to delete them.
>>>>>>> 1ee3f9b (Left: Revise Documentation, Final Check at VM, THEORY, THEORY)
