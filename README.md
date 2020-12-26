# spip-docker

Containers for SPIP

## Usage

```bash
git clone https://github.com/JamesRezo/spip-docker.git
cd spip-docker
make start
```

Open <http://localhost:8000/ecrire> in a web browser.

- login: `admin`
- password: `spip3.2.8`

SPIP is installed in `./apps/spip`.

## Services

### Tools

- [spip/tools](https://hub.docker.com/r/spip/tools)
- Content:
  - php-cli (including opcache, gd and mysqli extensions)
  - php.ini in default development mode + spip.ini custom directives
    - date.timezone defaults to Europe/Paris
    - memory_limit pushed to 160M because @imagecreatefromgif() call in SPIP 3.2 `ecrire/inc/filtres_images_lib_mini.php:504`
  - [composer](https://getcomposer.org)
  - [Xdebug](https://xdebug.org/)
  - [SPIP Checkout](https://git.spip.net/spip-contrib-outils/checkout)
  - [netpbm](http://netpbm.sourceforge.net/)
  - [ImageMagick](https://imagemagick.org/)

#### Xdebug

- Xdebug versions are : 2.4.1 for PHP5.4, 2.5.5 for PHP5.5 & PHP5.6, 2.7.2 for PHP7.0, 2.9.8 for PHP7.1, 3.0.1 for PHP7.2  and above.

#### sqlite3 enabled

`config/connect.php`:

```php
<?php
if (!defined("_ECRIRE_INC_VERSION")) return;
$GLOBALS['spip_connect_version'] = 0.8;
spip_connect_db('localhost','','','','spip','sqlite3', 'spip','','');
```

#### SPIP-Cli

TODO.

### SQL

Default SQL Server is MariaDB 10.3 (default sql server in Debian Buster)

Parameters:

- host: `sql` default to 3306 port
- user: `root`
- password: `spip`

Alternatively, for MySQL 5.7,
create a `docker-compose.override.yml` file next to the `docker-compose.yml` file with the content below

```yml
  sql:
    image: mysq:5.7
    command: --default-authentication-plugin=mysql_native_password
    volumes:
    - ./data/spip:/var/lib/mysql
    - ./docker/sql/mysql/5.7:/docker-entrypoint-initdb.d
```

### Web Server

#### mod_php

- [spip/mod_php](https://hub.docker.com/r/spip/mod_php)
- Content:
  - php+apache2+mod_php (including gd and mysqli extensions)
  - php.ini in default development mode + spip.ini custom directives
    - date.timezone defaults to Europe/Paris
    - memory_limit pushed to 160M because @imagecreatefromgif() call in SPIP 3.2 `ecrire/inc/filtres_images_lib_mini.php:504`
  - [Xdebug](https://xdebug.org/)
  - [netpbm](http://netpbm.sourceforge.net/)
  - [ImageMagick](https://imagemagick.org/)

#### PHP-FPM with Apache httpd Server

TODO.

#### PHP-FPM with Nginx

TODO.

### emails

TODO.

## Version Matrix

### spip/tools

| SPIP Version     | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1 | PHP 7.2 | PHP 7.3 | PHP 7.4 | PHP 8.0 |
| ---------------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| 3.2 (3.2.8)      | 5.4-cli | 5.5-cli | 5.6-cli | 7.0-cli | 7.1-cli | 7.2-cli | N/A     | N/A     | N/A     |
| 3.3 (3.3.x-dev)  | N/A     | N/A     | 5.6-cli | 7.0-cli | 7.1-cli | 7.2-cli | 7.3-cli | latest  | 8.0-cli |
| 3.4 (3.4.x-dev)  | N/A     | N/A     | N/A     | N/A     | N/A     | N/A     | 7.3-cli | latest  | 8.0-cli |

### spip/mod_php

| SPIP Version     | PHP 5.4    | PHP 5.5    | PHP 5.6    | PHP 7.0    | PHP 7.1    | PHP 7.2    | PHP 7.3    | PHP 7.4 | PHP 8.0    |
| ---------------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ------- | ---------- |
| 3.2 (3.2.8)      | 5.4-apache | 5.5-apache | 5.6-apache | 7.0-apache | 7.1-apache | 7.2-apache | N/A        | N/A     | N/A        |
| 3.3 (3.3.x-dev)  | N/A        | N/A        | 5.6-apache | 7.0-apache | 7.1-apache | 7.2-apache | 7.3-apache | latest  | 8.0-apache |
| 3.4 (3.4.x-dev)  | N/A        | N/A        | N/A        | N/A        | N/A        | N/A        | 7.3-apache | latest  | 8.0-apache |

### spip/fpm

| SPIP Version     | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1 | PHP 7.2 | PHP 7.3 | PHP 7.4 | PHP 8.0 |
| ---------------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| 3.2 (3.2.8)      | 5.4-fpm | 5.5-fpm | 5.6-fpm | 7.0-fpm | 7.1-fpm | 7.2-fpm | N/A     | N/A     | N/A     |
| 3.3 (3.3.x-dev)  | N/A     | N/A     | 5.6-fpm | 7.0-fpm | 7.1-fpm | 7.2-fpm | 7.3-fpm | latest  | 8.0-fpm |
| 3.4 (3.4.x-dev)  | N/A     | N/A     | N/A     | N/A     | N/A     | N/A     | 7.3-fpm | latest  | 8.0-fpm |

Defaults to 7.2-cli+7.2-fpm images and SPIP3.2.8 installation

To test with alternative PHP Versions :

Create a `docker-compose.override.yml` file next to the `docker-compose.yml` file with the content below and change the PHP version as needed :

```yml
#Run Stable SPIP under PHP 8.0 version
version: "3.8"
services:
  tools:
    image: spip/tools:8.0-cli

  dev.spip.local:
    image: spip/mod_php:8.0
    volumes:
    - ./apps/spip:/var/www/html
```

or

```yml
#Run Stable SPIP under its minimum PHP version and apache2+mod_php
version: "3.8"
services:
  tools:
    build:
      context: ./docker/php
      dockerfile: cli/5.4/Dockerfile
    image: spip/tools:5.4-cli

  dev.spip.local:
    build:
      context: ./docker/php
      dockerfile: apache/5.4/Dockerfile
    image: spip/mod_php:5.4
    volumes:
    - ./apps/spip:/var/www/html
```

or

```yml
#Run Dev SPIP under stable PHP version
version: "3.8"
services:
  tools:
    build:
      context: ./docker/php
      dockerfile: cli/7.3/Dockerfile
    image: spip/tools:7.3-cli

  php-server:
    image: spip/tools:7.3-cli
    networks:
    - dev.spip.local
    ports:
    - "5919:5919"
    hostname: php-server
    container_name: php-server
    volumes:
    - ./apps/spip-dev:/build
    entrypoint: ["php", "-S", "php-server:5919", "-t", "."]
```
