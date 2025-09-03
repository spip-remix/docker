ARG PHP=8.4.12
ARG COMPOSER=2.8.11
FROM composer/composer:${COMPOSER}-bin AS composer
FROM mlocati/php-extension-installer:2 AS ext-installer
FROM php:${PHP}-cli-alpine AS base
COPY --from=composer /composer /usr/local/bin/composer
COPY --from=ext-installer /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions
ARG MAKE=4.4
ARG JQ=1.8
ARG EXTS="gd zip opcache mysqli"
ARG XDEBUG
ARG TOOLS
ENV EXTS=${EXTS}

COPY spip.ini ${PHP_INI_DIR}/conf.d/docker-php-ext-spip.ini
RUN apk --no-cache add make=~${MAKE} jq=~${JQ} git && \
    ln -s "${PHP_INI_DIR}/php.ini-development" "${PHP_INI_DIR}/php.ini" && \
    if [ "${XDEBUG}" != "0" ];then EXTS="${EXTS} xdebug-${XDEBUG}"; fi && \
    install-php-extensions ${EXTS} && \
    pear config-set php_ini "$PHP_INI_DIR/php.ini" && \
    adduser --home /build --shell /bin/ash --disabled-password ciuser ci && \
    mkdir -p /build/.composer && \
    curl -s -o /build/.composer/keys.dev.pub https://composer.github.io/snapshots.pub && \
    curl -s -o /build/.composer/keys.tags.pub https://composer.github.io/releases.pub && \
    chown -R 1000:1000 /build/.composer && \
    touch /tmp/xdebug.log && \
    chown 1000:1000 /tmp/xdebug.log

FROM base AS tools
USER ciuser
ENV COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_NO_INTERACTION=1 \
    COMPOSER_FUND=0 \
    COMPOSER_AUDIT_ABANDONED=report \
    COMPOSER_ROOT_VERSION=1.0.0 \
    XDEBUG_MODE=off \
    PATH="/build/.composer/vendor/bin:${PATH}"
RUN composer global config repositories.spip composer https://get.spip.net/composer && \
    composer global require ${TOOLS} && \
    composer clear-cache
WORKDIR /build/app
VOLUME [ "/build/.composer/cache" ]

FROM tools AS ci
COPY Makefile /Makefile
COPY .jq /usr/local/lib/jq
ENTRYPOINT [ "make", "-f", "/Makefile" ]
CMD [ "help" ]
