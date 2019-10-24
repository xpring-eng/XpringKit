#!/usr/bin/env bash

set -e -o pipefail

echo "Generating XpringKit Project"

# Regenerate protocol buffers so the generated sources get picked up by xcodegen.
echo "Regenerating Protocol Buffers"
./scripts/regenerate_protos.sh

# Bundle JavaScript from Xpring Common JavaScript.
echo "Bundling JavaScript"
./scripts/bundle_js.sh

# Generate the project.
echo "Generating Project"
xcodegen generate -s project_cocoapods.yml
open XpringKit.xcodeproj
