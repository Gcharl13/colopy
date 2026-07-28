# UI Renderer Specification — v2 (2026-05-24, post-audit)

> ⚠ **SUPERSEDED (2026-07-28).** This doc is a **pre-resegmentation stub** with load-bearing
> errors: it sizes `func_06F0F4` at "80 bytes" (actually 1061 B, ENTER 0x168), reads `WIDTH` as a
> char-column count (it is a **pixel** content-width floor), and presents the cursor-relative
> `func_067DC8` chain as the "primary" layout path (the GAME.TXT event popups use the centered
> `@x/@y` path). **Do not build from this file.** The authoritative dialog layout math is
> `spec/ui/dialog_framework.md`; fonts/metrics are `spec/ui/fonts_and_colors.md` +
> `data_extracted/fonts/ff_metrics.json`; draw verbs are `spec/ui/render_primitives.md`.


Consolidated, byte-cited specification for the Python UI renderer, built
from THREE parallel disassembly audits run on 2026-05-24:

- `ADVISOR_REPORTS_AUDIT.md`     — F-key dispatcher + per-report paint chains
- `POPUP_TEMPLATE_AUDIT.md`      — dialog framework, 3 sprite channels, geometry
- `KING_AND_CINEMATIC_AUDIT.md`  — King speaker dispatcher, end-game cinematics, native sprite flow

Plus prior user-curated docs (UI_RENDER_MAP, UI_DIALOGS, DIALOG_GEOMETRY,
RENDERER_GEOMETRY, SCREEN_ASSET_REQUIREMENTS, SESSION_UI_CATALOG).

Where the audits CORRECTED prior assumptions, this doc cites both.

---

## 1. Font assignments (LOCKED — user-curated, audits agree)

| Font | Used for |
|------|----------|
| **FONTTINY** | Default for dialog body, popup body, inventory numbers, yield digits, small labels. Also what the `@SMALLFONT` directive binds to at runtime via `[0x89E]`. |
| **FONTSMAL** | On-disk orphan — present in COLONIZE/ but NEVER loaded by VICEROY.EXE. The `@SMALLFONT` directive does NOT bind to FONTSMAL; it resolves to FONTTINY via `[0x89E]` (see FONTTINY row). |
| **FONTINTR** | Title bars (top of every screen), sidebar labels, "GAME / VIEW / ORDERS / REPORTS / TRADE" menu, EXIT label. |
| **FONTKING** | King-audience speech-bubble text ONLY. |
| **FONT-NP** | Disabled / grayed menu items. |

Cited: `POPUP_TEMPLATE_AUDIT.md` §font, `UI_RENDER_MAP.md` ⚠ block, `UI_DIALOGS.md`.

Line heights: FONTTINY = 9 px (6 cell + 3 leading); FONTSMAL = 8 px;
FONTINTR = 10 px; FONTKING = 9 px.

---

## 2. Dialog framework — `func_06F0F4` (BYTE_VERIFIED)

### Root dispatcher
- **`func_06F0F4`** at file `0x06F0F4` (80 bytes) — parses 9 in-section directives.

### 9 in-section directives (from string table at `0x1F967..0x1F9B3`)

| Address | Directive | Effect |
|---------|-----------|--------|
| `0x1F967` | `OPTIONS` | List of selectable buttons. |
| `0x1F96F` | `PROMPT` | Body text. |
| `0x1F976` | `TEXT` | Body text (alt). |
| `0x1F97B` | `SMALLFONT` | Switch font to FONTSMAL. |
| `0x1F989` | `WIDTH` | char_width_cols (the X-side input to the rect formula). |
| `0x1F98F` | `LENGTH` | char_height_rows (Y-side). |
| `0x1F996` | `CHECKBOX` | Multi-select items. |
| `0x1F99F` | `DEFAULT` | Default-highlighted option index. |
| `0x1F9AA` | **`TEXTCOLR`** | Per-popup text color override (NEW — was missing from my renderer). |

### Geometry compute (per `DIALOG_GEOMETRY.md` and re-confirmed)
- 4-word rect at `DGROUP:[0x839E..0x83A4]`.
- 4 compute-wrappers — `func_067DC8`, `func_067E8C`, `func_075352` (endgame), `func_075FB6` (scoreboard).
- Primary formula (`func_067DC8` byte-cited):
  ```
  arg_x = [0xA5A4] + [0x1EA4] - 8     ; font_cell_w + char_w_cols - 8
  arg_y = [0xA5A6] + [0x1EA5] - 0x0F  ; font_cell_h + char_h_rows - 15
  arg3  = [0x174]  (cursor_x)
  arg4  = [0x176]  (cursor_y)
  ```
