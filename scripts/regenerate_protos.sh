#!/usr/bin/env bash

set -e -o pipefail

echo "Regenerating Common Protos..."

LEGACY_PROTO_DIR=./XpringKit/generated/Legacy

mkdir -p $LEGACY_PROTO_DIR
protoc \
    --proto_path=./xpring-common-protocol-buffers/proto \
    --swift_opt=Visibility=Public \
    --swift_out=$LEGACY_PROTO_DIR \
    --swiftgrpc_out=$LEGACY_PROTO_DIR \
    ./xpring-common-protocol-buffers/proto/*.proto

echo "Prefixing Legacy Protocol Buffers"
cd $LEGACY_PROTO_DIR
for file in *.pb.swift
do
  mv "$file" "${file/.pb.swift/.legacy.pb.swift}"
done
for file in *.grpc.swift
do
  mv "$file" "${file/.grpc.swift/.legacy.grpc.swift}"
done

echo "All done!"
