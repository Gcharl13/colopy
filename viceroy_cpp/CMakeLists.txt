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

# --- P1: headless economic-spine sim core (pure logic, no I/O) + golden tests ---
add_library(viceroy_sim STATIC
  sim/economy.cpp
  sim/market.cpp
  sim/turn.cpp
  sim/ref.cpp
  sim/immigration.cpp
  sim/game.cpp
  sim/unit.cpp
  sim/combat.cpp
  sim/natives.cpp
  sim/diplomacy.cpp
  sim/founding_fathers.cpp
)
target_include_directories(viceroy_sim PUBLIC sim)

enable_testing()
add_executable(sim_tests sim/tests/sim_tests.cpp)
target_link_libraries(sim_tests PRIVATE viceroy_sim)
add_test(NAME sim_tests COMMAND sim_tests)
