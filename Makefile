.DEFAULT_GOAL := init
SPIP_DIRECTORY=spip
SPIP_VERSION=v3.2.8

build/.done:
	@test -d build || mkdir build
	@docker-compose build tools
	@touch $@

build/.pulled:
	@test -d build || mkdir build
	@docker-compose pull tools sql dev.spip.local
	@touch $@

apps/spip/config/.ok: build/.pulled
	@test -d apps || mkdir apps
	@test -d data/$(SPIP_DIRECTORY) || mkdir -p data/$(SPIP_DIRECTORY)
	@docker-compose run tools checkout spip -b$(SPIP_VERSION) $(SPIP_DIRECTORY)
	@touch $@

.PHONY: init start
init: apps/spip/config/.ok

start: apps/spip/config/.ok
	@docker-compose up -d dev.spip.local
