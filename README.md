# libuv-cmake

This repo provides scripts to build libuv via Conan, package them for the appropriate platforms and provide cmake scripts for simple integration. Currently, the scripts support the following platforms.

* iOS 11+
* Android 9.0+ (API 28)
* macOS x86_64 & arm64
* Linux x86_64 & arm64 (glibc)
* Windows x64 & ARM64

The current dependency is libuv 1.53.0. Conan Center does not yet carry this
version, so builds export the pinned recipe in `recipes/libuv` as
`libuv/1.53.0@blueye/stable`. The source archive is downloaded from libuv's official
distribution site and verified against the SHA-256 in `conandata.yml`. See the
recipe's README for its upstream revision and local changes.

`download.sh` uses the checkout's exact release tag, or `v1.53.0` for an untagged
checkout. It fails without replacing existing libraries if that release is not
yet available; build from source until the matching binaries are published.

## Building From Source

### Prerequisites (macOS)

Assuming Homebrew is already installed, run the following to install the required dependencies and toolchains:

```
brew install conan
```

Linux builds also require Docker with support for `linux/arm64` and
`linux/amd64` containers, as provided by Docker Desktop on macOS. They use
Ubuntu 24.04 with glibc, matching Surge's OpenSSL Linux builds. This replaces the
previous host-installed musl cross-compiler; these archives require glibc and
must not be linked into musl applications. CI uses ARM64 emulation.

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

On macOS this builds for iOS, Android, macOS and Linux. On Windows it auto-detects the platform and builds for Windows x64 and ARM64.

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
