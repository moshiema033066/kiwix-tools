#!/usr/bin/env sh

# Build (or update) /data/library.xml with all ZIM files found in /data.
set -eu

for zim in /data/*.zim; do
  [ -e "$zim" ] || continue  # skip if glob didn't match
  echo "Adding $zim to library.xml"
  kiwix-manage /data/library.xml add "$zim" || true
done 