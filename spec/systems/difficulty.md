# Difficulty Levels

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Details pending — breadth pass.

**Overall confidence:** 5 level names + global byte `BYTE_VERIFIED`; **a broad set
of per-level modifier formulas `BYTE_VERIFIED`** (REF size, combat handicap,
native attitude, diplomacy demands — see §3); some economy/king touch points still
`R`.
**Canonical primary:** `data_extracted/text/NAMES_sections.json` (@DIFFICULTY),
`docs/DATA_MODEL.md` (DGROUP `0x53A6`).

## 1. Purpose & behavior
A difficulty level chosen at setup adjusts many factors to make the game easier
or harder (`docs/GAME_MANUAL.md`). Five levels, ascending:

| Idx | Name | Manual gist |
|-----|------|-------------|
| 0 | Discoverer | easiest; novice players |
| 1 | Explorer | opponents stronger/smarter, natives less friendly |
| 2 | Conquistador | enemies substantially more aggressive |
| 3 | Governor | opponents evenly matched with player |
| 4 | Viceroy | hardest; winnable but not consistently |

Names `BYTE_VERIFIED` from `@DIFFICULTY`; ordering matches manual.

## 2. State & data
- `@DIFFICULTY` (`NAMES_sections.json`): 5 level strings (above). **BYTE_VERIFIED**.
- **DGROUP `0x53A6`** — byte holding "difficulty / current player (0..4)"
  (`docs/DATA_MODEL.md:280`, BYTE_VERIFIED via king-tax + SMITE byte-traces;
  also listed `docs/ARCHITECTURE.md:108`). **BYTE_VERIFIED**.
  > Note: this single byte is documented as serving both "current player" and
  > "difficulty" roles; disambiguate at the read site before relying on it.

## 3. Formulas & rules
`diff` = byte `[0x53A6]` (0=Discoverer … 4=Viceroy). Most sites gate the
difficulty term on `AIPersonality.controller` (`[idx·0x34 + 0x543F]`): the human
branch carries the `diff` term while the AI branch uses a fixed constant — i.e.
**the difficulty term is a human handicap**, not a symmetric scaler. (Caveat:
`0x53A6` is dual-role — also "current player"; the sites below were confirmed to
be genuine difficulty arithmetic, not player indexing.)

### Byte-verified per-level formulas (2026-06-20 trace; high confidence)
| Mechanic | Formula | Site |
|---|---|---|
| **Starting REF — regulars** | `[0x53DA] = 8·diff + 15` (15/23/31/39/47) | `new_game_state_init @0x7569B` |
| **Starting REF — cavalry** | `[0x53DC] = 5·(diff+1)` (5/10/15/20/25) | `@0x7569B` |
| **Starting REF — artillery** | `[0x53E0] = 6·diff + 2` (2/8/14/20/26) | `@0x7569B` |
| **Starting REF — man-o-war** | `[0x53DE] = 3·diff + 2` (2/5/8/11/14) | `@0x7569B` |
| **Combat human handicap** | attacker `[bp-0x90] += (4−diff)`; defender `[bp-0xa6] += (4−diff)` (human only) → fed to `odds=ATK/(ATK+DEF)` | land decider `func_05CA7E @0x5CE35`/`@0x5CE54` |
| **Generic combat base** | `strength_base [bp-0x34] = diff + 5` | `@0x3F005` |
| **Native attitude (human)** | `2·(diff+3) + tribe[+2] + tribe[+5] − prior`; threshold `0x41` | native eval `@0x46500` |
| **Native attitude (AI)** | `tribe[+2] + tribe[+5] − diff + 12 − prior`; threshold `0x32` | `@0x46538` |
| **Native per-power seed** | AI powers: `tribe[+0x46 + power·2] = rand(0..13) + 2·diff` | tribe init `func_065D26 @0x65DCE` |
| **AI war/refusal grace** | `10·(10−diff)` turns (100/90/80/70/60) | diplomacy `@0x58374` |
| **AI tribute/demand value** | `value · 10·(diff+8)/100` (×0.8…×1.2) | `@0x583A0` |
| **AI demand surcharge** | `+= 500·(diff+1)` | `@0x5842B` |
| **AI/native action prob** | `random_int(1000) < 200·diff + 100` (10%…90%) | `@0x4A73D`, `@0x58315` |
| **Easy-mode double starting units** | at `diff ≤ 1` the human reruns the starting-unit placement a 2nd time (double Caravel+Pioneer+Soldier, stamped Veteran) | new-game setup `func_0755CC @0x0758F5`/`@0x075961` |

