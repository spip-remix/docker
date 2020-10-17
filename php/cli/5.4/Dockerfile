FROM php:5.4-cli

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug-2.4.1 \
    && docker-php-ext-enable xdebug \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove
