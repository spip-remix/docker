.PHONY: help clean phplint phpcompat audit outdated phpstan

## —— The SpipRemix Makefile ——
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

clean: ## Clean build directory
	@rm -Rf build

/root/.composer/vendor/bin/phpstan:
	@echo "phpstan is not present on this version of friendsofsonar."
	@false

composer.json:
	@echo "fichier $@ manquant."
	@false

composer.lock: composer.json
	@composer validate --no-check-publish --quiet --no-check-lock
	@echo "please run composer update --lock before anything else."
	@false

phplint.lst:
	@echo "fichier $@ manquant."
	@false

phpcs.xml:
	@echo "fichier $@ manquant."
	@false

phpstan.neon:
	@echo "fichier $@ manquant."
	@false

build/phplint.txt: phplint.lst
	@test -d build || mkdir -p build
	@parallel-lint --no-progress $$(cat phplint.lst) | tee $@

build/phpcompat.json: build/phplint.txt phpcs.xml
	@test -d build || mkdir -p build
	@phpcs --report-json=$@.tmp -p || true
	@jq '.files' < $@.tmp | jq -r -f /root/.jq/phpcompat.jq > $@
	@rm $@.tmp

build/phpstan.json: /root/.composer/vendor/bin/phpstan build/phplint.txt phpstan.neon
	@test -d build || mkdir -p build
	@phpstan --memory-limit=-1 --error-format=json > $@ || true
	@echo $$(jq '.totals.errors + .totals.file_errors' < $@)" erreur(s)."

build/outdated.json: composer.lock
	@test -d build || mkdir -p build
	@composer outdated --format=json > $@.tmp || true
	@cat $@.tmp | jq -f /root/.jq/outdated.jq > $@
	@rm $@.tmp

build/audit.json: composer.lock
	@if ! composer help audit >/dev/null 2>&1; \
	then \
		echo "No audit capability. Try with a newer version (7.2+)."; \
		false; \
	fi
	@test -d build || mkdir -p build
	@composer audit --locked --no-dev --format=json > $@.tmp || true
	@cat $@.tmp | jq -f /root/.jq/audit.jq > $@
	@rm $@.tmp

phplint: build/phplint.txt ## Find syntax errors

phpcompat: build/phpcompat.json

phpstan: build/phpstan.json ## Find bugs with phpstaan

## External vulnerabilities
outdated: build/outdated.json  ## Outdated packages

audit: build/audit.json ## Vulnerabilities
