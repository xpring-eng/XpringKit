#!/usr/bin/env bash

set -e -o pipefail

##########################################################################
# Generate Protocol Buffers from Hermes for ILP.
##########################################################################

echo "Regenerating Protocol Buffers from Hermes ILP"

ILP_SWIFT_OUT_DIR=./XpringKit/ILP/Generated

mkdir -p $ILP_SWIFT_OUT_DIR
protoc \
    --proto_path=./hermes-ilp/protocol-buffers/proto/ \
    --swift_opt=Visibility=Public \
    --swift_out=$ILP_SWIFT_OUT_DIR \
    --swiftgrpc_out=$ILP_SWIFT_OUT_DIR \
    ./hermes-ilp/protocol-buffers/proto/*.proto

##########################################################################
# Generate Protocol Buffers from Rippled.
##########################################################################

echo "Regenerating Protocol Buffers from Rippled"

SWIFT_OUT_DIR=./XpringKit/XRP/Generated/

mkdir -p $SWIFT_OUT_DIR
protoc \
    --proto_path=./rippled/src/ripple/proto/ \
    --swift_opt=Visibility=Public \
    --swift_out=$SWIFT_OUT_DIR \
    --swiftgrpc_out=$SWIFT_OUT_DIR \
    ./rippled/src/ripple/proto/org/xrpl/rpc/v1/*.proto

echo "All done!"
