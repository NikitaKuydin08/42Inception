#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then 
    echo "Initialising data directory..."
    
    chown -R mysql:mysql /var/lib/mysql

    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

extract_secret() {
    grep "^$1" /run/secrets/database | cut -d= -f2
}

DB_NAME=$(extract_secret DB_NAME)
DB_MAIL=$(extract_secret DB_MAIL)
DB_USER=$(extract_secret DB_USER)
DB_ROOT=$(extract_secret DB_ROOT)
DB_PASS=$(extract_secret DB_PASS)

if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
mysqld_safe --skip-networking &
sleep 5

/usr/bin/mysql << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE OR REPLACE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}'; # create or replace user with a new one if it exists 
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%'; #provide the user with user rights 
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${DB_ROOT}" shutdown
echo "Success: mariadb database [${DB_NAME}] is created and run"

fi

exec mysqld_safe