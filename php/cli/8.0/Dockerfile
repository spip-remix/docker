FROM php:8.0.0RC2-cli

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
    # && pecl install xdebug \
    # && docker-php-ext-enable xdebug \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove