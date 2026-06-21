# Europe Screen (London / home trade port)

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Overall confidence:** main-panel geometry **B** (literal coords in the decompiled
`europe_screen_render` + corroborating hit-test rects — supersedes the old luma-only **A**);
load-bearing state fields **B** (raw-EXE-verified); two extra draw passes + transaction
sub-panel **TBD** (genuinely overlay-resident). · **Canonical primary:**
`ghidra_export/VICEROY_decompiled.named.c` (`europe_screen_render` line 21920 + helpers),
`raw/COLONIZE/VICEROY.EXE`, `docs/RENDERER_GEOMETRY.md`, `docs/SESSION_UI_CATALOG.md` §4.

> **Correction (2026-06-21):** the prior caveat "Europe renderer per-element code is
> overlay-resident / TBD" was **stale**. `europe_screen_render` and its four helpers
> (`europe_draw_stockpile`/`_title`/`_dock_ships`/`_recruit_pool`) are **fully decompiled
> with literal coordinates**; the panel rects below are byte-grounded, not luma-guessed, and
> the deprecated v2 sub-coords (e.g. "RECRUIT y=144") are **refuted** (real RECRUIT y≈89).

## 1. Purpose
The home-nation harbor where the player sells/buys cargo, recruits/purchases/trains units,
and dispatches ships. Docked panels track ship traffic (Expected Soon / Bound For \<colony\>
/ Loading). Bottom strip shows the 16 commodities with price and a boycott red-X overlay.
**A** (`SESSION_UI_CATALOG.md` §4). Entered via `europe_open` (line 21950): loads the harbor
PIK by numeric key `0x0FBA` and enters screen-view id `0x2B`. **B**

## 2. State & data layout
All offsets raw-verified against `raw/COLONIZE/VICEROY.EXE` (capstone 16-bit) unless noted.

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| PowerRecord `+0x2A` | u32 | treasury gold (dword) | B | `sub [bx+0x2a],ax; sbb [bx+0x2c],dx` @0x3340D |
| `DG16(0x2F5E)` | u16 | displayed gold mirror ("`$%d`") | B | render line 21856 |
| PowerRecord `+0x01` | u8 | tax rate 0..100 | B | title line 21870 |
| PowerRecord `+0x20` | u16 | **boycott bitmask** (`1<<good`), one bit/good | B | `and ax,[bx+0x20]` @0x30B47; clear `and [bx+0x20],ax` @0x33423 — **confirms the long-open candidate** |
| PowerRecord `+0x22` | u32 | cumulative spent | B | `add [bx+0x22]; adc [bx+0x24]` @0x33413 |
| `+0x4C + good` | u8 | **price_level[16]** (running price index) | B | `mov [bx+si+0x4c],al` @0x306F3 (corrects "market sensitivity") |
| `+0x5C + good·2` | i16 | **vol_accum[16]** (traffic-volume accumulator) | B | `add [bx+si+0x5c],ax` @0x30707 |
| `DG16(0x9E12)` | u16 | selected good / power idx | B | lines 21818, 21867 |
| `DG16(0x538A)` | u16 | game year | B | line 21868 |

> **Ruling:** byte-verified `market.h` (price_level `+0x4C` / vol_accum `+0x5C` / boycott
> `+0x20`) **wins** over the RECONSTRUCTED `power.h` field names. There is no separate
> contiguous market_pool/eu_supply/base_value block at these offsets (see RULINGS 2026-06-21).

## 3. Formulas & rules
- **Title bar** (`europe_draw_title`, line 21874): `snprintf("%s Port  %d  Tax %d%%",
  nations[power], year, tax)`, centered, y=4, green `ui_color_for(0x52,0x8A,0x31)`. So the
  header is **"\<Nation\> Port  \<year\>  Tax \<N\>%"** — the old "Selling X at N Gold" string
  is `@CMESSAGE`-driven and belongs to the transaction sub-panel, not this title. **B**
  `nations[4] = {English, French, Spanish, Dutch}`.
- **Stockpile price per cell**: `market_bid_price(i)` formatted `"%d"` (line 21847); the
  bid/ask spread (`ask = bid + @CARGO burden+1`) is in `market_bid_price`/`market_ask_price`
  whose bodies are overlay-resident — **TBD**.
- **Recruit-pool cell height**: `(0x20-4)/3 = 9`; cells stepped `cy += 9 + 2`. **B**

