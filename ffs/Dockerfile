FROM golang:1.26-alpine AS build
ARG PROXY TAGS
RUN apk add build-base git
RUN GOPROXY=${PROXY} go install -tags ${TAGS} github.com/creachadair/ffstools/ffs@latest

FROM alpine:latest AS run
ARG DESC
LABEL org.opencontainers.image.source=https://github.com/creachadair/docker-images
LABEL org.opencontainers.image.description="${DESC}"
VOLUME /data
WORKDIR /data
COPY --from=build /go/bin/ffs /usr/local/bin
ENTRYPOINT ["/usr/local/bin/ffs"]
