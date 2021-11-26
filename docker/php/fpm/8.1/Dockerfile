FROM php:8.1.0RC6-fpm

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libzip-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    && pecl install xdebug-3.1.1 \
    && docker-php-ext-enable opcache xdebug \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli zip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && pecl clear-cache \
    && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && echo "Done."

ADD spip-noxdbg.ini /usr/local/etc/php/conf.d/spip.ini
ADD spip.conf /usr/local/etc/php-fpm.d/spip.conf
