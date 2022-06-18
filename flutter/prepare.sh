#!/usr/bin/env bash

cat > lib/endpoint.dart <<EOF
const ENDPOINT = "$(cat "$(dirname "${BASH_SOURCE[0]}")/../endpoint.url")";
EOF
