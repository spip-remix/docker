# spip/tools

PHP tooling container for SPIP developments: lint, coding standards, static analysis, unit tests
with coverage and Composer audits, locally or in a CI pipeline.

The image brings PHP and a Makefile; the QA tools themselves come from **your project**,
so the versions used in CI are the ones you use locally.

Source, issues and build scripts: [github.com/spip-remix/docker](https://github.com/spip-remix/docker)

## Supported tags

<!-- tags:start -->
| Tags | PHP | Notes |
|---|---|---|
| `8.6`, `8.6.0` | 8.6.0 | ZTS build (official image), no pcov yet: no `test-coverage` |
| `8.5`, `8.5.13`, `latest` | 8.5.13 | default tag |
| `8.4`, `8.4.28` | 8.4.28 |  |
| `8.3`, `8.3.37` | 8.3.37 |  |
| `8.2`, `8.2.36` | 8.2.36 |  |
<!-- tags:end -->

`7.4`, `8.0` and `8.1` (PHP end of life) are only rebuilt occasionally, `5.6` is not rebuilt anymore.

## What's inside

- PHP (Alpine CLI image) with `gd`, `intl`, `zip`, `opcache`, `mysqli`, `pgsql`, `pdo_mysql`, `pdo_pgsql`,
  plus `pcntl` (PHPStan workers) and `pcov` (coverage, disabled by default)
- Composer, `make`, `jq`, `git`
- `parallel-lint`, the only QA tool installed globally: `lint` works without a `composer install`
- A Makefile (`/Makefile`), used as the entrypoint

The container runs as `ciuser` (uid 1000) in `/build/app`. There is no Xdebug in this image:
use [spip/fpm](https://hub.docker.com/r/spip/fpm) or [spip/apache](https://hub.docker.com/r/spip/apache) to debug.

## Your project

The Makefile runs `composer install`, then the tools of `vendor/bin`. Add them to the `require-dev`
of your project, one by one or all at once with `spip-league/qa-tools`:

```bash
composer require --dev spip-league/qa-tools
```

| Command | Tool | Configuration | Report in `build/` |
|---|---|---|---|
| `lint` | parallel-lint (global) | `phplint.lst` (optional) | `phplint.json` |
| `analyze` | PHPStan | `phpstan.neon.dist` | `phpstan.json` |
| `cs` | ECS | `ecs.php` | console only |
| `cs-fixer` | PHP-CS-Fixer | `.php-cs-fixer.dist.php` | `php-cs-fixer.json` |
| `refactor` | Rector (dry run) | `rector.php` | console only |
| `test` | PHPUnit | `phpunit.xml.dist` | `junit.xml` |
| `test-coverage` | PHPUnit + pcov | `phpunit.xml.dist` | `cobertura.xml` |
| `outdated` | Composer | `composer.lock` (created if missing) | `gl-outdated.json` |
| `audit` | Composer | `composer.lock` (created if missing) | `gl-audit.json` |
| `clean` | | | removes `build/` |

- `lint` checks the files listed in `phplint.lst`, or else the whole project (except `vendor`, `lang`,
  `node_modules`, `build`). `ecs.php` and `rector.php` are skipped: these tools may run on a newer PHP
  than the linted code.
- `audit` fails when a vulnerability is reported (the report is written anyway).
- The JSON reports use the GitLab formats (code quality, dependency scanning).
- Each command runs its tool again, even if a report is already there.

## Usage

Mount your project in `/build/app` and give the commands to run:

```bash
docker run --rm -v $(pwd):/build/app spip/tools:8.5            # list the commands
docker run --rm -v $(pwd):/build/app spip/tools:8.5 clean lint analyze test
```

A local shortcut:

```bash
alias spip-tools='docker run --rm -v $(pwd):/build/app spip/tools'
spip-tools clean test-coverage
```

### GitLab CI

```yml
my-job:
    image:
        name: spip/tools:8.5
        entrypoint: [""]
    variables:
        COMPOSER_CACHE_DIR: .composer-cache
    cache:
        key: composer
        paths:
            - .composer-cache/
    before_script:
        # lets Composer read the branch of the project (the clone belongs to another user)
        - git config --global --add safe.directory "$CI_PROJECT_DIR"
    script:
        - make -f /Makefile lint analyze test-coverage
    coverage: '/^\s*Lines:\s*\d+.\d+\%/'
    artifacts:
        when: always
        paths:
            - build/
        reports:
            junit: build/junit.xml
            codequality: build/phpstan.json
            coverage_report:
                coverage_format: cobertura
                path: build/cobertura.xml
```

### Private packages

Pass the Composer credentials at runtime rather than storing them in an image:

```bash
docker run --rm \
    -e COMPOSER_AUTH='{"gitlab-token": {"gitlab.my.org": "xxxxx"}}' \
    -v $(pwd):/build/app \
    spip/tools:8.5 audit
```

To install packages over SSH, extend the image and forward your SSH agent:

```Dockerfile
FROM spip/tools:8.5
USER root
RUN apk --no-cache add openssh-client
USER ciuser
RUN mkdir -p /build/.ssh && \
    ssh-keyscan gitlab.my.org > /build/.ssh/known_hosts && \
    composer config --global gitlab-domains gitlab.my.org
```

```bash
docker run --rm \
    -e SSH_AUTH_SOCK=/ssh-agent \
    -v $SSH_AUTH_SOCK:/ssh-agent \
    -v $(pwd):/build/app \
    your/image:8.5 audit
```

## Notes

- Before 2026-11-25, the image also shipped phpstan, ecs, rector, phpunit and php-cs-fixer globally,
  with Xdebug for the coverage.
- `COMPOSER_ROOT_VERSION` is not set anymore: Composer reads the version of your project from git.
- PHP 8.6: the official image is built with ZTS (thread safety), unlike PHP 8.5 and earlier.
  Opcache is always present and PEAR is gone.
- Images are built for `linux/amd64` and `linux/arm64`.
