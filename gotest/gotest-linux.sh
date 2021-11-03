#!/bin/sh
#
# Usage: gotest-linux.sh go-test-args...
#
set -euo pipefail

readonly root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
docker run --rm -it \
       --volume "$root":/module \
       --volume go-modcache:/go/pkg \
       --volume go-buildcache:/build/cache \
       --entrypoint go \
       ghcr.io/creachadair/gotest -- \
       test "$@"

