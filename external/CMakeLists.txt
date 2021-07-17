include(ExternalProject)

set(llvm_project_INSTALL_DIR ${CMAKE_BINARY_DIR}/llvm)

ExternalProject_Add(llvm_project
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/llvm-project/llvm
    INSTALL_DIR ${llvm_project_INSTALL_DIR}
    CMAKE_ARGS
        -DLLVM_TARGETS_TO_BUILD=X86$<SEMICOLON>RISCV$<SEMICOLON>
        -DLLVM_ENABLE_PROJECTS=clang
        -DLLVM_ENABLE_TERMINFO=OFF
        -DLLVM_ENABLE_ASSERTIONS=ON
        -DLLVM_ENABLE_RTTI=ON
        -DCMAKE_CROSSCOMPILING=True
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
)

ExternalProject_Add(halide_project
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Halide
    INSTALL_DIR ${CMAKE_BINARY_DIR}/halide
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DLLVM_DIR=${llvm_project_INSTALL_DIR}/lib/cmake/llvm
    BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --parallel --target Halide
    DEPENDS llvm_project
    BUILD_ALWAYS TRUE
)
