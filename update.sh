#!/usr/bin/env bash

cd cryogen
lein run
cd ..
cp -r cryogen/resources/public/* .
