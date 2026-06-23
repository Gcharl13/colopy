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
Clicking a cell is the buy/sell action — handler **`func @0x032914`**: it resolves the
clicked good (`0x181F:0xC2C` from cursor) and, if that good is **boycotted** (`[0x892]`),
blocks with a message (good name `[bx-0x6840]`, dialog `0x36840`/`0x36854`). Otherwise it
builds the trade confirmation by `%`-substituting the **good name** (`[bx-0x6840]`, slot
0), the **in-port ship / cargo type** (`[bx+0x5230]`, slot 1), the **nation**
(`[bx-0x7C74]`, slot 2) and the **price/amount** (`[0x8DC4]`), i.e. sell the ship's cargo
of that good at the bid price (tax deducted per the banner `% Tax:`). **B.**

## 5. Banner / header — `func_030F76`
Two states, both assembled into `[bp-0x50]` and painted via **`0x181F:0xB0` (`func_00275C`,
the same rich-text painter as the colony title) `@0x0310AD`**, composer mode `[bp+4]=0` ⇒
header band, runtime text-box origin (`[0x2CC6/8/A/C]`, **R**).

**Idle banner (byte-decoded fields):** nation string (`[0x9E12]`-indexed `[bx-0x7C74]`,
then `[bx-0x72BE]` via `0x181F:0x22` fetch) + **season** (`[0x538C]`-indexed `[bx-0x6800]`,
the same season global as the colony title) + **year** (`[0x538A]`, itoa) + **tax rate**
(`PowerRecord+0x01` = `byte[[0x84FC]+1]`, `@0x031043`). So the idle Europe header reads
roughly *"«Nation» … «Spring» «1612» … Tax «N»%"*. **B (fields) / R (literal layout).**

**Transaction banner:** during a buy/sell the same line is rebuilt from `@CMESSAGE`
fragments (`Selling`/`Buying`/`at`/`. Price:`/`% Tax:`/`. Net:`) and the nation merge
`0x181F:0xB1E` (`@0x03109D`). **B (keys) / R (origin).**

> Gold is **not** in this banner — it's in the top **menu header** (`PowerRecord+0x2A`,
> §6). The banner carries the **tax**; the menu header carries the **gold**.

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

## 8. RECRUIT / PURCHASE / TRAIN — `func_031DC8` (the 3 right-side buttons)
Panel `(281,89,37,32)`, optional 1-px frame `0x181F:0xE2`. Three centered rows from
`@EUROLABEL` (`"RECRUIT\nPURCHASE\nTRAIN\nx"`, table `[bx-0x6C28]` indexed by `row`),
y = `89 + row·(glyphH+2)`, ink `0x0F`/`0x0` by selection (`@0x031C10`/`@0x031BF4`).
**Row→action is fixed by the draw order** (row indexes the label list): **row 0 =
RECRUIT, row 1 = PURCHASE, row 2 = TRAIN**.

Clicking the panel returns hit-id 5 (§9); the row chosen enters a selection sub-mode
`[0x9E3A]` and opens that action's chooser dialog; `[0x9E3E]=1` marks an active
selection. Per-item handlers `func_? @0x320EE`/`@0x321B4`/`@0x321FC` (set `[0x9E3A]`
to `0xA`/`8`/`9`) process clicks on the candidate sub-list (read unit type `[+0x3146]`,
icon `[+0x5232]`). Actions, anchored to the GAME.TXT chooser each raises:
- **RECRUIT** → `@RECRUIT` ("…pay their passage ({N gold}). Whom shall we recruit?") —
  bring over a waiting immigrant now; cost = recruit-pool slot `+0x04` word at DGROUP
  `0x978C + slot·6` (`DATA_MODEL.md`; not `base<<count`), rising per recruit.
- **PURCHASE** → `@PURCHASE` ("…Which shall we purchase?") then `@REALLYBUY`
  ("Purchase %STRING0 for %NUMBER0$? Yes/No") — buy a ship/artillery for gold.
- **TRAIN** → `@KINGRECRUIT`/`@RECRUIT2` (Royal University specialists) → result
  `@TRAINPROFESSION` ("…has learned the specialty profession {Y}.") — pay to train a
  specialist. **B (labels/panel/row order) / B (chooser keys present).**

## 9. Interactions — hit-test `func @0x032034` (point-in-rect `0x181F:0x3CA`), B
Exact rects, in test order (returns the id of the first rect the cursor is inside):

| click-id | rect (x,y,w,h) | zone / action |
|----------|----------------|---------------|
| 5 | (281,89,37,32) | RECRUIT/PURCHASE/TRAIN buttons (§8) |
| 0 | (0,179,305,21) | market price bar — buy/sell (`@0x032914`) |
| 1 | (143,118,81,60) | dock (docked ships) |
| 2 | (72,118,70,51) | dock left-centre zone (ships by sail-state) |
| 3 | (1,118,70,51) | dock far-left zone |
| 4 | (224,120,96,59) | in-port recruit/unit list panel (step-7 `func_031AFA`) |

(The `(306,179)` right readout is inside the id-0 strip; its own click-id `0xB`
appears in the deeper dispatch. Exit-button rect not in this `@0x032034` block — TBD.)

## 10. Status — verified vs remaining
- **VERIFIED (B):** all 9 composer steps + every trampoline resolved to a named
  sub-renderer; market bar (twin of colony) + **trade handler `@0x032914`** (boycott
  block + sell-confirm substitution); dock/ship geometry (6 slots, x=147+slot·12,
  y=165; status-row Y by sail-state); **3 right-side buttons** (row0 RECRUIT / row1
  PURCHASE / row2 TRAIN, each chooser keyed); **hit-test rects** (`@0x032034`, ids
  0–5); **banner fields** (nation+season `[0x538C]`+year `[0x538A]`+tax `PowerRecord+0x01`);
  gold field (`PowerRecord+0x2A`, header); `(306,179)` is a caption not gold.
- **Runtime-only / remaining (NOT guessed):** (a) banner & gold blit pixel x/y (runtime
  text-box / menu chrome); (b) the `[0x2F5E]`/`[0x2DD0]` heap string contents; (c) the
  dock caption id↔sail-state map (captions not literal pushes in `func_0314DC`); (d) the
  Exit-button paint origin. The composer steps 6/7 are now resolved: step 7
  `func_031AFA` = the right-side in-port recruit/unit list panel `(224,120,96,59)`
  (iterates units of type `0x0D..0x12`); step 6 `func_0319A6` dispatches **func_0317CC**
  + **func_0318D2** (the two transaction-detail strips — their exact contents are the
  remaining trace).
