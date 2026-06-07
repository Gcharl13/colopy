# Naming Conventions

Every derived file in this tree follows these rules. They exist so that
a) the link between a derived artifact and its original is unambiguous, and
b) the tooling can mechanically check that nothing is mis-named.

## General principles

- **Original names are preserved verbatim.** If the DOS file is `PHYS0.SS`,
  every derived artifact begins with `PHYS0`. Case is preserved exactly as
  on the DOS distribution (uppercase for the stem, original case for the
  extension when relevant).
- **No spaces, no Unicode characters, no friendly aliases.** A sprite is
  `PHYS0_017.png`, not `phys0-17-soldier.png`. Friendly labels live in the
  sidecar JSON, not the filename.
- **Hex addresses are always 6-digit zero-padded uppercase**, prefixed with
  lowercase `0x` in narrative text but bare in filenames. Example:
  filename `func_006204_check_auto_forest_terrain.asm`; in prose,
  "function at `0x006204`".
- **Indices are zero-padded to 3 digits.** The 18th sprite of `PHYS0.SS` is
  index 17 → `PHYS0_017.png`.
- **Codepoints are zero-padded to 3 digits.** Glyph for ASCII `A` (0x41 = 65)
  is `<FONT>_glyph_065.png`.

## Per-artifact rules

### Disassembly (`code/<EXE>/`)

- One file per function: `disasm/func_<6hex>_<symbol>.asm`.
  - `<6hex>` is the function's start offset within the executable image,
    uppercase hex, zero-padded to six digits. Example: `func_006204`.
  - `<symbol>` is a snake_case identifier. If the function is not yet named,
    use `unknown_<6hex>` as a placeholder (also tracked in `functions.json`
    with `"named": false`).
  - Renames update both the filename and `functions.json`. The ledger
    regenerator fixes broken cross-references.
- Sidecar tables:
  - `header.asm` — MZ header + relocation table.
  - `overlay_loader.asm` — RTLink overlay dispatcher (VICEROY only).
  - `functions.json` — index keyed by hex offset string.
  - `strings.json` — every immediate string with offset and xref list.
  - `data_segments.md` — DS layout, globals, tables (hand-authored).
  - `structs.md` — reconstructed records (hand-authored).
  - `asset_xrefs.md` — asset filename → loader function (Pass 1 + Pass 2).

Inside each `.asm` file, every line has this column layout:

```
<6hex>  <up to 6 raw byte hex pairs>   <MNEMONIC>  <operands>   ; comment
```

Example:

```
006204  3C 08         CMP   AL, 0x08         ; lower bound (forest range start)
```

Lines we have not yet identified end with `; UNKNOWN`. Those count as RAW
in the ledger, NOT as identified.

### Sprite sheets (`assets/sprites/<SHEET>/`)

For each `<SHEET>.SS`:

- `<SHEET>_index.json` — sheet metadata: sprite count, palette id, dims,
  source SHA256, loader function offset.
- `<SHEET>_atlas.png` — assembled overview (every sprite tiled).
- `<SHEET>_<3-digit-index>.png` — one PNG per sprite.
- `<SHEET>_<3-digit-index>.json` — sidecar per sprite: width, height, byte
  offset within source file, transparent color, hash.

### Backgrounds (`assets/backgrounds/`)

For each `<NAME>.PIK`:
- `<NAME>.PIK.png`
- `<NAME>.PIK.json`

### Fonts (`assets/fonts/<FONTNAME>/`)

For each `<FONTNAME>.FF`:
- `<FONTNAME>.json` — glyph metrics, line height, baseline, kerning.
- `<FONTNAME>_glyph_<3-digit-codepoint>.png` — one PNG per glyph.

### Maps (`assets/maps/`)

For each `<MAP>.MP`:
- `<MAP>.MP.json` — decoded grid (terrain ids, prime resources, units, sea
  lane column).
- `<MAP>.MP.png` — visualisation rendered from the JSON using the master
  palette.

### Text (`assets/text/`)

For each `<NAME>.TXT`:
- `<NAME>.json` — parsed sections.

### Palettes (`assets/palettes/`)

For each `.PAL`:
- `<NAME>.PAL.json` — 256 RGB triples, scaled to 8-bit.
- `<NAME>.PAL.png` — 16×16 swatch grid.

### Audio (`assets/audio/`)

- `COLDIG.BIN.json` — bank index: `[ {id, offset, length, sample_rate, name} ]`.
- `samples/<NAME>.wav` — one WAV per decoded sample. `<NAME>` matches the
  in-game sound id from the bank index.

### Movies (`assets/movies/<NAME>/`)

- `<NAME>.MOV.json` — header + per-frame timing.
- `frames/<6-digit-frame-index>.png` — one PNG per frame.

### Data tables (`data/`)

For each `.DAT` / `.COL` / similar:
- `<NAME>.<EXT>.md` — narrative description with field offsets.
- `<NAME>.<EXT>.json` — machine-readable decoded form.

### Format specs (`formats/`)

One file per file extension we ship:
- `<EXT>.md` — byte-level layout, header fields, encoding rules, citations
  to the disassembly that confirms each rule.

## Sidecar JSON shape

Every `.json` sidecar for a decoded asset contains at least:

```json
{
  "source": "PHYS0.SS",
  "source_sha256": "…",
  "loader_function": "func_018A40_load_sprite_sheet",
  "loader_offset": "0x018A40",
  "called_with": { "sheet_slot": 3, "filename_ptr": "ds:0x4A20" },
  "extracted_by": "tools/extract_ss.py",
  "extracted_at": "2026-05-02T00:00:00Z",
  "round_trip_byte_equal": true
}
```

If `round_trip_byte_equal` is anything other than `true`, the asset is
considered NOT yet verified.

## Lint

`tools/lint_naming.py` (Phase 1 deliverable) walks the tree and flags any
file that violates these rules. CI for this archive is "lint passes plus
verify.py passes."
