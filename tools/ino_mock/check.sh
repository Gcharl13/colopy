#!/bin/sh
# Mock-compile gate for the generated P4 sketch: emulate the IDE's
# prototype hoist (gen_mock.py), then syntax-check against the stub
# headers in this directory.  Two passes, because the BLE-mouse path is
# behind a build flag and its own hoisted prototype is exactly what broke
# a real IDE build on 2026-08-19.
#
# Exits NONZERO on any error.
#
# Self-locating (2026-09-02): the sketch directory is found relative to
# this script, never by an absolute path -- the gate that "lived outside
# the repo" (REMAINING_WORK.md G2e) had kept one foot out there through an
# include path hard-coded to one particular checkout, so a worktree or a
# fresh clone was compiling against SOMEONE ELSE'S headers.
cd "$(dirname "$0")" || exit 1
python3 gen_mock.py || exit 1
INC="-I. -I../../cport/arduino_p4/colopy_p4"
if g++ -fsyntax-only -std=gnu++17 $INC sketch_test.cpp 2> /tmp/mockerr; then
  echo "MOCK-COMPILE-OK (BLE off)"
else
  echo "MOCK-COMPILE-FAILED (BLE off)"; head -25 /tmp/mockerr; exit 1
fi

if g++ -fsyntax-only -std=gnu++17 -DCOLOPY_BLE_MOUSE=1 $INC sketch_test.cpp \
     2> /tmp/mockerr_ble; then
  echo "MOCK-COMPILE-OK (BLE on)"
else
  echo "MOCK-COMPILE-FAILED (BLE on)"; head -25 /tmp/mockerr_ble; exit 1
fi

# Third pass: the board macro the real P4 core defines
# (-DARDUINO_ESP32P4_DEV), which flips colopy_render.h to the external
# PSRAM framebuffer (COLOPY_EXTERNAL_FRAMEBUFFER=1) -- the sketch's
# rd_bind_framebuffer() path only exists under it.  The stub headers
# above do not define it, so without this pass that code is never seen.
if g++ -fsyntax-only -std=gnu++17 -DARDUINO_ESP32P4_DEV $INC sketch_test.cpp \
     2> /tmp/mockerr_p4; then
  echo "MOCK-COMPILE-OK (ESP32P4_DEV, external framebuffer)"
else
  echo "MOCK-COMPILE-FAILED (ESP32P4_DEV)"; head -25 /tmp/mockerr_p4; exit 1
fi

# ...and the C side of the same choice: every render/game/core unit of the
# sketch must still compile with RD.fb a pointer (the host build only ever
# sees the inline array).
if gcc -fsyntax-only -std=gnu11 -Wall -Werror -DCOLOPY_EXTERNAL_FRAMEBUFFER=1 \
     -I../../cport/arduino_p4/colopy_p4 ../../cport/arduino_p4/colopy_p4/*.c \
     2> /tmp/mockerr_fb; then
  echo "MOCK-COMPILE-OK (C units, external framebuffer)"
else
  echo "MOCK-COMPILE-FAILED (C units, external framebuffer)"
  head -25 /tmp/mockerr_fb; exit 1
fi
