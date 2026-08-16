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
oracle is byte-identical) — the Teensy game loop blocks on the prompt
event drawn through the dialog framework, arrows pick a GAME.TXT tail
row, Enter answers, Escape dismisses.  Open follow-ups, all
presentation-side: the drag layer, the pedia/options browse screens,
the Custom House ask-loop, the Save/Load/Go To dialog rows, and the
USB-keyboard bring-up check per teensy/README.md).
