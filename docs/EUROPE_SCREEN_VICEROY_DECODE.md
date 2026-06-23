# EUROPE SCREEN — VICEROY.EXE decode (code-anchored)

> Source of truth = **VICEROY.EXE disassembly** (`raw/COLONIZE/VICEROY.EXE`, capstone
> 16-bit). Companion to `docs/COLONY_SCREEN_VICEROY_DECODE.md`; the Europe market bar
> `func_0310B4` is the byte-identical twin of the colony stockpile bar. Built
> 2026-06-23. Tiers: **B** byte-verified / **A** anchor / **R** reconstructed / **TBD**.

## 0. Anchors
- DGROUP file base = `0x1D9A0`; BSS starts `DS:0x2CC6` (see colony decode §0).
- Active power record ptr = **`[0x84FC]`** (`g_current_power_ptr`); PowerRecord stride
  `0x13C`. Treasury = **`PowerRecord+0x2A`** (u32, BYTE_VERIFIED, `DATA_MODEL.md`).
- Ships-in-port count = **`[0xFA2]`** (`= func_030B4C([0xFA4])`, set @0x030D75).

## 1. Entry + screen chain
```
europe_screen stub  func_030DBC @0x030DEB
  load EUROPE.PIK   (numeric key 0x0FBA @0x030DCE)   -- the harbor backdrop, full screen
  mov bx,0x2B ; lcall enter_screen_view             -- screen id 0x2B
  paint = COMPOSER func_031E4C @0x031E4C
  event loop / hit-test (orphan @0x032034, point-in-rect)
```

## 2. Composer draw order — `func_031E4C @0x031E4C` (byte-read, 9 steps)

Near-call trampolines `call cs:0x368xx` → `ljmp 0x191F:NNN` → file (all resolved
2026-06-23 with `tools/follow_thunk.py`):

| # | @site | call | sub-renderer | role |
|---|-------|------|--------------|------|
| 1 | 0x031E56 | `call 0x368CC` → `0x191F:0xCE6` | **func_030D86** | play-area pattern fill `(0,8,320,192)` (`0x181F:0x444`, sheet `[0x2DA8]`) |
| 2 | 0x031E5D | `call 0x368A4` → `0x191F:0xC76` | **func_030D6C** | header setup: `[0xFA2]=`ship count, then `0x36872`→**func_030D16** (recruit-pool count `[0x9E2A]`) + backdrop |
| 3 | 0x031E63 | `call 0x310B4` (arg 0) | **func_0310B4** | **16-good market PRICE bar** `(0,179,320,21)` |
| 4 | 0x031E6B | `call 0x30F76` (arg 0) | **func_030F76** | **market banner** ("Selling …") |
| 5 | 0x031E73 | `call 0x314DC` (arg 0) | **func_0314DC** | **dock + 6 ships + in-port list** |
| 6 | 0x031E7C | `call 0x36863` → `0x191F:0xBC0` | **func_0319A6** | transaction strips: dispatches **func_0317CC** (`0x3690D`) + **func_0318D2** (`0x3695D`) |
| 7 | 0x031E85 | `call 0x36926` → `0x191F:0xDE2` | **func_031AFA** | right-side in-port recruit/unit list panel `(224,120,96,59)` |
| 8 | 0x031E8D | `call 0x31DC8` (arg 0) | **func_031DC8** | **RECRUIT/PURCHASE/TRAIN** panel `(281,89,37,32)` |
| 9 | 0x031E95 | `lcall 0x181F:0xE2` | — | screen outer rule `(0,200,320)` |

The screen-toggle/refresh entry points (`@0x031EB0`/`@0x031EEE`) re-call steps 3/4/5/7
with arg 1 and recompute the gold mirror `[0x9E30] = treasury+0x14` (`@0x031F1F`).

## 3. Region map — "what is drawn where" (B unless noted)

| Element | x | y | w | h | source |
|---------|---|---|---|---|--------|
| Play-area fill | 0 | 8 | 320 | 192 | step 1 `func_030D86` |
| Harbor backdrop | full | — | — | — | EUROPE.PIK (key 0x0FBA) |
| Market banner ("Selling …") | header band, centered | runtime (R) | — | — | `func_030F76` paint `0x181F:0xB0` |
| Market price bar | 0 | 179 | 320 | 21 | `func_0310B4` |
| Market-bar icons (16) | x=1, stride 19 | bar | — | — | ICONS `good+0x17` (23..38) |
| Market-bar prices (16) | cell-centered | 194 | — | — | bid `"%d"`, ink `0x2F` |
| Warehouse-bar right readout | 306 | 179 | 15 | — | heap string `[0x2F5E]` (**NOT gold** — §6) |
| Dock fill | 143 | 118 | 81 | 60 | `func_0314DC` |
| Docked ships (6) | 147+slot·12 | 165 | 10 | 12 | ICONS sprite `0x7B`; `func_0314AE` |
| Ship status row | state·tile+base | 146/137/132 by state | — | — | `func_031298`/`func_031366` |
| Recruit/Purchase/Train panel | 281 | 89 | 37 | 32 | `func_031DC8` |
| Screen outer rule | 0 | 200 | 320 | — | `0x181F:0xE2` |

