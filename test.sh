#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ROLE="${1:-cli}"
if [ "$ROLE" != "cli" ] && [ "$ROLE" != "fpm" ] && [ "$ROLE" != "apache" ]; then
    >&2 echo "Bad role given"
    exit 1;
fi

SPIP_ROLE="${ROLE}"
if [ "$ROLE" == "cli" ]; then
    SPIP_ROLE=tools
fi

if [ "$ROLE" == "cli" ] || [ "$ROLE" == "fpm" ]; then
    ROLE="${ROLE}-alpine"
fi

# Check official images against ours
for version in 5.6 7.1 7.4 8.0 8.1 8.2 8.3;
do
    SPIP_IMAGE="spip/${SPIP_ROLE}:${version}"
    DOCKER_IMAGE="php:${version}-${ROLE}"

    >&2 echo -e "${NC}Looking for last PHP (${ROLE}) version in ${version} branch...${NC}"
    PATCH_VERSION=
    if docker pull ${DOCKER_IMAGE} > /dev/null 2>&1; then
        PATCH_VERSION=$(docker run --rm -it ${DOCKER_IMAGE} php --version | grep -E "^PHP" | cut -d" " -f 2)
        echo "${PATCH_VERSION}"
    else
        >&2 echo -e "${RED}Docker image not found for ${version} (${ROLE}) branch${NC}"
    fi

    if [ -n "${PATCH_VERSION}" ];then
        >&2 echo -e "${NC}Comparing with last SPIP (${SPIP_ROLE}) version in ${version} branch...${NC}"
        OUR_PATCH_VERSION=
        if docker pull ${SPIP_IMAGE} > /dev/null 2>&1; then
            OUR_PATCH_VERSION=$(docker run --rm -it --entrypoint docker-php-entrypoint ${SPIP_IMAGE} --version | grep -E "^PHP" | cut -d" " -f2)
            if test "${PATCH_VERSION}" != "${OUR_PATCH_VERSION}"; then
                >&2 echo -e "${YELLOW}${SPIP_IMAGE} to build${NC}"
            else
                >&2 echo -e "${NC}Nothing to do${NC}"
            fi
        else
            >&2 echo -e "${YELLOW}${SPIP_IMAGE} to build${NC}"
        fi
    fi
done
# EXTENSION_DIR=$(php -r 'echo ini_get("extension_dir");')
# php-config --extension-dir
