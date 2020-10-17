# spip-docker

Containers for SPIP

## Services

### Tools

- [spip/tools](https://hub.docker.com/r/spip/tools)
- Content:
  - php-cli
  - [composer](https://getcomposer.org)
  - [Xdebug](https://xdebug.org/)

#### Notes

- Xdebug versions are : 2.4.1 for PHP5.4, 2.5.5 for PHP5.5 & PHP5.6, 2.6.1 for PHP7.0, 2.9.8 for PHP7.1 and above.
- No Xdebug for PHP8.0 as pecl is not installed and no xDebug stable version has been released yet.

## Version Matrix

### spip/tools

| SPIP Version     | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1 | PHP 7.2 | PHP 7.3 | PHP 7.4 | PHP 8.0      |
| ---------------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------------ |
| 3.2 (3.2.8)      | 5.4-cli | 5.5-cli | 5.6-cli | 7.0-cli | 7.1-cli | 7.2-cli | N/A     | N/A     | N/A          |
| 3.3 (3.3.x-dev)  | N/A     | N/A     | 5.6-cli | 7.0-cli | 7.1-cli | 7.2-cli | 7.3-cli | latest  | 8.0.0RC2-cli |
| 3.4 (3.4.x-dev)  | N/A     | N/A     | N/A     | N/A     | N/A     | N/A     | 7.3-cli | latest  | 8.0.0RC2-cli |
