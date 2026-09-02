# STATUS — project state

> **The single source of truth for current project state.** Every figure below
> was re-measured on **2026-08-05**, not carried forward. Where a gate could not
> be measured in this checkout, it says so instead of quoting the old number.
>
> For the correct-vs-misleading information audit see [`AUDIT.md`](AUDIT.md);
> for the three-layer model (evidence → **spec** → implementation) see
> [`METHODOLOGY.md`](METHODOLOGY.md). The specification (`spec/README.md`) is
> the source of truth; `viceroy_source/` is evidence (`viceroy_source/ROLE.md`).

**Last refreshed: 2026-08-07 (evening pass).** (Previous refreshes:
2026-08-07 morning, 2026-08-05, 2026-06-18.) The 2026-08-07 passes: fixed the
six player-reported defects, closed the raid-gate K TBD, added rival-power AI
and LOAD GAME (full COLONY##.SAV importer — the shipped 1653 game restores
field-for-field), folded the port-era harvest into the technical reference
(§30); then the play-test batches — map messages all popups (ruling i), the
F3 freeze + report sprites + F5 trade columns + sail confirms + Europe cells
(j), the popup framework to the byte-decoded math + all live woodcut
triggers (k), the colony surrounding-tiles panel (l), and the two HIGH
invented-flow rebuilds: the village haggle and the European meeting chain
(m). Treat any figure elsewhere dated before 2026-08-05 as unverified.

## Build tracker (the port)

**The completion roadmap is [`docs/COMPLETION_PLAN.md`](docs/COMPLETION_PLAN.md)** —
six phases from infrastructure to release, approved 2026-08-07. Work items
below are superseded by that plan's phase lists.

Where the port's work is tracked, in the order to consult them:

| Document | Role |
|---|---|
| **`docs/REMAINING_WORK.md`** | **START HERE for what is left.** The complete open-items ledger for finishing the handheld build (2026-08-17): blocking bugs, missing features, fidelity debt, board verification, unshipped assets, audio, tooling. Compiled by auditing the whole tree, and it records where the ledgers below disagree with each other. |
| **`docs/MESSAGE_STATUS.md`** | Every GAME.TXT message key's status, regenerated mechanically by `python3 port/tools/message_status.py`. Current (Phase 4 complete): **411 done + 29 via-DATA, 0 missing, 0 unwired**; **1 BLOCKED** (FULL's join-colony crowding threshold, behind func_02883E's jump table), 34 N/A, 24 support lists. |
| **`docs/POPUP_AUDIT_2026-08-08.md`** | The 200-row audited gap ledger with severities and evidence notes. Rows resolved by rulings i-m are superseded by RULINGS.md; unresolved HIGH/MEDIUM rows are the work queue. |
| **`notes/rulings/RULINGS.md`** | Per-batch decisions: what was byte-solved, what was implemented, which stand-ins are flagged TBD. The 2026-08-07 series (a-m) is the port-era log. |
| **`docs/UI_AUDIT_TRACKER.md`** | Per-screen byte-verification coverage (the standing UI mandate in CLAUDE.md). |
| `port/tools/test_flow.py` | The behavioural gate: **236/236**, including the Phase-5 end-to-end playtest. |

Done since the plan (2026-08-07 n-z14): Phases 0–3 and the pre-capture
sweep, then **Phase 4 COMPLETE** — the DOSBox capture batch (Hall of Fame
from crafted HALLFAME.DAT, K-threshold=10000, F4/F5/F6/F9 references, the
ICONS profession figures, Europe slot pitches 17/18 + nation sack + the
Bound-For manifest) and the disassembly windows (func_0734F8's 43-block
order → tutorial/woodcut/REF import; func_020F50 → all tutorial guard
bits; func_073474 inks; func_008D00 capacity; func_05CA7E → the seven
aftermath bulletins; func_04A7CA Speak-with-Chief; the func_049600 tail →
@TRADE0 quality; func_05BE84 raid payloads; func_056C3E treaty effect;
func_059B90/03FDDE/04E2D6 shipping; func_034AE0 the tax petition;
func_057F4E the MEEK/MANLY strength predicate; the 0x191F:0x9C0 disposal
gate). **MISSING 0, BLOCKED 1.** Every remaining flag is a documented
byte-read ceiling, not an unread window.

