cmake_minimum_required(VERSION 3.15)

link_directories(${CMAKE_CURRENT_LIST_DIR}/lib/android/${ANDROID_ABI})
include_directories(${CMAKE_CURRENT_LIST_DIR}/include)

set(libuv uv)
