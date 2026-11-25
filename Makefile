.PHONY: help clean lint audit outdated analyze refactor cs cs-fixer test test-coverage
# Reports are always regenerated: a report written by a failed run must not make the next run a no-op.
.PHONY: build/phplint.json build/phpstan.json build/php-cs-fixer.json build/junit.xml build/cobertura.xml build/gl-outdated.json build/gl-audit.json

## —— 🐿️  The SpipRemix Makefile 🐿️  ——
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

clean: ## Clean build directory
	@rm -Rf build .phpunit.cache

# parallel-lint is the only global tool: it does not need a "composer install" of the project.
/build/.composer/vendor/bin/parallel-lint:
	@echo "parallel-lint is not present on this version of spip/tools. Try with a newer version (5.6+)."
	@false

# Other QA tools come from the project: add them (or spip-league/qa-tools) to its require-dev.
vendor/bin/phpstan vendor/bin/rector vendor/bin/ecs vendor/bin/php-cs-fixer vendor/bin/phpunit: vendor/autoload.php
	@test -x $@ || { echo "$@ is missing: add it (or spip-league/qa-tools) to the require-dev of the project."; false; }

composer.json:
	@echo "fichier $@ manquant."
	@false

composer.lock: composer.json
	@composer validate --no-check-publish --quiet --no-check-lock
	@echo "please run composer update --lock before anything else."
	@false

vendor/autoload.php: composer.json
	@composer install --no-progress --prefer-install=auto

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

.php-cs-fixer.dist.php:
	@echo "fichier $@ manquant."
	@false

# Files from phplint.lst, or the whole project if it has a composer.json.
# ecs.php and rector.php configure tools that may run on a newer PHP than the linted code.
build/phplint.json: /build/.composer/vendor/bin/parallel-lint
	@test -d build || mkdir -p build
	@echo "Looking for PHP syntax errors ..."
	@if [ -f phplint.lst ]; then \
		set -- --exclude ecs.php --exclude rector.php $$(cat phplint.lst); \
	elif [ -f composer.json ]; then \
		set -- --exclude .git --exclude vendor --exclude lang --exclude node_modules --exclude build --exclude .composer-cache --exclude ecs.php --exclude rector.php .; \
	else \
		echo "No phplint.lst nor composer.json: nothing to lint."; \
		echo "[]" > $@; \
		exit 0; \
	fi; \
	parallel-lint --gitlab "$$@" > $@ || { rc=$$?; parallel-lint "$$@"; exit $$rc; }
	@echo $$(jq '.|length' $@)" error(s)."

build/phpstan.json: vendor/bin/phpstan phpstan.neon.dist
	@test -d build || mkdir -p build
	@echo "Looking for bugs with phpstan ..."
	@vendor/bin/phpstan analyse --memory-limit=1G --no-progress --error-format=gitlab > $@ || { \
		rc=$$?; \
		vendor/bin/phpstan analyse --memory-limit=1G --no-progress --error-format=table; \
		exit $$rc; \
	}

build/php-cs-fixer.json: vendor/bin/php-cs-fixer .php-cs-fixer.dist.php
	@test -d build || mkdir -p build
	@echo "Checking coding standards ..."
	@vendor/bin/php-cs-fixer check --show-progress=none --format=gitlab > $@

build/junit.xml: vendor/bin/phpunit phpunit.xml.dist
	@test -d build || mkdir -p build
	@vendor/bin/phpunit --colors --no-coverage --log-junit $@

build/cobertura.xml: vendor/bin/phpunit phpunit.xml.dist
	@php -m | grep -qi '^pcov$$' || { echo "pcov is not available on this version of spip/tools."; false; }
	@test -d build || mkdir -p build
	@php -d pcov.enabled=1 vendor/bin/phpunit --colors --coverage-text --coverage-cobertura $@

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
	@if [ "$$(jq '.packages | length' composer.lock)" -eq 0 ]; then \
		echo "No runtime dependency to audit."; \
		echo "[]" > $@; \
		exit 0; \
	fi; \
	composer audit --locked --no-dev --format=json > $@.tmp; rc=$$?; \
	jq -f /usr/local/lib/jq/gitlab/audit.jq $@.tmp > $@; \
	rm -f $@.tmp; \
	if [ $$rc -ne 0 ]; then composer audit --locked --no-dev; fi; \
	exit $$rc

## Test tools
lint: build/phplint.json ## Find syntax errors

cs: vendor/bin/ecs ecs.php ## Check coding standards (with ecs)
	@echo "Checking coding standards ..."
	@vendor/bin/ecs check --no-progress-bar

cs-fixer: build/php-cs-fixer.json ## Check coding standards (with php-cs-fixer)

analyze: build/phpstan.json ## Find bugs with phpstan

refactor: vendor/bin/rector rector.php ## Find bugs with rector
	@vendor/bin/rector process --no-progress-bar --dry-run

test-coverage: build/cobertura.xml ## Run Unit Tests with coverage (pcov)

test: build/junit.xml ## Run Unit Tests without coverage

## External vulnerabilities
outdated: build/gl-outdated.json  ## Outdated packages

audit: build/gl-audit.json ## Vulnerabilities (fails if any)
