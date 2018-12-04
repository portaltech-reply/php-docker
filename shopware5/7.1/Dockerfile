FROM php:7.1-fpm-alpine3.7
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash freetype git icu-libs libgd libintl libjpeg-turbo libpng libwebp libxml2 libxpm mariadb-client-libs openssh-client postgresql-libs zlib"
ENV BUILD_DEPS="${PHPIZE_DEPS} freetype-dev icu-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxml2-dev libxpm-dev mariadb-dev postgresql-dev zlib-dev"
ENV PECL_EXTS="redis"
ENV PHP_EXTS="gd intl mysqli pdo_mysql pdo_pgsql soap zip"
RUN    apk update \
    && apk upgrade \
    && apk add --no-cache $RUN_DEPS \
    && apk add -t .build-deps $BUILD_DEPS \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) $PHP_EXTS \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && pecl channel-update pecl.php.net \
    && pecl install -o -f $PECL_EXTS \
    && docker-php-ext-enable $PECL_EXTS \
    && pecl clear-cache \
    && apk del .build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=composer:1.7 /usr/bin/composer /usr/bin/composer
