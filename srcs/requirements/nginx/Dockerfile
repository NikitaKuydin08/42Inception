FROM debian:12

RUN apt update && apt -y upgrade && apt -y install nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/*.conf /etc/nginx/conf.d/

RUN mkdir -p /etc/nginx/certs/ && \
    openssl req -x509 -days 90 \
    -noenc \
    -newkey rsa \
    -keyout /etc/nginx/certs/nkuydin.42.fr.key \
    -out /etc/nginx/certs/nkuydin.42.fr.crt \
    -subj '/C=GB/ST=FU/L=Bkk/O=Gustavo/ON=Chicken/CN=nkuydin.42.fr/emailAddress=pablo@gmail.com'

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;"]