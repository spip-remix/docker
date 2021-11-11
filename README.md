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
- password: `spip3.2.11`

SPIP is installed in `./apps/spip`.

## Services

### Tools

- [spip/tools](https://hub.docker.com/r/spip/tools)
- Content:
  - php-cli (including opcache, gd, zip, and mysqli extensions)
  - php.ini in default development mode + spip.ini custom directives
    - date.timezone defaults to Europe/Paris
    - memory_limit pushed to 160M because @imagecreatefromgif() call in SPIP 3.2 `ecrire/inc/filtres_images_lib_mini.php:504`
  - [composer](https://getcomposer.org)
  - [Xdebug](https://xdebug.org/)
  - [SPIP Checkout](https://git.spip.net/spip-contrib-outils/checkout)
  - [netpbm](http://netpbm.sourceforge.net/)
  - [ImageMagick](https://imagemagick.org/)

#### Xdebug

- Xdebug versions are : 3.1.0 for PHP7.3 and above.

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
  - php+apache2+mod_php (including opcache, gd, zip, and mysqli extensions)
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

### spip/tools and spip/mod_php

| SPIP Version     | PHP 7.3 | PHP 7.4 | PHP 8.0 | PHP 8.1   |
| ---------------- | ------- | ------- | ------- | --------- |
| 3.2 (3.2.11)     | 7.3     | 7.4     | N/A     | N/A       |
| 4.0 (4.0.0)      | 7.3     | 7.4     | latest  | N/A       |
| 4.1 (4.1.x-dev)  | N/A     | 7.4     | latest  | 8.1-RC6   |

### spip/fpm

TODO

### PHP Versions

TODO

#### PHP oldest versions

TODO

### SPIP Versions

TODO

#### SPIP oldest versions

TODO

## Customization

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
      dockerfile: cli/7.3/Dockerfile
    image: spip/tools:7.3-cli

  dev.spip.local:
    build:
      context: ./docker/php
      dockerfile: apache/7.3/Dockerfile
    image: spip/mod_php:7.3
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
