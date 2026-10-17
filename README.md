*This project has been created as part of the 42 curriculum by nkuydin.*

A “Description” section that clearly presents the project, including its goal and a
brief overview.
- A Project description section must also explain the use of Docker and the sources
included in the project. It must indicate the main design choices, as well as a
comparison between:
◦ Virtual Machines vs Docker
◦ Secrets vs Environment Variables
◦ Docker Network vs Host Network
◦ Docker Volumes vs Bind Mounts

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
 - [Dockerfiel instructions](https://docs.docker.com/reference/dockerfile/#exec-form)

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

## [Docker Compose](https://docs.docker.com/compose/)
 - 

Reset Everything -  docker compose down -v --rmi all --remove-orphans;
                    docker builder prune -af;
                    docker compose up