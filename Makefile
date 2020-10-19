.DEFAULT_GOAL := init

build/.done:
	@test -d build || mkdir build
	@docker-compose build tools
	@touch $@

build/.pulled:
	@test -d build || mkdir build
	@docker-compose pull tools
	@touch $@

apps/spip/config/.ok: build/.pulled
	@test -d apps || mkdir apps
	@docker-compose run tools checkout spip -bv3.2.8 spip
	@touch $@

.PHONY: init php-server
init: apps/spip/config/.ok

php-server: apps/spip/config/.ok
	@docker-compose up -d php-server
