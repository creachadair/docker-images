#!/bin/sh
#
# Usage: go-linux.sh go-args...
#
set -euo pipefail

readonly root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
docker run --rm -it \
       --volume "$root":/module \
       --volume go-buildcache:/build/cache \
       --volume go-modcache:/go/pkg \
       ghcr.io/creachadair/gotest

