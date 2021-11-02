#!/bin/bash

module load python

build_llvm()
{
  src=$PWD/external/llvm-project/llvm
  build=$PWD/build-llvm
  dst=$PWD/install-llvm
  (
    mkdir -p $build
    cd $build &&
    cmake $src \
        -DCMAKE_INSTALL_PREFIX=$dst  \
        -DLLVM_TARGETS_TO_BUILD="X86;RISCV;" \
        -DLLVM_ENABLE_PROJECTS=clang \
        -DLLVM_ENABLE_TERMINFO=OFF   \
        -DLLVM_ENABLE_ASSERTIONS=ON  \
        -DLLVM_ENABLE_RTTI=ON        \
        -DCMAKE_CROSSCOMPILING=True  \
        -DCMAKE_BUILD_TYPE=Release &&
    cmake --build . --parallel 25 &&
    cmake --install .
  )
}

build_halide()
{
  llvmdir=$PWD/install-llvm/lib/cmake/llvm
  (
    mkdir -p build-halide
    cd build-halide
    cmake .. -DLLVM_DIR=$llvmdir
    make -j25 halide_project
  )
}

build_llvm
build_halide
