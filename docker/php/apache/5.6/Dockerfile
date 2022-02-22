FROM php:5.6-apache

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libzip-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    && apt-get upgrade -y curl \
    && a2enmod rewrite \
    && ln -s "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && pear config-set php_ini "$PHP_INI_DIR/php.ini" \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable xdebug opcache \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-freetype-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install -j$(nproc) gd zip mysqli \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && echo "Done."

ADD spip-noxdbg.ini /usr/local/etc/php/conf.d/spip.ini
