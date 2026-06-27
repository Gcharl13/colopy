# Europe Screen (home trade port / harbor)

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers:
> **B** = byte-cited (a `func_XXXXXX @0xNNNNN` immediate or a verified text key),
> **A** = overlay/pixel-verified geometry (not byte-cited),
> **R** = single-frame approximate / low-trust,
> **TBD** = unknown, no surviving evidence.

**Overall confidence:** the composer draw ORDER + every panel rect is now
**byte-cited B** from the overlay-resolved draw-list (`func_031E4C @0x031E4C`,
sub-renderers `func_0310B4`/`func_030F76`/`func_0314DC`/`func_031298`/`func_031366`/
`func_031DC8`); load-bearing state fields **B** (raw-EXE-verified); the market
bid/ask formula **B**; the dock-ship slot geometry **B** (now refined from the
old "stride 20 y=122" R guess to the byte-exact `x=147+slot·12, y=165` of
`func_0314AE`). Two paint origins — **RESOLVED-mechanism 2026-06-27** (UI closeout): the **banner** is `func_030F76`
(composer step 4 @0x031E6B) via painter **`0x181F:0xB0` (file 0x275C)** reading the text-box rect from
BSS `[0x2cc6..0x2ccc]` set per-screen by **`set_text_box` @0x2740** (`w,h,x,y`) — so the banner origin
= that screen's `set_text_box` args; the **Exit `E`** glyph is framework chrome from the screen-view
runner (`0x181F:0x772 → file 0x077D5E`, EXIT.SS), not a europe-page draw. Tracker row 3 = **DONE**;
the residual is the per-screen `set_text_box` arg trace + live heap-string slot contents. **No runtime
residual** — every element is static
geometry; only the live values (gold, prices, which goods are boycotted, ships in
port) are game state.

· **Canonical primary:** `viceroy_source/docs/drawlist/EUROPE_COLONY.md` PART 1
(composer + 6 sub-renderers, byte-read), `viceroy_source/docs/SCREEN_LAYOUTS.md`
§2 (the [V]-cited Europe table), `raw/COLONIZE/VICEROY.EXE` (capstone re-verify),
`data_extracted/text/{LABELS,NAMES}_sections.json` (text keys).

> **Correction (2026-06-22):** the dock-ship geometry in the prior revision
> ("x0=143, stride 20, y=122") was an **R single-frame guess**; the byte-exact
> geometry is `func_0314AE @0x0314BD..0x0314D6`: **x = slot·12 + 0x93 (147)**,
> **y = 0xA5 (165)**, **10×12**, sprite **ICONS 0x7B**. Also corrected: the dock
> band captions ("Expected Soon / Bound For / Loading") come from **`@MISC`**, not
> `@EUROLABEL` (grep-verified below); `@EUROLABEL` holds only RECRUIT/PURCHASE/TRAIN.

## 0. AS-BUILT RENDER STATUS (2026-06-27)

A standalone composite of this screen was built (the browser lab was removed this date, so the
renderer is now `tools/render_europe.py` — a small Python compositor; reference output committed at
`docs/screens/europe_render.png`). It composites the byte-cited static layer + the structural
overlays and is matched against the live capture `docs/screens/10_europe_screen.png` (London,
Spring 1500, Gold 1000e). **The renderer depends on the regenerable, git-ignored
`viceroy_cpp/build/bundle/` assets** (rebuild via `tools/extract_visuals.py`); the committed record
is this section + the reference PNG.

### 0.1 What is rendered, and at what confidence
| Element | Placement used | Source / tier |
|---------|----------------|---------------|
| Harbor background | `EUROPE.png` (320×200, blue sky — palette correct, NOT the stride-4 bug) | bundle background, **B** scene |
| Wood menu bar | WOODTILE tiled **y0..6 (7px only)** + black separator at **y7** | measured from capture, **A** |
| Title (green) | FONTTINY `(71,1)` "London, England.  Spring, 1500.  Tax: 0%  Gold: 1000e" | string = this capture's live state; banner mechanism `func_030F76` is **B**, pixel origin **A** |
| Market bar | **NO fill box** — 16 ICONS on the harbor bg, centered in 19px cells (`x=1+i·19`, icon y=180) | **B** geometry (`func_0310B4`); icon = bundle frame **`0x16+good`** = EXE `0x17+good` (ssdec off-by-one) |
| Bid/ask prices | **BLACK** FONTTINY, cell-centered, **y=194** | **B** y/centering; price values read from capture |
| RECRUIT/PURCHASE/TRAIN | beveled buttons, panel ≈ `(280,88)` rows at pitch 11; **INVERTED bevel** (shadow TL, highlight BR); white text + **yellow accelerator first letter** | panel rect (281,89,37,32) **B**; bevel/colors **A** (measured) |
| Dock captions (green) | **y=120**: "Expected Soon" `(16,120)`; "Bound For"`(87,120)`/"New England"`(87,127)`; "Loading:"`(150,120)`/"Caravel"`(186,120)` | strings = `@MISC` keys (**B**); x/y measured from capture (**A**) |
| Exit | white "Exit" `(306,179)` + red "E" `(308,187)` | measured from capture (**A**); matches spec `x=306,y=179` |

