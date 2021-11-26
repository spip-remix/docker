FROM php:7.3.33-cli-alpine3.14  AS build

RUN apk add --no-cache $PHPIZE_DEPS \
        libzip-dev \
        freetype-dev \
        libpng-dev \
        jpeg-dev \
        libjpeg-turbo-dev \
    && pecl install xdebug-3.1.1 \
    && docker-php-ext-configure gd --with-png-dir=/usr/lib/ --with-freetype-dir=/usr/lib/ --with-jpeg-dir=/usr/lib/ \
    && docker-php-ext-install -j$(nproc) gd mysqli zip \
    && true

FROM php:7.3.33-cli-alpine3.14 AS spip-cli

COPY --from=build /usr/local/lib/php/extensions/no-debug-non-zts-20180731/*.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731
COPY --from=build /usr/lib/libzip.so* /usr/lib
COPY --from=build /usr/lib/libbz2.so* /usr/lib
COPY --from=build /usr/lib/libpng16.so* /usr/lib
COPY --from=build /usr/lib/libjpeg.so* /usr/lib
COPY --from=build /usr/lib/libfreetype.so* /usr/lib

RUN docker-php-ext-enable opcache xdebug gd mysqli zip \
    && ln -s "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && true

COPY spip.ini /usr/local/etc/php/conf.d

COPY --from=composer:2.1 /usr/bin/composer /usr/bin/composer

WORKDIR /build
