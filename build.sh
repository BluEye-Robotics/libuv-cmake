#!/bin/bash

buildiOS() {
  scripts/build-library.sh ios-armv8
  scripts/build-library.sh iossimulator-armv8
  scripts/build-library.sh iossimulator-x86

  mkdir lib/iossimulator
  lipo \
   	lib/iossimulator-armv8/libuv.a \
   	lib/iossimulator-x86/libuv.a \
   	-create -output lib/iossimulator/libuv.a \

  xcodebuild -create-xcframework \
    -library lib/ios-armv8/libuv.a \
    -library lib/iossimulator/libuv.a \
  	-output lib/ios/libuv.xcframework

  rm -r lib/ios-armv8 lib/iossimulator-armv8 lib/iossimulator-x86 lib/iossimulator
}

buildAndroid() {
  scripts/build-library.sh android-armv8 android/arm64-v8a
  scripts/build-library.sh android-armv7 android/armeabi-v7a
  scripts/build-library.sh android-x86_64 android/x86_64
  scripts/build-library.sh android-x86 android/x86
}

buildMacOS() {
  scripts/build-library.sh macos-armv8 macos/armv8
  scripts/build-library.sh macos-x86 macos/x86

  lipo \
    lib/macos/armv8/libuv.a \
    lib/macos/x86/libuv.a \
    -create -output lib/macos/libuv.a

  rm -rf lib/macos/armv8 lib/macos/x86
}

buildLinux() {
  scripts/build-library.sh linux-armv8 linux/armv8
  scripts/build-library.sh linux-x86 linux/x86
}

buildWindows() {
  scripts/build-library.sh windows-x64 windows/x64

  # Normalize: CMake links 'uv' which expects uv.lib, but Conan produces libuv.lib
  for dir in lib/windows/*/; do
    if [[ -f "$dir/libuv.lib" ]]; then
      mv "$dir/libuv.lib" "$dir/uv.lib"
    fi
  done
}

set -e

cd "$(dirname "$0")"

# Parse arguments: platform names and --package flag
PLATFORMS=()
PACKAGE=false
for arg in "$@"; do
  case "$arg" in
    --package) PACKAGE=true ;;
    *) PLATFORMS+=("$arg") ;;
  esac
done

# If no platforms specified, auto-detect based on OS
if [[ ${#PLATFORMS[@]} -eq 0 ]]; then
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OS" == "Windows_NT" ]]; then
    PLATFORMS=(windows)
  else
    PLATFORMS=(ios android macos linux)
  fi
fi

rm -rf lib include

for platform in "${PLATFORMS[@]}"; do
  case "$platform" in
    ios) buildiOS ;;
    android) buildAndroid ;;
    macos) buildMacOS ;;
    linux) buildLinux ;;
    windows) buildWindows ;;
    *) echo "Unknown platform: $platform"; exit 1 ;;
  esac
done

if $PACKAGE; then
  zip -r package.zip include lib
  echo "Package has been created at $(pwd)/package.zip"
fi
