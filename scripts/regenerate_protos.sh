#!/usr/bin/env bash

set -e -o pipefail

##########################################################################
# Generate Protocol Buffers from Rippled.
##########################################################################

echo "Regenerating Protocol Buffers from Rippled"

PROTO_PATH="./rippled/src/ripple/proto"
OUT_DIR="./XpringKit/generated"

mkdir -p $OUT_DIR
protoc \
    --proto_path=$PROTO_PATH \
    --swift_opt=Visibility=Public \
    --swift_out=$OUT_DIR \
    --swiftgrpc_out=$OUT_DIR \
    ./rippled/src/ripple/proto/rpc/v1/*.proto

##########################################################################
# Regenerate legacy protocol buffers.
# TODO(keefertaylor): Remove this when rippled fully supports gRPC.
##########################################################################

echo "Regenerating Protocol Buffers from xpring-common-protocol-buffers"

# Directory to write generated code to (.js and .d.ts files)
LEGACY_PROTO_PATH="./xpring-common-protocol-buffers/proto"
LEGACY_OUT_DIR="./XpringKit/generated/Legacy"
mkdir -p $LEGACY_OUT_DIR
protoc \
    --proto_path=$LEGACY_PROTO_PATH \
    --swift_opt=Visibility=Public \
    --swift_out=$LEGACY_OUT_DIR \
    --swiftgrpc_out=$LEGACY_OUT_DIR \
    ./xpring-common-protocol-buffers/proto/*.proto

echo "Prefixing Legacy Protocol Buffers"
cd $LEGACY_OUT_DIR
for file in *.pb.swift
do
  mv "$file" "${file/.pb.swift/.legacy.pb.swift}"
done
for file in *.grpc.swift
do
  mv "$file" "${file/.grpc.swift/.legacy.grpc.swift}"
done

echo "All done!"
