# libuv-cmake

Cross-platform libuv build system using Conan. Produces static libraries packaged as GitHub releases for consumption by downstream projects (Surge).

## Repository Structure

- `profiles/` - Conan profiles for each platform/arch combination (e.g. `ios-armv8.profile`, `windows-x64.profile`)
- `scripts/build-library.sh` - Core build script that runs `conan install` with a profile and copies outputs
- `build.sh` - Top-level build orchestrator. Accepts platform names (`ios`, `android`, `macos`, `linux`, `windows`) and `--package` flag
- `download.sh` - Downloads prebuilt binaries from the matching GitHub release
- `conanfile.txt` - Declares libuv version and Conan generators
- `.github/workflows/ci-build.yaml` - CI: builds all platforms, packages into zip, publishes GitHub release on tag push

## Build Flow

1. `build.sh` calls `scripts/build-library.sh <profile> [output-dir]` for each arch
2. `build-library.sh` runs `conan install` with the matching profile, extracts lib/include paths from generated `.pc` files, and copies artifacts
3. `build-library.sh` normalizes library names: `libuv_a.a` → `libuv.a`, `uv_a.lib` → `uv.lib`, and updates `.cmake` files accordingly
4. `build.sh` post-processes platform outputs (lipo for macOS universal, xcframework for iOS, library rename for Windows)
5. `--package` creates a `package.zip` with `include/` and `lib/`

## Supported Platforms

- iOS (armv8, simulator armv8+x86 → xcframework)
- Android (armv8, armv7, x86_64, x86)
- macOS (armv8 + x86 → universal binary via lipo)
- Linux (armv8, x86)
- Windows (x64 — library renamed from libuv.lib to uv.lib)

## Windows Notes

- Windows profiles use `compiler.runtime=static` for static CRT linking
- Conan auto-detects the MSVC version (no hardcoded compiler version in profiles)
- Output library is renamed to match CMake link expectations: `uv.lib`

## CI/CD

- Triggered on push to `main` and version tags (`v*`)
- Two parallel build jobs: unix (macOS runner, builds iOS/Android/macOS/Linux), windows (Windows runner)
- Artifacts merged into a single `package.zip` and uploaded as a GitHub release on tag push

## Releasing

Push a version tag to trigger a release:

```
git tag v1.48.0-3
git push origin v1.48.0-3
```

## Dependencies

- libuv version is declared in `conanfile.txt`
- Conan 2.x required
