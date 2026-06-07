# Render Chain — How the Game Composes a Frame

Pixel-level trace of how VICEROY.EXE renders the game screen each
frame. Built from byte-traced sources where available, anchored to
prior pixel-verification work for the rest.

**Resolution**: VGA mode 13h (320×200, 256 colors, 1 byte per pixel
indexing into VICEROY.PAL).

---

## Layer order (bottom to top)

1. **Terrain base** — for each visible tile, the base terrain sprite
   from PHYS0.SS.
2. **Terrain texture** — TERRAIN.SS overlay for grass/water variants.
3. **Forest overlay** — auto-forest sprites from PHYS0.SS rows 0x21
   (mountains) and 0x31 (hills) when applicable.
4. **River overlay** — river sprites (PHYS0.SS rows 0x01/0x11) when
   the .MP byte's bit 5 is set.
5. **Coast halo** — beach pixels around coastal water tiles (sprite
   indices 150–153).
6. **Roads** — drawn between road-tile centers.
7. **Settlements** — colony sprites from BUILDING.SS, native sprites
   from MSS*/MYR*.SS.
8. **Units** — unit sprites from ICONS.SS at unit's tile position,
   facing the unit's direction.
9. **Fog of war** — semi-transparent dark overlay for unexplored tiles.
10. **HUD overlays** — top status bar + side panel + minimap.
11. **Dialogs** — modal dialog boxes (PIK background + WOODFRAM + glyphs).
12. **Mouse cursor** — CURSOR.SS at current mouse coordinates.

---

## Tile-render chain (BYTE_VERIFIED via prior pixel work)

Per CLAUDE.md (and re-derivable from byte analysis once Phase D
annotates them):

```
func_O514  →  func_O513  →  func_O512
```

- `func_O514` (top-level): walks the visible viewport, iterating
  (screen_x, screen_y, map_x, map_y).
- `func_O513` (per-tile composer): looks up the .MP byte for
  (map_x, map_y), decodes terrain_id + river_bit + forest_bit, picks
  the right sprite stack.
- `func_O512` (sprite blitter): copies sprite pixels to the framebuffer
  with index-0-transparent skipping.

The exact file offsets of these three functions are TBD (Phase D —
find via the call chain from the per-turn render function).

---

## Unit render

For each visible unit:

1. Read UnitRecord at `DGROUP:0x3146 + idx × 0x1C` (BYTE_VERIFIED).
2. Extract `unit_type` (byte +0), `direction` (low bits of byte +0x15),
   `x, y` (location bytes).
3. Compute screen coords: `(x - viewport_x) × TILE_W`,
   `(y - viewport_y) × TILE_H`.
4. Look up sprite index from a `unit_type → sprite_index` table
   (TBD — Phase D find via the unit-sprite mapping).
5. Adjust by `direction` for facing variants.
6. Blit ICONS.SS sprite at computed screen coords.

---

## HUD render

The game's HUD has 4 fixed regions:

1. **Top bar** — turn counter, current player, gold, bell pool. Read
   from `[DGROUP:0x538E]` (turn — BYTE_VERIFIED), PowerRecord fields,
   etc.
2. **Side panel** — selected unit info (UnitRecord fields).
3. **Minimap** — small overview rendered from .MP at low zoom.
4. **Status messages** — recent event message via the messaging API
   (`LCALL 0x181F:0x0652` = `display_text_key`).

---

## Dialog render

Every dialog is composed of:

1. **Background**: WOODPANL.PIK or WOODPAN2.PIK tiled across the dialog
   rect.
2. **Frame**: WOODFRAM.SS border sprites.
3. **Title strip**: NAMEPLAT.SS at top.
4. **Body text**: glyph-by-glyph from FONTSMAL.FF or FONTTINY.FF.
5. **Sprite previews**: optional CC-NN.SS portrait (FF dialog),
   ICONS.SS unit icon (unit dialog), etc.
6. **Buttons**: drawn as text in FONT-NP.FF (for unavailable) or
   FONTSMAL.FF (for available).

The dialog framework function is `func_06F0F4` (identified via strings
CHECKBOX, DEFAULT, OPTIONS, PROMPT, etc. in BYTE_VERIFIED string
analysis). Per-dialog catalog: see `docs/UI_DIALOGS.md`.

---

## Color cycling (palette animation)

Some palette indices are continuously cycled by a timer interrupt to
animate water shimmer, lava glow, and similar effects. Driven by
CYCLE.DAT (see `formats/DAT.md`).

