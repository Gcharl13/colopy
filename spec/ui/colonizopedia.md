# Colonizopedia (in-game encyclopedia)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Renderer topology + per-page layouts are **B** (byte-cited against
> `raw/COLONIZE/VICEROY.EXE` via `code/VICEROY/disasm_overlay_reseg/page_16.asm`;
> decode record: `docs/UI_PHASE1_ATTRIBUTION.md` §3, all load-bearing cites
> independently re-resolved 2026-07-30). Entry TEXT is data (PEDIA.TXT), names are
> NAMES.TXT — both committed under `data_extracted/text/`. Sections marked
> *(pending)* are being decoded; treat as TBD until filled.

**Canonical primary:** `page_16.asm` (complete listing for all seven entry pages +
browser; the per-function `code/VICEROY/disasm/func_*_unknown.asm` files are
truncated — do not cite them), `data_extracted/thunk_targets.json`,
`data_extracted/text/{PEDIA,NAMES,LABELS,MENU}_sections.json`.
**Ruling:** `notes/rulings/RULINGS.md` 2026-07-30 — `func_069D8C` is the pedia
TERRAIN page, in-game (refutes the old "map-editor palette" claim; CLAUDE.md hard
rule 7 amendment pending user sign-off).

## 1. Purpose
The in-game encyclopedia ("ENCYCLOPEDIA OF COLONIZATION"). 166 content surfaces:
seven category index pages + per-entry article pages (Cargo 16, Unit, Terrain,
Colonist Skill 28, Colony Building 42, Founding Father 25, Game Concept 12).
Reached two ways (both B):
- **Menu**: menu-command executor `func_0235D6` → browser `func_06B398`
  (`0x191f:0x372` @0x02390B).
- **Context help**: dispatcher `func_02BC72` (page 0x02), switch on selection
  type `[0x32E]` @0x02BD08 → 0 = tile terrain → TERRAIN page @0x02BD64; 1 = unit
  profession → JOB @0x02BD90; 2/3 = unit type → UNIT @0x02BDCE; 4 = cargo
  (`[0x33A]`) → CARGO @0x02BDDC. Plus per-screen help sites (colony/europe
  helpers) listed per page below.

Renderer roster (overlay page 0x16, one function per category, `@PEDIA` line n =
category label):

| n | category (`@PEDIA` line) | function | key | entries |
|---|---|---|---|---|
| 0 | Cargo Type | `func_0694AE` | `"CARGO"` | 0..15 |
| 1 | Unit Type | `func_0696C6` | `"UNIT"` | *(pending)* |
| 2 | Terrain Type | `func_069D8C` | `"TERRAIN"` | *(pending)* |
| 3 | Colonist Skill | `func_06A700` | `"JOB"` | 0..27 |
| 4 | Colony Building | `func_06AA88` | `"BUILDING"` | 0..41 |
| 5 | Founding Father | `func_06AE08` | `"FATHER"` | 0..24 |
| 6 | Game Concept | `func_06AF1C` | `"MISC"` | 0..11 |

Key strings live at DGROUP 0x1ECD..0x1F05 (byte-read at file 0x1F86D–0x1F8A5).
Article body = PEDIA.TXT section `<KEY><idx>` rendered by the standard text-window
engine (`0x181f:0x998` = `func_06F51A` = menu_lookup_run).

## 2. Shared page skeleton (B — identical opcode sequence in all seven)
Native 320×200, full-screen modal.

