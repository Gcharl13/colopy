# .DAT — Misc Binary Data

Three `.DAT` files, three unrelated formats, three different owners. Rewritten
2026-09-02 (REMAINING_WORK.md G6) from the readers; the previous version of
this page guessed that `CYCLE.DAT` was "a tiny code patch" and left every
loader TBD. Offsets are file offsets into `VICEROY.EXE`
(`data_extracted/disassembly/VICEROY_annotated.asm`); DGROUP strings are
relative to file `0x1D9A0`.

| File | Size | Owner | Reader | Round trip |
|------|-----:|-------|--------|------------|
| `CYCLE.DAT` | 34 | VICEROY.EXE | `func_0783E4` @`0x0783E4` | bit-exact (`tools/asset_codecs.py` `cycle_dat_*`) |
| `PATH.DAT` | 6,459 | OPENING.EXE | string @ OPENING file `0xBFE8`; parser not traced | bit-exact (`path_dat_*`) |
| `INSTALL.DAT` | 14,153 | INSTALL.EXE | not annotated | bit-exact, **opaque** (`opaque_*`) |

A search of `VICEROY.EXE` for `.DAT` finds only `CYCLE.DAT` (DGROUP `0x25F9`,
file `0x1FF99`) and `HALLFAME.DAT` (`@0x1EB92`/`@0x1EBC7`, read/written by
`hallfame_dat_write` `@0x3ADA6` — not a shipped file). `PATH.DAT` and
`INSTALL.DAT` are not named in VICEROY at all.

`tools/verify_assets.py` runs every codec below over `raw/COLONIZE/` under
`make test`; a decoded JSON of each is written with `--emit`.

---

## CYCLE.DAT — the palette-cycling band table (BYTE_VERIFIED)

**Reader `func_0783E4`** (VICEROY file `0x0783E4`):

```
0783E8  mov word [0x929e], 0                 ; count = 0 (default when the file is absent)
0783EE  push ds ; push 0x25f9                ; "CYCLE.DAT"  (DGROUP 0x25F9, file 0x1FF99)
0783F2  lea bx, [0x25f6]                     ; "rb"         (DGROUP 0x25F6)
0783F6  lcall 0x181f, 0xe86                  ; fopen
078402  push ax ; push 1 ; push 0x22 ; push 0x929e
07840A  lcall 0xd1d, 0x528                   ; fread(0x929E, 0x22, 1, fp) -- 34 bytes
07841B  lcall 0xd1d, 0x3f4                   ; fclose
```

The 34 bytes land in DGROUP `0x929E` and are consumed as

```c
struct {
    uint16 count;                                  // active bands
    struct { uint8 len, phase, start, delay; }     // 4 bytes each
        band[8];
};                                                 // 2 + 8*4 = 34 = 0x22
```

by `cycle_init` (`@0x0C4A4`) and `cycle_colors` (`@0x0C51A`) — field sites
and the 60.8766 Hz tick derivation are in `docs/PALETTE_AND_CYCLING.md`.
Shipped: `count = 1`, `band[0] = {len 8, phase 0x3D, start 120, delay 35}`.

**Opaque for the engine, verbatim for the codec:** `band[count..7]` (bytes
`6..33`) are never read — that is why they disassemble as stray x86, the
source of the old "code patch" reading — and `band[i].phase` is overwritten
with 0 at init (`@0x0C4EF`). The decoder still emits all eight bands so the
encoder can reproduce the file byte for byte.

Decoded: `data_extracted/data/CYCLE_DAT.json`.

---

## PATH.DAT — cinematic ship-path waypoints (format BYTE_VERIFIED, consumer partly)

Plain ASCII: 701 lines of `"x, y"` followed by CR LF, then one empty line
(the file ends `…161, 114\r\n\r\n`). First line `868, 89`, last `161, 114`.

Consumer: **OPENING.EXE** — the string `"PATH.DAT"` is at OPENING file
`0xBFE8` (next to `"CREDITS"` and `"OPENING"`); `spec/ui/cinematics.md`
attributes the waypoints to the opening ship (`_ship[]` `@0x4F0C`). The
parse routine has not been read (blocker: OPENING.EXE is outside the
VICEROY listing), so the codec commits only to the *text* grammar: every
line that re-encodes exactly as `f"{x}, {y}"` is stored as `[x, y]`; any
other line would be kept verbatim under `{"raw": …}` (none in the shipped
file). Not read by VICEROY.EXE.

Decoded: `data_extracted/data/PATH_DAT.json`.

---

## INSTALL.DAT — installer manifest (OPAQUE)

14,153 bytes beginning `87 15 64 46 87 19 23 0A 05 05 C0 05` then ASCII
`config.col` and zero padding — evidently a record list with a small header
per null-padded filename. **That is an observation, not a decode:**
`INSTALL.EXE` has not been annotated, so no field is byte-verified and the
codec carries the whole file as `opaque_hex` (with the ASCII runs listed
for orientation only). Used by `INSTALL.EXE` alone; not named in VICEROY.

---

## Round-trip

`tools/asset_codecs.py` — `cycle_dat_decode/encode`, `path_dat_decode/encode`,
`opaque_decode/encode` — all bit-exact against `raw/COLONIZE/` (checked by
`tools/verify_assets.py`, pinned by `tools/stale_check.py` probe `G6`).
