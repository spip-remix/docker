FROM php:8.1.0RC1-fpm

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
    && docker-php-ext-enable opcache \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean && apt-get autoremove \
    && echo "Done."

ADD spip-noxdbg.ini /usr/local/etc/php/conf.d/spip.ini
ADD spip.conf /usr/local/etc/php-fpm.d/spip.conf
