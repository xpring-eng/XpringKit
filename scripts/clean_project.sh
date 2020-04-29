#!/usr/bin/env bash

set -e -o pipefail

echo "Cleaning XpringKit Project"

rm -rf *.xcodeproj
rm -rf XpringKit/ILP/Generated
rm -rf XpringKit/XRP/Generated
rm -rf XpringKit/Resources
rm -rf XpringKit/PayID/Generated/

echo "All Done"