- Setter overlay `0x181F:0x254 → 0x0C36:0x000A`.
- Gate: only writes rect when `[0x186] >= 0x64`.

### Frame draw call site (NEW)
- `func_026374` at file `0x0263A9` pushes rect twice + 6 constants `(0x50, 0x50, 0x08, 0xC8, 0, 0)` then `LCALL 0x181F:0x510` → thunk `0x02E9:0x008C`.
- Frame is sprite-driven from **WOODFRAM.SS**, NOT hardcoded RGB.

### Frame & body composition (per `UI_DIALOGS.md` + audit)

| Layer | Asset | Notes |
|-------|-------|-------|
| 1. Body fill | **WOODPANL.PIK** tiled (or WOODPAN2.PIK for darker variant; selection logic TBD) | NOT solid color. |
| 2. Frame | **WOODFRAM.SS** (single 274×170 carved-wood sprite with rectangular hole) | Crop / 9-slice to popup rect. Replaces my 3-line color outline. |
| 3. Title strip | **NAMEPLAT.SS** (3 variants 18×14 / 16×14 / 18×14) | When popup has a title row. |
| 4. Body text | FONTTINY (or FONTSMAL if @SMALLFONT) in body color | Respect GAME.TXT line breaks unless overflow. |
| 5. Buttons | FONTSMAL (enabled), FONT-NP (disabled) | Left-aligned with small indent. |
| 6. Advisor sprite | per slot dispatch (§3) | Drawn LAST so sprite sits over frame. |

---

## 3. Advisor sprite — 3 channels, byte-direct mapping (BYTE_VERIFIED)

**MAJOR CORRECTION**: VICEROY does NOT use a static @KEY → sprite table. It uses
three independent global channels written by per-event game-logic code.

| Channel | Address | Range | Sprite | Wrapper |
|---------|---------|-------|--------|---------|
| Slot 1 (tribe/king) | `[0x1F5C]` | 0..7 → `INDnA0`, 8 → `KING`, 9 → `KING1` | tribe / king | `func_06F5B0` (tribe), `func_06F5DA` (king) |
| Slot 2 (advisor) | `[0x1F5E]` | 0..5 → `MSSn` | MSS portraits | `func_06F5F2` |
| Slot 3 (missionary) | `[0x1F60]` | 0..N → `MYRn` | MYR portraits | `func_06F61C` |
| Slot 4 | implicit | TBD | TBD | TBD |

All wrappers call shared core `func_06F7EF` (LJMP `0x181F:0x998`).

Reset after popup close: all three channels set to `0xFFFF` at `0x06EE6B`.

### Channel-1 value rule (CRITICAL)

Per `KING_AND_CINEMATIC_AUDIT.md`:
- `0..7` → IND sprite: tribe index 0..7 corresponds to NAMES.TXT @TRIBES order:
  - 0 = Inca → `IND0A0`
  - 1 = Aztec → `IND1A0`
  - 2 = Arawak → `IND2A0`
  - 3 = Iroquois → `IND3A0`
  - 4 = Cherokee → `IND4A0`
  - 5 = Apache → `IND5A0`
  - 6 = Sioux → `IND6A0`
  - 7 = Tupi → `IND7A0`
- `8` → `KING.SS.000` (1-frame standing King George, red coat, 79×161). **NOT KING1.**
- `9` → `KING1.SS.000` (alternate King pose, used by some KING* messages — TBD which).

**KEY CORRECTION** (resolves the contradiction):
- `POPUP_TEMPLATE_AUDIT.md` agent #1 said `[0x1f5c] = 8 → KING1`.
- `KING_AND_CINEMATIC_AUDIT.md` agent #3 said the audience sprite is `KING.SS` (not KING2 anger).
- Resolution: per agent #3's deeper trace, `func_06F5DA` writes `[0x1f5c] = 8` → sentinel meaning "use king path" → renders `KING.SS.000` (the standing single-frame audience portrait). Agent #1 likely conflated the value 8 with the KING1 sprite name because of the alphabetical order.

### KING2.SS is NOT anger states

Agent #3 finding: `KING2.SS` is 8 frames of an arm-raising animation, likely
the war-declaration cinematic. NOT used for audience.

### Native tribe context → channel-1 value

Per `func_0081C6(idx)`:
```
[0x8d52] = idx              ; tribe 0..7 → channel-1 value
[0x8d50] = idx + 4          ; tribe power_idx 4..11 (PowerRecord enum)
[0x8d4e] = NativeTribe ptr  ; tribe record pointer
```
Then `[0x1f5c] = [0x8d52]` (copy slot-1 ahead of dispatch).

