FROM php:5.5-apache

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install mysqli \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-freetype-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && echo "Done."

ADD spip.ini /usr/local/etc/php/conf.d/spip.ini
#PHP5.5 image seems not to deliver ini files
ADD php5.5.ini-development "$PHP_INI_DIR/php.ini"
