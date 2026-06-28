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

# --- headless economic-spine sim core (pure logic, no I/O) + golden tests ---
add_library(viceroy_sim STATIC
  sim/economy.cpp
  sim/market.cpp
  sim/turn.cpp
  sim/ref.cpp
  sim/immigration.cpp
  sim/game.cpp
  sim/rules.cpp
  sim/rules_invariants.cpp
  sim/unit.cpp
  sim/unit_turn.cpp
  sim/combat.cpp
  sim/natives.cpp
  sim/diplomacy.cpp
  sim/founding_fathers.cpp
)
target_include_directories(viceroy_sim PUBLIC sim)

# --- CLI: import-all / import / import-font / render / mapview ---
add_executable(viceroy_cpp
  src/main.cpp
  # importer (offline): original codec
  src/fab.cpp
  src/madspack.cpp
  src/ss.cpp
  src/pik.cpp
  src/ff.cpp
  # bundle + runtime
  src/bundle.cpp
  src/png_io.cpp
  src/mp.cpp
  src/pal.cpp
  src/render.cpp
  src/image_io.cpp
  # presentation (P4): map-view screen compositor
  src/surface.cpp
  src/mapview.cpp
  src/colony_screen.cpp
)
# `include` for the engine headers, `.` so mapview.cpp resolves "sim/*.hpp".
target_include_directories(viceroy_cpp PRIVATE include .)
target_link_libraries(viceroy_cpp PRIVATE PNG::PNG viceroy_sim)

# --- Viceroy Forge: headless balance inspector (F1). Links the sim in-process;
#     the tiny JSON reader is forge-local so the sim core stays dependency-light. ---
add_executable(forge
  forge/main.cpp
  forge/json.cpp
  forge/rules_json.cpp
  forge/mapedit.cpp
  forge/mod.cpp
)
target_include_directories(forge PRIVATE forge sim)
target_link_libraries(forge PRIVATE viceroy_sim)

enable_testing()
add_executable(sim_tests sim/tests/sim_tests.cpp)
target_link_libraries(sim_tests PRIVATE viceroy_sim)
add_test(NAME sim_tests COMMAND sim_tests)
add_test(NAME forge_map COMMAND forge map selftest)
add_test(NAME forge_rules COMMAND forge rules selftest)
add_test(NAME forge_mod COMMAND forge mod selftest)

# --- Optional Dear ImGui desktop GUI (forge/gui). OFF by default: it needs network
#     (FetchContent) + an OpenGL/GLFW dev environment, so the normal build and CI
#     stay dependency-light. Enable locally with: cmake -DFORGE_GUI=ON ...
#     The GUI reuses the tested forge backend; only its ImGui glue is GUI-only. ---
option(FORGE_GUI "Build the Dear ImGui desktop tool (needs network + OpenGL/GLFW)" OFF)
if(FORGE_GUI)
  include(FetchContent)
  find_package(OpenGL REQUIRED)

  set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
  set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
  set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
  FetchContent_Declare(glfw
    GIT_REPOSITORY https://github.com/glfw/glfw.git
    GIT_TAG 3.4)
  FetchContent_MakeAvailable(glfw)

  # Dear ImGui ships no CMakeLists -- populate and add its sources directly.
  FetchContent_Declare(imgui
    GIT_REPOSITORY https://github.com/ocornut/imgui.git
    GIT_TAG v1.91.5)
  FetchContent_GetProperties(imgui)
  if(NOT imgui_POPULATED)
    FetchContent_Populate(imgui)
  endif()

  add_executable(forge_gui
    forge/gui/forge_gui.cpp
    forge/json.cpp
    forge/rules_json.cpp
    forge/mapedit.cpp
    ${imgui_SOURCE_DIR}/imgui.cpp
    ${imgui_SOURCE_DIR}/imgui_draw.cpp
    ${imgui_SOURCE_DIR}/imgui_tables.cpp
    ${imgui_SOURCE_DIR}/imgui_widgets.cpp
    ${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.cpp
    ${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
  )
  target_include_directories(forge_gui PRIVATE
    forge sim ${imgui_SOURCE_DIR} ${imgui_SOURCE_DIR}/backends)
  target_link_libraries(forge_gui PRIVATE viceroy_sim glfw OpenGL::GL)
endif()
