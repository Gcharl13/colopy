# viceroy_cpp — Layer-3 C++ reimplementation (P0)

A modern C++ port of *Sid Meier's Colonization* (VICEROY.EXE), built **from the
spec** (`spec/`), per the project's three-layer model in `METHODOLOGY.md`. The
goal is to **look and run like the original**, while the low-level math is free
to be modernized — the spec's *documented behavior* is the contract, not the
16-bit byte sequence. See `REWRITE_READINESS.md` (repo root) for the full
strategy, fidelity policy, and roadmap.

> This is a clean Layer-3 implementation, distinct from the low-trust Layer-1
> evidence transcript in `viceroy_source/` (which is decode-notes, never
> compiled). Discipline follows `mapedit_source/REWRITE_PLAN.md`: cite the spec,
> never guess, verify against an oracle.

## Architecture — import once, run on a modern bundle
The shipped **runtime does not carry the original codec** (MADSPACK/FAB/`.SS`).
A one-time **offline importer** converts the original assets into a modern
bundle; the runtime loads only that. (See `REWRITE_READINESS.md` §4a.)

```
PHYS0.SS ──(import: MADSPACK/FAB/SS decode + atlas pack)──▶ phys0.png (paletted) + phys0.json
                                                            └──(render: bundle only, no codec)──▶ map
```

The atlas is a **paletted** PNG (color-type-3, `PLTE`+`tRNS`) — it stores palette
**indices**, not baked RGB, so the runtime keeps an indexed framebuffer and can
do palette **cycling** (animated water) later. `frames.json` keeps each frame's
`(w,h)` + original `.SS` hotspot `(x,y)` + atlas rect `(ax,ay)`.

## P0 — what works now
The **asset → pixels spine**, end to end:

- **importer** (`fab`/`madspack`/`ss` ← `tools/ssdec.py`, byte-verified) → **`bundle`**
  (atlas pack + `png_io` paletted write + `frames.json`).
