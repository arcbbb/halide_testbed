cmake_minimum_required(VERSION 3.5)

project(halide_testbed)

set(LLVM_DIR "" CACHE STRING "LLVM PATH")

add_subdirectory(external)
add_subdirectory(test)
