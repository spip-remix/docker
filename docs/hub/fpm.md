# spip/fpm

PHP-FPM container (Alpine) for SPIP **development**, to use behind a web server such as nginx.

Source, issues and build scripts: [github.com/spip-remix/docker](https://github.com/spip-remix/docker)

## Supported tags

<!-- tags:start -->
| Tags | PHP | Xdebug | Notes |
|---|---|---|---|
| `8.6`, `8.6.0` | 8.6.0 | not available yet | ZTS build (official image) |
| `8.5`, `8.5.13`, `latest` | 8.5.13 | 3.5.3 | default tag |
| `8.4`, `8.4.28` | 8.4.28 | 3.5.3 |  |
| `8.3`, `8.3.37` | 8.3.37 | 3.5.3 |  |
| `8.2`, `8.2.36` | 8.2.36 | 3.5.3 |  |
<!-- tags:end -->

`7.4`, `8.0` and `8.1` (PHP end of life) are only rebuilt occasionally, `5.6` is not rebuilt anymore.

## What's inside

- PHP-FPM with `gd`, `intl`, `zip`, `opcache`, `mysqli`, `pgsql`, `pdo_mysql`, `pdo_pgsql`
- Xdebug (see the table above)
- `php.ini-development`, `memory_limit=160M`, `date.timezone=Europe/Paris`
- FPM listens on port **9000** (the default of the official image) and answers its status page on `/ping`

These images are meant for development: do not use them in production.

## Usage

Mount your SPIP site in `/var/www/html`:

```bash
docker run -d --name spip-fpm -v $(pwd):/var/www/html spip/fpm:8.5
```

With Docker Compose and nginx:

```yml
services:
    php:
        image: spip/fpm:8.5
        volumes:
            - ./:/var/www/html
    web:
        image: nginx:alpine
        ports:
            - "8080:80"
        volumes:
            - ./:/var/www/html
            - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

with `fastcgi_pass php:9000;` in `nginx.conf`.

## Xdebug

Xdebug is set up for step debugging (`xdebug.mode=develop,debug`) and connects to your IDE on
`host.docker.internal:9003` with the IDE key `my-ide-key`.
On Linux, add `--add-host=host.docker.internal:host-gateway` (or `extra_hosts` in Compose).

## Notes

- Until November 2026, FPM listened on port 9003, the port of the Xdebug client.
  Update `fastcgi_pass` (or your proxy settings) to port 9000.
- PHP 8.6: the official image is built with ZTS (thread safety), unlike PHP 8.5 and earlier.
  Xdebug is not available yet for this version.
- Images are built for `linux/amd64` and `linux/arm64`.
