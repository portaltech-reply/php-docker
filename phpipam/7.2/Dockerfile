FROM php:7.2-fpm-alpine3.8
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash freetype gettext-libs git gmp libgd libjpeg-turbo libldap libpng libwebp libxml2 libxpm mariadb-connector-c openssh-client zlib"
ENV BUILD_DEPS="${PHPIZE_DEPS} freetype-dev gettext-dev gmp-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxml2-dev libxpm-dev mariadb-connector-c-dev openldap-dev zlib-dev"
ENV PECL_EXTS="redis"
ENV PHP_EXTS="gd gettext gmp ldap mysqli pcntl pdo_mysql simplexml sockets"
RUN    apk update \
    && apk upgrade \
    && apk add --no-cache $RUN_DEPS \
    && apk add -t .build-deps $BUILD_DEPS \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) $PHP_EXTS \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && pecl channel-update pecl.php.net \
    && pecl install -o -f $PECL_EXTS \
    && docker-php-ext-enable $PECL_EXTS \
    && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && mkdir /usr/local/etc/php/conf-override.d/ \
    && sed -i -e 's|exec "$@"|cp /usr/local/etc/php/conf-override.d/* /usr/local/etc/php/conf.d/\n\nexec "$@"|' /usr/local/bin/docker-php-entrypoint \
    && pecl clear-cache \
    && apk del .build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=composer:1.8 /usr/bin/composer /usr/bin/composer