So the renderer's `tribe_power_idx - 4` formula IS correct because PowerRecord
uses 4..11 for tribes but the IND sprite uses 0..7.

---

## 4. Per-event advisor channel writers (partial, byte-cited)

When a GAME.TXT event fires, an event handler writes channel(s) before
calling the dialog framework. Known event → channel writes:

| Event handler | Channel writes | Sprite shown |
|---------------|----------------|--------------|
| `func_034DD4` (price events PRICEUP/PRICEDOWN) | Slot 2 = 2/3/4 | MSS2/MSS3/MSS4 (varies by price direction) |
| `func_040C1E` (military) | Slot 2 = 5 | MSS5 |
| `func_032FE2` (colony event) | Slot 2 = 0 | MSS0 |
| `func_0350A0` (trade secondary) | Slot 2 = 2 | MSS2 |
| `func_06F5DA` (King audience) | Slot 1 = 8 | KING |
| `func_06F5B0` (tribe popup) | Slot 1 = tribe idx | IND0..7 |

Implication: my static `popup_layouts.json` per-@KEY advisor mapping is
a REASONABLE SIMPLIFICATION, but the actual game dispatches dynamically
based on event subtype. For high-fidelity, the renderer should accept a
`channel_overrides` dict at call time.

---

## 5. F-key advisor reports (BYTE_VERIFIED)

**MAJOR CORRECTION**: The F-key → report mapping is DIFFERENT from what I assumed.

Dispatcher: `func_0x2B743` at file `0x02BDEA..0x02BECF`.

| F-key | Report | Paint function (file offset) | LABELS.TXT @MISC title index |
|-------|--------|------------------------------|-----------------------------|
| F2 | Religious | `0x025F18` | 45 |
| F3 | **Continental Congress** | `0x025FD0` | 52 |
| F4 | **Labor** | `0x0269D8` | 64 |
| F5 | **Economic** | `0x027010` | 65 |
| F6 | **Colony** | `0x0277D8` | 66 |
| F7 | **Naval** | `0x027B0C` | 67 |
| F8 | **Foreign Affairs** | `0x027E48` | 108 |
| F9 | **Indian** | `0x025A0A` | 44 |
| F10 | **Score** (conditional `[0x5383] & 0x20`) | `0x026DA8` / `0x025992` | 129 |

Title-bar painter: `LCALL 0x4509:0x10F` takes a LABELS.TXT @MISC index.
PIK loader: `func_037340` (`0x037340`) does `sprintf("REPORT%d", n)`.

Foreign Affairs prereq guard: `func_039888` (`0x039888`) tests `[0x5382] & 1`,
shows `@FOREIGNNOTAVAIL` if no war-of-independence yet.

Foreign Affairs nested picker: `foradv_picker` cluster (existing
popup_layouts.json entry), bounds (60, 96, 180, 68), 4 nation options.

**Parallel dispatchers** also found (besides F-keys):
- Letter hotkeys A..I at file `0x023843..0x0238E7`.
- Top REPORTS menu click at file `0x0355AE..0x03561E`.

---

## 6. King audience (BYTE_VERIFIED)

**MAJOR CORRECTION**: `build/ui_extract/screens/king_screen.json` has
`paint_func: "0x249b1"` — that offset is in **COLONIZE.EXE** (not VICEROY)
and it's a **filename-builder**, NOT a screen painter.

Actual King speaker-portrait dispatcher: `func_06E3D0` in VICEROY
(`0x06E3D0..0x06E4CD`).

| Aspect | Value | Notes |
|--------|-------|-------|
| Screen background | LIVE MAP VIEW (popup overlays current map) | NOT a separate PIK |
| Speaker sprite | KING.SS.000 (1-frame, 79×161) | NOT KING2 anger |
| Speech bubble | popup at (95, 30, 220, 130) | per popup_layouts.json king_tax |
| King sprite position | (8, 30) size 79×161 | left side, popup right |
| Body font | FONTKING | per UI_RENDER_MAP.md user ruling |
| Body color | TBD (needs pixel sample) | |

`KINGLSS1.PIK` / `KINGLSS2.PIK` are END-GAME CINEMATIC backgrounds, NOT
audience backgrounds (also corrected).

**King anger byte** — project MEMORY.md says `0x53A7` but disasm shows
that's century-of-independence byte. Anger byte address is TBD.

---

## 7. End-game cinematics (BYTE_VERIFIED)

Endgame dispatcher: `func_075352` (BYTE_VERIFIED).

