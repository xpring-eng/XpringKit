#!/usr/bin/env bash

set -e -o pipefail

##########################################################################
# Generate Protocol Buffers from Hermes for ILP.
##########################################################################

echo "Regenerating Protocol Buffers from Hermes ILP"

ILP_SWIFT_OUT_DIR=./XpringKit/generated/ilp

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

SWIFT_OUT_DIR=./XpringKit/generated

mkdir -p $SWIFT_OUT_DIR
protoc \
    --proto_path=./rippled/src/ripple/proto/ \
    --swift_opt=Visibility=Public \
    --swift_out=$SWIFT_OUT_DIR \
    --swiftgrpc_out=$SWIFT_OUT_DIR \
    ./rippled/src/ripple/proto/org/xrpl/rpc/v1/*.proto

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
  if [[ $file != *".legacy."* ]];
  then
    mv "$file" "${file/.pb.swift/.legacy.pb.swift}"
  fi
done
for file in *.grpc.swift
do
  if [[ $file != *".legacy."* ]];
  then
    mv "$file" "${file/.grpc.swift/.legacy.grpc.swift}"
  fi
done

echo "All done!"
