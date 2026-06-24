cmake_minimum_required(VERSION 3.10)

add_library(arp_parser STATIC)

target_sources(arp_parser
    PRIVATE
        src/arp_parser.c
)

target_include_directories(arp_parser
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)