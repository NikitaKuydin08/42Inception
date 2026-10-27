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
| `srcs/docker-compose.yml` | services, network, volumes, secrets |
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

Comparisons     

| | Virtual machine | Docker container |
|---|---|---|
| Defintion | Virtualisation of an entire machine (server) emulating the hardware components, such as the CPU, memory, NIC; Full OS | Open-Source Container platform; Container has its own file system, dependency structure, processes, network; Shares the underlying host OS kernel resources.
| Objective | To allow users to create a virtual environment that's isolated from the underlying software. | To provide a lightweight and portable way to package and run applications in an isolated environment. 
| The Use | Used in deploying possibly unsecure applications; Allows the use of hardware resources more efficiently. | Ease managing of software environment updates and maintaining environment consistency everywhere. Addresses the challenge of deploying applications across different environments. 
| Isolation | Strong - Higher security. As a VM runs an entire operating system. | lighter (namespaces for what it sees, cgroups for what it uses) |
| Weight | gigabytes, boots in minutes | megabytes, starts in seconds |

Virtual Machines vs Docker

A virtual machine emulates a full computer: a hypervisor runs a complete guest operating system with its own kernel on virtualised hardware. This gives strong isolation but is heavy (gigabytes of disk, minutes to boot, significant RAM overhead). A Docker container is only an isolated process (or group of processes) that shares the host's kernel; isolation is obtained with Linux namespaces (what the process can see) and cgroups (how much it can use). Containers are small, start in seconds and are easy to reproduce, but the isolation is weaker than a VM since the kernel is shared. In this project, the VM provides the host environment, and Docker is used inside it to run each service in a lightweight, reproducible unit.

Secrets vs Environment Variables

Environment variables are simple and convenient, which makes them suitable for non-sensitive configuration (domain name, database name, usernames). However, they are easily exposed: they appear in docker inspect, in /proc/<pid>/environ, are inherited by child processes and can leak into logs or crash reports. Docker secrets are mounted inside the container as files (in /run/secrets/<name>), are only given to the services that explicitly request them, and are never part of the image or its metadata. This project uses secrets for passwords and credentials and environment variables (.env) for the rest.

Docker Network vs Host Network

With a user-defined Docker (bridge) network, containers get their own network namespace and private IP addresses, can reach each other by service name thanks to Docker's built-in DNS (e.g. wordpress reaches mariadb:3306), and only the ports explicitly published are reachable from outside. With the host network (network: host), the container shares the host's network stack: there is no isolation, ports can collide with host services, and every port the container opens is exposed. The host network (and links) is forbidden here; a dedicated Docker network is used so that only nginx is exposed, on port 443.

Docker Volumes vs Bind Mounts

A named volume is created and managed by Docker (by default under /var/lib/docker/volumes/), is independent of the host's directory layout, can be shared between containers and handled through the docker volume commands. A bind mount directly maps an existing host path into the container, which depends on the host's file structure and permissions. Bind mounts are convenient for development but less portable. This project uses named volumes (as required), configured with the local driver so that their data is stored in /home/<login>/data on the host while still being real Docker named volumes.

• An “Instructions” section containing any relevant information about compilation,
installation, and/or execution.

• A “Resources” section listing classic references related to the topic (documen-
tation, articles, tutorials, etc.), as well as a description of how AI was used —
specifying for which tasks and which parts of the project.

## General (I guess)
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

## Haven't looked into it
 - [Docker compose - LEMP stack](https://stackoverflow.com/questions/39678099/docker-compose-php-fpm-nginx-mysql-and-use-wp-cli-on-nginx)
 - [Reasons Why Containers can't talk to each other](https://maximorlov.com/4-reasons-why-your-docker-containers-cant-talk-to-each-other/?fbclid=IwAR3Q3VUS9wqJtE2fhbpFYOUD9jKw1p1Ajn10jTR6dbUP_rXkbyP2T2aUtmU)
 - [Manage Secrets Securely in Docker Compose](https://docs.docker.com/compose/how-tos/use-secrets/)

## NGINX

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

## [MariaDB Documentation](https://mariadb.com/docs)
 - [docker health check](https://www.dash0.com/guides/docker-health-check-a-practical-guide)
 - [Configuring optional("configuration") files](https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/configuring-mariadb/configuring-mariadb-with-option-files)
 - [Starting MariaDB Server](https://dev.mysql.com/doc/mysql-security-excerpt/5.7/en/starting-server.html)
 - [CREATE USER](https://www.ionos.com/digitalguide/hosting/technical-matters/mariadb-create-user/)
 - [Setting up mariaDB server](https://dev.to/waji97/setting-up-a-mariadb-server-4meh)
 - [Ways to stop MySQL after running it using mysqld_safe?](https://stackoverflow.com/questions/53086514/how-to-stop-mysql-after-running-it-using-mysqld-safe)
 - [Another configuration of MariaDB website](https://docs.webdock.io/how-guides/database-guides/how-enable-remote-access-your-mariadbmysql-database/)

## [WordPress](https://developer.wordpress.org)
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

Reset Everything -  docker compose down -v --rmi all --remove-orphans;
                    docker builder prune -af;
                    docker compose up