- **runtime**: **`bundle`** loads the paletted PNG (libpng) + JSON → frames;
  **`pal`** loads `VICEROY.PAL`; **`mp`** loads `.MP`; **`render`** composites the
  map view (naive `sprite_idx = terrain_id`, skip placeholders 0/16/100 per
  CLAUDE.md hard rule #5, river overlay = frame 1); **`png_io`/`image_io`** write
  the result (PNG via libpng, PPM for diffing).

Importing `PHYS0.SS` then rendering `AMER2.MP` **from the bundle** yields a
928×1152 image **pixel-identical to the Python oracle**.

**`import-all`** bundles the whole asset set in one pass: **204 sprite sheets**
(`.SS` → `sprites/<NAME>.png` + `.json`) + **35 backgrounds** (`.PIK` →
`backgrounds/<NAME>.png`, paletted) + **4 fonts** (`.FF` → `fonts/<NAME>.png`
glyph atlas + `.json`, when the `.FF` files are present) + a `manifest.json`.
The orphan `TERRAIN.SS`/`BDARK.SS`/`FONTSMAL.FF` are skipped (CLAUDE.md #5);
0 decode failures. Single font: `import-font --ff FILE --atlas PNG --frames JSON`.

## Build & run (headless)
```sh
python3 bin/reconstitute.py                 # from repo root: rebuild raw/COLONIZE/*
cmake -S viceroy_cpp -B viceroy_cpp/build -DCMAKE_BUILD_TYPE=Release
cmake --build viceroy_cpp/build -j
B=viceroy_cpp/build
# 1) import EVERYTHING (offline): all .SS + .PIK -> modern bundle/
$B/viceroy_cpp import-all --colonize raw/COLONIZE --out $B/bundle
# 2) render (runtime): a bundled sheet + .MP -> image  (no .SS / no codec)
$B/viceroy_cpp render --atlas $B/bundle/sprites/PHYS0.png --frames $B/bundle/sprites/PHYS0.json \
    --mp raw/COLONIZE/AMER2.MP --out $B/map
python3 viceroy_cpp/verify.py --cpp $B/map.ppm    # PARITY OK iff runtime == ssdec oracle
```
`import-all` writes `bundle/{sprites,backgrounds}/*.png|json` + `manifest.json`.
For a single sheet use `import --ss FILE --atlas PNG --frames JSON`.

Needs **libpng** (a standard library, not a game codec). No display required:
P0 renders to a file. A windowed/interactive client (SDL/raylib, 320×200
mode-13h viewport) is a later phase.

## Verification
`verify.py` decodes the same assets via the byte-verified `tools/ssdec.py`,
composites identically, and pixel-diffs against the runtime's PPM. Because the
C++ render path goes **`.SS` → importer → bundle → runtime**, while the oracle
goes **`.SS` → ssdec**, a match validates the *whole bundle round-trip* (decode +
atlas pack + paletted-PNG write/read + JSON) — any divergence is caught. P0
result: **PARITY OK (3,207,168 bytes exact).**

## sim/ — headless game-logic core (P1–P3 done, golden-master tested)
A pure-logic, **headless** sim core (no I/O, no rendering) implementing the
byte-verified rules from `spec/systems/*`, with "modernized math" (plain
`int`/`int64`, but the *observable* integer truncation preserved). All validated
by a dependency-free golden-master suite (`sim/tests/sim_tests.cpp`):
```sh
cmake --build viceroy_cpp/build -j && ./viceroy_cpp/build/sim_tests   # ALL SIM TESTS PASSED
```
- **P1 economic spine** — turn/season cadence + orchestrated `step_turn`; colony
  production (tory penalty + expert), Sons-of-Liberty 1/64 EMA, hammers/build
  (surplus carry), warehouse cap, food→growth, immigration; market price drift
  (`>>8`); REF growth. (SoL 5/10/20%, price 800→797→794, REF 23/10/5/8, …)
- **P2 units & conflict** — `@UNIT` stats + Unit; land combat (odds, terrain
  defense, difficulty handicap, demotion ladder, capture); natives (mission/raid/
  tension/trade/tribute); diplomacy (war/treaty matrices, cooldown, AI willingness).
- **P3 meta systems** — Founding Fathers cost curve (Explorer ff1→129) + era
  bands + availability; revolution (declare gate, REF-war win, bonus `(1780-y)·2`,
  Tory uprising); scoring (mult {4,5,6,8,10}, population, rank `n²/3`); map-gen
  climate→terrain + 58×72 dims.

## P4 — the map-view SCREEN (`mapview`), composed strictly from the spec
`viceroy_cpp mapview --bundle B --mp raw/COLONIZE/AMER2.MP --out F [--turns N] [--scale S]`
composites the 320×200 mode-13h main screen from the bundle + the headless sim and writes PNG
frame(s). It is built **only** from `spec/ui/map_view.md` — every element traces to a spec
coordinate + tier (`src/mapview.cpp` carries the citation table); R-tier elements are drawn from
the *cited* approximate data and labeled, nothing is invented:

| Element | Rect | Source (`map_view.md`) | Tier |
|---------|------|------------------------|------|
| Background wood | full | WOODPANL.PIK (§3) | A |
| Menu strip | (0,0,320,9) | FONTTINY green idx68; MENU `~`titles (§2/§3) | B mech / **R** x-pos |
| Map viewport | (0,8,240,192) | 15×12@16, **TERRAIN.SS base + PHYS0 overlays** (§2) | B (terrains 0–26); mtn/hills base R; river/coast deferred |
| Minimap | (241,8,79,41) | `func_066CD6`; white viewport rect idx0x0F (§6.1) | B geom |
| Sidebar season/gold/tax | 244,58 / 244,66 / 290,66 | frame 1310262984 (§6.3) | **R** (no B source) |
| Sidebar unit panel | (240,136,…) | selected-unit — **blank** (no map unit in the sim yet) | honest empty |

**Active palette = PHYS0's embedded palette** (resolved from evidence: the map screen uses the
terrain sheet's palette, which WOODPANL/ICONS/fonts all share within ~2 indices). VICEROY.PAL is
**4 bytes/entry** (R,G,B,pad) and differs from it in **197/256** entries — an earlier "use
VICEROY.PAL" attempt was a 3-byte-parse mis-measurement and rendered terrain brown; PHYS0's palette
renders it correctly (green/blue), matching the P0 oracle.

**Faithful terrain** (`func_O514→O513→O512`, CLAUDE.md #7): each tile is `TERRAIN.SS[base]`
(`emit_ground_sprite`/`terrain_cell_transform`, byte-verified) composited under PHYS0 overlays —
forest (band `0x40`), mountains (`0x20`), hills (`0x30`). Water (Ocean/Sea-lane) draws its TERRAIN
base. This replaced the old naive `terrain_id→PHYS0` blit (which drew PHYS0's *river-edge* frames
for forested ids → fragments on black). The viewport now renders solid ground + forests + ocean,
recognizably the original.

> **Deferred (next milestone):** the **connectivity layers** — rivers (PHYS0 `0x51..0x5E` by
> 4-neighbor river connections) and the **coast beach-halo** (water-adjacent tiles, PHYS0
> `0x96..0x99` + the `0x70` sub-cell band) — both need the `func_O512` neighbor analysis. Also
> mountains/hills(27/28) use an R land-base approximation pending their exact base mapping.
- P1 remainder (full turn-loop phases) + P2+ (combat, units, natives, diplomacy,
  congress), screen-UI render, input, windowing, sound.

## Layout
```
include/   importer:  fab madspack ss pik ff    (.hpp)
           runtime:   bundle pal mp render
           presentation: surface mapview        (P4 map-view screen)
           shared:    png_io image_io util
src/       (same set) + main.cpp  (import-all / import / render / mapview subcommands)
sim/       game-logic core (P1-P3): types economy market turn ref immigration
           game unit combat natives diplomacy founding_fathers revolution
           scoring mapgen  (+ tests/sim_tests.cpp)
verify.py  oracle parity check (uses tools/ssdec.py)
CMakeLists.txt   (links libpng; builds viceroy_cpp + sim_tests)
```
