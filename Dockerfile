ARG PHP=8.5.13
ARG COMPOSER=2.11.3
FROM composer/composer:${COMPOSER}-bin AS composer
FROM mlocati/php-extension-installer:2 AS ext-installer
# pie for php8.1+
FROM ghcr.io/php/pie:bin AS pie
FROM php:${PHP}-cli-alpine AS base
COPY --from=composer /composer /usr/local/bin/composer
COPY --from=ext-installer /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions
COPY --from=pie /pie /usr/local/bin/pie
ARG MAKE=4.4
ARG JQ=1.8
ARG EXTS="gd zip opcache mysqli"
# Extensions specific to the tools image (versions.json "cli_exts"): pcntl, pcov before PHP 8.1...
ARG EXTRA_EXTS=""
# PECL extensions installed with PIE, PHP 8.1+ (versions.json "cli_pie")
ARG PIE_EXTS=""
ARG TOOLS
ENV EXTS=${EXTS}

COPY spip.ini ${PHP_INI_DIR}/conf.d/docker-php-ext-spip.ini
RUN apk --no-cache add make=~${MAKE} jq=~${JQ} git && \
    ln -s "${PHP_INI_DIR}/php.ini-development" "${PHP_INI_DIR}/php.ini" && \
    install-php-extensions ${EXTS} ${EXTRA_EXTS} && \
    if [ -n "${PIE_EXTS}" ]; then \
        apk --no-cache add --virtual .pie-build-deps ${PHPIZE_DEPS} && \
        for ext in ${PIE_EXTS}; do pie install --no-interaction "${ext}" || exit 1; done && \
        apk del .pie-build-deps; \
    fi && \
    # pcov is only enabled when needed (php -d pcov.enabled=1), it would otherwise slow PHP and restart PHPStan
    if php -m | grep -qi '^pcov$'; then echo "pcov.enabled=0" > "${PHP_INI_DIR}/conf.d/zz-pcov.ini"; fi && \
    adduser --home /build --shell /bin/ash --disabled-password ciuser ci && \
    mkdir -p /build/.composer/cache && \
    curl -s -o /build/.composer/keys.dev.pub https://composer.github.io/snapshots.pub && \
    curl -s -o /build/.composer/keys.tags.pub https://composer.github.io/releases.pub && \
    chown -R 1000:1000 /build/.composer

FROM base AS tools
USER ciuser
# QA tools (phpstan, ecs, phpunit, rector...) come from the project (vendor/bin).
# Only tools that run without a "composer install" of the project (parallel-lint) are installed globally.
ENV COMPOSER_HOME=/build/.composer \
    COMPOSER_CACHE_DIR=/build/.composer/cache \
    COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_NO_INTERACTION=1 \
    COMPOSER_FUND=0 \
    COMPOSER_AUDIT_ABANDONED=report \
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