**Phase 5 COMPLETE (2026-08-08, tag `port-v1.0`)** — the final audit:
ledger re-verified (411 done + 29 via-DATA, 0 missing/unwired, 1 BLOCKED
ceiling, 34 N/A); the full `shots.py` (47 scenarios) + `render_diff.py`
(15/15 pairs) pass; and the scripted END-TO-END PLAYTEST is in the suite —
a fresh Discoverer game driven through the public flows: tutorial card →
landfall → founding → field + Town Hall assignment → three producing
turns → the Europe muskets run (Go To's Europe row, the three-turn
crossing both ways, the market purchase, the unload dialogs) →
declaration (mobilization + the King's landing) → the won war → retire →
Hall of Fame (independent record) → the lost war (KINGWIN + dependent
record). Staged middles (the bell climb, combat attrition) are marked in
the block. The user-defect batch that preceded it (RULINGS 2026-08-08a)
fixed the Go To Europe row, the press-edge pulldown gesture, flick
drags, the nation-sack ink, and the new-game state leak.

---

## Where the project actually is

Three layers, in the order `METHODOLOGY.md` defines them.

| Layer | State |
|---|---|
| **Evidence** (disassembly, asset decode) | 1,241 VICEROY functions inventoried; **156 named**, 1,094 not. All 13 container formats decoded. |
| **Specification** (`spec/`, 64 sheets) | The mature layer. **17 open TBD lines across 10 sheets**, each named with its blocker. Every game-system formula is byte-closed. |
| **Implementation** (`port/`, HTML) | Playable start-to-endgame, **236/236 tests** (incl. the end-to-end playtest), ~12k lines, 3.6 MB single-file bundle. Drag-and-drop, byte-decoded popup framework, all live woodcut triggers, popup speakers incl. MYR meeting portraits, the village haggle loop, the European meeting chain, native + rival AI (reduced/R-tier), LOAD GAME incl. the shipped COLONY##.SAV format. Main gaps: see the Build tracker above. |

The honest one-line summary: **the spec is close to done, the port is the
working proof of it, and the raw per-line annotation of the binary is not and
may never be the point.**

---

## Verification gates

Re-run: `python3 tools/verify.py`, `python3 tools/sigmatch.py --self-test`,
`python3 tools/extract_pal.py && python3 tools/encode_pal.py`, ditto `_mp`,
and `make -C cport/host test` — which since 2026-09-02 runs gate C
(`assets`) on every invocation alongside the stack budget, the staleness
probes (`records`) and the .ino mock gate (`mock`).

| Gate | Status | Measured 2026-08-05 (C: 2026-09-02) |
|------|--------|---------------------|
| A. sigmatch self-test | ✅ **PASS** | 17/17 BYTE_VERIFIED helpers re-found |
| B. byte-identity round-trip | ⚠️ **NOT MEANINGFUL AS IMPLEMENTED** | see below |
| B-CODEC. decode→encode round-trip (2026-09-02) | ✅ `tools/verify_assets.py` under `make test`: 11 files re-encoded bit-exactly (PAL, MP, 3 DAT, 5 COL, MOV), 246 containers decode-checked, 45 byte-identity; REMAINING_WORK.md G6 | `python3 tools/verify_assets.py` |
| B-PAL. PAL extract+encode | ✅ **PASS** (fixed today) | was silently FAILING since 2026-06-27 — see below |
| B-MP. MP extract+encode | ✅ **PASS** | `AMER2.MP` SHA-exact |
| C. visual asset extraction | ✅ **PASS** (rewritten 2026-09-02) | `extract_visuals.py`: SS **204/206** (1,425 frames; BDARK skipped per CLAUDE.md rule 5, `WIN-FWRK.SS` a DECLARED failure), PIK **35/35**, FF **5/5** (340 glyphs), 3 s, into `extracted/assets/` — see below |
| C-VISUAL. catalog generation | ⚪ **NOT RUN** | `tools/build_catalogs.py` was not exercised in the 2026-09-02 pass; the frame counts it would read now come from the in-repo codec, and BUILD.md's "1,676 frames across 205 sheets" is unreconciled against today's 1,425/204 |
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

### Gate C was a gate that could not fail (found 2026-09-02)

"NOT RUNNABLE HERE" was the kind reading. `tools/extract_visuals.py` drove
an external `mpskit` expected at `<repo>/../tools/mpskit/main.py` — a path
that exists in no checkout of this project — and never inspected the child
process's exit status, so every run printed `205/206 extracted` while
writing **zero PNGs**. The tracked `assets/*/loader.json` sidecars, every
one reading `frames_or_glyphs_count: 0`, are that run's residue (left in
place; they are not this pass's to delete). The tool is rewritten on the
in-repo byte-verified codec (`tools/ssdec.py` + `port/tools/build_assets.py`'s
PIK/FF readers — the same code the JS bundle and the C pak are built from),
writes to `extracted/assets/` as CLAUDE.md's path convention says, declares
its one codec failure (`WIN-FWRK.SS`: palette section not 6-bit, cause TBD)
and fails if that declaration goes stale in either direction, and runs
under `make -C cport/host test`. Ledger: `docs/REMAINING_WORK.md` G7.

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
Analysis dialog**, and byte-exact **advisor-report body layouts**. **Audio**
remains out of the JS port's fidelity scope, but as of 2026-08-17 it exists as
a separately-scoped **cport milestone** (`docs/AUDIO_PORT.md`): the caller-side
sound layer is byte-pinned and ported (`cport/audio/`), all 67 shippable ids
are captured/packed (`COLAUDIO.PAK` — 16 bit-clean COLDIG slices + 51 driver
renders, empirical-capture tier), both board backends are written (P4 I2S,
Teensy MQS; opt-in `COLOPY_AUDIO`, off until verified by ear on hardware).

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
