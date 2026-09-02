# .PIK — MADS Packed Image Format (320×200 backgrounds)

Full-screen background images for game screens. Each .PIK is a single
320×200 indexed-color image (using VICEROY.PAL or an embedded palette),
FAB-compressed inside a MADSPACK container.

**35 .PIK files in COLONIZE/**. See
[`assets/backgrounds/BACKGROUND_CATALOG.md`](../assets/backgrounds/BACKGROUND_CATALOG.md)
for the per-file role table.

---

## Layout

```
[MADSPACK 2.0 header — 16 bytes, directory of 10-byte entries, data from 0xB0]
  Section 0: 8-byte image header — +0 u16 HEIGHT, +2 u16 WIDTH, +4..+7 unread
  Section 1: pixel data (width×height indexed bytes, FAB-compressed)
  Section 2: palette (256 × 3 RGB6 entries) — present on some files only
```

> **Corrected 2026-09-02 (REMAINING_WORK.md G5, RULINGS 2026-09-02c):** the
> previous layout listed *Section 1 = palette, Section 2 = pixels*. The
> engine reads them the other way round (loader below), and every shipped
> file agrees (`ssdec` census: `COLONY.PIK` = `(8), (23040)` — no palette
> section at all; `EUROPE.PIK` / `WOODPANL.PIK` = `(8), (64000), (768)`).
> The header's first word is the **height** (`COLONY.PIK`:
> `48 00 40 01 00 00 44 25` → h 72, w 320). `port/tools/build_assets.load_pik`
> picks sections by size and was never affected.

---

## Reference implementation

[`mpskit/pik.py`](../../tools/mpskit/pik.py) +
[`mpskit/madspack.py`](../../tools/mpskit/madspack.py) +
[`mpskit/fab.py`](../../tools/mpskit/fab.py).

CLI:
- `mpskit pik unpack <file.PIK>` — emits `<NAME>.PIK.png` (320×200 RGB image)
- `mpskit pik pack <file.PIK>` — re-encodes from PNG

Round-trip is lossless decoded (FAB compression non-deterministic).

---

## Loader in VICEROY.EXE — LOCATED (2026-09-02, G5)

Two loaders share the MADSPACK stream layer (`func_076E50` open,
`func_077100` section read — `formats/SS.md`). File offsets into
`VICEROY.EXE`; DGROUP strings relative to file `0x1D9A0`.

- **`func_076AEC`** (file `0x076AEC`) — loads header + pixels, **no palette**.
- **`func_076B9E`** (file `0x076B9E`, thunk **`0x181F:0x44E`**, 11 callers —
  the `load_PIK_fullscreen` of `spec/ui/cinematics.md` §2a) — the same plus
  the palette into its 5th argument.

Both: `strcpy` the name `@0x76AFC` / `@0x76BAE`; append the extension
**`"PIK"`** — DGROUP `0x23FA` / `0x2402`, **no dot** (the `'.'` is added by
`func_00D72E` via `lcall 0x1a1f,0xa94`: `strrchr '.'` `@0xD73B`, else
`strcat "."` (DGROUP `0x2626`) + ext `@0xD74F–0xD761`) — which is why a
`".PIK"` search of the EXE finds nothing; mode `"rb"` = `0x23FE` / `0x2406`.

| Section | Read at | What the engine does with it |
|---|---|---|
| 0 (8 bytes) | `mov ax,8; lcall 0x1a1f,0xe82` `@0x76B3B–0x76B3F` / `@0x76BF0–0x76BF4` into `[bp-0xC]` | `+0` = **height**, `+2` = **width**: pixel length = `hdr+2 × hdr+0` (`mov ax,[bp-0xa]; imul word [bp-0xc]` `@0x76B7C–0x76B7F`); when the "anchor to bottom" arg `[bp+0x10]` is set the destination row is `surface.h − hdr+0` (`mov dx,[bp+8]; sub dx,[bp-0xc]; lea bx,[bp+8]; lcall 0x181f,0x290` `@0x76B59–0x76B64`; `0x181F:0x290` → `func_00C8E8` = `off + y·stride + x` over a `{h, w, off, seg}` surface). **`+4..+7` are never read** — meaning TBD (blocker: no reader in VICEROY). |
| 1 (w×h) | `@0x76B6E–0x76B82` | pixels straight into the caller's far buffer |
| 2 (0x300) | `func_076B9E` only: `push [bp+0x14]; push [bp+0x12]; mov ax,0x300` `@0x76C40–0x76C54` | palette into the 5th argument |

`COLONY.PIK` (72 rows) is the bottom-anchored partial screen; the 200-row
files fill the frame.

---

## Extraction outputs

For `<NAME>.PIK`:
- `assets/backgrounds/<NAME>/<NAME>.PIK.png` — the rendered 320×200 image
- `assets/backgrounds/<NAME>/<NAME>.PIK.json` — image metadata
- `assets/backgrounds/<NAME>/loader.json` — sidecar
