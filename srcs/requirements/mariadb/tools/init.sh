#!/bin/bash

# root@bc9f9b8926a5:/var/lib/mysql/performance_schema# cat db.opt
# default-character-set=utf8mb3
# default-collation=utf8mb3_general_ci


if [ ! -d "/var/lib/mysql/mysql" ]; then 
    echo "Initialising data directory..."
    
    chown -R mysql:mysql /var/lib/mysql

    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

#db_credentials.txt
DB_NAME=inception
DB_USER='username'@'hostname'
DB_USER=nkuydin
DB_ROOT='root_password'
DB_PASS='p3l3meni'

# DB_ROOT=$(cat /run/secrets/db_credentials | )

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