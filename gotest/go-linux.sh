#!/bin/sh
#
# Usage: go-linux.sh go-args...
#
set -euo pipefail

readonly root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
docker run --rm -it \
       --volume "$root":/module \
       --volume buildcache:/build/cache \
       --volume modcache:/go/pkg \
       ghcr.io/creachadair/gotest

