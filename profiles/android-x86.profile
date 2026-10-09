include(default)

[settings]
os=Android
os.api_level=28
arch=x86
compiler=clang
compiler.libcxx=c++_shared
compiler.version=21

[tool_requires]
*: android-ndk/r30@blueye/stable
