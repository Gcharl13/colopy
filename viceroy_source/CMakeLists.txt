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
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/main_modern\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/platform/.*\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/boot/entry\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/runtime/cstart\\.c$")
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/overlay/rtlink\\.c$")
# Phase 4.4 (2026-06-12): audio/ + asset/ now compile into the rules lib
# (RECONSTRUCTED-tier bodies; byte-verification is Phase 5).  Their DOS
# hardware leaves (outp/inp/file I/O) resolve to the platform layer / iolib.
# render/ INCLUDED (poke-converted 2026-06-09) except blit.c: its leaf-emitter
# wrappers are implemented by the platform layer (src/platform/render_glue.c)
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/render/blit\\.c$")
# Phase 3.4: screen_id_map.c is compiled as a direct viceroy_modern object so
# its strong overlay_call_181F_0772 definition beats the weak stub in
# linkfloor_stubs.c (archive members cannot override weak direct-object defs).
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/ui/screen_id_map\\.c$")
# Phase 3.5: msg_dialog_wiring.c provides strong overrides for the dialog/event
# thunk stubs (ovly_dialog_652/msg_show/msg_set_arg/msg_emit_num/rel_query/...).
# Must be a direct object — same reason as screen_id_map.c.
list(FILTER VICEROY_SOURCES EXCLUDE REGEX ".*/ui/msg_dialog_wiring\\.c$")
# load_image/ — all 16 files ported & verified to compile clean under
# -D_VICEROY_MODERN (stale "raw ax/label artifacts" exclusion removed
# 2026-06-09; these resident functions are overlay-thunk targets the
# tools/thunkwire.py wiring resolves into)

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
# viceroy_modern — the modern-host executable (milestone 3 first-light)
# ----------------------------------------------------------------------------
# Links the rules library against the GENERATED link floor:
#   tools/generated/linkfloor.ld      byte-exact DGROUP-global aliases
#   tools/generated/thunk_wiring.ld   overlay-thunk -> real-target aliases
#   tools/linkfloor_extra.ld          committed aliases (non-hex-named globals)
#   tools/generated/linkfloor_stubs.c weak no-op floor for everything else
#   tools/generated/thunk_keepalive.c forces alias targets out of the archive
# Regenerate after library changes:
#   python3 tools/thunkwire.py && python3 tools/linkgap.py
# ============================================================================
set(VICEROY_GEN "${CMAKE_CURRENT_SOURCE_DIR}/tools/generated")
if(EXISTS "${VICEROY_GEN}/linkfloor_stubs.c" AND EXISTS "${VICEROY_GEN}/thunk_wiring.ld")
    add_executable(viceroy_modern
        src/main_modern.c
        src/platform/pik.c
        src/platform/video_sdl.c
        src/platform/script_input.c
        src/platform/font.c
        src/platform/ss.c
        src/platform/render_glue.c
        src/platform/unit_blit.c
        src/platform/naval_glue.c
        src/platform/dgroup_image.c
        src/platform/timer.c
        src/platform/dos_isr_glue.c
        src/platform/dos_service_glue.c
        src/platform/headless_io_stubs.c
        "${VICEROY_GEN}/linkfloor_stubs.c"
        "${VICEROY_GEN}/thunk_keepalive.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/tools/thunk_keepalive_extra.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/tools/stub_hits.c"
        # Phase 3.4/3.5 strong overrides — must be direct objects (not archive members)
        # so they beat the weak stubs in linkfloor_stubs.c at link time.
        src/ui/screen_id_map.c
        src/ui/msg_dialog_wiring.c
    )
    target_link_libraries(viceroy_modern PRIVATE viceroy_rules)
    target_include_directories(viceroy_modern PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/include"
    )
    target_compile_definitions(viceroy_modern PRIVATE
        _VICEROY_MODERN
    )
    # SDL2: window/input when available; headless (PPM dumps) otherwise
    find_package(SDL2 QUIET)
    if(SDL2_FOUND)
        target_compile_definitions(viceroy_modern PRIVATE VICEROY_HAVE_SDL2)
        target_include_directories(viceroy_modern PRIVATE ${SDL2_INCLUDE_DIRS})
        if(TARGET SDL2::SDL2)
            target_link_libraries(viceroy_modern PRIVATE SDL2::SDL2)
        else()
            target_link_libraries(viceroy_modern PRIVATE ${SDL2_LIBRARIES})
        endif()
        message(STATUS "viceroy_modern: SDL2 video enabled")
    else()
        message(STATUS "viceroy_modern: SDL2 not found -- headless video only")
    endif()
    # linker-script INPUTS (not -T: they augment, never replace, the default)
    target_link_options(viceroy_modern PRIVATE
        "${VICEROY_GEN}/linkfloor.ld"
        "${VICEROY_GEN}/thunk_wiring.ld"
        "${CMAKE_CURRENT_SOURCE_DIR}/tools/linkfloor_extra.ld"
    )
else()
    message(STATUS "viceroy_modern skipped: run tools/thunkwire.py + tools/linkgap.py first")
endif()
