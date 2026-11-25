#!/usr/bin/env bash
# Regenerates the "Supported tags" tables of the Docker Hub overviews (docs/hub/*.md)
# from versions.json, between the <!-- tags:start --> and <!-- tags:end --> markers.
#
# Only the maintained versions (8.2+, the ones checked by build.sh) are listed:
# older tags stay on Docker Hub but are not rebuilt anymore.
#
# Usage: docs/hub/tags.sh

set -euo pipefail

cd "$(dirname "$0")/../.."

table() {
    jq -r --arg role "$1" '
        map(select((.version | split(".") | map(tonumber? // 0)) >= [8, 2]))
        | reverse
        | (if $role == "tools"
            then "| Tags | PHP | Notes |\n|---|---|---|"
            else "| Tags | PHP | Xdebug | Notes |\n|---|---|---|---|"
          end),
          (.[]
            | ((.version | split(".") | map(tonumber? // 0)) >= [8, 6]) as $zts
            | "| `" + .version + "`, `" + .php + "`" + (if .latest then ", `latest`" else "" end)
              + " | " + .php
              + (if $role == "tools" then "" else " | " + (if .xdebug == "0" then "not available yet" else .xdebug end) end)
              + " | " + ([
                  (if $zts then "ZTS build (official image)" else empty end),
                  (if $role == "tools" and ((.cli_exts // []) + (.cli_pie // []) | map(select(test("pcov"))) | length) == 0
                    then "no pcov yet: no `test-coverage`" else empty end),
                  (if .latest then "default tag" else empty end)
                ] | join(", "))
              + " |")
    ' versions.json
}

for role in tools fpm apache; do
    file="docs/hub/${role}.md"
    tmp="$(mktemp)"
    table "${role}" > "${tmp}.table"
    awk -v table="${tmp}.table" '
        /<!-- tags:start -->/ { print; while ((getline line < table) > 0) print line; skip = 1; next }
        /<!-- tags:end -->/ { skip = 0 }
        !skip { print }
    ' "${file}" > "${tmp}"
    mv "${tmp}" "${file}"
    rm -f "${tmp}.table"
    echo "${file} updated"
done
