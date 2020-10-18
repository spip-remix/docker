FROM php:5.5-cli

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable xdebug \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=spipremix/checkout /checkout /usr/local/bin/checkout
