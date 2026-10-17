#!/bin/bash

# configuration files(php-fpm) are located at /etc/php/8.2/fpm

# /var/lib/wordpress/wp-content/ 
#   root@caf88ac3cd42:/var/lib/wordpress/wp-content# ls -l
#   total 28
#   -rw-r--r-- 1 www-data www-data    28 Jan  8  2012 index.php
#   drwxr-xr-x 5 www-data www-data 12288 Oct  6 13:32 languages
#   drwxr-xr-x 2 www-data www-data  4096 Oct  6 13:32 plugins
#   drwxr-xr-x 2 www-data www-data  4096 Oct  6 13:32 themes
#   drwxr-xr-x 2 www-data www-data  4096 Oct 15  2025 uploads

# user and hostname are www-data

#db_credentials.txt
DB_NAME='inception'
DB_USER='nkuydin'
DB_ROOT='root_password'
DB_PASS='p3l3meni'
# wp_credentials.txt
URL='https://nkuydin.42.fr'
TITLE='INCEPTION'
ADMIN_USER='wordpress'
ADMIN_PASS='wordpress_pass'
ADMIN_EMAIL='wordpress@gmail.com'
# wordpress create user
WP_USER='wp_user'
WP_PASS='wp_pass'
WP_EMAIL='wp_email@gmail.com'
WP_USER_ROLE='editor'

pwd

wp core download --allow-root --locale=en_US --version='6.6'

wp core verify-checksums --allow-root --locale=en_US --version='6.6'

if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then 

echo -e "Creating wp-config.php..."

# touch /var/www/wordpress/wp-config.php

cat << EOF > /var/www/html/wordpress/wp-config.php
<?php
/**
 * The base configuration for WordPress
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Database table prefix
 * * ABSPATH
 */

/** The name of the database for WordPress */
define( 'DB_NAME', '${DB_NAME}' );
/** MySQL database username */
define( 'DB_USER', '${DB_USER}' );
/** MySQL database password */
define( 'DB_PASSWORD', '${DB_PASS}' );
/** MySQL hostname */
define( 'DB_HOST', 'mariadb' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );
/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', 'utf8mb4_general_ci' );

/** Activates Debugging mode to show PHP errors, warnings and notices. */
define( 'WP_DEBUG', true );
/** Logging Errors. */
define( 'WP_DEBUG_LOG', true );
/** Don't Display Errors on the WordPress page. */
define( 'WP_DEBUG_DISPLAY', false );

/** Wordpress Instance's Prefix for one single database. */
\$table_prefix = 'wp_';

define( 'WP_SITEURL', 'https://nkuydin.42.fr' );
/** Redirect the User, if subdomain doesn't exist. */
define( 'NOBLOGREDIRECT', 'https://nkuydin.42.fr' );

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) define( 'ABSPATH', __DIR__ . '/' );

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
EOF

echo -e "\033[0;32mSuccess - wp-config.php created\033[0m"

echo -e "Waiting for MariaDB to be ready..."
sleep 10

wp core install --allow-root \
                --url=$URL \
                --title=$TITLE \
                --admin_user=$ADMIN_USER \
                --admin_password=$ADMIN_PASS \
                --admin_email=$ADMIN_EMAIL

wp core version --allow-root && echo -e "\033[0;32mSuccess: WordPress installed successfully. \033[0m"

wp user create --allow-root $WP_USER $WP_EMAIL --user_pass=$WP_PASS --role=$WP_USER_ROLE

wp user list --allow-root
# [ "$(wp user list --allow-root | wc -l)" -eq 2 ] && echo -e "\033[0;32mTwo users created, wordpress set up\033[0m"

fi

exec $@