| `bp+6` | `bp+8` | Background | Foreground sprite | Meaning |
|--------|--------|------------|--------------------|---------|
| 1 | 1 | KINGLSS1.PIK | KING1 | mock / setup |
| 1 | ≠1 | KINGLSS1.PIK | KINGLOSE | **player won** |
| 2 | – | KINGLSS2.PIK | KINGWIN | **player lost** |

Declaration cinematic: `func_03DA2A` loads **DECOIND.PIK** (signing
celebration), reads player leader name from `DGROUP:0x540E + idx*0x34`.

---

## 8. Native chief popups (CORRECTED — was using MSS3, should be per-tribe)

All native popups in `popup_layouts.json` that currently have
`advisor_sprite.sheet = "MSS3"` should be CHANGED to per-tribe IND0..IND7
selection based on the active tribe context (`NativeSettlement+0x02`).

Catalog entries to fix:
- `raid_wreaks_havoc` (RAIDWREAK) — currently MSS3, should be IND<tribe>
- `unrest_immigration` (UNREST) — depends on event source; if native unrest, use IND

Selection formula (CORRECT): given `tribe_power_idx` from
`NativeSettlement[active]+0x02` (range 4..11):
```
sprite_sheet = f"IND{tribe_power_idx - 4}A0"
```

For events that don't pass a tribe context (e.g. UNREST about immigration
from a European country, not a native event), use a generic European
advisor (Continental MSS5 or similar — TBD).

---

## 9. Per-popup ASSET sources (final list)

| Asset | Source path | Use |
|-------|------------|-----|
| Body fill | `assets/backgrounds/WOODPANL/WOODPANL.PIK.png` (320×200) | tile-crop to popup rect |
| Frame | `assets/sprites/WOODFRAM/WOODFRAM.SS.000.png` (274×170) | 9-slice or center-crop |
| Title strip | `assets/sprites/NAMEPLAT/NAMEPLAT.SS.000.png` (18×14), `.001.png` (16×14), `.002.png` (18×14) | choose width per title length |
| Default tile font | `FONTTINY/FONTTINY.FF.<ASCII>.png` | popup body |
| SMALLFONT-flag font | `FONTSMAL/FONTSMAL.FF.<ASCII>.png` | popup body when @SMALLFONT |
| King speech-bubble font | `FONTKING/FONTKING.FF.<ASCII>.png` | King audience only |
| Title-bar font | `FONTINTR/FONTINTR.FF.<ASCII>.png` | screen titles (gameplay/colony/europe/CC/king/reports) |

---

## 10. Renderer implementation plan (apply in order)

1. **[catalog]** Add `king_tax` entry to `popup_layouts.json` for KINGTAX (DONE).
2. **[catalog]** Switch native popups (RAIDWREAK, etc.) from MSS3 → per-tribe formula.
3. **[catalog]** Add `combine_options_from: "TAXOPTIONS"` for KINGTAX/KINGRAISE family (KINGTAX done).
4. **[code]** Replace solid-dark body fill with WOODPANL.PIK crop.
5. **[code]** Replace 3-line color frame with WOODFRAM.SS center-crop or 9-slice.
6. **[code]** Add optional NAMEPLAT.SS title strip.
7. **[code]** Apply per-tribe IND<n>A0 formula for native popups (DONE; verify formula matches §3).
8. **[code]** Use KING.SS.000 (1-frame) for KING audience popups (DONE in catalog).
9. **[code]** Honor `TEXTCOLR` directive per popup.
10. **[code]** Recompute popup heights from content (DONE).

---

## 11. Open / TBD

- King-anger byte address — disasm contradicts MEMORY.md; needs re-audit.
- WOODPANL vs WOODPAN2 per-popup selection logic.
- Default option highlight color (palette index TBD).
- KING2 anger-vs-animation usage clarification.
- Per-row (x, y) coordinates within each advisor report body — needs paint-function-level trace.
- F4 nested nation picker function offset.
- Foreign Affairs PICKER function (only guard found, not the picker itself).
- Slot-4 (the 4th implicit speaker slot) trigger function and content.

---

## 12. Cross-reference

Read these for the byte-cited derivations:

- `ADVISOR_REPORTS_AUDIT.md` — §5 source
- `POPUP_TEMPLATE_AUDIT.md` — §2, §3, §4 source
- `KING_AND_CINEMATIC_AUDIT.md` — §6, §7, §8 source
- `build/ui_extract/advisor_reports.json` — F-key → paint chain JSON
- `build/ui_extract/popup_template.json` — popup geometry + channel JSON
- `build/ui_extract/king_and_cinematic.json` — King + endgame JSON
