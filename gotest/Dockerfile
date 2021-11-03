#
# To run:
#    docker run --rm -it -v $REPO_ROOT:/module -v modcache:/go/pkg gotest
#
FROM golang:1.17-alpine
LABEL org.opencontainers.image.source=https://github.com/creachadair/docker-images
RUN apk add build-base git linux-headers
ENV GOCACHE=/build/cache
VOLUME /go/pkg      # preserve the module cache
VOLUME /build/cache # preserve the build cache
VOLUME /module      # the repository to be tested
WORKDIR /module
ENTRYPOINT ["/bin/sh"]
