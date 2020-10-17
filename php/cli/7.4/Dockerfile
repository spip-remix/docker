FROM php:7.4-cli

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
