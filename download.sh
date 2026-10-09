#!/bin/bash

set -eo pipefail
cd "$(dirname "$0")"

REPO_ID="BluEye-Robotics/libuv-cmake"

getReleaseDownloadUrl() {
  RELEASE="tags/$1"

  if [ -n "$TOKEN" ]
  then
    curl --fail --silent --show-error --header "authorization: Bearer $TOKEN" "https://api.github.com/repos/$REPO_ID/releases/$RELEASE" |
        grep '"browser_download_url":' |
        sed -E 's/.*"([^"]+)".*/\1/'
  else
    curl --fail --silent --show-error "https://api.github.com/repos/$REPO_ID/releases/$RELEASE" |
        grep '"browser_download_url":' |
        sed -E 's/.*"([^"]+)".*/\1/'
  fi
}

TOKEN=$1
# Branch checkouts must use this version, even before its release is published.
# An exact tag can select a later packaging revision of the same dependency.
GIT_TAG=$(git describe --tags --exact-match 2>/dev/null || echo "v1.53.0-1")
if ! DOWNLOAD_URL=$(getReleaseDownloadUrl "$GIT_TAG"); then
  echo "Cannot download libuv release $GIT_TAG. Publish it first or run ./build.sh." >&2
  exit 1
fi

# Keep existing libraries intact if the release is unavailable or incomplete.
DOWNLOAD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/libuv-download.XXXXXX")
trap 'rm -rf "$DOWNLOAD_DIR"' EXIT
curl --fail --location "$DOWNLOAD_URL" -o "$DOWNLOAD_DIR/release.zip"
unzip -q "$DOWNLOAD_DIR/release.zip" -d "$DOWNLOAD_DIR/package"
test -f "$DOWNLOAD_DIR/package/include/uv.h"
test -d "$DOWNLOAD_DIR/package/lib"
rm -rf include lib
mv "$DOWNLOAD_DIR/package/include" "$DOWNLOAD_DIR/package/lib" .
