#!/bin/sh
# compile_check.sh -- prove the whole game core compiles for the Teensy 4.1's
# Cortex-M7 (IMXRT1062) with the same flags the PlatformIO build uses. This
# is the CI-able half of the port: the Arduino-framework frontend files
# (main.cpp / sd_syscalls.cpp / ili9341.hpp) need the Teensy core headers and
# are built by `pio run` on a machine with registry access.
#
# Usage: teensy/compile_check.sh   (from the repo root)
set -e
CXX=arm-none-eabi-g++
FLAGS="-mcpu=cortex-m7 -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb
       -std=gnu++17 -fexceptions -frtti -Os -ffunction-sections -fdata-sections
       -DVICEROY_TEENSY=1
       -Iviceroy_cpp/include -Iviceroy_cpp -Iviceroy_cpp/forge -Iviceroy_cpp/sim
       -Iviceroy_cpp/third_party/stb"
OUT=$(mktemp -d)
trap 'rm -rf "$OUT"' EXIT

SRC="
viceroy_cpp/sim/*.cpp
viceroy_cpp/src/surface.cpp viceroy_cpp/src/render.cpp
viceroy_cpp/src/mapview.cpp viceroy_cpp/src/colony_screen.cpp
viceroy_cpp/src/native_assets.cpp viceroy_cpp/src/popup_render.cpp
viceroy_cpp/src/mp.cpp viceroy_cpp/src/pal.cpp viceroy_cpp/src/image_io.cpp
viceroy_cpp/src/fab.cpp viceroy_cpp/src/madspack.cpp viceroy_cpp/src/ss.cpp
viceroy_cpp/src/ff.cpp viceroy_cpp/src/pik.cpp
viceroy_cpp/drydock/text/rec_text.cpp viceroy_cpp/drydock/schema/schema.cpp
viceroy_cpp/drydock/pack/pack.cpp viceroy_cpp/drydock/core/store.cpp
viceroy_cpp/forge/session.cpp viceroy_cpp/forge/json.cpp
viceroy_cpp/forge/rules_json.cpp viceroy_cpp/forge/mapedit.cpp
viceroy_cpp/forge/mod.cpp viceroy_cpp/forge/savegame.cpp
viceroy_cpp/forge/drydock_bridge.cpp viceroy_cpp/forge/drydock_api.cpp
viceroy_cpp/forge/datacheck.cpp viceroy_cpp/forge/formulas.cpp
viceroy_cpp/forge/engine.cpp viceroy_cpp/forge/turnpipe.cpp
viceroy_cpp/forge/native_powers.cpp viceroy_cpp/forge/store.cpp
viceroy_cpp/forge/expr.cpp
viceroy_cpp/forge/game_assets.cpp viceroy_cpp/forge/game_reports.cpp
viceroy_cpp/forge/game_shell.cpp
"

n=0
for f in $SRC; do
    n=$((n + 1))
    $CXX $FLAGS -c "$f" -o "$OUT/$(basename "$f").o"
done
SIZE=$(du -sh "$OUT" | cut -f1)
echo "TEENSY CORE COMPILE OK: $n translation units for cortex-m7 ($SIZE of objects)"
