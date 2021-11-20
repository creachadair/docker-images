#!/bin/bash
set -euo pipefail

readonly goroot="$(go env GOROOT)"

find . -type f -name go.mod -print | while read -r mod ; do
    echo "-- $mod" 1>&2
    pushd "$(dirname $mod)" 1>/dev/null
    modname="$(go list -m)"
    go mod download

    modout="$(echo $modname | tr '/' '-')"
    go list ./... | xargs -t go_extractor -continue \
			  -corpus "$modname" \
			  -goroot "$goroot" \
			  -output "/data/${modout}.kzip"
    popd
done

find /data -type f -name '*.kzip' -print \
    | xargs -t go_indexer -code \
    | entrystream -unique -write_format riegeli \
    > /data/index-data.riegeli
