.PHONY: help clean lint audit outdated analyze refactor cs test test-coverage

## —— 🐿️  The SpipRemix Makefile 🐿️  ——
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

clean: ## Clean build directory
	@rm -Rf build .phpunit.cache

/build/.composer/vendor/bin/parallel-lint:
	@echo "parallel-lint is not present on this version of spip/tools. Try with a newer version (5.6+)."
	@false

/build/.composer/vendor/bin/phpstan:
	@echo "phpstan is not present on this version of spip/tools. Try with a newer version (7.4+)."
	@false

/build/.composer/vendor/bin/rector:
	@echo "rector is not present on this version of spip/tools. Try with a newer version (7.4+)."
	@false

/build/.composer/vendor/bin/ecs:
	@echo "ecs is not present on this version of spip/tools. Try with a newer version (7.4+)."
	@false

/build/.composer/vendor/bin/phpunit:
	@echo "phpunit is not present on this version of spip/tools. Try with a newer version (7.4+)."
	@false

composer.json:
	@echo "fichier $@ manquant."
	@false

composer.lock: composer.json
	@composer validate --no-check-publish --quiet --no-check-lock
	@echo "please run composer update --lock before anything else."
	@false

vendor/autoload.php: composer.json
	@composer install --no-progress --prefer-install=auto

phplint.lst:
	@echo "fichier $@ manquant."
	@false

phpstan.neon.dist:
	@echo "fichier $@ manquant."
	@false

phpunit.xml.dist:
	@echo "fichier $@ manquant."
	@false

rector.php:
	@echo "fichier $@ manquant."
	@false

ecs.php:
	@echo "fichier $@ manquant."
	@false

build/phplint.json: vendor/autoload.php /build/.composer/vendor/bin/parallel-lint phplint.lst
	@test -d build || mkdir -p build
	@echo "Looking for PHP syntax errors ..."
	@parallel-lint --gitlab $$(cat phplint.lst) > $@
	@echo $$(jq '.|length' $@)" error(s)."

build/phpstan.json: vendor/autoload.php /build/.composer/vendor/bin/phpstan phpstan.neon.dist
	@test -d build || mkdir -p build
	@echo "Looking for bugs with phpstan ..."
	@phpstan --memory-limit=-1 --error-format=gitlab > $@

build/ecs.json: vendor/autoload.php /build/.composer/vendor/bin/ecs ecs.php
	@test -d build || mkdir -p build
	@echo "Checking coding standards ..."
	@ecs check --output-format=gitlab > $@

build/rector.json: vendor/autoload.php /build/.composer/vendor/bin/rector rector.php
	@test -d build || mkdir -p build
	@rector process --dry-run --output-format=gitlab > $@

build/test: vendor/autoload.php /build/.composer/vendor/bin/phpunit phpunit.xml.dist
	@test -d build || mkdir -p build
	@phpunit --colors --no-coverage

.phpunit.cache/corbertura/report.xml: vendor/autoload.php /build/.composer/vendor/bin/phpunit phpunit.xml.dist
	@XDEBUG_MODE=coverage phpunit --colors

build/gl-outdated.json: vendor/autoload.php
	@test -d build || mkdir -p build
	@composer outdated --locked --direct --strict --format=json > $@.tmp || true
	@cat $@.tmp | jq -f /usr/local/lib/jq/gitlab/outdated.jq > $@
	@rm $@.tmp

build/gl-audit.json: vendor/autoload.php
	@if ! composer help audit >/dev/null 2>&1; \
	then \
		echo "No audit capability. Try with a newer version (7.2+)."; \
		false; \
	fi
	@test -d build || mkdir -p build
	@composer audit --locked --no-dev --format=json > $@.tmp || true
	@cat $@.tmp | jq -f /usr/local/lib/jq/gitlab/audit.jq > $@
	@rm $@.tmp

## Test tools
lint: build/phplint.json ## Find syntax errors

cs: build/ecs.json ## Check coding standards

analyze: build/phpstan.json ## Find bugs with phpstan

refactor: build/rector.json ## Find bugs with rector

test-coverage: .phpunit.cache/corbertura/report.xml ## Run Unit Tests with coverage

test: build/test ## Run Unit Tests without coverage

## External vulnerabilities
outdated: build/gl-outdated.json  ## Outdated packages

audit: build/gl-audit.json ## Vulnerabilities