### 0.2 NOT rendered (honest gaps — need a matched RAM snapshot, which does NOT exist for Europe)
- The **dynamic harbor contents**: the Caravel (Loading) and the colonists in their green
  selection boxes on the piers, and the pier **crates**. These are live game state (ships in port,
  units, cargo). Unlike the colony screen, **no matched RAM snapshot was captured for this Europe
  screenshot**, so their positions/sprites cannot be byte-verified — they are intentionally omitted
  rather than guessed.
- Market **prices** and the **title** string are the *displayed* values of this specific capture
  (read from the screenshot), not a decoded snapshot.

## 1. Purpose
> **RUNTIME-CONFIRMED 2026-06-25** (`docs/screens/10_europe_screen.png`, `09_europe_arriving.png`):
> drove a Caravel back to Europe ("Return to Europe" order) and captured the live screen. Confirms
> the header `London, England. Spring, 1500. Tax: 0% Gold: 1000e`, the three dock-zone captions
> `Expected Soon` / `Bound For New England` / `Loading: Caravel`, the `RECRUIT`/`PURCHASE`/`TRAIN`
> button panel (top-right), the 16-commodity bid/ask price strip along the bottom (same prices as
> the F5 Economic report — single market model), and the `Exit` button with its red `E` accelerator
> (bottom-right). First arrival shows a tutorial help overlay (the "European Status Screen" text).
> Validates the Track-4 `func @0x3200A` hit-test rects and the §-cited paint origins.

The home-nation harbor where the player sells/buys cargo, recruits/purchases/trains
units, and dispatches ships. The dock panel tracks ship traffic (Expected Soon /
Bound For / Loading via per-ship sail-state). The bottom strip shows the 16
commodities; on Europe each cell shows the **market price** (the cell is the
buy/sell interface — you trade through it), with a boycotted good's own icon
redrawn as the boycott marker. **B**

Entered via the screen stub `func_030DBC @0x030DEB`: loads `EUROPE.PIK` by numeric
key **0x0FBA** (`@0x030DCE`) then `mov bx,0x2B; lcall enter_screen_view`
(`0x181F:0x772`) → screen-view id **0x2B**, code page 0x04. **B**
(`SCREEN_LAYOUTS.md` §2; the older note cited the same stub as `europe_open`
line 21950 / `0x030DBC` — consistent.)

## 2. State & data layout
All offsets raw-verified against `raw/COLONIZE/VICEROY.EXE` (capstone 16-bit)
unless noted.

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| PowerRecord `+0x2A` | u32 | treasury gold (dword) | B | `sub [bx+0x2a],ax; sbb [bx+0x2c],dx` @0x3340D |
| `DG16(0x2F5E)` | u16 | **string-heap index = 537 → "Sons of Liberty"** drawn at (306,179) via `0x181F:0x22`→`0x13C` (NOT gold; gold = `PowerRecord+0x2A`). `[0x2F5E]` has **zero static absolute writers** (byte-searched A3/C7-06/89-xx encodings across the whole EXE → none); it is a boot-resolved @LABELS caption pointer. **RESOLVED 2026-06-27 (ram_read):** snapshot `rep_europe.bin` (& `colony_live_1505.bin`) both read `[0x2f5e]=0x219`=537; the heap (far ptr `[0x2d42]`) index 537 = **"Sons of Liberty"**. | B draw / A semantic (oracle) | `func_0314DC @0x031264`; snapshot [0x2f5e]=537='Sons of Liberty' |
| PowerRecord `+0x01` | u8 | tax rate 0..100 | B | banner uses it (`func_030F76`, `SCREEN_LAYOUTS.md` §2 ord 2) |
| PowerRecord `+0x20` | u16 | **boycott bitmask** (`1<<good`), one bit/good | B | `and ax,[bx+0x20]` @0x30B47; clear `and [bx+0x20],ax` @0x33423 |
| PowerRecord `+0x22` | u32 | cumulative spent | B | `add [bx+0x22]; adc [bx+0x24]` @0x33413 |
| `+0x4C + good` | u8 | **price_level[16]** (running price index) | B | `mov [bx+si+0x4c],al` @0x306F3 |
| `+0x5C + good·2` | i16 | **vol_accum[16]** (traffic-volume accumulator) | B | `add [bx+si+0x5c],ax` @0x30707 |
| `DG16(0x9E12)` | u16 | selected good / power idx (banner `good=[0x9E12]`) | B | lines 21818, 21867; `SCREEN_LAYOUTS.md` §2 ord 2 |
| `DG16(0x538A)` | u16 | game year (banner `year=[0x538A]`) | B | line 21868; `SCREEN_LAYOUTS.md` §2 ord 2 |
| `DG16(0x0FA2)` | u16 | **count of ships IN PORT** (dock branch selector) | B | `cmp [0xFA2],0; jne 0x31560` @0x0314F1 |
| UnitRecord base `0x3144` stride `0x1C` | — | per-ship record (dock loop) | B | drawlist DGROUP table; type `+0x02=0x3146`, flag `+0x3150` |

