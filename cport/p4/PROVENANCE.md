# cport/p4/elecrow_ref — provenance

Byte-exact reference copies of Elecrow's own working Arduino examples
for this exact board, fetched 2026-08-16 from
`github.com/Elecrow-RD/CrowPanel-Advanced-7inch-ESP32-P4-HMI-AI-Display-1024x600-IPS-Touch-Screen`
(branch `master`, `example/V1.2/Arduino_Code/`).  Per the project's
never-fabricate rule, every hardware number in the Colopy P4 shell
(panel timings, pins, LDO channels, SD slot config) traces to these
files — none of it is guessed.

| file | from | what it is the citation for |
|---|---|---|
| `Lesson07-Turn_on_the_screen.ino` | Lesson07 | LDO3 2.5 V + LDO4 3.3 V channel acquire, `Board` init/begin order |
| `board_config.h` | Lesson07 | EK79007 timings (51 MHz DPI, HPW 70/HBP 160/HFP 160, VPW 10/VBP 23/VFP 21), LCD RST 41, backlight 31 (PWM 30 kHz, on=1), GT911 RST 40/INT 42, I2C SCL 46/SDA 45 |
| `esp_panel_board_custom_conf.h` | Lesson07 | ESP32_Display_Panel custom-board config (2-lane MIPI-DSI @ 1000 Mbps, RGB565) — Apache-2.0 (Espressif template, Elecrow values) |
| `esp_panel_drivers_conf.h` | Lesson07 | driver enables: MIPI-DSI bus + EK79007 LCD + GT911 touch — Apache-2.0 |
| `esp_utils_conf.h` | Lesson07 | esp-lib-utils config — Apache-2.0 |
| `lvgl_v8_port.h/.cpp` | Lesson07 | reference only (Colopy does not use LVGL): confirms the `LCD::drawBitmap`/`getFrameBufferByIndex` flush path on this panel |
| `lesson05_touch.ino` | Lesson05 | `Touch::readPoints(points, n, 0)` usage, point fields x/y/strength |
| `lesson06_usb.ino` | Lesson06 | reference only: the board's USB 2.0 example is DEVICE HID (mouse) — no USB host keyboard path exists in Elecrow's Arduino examples, hence touch+serial input on P4 |
| `lesson08_sd.ino` | Lesson08 | SDMMC mount: `SDMMC_HOST_SLOT_0`, 10 MHz, 1-bit, internal pull-ups, `esp_vfs_fat_sdmmc_mount("/sdcard", ...)` |
| `lesson08_board_config.h` | Lesson08 | SD pins: CLK 43 / CMD 44 / D0 39 |

Bundled library versions (the repo's `example/V1.2/Arduino_Code/libraries/`,
which ship PRE-CONFIGURED for this panel — install THOSE, not the
Library Manager copies): ESP32_Display_Panel **1.0.4** (espressif;
depends ESP32_IO_Expander >=1.0 <2.0, esp-lib-utils >=0.2 <0.3), lvgl
(not used by Colopy).  ESP32_Display_Panel documents arduino-esp32 core
**>= 3.1.0** (boards URL
`https://espressif.github.io/arduino-esp32/package_esp32_index.json`).

The three needed libraries are VENDORED in this repo at
`cport/p4/arduino_libraries/` (fetched 2026-08-16 via sparse checkout
of Elecrow's `master`; ESP32_Display_Panel trimmed to build files —
see the README there) because GitHub's ZIP of Elecrow's full repo has
failed to extract for users.

Do not edit these files; refresh them from Elecrow's repo if their
examples update, and re-run `tools/gen_arduino_p4_sketch.py`.
