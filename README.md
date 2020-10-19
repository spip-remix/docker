# spip-docker

Containers for SPIP

## Services

### Tools

- [spip/tools](https://hub.docker.com/r/spip/tools)
- Content:
  - php-cli (including gd and mysqli extensions)
  - php.ini in default development mode + spip.ini custom directives
    - date.timezone defaults to Europe/Paris
    - memory_limit pushed to 160M because @imagecreatefromgif() call in SPIP 3.2 `ecrire/inc/filtres_images_lib_mini.php:504`
  - [composer](https://getcomposer.org)
  - [Xdebug](https://xdebug.org/)
  - [SPIP Checkout](https://git.spip.net/spip-contrib-outils/checkout)

#### Notes

- Xdebug versions are : 2.4.1 for PHP5.4, 2.5.5 for PHP5.5 & PHP5.6, 2.6.1 for PHP7.0, 2.9.8 for PHP7.1 and above.
- No Xdebug for PHP8.0 as pecl is not installed and no xDebug stable version has been released yet.

TODO: xdebug configuration in spip.ini file

### Lamp

TODO.

## Version Matrix

### spip/tools

| SPIP Version     | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1 | PHP 7.2 | PHP 7.3 | PHP 7.4 | PHP 8.0      |
| ---------------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------------ |
| 3.2 (3.2.8)      | 5.4-cli | 5.5-cli | 5.6-cli | 7.0-cli | 7.1-cli | 7.2-cli | N/A     | N/A     | N/A          |
| 3.3 (3.3.x-dev)  | N/A     | N/A     | 5.6-cli | 7.0-cli | 7.1-cli | 7.2-cli | 7.3-cli | latest  | 8.0.0RC2-cli |
| 3.4 (3.4.x-dev)  | N/A     | N/A     | N/A     | N/A     | N/A     | N/A     | 7.3-cli | latest  | 8.0.0RC2-cli |

Defaults to 7.2-cli image and SPIP3.2.8 installation

To test with alternative PHP Versions :

Create a `docker-compose.override.yml` file next to the `docker-compose.yml` file with the content below and change the PHP version as needed :

```yml
version: "3.8"
services:
  tools:
    build:
      context: ./docker/php
      dockerfile: cli/5.4/Dockerfile
    image: spip/tools:5.4-cli

  php-server:
    image: spip/tools:5.4-cli
    volumes:
    - ./apps/spip:/build
```
