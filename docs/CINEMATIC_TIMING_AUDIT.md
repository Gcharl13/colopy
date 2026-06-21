# Cinematic Timing Audit — OPENING.EXE & CLOSING.EXE

> Evidence-layer doc (Layer 1). Byte-grounded RE of the per-frame playback in the two
> **separate** cinematic binaries. Tiers: B (byte-verified at a cited offset) / A (anchor) /
> R (reconstructed) / TBD. Feeds `spec/ui/cinematics.md`. **Scope expansion 2026-06-21** — the
> project was previously VICEROY-only; the user asked to crack the OPENING/CLOSING timing as part
> of completing the UI spec. Offsets are file offsets within each binary's RTLink load image.

## TL;DR
The cinematics are driven by a **real-time master clock**, not a fixed per-frame delay: a BIOS
18.2 Hz tick spin-wait advances a demo clock, and a cascade of `CMP clock, threshold` gates selects
which animation element/frame is active. Loop exit is **count-based** (the row/element count), not a
`-1`/`0xFFFF` sentinel — the `END OF DEMO` row is consumed upstream when the count is computed.
**KING2.SS is absent from both binaries** (and from VICEROY).

> **Disassembler caveat (B).** The playback code is **not** in `orphans_overlay.asm` in either
> tree — those files are ~92% `DATA_BYTE` with zero real `CALL`s: they hold the RTLink obj-name
> table (`opening.obj`/`picture.obj`/`text.obj`/`credit2.obj`…) and the **C symbol-name string
> table** (`_demo`, `_open_loop`, `_anim_clock`, `*_timing`, `_pan_x`, `_ship_path`, `_get_map`,
> `_scr_depth`, `_increments`, …) as data; the isolated `CMP byte ptr [0xNN63],ch` lines are the
> repeating `38 2E 63 XX` data signature mis-decoded as instructions. The real loops are in
> **`orphans_load_image.asm`** (genuine code; the prologue detector failed to promote these
> overlay-resident funcs, so they read as "orphans").

---

## 1. OPENING.EXE — title demo (panoramic pan)

`OPENING.PIK` is a wide panorama scrolled across the 320-px screen; sprites animate over it.

### 1.1 Per-frame loop — `code/OPENING/disasm/orphans_load_image.asm` (all **B**)
| Role | Offset | Bytes / insn |
|------|--------|--------------|
| Loop top (index table by counter `[bp-6]`) | `0x103E` | `8B 5E FA  MOV bx,[bp-6]` |
| Frame-variant select cascade vs clock `[0x82]` | `0x106A`…`0x10B8` | `CMP [0x82], 0x87/0x99/0xAD/0xC3/0xDC/0xEC/0xFC` |
| …continued | `0x117E` | `CMP [0x82], 0x1FB` |
| Draw/blit (resident sprite routine) | `0x111E` | `9A 00 00 92 03  LCALL 0x392,0` |
| Counter `++` | `0x1128` | `FF 46 FA  INC [bp-6]` |
| Exit test vs row count `[0x46]` | `0x112E` | `39 46 FA  CMP [bp-6],ax` (`ax=[0x46]`) → `JGE`, else `JMP 0x103E` |

The selection thresholds **135, 153, 173, 195, 220, 236, 252, 507** (`0x87,0x99,0xAD,0xC3,0xDC,
0xEC,0xFC,0x1FB`) are inline immediates — confirming the clock-vs-time comparison model. Exit is
count-based on `[0x46]` (number of rows in the loaded animation table).

### 1.2 Frame pacing — the master clock (all **B**)
A BIOS-tick spin-wait advances the demo clock once per real-time interval:
- `0x1335` `2B 0E 6C 00  SUB cx,[0x6c]` — reads the BIOS 18.2 Hz tick low word at `0040:006C`.
- `0x1142/0x1146` `MOV cx,[0x4ade] / MOV bx,[0x4ae0]` — current-tick latch (`_anim_clock` pair).
- `0x134D` `FF 06 82 00  INC [0x82]` — advances the **master demo clock `[0x82]`** when the
  interval elapses. The §1.1 cascade then maps `[0x82]` → active frame.

So the **delay quantum is one BIOS tick (~55 ms)** per clock step; element activation times are in
clock units. **B.**

### 1.3 `@OPENING` row format (`data_extracted/text/OPENING_sections.json`)
`(sprite_idx, activation_time, layer, pan_width)` — **col0–2 B** (data + in-file comments),
**col3 A** (consistent with the panorama X-extent; exact consumer not byte-pinned):

