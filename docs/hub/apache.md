# spip/apache

Apache httpd + mod_php container for SPIP **development**.

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

- Apache httpd with mod_php and `mod_rewrite` enabled (for SPIP's `.htaccess`)
- PHP with `gd`, `intl`, `zip`, `opcache`, `mysqli`, `pgsql`, `pdo_mysql`, `pdo_pgsql`
- Xdebug (see the table above)
- `php.ini-development`, `memory_limit=160M`, `date.timezone=Europe/Paris`

These images are meant for development: do not use them in production.

## Usage

Mount your SPIP site in `/var/www/html` and publish port 80:

```bash
docker run -d -p 8080:80 -v $(pwd):/var/www/html spip/apache:8.5
```

The site is then available on <http://localhost:8080>.

With Docker Compose:

```yml
services:
    web:
        image: spip/apache:8.5
        ports:
            - "8080:80"
        volumes:
            - ./:/var/www/html
```

## Xdebug

Xdebug is set up for step debugging (`xdebug.mode=develop,debug`) and connects to your IDE on
`host.docker.internal:9003` with the IDE key `my-ide-key`.
On Linux, add `--add-host=host.docker.internal:host-gateway` (or `extra_hosts` in Compose).

## Notes

- PHP 8.6: the official image is built with ZTS (thread safety), unlike PHP 8.5 and earlier.
  Xdebug is not available yet for this version.
- Images are built for `linux/amd64` and `linux/arm64`.
