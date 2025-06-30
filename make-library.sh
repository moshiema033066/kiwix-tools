#!/usr/bin/env sh

set -eu
for zim in /data/*.zim; do
  [ -e "$zim" ] || continue
  echo "Adding $zim to library.xml"
  kiwix-manage /data/library.xml add "$zim" || true
done 