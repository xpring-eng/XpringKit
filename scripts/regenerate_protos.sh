#!/usr/bin/env bash

set -e -o pipefail

##########################################################################
# Generate Protocol Buffers from Rippled.
##########################################################################

echo "Regenerating Protocol Buffers from Rippled"

LEGACY_PROTO_DIR=./XpringKit/generated/Legacy

mkdir -p $LEGACY_PROTO_DIR
protoc \
    --proto_path=./rippled/src/ripple/proto \
    --swift_opt=Visibility=Public \
    --swift_out=./XpringKit/generated \
    --swiftgrpc_out=./XpringKit/generated \
    ./rippled/src/ripple/proto/rpc/v1/*.proto

##########################################################################
# Regenerate legacy protocol buffers.
# TODO(keefertaylor): Remove this when rippled fully supports gRPC.
##########################################################################

echo "Regenerating Protocol Buffers from xpring-common-protocol-buffers"

# Directory to write generated code to (.js and .d.ts files)
mkdir -p ./XpringKit/generated/legacy
protoc \
    --proto_path=./xpring-common-protocol-buffers/proto \
    --swift_opt=Visibility=Public \
    --swift_out=./XpringKit/generated/legacy \
    --swiftgrpc_out=./XpringKit/generated/legacy \
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
