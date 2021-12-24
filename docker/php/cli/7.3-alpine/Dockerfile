ARG XDEBUG_VERSION
FROM php:7.3-cli-alpine AS build

RUN apk add --no-cache $PHPIZE_DEPS \
    libzip-dev \
    freetype-dev \
    libpng-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-configure gd --with-png-dir=/usr/lib/ --with-freetype-dir=/usr/lib/ --with-jpeg-dir=/usr/lib/ \
    && docker-php-ext-install -j$(nproc) gd mysqli zip \
    && true

FROM php:7.3-cli-alpine AS spip-tools

COPY --from=build /usr/local/lib/php/extensions/no-debug-non-zts-20180731/*.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731
COPY --from=build /usr/lib/libzip.so* /usr/lib
COPY --from=build /usr/lib/libbz2.so* /usr/lib
COPY --from=build /usr/lib/libpng16.so* /usr/lib
COPY --from=build /usr/lib/libjpeg.so* /usr/lib
COPY --from=build /usr/lib/libfreetype.so* /usr/lib

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
