# Android NDK r30 recipe

The Conan Center Android NDK recipe is vendored from
[`conan-io/conan-center-index` at `91293b3587f541b81d7371b91e1bdc6fb953cc19`](https://github.com/conan-io/conan-center-index/tree/91293b3587f541b81d7371b91e1bdc6fb953cc19/recipes/android-ndk/all).
The recipe and wrapper files are unchanged; `conandata.yml` adds only r30.
It is exported as `android-ndk/r30@blueye/stable` by the Android build script
until Conan Center publishes r30.

The download URLs come from Google's SDK repository. Each archive's SHA-256
was calculated after verifying its SHA-1 against the official repository
metadata for NDK `30.0.16248370`. All Android profiles use API 28.

When Conan Center carries r30, switch the profiles to its recipe and remove
the local export and this directory. The MIT license for the recipe is in
`LICENSE`; the NDK distribution carries its own notices.
