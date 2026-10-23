#!/bin/bash

mkdir -p ./secrets/ && cd ./secrets/

cat << EOF > wp_credentials.txt
# setting the wordpress up, creating root user
URL=
TITLE=
ADMIN_USER=
ADMIN_PASS=
ADMIN_EMAIL=

# creating second user for wordpress
WP_USER=
WP_PASS=
WP_EMAIL=
WP_ROLE=
EOF

cat << EOF > db_credentials.txt
DB_NAME=
DB_USER=
DB_ROOT=
DB_PASS=
DB_MAIL=
EOF

cat << EOF > ./srcs/.env
DOMAIN_NAME=
EOF