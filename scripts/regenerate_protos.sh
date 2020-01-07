#!/usr/bin/env bash

set -e -o pipefail

##########################################################################
# Generate Protocol Buffers from Rippled.
##########################################################################

echo "Regenerating Protocol Buffers from Rippled"

PROTO_PATH="./rippled/src/ripple/proto/"
OUT_DIR="./XpringKit/generated/"

mkdir -p ./XpringKit/generated
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
mkdir -p ./XpringKit/generated/legacy
protoc \
    --proto_path=./xpring-common-protocol-buffers/proto \
    --swift_opt=Visibility=Public \
    --swift_out=./XpringKit/generated/legacy \
    --swiftgrpc_out=./XpringKit/generated/legacy \
    ./xpring-common-protocol-buffers/proto/*.proto

echo "All done!"
