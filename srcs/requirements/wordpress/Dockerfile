FROM debian:12

RUN apt update && apt -y upgrade && apt install -y --no-install-recommends wget php8.2 \
    php8.2-fpm \
    php8.2-cli \
    php8.2-mysql \
    ca-certificates \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp --info && echo -e "\033[0;32mCLI installation succeeded\033[0m"

RUN sed -i '/listen = 127.0.0.1:9001/c\listen = 9000' /etc/php/8.2/fpm/pool.d/www.conf && \
    grep -q '^listen = 9000' /etc/php/8.2/fpm/pool.d/www.conf && echo -e "All good"

COPY ./conf/ /tools
RUN chmod +x /tools/configure_wp.sh

WORKDIR /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress

ENTRYPOINT [ "/bin/bash", "/tools/configure_wp.sh"]

CMD [ "/usr/sbin/php-fpm8.2", "-F" ]