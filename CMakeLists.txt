cmake_minimum_required(VERSION 2.8)
project(ringbuffer)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/priv)
file(GLOB RINGBUFFER_SRC src/*.c)

set(CMAKE_C_FLAGS "-g -O3 -pedantic -Wall -Wextra -Wno-unused-parameter -std=c99 -undefined dynamic_lookup -dynamiclib")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(${CMAKE_SOURCE_DIR}/cmake/FindErlang.cmake)

find_package(Erlang REQUIRED)

include_directories(
  SYSTEM
  ${ERLANG_EI_INCLUDE_DIR}
  ${ERLANG_EI_DIR}/src
)

link_directories(
  ${ERLANG_EI_LIBRARY_DIR}
)

add_executable(ringbuffer.so ${RINGBUFFER_SRC})
target_link_libraries(ringbuffer.so ${ERLANG_EI_LIBRARIES})
