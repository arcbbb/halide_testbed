
add_executable(test test.cpp)
target_link_libraries(test Halide)

add_executable(vadd add.cpp)
target_link_libraries(vadd Halide)
