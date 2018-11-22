FROM php:7.2-fpm-alpine3.7
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash gettext-libs git gmp libgd libldap libxml2 mariadb-client-libs openssh-client"
ENV BUILD_DEPS="${PHPIZE_DEPS} freetype-dev gettext-dev gmp-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxml2-dev libxpm-dev mariadb-dev openldap-dev zlib-dev"
ENV PECL_EXTS="redis"
ENV PHP_EXTS="gd gettext gmp ldap mysqli pcntl pdo_mysql simplexml sockets"
RUN    apk update \
    && apk upgrade \
    && apk add --no-cache $RUN_DEPS \
    && apk add -t .build-deps $BUILD_DEPS \
    && docker-php-ext-install $PHP_EXTS \
    && pecl install -o -f $PECL_EXTS \
    && docker-php-ext-enable $PECL_EXTS \
    && pecl clear-cache \
    && apk del .build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=composer:1.7 /usr/bin/composer /usr/bin/composer
