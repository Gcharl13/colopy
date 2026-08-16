# Vendored Arduino libraries for the CrowPanel Advance 7" ESP32-P4

The three libraries the `cport/arduino_p4/colopy_p4` sketch needs,
copied from Elecrow's repo
(`example/V1.2/Arduino_Code/libraries/`, branch `master`, fetched
2026-08-16) — the SAME pre-configured bundle their own examples use.
Vendored here because GitHub's ZIP of Elecrow's full repo is huge and
extraction of it has failed for users; this way the one Colopy
download carries everything.

**Install: copy each of these three folders into your Arduino
`libraries/` folder** (e.g. `Documents\Arduino\libraries\` — or
better, a sketchbook OUTSIDE OneDrive), replacing any existing copies
with the same names:

- `ESP32_Display_Panel/`  (espressif, v1.0.4, Apache-2.0) — build
  files only: `src/` + the root config headers, which carry Elecrow's
  panel enables (`ESP_PANEL_DRIVERS_BUS_USE_MIPI_DSI/LCD_USE_EK79007/
  TOUCH_USE_GT911` = 1) and the custom-board values (1024x600, 2-lane
  DSI).  The upstream `examples/`, `docs/`, `test_apps/`,
  `mpy_support/` trees are omitted (not used by the IDE build);
  everything kept is byte-identical to Elecrow's bundle.
- `ESP32_IO_Expander/`  (espressif, Apache-2.0) — whole, unmodified.
- `esp-lib-utils/`  (espressif, Apache-2.0) — whole, unmodified.

The Library Manager copies of these are NOT substitutes: they ship
unconfigured (no panel enabled), which fails the build.  If
`libraries/ESP32_Display_Panel/library.properties` doesn't say
`version=1.0.4`, or `src/` has a `bus/` folder directly under it
(v0.x layout), you have a stale copy — delete it and re-copy from
here.
