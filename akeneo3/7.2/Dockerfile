FROM php:7.2-fpm-alpine3.10
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="bash freetype git icu-libs imagemagick imagemagick-libs libgd libintl libjpeg-turbo libmagic libmcrypt libpng libwebp libxml2 libxpm libzip mariadb-connector-c openssh-client su-exec zlib" \
    BUILD_DEPS="${PHPIZE_DEPS} freetype-dev icu-dev imagemagick-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev libwebp-dev libxml2-dev libxpm-dev libzip-dev mariadb-connector-c-dev zlib-dev" \
    PECL_EXTS="apcu imagick mcrypt redis" \
    PHP_EXTS="bcmath exif gd intl mysqli pdo_mysql soap zip"
ENV PHP_JPEG_DIR="/usr" \
    PHP_PNG_DIR="/usr" \
    PHP_ZLIB_DIR="/usr" \
    PHP_WEBP_DIR="/usr" \
    PHP_INI_SCAN_DIR="/usr/local/etc/php/conf.d/:/usr/local/etc/php/conf-override.d/" \
    # fixes iconv
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so"

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community gnu-libiconv

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
    && pecl clear-cache \
    && apk del .build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*

COPY --from=composer:1.8 /usr/bin/composer /usr/bin/composer
