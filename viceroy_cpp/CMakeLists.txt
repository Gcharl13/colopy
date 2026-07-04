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

# --- Runtime renderer library: 320x200 indexed compositors + repo-asset
# loaders. PNG READING is stb_image (vendored) so the core builds with ZERO
# external deps everywhere (the native editor's game view needs it on every
# platform); libpng gates only the import/write pipeline (png_io + bundle),
# used by the asset CLI and the frame-dump modes.
add_library(viceroy_render STATIC
  src/native_assets.cpp
  src/mp.cpp
  src/pal.cpp
  src/render.cpp
  src/image_io.cpp
  # presentation (P4): 320x200 indexed surface + screen compositors
  src/surface.cpp
  src/mapview.cpp
  src/colony_screen.cpp
  src/popup_render.cpp
  # the original MADSPACK/FAB codec (pure, no libpng): lets the runtime load
  # the game's own .FF fonts / .SS sheets when the user's copy provides them
  src/fab.cpp
  src/madspack.cpp
  src/ss.cpp
  src/ff.cpp
)
target_include_directories(viceroy_render PUBLIC include . third_party/stb)
target_link_libraries(viceroy_render PUBLIC viceroy_sim)
if(PNG_FOUND)
  target_sources(viceroy_render PRIVATE src/png_io.cpp src/bundle.cpp)
  target_link_libraries(viceroy_render PUBLIC PNG::PNG)
endif()

# --- CLI: import-all / import / import-font / render / mapview (needs libpng) ---
if(PNG_FOUND)
  add_executable(viceroy_cpp
    src/main.cpp
    # importer (offline): PIK background codec (SS/FF live in viceroy_render)
    src/pik.cpp
  )
  target_link_libraries(viceroy_cpp PRIVATE viceroy_render)

  # --- The native application (N2): SDL2 window over the compositors. ---
  # SDL2 is optional (apt: libsdl2-dev); without it the app target is skipped
  # and everything else still builds. The app's --frames headless mode does
  # not need SDL and is what the ctest smoke runs.
  find_package(SDL2 QUIET)
  if(SDL2_FOUND)
    add_executable(viceroy src/viceroy_app.cpp)
    target_compile_definitions(viceroy PRIVATE VICEROY_HAVE_SDL=1)
    target_link_libraries(viceroy PRIVATE viceroy_render forge_core SDL2::SDL2)
    message(STATUS "SDL2 ${SDL2_VERSION} found -- building the `viceroy` application.")
  else()
    add_executable(viceroy src/viceroy_app.cpp)
    target_link_libraries(viceroy PRIVATE viceroy_render forge_core)
    message(STATUS "SDL2 not found -- `viceroy` builds HEADLESS-ONLY "
                   "(--frames mode); install libsdl2-dev for the window.")
  endif()
else()
  message(STATUS "libpng not found -- skipping the asset importer/renderer "
                 "(`viceroy_cpp`); `forge` + `sim_tests` still build.")
endif()

# --- Viceroy Forge: headless balance inspector (F1). Links the sim in-process;
#     the tiny JSON reader is forge-local so the sim core stays dependency-light. ---
# The game core shared by BOTH frontends: the session + engine VM + data
# layers, with no HTTP/web code. `forge` (web/editor) adds the routes +
# embedded UI on top; `viceroy` (the native application) links this directly.
add_library(forge_core STATIC
  forge/session.cpp
  forge/json.cpp
  forge/rules_json.cpp
  forge/mapedit.cpp
  forge/mod.cpp
  forge/savegame.cpp
  forge/drydock_bridge.cpp
  forge/drydock_api.cpp
  forge/datacheck.cpp
  forge/formulas.cpp
  forge/engine.cpp
  forge/turnpipe.cpp
  forge/native_powers.cpp
  forge/store.cpp
  forge/expr.cpp
)
target_include_directories(forge_core PUBLIC forge sim)
target_link_libraries(forge_core PUBLIC viceroy_sim drydock)

add_executable(forge
  forge/main.cpp
  forge/httpd.cpp
  forge/desktop.cpp
  forge/web_ui.cpp
)
target_include_directories(forge PRIVATE forge sim)
target_link_libraries(forge PRIVATE forge_core)
if(WIN32)
  # Winsock for the engine server; COM/shell/registry for the (legacy)
  # browser-window shell. The NATIVE editor (forge_studio) owns the Forge
  # name now; this web/CLI binary stays `forge` on every platform.
  target_link_libraries(forge PRIVATE ws2_32 ole32 uuid shell32 advapi32 user32)
endif()

