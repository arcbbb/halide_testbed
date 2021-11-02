include(ExternalProject)

ExternalProject_Add(halide_project
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Halide
    INSTALL_DIR ${CMAKE_BINARY_DIR}/halide
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DLLVM_DIR=${LLVM_DIR}
        -DWITH_PYTHON_BINDINGS=OFF
        -DWITH_TESTS=OFF
        -DWITH_TUTORIALS=OFF
        -DWITH_DOCS=OFF
        -DBUILD_SHARED_LIBS=OFF # to disable building autoscheduler
    BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --parallel --target Halide
)

find_package(LLVM REQUIRED PATHS ${LLVM_DIR})

llvm_map_components_to_libnames(llvm_targets mcjit bitwriter linker passes RISCV X86)

add_library(imported_libhalide STATIC IMPORTED)
set_property(TARGET imported_libhalide PROPERTY
    IMPORTED_LOCATION ${CMAKE_BINARY_DIR}/halide/lib64/libHalide.a)
add_library(Halide INTERFACE)
add_dependencies(Halide halide_project)
target_compile_features(Halide INTERFACE cxx_std_17)
target_link_libraries(Halide INTERFACE imported_libhalide ${llvm_targets})
target_include_directories(Halide INTERFACE "$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/halide/include>")
