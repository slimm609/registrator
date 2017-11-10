#!/bin/bash

APP='registrator'
PKGDIR='pkg'
OSES=(
  'darwin'
  'linux'
)
GOARCH='amd64'

for GOOS in "${OSES[@]}"; do
  echo "Building $GOOS-$GOARCH binary"
  echo "-----"

  docker run --rm \
    -v "$PWD:/go/src/$APP" -w "/go/src/$APP" \
    -e "GOOS=$GOOS" -e "GOARCH=$GOARCH" \
    -e "GOPATH=/go/src/$APP" \
    golang:1.8 \
       go build -v -ldflags "-X main.Version=$(cat VERSION)" -o "$PKGDIR/$GOOS/registrator"
done

#  echo "Building linux-alpine binary"
#  echo "-----"

#  docker run --rm \
#      -v "$PWD:/go/src/$APP" -w "/go/src/$APP" \
#      -e "GOOS=linux" -e "GOARCH=$GOARCH" \
#      golang:1.9-alpine \
#        go build -v -o "$PKGDIR/linux-alpine/summon-s3"
