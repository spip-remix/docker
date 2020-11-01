.DEFAULT_GOAL := init
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

apps/spip/config/connect.php: apps/spip/config/.ok docker/spip/3.2.8/connect.php
	@cp -f docker/spip/3.2.8/connect.php apps/spip/config/connect.php

apps/spip/config/chmod.php: apps/spip/config/.ok docker/spip/3.2.8/chmod.php
	@cp -f docker/spip/3.2.8/chmod.php apps/spip/config/chmod.php

apps/spip/config/.ok: build/.pulled
	@test -d apps || mkdir apps
	@test -d data/$(SPIP_DIRECTORY) || mkdir -p data/$(SPIP_DIRECTORY)
	@docker-compose run tools checkout spip -b$(SPIP_VERSION) $(SPIP_DIRECTORY)
	@touch $@

.PHONY: clean reset start stop
clean:
	@rm -f apps/spip/config/.ok

reset: clean stop
	@rm -Rf apps data

start: apps/spip/config/connect.php apps/spip/config/chmod.php
	@docker-compose up -d dev.spip.local

stop:
	@docker-compose down
