cmake_minimum_required(VERSION 3.16)
project(viceroy_cpp CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
add_compile_options(-Wall -Wextra)

add_executable(viceroy_cpp
  src/main.cpp
  src/fab.cpp
  src/madspack.cpp
  src/ss.cpp
  src/mp.cpp
  src/pal.cpp
  src/render.cpp
  src/image_io.cpp
)
target_include_directories(viceroy_cpp PRIVATE include)
