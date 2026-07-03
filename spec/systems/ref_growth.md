# REF Growth (Royal Expeditionary Force)

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Driver fully decoded (`func_03E162`, §3).

**Overall confidence:** REF count globals `USER-VERIFIED`; **the budget→force driver
`func_03E162` `BYTE_VERIFIED`** — accrual rate `(8·diff+10)·2^era`, **threshold 1800**,
composition ratios, and the `royal_money +0x22` spend; count writers
(`func_03CDA2`/`func_051EF4`, war-assembly path) `BYTE_VERIFIED`. · **Canonical
primary:** `func_03E162`; `docs/DATA_MODEL.md` (runtime-verified). Cross-ref `spec/systems/king.md`.

## 1. Purpose & behavior

Over the game the Crown accumulates a hidden **expansion budget** and uses it to
grow the **Royal Expeditionary Force** — the army deployed against the player on
a declaration of independence. The budget ticks up every turn at
`(8·diff+10)·2^era`; when it reaches **1800** a new REF unit is bought into one
of four count slots, chosen to hold the force ratios (§3, `func_03E162` —
**BYTE_VERIFIED**, superseding the earlier "undecoded threshold" note). The
REF is **exactly four unit types**: Regulars, Cavalry, Man-O-War, Artillery
(per `king.md` and `docs/DATA_MODEL.md`). The budget→unit causal link, the
threshold, and the composition selection are all byte-verified in §3.

## 2. State & data

