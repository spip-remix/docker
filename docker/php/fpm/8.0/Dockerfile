FROM php:8.0.0RC3-fpm

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        unzip \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        netpbm \
        imagemagick \
    # && pecl install xdebug \
    # && docker-php-ext-enable xdebug \
    && docker-php-ext-install mysqli \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && echo "Done."

ADD spip.ini /usr/local/etc/php/conf.d/spip.ini
ADD spip.conf /usr/local/etc/php-fpm.d/spip.conf
