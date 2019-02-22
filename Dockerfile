FROM php:7.2.2-apache

RUN apt-get update

#Reverse proxy
RUN apt-get install -y \
    libapache2-mod-jk \
    libapache2-mod-proxy-uwsgi \
    libapache2-mod-proxy-msrpc

#/etc/apache2/sites-enabled/000-default.conf state=absent

RUN a2enmod alias \
    && a2enmod ratelimit \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2enmod proxy_ajp \
    && a2enmod proxy_balancer \
    && a2enmod proxy_connect \
    && a2enmod proxy_express \
    && a2enmod proxy_ftp \
    && a2enmod proxy_html \
    && a2enmod proxy_http \
    && a2enmod proxy_scgi \
    && a2enmod proxy_wstunnel \
    && a2enmod ssl \
    && a2enmod vhost_alias \
    && a2enmod xml2enc 

RUN a2enmod auth_digest \
    && a2enmod authnz_ldap \
    && a2enmod ldap 


RUN a2enmod cache_disk \
    && a2enmod cache \
    && a2enmod file_cache

RUN a2enmod substitute \
    && a2enmod auth_form \
    && a2enmod session \
    && a2enmod request \
    && a2enmod session_cookie

#remove default site
RUN rm /etc/apache2/sites-enabled/000-default.conf

#SSH command
RUN apt-get install -y openssh-client

RUN usermod -s /bin/bash www-data

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /

RUN chmod 0755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

EXPOSE 443

CMD ["apache2-reverse-proxy"]
