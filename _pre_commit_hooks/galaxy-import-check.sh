#!/usr/bin/env bash
# Build the collection and run the same importer Galaxy runs on publish.
set -euo pipefail

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

ansible-galaxy collection build --force --output-path "$out" . >/dev/null
# The importer writes importer_result.json to the working directory.
cd "$out"
python -m galaxy_importer.main ./*.tar.gz
