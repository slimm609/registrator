#!/bin/bash

APP='registrator'
PKGDIR='pkg'
OSES=(
  'darwin'
  'linux'
)
GOARCH='amd64'

export GOPATH=$(pwd)

go get
#### THIS SECTION IS HERE UNTIL DEPS ARE MOVED TO THE NEW ETCD ####
go get -u github.com/ugorji/go/codec/codecgen

cd src/github.com/coreos/go-etcd/etcd
$GOPATH/bin/codecgen -d 1978 -o response.generated.go response.go
cd $GOPATH
###################################################################

for GOOS in "${OSES[@]}"; do
  echo "Building $GOOS-$GOARCH binary"
  echo "-----"

  docker run --rm \
    -v "$PWD:/go/src/$APP" -w "/go/src/$APP" \
    -e "GOOS=$GOOS" -e "GOARCH=$GOARCH" \
    -e "GOPATH=/go/src/$APP" \
    golang:1.9 \
       go build -v -ldflags "-X main.Version=$(cat VERSION)" -o "$PKGDIR/$GOOS/registrator"
done

  echo "Building Alpine golang docker image"
  echo "-----"
  docker build -f Dockerfile.alpine_build -t golang:1.9-alpine-gcc .

  echo "Building linux-alpine binary"
  echo "-----"

  docker run --rm \
      -v "$PWD:/go/src/$APP" -w "/go/src/$APP" \
      -e "GOOS=linux" -e "GOARCH=$GOARCH" \
      -e "GOPATH=/go/src/$APP" \
      golang:1.9-alpine-gcc \
        go build -v -ldflags "-X main.Version=$(cat VERSION)" -o "$PKGDIR/$GOOS-alpine/registrator"

rm -rf bin/ src/
