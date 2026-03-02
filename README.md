# libuv-cmake

This repo provides scripts to build libuv via Conan, package them for the appropriate platforms and provide cmake scripts for simple integration. Currently, the scripts support the following platforms.

* iOS 11+
* Android 5.0+
* macOS x86 & arm64
* Linux x86 & arm64
* Windows x64

## Building From Source

### Prerequisites (macOS)

Assuming Homebrew is already installed, run the following to install the required dependencies and toolchains:

```
brew install conan
brew install FiloSottile/musl-cross/musl-cross
brew reinstall FiloSottile/musl-cross/musl-cross --with-aarch64
```

### Prerequisites (Windows)

Install Python and Conan:

```
pip install conan
conan profile detect
```

### Build

To build libuv, run the following command:

```
./build.sh
```

On macOS this builds for iOS, Android, macOS and Linux. On Windows it auto-detects the platform and builds for Windows x64.

You can also specify platforms explicitly:

```
./build.sh windows
./build.sh ios android macos linux
```

The build script also supports the following arguments:

```
--package: packages the headers and binaries into a zip file.
```

## Downloading Prebuilt Binaries

Run the following to download prebuilt binaries for all listed platforms. The script will download the release associated with the current commit you have checked out, otherwise it will download the latest release available.

```
./download.sh
```
