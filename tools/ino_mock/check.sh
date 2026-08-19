#!/bin/sh
# Mock-compile gate for the generated P4 sketch: emulate the IDE's
# prototype hoist (gen_mock.py), then syntax-check against the stub
# headers in this directory.  Two passes, because the BLE-mouse path is
# behind a build flag and its own hoisted prototype is exactly what broke
# a real IDE build on 2026-08-19.
#
# Exits NONZERO on any error.
cd "$(dirname "$0")" || exit 1
python3 gen_mock.py || exit 1
INC="-I. -I/home/user/colopy/cport/arduino_p4/colopy_p4"
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
