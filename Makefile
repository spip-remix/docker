.DEFAULT_GOAL := start
SPIP_DIRECTORY=spip
SPIP_VERSION=v3.2.8

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

.PHONY: clean reset start stop
clean:
	@rm -f apps/$(SPIP_DIRECTORY)/config/.ok
	@rm -f build/.pulled

reset: clean stop
	@rm -Rf apps data

start: apps/$(SPIP_DIRECTORY)/config/connect.php apps/$(SPIP_DIRECTORY)/config/chmod.php
	@docker-compose up -d dev.spip.local

stop:
	@docker-compose down
