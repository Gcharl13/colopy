# cport — the game core in C, for Teensy 4.1

The game (rules, state, turn loop, economy, combat, AI) as a portable C
library with **no rendering, no input, no OS** — the interface layer comes
later and talks only through `core/colopy_core.h`. Source of truth is the
census-verified JS port (`port/src/game.js`), not the low-trust old C recon.

| Directory | What |
|---|---|
| `core/` | portable C (C99/C11, no malloc, static pools). `colopy_core.h` is the public API; `colopy_records.h` holds the byte-verified engine record layouts (stride-asserted) |
| `data/` | GENERATED — `python3 tools/gen_c_data.py` emits the game tables from the same `build_data()` the JS bundle uses, so the two cannot drift. `MANIFEST.md` lists every DATA member and its disposition |
| `render/` | (Phase 7) the ILI9341-ready screen painters: 8-bit 320x240 fb, every screen oracle-verified pixel-for-pixel against the JS canvas (`tools/render_*_compare.py`) |
| `game/` | (Phase 8) the keyboard input layer: `in_key` over the UI state the renderers draw, oracle-verified event-for-event against the JS onKey (`tools/input_compare.py`) |
| `pak/` | `COLOPY.PAK` (tools/gen_sd_pack.py) — the SD asset container, census-checked against the JS DATA (`sim_compare.py pak`) |
| `host/` | PC harness: `make test` + every parity oracle entry (`--turns/--produce/--render*/--input/...`) |
| `teensy/` | the serial shell + the display/keyboard game loop (panel + USB keyboard paths hardware-flagged; README.md carries the bring-up checklist) |
| `p4/` | (Phase 9) the CrowPanel Advance 7" ESP32-P4 shell (1024x600 MIPI-DSI at an exact 3x scale, GT911 touch drives the pointer layer + dialog row taps, SD pak/saves) — every pin/timing byte-exact from Elecrow's own examples (`p4/PROVENANCE.md`); `tools/gen_arduino_p4_sketch.py` builds the IDE sketch |

Ledger of every game.js function and its porting status:
`PORT_LEDGER.md` (regenerate the skeleton with `tools/gen_port_ledger.py`).

