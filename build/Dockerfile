ARG RepositoryUri
FROM golang:1.15.12-alpine3.13 as builder
WORKDIR /go/src
ARG GOOFYS_VERSION=master
RUN apk add git make; \
  git clone --branch=${GOOFYS_VERSION} --depth=1 https://github.com/kahing/goofys.git; \
  cd goofys; \
  make build; \
  chmod +x goofys;

FROM alpine:3.13.6
COPY --from=builder /go/src/goofys/goofys /usr/bin
COPY ./build/entrypoint.sh /entrypoint.sh
COPY ./build/stop.sh /stop.sh
CMD ["/bin/sh","entrypoint.sh"]

