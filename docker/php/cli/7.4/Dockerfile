FROM php:7.4-cli

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
        libzip-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    && pecl install xdebug-3.0.4 \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable opcache \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && mkdir /root/.composer \
    && curl -s -o /root/.composer/keys.dev.pub https://composer.github.io/snapshots.pub \
    && curl -s -o /root/.composer/keys.tags.pub https://composer.github.io/releases.pub \
    && echo "Done."

ADD spip-xdbg3.ini /usr/local/etc/php/conf.d/spip.ini

COPY --from=composer:2.0 /usr/bin/composer /usr/local/bin/composer
COPY --from=spipremix/checkout /checkout /usr/local/bin/checkout

WORKDIR /build
