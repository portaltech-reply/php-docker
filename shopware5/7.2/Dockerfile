FROM php:7.2-fpm-alpine3.8
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash freetype git icu-libs libgd libintl libjpeg-turbo libpng libwebp libxml2 libxpm libzip mariadb-connector-c openssh-client postgresql-libs zlib" \
    BUILD_DEPS="${PHPIZE_DEPS} freetype-dev icu-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxml2-dev libxpm-dev libzip-dev mariadb-connector-c-dev postgresql-dev zlib-dev" \
    PECL_EXTS="redis" \
    PHP_EXTS="gd iconv intl mysqli pdo_mysql pdo_pgsql soap zip"
ADD docker-php-update-conf /usr/local/bin/
ENV PHP_JPEG_DIR="/usr" \
    PHP_PNG_DIR="/usr" \
    PHP_ZLIB_DIR="/usr" \
    PHP_WEBP_DIR="/usr"

# fixes iconv 
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv

RUN    apk update \
    && apk upgrade \
    && apk add --no-cache $RUN_DEPS \
    && apk add -t .build-deps $BUILD_DEPS \
    && if [ -z "$(echo "$PHP_EXTS" |sed '/^gd\| gd/d')" ]; then docker-php-ext-configure gd \
        --with-freetype-dir=/usr \
        --with-xpm-dir=/usr \
        --enable-gd-native-ttf \
        --enable-gd-jis-conv ; fi \
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
