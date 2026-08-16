# cport/p4 — CrowPanel Advance 7" ESP32-P4 shell (Phase 9)

The Arduino-IDE game shell for the Elecrow CrowPanel Advance 7"
(ESP32-P4NRW32: RISC-V dual-core 400 MHz, 16 MB flash, 32 MB PSRAM,
1024x600 MIPI-DSI IPS, GT911 touch, microSD, USB-C).  Same
parity-verified engine as the host/Teensy builds; this directory holds
the shell source and the byte-exact Elecrow reference files every
hardware number traces to.

| file | what |
|---|---|
| `colopy_p4.ino` | the shell: panel/touch/SD init (verbatim from Elecrow's examples), 3x-scale flush, touch pointer layer + dialog row taps, the serial shell (`l/t/d/i/s/v/g/k`), autoboot |
| `elecrow_ref/` | Elecrow's working V1.2 Arduino example files, byte-exact — the citations (see `PROVENANCE.md`) |
| `PROVENANCE.md` | which file certifies which pin/timing/API, bundled library versions |

Build the IDE sketch folder with (repo root):

    python3 tools/gen_arduino_p4_sketch.py

which assembles `cport/arduino_p4/colopy_p4/` (flattened engine copies
+ the panel configs + this shell + README with the exact IDE steps).

## Geometry

320x200 logical screen x3 = 960x600 — an EXACT integer scale on the
1024x600 panel with a 32-px pillarbox each side.  Touch descales the
same way: game_x = (touch_x - 32) / 3, game_y = touch_y / 3.  The
Teensy build's rows 200..239 status strip (itself a FLAGGED port
choice — the DOS game is 200 rows) is not shown here.

## Input model

- **Touch** (play is touch-complete — no keyboard needed):
  - **tap** = the pointer layer's `in_click` at the descaled
    coordinate (menus, colony, Europe, context menus all work by
    tap); on the map, a tap on a tile **adjacent to the active unit
    moves it there** (the shell synthesizes the 8-way movement key —
    attacking and entering colonies included).  Tapping the active
    unit's own tile cycles stacked units.
  - **long-press** (>= 600 ms) = Space — skip the active unit.
  - **two-finger tap** = Escape — close a menu/screen, dismiss.
  - A queued notice popup: tap dismisses.  A question dialog
    (`colopy_ask_hook` → `board_ask`): **tap an option row to answer
    it** (`rm_dialog_row_hit` re-derives the exact box the painter
    drew), tap outside the box = dismiss (Escape).  An amount modal:
    tap the box = Enter (empty entry = the full amount), outside =
    Escape; typed digits need serial.
  - Every unit order (fortify, sentry, plow, road, build...) is also
    a row in the tappable ORDERS pulldown, and the reports live in
    the menu bar — so the key vocabulary is reachable by touch.
- **Serial** (USB-C CDC, 115200): the whole Teensy shell vocabulary,
  including `k <name>` key injection.
- **No USB keyboard**: Elecrow's Arduino USB example is device-mode
  HID only (`elecrow_ref/lesson06_usb.ino`) — the P4 Arduino core has
  no host-keyboard path today, hence touch + serial.

## Bring-up checklist (panel + touch VERIFIED ON HARDWARE — user
## bring-up 2026-08-16 with the vendored libraries; the digest
## acceptance run below is the remaining flag)

1. IDE setup + libraries per `cport/arduino_p4/colopy_p4/README.md`
   (Elecrow's bundled, pre-configured libraries — NOT Library Manager).
2. SD: FAT32, root: `COLOPY.PAK` + `COLONY00.SAV`.
3. Flash; the default `COLOPY_AUTOBOOT` boots straight into the game.
4. Acceptance: over serial, `l COLONY00.SAV` then `t 100` — the digest
   lines must match the host run turn for turn (same test the Teensy
   passed).
5. Watch-fors on first light (report back, do not guess):
   - red/blue swapped → the RGB565 LUT vs the panel's RGB element
     order (`ESP_PANEL_BOARD_LCD_COLOR_BGR_ORDER` is 0 in Elecrow's
     config); fix = swap the LUT, one line in `build_lut`.
   - slow flushes → move to `getFrameBufferByIndex` direct writes or
     dirty-row tracking (drawBitmap currently pushes the full
     1024x600x2 buffer per redraw).
   - partition scheme: any large-app layout works (the sketch carries
     no embedded pak on this board); if the IDE default fits, keep it.

## Open follow-ups

- Long-press → right-click mapping for the pointer layer (taps are
  left-clicks today).
- On-screen keyboard for the naming dialogs (founding uses the
  suggested name via `colopy_front_live`; free-text entry needs
  serial for now).
- The presentation follow-ups shared with the Teensy build
  (`cport/README.md` ledger).
