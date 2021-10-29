FROM php:8.1.0RC5-apache

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
        libzip-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    && a2enmod rewrite \
    && pecl install xdebug-3.1.0 \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable opcache \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove

COPY spip.ini /usr/local/etc/php/conf.d/spip.ini
