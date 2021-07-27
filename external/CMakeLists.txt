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
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DLLVM_DIR=${llvm_project_INSTALL_DIR}/lib/cmake/llvm
        -DWITH_PYTHON_BINDINGS=OFF
        -DWITH_TESTS=OFF
        -DWITH_TUTORIALS=OFF
        -DWITH_DOCS=OFF
        -DBUILD_SHARED_LIBS=OFF # to disable building autoscheduler
    BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --parallel --target Halide
    DEPENDS llvm_project
)

set(LLVM_DIR ${CMAKE_BINARY_DIR}/llvm/lib/cmake/llvm)
find_package(LLVM REQUIRED)

llvm_map_components_to_libnames(llvm_targets mcjit bitwriter linker passes RISCV X86)

add_library(imported_libhalide STATIC IMPORTED)
set_property(TARGET imported_libhalide PROPERTY
    IMPORTED_LOCATION ${CMAKE_BINARY_DIR}/halide/lib/libHalide.a)
add_library(Halide INTERFACE)
add_dependencies(Halide halide_project)
target_compile_features(Halide INTERFACE cxx_std_17)
target_link_libraries(Halide INTERFACE imported_libhalide ${llvm_targets})
target_include_directories(Halide INTERFACE "$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/halide/include>")
