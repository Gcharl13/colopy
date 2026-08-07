# STATUS — project state

> **The single source of truth for current project state.** Every figure below
> was re-measured on **2026-08-05**, not carried forward. Where a gate could not
> be measured in this checkout, it says so instead of quoting the old number.
>
> For the correct-vs-misleading information audit see [`AUDIT.md`](AUDIT.md);
> for the three-layer model (evidence → **spec** → implementation) see
> [`METHODOLOGY.md`](METHODOLOGY.md). The specification (`spec/README.md`) is
> the source of truth; `viceroy_source/` is evidence (`viceroy_source/ROLE.md`).

**Last refreshed: 2026-08-07.** (Previous refreshes: 2026-08-05, 2026-06-18.)
The 2026-08-07 pass fixed the six player-reported defects, closed the
raid-gate K TBD, added rival-power AI and LOAD GAME (including a full
COLONY##.SAV importer — the shipped 1653 game restores field-for-field), and
folded the whole port-era harvest into the technical reference (§30). Treat
any figure elsewhere in the tree dated before 2026-08-05 as unverified.

---

## Where the project actually is

Three layers, in the order `METHODOLOGY.md` defines them.

| Layer | State |
|---|---|
| **Evidence** (disassembly, asset decode) | 1,241 VICEROY functions inventoried; **156 named**, 1,094 not. All 13 container formats decoded. |
| **Specification** (`spec/`, 64 sheets) | The mature layer. **17 open TBD lines across 10 sheets**, each named with its blocker. Every game-system formula is byte-closed. |
| **Implementation** (`port/`, HTML) | Playable start-to-endgame, **215/215 tests**, ~9.5k lines, 3.0 MB single-file bundle. Drag-and-drop, popup speakers, native + rival AI (both reduced/R-tier — the full func_04E2D6 pipeline is the ceiling), LOAD GAME incl. the shipped COLONY##.SAV format. Main gaps: Hall of Fame, sound, tutorial. |

The honest one-line summary: **the spec is close to done, the port is the
working proof of it, and the raw per-line annotation of the binary is not and
may never be the point.**

---

## Verification gates

Re-run: `python3 tools/verify.py`, `python3 tools/sigmatch.py --self-test`,
`python3 tools/extract_pal.py && python3 tools/encode_pal.py`, ditto `_mp`.

| Gate | Status | Measured 2026-08-05 |
|------|--------|---------------------|
| A. sigmatch self-test | ✅ **PASS** | 17/17 BYTE_VERIFIED helpers re-found |
| B. byte-identity round-trip | ⚠️ **NOT MEANINGFUL AS IMPLEMENTED** | see below |
| B-PAL. PAL extract+encode | ✅ **PASS** (fixed today) | was silently FAILING since 2026-06-27 — see below |
| B-MP. MP extract+encode | ✅ **PASS** | `AMER2.MP` SHA-exact |
| C. visual asset extraction | ⚪ **NOT RUNNABLE HERE** | `extract_visuals.py` → `0/0`; needs the full `COLONIZE/` tree |
| C-VISUAL. catalog generation | ⚪ **NOT RUNNABLE HERE** | same dependency |
| D. per-line annotation | ⏳ ~5% | deferred by choice — see "Direction" |
| E. other-EXE annotation | ⏳ partial | sigmatch promotions only |
| F. doc-to-code linkcheck | ⏳ **TODO** | `tools/linkcheck.py` still not built |
| G. DOSBox playable-rebuild smoke test | ⏳ **TODO** | never run |
| H. third-party reproducibility | ✅ DOC done | `BUILD.md` |

### Gate B is overstated and always has been

The old dashboard read *"byte-identity round-trip for all 319 COLONIZE/ files —
✅ PASS (319/319)"*. Two problems, both found on 2026-08-05:

1. **It measures 10 files here, not 319.** `verify.py` enumerates
   `raw/COLONIZE/`, which in a fresh clone holds only the 10 binaries
   `bin/reconstitute.py` rebuilds from `bin/*.b64`. The 319-file figure assumes
   you have dropped your own full `COLONIZE/` directory there (`BUILD.md`
   step 1). `col.zip` carries 300 payload files and is what the port builds from.
2. **For the byte-identity formats the test is a tautology.**
   `round_trip_byte_identity()` reads a file, writes the same bytes to
   `verification/results/`, and compares the file to itself. It returns `True`
   unconditionally. That proves nothing about any extractor.

The gates that genuinely round-trip through a decode/encode pair are **B-PAL**
and **B-MP**, and those two are the ones worth trusting. Gate B should either be
rewritten to exercise real codecs or retired; it is left in place, honestly
labelled, rather than quietly deleted.

### Gate B-PAL had been failing for six weeks

Found while refreshing this file. On 2026-06-27 the `.PAL` entry stride was
corrected from 4 bytes to 3 (768 RGB bytes + a 256-byte tail). `extract_pal.py`
was updated; **`encode_pal.py` was not**, and kept writing the old 4-byte
interleave. Worse, the extractor hardcoded `pad = 0` and never read the tail at
all — so the JSON was **lossy** and no encoder could have reproduced the file.

The tail is not padding: 156 of its 256 bytes are non-zero (`0x05` across
indices 0..151 and 252..255, `0x00` between), one byte per palette index. Its
*meaning* is TBD — the `.PAL` loader is still unidentified — but it is content.

Both tools and `formats/PAL.md` are corrected; the round-trip is byte-exact
again. The lesson for this dashboard: **a green gate that nobody re-runs is
worse than no gate**, because it is load-bearing in exactly the places where
being wrong costs most.

---

## Evidence layer

### VICEROY.EXE — 1,241 functions

| | count |
|---|---:|
| total functions | 1,241 (550 load-image, 691 overlay) |
| total instructions | 212,778 |
| **named** | **156** |
| unnamed | 1,094 |
| status `AUDITED` | 73 |
| status `MANUAL` | 77 |
| status `RAW` | 1,085 |

**89 of the names came from `MAPEDIT.EXE`'s CodeView table** (2026-08-05).
MAPEDIT ships 1,071 symbols across 203 modules and VICEROY ships none, but the
two share an in-house C library — so a function fingerprinted with its
displacement and immediate fields deleted matches across both builds.
`tools/xmatch_mapedit_viceroy.py` verifies each candidate by extension, ignoring
the recorded boundaries. 12 of the 13 matches that landed on already-named
functions **agree**; the 13th was a correction (below). Details:
`docs/VICEROY_NAMES_FROM_MAPEDIT.md`.

This is **evidence of shared code, not of a shared call path** — `cycle_colors`
is the standing counterexample.

### Other executables

| EXE | disasm | named / verified |
|-----|-------:|---|
| VICEROY.EXE | 1,243 files | 156 named (see above) |
| MAPEDIT.EXE | 212 files | **1,071 CodeView symbols** — the richest symbol source in the project |
| OPENING.EXE | 147 files | 4 sigmatch-promoted; `_opening` deep-decoded |
| CLOSING.EXE | 138 files | 4 sigmatch-promoted; `_closing` deep-decoded |
| MPSCOPY.EXE / INSTALL.EXE | 0 | not disassembled, and not needed |

### Formats — 13 specs, all decoded

`EXE_MZ`, `RTLINK`, `MP`, `PAL`, `SS`, `PIK`, `FF`, `TXT`, `DAT`, `COL`, `BIN`,
`MOV`, `GIF`. `MP` and `PAL` round-trip byte-perfect through real
extract/encode pairs; `SS`/`PIK`/`FF` decode losslessly via the byte-verified
FAB codec in `tools/ssdec.py`; the rest are byte-identity containers.

**`CYCLE.DAT` is decoded** (2026-08-05) — it was the last format marked
"unclear". `{u16 count; struct {u8 len, phase, start, delay;} band[8];}`,
shipped as one band of 8 from index 120 stepping every 35 ticks of a 60.8766 Hz
timer. See `docs/PALETTE_AND_CYCLING.md`.

---

## Specification layer — `spec/`, 64 sheets

The mature part of the project. **17 open TBD lines**, in 10 sheets:

| sheet | open |
|---|---:|
| `ui/debug_screens.md` | 3 |
| `ui/trade_routes.md` · `ui/options_dialogs.md` · `ui/diplomacy_popups.md` · `ui/dialog_framework.md` · `ui/colonizopedia.md` | 2 each |
| `ui/popups.md` · `ui/map_editor.md` · `ui/ff_pick_and_briefings.md` · `ui/combat_analysis.md` | 1 each |

All game-system formulas are byte-closed: combat damage, market drift, FF
acquisition, LCR distribution, REF growth, score, map generation (`func_064A10`,
passes P0–P6), colony-site value, native alarm, immigration.

**UI coverage.** The 2026-07-28 adversarial audit found ~300 UI surfaces with no
spec. That ledger is now **worked through** — Colonizopedia, map editor,
options/music/debug, European diplomacy, woodcuts, tutorial, multiplayer,
Combat Analysis, trade routes, FF pick, briefings and intro cards all landed as
specs during July. `docs/UI_AUDIT_TRACKER.md` is the live view, now 24 rows.

**182 rulings** recorded in `notes/rulings/RULINGS.md`.

---

## Implementation layer — `port/`

A playable HTML/canvas port built from the spec, not from the disassembly.

| | |
|---|---|
| tests | **167/167** (`port/tools/test_flow.py`, headless Chromium) |
| source | ~6,550 lines, one file |
| bundle | 2.8 MB single self-contained HTML |
| coverage | title → difficulty → nation → briefings → intro → King → map → colonies → Europe → combat → natives → Congress → Declaration → REF → endgame |
| menus | all six MENU.TXT pulldowns, every row bound or visibly greyed |

**What it does not have** — the full list lives in `port/README.md`; the
headlines are **AI opponents** (deliberately last: `spec/systems/ai.md` is the
thinnest area and real opponents would mean inventing behaviour), the **Combat
Analysis dialog**, byte-exact **advisor-report body layouts**, and **audio**
(out of scope by user decision).

---

## Direction

Per-line annotation of all 1,241 functions (gate D) has been **deliberately
deprioritised** since 2026-06. It is not the shortest path to the goal, and the
last two years of progress have come from three other moves instead:

1. **Render-and-diff against live DOSBox captures.** Every pixel disagreement is
   a real defect; this found the fog stencil bug, the TERRAIN palette question
   and the coast quadrant direction.
2. **Cross-binary symbol transfer.** MAPEDIT's CodeView table is worth more than
   months of manual naming.
3. **Building the thing.** The port is the strongest possible test of the spec —
   it fails loudly when the spec is wrong.

The remaining genuinely-blocked items all need a **live capture or runtime
trace**, not more static analysis: ~17 runtime-only spec values, the `0x9408`
REF and `0x9654` FF candidate tables (BSS-only), three unexplained pixels on the
Sea Lane tile, and whether the colour cycle is visible on the score/woodcut
plates.

---

## Housekeeping found during this refresh

- ✅ **fixed** — `encode_pal.py` / `extract_pal.py` / `formats/PAL.md` (above).
- ✅ **fixed** — `docs/UI_AUDIT_TRACKER.md` claimed the port lacked Pillage, Go
  to Place, Begin Trade Route and the trade-route editor. All four have shipped
  since 2026-08-04.
- ⚠️ **open** — `spec/BACKLOG.md` still calls the random map generator "the one
  whole system still unlocated" in its 2026-06-19 header, while
  `spec/systems/map_generation.md` has it byte-verified at `func_064A10` and the
  same file says so further down. The header needs striking.
- ⚠️ **open** — the "Memory (durable knowledge)" section of the old STATUS
  pointed at a Windows path (`C:\Users\gregc\...`) that does not exist in this
  checkout. Dropped rather than carried forward; if those notes matter they
  should live in `notes/`.
- ⚠️ **open** — gate B (above) either needs a real codec exercise or retirement.
