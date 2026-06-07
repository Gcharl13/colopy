# .SS — MicroProse MADS Sprite Sheet Format

The variable-size sprite-sheet format used throughout VICEROY.EXE,
MAPEDIT.EXE, OPENING.EXE, and CLOSING.EXE.

**206 .SS files in COLONIZE/** total. See
[MANIFEST.md](../MANIFEST.md) and
[`assets/sprites/SPRITE_CATALOG.md`](../assets/sprites/SPRITE_CATALOG.md)
for the per-file role catalog.

---

## High-level structure

```
[MADSPACK 2.0 header — 14 bytes]
[per-section directory: N entries × 4 bytes]
[per-section data — variable, FAB-compressed or raw]
```

The MADSPACK container holds **4 sections** for a typical .SS:
- Section 0: sprite header (count, dimensions metadata)
- Section 1: per-sprite descriptor table (offset, w, h, hotspot per sprite)
- Section 2: palette (optional; some sheets reuse VICEROY.PAL)
- Section 3: pixel data (color-keyed, indexed-color)

Each section is independently FAB-compressed (LZ-style with bit-packed
literals + back-references) or stored raw, depending on a per-section
flag in the directory.

**Color key**: palette index 0 is transparent. Pixels reading 0 during
blit are skipped.

---

## Reference implementation

The byte-level format is implemented in
[`mpskit/ss.py`](../../tools/mpskit/ss.py) and uses
[`mpskit/madspack.py`](../../tools/mpskit/madspack.py) +
[`mpskit/fab.py`](../../tools/mpskit/fab.py) for the underlying
container + compression.

mpskit exposes both directions:
- `mpskit ss unpack <file.SS>` — emits per-sprite PNGs + JSON metadata
- `mpskit ss pack <file.SS>` — re-encodes from extracted PNGs

**Round-trip caveat**: FAB compression is non-deterministic at the bit
level — re-encoded .SS files don't byte-match the original. The
**lossless decoded round-trip** criterion applies: extract → re-encode
→ re-extract produces identical PNGs.

For byte-perfect verification of original assets, use
`tools/verify.py` which uses the byte-identity round-trip from the
golden manifest.

---

## Loader in VICEROY.EXE

The .SS loader function reads a filename string, calls fopen/fread,
decompresses each section, and stores sprite descriptors in a
SpriteSheet record at a DGROUP location.

**Loader function**: TBD (Phase D — find via PUSH "phys0" / PUSH
"icons" sites in VICEROY's startup code; the `func_0749E0` scenario
loader pushes these names).

---

## Extraction outputs

For `<NAME>.SS`:
- `assets/sprites/<NAME>/<NAME>.SS.NNN.png` — one PNG per sprite frame
- `assets/sprites/<NAME>/<NAME>.SS.NNN.json` — frame metadata
- `assets/sprites/<NAME>/<NAME>.SS.json` — sheet-level metadata
- `assets/sprites/<NAME>/<NAME>.SS.pal.png` — embedded palette swatch
- `assets/sprites/<NAME>/loader.json` — sidecar (loader_function,
  loader_offset, sha256, format_spec)

---

## Sprite role catalog

See [`assets/sprites/SPRITE_CATALOG.md`](../assets/sprites/SPRITE_CATALOG.md)
for the per-sheet role table. The detailed sprite-to-role mapping
(per-frame: "this is a soldier walking north") is in
`assets/sprites/SPRITE_ROLE_CATALOG.md` (Phase CV7 deliverable).