| step | element | placement / mechanism | cite |
|---|---|---|---|
| 1 | Background | WOODPANL.PIK via `func_069304`: `0x191f:0x87A("WOODPANL"@DG 0x1EC4, ctx [0x2DA8], 0)`; on nonzero → fill color 8 (`0x484`) + full-screen rect op `0x444` (320×200) | @0x069319/@0x069337/@0x069365 |
| 2 | Screen title | `[0x2E92]` = **"ENCYCLOPEDIA OF COLONIZATION"** (LABELS `@MISC` line 108; runtime label-ptr array base DG 0x2DBA, slot = line), centered `0x100` (x0=0, w=320, **y=5**, color `[0x831]`) | e.g. @0x0694C4–@0x0694D2 |
| 3 | Entry header | `<entry name>` + separator + `<category label>` (from `func_06927C`: `0x181f:0x422("PEDIA","PEDIA", n)` = `@PEDIA` line n), centered `0x100` at **y = font_height+7** (font far ptr `[0x89E]`) | @0x06927F–@0x069295 |
| 4 | Body seed | y = header_y + font_height + 0xE (JOB page: +font_height+3); **x = 10** | per-page cites |
| 5 | Article | key = `<KEY><idx>` (strcpy + `0x182` append-number); `[0x1F5A]` = text-window y-cursor (word global, init 0xFFFF; NOT a string); `0x181f:0x438` = `func_06C23C` sets text-substitution slot 0 = entry name; `func_06929C` sets `[0x1F56]\|=0x20` and runs menu_lookup_run("PEDIA", key) | @0x06C23C/@0x0692D2/@0x0692EE |
| 6 | Terminate | present `0xE2` (0, 0x140, 0xC8) + `0x3C0` MODAL-WAIT, RETF | e.g. @0x0696B8–@0x0696C4 |

Sprite convention: `0x181f:0x254` AX=frame, DX=x, stacked y + far sheet handle,
BX=&ctx 0x2DA8. Sheets: **ICONS.SS = `[0x83E]`** (cargo icons frames 0x17+i;
profession figures 0x52+job), **BUILDING.SS = `[0x842]`** (building pictures
frame rec+1).

## 3. Cargo Type page (`func_0694AE`, idx 0..15) — B
- Entry name: cargo-name ptr table DG 0x97C0 (runtime-filled from NAMES `@CARGO`)
  @0x0694FE.
- Production-chain rows (switch @0x069567–@0x069633; row renderer `func_06936C`;
  **row pitch y+=0x14**):
  Food → (Farmer row)+(Fish row: icon 0x3A, job 8 Fisherman, "Fish"=`[0x2F1C]`);
  Sugar/Tobacco/Cotton/Furs → raw+manufactured pairs (i,i)+(i+8,i+8);
  Lumber → (5,5)+(Hammers 0x10, Carpenter 0xD); Ore → 3 rows Ore→Tools→Muskets;
  Silver/Horses/Trade Goods → single row.
- Row layout (`func_06936C`): job figure ICONS frame job+0x52 at (10, y−2),
  x+=0xE; cargo icon frame cargo+0x17 (0x10→0x37, <0→0x3A) at x, x+=0x10, then
  **6 more copies at x+=4** (7-icon stack), x+=0xC; text `"<Cargo> With
  <Expert>"` (`[0x2F1E]`="With") at (x, y+4) color `[0x830]`
  @0x0693B1–@0x0694A7.
- Context-help callers: @0x02BDDC (`[0x32E]`=4), @0x02AFBE, @0x02BABD, @0x0336AB,
  @0x033B4F, @0x035560.

## 4. Unit Type page (`func_0696C6`, idx 0..0x16) — B
Signature: `far func(unit_type)`, one word param. Decoded 2026-07-30; 12
load-bearing cites + the separator literal pool + the type→job byte table
re-verified against the EXE.

- **Temp preview unit**: creates a throwaway UnitRecord via `0x1a1f:0x1CA` =
  `func_04007E` (type 0, x=y=−6, nation `[0x5398]`) @0x0696CB–@0x0696DA; sets
  orders=0, type=param, profession=0x13 @0x0696E7–@0x0696F6; destroyed at exit
  (`0x181f:0x808` = `func_006E94` on `[0x539C]−1`) @0x069D7B–@0x069D85.
