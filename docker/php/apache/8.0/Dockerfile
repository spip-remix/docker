FROM php:8.1-apache
ARG XDEBUG_VERSION

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libzip-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    && a2enmod rewrite \
    && ln -s "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && pear config-set php_ini "$PHP_INI_DIR/php.ini" \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable opcache xdebug \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli zip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && pecl clear-cache \
    && true

COPY spip.ini /usr/local/etc/php/conf.d
