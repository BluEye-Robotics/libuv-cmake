#!/bin/bash

set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR=${SCRIPT_DIR}/../build
cd ${SCRIPT_DIR}

PROFILE=$1
OUTPUT_LIB_DIR=../lib/$PROFILE
PROFILE_PARAMS="--profile ../profiles/$PROFILE.profile"

if [[ -n "$2" ]]; then
  OUTPUT_LIB_DIR=../lib/$2
fi

if [[ "$PROFILE" == *"android"* ]]; then
  PROFILE_PARAMS="--profile:host ../profiles/$PROFILE.profile --profile:build default"
fi

mkdir -p ${OUTPUT_LIB_DIR}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
conan install .. $PROFILE_PARAMS --build=missing
cd ${SCRIPT_DIR}

# Find the .pc file (libuv or libuv-static)
PC_FILE=$(find ${BUILD_DIR} -name "libuv*.pc" | head -n1)

prefix=$(sed -n 's|^prefix=\(.*\)|\1|p' "$PC_FILE")
libdir=$(sed -n "s|^libdir=\${prefix}/\(.*\)|$prefix/\1|p" "$PC_FILE")
includedir=$(sed -n "s|^includedir=\${prefix}/\(.*\)|$prefix/\1|p" "$PC_FILE")

if [[ -d "$includedir" && ! -d ../include ]]; then
  echo "Copying includes from $includedir"
  cp -r "$includedir" ../include
fi

if [[ -d "$libdir" ]]; then
  echo "Copying libs from $libdir to $OUTPUT_LIB_DIR"
  cp -r "$libdir"/* "$OUTPUT_LIB_DIR"
else
  echo "Library directory not found in $libdir"
  exit 1
fi

# Rename libuv_a to libuv for consistent naming.
# Handles both Unix (.a) and Windows (.lib) static libraries.
for file in "$OUTPUT_LIB_DIR"/libuv_a.a "$OUTPUT_LIB_DIR"/uv_a.lib; do
  if [[ -f "$file" ]]; then
    mv "$file" "${file/_a/}"
  fi
done
if [[ "$OSTYPE" == "darwin"* ]]; then
  find "$OUTPUT_LIB_DIR" -type f -name "*.cmake" -exec sed -i '' 's/uv_a/uv/g' {} +
else
  find "$OUTPUT_LIB_DIR" -type f -name "*.cmake" -exec sed -i 's/uv_a/uv/g' {} +
fi

# Clean up
rm -rf ${BUILD_DIR}