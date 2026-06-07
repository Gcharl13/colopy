# main.py fabrication audit

Run on `colonize_sdl/main.py` 2026-04-25 (3897 lines). Catalogues every
constant that was hand-authored by Claude rather than pulled from an
extracted DOS or Win16 source.

Raw findings: `docs/MAIN_PY_FABRICATION_AUDIT_RAW.txt`.

## Summary counts

| Category                                    | Count |
|---------------------------------------------|-------|
| UI string literals without citation         | 255   |
| Hardcoded RGB color tuples                  | 163   |
| Hardcoded sprite indices (no SPRITE_BANKS)  | TBD   |

## Category 1 — UI strings that should come from extracted text

### Replace immediately (extracted source EXISTS)

| Hardcoded                                                  | main.py     | Source                                     |
|------------------------------------------------------------|-------------|--------------------------------------------|
| `MENU_ITEMS = ["GAME","VIEW","ORDERS",…]`                  | L332        | `extracted/text/MENU_sections.json` @keys  |
| `MENU_DROPDOWNS = {"GAME": [...], …}`                      | L334+       | `MENU_sections.json` parsed lines          |
| `_GOOD_NAMES = ["Food","Sugar",…]`                         | L149-151    | Win16 coltext0 strings (Sfx-adjacent ids)  |
| `_BUILDING_NAMES = ["Stockade","Fort",…]`                  | L172-176    | `LABELS_sections.json` or `PEDIA_sections` |
| `NATION_NAMES = […]` fallback                              | L?          | `NAMES_sections.json` (DOS_NATION_NAMES already used as primary) |
| `NATION_COLORS = […]` (RGB tuples per nation)              | L163        | `extracted/palette.json` indexed by nation |

### Already correct (extracted source IS used)

- `DOS_SEASONS` (L318) ← `NAMES_sections.json @SEASONS` ✓
- `DOS_NATIONALITY` ← `NAMES_sections.json` ✓
- `DOS_NATION_NAMES` ← `NAMES_sections.json` ✓
- `DOS_GREAT_KINGS / DEEDS / LEADER` (L279-282) ← `GAME_sections.json` ✓
- `COLONY_NAMES_BY_NATION` (L208-235) ← `COLONY_sections.json` ✓

## Category 2 — Hardcoded RGB tuples

163 `(r,g,b)` literals in main.py. Examples:

```
L112: 0:  20,   # Tundra      -> (172,164,164) tundra-grey
L113: 1:  66,   # Desert      -> (204,176,140)
L116: 4:  91,   # Grassland   -> (104,176, 72) dark green
L139: 25: 45,   # Ocean       -> ( 32, 44,136)
```

These are TERRAIN_COLORS / `(r,g,b)` for the minimap and fallback
fills. The DOS engine uses VGA palette indices (the second column is
the palette index, e.g. `45` is the ocean color in `VICEROY.PAL`).

**Replacement strategy**: introduce a top-level `PALETTE` dict
loaded from `extracted/palette.json`, then rewrite each `(r,g,b)` as
`PALETTE[index]`. The palette indices in the comments
(`# Tundra → 20`, `# Ocean → 45`, etc.) are already cited; we just
need to actually use the index.

## Category 3 — Right info panel (`_render_right_panel`, L3499)

Every coordinate, label, and color in this function was made up.
Specific lines:

```
L3540: self.font.render(surf, year_str, px + 4, info_y, white)
L3544: self.font.render(surf, f"Gold: {gold}", px + 4, info_y + 10, gold_col)
L3545: self.font.render(surf, f"Tax: {tax}%", px + 4, info_y + 20, cream)
L3554: self.font.render(surf, coord_str, px + 4, loc_y, dim)
L3565: self.font.render(surf, col_at.name[:12], px + 4, loc_y + 30, gold_col)
L3578: self.font.render(surf, f"Moves: {u.moves_left}", px + 4, unit_y + 10, cream)
```

The actual labels, font, and pixel offsets must come from the DOS
sidebar render function chain `func_O514 → func_O513 → func_O512`
(per `FUNCTIONS_INVENTORY.md`).  See task #62.

## Category 4 — Status bar (B COLONY F FORT …)

User confirmed wrong. Search by content turns up nothing in
extracted text yet. Possible homes:

- `LABELS_sections.json` (not yet enumerated)
- VICEROY.EXE near the bottom-bar render fn (search for "FORT" and
  "SENTRY" strings in `extracted/disassembly/strings_in_code.txt`)
- coltext0 widget specs

See task #68.

## Category 5 — Fonts

L602: `self.font = BitmapFont("FONTSMAL")` — only one font ever
loaded. Five fonts available: FONTINTR, FONTKING, FONTSMAL, FONTTINY,
FONT-NP. See task #67.

## Category 6 — MENU_DROPDOWNS contents

L334 hand-coded dict. Every key already exists in
`MENU_sections.json` (e.g. `@GAME` → "~GAME\n  Game Options\n  Colony
Report Options\n  …"). The accelerator markers (`~`) and submenu
indentation are preserved in the JSON. Replace by parser. See task
#61.

## Followups required (no extracted source yet — open new task)

- Status bar key-hint strings: not in extracted text. Need a
  disassembly-trace task to recover them from the bottom-bar render
  function.
- The key-hint font (FONTTINY?): trace `SetTextFont` call sites
  per render context.
- Right-panel labels: full disassembly trace required (task #62).

## How to make it stick

Task #73 adds CI enforcement so any new UI string / color / sprite
constant in `main.py` fails the build unless it has a `# CITATION:`
comment pointing to an extracted file or VICEROY.EXE offset.
