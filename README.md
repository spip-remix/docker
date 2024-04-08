# Friends of SPIP

## Build

### PHP CLI (a.k.a. spip/tools)

```bash
jq -r '.[]|
    "docker build"+
    " -t spip/tools:"+.version+
    " -t spip/tools:"+.php+
    (if .latest then " -t spip/tools" else "" end)+
    " --build-arg PHP="+.php+
    " --build-arg XDEBUG="+.xdebug+
    (if .composer then " --build-arg COMPOSER="+.composer else "" end)+
    (if .make then " --build-arg MAKE="+.make else "" end)+
    (if .jq then " --build-arg JQ="+.jq else "" end)+
    " --build-arg TOOLS=\""+(.tools|join(" "))+"\" ."
' versions.json > build.sh
sh build.sh
rm build.sh
docker push --all-tags spip/tools
```

### apache+mod_php (a.k.a. spip/apache)

```bash
jq -r '.[]|
    "docker build"+
    " -t spip/apache:"+.version+
    " -t spip/apache:"+.php+
    (if .latest then " -t spip/apache" else "" end)+
    " --build-arg PHP="+.php+
    " --build-arg XDEBUG="+.xdebug+" -f Dockerfile.apache ."
' versions.json > apache-build.sh
sh apache-build.sh
rm apache-build.sh
docker push --all-tags spip/apache
```

### PHP-FPM (a.k.a. spip/fpm)

```bash
jq -r '.[]|
    "docker build"+
    " -t spip/fpm:"+.version+
    " -t spip/fpm:"+.php+
    (if .latest then " -t spip/fpm" else "" end)+
    " --build-arg PHP="+.php+
    " --build-arg XDEBUG="+.xdebug+" -f Dockerfile.fpm ."
' versions.json > fpm-build.sh
sh fpm-build.sh
rm fpm-build.sh
docker push --all-tags spip/fpm
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
snyk container test holisticagency/friendsofsonar --file=Dockerfile --exclude-base-image-vulns
```
