#!/usr/bin/env bash

set -e -o pipefail

echo "Cleaning XpringKit Project"

rm -rf *.xcodeproj
rm -rf XpringKit/generated
rm -f XpringKit/Resources/bundled.js

echo "All Done"