Phases and acceptance tests (see the repo tasks): 0 inventory/API/data ✓
→ 1 SAV roundtrip ✓ → 2 subsystems ✓ → 3 turn-parity oracle ✓ → 4 Teensy
budget + serial digest ✓ → 5 interactive core ✓ → 6 SD asset pack ✓ →
7 ILI9341 renderer ✓ (all screens 0 structural) → 8 input loop ✓ (boot +
map/menu/colony/Europe key vocabulary AND the pointer layer, village
keys, the construction picker, the jobs popup, the Europe r/p/t
sub-menus + King's petition, the land parley arm, the @HOWMUCH amount
modals (Europe sell + ship load/unload), and the map mechanics keys
(build/join colony with the land-claim + site-scan chains, improvement
orders, cargo load/unload/dump, disband, sail for Europe) — all
0-event-diff across five scenarios; the ILI9341 panel path is VERIFIED
ON HARDWARE.  The MECHANICS are complete: the rival land WAR arms
(resolveAttack + the @CAPTURED colony re-found), the Wagon Train trade
and Scout dialogs at rival colonies, colony rush-buy, the Europe
ship/dockunit context menus (board/hold/front/arm/bless + front/sail/
unload-all), and colony FOUNDING (cmd_found_colony — the harness stops
at the inert name dialog; a live front end, colopy_front_live, founds
with the suggested name).  Questions now go to the PLAYER on a live
front end: colopy_ask_hook (default = the harness seq policy, so every
oracle is byte-identical) — the board game loop blocks on the prompt
event drawn through the dialog framework; touch taps a row, Enter
answers, Escape dismisses.  PHASE 9 (the CrowPanel ESP32-P4 board,
p4/): the full boot — title menu, difficulty/nation/name (touch
keyboard), briefing pages, the King's audience, the ten LEVN cards —
into colopy_new_game (beginGame ported JS-exact, its own oracle:
sim_compare newgame, 0 diffs x 4 nations x 2 difficulties x 30 turns);
landfall + the woodcut plates + the staying village screen + the
@INDIANWELCOME chain live on colopy_front_live channels; every menu
row bound (ORDERS delegating to the key handlers, the @SAILPORT/
@TRAVELPLACE Go To picker, DECLARE INDEPENDENCE, Retire, Exit to DOS,
Save/Load through the shell SD pickers); the Hall of Fame written at
retirement and persisted as HOF.DAT.

The Phase-9 follow-up list is now CLOSED except where noted.  Since
shipped: the Colonizopedia browser and entry pages, the options
dialogs, the village screen, woodcuts on the board, map zoom 0-3, the
trade-route dialogs with a working advance_trade_routes, the Custom
House, Find Colony, colony unit builds (Wagon Train / Artillery /
ships), the entry modals with an on-screen numeric keypad and alpha
keyboard (so @LANDHO, colony founding and renaming, and Europe/colony
amounts are all free-text on the board), menu bars that track the
finger with the selection highlighted under it, ending a turn with no
active unit, and the Pick Music binding.

Still open, and stated plainly (the COMPLETE ledger, including the
gameplay mechanics still missing and every flagged approximation, is
`docs/REMAINING_WORK.md` — this list is the board-side summary):

- **Drag and drop** is absent by design — every drag in the JS port has
  a tap-driven equivalent on the board (menus, the plaza/field taps,
  the Europe dock and market rows).
- **Music cannot be played at all.**  The DOS game ships no music
  files; the tunes are synthesised inside the `?SOUND.COL` driver
  overlays.  **Sound effects DO play**: `COLDIG.BIN`'s sample index was
  decoded from those drivers (`formats/BIN.md`), and the board plays
  the cues whose call sites are byte-verified — the rest stay silent
  rather than guessed.
- **Ending a turn with nothing active.**  Fortify or sentry every unit
  and the cycle offers nobody.  Two ways out on the board: a long-press
  anywhere on the map, or ORDERS -> "Wait for next unit", the one row
  left live in that state.  The DOS `@ORDERS` menu has no End-of-Turn
  row and none was invented.
- **The Bluetooth pairing row is compiled out by default.**  It sits on
  the TITLE screen just below the menu plaque (y=155) and appears only
  when `COLOPY_BLE_MOUSE` is set to 1 at the top of `colopy_p4.ino`.
- **Bluetooth mouse** support exists but is opt-in and **untested
  against hardware** (`COLOPY_BLE_MOUSE`); it needs a core with hosted
  BT for the P4 and C6 firmware that exposes Bluetooth, neither of
  which can be verified from this repo.
- **Sidecar-only state.**  A colony's unit build target and the trade
  routes ride in a companion `.CPX` file, not the `.SAV` — the DOS
  format has no field for either and the `.SAV` is written byte-exact.
- Cosmetic TBDs remain: the colony dither/speckle pass, a handful of
  unresolved display strings, and no resource model on the map.
- **Go To moves ONE square a turn**, whatever the unit's allowance.  That
  is the executor's shape in both engines and predates the sail-for-Europe
  work; it makes a ship's run out to the sea lane slower than the ship.
  Recorded as TBD in `notes/rulings/RULINGS.md` (2026-08-17).
- **No fence hit-rect.**  `@TUTORIAL4` puts the fence "near the water on
  the colony picture", but no byte-read rectangle for it exists, so
  leaving a colony rides the two exits that do: the jobs menu's "Return
  to the fence" row and the drop-out-of-the-fields drag.  TBD.
- **Taking the LAST colonist out of a colony is refused.**  What the
  engine does there is unread, and abandonment already has its own
  command (`@ABANDON`, shift-A), so no second path into it was invented.