Net effect of the human-side terms: higher difficulty → larger Royal Expeditionary
Force at independence, less combat padding for the player, worse native attitude,
and more aggressive/expensive AI diplomacy. **B** (the rows above).

### Touch points consistent with the same idioms (instruction-verified 2026-06-25 — promoted R→B)
- **Native gift/treasure:** reward `2·diff+15` (`@0x4A05A`); `10·(diff+rand)`
  (`@0x4A0C2`); gate `diff+1` + cap `8−diff` (`@0x4A2A9`); native price floor
  `5·diff+50` (`@0x5C976`). (CHIEFKILL roll bound `(8−diff)<<scout` `@0x4A84D` is
  already **B** in `natives.md`.)
- **Native aggression:** attack chance `random_int((5−diff)·2)` (`@0x48697`);
  raid severity family in `native_raid_outcome_dispatch` (`@0x5BF1A`…`@0x5C09E`);
  native-war escalation `(diff+1)/100` (`@0x3F0B2`).
- **King / REF / mercenaries:** REF budget `8·diff+10` (`@0x3E17C`); merc cost
  `((diff+3)·2+rand)·100·troops` (`@0x3E558` — confirms `mercenary.md`); King
  reinforcement `+ diff + 1` (`@0x3CC06`); King merc stock `100·(10−diff)`
  (`@0x529FC`).
- **Economy / immigration / score:** immigration cost `(8−diff)/8` (`@0x35E60`,
  cross-ref `national_powers.md` English ×2/3); rival-immigration bonus
  `100·(diff+1)` (`@0x35FFB`); production base `diff+5` (`@0x8AFF`); score
  multiplier `diff+4 (+1 if≥3, +1 if≥4)` (`@0x3AA0A`, already **B** in scoring);
  FF score penalty `ff_count·(−1−diff)` (`@0x3A4B9`).

### Non-mechanics (excluded — do not cite as difficulty modifiers)
- `g_king_galleon_displaynum[diff]` (base `−0x7C6C`, index `diff·2`) is **UI
  salutation text only** (15 push sites incl. `@0x2F2CC`, `@0x34B7E`, `@0x73031`);
  confirms `spec/BACKLOG.md` galleon-fee correction.
- `@0x705D2`/`@0x706A3`/`@0x7071E` = difficulty-**selection** setup screen (write
  `0x53A6`, `(diff+4) mod 5` wrap); `@0x47968`/`@0x70378` = dead read / player-index
  compare.

### Manual-sourced (R — byte-confirm pending)
- Indian Destruction Penalty = `−(diff + 1)` per native settlement destroyed
  (`docs/GAME_MANUAL.md`). **R**.
