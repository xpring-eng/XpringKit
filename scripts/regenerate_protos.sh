#!/usr/bin/env bash

set -e -o pipefail

echo "Regenerating Terram Protos..."

mkdir -p ./XpringKit/generated
protoc \
    --proto_path=./terram-protos/proto \
    --swift_opt=Visibility=Public \
    --swift_out=./XpringKit/generated \
    --swiftgrpc_out=./XpringKit/generated \
    ./terram-protos/proto/*.proto

echo "All done!"
