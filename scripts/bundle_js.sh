#!/usr/bin/env bash

set -e -o pipefail

WORKING_DIR=$(pwd)

echo "Bundling JS"
cd terram

echo ">> Installing Node Dependencies"
npm i
echo ">> Done Installing Node Dependencies"

echo ">> Running Webpack."
npm run webpack
echo ">> Done Running Webpack"

echo "Done Bundling JS"

cd $WORKING_DIR
echo "Copying Artifacts"
mkdir -p ./XpringKit/Resourses
cp terram/dist/bundled.js ./XpringKit/Resources/
