#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREY='\033[0;30m'
NC='\033[0m' # No Color

ROLE="${1:-cli}"
if [ "$ROLE" != "cli" ] && [ "$ROLE" != "fpm" ] && [ "$ROLE" != "apache" ]; then
    >&2 echo "Bad role given"
    exit 1;
fi

ENTRYPOINT=
VERSION_COMMAND="php --version"
DOCKERFILE=
PACKAGES=
TOOLS=
SPIP_ROLE="${ROLE}"

if [ "$ROLE" == "cli" ]; then
    SPIP_ROLE=tools
    ENTRYPOINT="--entrypoint docker-php-entrypoint"
    VERSION_COMMAND="--version"
    PACKAGES='(if .composer then " --build-arg COMPOSER="+.composer else "" end)+
    (if .make then " --build-arg MAKE="+.make else "" end)+
    (if .jq then " --build-arg JQ="+.jq else "" end)+'
    TOOLS='" --build-arg TOOLS=\""+(.tools|join(" "))+"\""+'
fi

if [ "$ROLE" == "cli" ] || [ "$ROLE" == "fpm" ]; then
    ROLE="${ROLE}-alpine"
fi

if [ "$ROLE" == "apache" ] || [ "$ROLE" == "fpm-alpine" ]; then
    DOCKERFILE="\" -f Dockerfile.${ROLE}\"+"
fi

TO_BUILD=

echo "Dockerfile:${DOCKERFILE}"
echo "Role:${ROLE}"
echo "SPIP Role:${SPIP_ROLE}"

# Check official images against ours
for version in 5.6 7.0 7.1 7.2 7.3 7.4 8.0 8.1 8.2 8.3 8.4;
do
    SPIP_IMAGE="spip/${SPIP_ROLE}:${version}"
    DOCKER_IMAGE="php:${version}-${ROLE}"

    echo -e "${GREY}PHP${version} (${ROLE}) ...${NC}"
    [[ "${DEBUG}" ]] && >&2 echo -e "${GREY}Looking for last PHP (${ROLE}) version in ${version} branch...${NC}"
    PATCH_VERSION=$(docker run --pull always --rm "${DOCKER_IMAGE}" php --version 2>&1 | grep -E "^PHP" | cut -d" " -f 2)
    [[ -z "${PATCH_VERSION}" ]] && >&2 echo -e "${RED}Docker image not found for PHP${version} (${ROLE}) branch${NC}"

    if [ -n "${PATCH_VERSION}" ];then
        [[ "${DEBUG}" ]] && >&2 echo -e "${GREY}Comparing with last SPIP (${SPIP_ROLE}) version in ${version} branch...${NC}"
        OUR_PATCH_VERSION=$(docker run --pull always --rm ${ENTRYPOINT} "${SPIP_IMAGE}" ${VERSION_COMMAND} 2>&1 | grep -E "^PHP" | cut -d" " -f 2)
        [[ "${PATCH_VERSION}" != "${OUR_PATCH_VERSION}" ]] && {
            echo -e "${YELLOW}${SPIP_IMAGE} to build${NC}"
            TO_BUILD="${TO_BUILD}${version} "
        } || {
            echo -e "${GREEN}OK${NC}"
            [[ "${DEBUG}" ]] && >&2 echo -e "${GREY}Nothing to do for PHP${version} (${ROLE})${NC}"
        }
    fi
done

[[ -z $TO_BUILD ]] && echo -e "${GREY}Nothing to do.${NC}" && exit 0
TO_BUILD=$(jq -Rr '[.|split(" ")|.[]|".version==\""+.+"\""]|join(" or ")|"select("+.+")"' <<< "${TO_BUILD%% }")

jq -r '.[]|'"${TO_BUILD}"'|
    "docker build"+
    " --platform linux/amd64,linux/arm64"+
    " -t spip/'${SPIP_ROLE}':"+.version+
    " -t spip/'${SPIP_ROLE}':"+.php+
    (if .latest then " -t spip/'${SPIP_ROLE}'" else "" end)+
    " --build-arg PHP="+.php+
    " --build-arg XDEBUG="+.xdebug+
    '"${PACKAGES}"'
    (if .exts then " --build-arg EXTS=\""+(.exts|join(" "))+"\"" else "" end)+
    '"${TOOLS}"'
    '"${DOCKERFILE}"'
    " ."
' versions.json > build.sh

sh build.sh
#docker push --all-tags "spip/${SPIP_ROLE}"

exit 0
