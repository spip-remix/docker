.DEFAULT_GOAL := start
SPIP_DIRECTORY=spip
SPIP_VERSION=v4.0.0

build/.done:
	@test -d build || mkdir build
	@docker-compose build tools
	@touch $@

build/.pulled:
	@test -d build || mkdir build
	@docker-compose pull sql dev.spip.local
	@touch $@

apps/$(SPIP_DIRECTORY)/config/connect.php: apps/$(SPIP_DIRECTORY)/config/.ok docker/spip/$(SPIP_VERSION)/connect.php
	@cp -f docker/spip/$(SPIP_VERSION)/connect.php apps/$(SPIP_DIRECTORY)/config/connect.php

apps/$(SPIP_DIRECTORY)/config/chmod.php: apps/$(SPIP_DIRECTORY)/config/.ok docker/spip/$(SPIP_VERSION)/chmod.php
	@cp -f docker/spip/$(SPIP_VERSION)/chmod.php apps/$(SPIP_DIRECTORY)/config/chmod.php

apps/$(SPIP_DIRECTORY)/config/.ok: build/.pulled
	@test -d apps || mkdir apps
	@test -d data/$(SPIP_DIRECTORY) || mkdir -p data/$(SPIP_DIRECTORY)
	@docker-compose run tools checkout spip -b$(SPIP_VERSION) $(SPIP_DIRECTORY)
	@touch $@

.PHONY: clean reset start stop test build push
clean:
	@rm -f apps/$(SPIP_DIRECTORY)/config/.ok
	@rm -f build/.pulled

reset: clean stop
	@rm -Rf apps data

start: apps/$(SPIP_DIRECTORY)/config/connect.php apps/$(SPIP_DIRECTORY)/config/chmod.php
	@docker-compose up -d dev.spip.local

stop:
	@docker-compose down

test:
	./test.sh

build-alpine:
	docker build -t spip/tools:8.1.3-alpine -t spip/tools:8.1-alpine -f docker/php/cli/8.1-alpine/Dockerfile docker/php
	docker build -t spip/tools:latest-alpine -t spip/tools:8.0.16-alpine -t spip/tools:8.0-alpine -f docker/php/cli/8.0-alpine/Dockerfile docker/php
	docker build -t spip/tools:7.4.28-alpine -t spip/tools:7.4-alpine -f docker/php/cli/7.4-alpine/Dockerfile docker/php

build:
	docker build --build-arg XDEBUG_VERSION=3.1.3 --build-arg COMPOSER_VERSION=2.2 -t spip/tools:7.4.28 -t spip/tools:7.4 -f docker/php/cli/7.4/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 --build-arg COMPOSER_VERSION=2.2 -t spip/tools:latest -t spip/tools:8.0.16 -t spip/tools:8.0 -f docker/php/cli/8.0/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 --build-arg COMPOSER_VERSION=2.2 -t spip/tools:8.1.3 -t spip/tools:8.1 -f docker/php/cli/8.1/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 -t spip/mod_php:7.4.28 -t spip/mod_php:7.4 -f docker/php/apache/7.4/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 -t spip/mod_php:latest -t spip/mod_php:8.0.16 -t spip/mod_php:8.0 -f docker/php/apache/8.0/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 -t spip/mod_php:8.1.3 -t spip/mod_php:8.1 -f docker/php/apache/8.1/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 -t spip/fpm:7.4.28 -t spip/fpm:7.4 -f docker/php/fpm/7.4/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 -t spip/fpm:latest -t spip/fpm:8.0.16 -t spip/fpm:8.0 -f docker/php/fpm/8.0/Dockerfile docker/php
	docker build --build-arg XDEBUG_VERSION=3.1.3 -t spip/fpm:8.1.3 -t spip/fpm:8.1 -f docker/php/fpm/8.1/Dockerfile docker/php

build-5.6-apache:
	docker pull spip/mod_php:5.6
	docker build -t spip/mod_php:5.6 -t spip/mod_php:5.6.40 -f docker/php/apache/5.6/Dockerfile docker/php

push-5.6-apache:
	docker push spip/mod_php:5.6
	docker push spip/mod_php:5.6.40

push-alpine:
	docker push spip/tools:8.1-alpine
	docker push spip/tools:8.1.3-alpine
	docker push spip/tools:latest-alpine
	docker push spip/tools:8.0.16-alpine
	docker push spip/tools:8.0-alpine
	docker push spip/tools:7.4.28-alpine
	docker push spip/tools:7.4-alpine

push:
	docker push spip/tools:7.4.28
	docker push spip/tools:7.4
	docker push spip/tools:8.0.16
	docker push spip/tools:8.0
	docker push spip/tools:latest
	docker push spip/tools:8.1.3
	docker push spip/tools:8.1
	docker push spip/mod_php:7.4.28
	docker push spip/mod_php:7.4
	docker push spip/mod_php:8.0.16
	docker push spip/mod_php:8.0
	docker push spip/mod_php:latest
	docker push spip/mod_php:8.1.3
	docker push spip/mod_php:8.1
	docker push spip/fpm:7.4.28
	docker push spip/fpm:7.4
	docker push spip/fpm:8.0.16
	docker push spip/fpm:8.0
	docker push spip/fpm:8.1.3
	docker push spip/fpm:8.1
	docker push spip/fpm:latest
