FROM golang:1.18-alpine AS build
ARG PROXY TAGS
RUN apk add build-base git
RUN GOPROXY=${PROXY} go install -tags ${TAGS} github.com/creachadair/ffstools/blobd@latest

FROM alpine:latest AS run
LABEL org.opencontainers.image.source=https://github.com/creachadair/docker-images
VOLUME /data
WORKDIR /data
COPY --from=build /go/bin/blobd /usr/local/bin
ENTRYPOINT ["/usr/local/bin/blobd"]
