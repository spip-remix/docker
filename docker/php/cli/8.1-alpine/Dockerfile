ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine AS tools
ARG XDEBUG_VERSION

RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    libzip-dev \
    freetype-dev \
    libpng-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && pecl clear-cache \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli zip \
    && apk del .build-deps

RUN apk add --no-cache \
    unzip \
    git \
    && docker-php-ext-enable opcache xdebug gd mysqli zip \
    && ln -s "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && mkdir /root/.composer \
    && curl -s -o /root/.composer/keys.dev.pub https://composer.github.io/snapshots.pub \
    && curl -s -o /root/.composer/keys.tags.pub https://composer.github.io/releases.pub \
    && true

COPY spip.ini /usr/local/etc/php/conf.d

COPY --from=composer:${COMPOSER_VERSION} /usr/bin/composer /usr/bin/composer
COPY --from=spipremix/checkout /checkout /usr/bin/checkout

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /build
