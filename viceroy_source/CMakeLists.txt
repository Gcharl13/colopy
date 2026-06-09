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
#
# Excluded scaffolding:
#   - load_image/* : the FIRST-PASS raw decompiler output, named by EXE address
#     range (load_image_AAAAAA_BBBBBB.c).  These are control-flow skeletons that
#     still carry un-materialised `goto label_XXXXXX` targets and bare x86
#     register pseudo-vars (`ax`, ...).  The semantically-organised modules
#     (colony/, unit/, combat/, king/, market/, native/, ...) ARE the rules
#     layer and progressively REPLACE these skeletons; each load_image function
#     re-enters the build once it has been hand-ported into an organised module.
#     (All 16 files are still raw as of this milestone — excluded wholesale.)
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
# load_image/: raw first-pass decompiler scaffolding (see header note above)
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/load_image/.*\\.c$")

# ...but re-include load_image files that have been HAND-PORTED (broken auto
# bodies materialised from re_work/disasm/*.asm, verified to compile). Add each
# file here as it is ported; this list is the live "done" set for the backlog.
set(VICEROY_LOADIMAGE_PORTED
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_0102EA_010AA5.c"  # C-runtime far-string lib
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_00FAAA_0102C8.c"  # C-runtime near-string lib + stdio (fwrite/getenv/fgets/fseek/sprintf/filelength)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_0033F2_004E76.c"  # input/terrain helpers ported; 11 tile-blit/render fns stubbed (SDL plug-in points)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_012ADA_01A43C.c"  # accessor/prologue-heavy
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_00C0D0_00D27F.c"  # draw/status-line/palette-cycle/cursor/input (18 ported)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_007610_00824E.c"  # unit AI / combat-strength / movement-cost / per-power get-set (15 ported)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_004EE6_005DF0.c"  # main per-turn game loop + blit/string/cell-command (16 ported)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_005DF0_006939.c"  # tile influence/visibility paint + chain helpers + unit-tile-head (12 ported)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_00693A_00760F.c"  # unit spawn/place/chain ops + 8-neighbour search + chain accumulator (21 ported)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_00AB2E_00C0D0.c"  # colony order validation/eligibility + map cursor + glyph cells (15 ported, 2 stubs)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_0024C6_0033E9.c"  # tooltip + stacked-bar + text drawing layer (29 ported)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_010B26_012A83.c"  # C-runtime buffered file I/O (fopen/fflush/lseek/write/ftell/setvbuf; 11 ported, printf-core/overlay stubbed)
    "${CMAKE_CURRENT_SOURCE_DIR}/src/load_image/load_image_00E454_00FAA9.c"  # VGA/video layer: 4 ported (file-record dispatch); 7 stubbed (RLE sprite blits = SDL, exit/delay = host)
)
list(APPEND VICEROY_SOURCES ${VICEROY_LOADIMAGE_PORTED})

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
