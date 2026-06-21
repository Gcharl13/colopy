# Europe Screen (London / home trade port)

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Overall confidence:** main-panel geometry **B** (literal coords in the decompiled
`europe_screen_render` + corroborating hit-test rects); load-bearing state fields **B**
(raw-EXE-verified); the transaction sub-panel + market price formula now **B** (traced
2026-06-21, §3/§7). **No runtime residual** — the boycott overlay's sprite is indexed by the
good (static, from sheet `[0x2DA8]`); *whether* it shows is the good's market/boycott state
(game data). · **Canonical primary:**
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
- **Market price — B (traced 2026-06-21, `0x181F:0xAEC → bid_get @0x0B2A2`):** per-good market
  record stride `0x1C`, base DGROUP `0x3150`; `level = [good·0x1C + 0x3150]`; **bid = nibble of
  `[good·0x1C + 0x3151 + level/2]`** (`sar 4` odd level / `and 0xF` even). **`ask = bid +
  @CARGO.Burden + 1`** (NAMES.TXT `@CARGO` "Burden" legend: *"0 means ask is 1 higher than
  bid"*). Sell handler `@0x32914` (price helper `@0x3245C`); cross-ref `systems/market.md`. **B**
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

## 7. Open questions — RESOLVED 2026-06-21
1. ✅ **`ov_draw_extra_a/b`** resolved (`europe_screen_render` `@file 0x31E4C`; extra_a `call
   0x36863 → 0x319A6`, worker `0x31A32`; extra_b `0x31AFA`). The **trade-transaction parchment
   panel** is two sub-fns: top strip `@0x317CC` box-fill `(51,70,118,72)` + text rows `(x=0x45,
   y=0x78)` drawing the power/good names; bottom strip `@0x318D2` box `(51,1,118,1)` + the
   numeric value `[0x2DCC]`. Text = `@CMESSAGE` tokens (Buying/Selling/at/Price/%Tax/Net), data
   in LABELS.TXT. **B.**
2. ✅ **Boycott marker — mechanism B; the "red-X ~slot 043" guess is REFUTED.** In extra_a
   `@0x31A73..0x31AB4` each good blits its commodity icon (`0x181F:0x2BC`) at (100,16), then a
   **state-gated overlay** (`lcall 0x181F:0x254 → 0x0E76A`) fires when the good-record state
   byte `[good·0x1C + 0x3146] ∈ 0x0D..0x12` **and** `[good·0x1C + 0x3150] ≠ 0`, drawn with the
   **good's own index** into sheet `[0x2DA8]` (a static per-good sprite, not a fixed red-X
   slot). So the frame is **static** (function of the good); *whether* it shows is the good's
   market/boycott state (game data). **B.**
3. ✅ **Market bid/ask** — fully byte-traced (see §3). **B.**

*No runtime residual* — every Europe element (geometry, sprites, price formula, boycott marker)
is static; only the live values (gold, prices, which goods are boycotted) are game state.
