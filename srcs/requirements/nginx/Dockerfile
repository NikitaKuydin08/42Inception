FROM debian:12

ARG DOMAIN_NAME

RUN apt update && apt -y upgrade && apt -y install nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/*.conf /etc/nginx/conf.d/
RUN sed -i "/DOMAIN_NAME/c\${DOMAIN_NAME}" /etc/nginx/*.conf

RUN mkdir -p /etc/nginx/certs/ && \
    openssl req -x509 -days 90 \
    -noenc \
    -newkey rsa \
    -keyout /etc/nginx/certs/${DOMAIN_NAME}.key \
    -out /etc/nginx/certs/${DOMAIN_NAME}.crt \
    -subj '/C=GB/ST=FU/L=Bkk/O=Gustavo/ON=Chicken/CN=${DOMAIN_NAME/emailAddress=pablo@gmail.com'

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;"]