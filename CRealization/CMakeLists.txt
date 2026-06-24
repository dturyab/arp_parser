cmake_minimum_required(VERSION 3.10)
project(demo)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(demo demo.c)

target_link_libraries(demo
    PRIVATE
        arp_parser
)

target_compile_options(demo PRIVATE
    -Wall
    -Wextra
    -Wpedantic
)

add_subdirectory(arp_parser)