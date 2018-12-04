FROM php:7.2-fpm-alpine3.7
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash git icu-libs libintl mariadb-client-libs openssh-client"
ENV BUILD_DEPS="${PHPIZE_DEPS} icu-dev mariadb-dev zlib-dev"
ENV PECL_EXTS="apcu redis"
ENV PHP_EXTS="intl mysqli pdo_mysql zip"
RUN    apk update \
    && apk upgrade \
    && apk add --no-cache $RUN_DEPS \
    && apk add -t .build-deps $BUILD_DEPS \
    && docker-php-ext-install $PHP_EXTS \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && pecl install -o -f $PECL_EXTS \
    && docker-php-ext-enable $PECL_EXTS \
    && pecl clear-cache \
    && apk del .build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=composer:1.7 /usr/bin/composer /usr/bin/composer
