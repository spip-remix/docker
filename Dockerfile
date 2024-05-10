ARG PHP
ARG COMPOSER=2.7.6
FROM composer/composer:${COMPOSER}-bin AS composer
FROM mlocati/php-extension-installer:2 AS ext-installer
FROM php:${PHP}-cli-alpine AS base
COPY --from=composer /composer /usr/local/bin/composer
COPY --from=ext-installer /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions
ARG MAKE=4.4
ARG JQ=1.7
ARG EXTS="gd zip opcache mysqli"
ARG XDEBUG
ARG TOOLS
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    PATH="/root/.composer/vendor/bin:${PATH}" \
    XDEBUG_MODE=off \
    EXTS=${EXTS}

COPY spip.ini ${PHP_INI_DIR}/conf.d/docker-php-ext-spip.ini
RUN apk --no-cache add make=~${MAKE} jq=~${JQ} unzip git && \
    ln -s "${PHP_INI_DIR}/php.ini-development" "${PHP_INI_DIR}/php.ini" && \
    if [ "${XDEBUG}" != "0" ];then EXTS="xdebug-${XDEBUG} ${EXTS}"; fi && \
    install-php-extensions ${EXTS} && \
    pear config-set php_ini "$PHP_INI_DIR/php.ini" && \
    mkdir -p /root/.composer && \
    curl -s -o /root/.composer/keys.dev.pub https://composer.github.io/snapshots.pub && \
    curl -s -o /root/.composer/keys.tags.pub https://composer.github.io/releases.pub && \
    composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true && \
    composer global require --no-interaction --no-progress ${TOOLS} && \
    composer clear-cache
COPY Makefile /Makefile
COPY .jq /root/.jq
ENTRYPOINT [ "make", "-f", "/Makefile"]
CMD [ "help" ]

WORKDIR /build
