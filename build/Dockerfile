ARG RepositoryUri
FROM golang:1.19.1-alpine3.16 as builder
WORKDIR /go/src
ARG GOOFYS_VERSION=master
ARG GOOFYS_COMMIT_ID=829d8e5ce20faa3f9f6f054077a14325e00e9249
RUN apk add git make; \
  git clone --branch=${GOOFYS_VERSION} --depth=10 https://github.com/kahing/goofys.git; \
  cd goofys; \
  go get -u golang.org/x/crypto; \
  go get -u golang.org/x/net; \
  go get -u golang.org/x/sys; \
  go get -u golang.org/x/text; \
  go mod tidy; \
  git checkout ${GOOFYS_COMMIT_ID}; \
  make build; \
  chmod +x goofys;

FROM alpine:3.16.2
COPY --from=builder /go/src/goofys/goofys /usr/bin
COPY ./build/entrypoint.sh /entrypoint.sh
COPY ./build/stop.sh /stop.sh
RUN apk update && apk upgrade && apk add --no-cache  mailcap fuse

CMD ["/bin/sh","/entrypoint.sh"]

