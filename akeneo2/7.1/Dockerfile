FROM php:7.1-fpm-alpine3.8
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash freetype git icu-libs imagemagick imagemagick-libs libgd libintl libjpeg-turbo libmagic libmcrypt libpng libwebp libxml2 libxpm mariadb-connector-c openssh-client zlib"
ENV BUILD_DEPS="${PHPIZE_DEPS} freetype-dev icu-dev imagemagick-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev libwebp-dev libxml2-dev libxpm-dev mariadb-connector-c-dev zlib-dev"
ENV PECL_EXTS="apcu imagick redis"
ENV PHP_EXTS="bcmath exif gd intl mcrypt mysqli pdo_mysql soap zip"
ADD docker-php-update-conf /usr/local/bin/

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
    && chmod +x /usr/local/bin/docker-php-update-conf \
    && mkdir /usr/local/etc/php/conf-override.d/ \
    && sed -i -e 's!exec "$@"!inotifyd docker-php-update-conf /usr/local/etc/php/conf-override.d/:cewDMymnd \&\nsleep 1\ndocker-php-update-conf\n\nexec "$@"!' /usr/local/bin/docker-php-entrypoint \
    && pecl clear-cache \
    && apk del .build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*

COPY --from=composer:1.8 /usr/bin/composer /usr/bin/composer
