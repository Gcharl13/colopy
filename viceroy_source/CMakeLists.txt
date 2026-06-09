cmake_minimum_required(VERSION 3.16)
project(ViceroyModern C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# ============================================================================
# Modern rules-layer build (-D_VICEROY_MODERN)
# ----------------------------------------------------------------------------
# This is the "milestone 2/3" target: the DOS game logic compiled against the
# DGROUP memory layer (include/dgroup.h) on a modern 64-bit host.
#
# Platform leaves still TODO:
#   - boot/entry.c   : DOS MZ entry + system_init  (replaced by main_modern.c)
#   - runtime/cstart.c : DOS C startup              (replaced by main_modern.c)
#   - overlay/rtlink.c : RTLink overlay loader      (replaced by flat link)
#   - audio, asset, render leaves (SDL swap-points — milestone 3)
# ============================================================================

# Gather all C sources, then exclude platform-only files
file(GLOB_RECURSE VICEROY_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
)

# Exclude DOS platform files + unrealised SDL platform-layer stubs
# (audio, asset, render: replaced by SDL/modern implementations in milestone 3)
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/boot/entry\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/runtime/cstart\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/overlay/rtlink\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/audio/.*\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/asset/.*\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/render/.*\\.c$")
# Exclude load_image first-pass skeletons (all still have raw ax/label artifacts;
# milestone 3 will port these one by one and add them back via VICEROY_LOADIMAGE_PORTED)
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/load_image/.*\\.c$")

# Rules library — all game logic, compiled in modern mode
add_library(viceroy_rules STATIC ${VICEROY_SOURCES})

target_include_directories(viceroy_rules PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_compile_definitions(viceroy_rules PUBLIC
    _VICEROY_MODERN
)

target_compile_options(viceroy_rules PRIVATE
    -Wall
    -Wno-unused-variable
    -Wno-unused-function
    -Wno-implicit-function-declaration
    # pointer-cast warnings are expected during the migration
    -Wno-pointer-to-int-cast
    -Wno-int-to-pointer-cast
    -Wno-incompatible-pointer-types
)

# ============================================================================
# Stub main (milestone 3 placeholder — SDL front end goes here)
# ============================================================================
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/main_modern.c")
    add_executable(viceroy_modern
        src/main_modern.c
    )
    target_link_libraries(viceroy_modern PRIVATE viceroy_rules)
    target_include_directories(viceroy_modern PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/include"
    )
    target_compile_definitions(viceroy_modern PRIVATE
        _VICEROY_MODERN
    )
endif()
