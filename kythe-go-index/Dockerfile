# Build an image including the tools needed to generate Kythe indexes from a
# repository of Go code.

# Stage 1: Base image shared by staging and runtime.
FROM golang:1.17-bullseye AS base

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates wget

# Stage 2: Fetch a precompiled release of Kythe and copy out the pieces we need
# for Go indexing. The intermediate image will be discarded.
FROM base AS install
ARG KYTHE_VERSION=v0.0.55
ARG DIR=/usr/local/kythe
WORKDIR /build
RUN wget -q https://github.com/kythe/kythe/releases/download/${KYTHE_VERSION}/kythe-${KYTHE_VERSION}.tar.gz
RUN tar -xzf kythe-${KYTHE_VERSION}.tar.gz
RUN mv kythe-${KYTHE_VERSION} kythe && mkdir -p ${DIR}/bin && \
    cp -p kythe/extractors/go_extractor ${DIR}/bin && \
    cp -p kythe/indexers/go_indexer ${DIR}/bin && \
    cp -p -r kythe/tools/* ${DIR}/bin
    # cp -p kythe/extractors/proto_extractor ${DIR}/bin && \
    # cp -p kythe/indexers/proto_indexer ${DIR}/bin

# Stage 3: Copy the reduced toolset.
# The code to be indexed should be mapped onto /code (read-only is OK).
# The output should be mapped onto /data.
FROM base AS run
COPY --from=install /usr/local/kythe/ /usr/local/kythe
COPY ./entrypoint.sh /usr/bin/
ENV KYTHE_DIR=/usr/local/kythe
ENV PATH="${PATH}:${KYTHE_DIR}/bin"
VOLUME /code
WORKDIR /code
VOLUME /data
ENTRYPOINT ["entrypoint.sh"]
