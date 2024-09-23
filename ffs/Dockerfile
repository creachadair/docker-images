FROM golang:1.23-alpine AS base
RUN apk add build-base git
RUN git clone https://github.com/creachadair/ffstools

FROM base AS build
ARG PROXY TAGS
RUN cd ffstools && \
    GOPROXY=${PROXY} go install -tags ${TAGS} github.com/creachadair/ffstools/ffs

FROM alpine:latest AS run
ARG DESC
LABEL org.opencontainers.image.source=https://github.com/creachadair/docker-images
LABEL org.opencontainers.image.description="${DESC}"
VOLUME /data
WORKDIR /data
COPY --from=build /go/bin/ffs /usr/local/bin
ENTRYPOINT ["/usr/local/bin/ffs"]
