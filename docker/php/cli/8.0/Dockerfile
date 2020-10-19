FROM php:8.0.0RC2-cli

ADD spip.ini /usr/local/etc/php/conf.d/spip.ini

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
    # && pecl install xdebug \
    # && docker-php-ext-enable xdebug \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=spipremix/checkout /checkout /usr/local/bin/checkout

WORKDIR /build