| sprite | time | layer | pan_width | comment |
|-------:|-----:|------:|----------:|---------|
| 0 | 78 | 1 | 640 | Wind 1 |
| 1 | 40 | 0 | 640 | Sun |
| 2 | 200 | 2 | 320 | Monster 1 |
| 6 | 502 | 3 | 320 | Fish |
| 9 | 701 | 0 | 0 | Bonk into land |
| 8 | 767 | 0 | 0 | Opening logo |
| -1 | 891 | 0 | 0 | END OF DEMO |

`-1` = END row (demo runs until clock ≈ 891). The 640/320 col3 values are the element X pan-extents
over the panorama; `0` = screen-fixed (logo / end). **A.**

### 1.4 Panning + ship-path subsystem (symbol-table names → **A**)
Named in the overlay C symbol table (`orphans_overlay.asm` data): `_pan_x` (scroll position),
`_pan_timing`/`_anim_clock`, `_scr_map`/`_scr_orig2` (off-screen panorama buffer),
`_update_to_map_area`/`_update_from_map_area` (scroll-buffer blit), `_ship_path`/`_load_ship_path`/
`_increments` (scripted ship motion for "Bonk into land"/"Guy getting out"). Symbols **A**; precise
per-function offsets **TBD** (overlay funcs not individually promoted).

---

## 2. CLOSING.EXE — end credits / retirement

### 2.1 Per-element composite loop — `code/CLOSING/disasm/orphans_load_image.asm` (all **B**)
| Role | Offset | Bytes / insn |
|------|--------|--------------|
| Loop top (stride-7 element table, idx `[bp-0x56]`) | `0xB16` | `8B 5E AA  MOV bx,[bp-0x56]` |
| Active-element check | `0xB25` | `83 BF A0 4B 00  CMP [bx+0x4BA0],0` → `JNE`/skip `JMP 0xBAF` |
| Draw/blit | `0xB91` | `9A 04 00 BC 02  LCALL 0x2BC,4` |
| Fade/effect (first element, `ax=0x5A`=90) | `0xBAA` | `9A 0E 00 9B 06  LCALL 0x69B,0xE` |
| Counter `++` | `0xBAF` | `FF 46 AA  INC [bp-0x56]` |
| Exit test vs active-count `[0x52]` | `0xBB5` | `39 46 AA  CMP [bp-0x56],ax` (`ax=[0x52]`) |

Element table bases: `0x4B96` (type), `0x4BA0` (active flag), `0x4BA2` (sprite/frame), stride 7.
A second, structurally identical pass at `0xC57` (idx `[bp-4]`, same `[0x52]` bound) — the
companion erase/redraw. Timing literals: `0xC8D CMP ax,0x2A` (42), fade `MOV ax,0x5A` (90). The
per-element time-pairs live **in** the stride-7 data table (read indirectly), not as inline
immediates; the real-time pacer (CLOSING's analogue of OPENING's `[0x82]`/`[0x6c]`) is in the outer
`_anim`/`_closing` driver. **B** (loop), **TBD** (outer-driver clock offset).

### 2.2 `@CLOSING` script
`CLOSING_sections.json @CLOSING` rows (Fireworks / Liberty Bell / Rock / Hat / Lady / Man / Military
/ "End of closing") feed the stride-7 element table. **B** (table present verbatim).

---

## 3. AMERICA.MOV (opening demo script)
`data_extracted/data/AMERICA_MOV.json`: the blob is a **1-bpp coastline/depth bitmap** (the
silhouette the ship sails toward) followed by a small **ship-path waypoint list** — trailing LE
words decode as `count` then per-step deltas (e.g. `8` waypoints, increments `3,9,3,3,2,2,2,3,2`),
consumed by `_load_ship_path`/`_increments` and tested against `_scr_depth`/`_depth_list`. Structure
**A/R** (decoded from the blob + symbol names); the exact opcode grammar of any non-bitmap header
bytes is **TBD**.

## 4. KING2.SS
**Absent (B, negative).** `grep -ri KING2` over `code/OPENING/`, `code/CLOSING/` (disasm +
`strings.json`) returns nothing; the spec already records it absent from traced VICEROY.EXE. No
binary in the set loads `KING2.SS` via a traceable path — treat as an unused/orphan asset unless a
runtime trace shows otherwise.

## 5. Still TBD
- OPENING `LCALL 0x392`,0 / CLOSING `LCALL 0x2BC`,4 — resolve the resident draw routine these enter
  (sprite blit vs frame compositor).
- The outer `_anim`/`_opening`/`_closing` driver: keypress early-out (`@keys_any`) + where `[0x46]`/
  `[0x52]` counts are computed from the script tables (the `-1`/"END" sentinel consumer).
- CLOSING outer-driver real-time clock offset (analogue of OPENING `[0x82]`/`[0x6c]`).
- AMERICA.MOV non-bitmap header opcode grammar (if any beyond bitmap + waypoints).
- `@OPENING` col3 exact consumer (pan-extent assumed from the panorama; not byte-pinned).
