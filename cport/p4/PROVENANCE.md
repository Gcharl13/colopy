# cport/p4 — provenance of the vendored Elecrow files

Byte-exact reference copies of Elecrow's own working Arduino examples
for this exact board, plus the three pre-configured libraries their
examples build against, from
`github.com/Elecrow-RD/CrowPanel-Advanced-7inch-ESP32-P4-HMI-AI-Display-1024x600-IPS-Touch-Screen`
(branch `master`, `example/V1.2/Arduino_Code/`).  Per the project's
never-fabricate rule, every hardware number in the Colopy P4 shell
(panel timings, pins, LDO channels, SD slot config, I2S pins) traces to
these files — none of it is guessed.

## The pin

| | |
|---|---|
| **Upstream commit** | `7b90882c68033d32702b1e243238d3d5a5b1afaf` — `master` as of 2026-08-11, the head when the files were fetched on 2026-08-16 |
| **Verified** | 2026-09-02, by a sparse clone of upstream and a blob-id / `diff -rq` comparison (below) |
| **Checksums** | `cport/p4/VENDORED.sha256` — every vendored file (415), `sha256sum -c` format |
| **Gate** | `tools/stale_check.py` probe `G9/G10` (runs under `make test`): PROVENANCE must name a commit and every file must still match the manifest |

How the pin was established (2026-09-02).  `git ls-remote` reached
upstream through the proxy; a `--filter=blob:none` sparse clone of
`example/V1.2/Arduino_Code` followed, deepened to 53 commits.  For the
thirteen `elecrow_ref/` files, `git hash-object` of each vendored copy
equals the blob id in upstream's tree at `47ded37` (2026-07-29, the last
commit that touched those lessons before the fetch), and
`git diff 47ded37..7b90882` over the five lesson directories is empty —
so they are exactly the files master served on 2026-08-16.  For the
libraries, `diff -rq` of the vendored `ESP32_IO_Expander` and
`esp-lib-utils` against today's master (`472adde`, 2026-09-02) reports
no differences, the vendored subset of `ESP32_Display_Panel` differs in
no file (only the trimmed `docs/ examples/ test_apps/ mpy_support/
template_files/ tools/` trees are "Only in" upstream), and
`git diff 7b90882..472adde` over those three library directories is
empty — so the libraries at the pin are the libraries today.

**Upstream has moved since the pin, and the reference files were NOT
refreshed.**  At today's master (`472adde`) seven of the thirteen
`elecrow_ref/` files differ from the vendored copies:
`Lesson07-Turn_on_the_screen.ino` (3 bytes), `lesson05_touch.ino`,
`lesson06_usb.ino`, `lesson08_sd.ino`, `lesson12_audio.ino`, and
`lvgl_v8_port.cpp/.h`, which upstream replaced outright with a
rewritten `lvgl_port.cpp/.h` (LVGL v9 port; commits of 2026-08-20 and
2026-09-02).  The six config headers are unchanged.  A refresh is a
decision, not a chore — these files are the citations for numbers
already compiled into the sketch, so a changed citation has to be read
before it is adopted.  The procedure is at the end of this file.

## The reference files (`elecrow_ref/`)

| file | upstream path (under `example/V1.2/Arduino_Code/`) | what it is the citation for |
|---|---|---|
| `Lesson07-Turn_on_the_screen.ino` | `Lesson07-Turn_on_the_screen/Lesson07-Turn_on_the_screen.ino` | LDO3 2.5 V + LDO4 3.3 V channel acquire, `Board` init/begin order |
| `board_config.h` | `Lesson07-Turn_on_the_screen/board_config.h` | EK79007 timings (51 MHz DPI, HPW 70/HBP 160/HFP 160, VPW 10/VBP 23/VFP 21), LCD RST 41, backlight 31 (PWM 30 kHz, on=1), GT911 RST 40/INT 42, I2C SCL 46/SDA 45 |
| `esp_panel_board_custom_conf.h` | `Lesson07-Turn_on_the_screen/esp_panel_board_custom_conf.h` | ESP32_Display_Panel custom-board config (2-lane MIPI-DSI @ 1000 Mbps, RGB565) — Apache-2.0 (Espressif template, Elecrow values) |
| `esp_panel_drivers_conf.h` | `Lesson07-Turn_on_the_screen/esp_panel_drivers_conf.h` | driver enables: MIPI-DSI bus + EK79007 LCD + GT911 touch — Apache-2.0 |
| `esp_utils_conf.h` | `Lesson07-Turn_on_the_screen/esp_utils_conf.h` | esp-lib-utils config — Apache-2.0 |
| `lvgl_v8_port.h/.cpp` | `Lesson07-Turn_on_the_screen/lvgl_v8_port.h/.cpp` (at the pin; upstream has since replaced them with `lvgl_port.*`) | reference only (Colopy does not use LVGL): confirms the `LCD::drawBitmap`/`getFrameBufferByIndex` flush path on this panel |
| `lesson05_touch.ino` | `Lesson05-Touchscreen/Lesson05-Touchscreen.ino` | `Touch::readPoints(points, n, 0)` usage, point fields x/y/strength |
| `lesson06_usb.ino` | `Lesson06-USB2.0/Lesson06-USB2.0.ino` | reference only: the board's USB 2.0 example is DEVICE HID (mouse) — no USB host keyboard path exists in Elecrow's Arduino examples, hence touch+serial input on P4 |
| `lesson08_sd.ino` | `Lesson08-SD_Card_File_Reading/Lesson08-SD_Card_File_Reading.ino` | SDMMC mount: `SDMMC_HOST_SLOT_0`, 10 MHz, 1-bit, internal pull-ups, `esp_vfs_fat_sdmmc_mount("/sdcard", ...)` |
| `lesson08_board_config.h` | `Lesson08-SD_Card_File_Reading/board_config.h` | SD pins: CLK 43 / CMD 44 / D0 39 |
| `lesson12_audio.ino` | `Lesson12-Playing_Loca_Music_from_SD_Card/Lesson12-Playing_Loca_Music_from_SD_Card.ino` (fetched 2026-08-17) | speaker path: plain I2S std mode via `ESP_I2S.h` `I2SClass` (`setPins(BCLK, LRCLK, SDATA)` then `begin(I2S_MODE_STD, rate, 16-bit, ...)`), no codec chip in the playback chain; audio **power gate** `AUDIO_GPIO_CTRL` LOW=enable; blocking `i2s_spk.write()` paces on DMA |
| `lesson12_board_config.h` | `Lesson12-Playing_Loca_Music_from_SD_Card/board_config.h` | audio pins: **LRCLK 21 / BCLK 22 / SDATA 23**, power gate **GPIO 30** (LOW = on); mic PDM CLK 24 / SDIN 26 (unused by Colopy) |

