#!/bin/bash

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
    cmake --build . --parallel &&
    cmake --install .
  )
}

build_halide()
{
  llvmdir=$PWD/install-llvm/lib/cmake/llvm
  build=$PWD/build-halide
  (
    mkdir -p $build
    cd $build
    cmake ..                        \
        -DCMAKE_BUILD_TYPE=Release  \
        -DLLVM_DIR=$llvmdir
    make -j test
  )
}

build_llvm
build_halide
