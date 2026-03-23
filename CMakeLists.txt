cmake_minimum_required(VERSION 3.16)
project(Example C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(CppUTest REQUIRED)

add_compile_options(-Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Werror)

add_subdirectory(Source)

enable_testing()
add_subdirectory(Tests)
