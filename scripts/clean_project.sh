#!/usr/bin/env bash

set -e -o pipefail

echo "Cleaning XpringKit Project"

rm -rf *.xcodeproj
<<<<<<< HEAD
rm -rf XpringKit/generated/
rm -rf XpringKit/generated/legacy
=======
rm -rf XpringKit/generated
rm -rf XpringKit/generated/Legacy
>>>>>>> tmp
rm -f XpringKit/Resources/bundled.js

echo "All Done"