> **Ruling:** byte-verified `market.h` (price_level `+0x4C` / vol_accum `+0x5C` /
> boycott `+0x20`) **wins** over the RECONSTRUCTED `power.h` field names. There is
> no separate contiguous market_pool/eu_supply/base_value block at these offsets
> (RULINGS 2026-06-21).

## 3. Formulas & rules
- **Market banner** (`func_030F76 @0x030F76`): a sprintf-style builder (chains
  `lcall 0xD1D:0x117e/0x11b4/0x7a4/0x8fa`) formats good-name + price into
  `[bp-0x50]`, then paints via `lcall 0x181F:0xB0 @0x0310AD`. Composer passes
  arg 0 (`@0x031E6B`), so the banner sits in the **header band**. The string is the
  **`@CMESSAGE` "Selling … at … "** family (see §5). Source words: `good=[0x9E12]`,
  `year=[0x538A]`, `tax=PowerRecord+0x01`. **B (mechanism + source words) / B (band y) /
  runtime (text X)** — the paint call `0x181F:0xB0`=`func_00275C @0x00275C` pushes **no
  coordinate** (only `ss`, `&[bp-0x50]`, `mode`); `func_00275C` reads the BSS text-box
  `[0x2cc6..0x2ccc]` and **center-justifies** the formatted line within it. That box is a
  **static EXE immediate** `(x=320, y=7, w=0, h=0)` written by `set_text_box`
  (`func_00273E @0x00273E`, `0x181F:0xA6`) from `func_035B06 @0x035B24` (`push 7; push
  0x140; push 0; push 0`) → full-width top band **y=0..7**; the literal X is the only
  runtime-derived part (string-width centering).
- **Market price — bid/ask, B (traced 2026-06-21, `0x181F:0xAEC → bid_get
  @0x0B2A2`):** per-good market record stride `0x1C`, base DGROUP `0x3150`;
  `level = [good·0x1C + 0x3150]`; **bid = nibble of `[good·0x1C + 0x3151 + level/2]`**
  (`sar 4` odd level / `and 0xF` even). **`ask = bid + @CARGO.Burden + 1`** (NAMES
  `@CARGO` "Burden" legend: *"0 means ask is 1 higher than bid"* — `@CARGO` row
  verified present, e.g. `Food, 1, 3, …`). Sell handler `@0x32914` (price helper
  `@0x3245C`); cross-ref `systems/market.md`. **B**
- **Market-bar price-number X centering** (`func_0310B4 @0x031179..0x0311B3`):
  `textW = measure(0x204)`, `x = cell_center − textW/2 + 8` (`sar ax,1; sub; neg;
  add 8` @0x031191). Prices are **CENTERED in each cell**, drawn `Y=0xC2 (194)`,
  text-colour palette `0x2F`. **B**
- **Recruit-row centering** (`func_031BE6 @0x031C40..0x031C4C`):
  `x = (boxW − textW)/2 + box_x`, so RECRUIT/PURCHASE/TRAIN are **HORIZONTALLY
  CENTERED** in the 37-px panel. Row pitch = `glyphH + 2` (`inc; inc; add [bp-4]`
  @0x031E23), **not** a flat 10. **B**
- **Per-ship sail-state → status-band Y** (`func_031298 @0x031298`): bins a ship's
  sail-distance `[bp+6]` into state 0..3, then the jump-table tail sets the row Y:
  **state 1 → Y=0x92 (146)** (@0x031329), **state 2 → Y=0x89 (137)** (@0x03133F),
  **state 3 → Y=0x84 (132)** (@0x031353); state 0 keeps the passed-in Y. Row x =
  `state·tilewidth + base_x` (tile width `0x10>>zoom`, @0x0312E5/@0x031313). **B**

