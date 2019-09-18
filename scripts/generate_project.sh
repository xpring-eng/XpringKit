#!/usr/bin/env bash

set -e -o pipefail

echo "Generating XpringKit Project"

# Regenerate protocol buffers so the generated sources get picked up by xcodegen.
echo "Regenerating Protocol Buffers"
./scripts/regenerate_protos.sh

# Run carthage bootstrap to build dependencies.
echo "Bootstrapping Carthage Dependencies"
carthage bootstrap --platform iOS --cache-builds

# Generate the project.
echo "Generating Project"
xcodegen generate
open XpringKit.xcodeproj
