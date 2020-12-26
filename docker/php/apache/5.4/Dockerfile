FROM php:5.4-apache

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    && a2enmod rewrite \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug-2.4.1 \
    && docker-php-ext-enable xdebug \
    && pecl install ZendOpcache \
    && docker-php-ext-enable opcache \
    && docker-php-ext-install mysqli \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-freetype-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && mv /usr/src/php/php.ini-development "$PHP_INI_DIR/php.ini" \
    && echo "Done."

ADD spip.ini /usr/local/etc/php/conf.d/spip.ini