## 4. UI layout — "what is drawn where"
Native 320×200 (mode 13h). Coordinates are **literal immediates** in the
overlay-resolved sub-renderers (tier **B**, `@asm` offsets cited per row),
corroborated by the click hit-test rects in the Europe hit-test orphan
`@0x032034` (line 22202 in the decompile).

Colors below are EUROPE.PIK palette indices → exact RGB (B); fonts are
screen-latched (A, per `fonts_and_colors.md`).

| Element | Rect (x,y,w,h) | Sprite / text | Font | Color → RGB | Tier |
|---------|----------------|---------------|------|-------------|------|
| Play-area fill | (0, 8, 320, 192) | frame-helper fill `func_030D86` | — | — | B (`push 0xC0,0x140,8,0; call 0x368CC` @0x031E4C) |
| Header/backdrop band | full-width top band; banner text-box = (x=320,y=7,w=0,h=0) | trampoline STATE-SETUP (no rect) | — | — | B-called; band y=0..7 **B** (`push cs; call 0x368A4` @0x031E5D → `ljmp 0x191F:0xC76` = **func_030D6C @0x030D6C**; the banner top-band rect `(320,7,0,0)` is set by `set_text_box` @0x035B2D / func_035B06). **RESOLVED-B 2026-06-27:** the step-2 target draws no fill — `func_030D6C` only sets `[0xFA2]`=ship-count + zeroes `[0x9E20]/[0x9E1C]` then calls `func_030D16` (recruit-pool counter). No own fill rect exists. |
| Market banner ("Selling …") | top title band **y=0..7** (`set_text_box`), text X center-justified at runtime | `@CMESSAGE` formatted line | FONTTINY | — | B-mech + B-band-y (`func_030F76` builds; paint `0x181F:0xB0`=`func_00275C` @0x0310AD reads box `[0x2cc6..0x2ccc]`=(320,7,0,0) set by `set_text_box`=`func_00273E` @0x035B2D in func_035B06); X is runtime-centered |
| Market bar fill (16-good) | (0, 179, 320, 21) | frame-helper fill | — | — | B (`push 0x15,0x140,0xB3,0; call 0x368CC` @0x0310B9) |
| Market-bar icons (16) | x=1, **stride 19**, icon row in bar | ICONS.SS `good+0x17` (23..38) | — | — | B (`add ax,0x17` @0x0310F2; pitch via `[0x83E]:[si+0x152]` half-width @0x031101) |
| Market-bar prices (16) | **cell-centered**, y=**194** | bid-price `"%d"` | FONTTINY | `0x2F` (price ink) | B (centering @0x031191; `0x181F:0x13C` @0x0311AE) |
| Warehouse-bar right readout | x=**306**, y=**179** | heap **string #`[0x2F5E]`** = idx **537** = **"Sons of Liberty"** (NOT gold) | FONTTINY | `0x0F`→white | B draw (`push 0xf;push 0xb3;push 0x132;push [0x2f5e]; lcall 0x181F:0x22 fetch; lcall 0x181F:0x13c draw` @0x031261). **Semantic RESOLVED 2026-06-27 (ram_read):** live snapshot `rep_europe.bin` → `[0x2f5e]=0x219`=537; string-heap (far ptr `[0x2d42:0x2d44]`, walked by FETCH `func_002462`) index 537 = **"Sons of Liberty"** (also =537 in the colony snapshot — a load-time @LABELS caption pointer, stable). |
| Dock fill | (143, 118, 81, 60) | frame-helper fill | — | — | B (`push 0x3C,0x51,0x76,0x8F; call 0x368CC` @0x0314E1) |
| Empty-dock caption box | (143, 81, 120, 69) | FILL + **CENTERED** caption `[0x2DD0]` = idx **338** = **"Bound For"** | FONTTINY | — | B (`push 0x45,0x78,0x51,0x8F; push [0x2dd0]; 0x181F:0x22 then 0x181F:0x100` @0x0314F8, gated by `cmp [0xfa2],0; jne` @0x0314F1). **`[0x2DD0]` RESOLVED 2026-06-27 (ram_read):** snapshot → 338 = **"Bound For"** (heap idx 338). |
| In-port ship-name list | (143, 81, 120, 69) | **CENTERED** ship-name rows | FONTTINY | — | B (`0x181F:0x100` @0x0315C9; 2nd line @0x031621) |
| Docked ships (6 slots) | **x=147+slot·12** (147,159,171,183,195,207), **y=165**, **10×12** | ICONS.SS sprite **0x7B (123)** | — | — | B (`func_0314AE`: x @0x0314BD, y=0xA5 @0x0314C8, w=0xA @0x0314CF, h=0xC @0x0314D6; sprite `mov ax,0x7B` @0x03154F) |
| Ship status row (per in-port ship) | x=`state·tile+base`, **y=146/137/132** by state 1/2/3 | sail-progress bar (`0x181F:0x2BC`) + type ICON `@UNIT[type]+0x5232` | FONTTINY | — | B (`func_031366`/`func_031298`; bar width `0x64>>state` @0x0313A4) |
| Recruit/Purchase/Train panel | (**281**, **89**, **37**, **32**) | frame-helper fill, optional 1-px frame `0x181F:0xE2` @0x031E45 | — | — | B (`push 0x20,0x25,0x59,0x119; call 0x368CC` @0x031DCC) |
| RECRUIT/PURCHASE/TRAIN rows (3) | inside panel, **centered**, y = 89 + row·(glyphH+2) | `@EUROLABEL` text | FONTTINY | `0x0F`/`0x0` by selection | B (3-row loop @0x031DEB..0x031E2F; center @0x031C40; ink @0x031C10/@0x031BF4) |
| Boycott marker | over dock, gated unit-type 0x0D–0x12 + `[+0x3150]≠0` | ICONS.SS **`good+0x17`** (the good's own icon) | — | — | B (gate @0x031A73..0x031AB4; `add ax,0x17`; blit `0x181F:0x254` @0x031417) |
| Screen outer rule | (0, 200, 320) bottom 1-px line | rule via `0x181F:0xE2` | — | — | B (`push 0,0x140,0xC8; lcall 0x181F:0xE2` @0x031E95/@0x031EA0) |
| Exit | framework-level (no painted button) | — | — | — | **RESOLVED 2026-06-23:** leaving Europe is the generic screen-view runner's close (`@EUROLABEL` 4th token `"x"`/ESC), not a Europe-painted button; steps 6/`func_036863`/`036926` are the two **left dock sub-panels** (`func_0317CC`/`func_0318D2`), not an exit widget. `EUROPE_SCREEN_VICEROY_DECODE.md` §10/§11 |

**Click hit-test rects** (Europe hit-test orphan `@0x032034`, point-in-rect
`0x181F:0x3CA`) — corroborate the draw rects and name the dock panels:
recruit pool (281,89,37,32); market-minus-exit (0,179,**305**,21); dock A
(143,118,81,60); **"Bound For"** (72,118,70,51); **"Loading"** (1,118,70,51);
**"Expected"** (224,120,96,59). The decompile names the same rects with IDs:
recruit→5, stockpile-gold (306,179,15,21)→0xB, stockpile row (0,179,305,21)→0,
dock A→1, Bound For→2, Loading→3, Expected→4. **B**

### 4.1 Composer draw chain — `func_031E4C @0x031E4C` (the backbone)
Transcribed call-for-call (`@asm 0x031E4C..0x031EA5`, drawlist §1.0). This ORDER is
the authoritative paint sequence; later steps composite over earlier ones.

| # | call site | callee | draws | rect / key |
|---|-----------|--------|-------|-----------|
| 1 | @0x031E4C | `func_030D86` (frame helper) | play-area fill below header | (0, 8, 320, 192) |
| 2 | @0x031E5D | `0x368A4` trampoline (`ljmp 0x191F:0xC76`) | header **STATE SETUP** (no rect) | full-width top band; banner text-box rect = **(320,7,0,0)** B (set_text_box @0x035B2D, func_035B06). **RESOLVED 2026-06-27 (multibranch, no TBD):** `0x191F:0xC76` = **func_030D6C @0x030D6C**, disassembled in full — it draws **NOTHING**: `push 0xFA4; call func_030B4C; mov [0xFA2],ax` (ship count), `mov [0x9E20],0; mov [0x9E1C],0`, then `call 0x36872`→**func_030D16 @0x030D16** (recruit-pool counter: zeroes `[0x9E2A]`, loops unit-type 0x0D–0x12), `retf`. Neither function emits a fill/blit/rect; the play-area backdrop is step-1 `func_030D86` (0,8,320,192) over EUROPE.PIK. Step-2 has **no own fill rect** — the prior "TBD (overlay-resident)" was a phantom. |
| 3 | @0x031E63 | **`func_0310B4`** (arg 0) | 16-good market PRICE bar | bar (0,179,320,21); icons+prices |
| 4 | @0x031E6B | **`func_030F76`** (arg 0) | "Selling …" market banner | header band y=0..7; X = runtime-centered. **RESOLVED-as-state 2026-06-27:** painter `func_00275C @0x00275C` reads box `[0x2cc6]=x=320,[0x2cca]=w=0,[0x2ccc]=h=0` and centers the live formatted line via `lcall 0xb9e:0xa @0x002823` (args `[0x2cca]=w,[0x2ccc]=h,[0x2cc6]=x`). Band geom is static-B (320,7,0,0); the literal text X is computed per-paint from the live string width — per-game state, not a static constant. |
| 5 | @0x031E73 | **`func_0314DC`** (arg 0) | dock + 6 ships + in-port list | dock (143,118,81,60) |
| 6 | @0x031E7C | `0x36863` trampoline | sub-renderer (`ov_draw_extra_a`) | transaction parchment top strip (see §7) |
| 7 | @0x031E85 | `0x36926` trampoline | sub-renderer (`ov_draw_extra_b`) | transaction parchment bottom strip (see §7) |
| 8 | @0x031E8D | **`func_031DC8`** (arg 0) | RECRUIT/PURCHASE/TRAIN menu | (281,89,37,32) |
| 9 | @0x031E95/@0x031EA0 | `0x181F:0xE2` | screen outer rule | (0, 200, 320) |

Per-ship status (`func_031298`/`func_031366`, §3) is invoked from inside step 5
(`func_0314DC`) when ships are in port (`[0xFA2]≠0`). The boycott marker (§4 row)
is emitted by `func_031366 @0x031417` within the same in-port path.

## 5. Assets & text
- **Background:** harbor PIK loaded by key **0x0FBA** (stub `func_030DBC @0x030DCE`);
  palette from the PIK. **B**
- **Recruit-pool labels** (`LABELS_sections.json @EUROLABEL`, grep-verified):
  literal value **`"RECRUIT\nPURCHASE\nTRAIN\nx"`** → RECRUIT / PURCHASE / TRAIN
  (the trailing `x` is the close/exit token). Table accessed as DGROUP
  `[bx-0x6C28]` by `func_031DC8`. **B**
- **Trade / banner text** (`LABELS_sections.json @CMESSAGE`, grep-verified): value
  includes **`Selling`**, **`Buying`**, **`at`**, **`. Price:`**, **`% Tax:`**,
  **`. Net:`**, **`bought for`**, **`sold for`**, **`Loading`**, **`Unloading`**.
  These feed the `func_030F76` banner and the transaction parchment (§7). **B
  (keys) / TBD (banner pixel origin)**
- **Dock band captions** (`LABELS_sections.json @MISC`, grep-verified — **corrected
  source**): value includes **`Expected Soon`**, **`Bound For`**, **`No Ships In
  Port`**, **`Awaiting Passage`**, **`Sailing For`**, **`Inbound From`**,
  **`Now Arriving In`**, **`Docks At`**, plus `Loading`/`Unloading`. These are the
  per-state dock captions; the per-state Y (146/137/132) is byte-pinned (§3), the
  exact caption-string-id↔state mapping and the empty-dock caption pointer `[0x2DD0]`
  resolution stay **TBD-runtime** (the captions are not literal pushes in `func_0314DC`;
  verified — the only text `func_0314DC` draws is the empty-dock caption `[0x2dd0]`
  @0x031501 and the in-port ship-type name `[bx+0x5230]` via `0x181F:0x16e` @0x0315C1,
  with the per-ship status loop at @0x031671..0x0316A1 selecting only a *color* `[bp-0x68]`=
  0xA/0xF, NOT an `@MISC` caption index). The `@MISC` dock-state captions form a contiguous
  block — ordinals (0-based within `@MISC`): 5=`Sailing For`, 6=`Inbound From`,
  7=`Now Arriving In`, 8=`Docks At`, 9=`Expected Soon`, 10=`Bound For`, 11=`No Ships In
  Port`, 12=`Awaiting Passage` — but the index↔sail-state SELECTION is computed by a renderer
  outside the four statically-decodable Europe page-4 functions (`func_0314DC`/`func_031366`/
  `func_0317CC`/`func_0318D2`), and `[0x2dd0]`/`[0x2de8]` are runtime heap indices never written
  by any disassembled `mov` (grep: zero writers). **B (keys + @MISC ordinals) / TBD-runtime
  (id↔state map; needs a live RAM/heap trace)**
- **16-commodity order + Burden** from NAMES `@CARGO` (grep-verified, e.g.
  `Food, 1, 3, 1, 6, 7, 3, 2, -1, 0`). Drives icon order (ICONS 23..38) and the
  `ask = bid + Burden + 1` rule. **B**
- **Nations** for the (legacy) title string `nations[4] = {English, French,
  Spanish, Dutch}`. The current Europe header is the `func_030F76` banner, not a
  separate "<Nation> Port" title. **B**

## 6. Interactions
- **Market bar cells** — Europe feeds the generic 16-cell bar (`func_0310B4`)
  market PRICES; clicking a cell is the buy/sell action (sell handler `@0x32914`).
  The same `func_0310B4` on the Colony screen shows warehouse quantities — same
  layout, different data (`SCREEN_LAYOUTS.md` §2/§3). **B**
- **Recruit/Purchase/Train panel** (281,89,37,32 → click-id 5) — three rows; each
  drives recruit / purchase / train of a waiting unit via `func_031DC8`. **B**
- **Dock panels** — click the dock (id 1), Bound For (2), Loading (3), Expected (4)
  zones to inspect/dispatch ships in those sail-states. **B**
- **Right-end readout** (306,179,15,21 → click-id 0xB) and market row (0,179,305,21
  → click-id 0) are the trade-readout zones. (The 306,179 readout is heap string
  `[0x2F5E]`, **not gold** — corrected 2026-06-23; player gold is in the top menu
  header, `PowerRecord+0x2A`. See `docs/EUROPE_SCREEN_VICEROY_DECODE.md` §6.) **B**
- **Exit** — a click-rect exists (`@0x032034`), but the Exit-button paint origin is
  **TBD** (§4). **B (clickable) / TBD (paint)**

## 7. Transaction sub-panel — `ov_draw_extra_a/b` (steps 6–7)
Resolved 2026-06-21 (kept; consistent with drawlist trampoline targets
`0x36863→0x319A6` / `0x36926→0x31AFA`): the **trade-transaction parchment panel**
is two sub-fns. Top strip `@0x317CC` box-fill `(51,70,118,72)` + text rows
`(x=0x45, y=0x78)` drawing the power/good names; bottom strip `@0x318D2` box
`(51,1,118,1)` + the numeric value `[0x2DCC]`. Text = `@CMESSAGE` tokens
(Buying/Selling/at/Price/%Tax/Net), data in LABELS.TXT. **B (rects) / B (keys).**
Boycott marker fully closed (§4) — the "red-X slot 043" guess is **REFUTED**; the
marker is the boycotted good's own ICONS.SS frame `good+0x17` redrawn over the dock
(gate @0x031A73..0x031AB4; blit @0x031417). **B.**

## 8. Evidence
- `viceroy_source/docs/drawlist/EUROPE_COLONY.md` PART 1 — composer `func_031E4C
  @0x031E4C` draw ORDER §1.0; market bar `func_0310B4` §1.1; banner `func_030F76`
  §1.2; dock+ships `func_0314DC`/`func_0314AE` §1.3; per-ship status
  `func_031298`/`func_031366` §1.4; recruit menu `func_031DC8`/`func_031BE6` §1.5;
  exit/info §1.6; Coordinate summary + PORT FIXES (EUROPE). **B**
- `viceroy_source/docs/SCREEN_LAYOUTS.md` §2 — screen-id 0x2B, entry `func_030DBC`
  (PIK 0x0FBA); market bar 16 cells stride 19 ICONS 23..38 (`add 0x17` @0x0310F2,
  pitch @0x03124C, count @0x031253, gold @0x031261); dock (143,118,81,60) sprite
  0x7B; recruit pool (281,89,37,32) 3 slots; outer frame @0x031EA0. **B [V]**
- `raw/COLONIZE/VICEROY.EXE` capstone re-verify: gold u32 `+0x2A` @0x3340D;
  boycott word `+0x20` @0x30B47/0x33423; price_level u8 `+0x4C` @0x306F3;
  vol_accum i16 `+0x5C` @0x30707; spent `+0x22` @0x33413; in-port count `[0xFA2]`
  @0x0314F1; status-band Y 146/137/132 @0x031329/@0x03133F/@0x031353. **B**
- `data_extracted/text/LABELS_sections.json` — `@EUROLABEL` ("RECRUIT\nPURCHASE\n
  TRAIN\nx"), `@CMESSAGE` (Selling/Buying/at/Price/%Tax/Net), `@MISC` (Expected
  Soon/Bound For/No Ships In Port/…). All grep-verified present. **B**
- `data_extracted/text/NAMES_sections.json` — `@CARGO` (16 goods + Burden column).
  Grep-verified present. **B**
- `ghidra_export/VICEROY_decompiled.named.c` lines 21815–21961, 22202–22213 —
  composer + helper bodies, hit-test rects (cross-reference; the drawlist `@asm`
  offsets are primary). **B**

## 9. Open questions
1. ✅ **Composer draw ORDER** — fully byte-traced as a 9-step chain (§4.1,
   `func_031E4C @0x031E4C`). **B.**
2. ✅ **Dock-ship geometry** — corrected to byte-exact `x=147+slot·12, y=165,
   10×12, ICONS 0x7B` (`func_0314AE`). Prior "stride 20 y=122" R guess refuted. **B.**
3. ✅ **Per-ship status-band Y** — byte-pinned 146/137/132 for sail-states 1/2/3
   (`func_031298` jump-table tail). **B.**
4. ✅ **Boycott marker** — REFUTED red-X guess; it is the good's own ICONS frame
   `good+0x17` (§4/§7). **B.**
5. ✅ **Market bid/ask** — byte-traced (§3). **B.**
6. ✅ **Transaction sub-panel** (steps 6–7) — two parchment strips at
   `@0x317CC`/`@0x318D2` (§7). **B.**
7. ✅ **RESOLVED-B (2026-06-27) — banner band geometry is a static EXE immediate, not runtime-only.**
   `func_030F76 @0x0310AD` paints via `lcall 0x181F:0xB0` (= `func_00275C @0x00275C`,
   thunk_resolve `181F:00B0`) with **no coordinate push** (verified: only
   `push ss; push &[bp-0x50]; push [bp+4]=mode` @0x0310A5..0x0310AD), so the origin
   comes from the BSS text-box `[0x2CC6..0x2CCC]`. **The painter `func_00275C` reads
   that box** (`mov ax,[0x2cca]=w; mov bx,[0x2cc6]=x; add bx,ax` @0x002782..0x002793;
   `mov ax,[0x2cca]; mov dx,[0x2ccc]; mov bx,[0x2cc6]; lcall 0xb9e:0xa` @0x002818..0x002823)
   and **horizontally CENTERS** the formatted line within it. **The box is SET by a
   static EXE immediate, refuting the old "no static B source" claim:** the page-4
   screen-init `func_035B06 @0x035B24..0x035B2D` does `push 7; push 0x140; push 0; push 0;
   lcall 0x181F:0xA6` where `0x181F:0xA6` = `set_text_box func_00273E @0x00273E`
   (`[0x2cca]=w=arg[bp+6]`, `[0x2ccc]=h=arg[bp+8]`, `[0x2cc6]=x=arg[bp+0xa]`,
   `[0x2cc8]=y=arg[bp+0xc]` — byte-verified @0x002741..0x00275A). cdecl arg order makes
   `[0x2cc6]=0x140=320, [0x2cc8]=7, [0x2cca]=0, [0x2ccc]=0` — exactly the oracle
   snapshot `(320,7,0,0)`, now **byte-sourced**. The identical immediates are also at
   the page-2 site @0x02C5F1, so the banner band is `(x=320,y=7,w=0,h=0)` = a
   **full-width top title band y=0..7** for the whole page-4 screen family. **Resolved
   (B):** painter `func_00275C` @0x0310AD; band geom `(320,7,0,0)` from `set_text_box`
   @0x035B24 (func_035B06). **Residual (runtime, not TBD-static):** the literal text X is
   center-justified at runtime against the live string width (the band is fixed at
   y=0..7).
8. ✅ **RESOLVED 2026-06-27 (ram_read) — dock caption pointer block.** The dock
   captions are a contiguous boot-resolved @LABELS-index array in DGROUP (string-heap
   indices fetched by `func_002462` from far ptr `[0x2d42]`). Live snapshot `rep_europe.bin`
   (identical in `colony_live_1505.bin`): `[0x2dcc]=336`="Docks At" (Loading panel
   `func_0318D2`, hit-id 3), `[0x2dce]=337`="Expected Soon" (Bound-For panel `func_0317CC`,
   hit-id 2), `[0x2dd0]=338`="Bound For" (empty-dock caption `func_0314DC` @0x031501),
   `[0x2dd2]=339`="No Ships In Port", `[0x2de8]=350`="No cargo on board!". The per-ship
   in-port loop in `func_0314DC` @0x031671 selects only a *color* (`[bp-0x68]`=0xA/0xF),
   not a caption index, so the visible state caption comes from these fixed panel pushes,
   not a runtime sail-state→@MISC computation. **A (oracle slot→string map).**
9. **TBD — Exit-button paint origin.** Only a click-rect exists (`@0x032034`); the
   composer body paints no Exit button. Likely emitted by the `func_036863`/
   `func_036926` sub-renderers (steps 6–7) but not byte-pinned (drawlist §1.6).
10. **R/A — fonts.** FONTTINY assignment for the bar/recruit/banner text is
    screen-latched per `fonts_and_colors.md` (A); the price-ink palette `0x2F` and
    recruit-row inks `0x0F`/`0x0` are byte-cited (B).

*No runtime residual* — every Europe element (geometry, sprites, price formula,
boycott marker) is static; only the live values (gold, prices, which goods are
boycotted, which ships are in port) are game state.
