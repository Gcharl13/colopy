# cport — the game core in C, for Teensy 4.1

The game (rules, state, turn loop, economy, combat, AI) as a portable C
library with **no rendering, no input, no OS** — the interface layer comes
later and talks only through `core/colopy_core.h`. Source of truth is the
census-verified JS port (`port/src/game.js`), not the low-trust old C recon.

| Directory | What |
|---|---|
| `core/` | portable C (C99/C11, no malloc, static pools). `colopy_core.h` is the public API; `colopy_records.h` holds the byte-verified engine record layouts (stride-asserted) |
| `data/` | GENERATED — `python3 tools/gen_c_data.py` emits the game tables from the same `build_data()` the JS bundle uses, so the two cannot drift. `MANIFEST.md` lists every DATA member and its disposition |
| `host/` | PC harness: `make test`. Grows into the JS↔C turn-parity driver |
| `teensy/` | (Phase 4) serial-digest shell for the hardware acceptance test |

Ledger of every game.js function and its porting status:
`PORT_LEDGER.md` (regenerate the skeleton with `tools/gen_port_ledger.py`).

Phases and acceptance tests are in the approved plan (see the repo tasks):
0 inventory/API/data ✓ → 1 SAV roundtrip → 2 subsystems → 3 turn-parity
oracle vs the JS port → 4 Teensy memory budget + serial digest.
