FROM php:7.1-fpm-alpine3.7
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash git icu-libs libintl mariadb-client-libs openssh-client postgresql-libs"
ENV BUILD_DEPS="${PHPIZE_DEPS} icu-dev mariadb-dev postgresql-dev"
ENV PECL_EXTS="redis"
ENV PHP_EXTS="intl mysqli pdo_mysql pdo_pgsql"
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