## 4. Market PRICE bar — `func_0310B4` (twin of colony stockpile bar)
Byte-identical layout to the colony stockpile bar (colony decode §6): fill
`(0,179,320,21)`, 16 cells pitch `0x13`, icon `good+0x17`. **Difference = the data and
ink:** Europe draws the **bid PRICE** per good (`"%d"`, ink `0x2F`), **cell-centered at
y=194 (`0xC2`)** (`@0x031191` add 8 / `@0x0311AE`); the colony twin draws warehouse
quantities at the same coordinates. Same right-end `[0x2F5E]` caption at (306,179).
Clicking a cell is the buy/sell action (sell handler `@0x032914`). **B.**

## 5. Banner / header — `func_030F76`
Assembles the trade line into `[bp-0x50]` from `@CMESSAGE` fragments (`Selling`/`Buying`/
`at`/`. Price:`/`% Tax:`/`. Net:`), merges nation via `0x181F:0xB1E` (`@0x03109D`,
arg `[0x9E12]`), then paints via **`0x181F:0xB0` (`func_00275C`) `@0x0310AD`** with mode
`[bp+4]` = **0** (composer arg). This is the **same rich-text painter the colony title
uses** — so the origin is the runtime text-box `[0x2CC6/8/A/C]` (header band, centered);
the literal pixel origin is **R/TBD** exactly as on the colony title. **B chain / R origin.**

## 6. Gold (treasury) — top menu header, NOT the warehouse bar
As on the colony screen (corrected 2026-06-23, user/DOS): the player gold is shown in
the **top menu header**, value **`PowerRecord+0x2A`** via `[0x84FC]` (displayed mirror
`[0x9E30] = treasury+0x14` recomputed `@0x031F1F`). The `(306,179)` `[0x2F5E]` readout
on the market/warehouse bar is a **heap string caption, not gold** — `0x2F5E` is a string
index (`0x181F:0x22` fetch), never written as a treasury value (the colony `@0x0283F1`
and Europe `@0x03125C` draws are byte-identical, both captions). **B (field) / B (not-gold).**

## 7. Dock + ships — `func_0314DC` → `func_0314AE`
- Dock fill `(143,118,81,60)`. If `[0xFA2]==0` (no ships): centered empty caption
  (`@MISC "No Ships In Port"` family; box `(143,81,120,69)`, heap ptr `[0x2DD0]` via
  `0x181F:0x22`→`0x100`). Else: in-port ship-name list, centered rows (`0x181F:0x100`).
- **6 dock slots** `func_0314AE`: **x = slot·12 + 0x93 (147)** (147..207), **y=165
  (`0xA5`)**, **10×12** (`0xA`×`0xC`), ICONS sprite **`0x7B` (123)**. **B.**
- Per in-port ship: a sail-progress bar (`0x181F:0x2BC`, width `0x64>>state`) + the unit
  type icon, on a status row whose **Y bins by sail-state**: state1→146, state2→137,
  state3→132 (`func_031298` @0x031329/0x03133F/0x031353); state0 keeps passed-in Y. **B.**
- Boycott marker: gated unit-type `0x0D..0x12` + `[+0x3150]≠0`, blits the good's own icon
  `good+0x17` (`0x181F:0x254` @0x031417). **B.**

## 8. RECRUIT / PURCHASE / TRAIN — `func_031DC8`
Panel `(281,89,37,32)`, optional 1-px frame `0x181F:0xE2`. Three centered rows from
`@EUROLABEL` (`"RECRUIT\nPURCHASE\nTRAIN\nx"`, table `[bx-0x6C28]`), y = `89 + row·(glyphH+2)`,
ink `0x0F`/`0x0` by selection (`@0x031C10`/`@0x031BF4`). Recruit cost = recruit-pool slot
`+0x04` word at DGROUP `0x978C + slot·6` (`DATA_MODEL.md`; not `base<<count`). **B.**

## 9. Interactions (hit-test orphan `@0x032034`, point-in-rect)
| zone | click-id | action |
|------|----------|--------|
| market cell | (per cell) | buy/sell (`@0x032914`) |
| dock / Bound For / Loading / Expected | 1 / 2 / 3 / 4 | inspect/dispatch ships by sail-state |
| Recruit/Purchase/Train | 5 | recruit/purchase/train waiting unit |
| market bar row / right readout | 0 / 0xB | trade-readout zones |
| Exit | (rect @0x032034) | leave Europe (paint origin TBD — likely `func_036863`/`036926`) |

## 10. Status — verified vs remaining
- **VERIFIED (B):** all 9 composer steps + every trampoline resolved to a named
  sub-renderer; market bar (twin of colony); dock/ship geometry (6 slots, x=147+slot·12,
  y=165; status-row Y by sail-state); recruit panel; banner painter; gold field
  (`PowerRecord+0x2A`, header); `(306,179)` is a caption not gold.
- **Runtime-only / remaining (NOT guessed):** (a) banner & gold blit pixel x/y (runtime
  text-box / menu chrome); (b) the `[0x2F5E]`/`[0x2DD0]` heap string contents; (c) the
  dock caption id↔sail-state map (captions not literal pushes in `func_0314DC`); (d) the
  Exit-button paint origin. The composer steps 6/7 are now resolved: step 7
  `func_031AFA` = the right-side in-port recruit/unit list panel `(224,120,96,59)`
  (iterates units of type `0x0D..0x12`); step 6 `func_0319A6` dispatches **func_0317CC**
  + **func_0318D2** (the two transaction-detail strips — their exact contents are the
  remaining trace).