Per-file SHA-256 digests are in `VENDORED.sha256` (the `elecrow_ref/`
lines); they are not repeated here so there is one place to keep right.

## The vendored libraries (`arduino_libraries/`)

The bundle in upstream's `example/V1.2/Arduino_Code/libraries/` ships
PRE-CONFIGURED for this panel — install THESE, not the Library Manager
copies (which ship with no panel enabled and fail the build).  Vendored
here because GitHub's ZIP of Elecrow's full repository has failed to
extract for users; with the tree pinned and checksummed the ZIP is no
longer needed for anything.

| library | version (`library.properties`) | vendored as | licence |
|---|---|---|---|
| `ESP32_Display_Panel` | 1.0.4 (espressif; depends `ESP32_IO_Expander >=1.0 <2.0`, `esp-lib-utils >=0.2 <0.3`) | build files only: `src/` + the root config headers (`esp_panel_board_custom_conf.h`, `esp_panel_board_supported_conf.h`, `esp_panel_drivers_conf.h`), `library.properties`, `CMakeLists.txt`, `Kconfig`, `idf_component.yml`, `CHANGELOG.md`, `README.md`, `license.txt`; upstream's `docs/ examples/ test_apps/ mpy_support/ template_files/ tools/` omitted (not used by the IDE build). Every kept file is byte-identical to upstream. | Apache-2.0 |
| `ESP32_IO_Expander` | 1.1.1 (espressif) | whole, unmodified | Apache-2.0 |
| `esp-lib-utils` | 0.2.3 (espressif) | whole, unmodified | Apache-2.0 |

`lvgl` (also in upstream's bundle) is not vendored: Colopy does not use
it.  ESP32_Display_Panel documents arduino-esp32 core **>= 3.1.0**
(boards URL `https://espressif.github.io/arduino-esp32/package_esp32_index.json`).
Install instructions are in `arduino_libraries/README.md`.

## Refresh procedure

Do not edit these files.  To move the pin:

1. `git ls-remote https://github.com/Elecrow-RD/CrowPanel-Advanced-7inch-ESP32-P4-HMI-AI-Display-1024x600-IPS-Touch-Screen refs/heads/master`
   — the candidate commit.  (The network path goes through the agent
   proxy; it worked on 2026-09-02.)
2. Sparse-clone it: `git clone --filter=blob:none --depth 1 --sparse
   --no-checkout <url> up && cd up && git sparse-checkout set
   example/V1.2/Arduino_Code && git checkout`.
3. Diff before copying: `diff -rq` each vendored library against its
   upstream directory, and `cmp` each `elecrow_ref/` file against the
   upstream path in the table above.  **Read every differing reference
   file** — each one is the citation for a number in
   `cport/arduino_p4/colopy_p4/` — and record what changed and whether
   the sketch follows it in `notes/rulings/RULINGS.md`.
4. Copy, then regenerate the manifest from `cport/p4/`:
   `find elecrow_ref arduino_libraries/ESP32_Display_Panel arduino_libraries/ESP32_IO_Expander arduino_libraries/esp-lib-utils -type f | LC_ALL=C sort | xargs sha256sum > VENDORED.sha256`
   (keep `ESP32_Display_Panel` trimmed to the build files listed above).
5. Update the commit hash and date in **The pin** and the drift paragraph
   under it; re-run `tools/gen_arduino_p4_sketch.py` and `make -C
   cport/host test` (the `G9/G10` probe verifies the manifest; the `mock`
   target syntax-checks the sketch).

To check for drift without moving anything: `cd cport/p4 && sha256sum -c
--quiet VENDORED.sha256` (silent when clean), or `make -C cport/host
records`.
