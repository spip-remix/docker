# Friends of SPIP

## Build

```bash
./test.sh
./test.sh apache
./test.sh fpm
```

## Usage

Locally:

```bash
docker run \
    --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) \
    spip/tools:<version> <command>
```

in a `.gitlab-ci.yml`:

```yml
my-job:
    stage: my-stage
    image: spip/tools:<version>
    script:
        - <[command ...]>
    artifacts:
        - build
```

Custom your own image:

```Dockerfile
FROM spip/tools:<version>
ENV COMPOSER_AUTH="{\"github-oauth\": {\"github.com\": \"xxxxx\"}, \"gitlab-token\": {\"gitlab.my.org\":\"xxxxx\"}}"
COPY <my-tool>.make /root/makefiles
RUN apk --no-cache add openssh git && \
    install-php-extensions gd zip && \
    ssh-keyscan gitlab.my.org > /root/.ssh/known_host && \
    composer config --global gitlab-domains gitlab.my.org
```

```bash
docker run \
    --rm \
    -e SSH_AUTH_SOCK=/ssh-agent
    -v $(pwd):$(pwd) \
    -v $SSH_AUTH_SOCK:/ssh-agent
    -w $(pwd) \
    spip/tools:<version> <command>
```

## TODO

### V1

- composer validate
- tester la présence de fichiers optionels (phpcs.xml OU phpcs.xml.dist, idem phpstan, phpunit)
- Préciser la syntaxe des fichiers de conf des outils
  - `phplint.lst` : parallel-lint dir1 dir2
- xdebug v2.x config
- check composer audit capability (`composer help audit > /dev/null 2>&1`: 1 si KO, 0 si OK)
- finaliser makefile (help, découpe makefiles/*.make, ...)
- set COMPOSER_HOME to /composer (+VOLUME ? sur le cache ?) use as root or random uid
- attention à  /root/.jq si random uid (essayer /usr/local/lib/jq)

### V2

- `phplint.exclude.lst` optional
  - parallel-lint --exclude src/templates --exclude tests/fixtures src tests
  - parallel-lint <--exclude "$(cat phplint.exclude.lst)"> $(cat phplint.lst)
- jq + root/.jq as modules
- include /makefiles/*.make
- dossier `build` par défaut, env. var. pour personaliser
- phpunit
- deptrac
- composer install
- rector --dry-run
- template config files + check command
- src files hash(js turbo like)

```bash
snyk container test spip/tools --file=Dockerfile --exclude-base-image-vulns
```

### V3

- "spip-cli"
- "checkout"

## apache/fpm

workdir=/var/www/html