- **Figures** drawn by `0x181f:0x2BC` = `func_00386A` (per-unit info panel) from
  the temp record — args (width=0x64, 0, y), AX=unit idx, DX=0, BX=x.
  **Horizontal pitch 0x12 (18px)**; x home = 8.
  - Type 0 (Colonists) = full profession gallery: prof 0x1C first, then
    0x19/0x1A/0x1B, then profs 0..0x16 skipping 0x12 (Teacher) and 0x13
    (Colonist); **17 figures per row** (`cmp [bp-2],0x11` @0x069864), wrap
    y+=0x14 — 25 figures total @0x0697C7–@0x069879.
  - Types 1–5: two figures — prof 0x13 at x=8, then expert job from byte table
    DG 0x30E (file 0x1DCAE = `13 15 14 18 17 16`: 1→0x15, 2→0x14, 3→0x18,
    4→0x17, 5→0x16; job 0x17 renders as prof 0x15 @0x0698DB) at x=0x1A
    @0x06987C–@0x0698FE.
  - Type 0xB (Artillery): second figure with UnitRecord flags `+0x04 |= 0x80`
    set @0x069923 then cleared @0x069942 — the "Damaged" state pair.
- **Name line** at (post-figures x, fig_y+6), color `[0x830]`: UnitName (stride
  0xE table DG 0x5230, +0) plus — types 1–5: `" (and <ExpertPlural>)"`
  (`[0x2E8E]`=@MISC 106 "and"; plural = JOB table 0x8EA2 +2); type 0xB:
  `" (and Damaged <UnitName>"` — **the closing ")" is missing in this branch
  (original bug, byte fact @0x0699E6–@0x069A62)**. Then y += 0x18.
- **Stat line** at (8, y), color `[0x830]`, from table 0x5230 (+5=combat,
  +6=attack, +4=moves×3, +7=cargo holds):
  `"Combat: N"` (`[0x2F20]`=@MISC 179) — type 0xB adds
  `"(Attack: +2 Damaged: -2)"` (delta = +6−+5 @0x069B39; literal 2 @0x069B89);
  types 1/4 add `"(Veteran: N)"` with attack×1.5 (`×3>>1` @0x069BEC);
  all: `"Moves: N"` = +4 **div 3** (`cl=3` @0x069C46); if +7≠0:
  `"(Cargo Holds: N)"` @0x069C86–@0x069CF0.
- **Article**: key `"UNIT"+idx` (push 0x1ED3 @0x069D0C) → PEDIA `@UNIT0..23`;
  `[0x1F5A]` = stat_y + 0xC @0x069D2B; modal-wait @0x069D76.
- **Separator helpers resolved (B)**: the `0x181f` string-builder wrappers
  strcat DGROUP literals (pool byte-read at file 0x1D9F0+): `0x178`=" " (DG
  0x50), `0x1BE`=": " (0x55), `0x11E`="(" (0x5E), `0x128`=")" (0x60),
  `0x146`="+" (0x66), `0x15A`="−" (0x68), `0x196`=" "×N, via `0xd1d:0x7a4`.
- Callers: browser @0x06B5FE; context help @0x02BDCE (`[0x32E]`=2/3);
  unit-list help sites @0x02AECB, @0x02B355, @0x02B701 (buildable-unit items),
  @0x03342C tail @0x033570, @0x0339F8, and three sites in the un-resegmented
  page-04 tail (@0x034305, @0x035263, @0x03559C — containing functions MEDIUM).

## 5. Terrain Type page (`func_069D8C`) — *(pending decode)*

## 6. Colonist Skill page (`func_06A700`, idx 0..27) — B
- Job name: DG 0x8EA2 stride-8 table +0 (NAMES `@JOB`; +2 = expert-plural)
  @0x06A74F.
- Workplace: `0x181f:0xB00` = `func_008D9C`, signed-byte table DG 0x2F4 (file
  0x1DC94, 19 entries; jobs 0–8 → −1 outdoor); no building → y+=0xB.
- Job figure ICONS frame idx+0x52 (idx 0x1B→0x43) at (10, y + bldg_h/2−7);
  expert name at (+0xE, fig_y+6); x+=0x18 @0x06A7F5–@0x06A86C.
- Building upgrade-chain loop: BUILDING frame b+1, x += frame_width+3, name from
  DG 0x8F82 stride-12; next b = byte 0x8F82[b]+4 while ≥0 @0x06A89C–@0x06A947.
