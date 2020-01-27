#!/usr/bin/env bash

set -e -o pipefail

echo "Cleaning XpringKit Project"

rm -rf *.xcodeproj
rm -rf XpringKit/generated
rm -rf XpringKit/Resources

echo "All Done"
