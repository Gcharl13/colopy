cmake_minimum_required(VERSION 3.16)
project(viceroy_cpp CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
# GCC/Clang warning flags; MSVC doesn't understand them (it uses /W...).
if(NOT MSVC)
  add_compile_options(-Wall -Wextra)
endif()

# libpng: needed ONLY by the offline asset importer/renderer (the `viceroy_cpp`
# target). The sim core, `forge` (incl. its browser GUI), and `sim_tests` don't use
# it -- so it's optional: without libpng the importer is skipped and everything else
# still builds (handy for a zero-dep Windows build of the Forge).
find_package(PNG)

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
  sim/training.cpp
  sim/explore.cpp
  sim/events.cpp
  sim/trade_routes.cpp
  sim/ai.cpp
  sim/mapgen.cpp
)
target_include_directories(viceroy_sim PUBLIC sim)

# --- CLI: import-all / import / import-font / render / mapview (needs libpng) ---
if(PNG_FOUND)
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
else()
  message(STATUS "libpng not found -- skipping the asset importer/renderer "
                 "(`viceroy_cpp`); `forge` + `sim_tests` still build.")
endif()

# --- Viceroy Forge: headless balance inspector (F1). Links the sim in-process;
#     the tiny JSON reader is forge-local so the sim core stays dependency-light. ---
add_executable(forge
  forge/main.cpp
  forge/json.cpp
  forge/rules_json.cpp
  forge/mapedit.cpp
  forge/mod.cpp
  forge/savegame.cpp
  forge/drydock_bridge.cpp
  forge/datacheck.cpp
  forge/formulas.cpp
  forge/engine.cpp
  forge/turnpipe.cpp
  forge/native_powers.cpp
  forge/store.cpp
  forge/expr.cpp
  forge/httpd.cpp
  forge/web_ui.cpp
)
target_include_directories(forge PRIVATE forge sim)
target_link_libraries(forge PRIVATE viceroy_sim drydock)
if(WIN32)
  target_link_libraries(forge PRIVATE ws2_32)   # Winsock for `forge serve`
endif()

# --- Drydock (engine-dev-environment-spec.md): record-database dev environment.
#     P0: canonical text module + tests. C++17 per Phase-0 ruling. ---
add_library(drydock STATIC
  drydock/text/rec_text.cpp
  drydock/schema/schema.cpp
  drydock/pack/pack.cpp
  drydock/core/store.cpp
)
add_executable(drydockc drydock/drydockc.cpp)
target_link_libraries(drydockc PRIVATE drydock)
# host-side codegen (spec 7 consumer #1): schema .rec -> structs + reflection
# tables. Runs at build time; the generated header lands in the build tree.
add_executable(drydock-gen drydock/schema/codegen.cpp)
target_link_libraries(drydock-gen PRIVATE drydock)
set(DD_GEN_DIR ${CMAKE_BINARY_DIR}/dd_gen)
file(GLOB DD_SCHEMA_FILES ${CMAKE_CURRENT_SOURCE_DIR}/../data/schema/*.rec)
add_custom_command(
  OUTPUT ${DD_GEN_DIR}/dd_gen.hpp
  COMMAND drydock-gen ${CMAKE_CURRENT_SOURCE_DIR}/../data/schema ${DD_GEN_DIR}
  DEPENDS drydock-gen ${DD_SCHEMA_FILES}
  COMMENT "drydock-gen: schema -> structs + reflection tables")
add_custom_target(dd_gen_header DEPENDS ${DD_GEN_DIR}/dd_gen.hpp)
target_include_directories(drydock PUBLIC drydock)

find_program(PYTHON3 python3)
enable_testing()
add_executable(sim_tests sim/tests/sim_tests.cpp)
target_link_libraries(sim_tests PRIVATE viceroy_sim)
add_test(NAME sim_tests COMMAND sim_tests)
add_executable(drydock_tests drydock/tests/drydock_tests.cpp forge/drydock_bridge.cpp)
target_link_libraries(drydock_tests PRIVATE drydock viceroy_sim)
add_dependencies(drydock_tests dd_gen_header)
target_include_directories(drydock_tests PRIVATE ${DD_GEN_DIR} drydock/core)
# drydock_tests reads the authored schemas under data/schema/ -> repo root cwd
add_test(NAME drydock_tests COMMAND drydock_tests
         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
# HARD GATE (spec 10.4): validate + canonical byte-identity over the FULL data
# set, then compile + read back the pack.
add_test(NAME drydockc_gate COMMAND drydockc data -o ${CMAKE_BINARY_DIR}/game.pack
         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
if(PYTHON3)
  # data/base provenance: a regeneration from the extraction tables must be
  # byte-identical to the committed .rec files.
  add_test(NAME drydock_migrate_check COMMAND ${PYTHON3} tools/drydock_migrate.py --check
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
endif()
add_test(NAME forge_map COMMAND forge map selftest)
add_test(NAME forge_rules COMMAND forge rules selftest)
add_test(NAME forge_mod COMMAND forge mod selftest)
add_test(NAME forge_save COMMAND forge save selftest)
add_test(NAME forge_data COMMAND forge data selftest)
# forge_engine reads real data (GAME.TXT messages, @-table cells, graphs) under
# data_extracted/, so run it from the repo root (the parent of this source dir).
add_test(NAME forge_engine COMMAND forge engine selftest
         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
# forge_bundle exports the whole game (graphs/screens/scenarios/tables) as one data bundle and
# round-trips it, so it likewise reads data_extracted/ from the repo root (B13).
add_test(NAME forge_bundle COMMAND forge bundle selftest
         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)

# Data-integrity gates (B12): schema binding resolution + cross-reference validation.
# Python, data-only; run from the repo root where the JSON data lives.
if(PYTHON3)
  add_test(NAME validate_schema COMMAND ${PYTHON3} tools/validate_schema.py
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
  add_test(NAME validate_all COMMAND ${PYTHON3} tools/validate_all.py
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
endif()

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

  # imnodes -- the node-graph canvas widget (also no CMakeLists; add imnodes.cpp).
  FetchContent_Declare(imnodes
    GIT_REPOSITORY https://github.com/Nelarius/imnodes.git
    GIT_TAG v0.5)
  FetchContent_GetProperties(imnodes)
  if(NOT imnodes_POPULATED)
    FetchContent_Populate(imnodes)
  endif()

  add_executable(forge_gui
    forge/gui/forge_gui.cpp
    forge/json.cpp
    forge/rules_json.cpp
    forge/mapedit.cpp
    forge/engine.cpp            # the in-process node-graph VM (catalog/run_graph/bind)
    ${imgui_SOURCE_DIR}/imgui.cpp
    ${imgui_SOURCE_DIR}/imgui_draw.cpp
    ${imgui_SOURCE_DIR}/imgui_tables.cpp
    ${imgui_SOURCE_DIR}/imgui_widgets.cpp
    ${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.cpp
    ${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
    ${imnodes_SOURCE_DIR}/imnodes.cpp
  )
  target_include_directories(forge_gui PRIVATE
    forge sim ${imgui_SOURCE_DIR} ${imgui_SOURCE_DIR}/backends ${imnodes_SOURCE_DIR})
  target_link_libraries(forge_gui PRIVATE viceroy_sim glfw OpenGL::GL)
endif()