- Product strip (idx<0x13): cargo icon idx+0x17 (specials 8→0x3A, 0xD→0x37,
  0x10→0x39, 0x11→0x3F), x+=0x10; name `[0x97C0]` with id remap 0xD→0x10,
  0x10→0x11, 0x11→0x12; idx 8 → "Fish" @0x06A95C–@0x06AA11.
- Context-help callers: @0x02BD90 (`[0x32E]`=1, profession field +0x40, remap
  0x1C→0x13), @0x029721, @0x029D15, @0x02A05B, @0x034984, @0x03500C.

## 7. Colony Building page (`func_06AA88`, idx 0..41) — B
- Name: DG 0x8F82 stride-12 +0 (NAMES `@BUILDING`) @0x06AAD3.
- Big picture: BUILDING frame rec+1 at (10, y), w/h from sheet header; idx
  0x10/0x1F → no picture (h=0x18, w=0); idx 0x11 → frame 0x2F (same override as
  colony screen) @0x06AB43–@0x06ABA1.
- Header strip: name at (10+w+3, h/2−7+y+6) color `[0x831]`; worker job via
  `0x181f:0xACE` = `func_009786` byte table DG 0x2CA (42 entries building→job);
  skip if job 0x12 (Teacher) / 0x15; else figure + expert name + product icon
  and name @0x06ABA6–@0x06AD1C.
- y += h+0xC; **Prerequisite line** if byte 0x8F82[idx]+3 ≥ 0:
  `[0x2F32]`="Prerequisite" + separator + prerequisite name at (10, y) color
  `[0x830]`; y+=0x14 @0x06AD3C–@0x06AD9F.
- Context-help callers: @0x02A076, @0x02B6E4.

## 8. Founding Father page (`func_06AE08`, idx 0..24) — B
Text-only. Name from DG 0x9652 stride-6 +0 @0x06AE53; y += font_height+0xE;
article `@FATHERn` (sections exist for 0..24). Extra callers: **FF-acquire
dispatch `func_03BC42` @0x03BD26** (shown when a Father joins the Congress) and
Congress selection screen @0x03C24E.

## 9. Game Concept page (`func_06AF1C`, idx 0..11) — B
Text-only. Name from DG 0x935C stride-2 ptr table @0x06AF67 (runtime-filled from
PEDIA `@MISCELLANEOUS`'s 12 concept names — loader site TBD). Article key
`"MISCn"`. Only caller = browser. **Open item:** extracted PEDIA.TXT has no
`@MISC0..11` sections — resolution of `"MISC5"` by menu_lookup_run is TBD
(possibly header-only render).

## 10. Browser + index pager (`func_06B398` / `func_06B02A`) — *(pending decode)*
Known (B): browser uses the same `[0x2E92]` title @0x06B3FA; dispatches to all
seven pages via near-stub block @0x06B660–@0x06B6BF in `@PEDIA` order; pager
`func_06B02A` draws `[0x2E94]`="(More)" @0x06B1A3 and `[0x2E96]`="(Exit)"
@0x06B1D2 footers.

## 11. Open items (exact trace sites)
1. `[0x2E92..]` label-array loader — find the loop filling DG 0x2DBA+2n from
   LABELS.TXT.
2. `LCALL 0xd1d:0x7e4/0x7a4` strcpy/strcat — resolve the 0xd1d segment fixup.
3. Substitution-slot store body near 0x06F7EA.
4. `"MISCn"` section resolution (§9).
5. ~~Separator-glyph helpers~~ **RESOLVED 2026-07-30** (§4): strcat wrappers of
   the DGROUP literal pool at 0x50.. (" ", ": ", "(", ")", "+", "−").
6. Internal y/baseline of centered-title verb `0x100` (overlay @0x0606C0).
7. `func_00386A` (0x2BC per-unit info panel) internals — figure sheet + frame
   math, effect of flags bit 0x80 "Damaged", meaning of prof 0x1C figure
   (needs full disasm of 0x00386A..~0x003E4x; per-func asm truncated).
8. NAMES `@UNIT` → DG 0x5230 loader (confirm +4 stored as moves×3); same
   family as the unlocated 0x8EA2 `@JOB` loader.
