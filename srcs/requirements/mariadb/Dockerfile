FROM debian:12

RUN apt update && apt -y upgrade && apt -y install --no-install-recommends mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/mysqld/ && chmod 777 /var/run/mysqld

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/init.sh /tmp/init.sh

# COPY ./tools/extract_secret.sh /tmp/extract_secret.sh

RUN chmod +x /tmp/init.sh

EXPOSE 3306

HEALTHCHECK --interval=2m --timeout=30s --start-period=30s --retries=1 \
    CMD mariadb -u root -p"root_password" -e 'SELECT @@datadir;' || exit 1

ENTRYPOINT [ "/bin/bash", "/tmp/init.sh" ]
