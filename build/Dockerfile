ARG RepositoryUri
FROM golang:1.15.12-alpine3.13 as builder
WORKDIR /go/src
ARG GOOFYS_VERSION=master
ARG GOOFYS_COMMIT_ID=829d8e5ce20faa3f9f6f054077a14325e00e9249
RUN apk add git make; \
  git clone --branch=${GOOFYS_VERSION} --depth=10 https://github.com/kahing/goofys.git; \
  cd goofys; \
  git checkout ${GOOFYS_COMMIT_ID}; \
  make build; \
  chmod +x goofys;

FROM alpine:3.13.6
COPY --from=builder /go/src/goofys/goofys /usr/bin
COPY ./build/entrypoint.sh /entrypoint.sh
COPY ./build/stop.sh /stop.sh
RUN apk add --no-cache mailcap
CMD ["/bin/sh","entrypoint.sh"]