- **Tory production-penalty threshold = `10 − diff`** (10 at Discoverer … 6 at
  Viceroy, `docs/GAME_MANUAL.md:3528`): when a colony's Tory count reaches this
  number, all production there drops by 1. **Value BYTE_VERIFIED:** the colony-
  production region computes `ax = 10 − diff` for a human-controlled owner
  (`mov al,[0x53a6]; sub ax,0xa; neg ax`) and a fixed **10** (or **0x32**) for AI,
  at **`@0x9D49`, `@0xA05C`, `@0x27416`** (all three same idiom, gated on
  `[bx+0x1a]<4 && [idx·0x34+0x543F]==0`). The `10−diff` value exactly matches the
  manual's 10→6, identifying this family as the SoL/Tory production thresholds.
  **B** (value); the exact site→effect binding is now **byte-resolved
  (2026-06-25)**: at **`@0x9D49`** and **`@0xA05C`** the `(10−diff)` value is used
  as an `IDIV` **divisor** of the SoL production term, then negated
  (`@0x9D7C IDIV [bp-0xe]; @0x9D7F NEG ax`; `@0xA090 IDIV [bp-0xa]; @0xA093 NEG ax`)
  — i.e. these two are the **SoL-bonus divisor**. At **`@0x27416`** the value is
  instead used as a **comparison threshold** against a count (`[bp-0x5e]`):
  `@0x27444 CMP [bp-0x62],[bp-0x5e]; JG` and `@0x27451 SHL ax,1; @0x27453 CMP
  ax,[bp-0x5e]; JG`, selecting outcome tiers `0xf/0xc/4` — i.e. `@0x27416` is the
  **threshold-comparison site** (the `count reaches 10−diff` semantics of the
  manual's Tory penalty). Note the AI constant differs by site: `0xa` (10) at
  9D49/A05C but `0x32` (50) at 27416. **B.** Cross-ref
  `spec/systems/tory_uprising.md`, `spec/systems/colony.md` (SoL production).

## 4. UI
Selected on the difficulty-selection setup screen, decoded as `func_070580 @0x070580`
(loads the **DIFFICUL.PIK** background by name: `push 0x202D ("DIFFICUL")` @0x0705A5 →
setup-PIK loader `0x181F:0x44E` @0x0705A8; if the PIK load fails it falls back to the
`@DIFFICULTY` text list-menu `lea ax,[0x2036]("DIFFICULTY")` → `0x181F:0x998` @0x0705B4,
storing `[0x53A6] = result-1` @0x0705D2). Strings = `@DIFFICULTY` (5 level names) in both
`NAMES_sections.json` and `GAME_sections.json` ("Select a Difficulty Level" header + the 5).
**Layout BYTE_VERIFIED (B):** screen is 320×200 (fill `(0,0,320,200)` @0x070611, blit
DIFFICUL.PIK @0x070623). The 5 level cells are laid out on a 3-column grid by rect helper
`func_0702C0`: for `idx = level+1`, `x = (idx mod 3)·105 + 23` (`imul ax,dx,0x69; add ax,0x17`
@0x0702DA/@0x0702DD) and `y = (idx div 3)·96 + 7` (`imul cx,bx,0x60; add ax,7` @0x0702F2/@0x0702F7,
with a `−1` row adjust when row>1 @0x0702E5); each cell is **w=90 (0x5A), h=68 (0x44)** (draw-cell
`func_070302` @0x07033A/@0x070342). Each cell is a clickable hit-rect (90×68) tested against the
mouse `[0x7E8](x)/[0x7EA](y)` by point-in-rect helper `func_004B16 @0x004B16` (call @0x070707 with
`push 0x5A; push 0x44`), which on hit sets `[0x53A6] = i`; the commit/exit zone is `click &&
mouseY<103 (0x67) && mouseX<128 (0x80)` (`func_070580 @0x07073A`). Keyboard nav wraps **mod 5**:
up `(level+4)%5` @0x070692, down `(level+1)%5` @0x0706C8, arrow scancodes matched @0x0706CC; ESC
(0x1B) exits @0x07065C. Draw-cell `func_070302` fills the cell then, when the cell is the current
selection (`cmp ax,[bp+6]` @0x07037D), draws a 1-px hollow-rectangle highlight outline
(`0x181F:0xCE` = `func_00E0A2` @0x0703AB) in a per-level ink color selected by the index switch
@0x07034A: **level 0=0x0A** (@0x07035C), **1=0x09** (@0x070362), **2=0x0E** (@0x070368),
**3=0x0D** (@0x07036E), **4=0x0C** (@0x070374).

**Cell-text source — resolved as state (B).** The 5 level-name strings the cells render are NOT
static in this screen's code; they are the 5 lines of the `@DIFFICULTY` section, parsed once at
setup into BSS line-pointer table `DS:0x8394` (5 words, base `[bx-0x7c6c]` = `[bx+0x8394]`). The
fill loop is `@0x074C99…@0x074CAE` (page 1A): the section is selected by `push 0x222b`
(="DIFFICULTY", snapshot-confirmed; `@0x074C87` → section-open thunk `0x191F:0x928` =
`func_06F8FA`), then for `idx = 0..4` (`cmp [bp-8],5` @0x074CAA) the per-line pointer returned by
section-reader thunk `0x1A1F:0xB16` (→ `func_06F8FA`) is stored `mov [bx-0x7c6c],ax` with
`bx=idx*2` (`shl bx,1` @0x074CA1, `@0x074CA3`). So slot `i` = pointer to `@DIFFICULTY` line `i` =
level name `i` (0=Discoverer…4=Viceroy). The literal names are already **B** from `@DIFFICULTY`;
the table holds per-game heap addresses bound at setup-parse — live state, not static constants.
The `[0x87C]` referenced earlier is **not a font byte**: it is read only as `LEA bx,[0x87c]`
(@0x0705B4, and ~13 other setup screens), i.e. the **menu/widget descriptor-struct base**
passed to the list-menu builder `0x181F:0x998` (@0x0705BE) for the text-fallback menu; the font is
a field set inside that builder, not an immediate in `func_070302`/`func_070580`. The clip/screen
rect globals `[0x839E..0x83A4]` and `[0x2DA8..0x2DAE]` carry the **full-screen 320×200 clip**
(live snapshot: `[0x839E]=0xC8`=200, `[0x83A0]=0x140`=320, `[0x83A2]=0`=x, `[0x83A4]`=raster ptr;
`[0x2DA8..]` the mirror set) — these are the active-surface clip descriptor set by the fill at
`@0x070608` (`push 0xC8; mov bx,0x140`)/blit, not cell-specific immediates. **B (sources cited).**

**Title/header draw — now byte-resolved (2026-06-27, binary_decode of the overlay thunk).** The
difficulty main `func_070580` calls `func_070C64` (`CALL 0x70c64` @0x070629, right after the
DIFFICUL.PIK blit @0x070623). `func_070C64` is a pure call-gate stub `LJMP 0x1a1f:0xbf2`
(@0x070C64, bytes `EA F2 0B 1F 1A`). Although `thunk_resolve.json` lacks a `1A1F:0BF2` entry, the
target is deterministic from the on-disk RTLink thunk: at file offset `0x1D1E2`
(= 0x2400 + 0x1A1F·16 + 0xBF2) the 14-byte type-A thunk is
`9A AB 0D 0D 11  EA A4 06 00 00  19 00 00 00` = `LCALL 110D:0DAB` (type-A runtime) then
`LJMP 0000:06A4` with trailer dword `0x19` (=overlay **page 25**, the difficulty/setup page). The
LJMP seg word is a load-time-patched placeholder; the page-25 code base is file `0x06FDF0`
(`overlay_pages.json` page `0x19` code_offset) — cross-checked against three KNOWN sibling thunks in
the same LJMP block (`1A1F:0B66`→`func_070580`@0x70580, `1A1F:0BE4`→`func_070060`@0x70060,
`1A1F:0B74`→`func_070A1A`@0x70A1A all imply base 0x06FDF0). Hence `0x06FDF0 + 0x06A4` =
**`func_070494` @0x070494** (the 236-byte header drawer immediately preceding `func_070580`). Inside
`func_070494`: the title string is the far pointer `[0x268a:0x268c]` (`LES bx,[0x268a]`@0x070498),
an `@LABELS`/`@MISC` heap pointer bound by `func_075FB6` (`MOV [0x268a],ax`@0x0760CB after a
section lookup `LEA bx,[0x2389]`); its first byte is the Pascal length, and **horizontal centering**
is computed `x_col = 0x14 − len/2` (`SHR al,1; SUB ax,0x14; NEG ax` @0x0704A1/@0x0704A5/@0x0704A8).
The two header lines are drawn by the centre-text-in-box helper `func_002CE0` (`0x181F:0x1C8`,
@0x0704E8/@0x07050B) with literal box anchors **x=0x17 (23)** and **w=0x44 (68)**, fed strings
fetched by `string FETCH func_002462` (`0x181F:0x22`) from string-id globals `[0x2efe]`@0x0704DA
and `[0x2f00]`@0x0704FD; the per-cell name text is drawn by `func_002BC8` (`0x181F:0x100`,
"centre-text-in-box", @0x07054D, box `(x=0x17,y=0x44,w=0x51)`). The glyph font is the default set
inside the leaf text-draw (`0x2c4a`/`0x2b38`, called from `func_002CE0`/`func_002BC8`), not an
immediate in `func_070494`. **B (binary_decode + accessor_trace; the title draw is fully pinned —
no RAM capture needed).** The title *string itself* is the `@DIFFICULTY` header ("Select a
Difficulty Level", `GAME_sections.json`) / `@MISC` "Difficulty Level" labels, already **B**.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@DIFFICULTY` (5 names). **B**
- `docs/DATA_MODEL.md:280` / `docs/ARCHITECTURE.md:108` — DGROUP `0x53A6`. **B**
- `VICEROY.EXE` `new_game_state_init @0x7569B` — starting REF (regulars/cavalry/
  artillery/man-o-war) as `8·diff+15 / 5·(diff+1) / 6·diff+2 / 3·diff+2`. **B**
- `VICEROY.EXE` `func_05CA7E @0x5CE35`/`@0x5CE54` — human combat handicap `+(4−diff)`. **B**
- `VICEROY.EXE` native eval `@0x46500`/`@0x46538` — native attitude human/AI split. **B**
- `VICEROY.EXE` diplomacy `@0x58374`/`@0x583A0`/`@0x5842B`/`@0x58315` — AI grace/demand/prob. **B**
- `docs/GAME_MANUAL.md` — level descriptions; Indian penalty. **R**

## 6. Open questions
1. ~~Byte-trace per-level modifier table.~~ **Done 2026-06-20** — REF size, combat
   handicap, native attitude, diplomacy demands, action probability all **B** (§3).
   Residual: instruction-level confirm of the §3 "touch points" subset
   (economy/king clusters). The native field `+0x46` label is **RESOLVED** (§3): it is the
   **per-power native-alarm seed** `tribe[+0x46 + power·2] = rand(0..13) + 2·diff` (`func_065D26
   @0x65DCE`, human-only gate `[bx+0x543F]==0`), not a difficulty field.
2. ~~Resolve the `0x53A6` dual role (difficulty vs current player) at read sites.~~
   **Resolved 2026-06-20 — `[0x53A6]` is the *difficulty level* (0..4), NOT current
   player.** All ~150 read sites treat it as a 0..4 value: compared against `4`
   (`@0x36637`/`@0x3AA20`/`@0x51F6A`), used with `mul` as a difficulty multiplier
   (`@0x4A73D`/`@0x58315`), written **only at new-game setup** (`@0x705D2`/`@0x706A3`/
   `@0x7071E`; default `2` `@0x7433C`). It is **never** iterated `0..3` as a per-power
   index — the **current power index is the separate global `[0x5394]`**. The "dual
   role" label in `docs/DATA_MODEL.md`/`turn_dispatch.md` is superseded. **B.**
3. ~~Confirm the score difficulty factor.~~ **Done** — `diff+4 (+1 if≥3, +1 if≥4)`
   `@0x3AA0A` (**B**, see scoring). **Indian-destruction penalty RESOLVED 2026-06-28 (B):**
   score line-item = `razed_native_count × −(1+difficulty)` (razed count = `byte[PowerRecord+0x18]`
   `@0x3A4B1`; `cx = 0xFFFF − [0x53A6]` `@0x3A4B6/@0x3A4BF`; `imul` `@0x3A4C3`; magnitudes −1 Discoverer … −5
   Viceroy), summed into the 7-term grand total `@0x3A896` (`func_039EE2`).
