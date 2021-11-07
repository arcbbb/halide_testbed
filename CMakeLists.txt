cmake_minimum_required(VERSION 3.5)

project(halide_testbed)

set(LLVM_DIR "" CACHE STRING "LLVM PATH")
set(WITH_PYTHON_BINDINGS OFF CACHE BOOL "")
set(WITH_TESTS OFF CACHE BOOL "")
set(WITH_TUTORIALS OFF CACHE BOOL "")
set(WITH_DOCS OFF CACHE BOOL "")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "") # to disable building autoscheduler

add_subdirectory(external)
add_subdirectory(test)