| Address / field | Type | Meaning | Tier | Evidence |
|---|---|---|---|---|
| `DGROUP:0x53DA` | u16 | REF **Regulars** count | **USER-VERIFIED** | `docs/DATA_MODEL.md` (23 in-game) |
| `DGROUP:0x53DC` | u16 | REF **Cavalry** count | **USER-VERIFIED** | `docs/DATA_MODEL.md` (10 in-game) |
| `DGROUP:0x53DE` | u16 | REF **Man-O-War** count | **USER-VERIFIED** | `docs/DATA_MODEL.md` (5 in-game) |
| `DGROUP:0x53E0` | u16 | REF **Artillery** count (slot 3) | **USER-VERIFIED** | `docs/DATA_MODEL.md` (8 in-game) |
| `PowerRecord +0x22` | s32 | `royal_money` — King's REF budget | **RUNTIME-VERIFIED** (field+rate); meaning **RECONSTRUCTED** | `docs/DATA_MODEL.md`: English 936→1062 over 7 turns = **+18/turn** (Discoverer); still +18 at turn 65 (1188) |
| `PowerRecord +0x32`/`+0x33` | u8×2 | **`home_x`/`home_y`** (the power's spawn/arrival coords) — **NOT** a REF strength rating (corrected 2026-06-20, RULINGS) | **BYTE_VERIFIED** | read byte `@0x58D72`→UnitRecord spawn-x; writers `@0x418D0`/`@0x65CCB`/`@0x74D74`. **No stored aggregate REF strength exists** — the 4 counts are summed on demand |
| `PowerRecord +0x44/+0x45/+0x46` | u8×3 | per-power bytes — **role unresolved** (one dump write-verified as REF, another found ≠ UI); **not** the authoritative count | **CONFLICT** | `colonization-memory-map (1).md` vs `docs/DATA_MODEL.md` (RULINGS 2026-06-19) |

`royal_money` is **player-only** (other nations = 0).

**REF-location — disasm-authoritative + a two-dump conflict (2026-06-19):** the static
disasm is decisive for game logic — the budget driver `func_03E162` (and
`func_03CDA2`/`func_051EF4`) read/write the **standalone globals `0x53DA..0x53E1`**
(regulars/cavalry/manowar/artillery), so **those are the authoritative counts** the
King grows and deploys. The two runtime dumps **disagree** on `PowerRecord
+0x44/+0x45/+0x46`: `colonization-memory-map (1).md` **write-verified** them as the
REF ("zeroing removes it"), while `docs/DATA_MODEL.md`'s session found them ≠ the UI
(with `0x53DA` matching). So `+0x44..46` is a per-power field of **unresolved** role —
do not treat it as the authoritative REF. (RULINGS 2026-06-19.)

## 3. Formulas & rules

- **Starting REF (new-game init) — BYTE_VERIFIED (2026-06-20):** at
  `new_game_state_init @0x7569B` the four counts are seeded from difficulty
  `diff=[0x53A6]`:
  - Regulars `[0x53DA] = 8·diff + 15` → {15,23,31,39,47}
  - Cavalry `[0x53DC] = 5·(diff+1)` → {5,10,15,20,25}
  - Artillery `[0x53E0] = 6·diff + 2` → {2,8,14,20,26}
  - Man-O-War `[0x53DE] = 3·diff + 2` → {2,5,8,11,14}

  **This corroborates the USER-VERIFIED in-game counts (23/10/5/8) exactly at
  `diff=1`** — the same difficulty the +18/turn `royal_money` accrual implies —
  closing the "Discoverer label off-by-one" question: the observed game was at
  `diff=1` (Explorer), not Discoverer. **B.** See `spec/systems/difficulty.md` §3.
- **Budget accrual:** `+0x22 += (8·difficulty + 10)·2^(era gates)` per turn —
  **BYTE_VERIFIED** (`func_03E162 @0x3E17C`; see below). The runtime **+18/turn**
  matches `diff=1` (`8·1+10`); era gates double it at 1600/1700/1750.
- **Count writers — LOCATED (2026-06-19), and they are REF *assembly*, not a
  per-turn budget spend:**
  - `func_03CDA2` (file `0x3CDA2`) sums the four counts as the REF total
    (`[0x53DA]+[0x53DC]+[0x53E0]+[0x53DE]` @`0x3CDB3..0x3CDBE`) and **guarantees
    ≥1 Man-O-War**: if `[0x53DE]==0` (and a per-power gate byte
    `[0x53D2*0x13 − 0x6DA2]==0`) it does `INC [0x53DE]` @`0x3CDF7`. **B**
  - `func_051EF4` (file `0x51EF4`) walks the unit table for units owned by the
    power (`UnitRecord +0x01 & 0x0F`) of **type `0x12` (Man-O-War)** and, per such
    unit (after a per-unit thunk `0x181F:0x808`), does `INC [0x53DE]` @`0x52013` —
    i.e. the player's Man-O-Wars are tallied into the REF. **B**
  - **Neither writer reads `royal_money` (`+0x22`).** So the +18/turn budget is
    **not** consumed by a direct per-turn `INC` of these counts — the budget→force
    link is indirect (counts appear assembled at/around the independence
    declaration, consistent with "no REF added up to budget 1188").
- **Budget accrual + reinforcement — `func_03E162` (file `0x3E162..0x3E2E8`).
  BYTE_VERIFIED (2026-06-19).** This is the per-turn REF driver and the
  `royal_money` **consumer**:
  - **Accrual rate** (`@0x3E17C..0x3E1AC`): `rate = (difficulty[0x53A6]·8 + 10)`,
    then **doubled once per era gate** passed on year `[0x538A]` ≥ `0x640`/`0x6A4`/
    `0x6D6` (**1600 / 1700 / 1750**). I.e. `rate = (8·diff + 10) · 2^(eras)`.
    Base per difficulty = `{Disc:10, +1:18, +2:26, +3:34, +4:42}` — the **+18/turn**
    runtime observation matches `diff=1` exactly (corroborates the formula; the
    runtime "Discoverer" label is off by one in indexing). Accrual runs only
    pre-independence (top gate `[0x5382]&1`, `@0x3E172`).
  - **Accrue:** `royal_money += rate` — 32-bit at current-player `PowerRecord
    +0x22/+0x24` via `[0x84FC]` (`@0x3E1B5`).
  - **Threshold:** a new REF unit is bought **iff `royal_money ≥ 1800` (`0x708`)**
    (`@0x3E1C6` `cmp +0x22, 0x708; jae`). This is why the runtime budget reached
    **1188 with no unit added** — it had not yet crossed 1800. **B.**
  - **Composition selection** (`@0x3E1D0..0x3E21D`) — picks the slot that keeps the
    force in ratio (`[bp-8]`, default **Regulars** slot 0):
    - **Cavalry** (slot 1) if `(regulars+2)/3 > cavalry[0x53DC]` (≈ 1 cav per 3 reg);
    - **Artillery** (slot 3) if `regulars/4 > artillery[0x53E0]` (≈ 1 art per 4 reg);
    - **Man-O-War** (slot 2) if `(regulars+cavalry+artillery+5)/10 > manowar[0x53DE]`
      (≈ 1 naval per 10 land).
  - **Apply:** `inc [0x53DA + slot·2]` (`@0x3E238`) adds the unit to the chosen
    count; pre-independence it then **deducts the cost `royal_money -= 1800`**
    (`@0x3E271` `sub +0x22, 0x708; sbb +0x24, 0`) and adds a per-type value to
    `PowerRecord +0xE` from table `DGROUP:0x9408` (`@0x3E283`). Post-independence
    the add is announced instead (`@0x3E28A`). **B.**

## 4. UI

REF composition is shown in the King / independence-readiness reports (the four
counts surface in-game — that is how they were USER-VERIFIED). **Heading label
byte-cited:** the in-game string is **"Expeditionary Force"** — `LABELS.TXT`
`@MISC` body index **85** (`data_extracted/text/LABELS.full.json` `@MISC`, between
`84="Artillery In Open"` and `86="Rebels"`/`87="Tories"`; the cluster also holds
`93="FOREIGN AFFAIRS REPORT"`, `98="Military Power"`, `99="Naval Power"`,
`100="Merchant Marine"`, `111="Intervention Force"`). Per-unit REF growth is also
surfaced as the announcement **`GAME.TXT @KINGBUY`** — "King increases military
spending. {%STRING0} added to royal expeditionary force. Colonial leaders express
alarm." (`data_extracted/text/GAME.full.json` `@KINGBUY`), which is the
post-independence "announce the add" branch of the driver (`func_03E162 @0x3E28A`,
per §3). **B.** **Report screen function = `func_037A10` (overlay page 5, file
`0x037A10..0x03807D`, 1646 bytes; reseg `disasm_overlay_reseg/page_05.asm`).** It is
the only overlay draw fn that reads all four counts `0x53DA/0x53DC/0x53DE/0x53E0`
and is invoked from the report dispatcher (`func_0235D6` p1 / `func_02BC72` p2 via
thunk `0x191F:0x03FE`). Layout, all BYTE_VERIFIED: full-screen panel `(x=0, y=0,
w=0x140=320, h=0xC8=200)` opened `@0x038049` (`push 0; push 0x140; push 0xC8`). Text
cursor = local `[bp-0x56]` X-anchor `=4` (`@0x037A49`) and `[bp-0x5A]` running-Y
`=0x19=25` (`@0x037A4E`), advanced per row by the active-font cell height
`es:[ [0x89E] ]` (font descriptor far-ptr) plus block metrics `es:[ [0x83E]+0x610 ]`.
The four counts are drawn as **one centred icon+value row**: enqueued by
`func_0033F2` (thunk `0x181F:0x222`, role 'ENQUEUE row item' — stores value→`[0x2CCE+]`,
icon/colour→`[0x2CF4+]`) at `@0x037E1C..0x037E57` in order **Regulars `[0x53DA]`,
Cavalry `[0x53DC]`, Artillery `[0x53E0]`, Man-O-War `[0x53DE]`** with per-unit-type
palette/icon bytes from globals `[0x5286]/[0x52A2]/[0x52CC]/[0x532E]`, then flushed
centred by `func_003104` (thunk `0x181F:0x22C`, role 'FLUSH centred icon+value row')
at `x=[bp-0x56]=4, width=bx=0x12C=300, y=[bp-0x5A]` (`@0x037E62`); icon sprite
widths read from the metrics table `es:[ [0x83E]+si+0x3E ]` for the centring math.
Unit-type **labels** come from the DGROUP table at `0x9652` (stride 6, 4 entries:
`[i*6 - 0x69AE]`, `@0x037FE7`) appended via `func_002992` (thunk `0x181F:0x16E`,
'string fetched from a table'); the heading uses the same overlay text builder, not a
literal `PUSH 85`. **The four count VALUES are live game state:** read from globals
`[0x53DA/0x53DC/0x53DE/0x53E0]`, rendered by `func_037A10 @0x037E1C..0x037E72` as a
centred icon+value row at the (x=4,w=300,y-cursor) above in the active UI font
(descriptor `[0x89E]`) — per-game state, not a static constant; the source globals,
renderer, format, and placement are now fully byte-cited. The only residual
runtime-only datum is the exact centred pixel-X (computed at flush time from the
summed icon/value widths via `func_003104`) and the literal font face — both fully
specified by the cited code/globals. **B.**

## 5. Evidence

- `docs/DATA_MODEL.md` — REF globals `0x53DA/0x53DC/0x53DE/0x53E0`
  (USER-VERIFIED), `+0x22` royal_money (+18/turn), `+0x32`/`+0x33` home_x/home_y
  (**NOT** a REF strength rating — corrected 2026-06-20, RULINGS; see the §state
  table line for `+0x32`), REF-location conflict ruling. **B / runtime**
- `spec/systems/king.md` — REF = exactly 4 unit types; budget meaning. **B**
- `func_03CDA2` (file `0x3CDA2`) — REF total = sum of the 4 counts; ≥1 Man-O-War guarantee (`INC [0x53DE]` @`0x3CDF7`). **B**
- `func_051EF4` (file `0x51EF4`) — tallies the power's `unit_type 0x12` (Man-O-War) units into `[0x53DE]` (`INC` @`0x52013`). **B**
- `func_03E162` (file `0x3E162`) — REF budget driver: accrual `(8·diff+10)·2^era` (`@0x3E17C`), threshold **1800** (`@0x3E1C6`), composition ratios 3:1 reg:cav / 4:1 reg:art / 10:1 land:naval (`@0x3E1D0`), spend `+0x22 -= 1800` (`@0x3E271`). **B**
- `new_game_state_init` (file `@0x7569B`) — starting REF counts seeded from
  difficulty: `8·diff+15 / 5·(diff+1) / 6·diff+2 / 3·diff+2` (reg/cav/art/manowar);
  reproduces the 23/10/5/8 in-game counts at `diff=1`. **B**
- `docs/GAME_MANUAL.md` — REF grows over the game, deployed on independence. **R**

## 6. Open questions

1. ~~Trace the writer of `0x53DA..0x53E0`.~~ **Done 2026-06-19** — `func_03CDA2`,
   `func_051EF4`, and the **driver `func_03E162`** (accrual + 1800-threshold spend +
   slot selection). **Royal-money consumer fully resolved.**
2. ~~**Difficulty scaling** of the accrual.~~ **Done** — `(8·diff+10)·2^(era gates)`
   (`func_03E162 @0x3E17C`).
3. ~~**Slot selection.**~~ **Done** — ratio rules 3:1 reg:cav, 4:1 reg:art, 10:1
   land:naval (`func_03E162 @0x3E1D0`).
4. ~~The per-power gate byte `[0x53D2·0x13 − 0x6DA2]`.~~ **Resolved 2026-06-20** —
   `DGROUP:0x925E` is the 3rd byte of a **0x13-stride per-power REF count record**
   (`0x925C/0x925D/0x925E`), used arithmetically as troop strength (`@0x5B99E`), not
   an active/surrendered flag (`func_03CDA2 @0x3CDE8` accrues only if count-C==0). Its
   write/init path is **not present in the committed image (verified-negative,
   2026-06-25):** every access to the record bytes `0x925C/0x925D/0x925E` (reached
   via `IMUL bx,[0x53D2],0x13` then `[bx-0x6DA4/-0x6DA3/-0x6DA2]`) across all
   disassembled code is a **read or compare** — `func_03CDA2 @0x3CDED` (cmp -0x6DA2);
   `func_051EF4 @0x52042/@0x5204B` (mov), `@0x520BE/@0x520CA` (cmp -0x6DA3),
   `@0x52132/@0x5213E` (cmp -0x6DA4); `@0x5B99E/@0x5B9D5` (mov), `@0x5B8C7/@0x5BA4B`
   (cmp); plus orphan reads `@0x2F29B,@0x39A9F,@0x39AA5,@0x3DF31,@0x3DF37,@0x4E7E3,@0x4E85A,@0x55E19,@0x55E3F,@0x58ABC`.
   **No MOV-destination / INC / DEC to these bytes exists** (write opcodes 0x88/0xC6/0xFE
   against `5C 92`/`5D 92`/`5E 92` return zero matches), and no code loads `0x925C` as an
   immediate base. The writer is therefore in an **undisassembled overlay** (or a block
   BSS-init) and remains **BLOCKED** — the per-power record is read-only in committed evidence.
5. ~~`PowerRecord +0xE` per-type value + `+0x32` strength rating.~~ **Resolved
   2026-06-20** — `+0x32` is **`home_x`** (spawn coord), not a strength rating (no
   aggregate exists; RULINGS). The `+0xE` value (`@0x3E283 add [bx+0xE],[idx−0x6BF8]`
   from `DGROUP:0x9408`) reads a **per-power tally that is RECOMPUTED at runtime — not a
   static constants table, and no memory dump is needed to understand it** (corrected
   2026-06-20). `0x9408` is one of the per-power statistics tables (alongside `0x9298`
   colony-count, `0x9410`, `0x9418`): the **stats-reset function `@0x42138`** zeroes all
   of them per power (`mov [idx−0x6BF8],0` `@0x42155`), then a **unit-scan loop**
   re-increments `0x9408[power]` per qualifying unit (`inc [idx−0x6BF8]` `@0x4229F`,
   gated on unit-type `[+0x3146]`). So the value = a derived per-power military tally;
   it is BSS-zero in the *static image* only because it is computed from live unit state
   — the computing code is byte-verified, so the semantics are fully recoverable.
