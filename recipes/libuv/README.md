# libuv 1.53.0 Conan recipe

This recipe is adapted from [Conan Center Index at b565a81d0f6e003b02e51378e208f03d6b824198](https://github.com/conan-io/conan-center-index/tree/b565a81d0f6e003b02e51378e208f03d6b824198/recipes/libuv/all).
Its MIT license is preserved in `LICENSE`.

Conan Center currently lists libuv through 1.51.0. The build scripts export this
recipe locally as `libuv/1.53.0@blueye/stable` before installing dependencies, so
builds do not depend on an untracked cache modification or an upstream recipe
appearing later.

Local changes:

* Pin the recipe and official source archive to 1.53.0, with a SHA-256 checksum.
* Use the Blueye fork as the recipe URL and export the recipe license.
* Include all Windows system libraries listed by libuv 1.53.0's CMake build,
  including `ole32`, `shell32`, and `synchronization`.

The remaining build and packaging logic is kept from the upstream recipe.
When Conan Center supports the required version, this override can be removed
and `conanfile.txt` switched back to the public reference after validation.