Mechanism:
1. Cycle-tick function reads CYCLE.DAT at startup into a DGROUP table.
2. On each timer tick, for each cycle entry, rotate the palette
   indices [start_idx..end_idx] by 1 position.
3. Re-stream the modified range via VGA I/O port 0x3C9.

The function is BYTE_VERIFIED-pending: find via writes to
DOS port 0x3C9 in a function called from a timer interrupt handler.

---

## Sprite blitting (the inner loop)

The `func_O512` blitter (per CLAUDE.md naming from prior pixel work)
iterates sprite pixels, skipping color 0 (transparent), and writes
the rest to the framebuffer. The framebuffer is the DGROUP-allocated
320×200 byte array later DMA'd or copied to VGA video memory.

For 16×16 tile sprites, the inner loop is roughly 256 byte-copies per
sprite — about 60,000 cycles per visible tile on a 16MHz 286, or
~10ms for a 14×16 visible tile grid. Hence the game targets ~10 FPS
during action turns.

---

## Cross-references

- `formats/PAL.md` — VGA palette format
- `formats/SS.md` — sprite-sheet container format
- `formats/PIK.md` — full-screen background format
- `formats/MP.md` — map data format (the input to terrain rendering)
- `formats/DAT.md` — CYCLE.DAT description
- `assets/sprites/SPRITE_ROLE_CATALOG.md` — sprite-to-role mapping
- `viceroy_source/FUNCTION_INVENTORY.md` — game-system function map

---

## Open work (Phase D dependencies)

1. Annotate `func_O514`/`func_O513`/`func_O512` from byte-traced
   sources. Verify each transitively cites a BYTE_VERIFIED helper.
2. Build the unit_type → ICONS.SS sprite index table from the
   unit-render function.
3. Identify the cycle-tick function via I/O-port-0x3C9 search.
4. Annotate the dialog framework functions in detail (the layout
   engine that calls drawing primitives).

---

## 2026-05-03 Update — LCALL formula breakthrough

The Day-1 disasm sprint produced a definitive formula for resolving
every `LCALL <seg>:<off>` in load-image disasm to its target overlay
function:

```
thunk_file_offset    = 0x2400 + (lcall_seg << 4) + lcall_off
overlay_file_offset  = overlay_directory[ljmp_seg].file_offset + ljmp_off
```

This decoded 7,048 of 8,869 LCALL sites (79.5%) to specific overlay
functions. The remaining ~20% are direct calls to RTLink runtime
entry points (0x110D:0x0DAB and 0x110D:0x0D91) — those don't carry
overlay metadata.

### Render-chain functions located via the formula

| Function | Thunk LCALL | Overlay target | File offset |
|----------|-------------|----------------|-------------|
| screen_blit_helper | `LCALL 0x1A1F:0x0E02` | 0x0000:0x0002 | **0x025902** |
| load_PIK | `LCALL 0x191F:0x087A` | 0x0000:0x000C | **0x02590C** |
| load_sprite_struct | `LCALL 0x191F:0x0FD0` | 0x0000:0x0054 | **0x025954** |
| popup_finalizer | `LCALL 0x1A1F:0x0E1E` | 0x0B70:0x0002 | **0x027954** |
| common_call_270x | `LCALL 0x181F:0x016E` | 0x004B:0x00E2 | **0x06048A** |
| random_int (BYTE_VERIFIED) | `LCALL 0x181F:0x04D4` | 0x09EF:0x0032 | **0x027DB2** |

### Dialog rect compute function (BYTE_VERIFIED)

`func_067DC8` at file `0x067DC8..0x067E09` (65 bytes) is the
canonical popup-rect compute — see `docs/DIALOG_GEOMETRY.md` for
the full data flow including upstream cursor/char-dim writers and
the (still unresolved) overlay setter at `0x0C36:0x000A`.

### Tooling

- `tools/resolve_lcall.py` — applies the formula to every .asm
  file, replacing `; UNKNOWN` with `; THUNK -> 0xSEG:0xOFF (overlay
  @file 0xNNNNNN)` after each LCALL line.
- `tools/classify_instructions.py` — bulk pattern classifier that
  pushed VICEROY ledger from 0.53% → 99.36% identified.
- `tools/auto_name_funcs.py` — string-xref-based function tagger;
  85 VICEROY functions auto-tagged with their distinctive strings.
- `tools/linkcheck.py` — validates every "file 0xNNNNNN" citation
  in docs against actual disasm offsets.
