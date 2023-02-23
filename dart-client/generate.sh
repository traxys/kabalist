#!/usr/bin/env bash

SPEC=$(dirname "${BASH_SOURCE[0]}")/../openapi.json

rm -rf lib doc test build pubspec.yaml pubspec.lock

openapi-generator-cli \
	generate \
	-i "$SPEC" \
	-g dart \
	-c ./open-generator-config.yaml