## 4. UI layout — "what is drawn where"
Native 320×200. Coordinates are **literal immediates** in the decompiled render helpers
(tier **B**), corroborated by the click hit-test rects in `func_03200A` (line 22202).
Draw order (`europe_screen_render`, line 21920): clear → clip → stockpile → title → dock
ships → `ov_draw_extra_a/b` (TBD) → recruit pool → outer box frame.

| Element | Rect (x,y,w,h) | Sprite / text | Tier | Line |
|---------|----------------|---------------|------|------|
| Full clear | (0, 8, 320, 192) | — | B | 21923 |
| Stockpile strip bg | (0, **179**, 320, 21) | box fill | B | 21838 |
| Stockpile cells (16) | x=1, stride **19**, icon y=**181**, price y=**194** | ICONS.SS `sid = good+0x16` (22..37), centered `x−(w/2)+9` | B | 21840–21851 |
| Stockpile gold | x=**306**, y=**179** | `"$%d"` of `DG16(0x2F5E)`, color 0x0F | B | 21856 |
| Title header | centered, y=**4** | "\<Nation\> Port  \<year\>  Tax \<N\>%", green | B | 21877 |
| Dock water box A | (**143**, 118, 81, 60) | box fill | B | 21886 |
| Dock water box B | (143, 81, 120, 69) | box fill | B | 21888 |
| Dock ships (6) | x0=**143**, stride **20**, y=**122**, centered −(w/2)+10 | ICONS.SS sprite **0x7B** (123) | B | 21890 |
| Recruit-pool box | (**281**, **89**, **37**, **32**), outline 0x39 | box fill | B | 21905 |
| RECRUIT/PURCHASE/TRAIN | inside box: y≈89 / 100 / 111, text centered in 37 px, color 0x0F | text (matches `@EUROLABEL`) | B | 21901–21915 |

**Click hit-test rects** (`func_03200A`, line 22202) — corroborate the draw rects and name
the dock panels: stockpile-gold (306,179,15,21)→0xB; recruit pool (281,89,37,32)→5;
stockpile row (0,179,305,21)→0; dock A (143,118,81,60)→1; **"Bound For"** (72,118,70,51)→2;
**"Loading"** (1,118,70,51)→3; **"Expected"** (224,120,96,59)→4. **B**

## 5. Assets & text
- **Background:** harbor PIK loaded by key `0x0FBA` (`europe_open`, line 21950); palette from
  the PIK. **B**
- **Buttons** (`LABELS_sections.json` `@EUROLABEL` = "RECRUIT\nPURCHASE\nTRAIN\nx";
  EXE string @0x1FC74): RECRUIT/PURCHASE/TRAIN. **B**
- **Trade text** (`@CMESSAGE`): "sold for", "bought for", "Selling", "% Tax:", ". Net:",
  ". Price:" — drawn by the transaction sub-panel (`ov_draw_extra_*`). **B (keys) / TBD (draw)**
- **Dock panel labels** (`@MISC`): "Expected Soon", "Bound For", "Loading". **B**
- 16-commodity order from NAMES `@CARGO` (verified). **B**

## 6. Evidence
- `ghidra_export/VICEROY_decompiled.named.c` lines 21815–21961, 22202–22213 — full bodies of
  `europe_screen_render`, the four draw helpers, `europe_open`, `europe_ship_click`, hit-test
  `func_03200A`. **B**
- `raw/COLONIZE/VICEROY.EXE` capstone re-verify: gold u32 `+0x2A` @0x3340D; boycott word
  `+0x20` @0x30B47/0x33423; price_level u8 `+0x4C` @0x306F3; vol_accum i16 `+0x5C` @0x30707;
  spent `+0x22` @0x33413. **B**
- `docs/RENDERER_GEOMETRY.md` (luma bands, now superseded by literal coords). **A**
- `data_extracted/text/LABELS_sections.json` `@EUROLABEL`/`@CMESSAGE`/`@MISC`. **B**

## 7. Open questions (TBD)
1. `ov_draw_extra_a/b` (lines 21815–21816) — the **trade-transaction parchment panel** (the
   `@CMESSAGE` "Selling/Sold…Net" text + the boycott red-X overlay) and the Exit "E" button.
   Declared extern → overlay-resident; bodies not in the export. **TBD** (entry: overlay
   `0x181F` call from `europe_screen_render`).
2. Boycott **red-X sprite index** in ICONS.SS — not in any decompiled body; the "~slot 043"
   is observation-only. **TBD**.
3. `market_bid_price`/`market_ask_price` → displayed coin value, and the `ask = bid +
   (@CARGO burden+1)` spread — overlay-resident. **TBD**.
