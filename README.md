*This project has been created as part of the 42 curriculum by nkuydin.*

## DESCRIPTION
The goal of this project is to set up a small infrastructure composed of different services under specific rules, inside a virtual machine. 
This project aims to broaden the student's knowledge of system administration: building images from scratch, isolating services, wiring them together through the private network, persisting data, and handling the environment variables and secrets properly, securely. 

The stack (LEMP) is made of 3 services, each running in its own dedicated container and build from its own Dockerfile(no ready made images from DockerHub, except of base image like Debian can be used). More on the description of configured services at [USER_DOC.md](./USER_DOC.md).  
The configuration of the named volumes is required to persist the data: one for the WordPress Database and one for the WordPress Website Files. This data is stored on the host machine in **$HOME/data/** . A Default Docker Network connects the 3 containers, and all containers restart automatically afetr a crash.    
The website is reachable at https://nkuydin.42.fr, a domain name is configured so that it points to local IP address (127.0.0.1) of the virtual machine. 

### A Project description
**Docker** is a tool that is used for containerization - packaging an application together with its dependencies into an image, which is run as an isolated container. 
The whole infrastucture is run by one file basically - srcs/docker-compose.yml and the Makefile wraps it in short commands to build, start and stop easily. 

| Source | Role |
|---|---|
| `Makefile` | entry point, builds images, calls `docker compose` |
| srcs/docker-compose.yml` | services, network, volumes, secrets |
| `srcs/requirements/<service>/` | one Dockerfile per service, plus its `conf/` and `tools/` (entrypoint scripts) |
| `secrets/` | passwords and credentials, ignored by Git |
| `srcs/.env` | non-sensitive variables, ignored by Git |

**Design choices**
- **Base image:** `debian:12`.
- **One service per container,** running as PID 1: each container runs its daemon in the foreground (nginx -g "daemon off;", php-fpm -F, mariadbd), launched with exec from the entrypoint scripts
- **TLS:** NGINX accepts TLSv1.3 only, with a self-signed certificate. Port 443 is the only one published to the host.
- **Users:** WordPress has two, an administrator (no "admin" in the name) and a regular one.
- **Credentials:** passwords sit in Docker secrets, nothing confidential is written in a Dockerfile or committed to Git.
- **Crashes:** `restart: unless-stopped` on every service.

### Comparisons     

| | Virtual machine | Docker container |
|---|---|---|
| Defintion | Virtualisation of an entire machine (server) emulating the hardware components, such as the CPU, memory, NIC; Full OS | Open-Source Container platform; Container has its own file system, dependency structure, processes, network; Shares the underlying host OS kernel resources.
| Objective | To allow users to create a virtual environment that's isolated from the underlying software. | To provide a lightweight and portable way to package and run applications in an isolated environment. 
| The Use | Used in deploying possibly unsecure applications; Allows the use of hardware resources more efficiently. | Ease managing of software environment updates and maintaining environment consistency everywhere. Addresses the challenge of deploying applications across different environments. 
| Isolation | Strong - Higher security. As a VM runs an entire operating system on top of Hypervisor. | lighter (namespaces for what it sees, cgroups for what it uses) |
| Weight | gigabytes, boots in minutes | megabytes, starts in seconds |

|.|.|.|
|-|-|-|
|.|.|.|

| | Environment variables | Docker secrets |
|---|---|---|
| Suitable For | Non-Sensitive data(domain name, database names) | Passwords & credentials. Data that can't be exposed to public and hackers |
| Exposed By | `docker compose -f srcs/docker-compose.yml config` ; `docker history --no-trunc <image_name/id>` ; can be leaked in logs | Accessible only to authorized services, are never part of the image |
| Stored | in the container's environment | mounted temporarily inside the container as files (in /run/secrets/<name>) |

|.|.|.|
|-|-|-|
|.|.|.|

| | Docker Network (bridge)| Host Network |
|---|---|---|
| Common Use | Application runs in a container that needs to communicate with other containers on the same host. | Container needs to handle a large range of ports. |
| Isolation | Complete. The container is hidden behind the virtual network interface. | None. Uses the host's networking directly. |
| Ports Management | Requires port mapping (8080:80). Multiple containers can use same internal port 80 by mapping them to different host ports. | No NAT overhead. Ports are taken directly from host. All the ports should be unique. |
| Inside->Outside World | Only the ports explicitly published, like nginx, are reachable from outside. | Every port the container opens is exposed |
| Communication bw services | Access each other by name or alises. | Talk over real port numbers/localhost, no built-in DNS Resolver |

|.|.|.|
|-|-|-|
|.|.|.|

| | Named volume | Bind mount |
|---|---|---|
|Created By | Docker (by default under /var/lib/docker/volumes/) | Managed by User |
| Depends on Host Storage | No. Independent | Yes. Maps an existing host path in the container, which depends on the host's file structure and rights. |
| Behaviour on creation(first time) | Copies data from the container to the volume, used for databases. | Overwrites container's data, the host's folder completely overshades contents inside container. |
| The Use | Can be shared between containers easily. | When user needs data to be stored in the specific and comfortable folder on the host machine. |
| Named Volumes with an driver_option: bind | Hybrid Mode(Our Case). Docekr cretaes a named Volume, but phusically saves data on the mentioned host's folder. | (N/A) |

## INSTRUCTIONS

1. Clone the repository and move into it:
```sh
   git clone <repository-url> 42Inception && cd 42Inception
```

2. Generate the secret templates and .env-file, then fill in every value in `secrets/db_credentials.txt` and `secrets/wp_credentials.txt` (the keys and rules are listed in [DEV_DOC.md](DEV_DOC.md)). These files are ignored by Git, and `make setup_secrets` overwrites them, so run it only once:
```sh
   make setup_secrets
```

3. Build and start the whole infrastructure (this also adds `nkuydin.42.fr` to `/etc/hosts` and creates the data folders in `~/data`):
```sh
   make
```

4. Open https://nkuydin.42.fr (accept the self-signed certificate warning). The administration panel is at https://nkuydin.42.fr/wp-admin.

### Additional Information

Stop the project with `make down` (data is kept). `make clean`, `make fclean` and `make re` also **delete all the data**.

- [USER_DOC.md](USER_DOC.md): using and administrating the website (services, start/stop, access webiste and administration, credentials, checks).
- [DEV_DOC.md](DEV_DOC.md): prerequisites, environment setup, Makefile rules, docker commands, how does the data persists.

## RESOURCES

### General (I guess)
 - [How containers like Docker work under the hood - Namespaces & Cgroups](https://blog.nginx.org/blog/what-are-namespaces-cgroups-how-do-they-work)
 - [Understanding Cgroups and Namespaces in Linux: The Foundations of Containerization](https://medium.com/@ozbillwang/understanding-cgroups-and-namespaces-in-linux-the-foundations-of-containerization-e0e565eb236e)
 - [Docker vs Virtual Machine (VM) – Key Differences You Should Know](https://www.freecodecamp.org/news/docker-vs-vm-key-differences-you-should-know/)
 - [The Docker Ecosystem: An Introduction to Common Components](https://www.digitalocean.com/community/tutorials/the-docker-ecosystem-an-introduction-to-common-components)
 - [Best Practices - dockerfile](https://docs.docker.com/build/building/best-practices/)
 - [The Ultimate Guide and Resource Page For Docker](https://habib-mote.gitbook.io/learn-docker-fast/)
 - [Dockerfile instructions](https://docs.docker.com/reference/dockerfile/#exec-form)
 - [Domain does not exit error - DNS_PROBE_FINISHED_NXDOMAIN](https://developers.cloudflare.com/dns/troubleshooting/dns-probe-finished-nxdomain/)
 - [How to fix the problem above](https://www.plesk.com/blog/various/dns-probe-finished-nxdomain-what-is-it-and-how-to-fix-the-problem/)
 - [Define and manage networks in Docker Compose](https://docs.docker.com/reference/compose-file/networks/)
 - [Rebuild separate service using docker-compose](https://stackoverflow.com/questions/36884991/how-to-rebuild-docker-container-in-docker-compose-yml)
 - [Docker Compose Commands: Understanding 'up -d' vs 'up --build'](https://dev.to/yuvraajsj18/docker-compose-commands-understanding-up-d-vs-up-build-3bb4)

### Haven't looked into it
 - [Docker compose - LEMP stack](https://stackoverflow.com/questions/39678099/docker-compose-php-fpm-nginx-mysql-and-use-wp-cli-on-nginx)
 - [Reasons Why Containers can't talk to each other](https://maximorlov.com/4-reasons-why-your-docker-containers-cant-talk-to-each-other/?fbclid=IwAR3Q3VUS9wqJtE2fhbpFYOUD9jKw1p1Ajn10jTR6dbUP_rXkbyP2T2aUtmU)
 - [Manage Secrets Securely in Docker Compose](https://docs.docker.com/compose/how-tos/use-secrets/)

### [NGINX](https://nginx.org)

 - [SSL/TLS Protocol, Certificate.](https://aws.amazon.com/what-is/ssl-certificate/)
 - [Whats the difference between OpenSSL and LetsEncrypt?](https://stackoverflow.com/questions/44850725/whats-the-difference-between-openssl-and-letsencrypt)
 - [TLS/SSL, certificates, version, openssl](https://docs.openssl.org/master/man7/ossl-guide-tls-introduction/)
 - [Openssl -req => creation of the self-signed certificate](https://docs.openssl.org/master/man1/openssl-req/#name)
 - [Docker Best Practices: Choosing Between RUN, CMD, and ENTRYPOINT](https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/)
 - [PHP site configuration, server, location in NGINX's .conf file](https://nginx.org/en/docs/http/request_processing.html)
 - [*BEST* Serve static Content *FOR* NGING Configuration](https://docs.nginx.com/nginx/admin-guide/web-server/serving-static-content/)
 - [Directives(set of rules), Embedded Variables, Every keyword for config file](https://nginx.org/en/docs/http/ngx_http_core_module.html)
 - [Directives(set of rules) for PHP-FPM server block configuration, passing requests to a FastCGI server.](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
 - [FastCGI protocol that defines how web server communicates with web application](https://www.reddit.com/r/webdev/comments/ulvk8/can_anyone_explain_like_i_am_5_what_is_fastcgi/)
 - [Location Directive in config - web server routing traffic correctly](https://www.digitalocean.com/community/tutorials/nginx-location-directive)
 - [Basic Understanding of The NGINX Configuration file Structure](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)
 - [Configure nginx PHP-FPM](https://linuxcapable.com/how-to-configure-nginx-php-fpm/#use-nginx-php-fpm-for-front-controller-applications)

### [MariaDB Documentation](https://mariadb.com/docs)
 - [docker health check](https://www.dash0.com/guides/docker-health-check-a-practical-guide)
 - [Configuring optional("configuration") files](https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/configuring-mariadb/configuring-mariadb-with-option-files)
 - [Starting MariaDB Server](https://dev.mysql.com/doc/mysql-security-excerpt/5.7/en/starting-server.html)
 - [CREATE USER](https://www.ionos.com/digitalguide/hosting/technical-matters/mariadb-create-user/)
 - [Setting up mariaDB server](https://dev.to/waji97/setting-up-a-mariadb-server-4meh)
 - [Ways to stop MySQL after running it using mysqld_safe?](https://stackoverflow.com/questions/53086514/how-to-stop-mysql-after-running-it-using-mysqld-safe)
 - [Another configuration of MariaDB website](https://docs.webdock.io/how-guides/database-guides/how-enable-remote-access-your-mariadbmysql-database/)

### [WordPress](https://developer.wordpress.org)
 - [Some PHP-FPM explanation](https://serversideup.net/open-source/docker-php/docs/image-variations/fpm)
 - [Setting up Wordpress through the terminal using WP-CLI(command line tool)](https://dev.to/kushang_tailor/wp-cli-the-terminal-way-to-wordpress-part-1-1lb6)
 - [Connecting Database mariadb to Wordpress/wp-config.php](https://blogvault.net/editing-wp-config-php/)
 - [The online Manual for Wordpress - Information and Documentation](https://codex.wordpress.org/Main_Page)
 - [Editing wp-config.php, websites's base configuration - database connection. Advanced options](https://developer.wordpress.org/advanced-administration/wordpress/wp-config/)
 - [Absolute Path To WordPress directory](https://www.pontikis.net/blog/what-is-abspath-in-wordpress-and-how-to-use-for-security#google_vignette)
 - [Master wp-config.php: A Comprehensive Guide](https://www.liquidweb.com/blog/wordpress-wp-config-php-file-explained/)
 - [Installing WP-CLI](https://make.wordpress.org/cli/handbook/guides/installing/)
 - [FS_METHOD - filesystem access methods for installing and updating plugins and themes](https://docs.mainwp.com/customization/required-fs_method)
 - [Installing WordPress using WP-CLI](https://www.liquidweb.com/help-docs/cms/wordpress/installing-wordpress-using-wp-cli/)
 - [Create wordpress User using wp-cli](https://blogvault.net/wp-cli-create-user/)
 - [*BEST* Complete Information on WP_CLI](https://www.liquidweb.com/wordpress/wp-cli/)
 - [wprdpress.org - man 'wp user create'](https://developer.wordpress.org/cli/commands/user/create/)
 - [30 wordpress errors, and how to solve them](https://blogvault.net/wordpress-errors/)
 - [What is in PHP-FPM configuration file?](https://dev.to/takahiro_82jp/what-is-in-php-fpm-configuration-file-2na6)
 - [WordPress with WP-CLI](https://pantheon.io/learning-center/wordpress/install-with-wp-cli)

## Use Of AI
 - AI have been used heavily to understand the difference between some aspects of the subject. Documentation was half written with AI, but have been extensively revised and changed to human, readable language. 
 - It was used for the shell scripting, and understanding bash scripts. As well as translation of some Inception guides. 
