FROM pttde/php:shopware6-7.4

RUN apk add --no-cache mysql-client nodejs-npm $PHPIZE_DEPS \
    && pecl install xdebug \
    && rm -rf /tmp/* /var/cache/apk/* \
    && cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN ln -s /app/psh.phar /usr/local/bin/psh
COPY shopware-dev.ini $PHP_INI_DIR/conf.d/shopware-dev.ini

WORKDIR /app
