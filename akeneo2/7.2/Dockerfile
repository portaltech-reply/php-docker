FROM php:7.2-fpm-alpine3.7
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash git icu-libs imagemagick imagemagick-libs libgd libintl mariadb-client-libs openssh-client"
ENV BUILD_DEPS="${PHPIZE_DEPS} freetype-dev icu-dev imagemagick-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxpm-dev mariadb-dev zlib-dev"
ENV PECL_EXTS="apcu imagick redis"
ENV PHP_EXTS="gd intl mysqli pdo_mysql"
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
