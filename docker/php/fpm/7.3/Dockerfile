FROM php:7.3-fpm

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
    && docker-php-ext-configure gd --with-png-dir=/usr --with-freetype-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install -j$(nproc) gd mysqli zip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && pecl clear-cache \
    && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && echo "Done."

ADD spip.ini /usr/local/etc/php/conf.d
ADD spip.conf /usr/local/etc/php-fpm.d/spip.conf
