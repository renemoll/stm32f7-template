cmake_minimum_required(VERSION 3.13)
project(nucleo_data_recorder VERSION 1.0 LANGUAGES ASM C CXX)

find_package(Python3 COMPONENTS Interpreter)

include(cmake/googletest.cmake)
include(cmake/stm32f7.cmake)
include(cmake/bob.cmake)

set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

configure_file(cmake/config.h.in config.h)


add_subdirectory(src)

if (NOT ${CMAKE_CROSSCOMPILING})
	add_subdirectory(tests)
endif()

# Todo:
# - clang format
# - Position independent code?
# - include-what-you-use / LINK_WHAT_YOU_USE?
