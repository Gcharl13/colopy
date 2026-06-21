cmake_minimum_required(VERSION 3.16)
project(viceroy_cpp CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
add_compile_options(-Wall -Wextra)

# libpng: standard image library for the modern asset bundle (not a game codec).
find_package(PNG REQUIRED)

add_executable(viceroy_cpp
  src/main.cpp
  # importer (offline): original codec
  src/fab.cpp
  src/madspack.cpp
  src/ss.cpp
  src/pik.cpp
  # bundle + runtime
  src/bundle.cpp
  src/png_io.cpp
  src/mp.cpp
  src/pal.cpp
  src/render.cpp
  src/image_io.cpp
)
target_include_directories(viceroy_cpp PRIVATE include)
target_link_libraries(viceroy_cpp PRIVATE PNG::PNG)
