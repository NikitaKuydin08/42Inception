# User documentation
 
This document is for the people who use or administrate the website: no Docker knowledge is needed. Everything is run from the root folder of the repository.
 
## 1. What the stack(LEMP - Linux, EngineX, MariaDB/MySQL, PHP) provides
 
The project runs a WordPress website, split into three services. Each one lives in its own container.
 
| Service | What it does for you |
|---|---|
| **NGINX** | The only one service reachable from outside. It receives every visit over secure HTTPS (port 443) and passes it on. |
| **WordPress + PHP-FPM** | The website itself and its administration panel. |
| **MariaDB** | The database where WordPress stores its pages, posts, settings and users. |
 
## 2. Start and stop the project
 
| I want to... | Command |
|---|---|
| First time starting | `make setup_secrets` |
| Start everything - first time or after a stop | `make` / `make up`|
| Rebuild the interface/build interface without running | `make build` |
| Stop the website, **keeping** all the data | `make down` |
| Restart containers that were stopped | `make start` |
| See what is running | `make status` |
| Shut down and remove services | `make clean` |
| as well as networks and volumes | `make fclean` |
| clean up the project and launch from 0 | `make re` |
 
The first `make` takes a few minutes: the images are built and WordPress installs itself. Later starts are much faster.

`make up` - does not rebuilds images if they were changed after the first run, run `make re` instead.
 
The containers restart automatically after a crash or a reboot of the machine, unless you stopped them yourself.
 
> **Danger:** `make clean`, `make fclean` and `make re` **delete the website and the database** . Use them only to start again from zero.
 
## 3. Access the website and the administration panel
 
The site is available only through the domain name `nkuydin.42.fr` locally.
 
| Page | Address |
|---|---|
| Website | https://nkuydin.42.fr |
| Administration panel | https://nkuydin.42.fr/wp-admin |
 
- Use `https://`. Plain `http://` (port 80)-default nginx port is not available.
- The security certificate is self-signed, so the browser shows a warning the first time. This is expected: choose "Advanced", then continue to the site.
- Log in to the administration panel with the administrator account (see section 4).
## 4. Locate and manage credentials
 
All credentials are stored in the `secrets/` folder at the root of the repository. This folder is **never** committed to Git, and must stay private.
 
| File | Content |
|---|---|
| `secrets/wp_credentials.txt` | Title, the **root** account (`ADMIN_USER`, `ADMIN_PASS`, `ADMIN_EMAIL`) and a **second user** (`WP_USER`, `WP_PASS`, `WP_EMAIL`) |
| `secrets/db_credentials.txt` | Database name and the database accounts (`DB_NAME`, `DB_USER`, `DB_ROOT`, `DB_PASS`, `DB_MAIL`) |
 
To log in, use `ADMIN_USER` and `ADMIN_PASS` for the administrator, or `WP_USER` and `WP_PASS` for the second user.
 
Good to know:
- To change a WordPress password, log in and go to **Users → Profile**, then set a new password. This is the normal way, and it does not need a restart.
- The accounts are created **once**, the first time the project starts. Editing the secret files afterwards does **not** change the existing accounts. To apply new values from scratch, run `make re` (this erases all data).

## 5. Check that the services are running correctly
 
1. **Containers:** run `make status`. The three services (`mariadb`, `wordpress`, `nginx`) should be shown as running (`Up`).
2. **Website:** open https://nkuydin.42.fr. The WordPress site should load.
3. **Command line check:** `curl -kI https://nkuydin.42.fr` should answer with an HTTP status line (`200` or a redirect such as `301`/`302`).
4. **Logs**, if something looks wrong:
```sh
   docker logs -f nginx
   docker logs -f wordpress
   docker logs -f mariadb
```
The good outcome of the command above is an infinite loop meaning that the separate container/service is running, no error or warnings.