# --- Forge Studio: the NATIVE desktop editor (no web technology). Dear ImGui
# (vendored, third_party/imgui) over a per-platform driver: Win32 + Direct3D
# 11 on Windows (zero external deps), SDL2 elsewhere. Opens a project folder
# and edits the game through the record-store chokepoint; the game view uses
# the native 320x200 compositor when libpng is available.
add_library(imgui STATIC
  third_party/imgui/imgui.cpp
  third_party/imgui/imgui_draw.cpp
  third_party/imgui/imgui_tables.cpp
  third_party/imgui/imgui_widgets.cpp
  third_party/imgui/imgui_stacklayout.cpp
)
target_include_directories(imgui PUBLIC third_party/imgui)

if(WIN32)
  set(FORGE_STUDIO_DRIVER studio/driver_win32_dx11.cpp
      third_party/imgui/backends/imgui_impl_win32.cpp
      third_party/imgui/backends/imgui_impl_dx11.cpp)
  set(FORGE_STUDIO_OK TRUE)
else()
  find_package(SDL2 QUIET)
  if(SDL2_FOUND)
    set(FORGE_STUDIO_DRIVER studio/driver_sdl2.cpp
        third_party/imgui/backends/imgui_impl_sdl2.cpp
        third_party/imgui/backends/imgui_impl_sdlrenderer2.cpp)
    set(FORGE_STUDIO_OK TRUE)
  else()
    set(FORGE_STUDIO_OK FALSE)
    message(STATUS "SDL2 not found -- skipping the native Forge editor "
                   "(forge_studio); install libsdl2-dev.")
  endif()
endif()

if(FORGE_STUDIO_OK)
  add_executable(forge_studio
    studio/studio_main.cpp
    studio/studio_assets.cpp
    studio/panel_sprites.cpp
    studio/panel_popups.cpp
    studio/panel_screens.cpp
    studio/panel_data.cpp
    studio/panel_map.cpp
    studio/game_views.cpp
    ${FORGE_STUDIO_DRIVER})
  target_include_directories(forge_studio PRIVATE studio forge sim)
  target_link_libraries(forge_studio PRIVATE imgui forge_core)
  set_target_properties(forge_studio PROPERTIES OUTPUT_NAME "Forge")
  if(WIN32)
    # a real GUI app: no console window behind the editor
    set_target_properties(forge_studio PROPERTIES WIN32_EXECUTABLE TRUE)
    target_link_libraries(forge_studio PRIVATE d3d11 dxgi d3dcompiler ole32 uuid shell32 user32 gdi32 dwmapi)
  else()
    target_link_libraries(forge_studio PRIVATE SDL2::SDL2)
  endif()
  # the game view runs on the stb-based renderer core -- every platform
  target_compile_definitions(forge_studio PRIVATE FORGE_STUDIO_GAME=1)
  target_link_libraries(forge_studio PRIVATE viceroy_render)
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
# AUTHORITY FLIP (ruling Q7, MIGRATION-LOG 20): data/base is the authoring
# truth now, free to diverge from the extraction as the user edits -- so the
# migration-era provenance gate (drydock_migrate.py --check as a ctest) is
# RETIRED. The script remains for reference regeneration. Loader correctness
# stays gated by drydock_tests (records -> RuleData faithfulness) and spec
# fidelity by verify_rules.py (compiled defaults == extraction, forever).
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

# Native render gate (N1): the application's asset path -- boot the sheet set
# from the repo's decoded assets (data_extracted + docs/atlas/pik) and compose
# a map-view frame. Fails on any missing/unreadable asset, palette-quantization
# breakdown, or compositor error. Runs from the repo root like forge_engine.
if(PNG_FOUND)
  add_test(NAME native_render COMMAND viceroy_cpp nativemap
           --out ${CMAKE_BINARY_DIR}/native_render_test.png --scale 1
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
  # Application smoke (N2): boot `viceroy` headless (--frames needs no SDL),
  # composing 2 frames with a unit step + sim end-turn between them -- proves
  # the full asset->state->compose->present pipeline minus the window.
  add_test(NAME viceroy_app_smoke COMMAND viceroy --frames 2 --scale 1
           --out ${CMAKE_BINARY_DIR}/viceroy_smoke
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
  # Popup frame engine (spec/ui/popups.md §2): render one popup through the
  # native compositor; asserts the byte-cited box geometry, writes a PNG.
  add_test(NAME native_popup COMMAND viceroy_cpp nativepopup
           --out ${CMAKE_BINARY_DIR}/native_popup_test.png --scale 1
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
endif()

# Native editor smoke (no web): boot Forge on the project under the SDL dummy
# driver for a few frames -- store load + dock layout + panels + exit 0.
if(FORGE_STUDIO_OK AND NOT WIN32)
  add_test(NAME forge_studio_smoke COMMAND forge_studio .
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)
  set_tests_properties(forge_studio_smoke PROPERTIES
    ENVIRONMENT "SDL_VIDEODRIVER=dummy;FORGE_FRAMES=5")
endif()

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
