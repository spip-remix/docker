FROM php:7.2-cli

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=spipremix/checkout /checkout /usr/local/bin/checkout
