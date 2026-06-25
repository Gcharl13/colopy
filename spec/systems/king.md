# King & Royal Taxation

> **Layer 2 — Specification.** Built from PRIMARY data only (see `/METHODOLOGY.md`
> → "Primary data is the decider"). Tiers: `BYTE_VERIFIED` / `ANCHOR_VERIFIED` /
> `RECONSTRUCTED` / `TBD`. **Worked-example spec** — copy its shape and its
> discipline (every number read from the bytes, not from a secondary doc).

**Overall confidence:** state layout + tax-change formula + **tax-pretext selection**
+ **REF-growth threshold (now in `ref_growth.md`)** `BYTE_VERIFIED`; **tax-revenue loop `BYTE_VERIFIED`** (sale×tax%/100 → REF fund +0x22).
**Last updated:** 2026-06-19.
**Primary evidence:** `code/VICEROY/disasm/func_034AE0_unknown.asm`,
`func_0349F4_unknown.asm`; `docs/DATA_MODEL.md` (runtime-verified);
`data_extracted/text/GAME_sections.json`.

## 1. Purpose & behavior

The Crown periodically raises the player's **tax rate** (a percentage taken from
European sales) under escalating pretexts. The player may **accept** (kiss the
pinky ring) or **refuse** with a **Tea Party**, which boycotts one good. The
Crown also maintains a **Royal Expeditionary Force (REF)** that grows over the
game and is deployed if the player declares independence.

## 2. State & data layout

PowerRecord base `DGROUP:0x8808`, **stride 316 (0x13C)**, 4 European powers;
active record via far ptr `DGROUP:0x84FC`. REF counts are **separate globals**,
not PowerRecord fields.

| Address / field | Type | Meaning | Tier | Evidence |
|-----------------|------|---------|------|----------|
| `PowerRecord +0x01` | u8 | `tax_pct` (0..) | **BYTE_VERIFIED** | `func_034AE0` reads `[bx+1]`; `docs/DATA_MODEL.md` |
| `PowerRecord +0x2A` | u32 | `gold` (player treasury) | **BYTE_VERIFIED** (runtime) | `docs/DATA_MODEL.md`: write-back matches UI (3552/4032) |
| `PowerRecord +0x22` | s32 | **Royal/REF fund.** Per turn it accrues `(diff*8+10)` (doubled once per era as the year `[0x538A]` passes 1600/1700/1750); at diff 1 that is 8+10=**18/turn**, matching the runtime observation. When the fund reaches **0x708 (1800)** the Crown buys one REF unit and subtracts 0x708. | **BYTE_VERIFIED** | `func_03E162` @0x3E181/@0x3E18A/@0x3E1B5 (accrue), @0x3E1C6 (gate `>= 0x708`), @0x3E271 (`SUB [bx+0x22],0x708`); `docs/DATA_MODEL.md`: English 936→1062 over 7 turns |
| `DGROUP:0x53DA` | u16 | **REF Regulars** | **USER-VERIFIED** | `docs/DATA_MODEL.md`: 23 matches in-game |
| `DGROUP:0x53DC` | u16 | **REF Cavalry** | **USER-VERIFIED** | `docs/DATA_MODEL.md`: 10 matches in-game |
| `DGROUP:0x53DE` | u16 | **REF Man-O-War** | **USER-VERIFIED** | `docs/DATA_MODEL.md`: 5 matches in-game |
| `DGROUP:0x53E0` | u16 | **REF Artillery** (slot 3) | **USER-VERIFIED** | `docs/DATA_MODEL.md`: 8 matches in-game |
| `DGROUP:0x538E` | u16 | global **turn counter** | **BYTE_VERIFIED** | read by `func_034AE0` (`IDIV 0x190`) |
| `DGROUP:0x53A6` | u8 | difficulty / current player (0..4) | **BYTE_VERIFIED** | read by `func_034AE0`, `func_0349F4` |

> **The REF is exactly these 4 unit types** (Regulars, Cavalry, Man-O-War,
> Artillery). A prior draft claimed "6 units incl. Dragoons & Frigates at
> PowerRecord +0x44" — that was wrong (sourced from a now-deleted secondary doc)
> and is removed. Dragoons/Frigates exist in `@UNIT` but are not REF.

## 3. Formulas & rules

**Tax-raise attempt — `func_034AE0` (file `0x034AE0`, 100 bytes). BYTE_VERIFIED,
read instruction-by-instruction:**
```
if (tax_pct <= 1) return;                       // 034AE8 CMP [bx+1],1 / JLE
delta       = (([0x53A6] & 0xFE) << 1) + 4;     // 034AEE..034AF6 (AND/SHL/ADD)
turn_factor = ([0x538E] / 0x190) + 1;           // 034AFC..034B07 (IDIV 400, INC)
candidate   = delta * turn_factor;              // 034B08..034B0D (IMUL)  [byte used]
if ((candidate + 5) >= tax_pct) return;         // 034B10..034B15 CMP/JGE
if (tax_pct <= candidate) {                      // 034B1A CMP/JLE → raise path
    roll = random_int(1, [0x53A6] + 1);         // 034B25..034B28 LCALL 0x181F:0x4D4
    if (roll - 1 == 0) return;                  // 034B30 DEC/JE → no raise this turn
}
show_king_message();                            // 034B33..034B41 LCALL 0x181F:0x998
```
So each turn the Crown computes a difficulty- and turn-scaled `candidate` tax and,
past a gate plus a difficulty `random_int` roll, raises it and shows the demand.

**Tax-level threshold = 60 (`0x3C`) — `func_0349F4` (file `0x0349F4`).
BYTE_VERIFIED:**
```
... if (tax_pct < 0x3C) return;   // 034A1B CMP byte[bx+1],0x3C / JL
    ... else show_message([0x1084]);
```
`0x3C` = **60** is a *tax-level gate* (branches king message/flow when
`tax_pct >= 60`) — **not** the cap.

**Tax hard clamp = 75 (`0x4B`) — `func_034318` (file `0x03434C..0x034365`).
BYTE_VERIFIED:**
```
[bx+1] += delta;                  // 03434C ADD [bx+1],al    (apply raise to PowerRecord+0x01 tax_pct)
if ([bx+1] > 0x4B) [bx+1] = 0x4B; // 03434F CMP [bx+1],0x4B  (raw 80 7F 01 4B); clamped store @034364
```
This **resolves the 60-vs-75 question**: 75 is the hard cap on `tax_pct` (matches
the manual), applied at the write-site; 60 is an independent message gate. Both
numbers are byte-verified and serve distinct roles.

**Tax revenue on European sales — BYTE_VERIFIED** (2026-06-20, sell routine
`@0x32A44..0x32AA2`). When the player sells a good in Europe:
```
gross = sale_value (price helper func_03245C)            # [bp-0x52]
tax   = gross × tax_rate / 100                            # tax_rate = PowerRecord +0x01;
                                                          # ×: 0xD1D:0xF60, ÷100: 0xD1D:0xEC6  @0x32A64/0x32A6B
net   = gross − tax                                       # [bp-0x5C]
PowerRecord.gold (+0x2A) += net    # via add_gold helper 0x181F:0xABA @0x32A82 (clamp [0, 999999])
PowerRecord +0x22       += tax     # @0x32A92 add/adc — the KING's cut feeds the royal/REF fund
PowerRecord +0x26       += net     # @0x32A9C add/adc — cumulative European-sales tally
```
So **the King's tax on every European sale = `sale × tax% / 100`, and it accrues to
the royal expeditionary-force fund `PowerRecord +0x22`** (the same fund the REF
buys units from, `ref_growth.md`) — the in-fiction "your taxes pay for the army
that will crush you." **B.**

**Tax-raise pretext selection — BYTE_VERIFIED** (`func_036138`, the per-turn tax-demand
driver + pretext message builder). **Cadence** (`@0x36150..0x361BA`): nothing before
**turn 30** (`[0x538E] ≥ 0x1E`); then a demand fires only when `turn % interval == 0`,
where `interval` starts **18** and shrinks to **15 / 12 / 9** as the year `[0x538A]`
crosses **1600 / 1700 / 1750** (`@0x3615A..0x36180`), further reduced by a human-player
difficulty term `(diff−2)` (`@0x36193`). A demand is also skipped once `tax > 85`
(`@0x361C3`).

The pretext is then chosen by a composite **grievance/severity score** `[bp-0x52]`
(`@0x361CC..0x36221`):
```
sev = random_int(1, 1000)
    + (2·rebel_sentiment[0x53D0] − tax) · 5      # @0x361F9..0x36208
    + gold_term(gold +0x2A, 100)                  # @0x361EA (0xD1D:0xEC6)
    + per_player_const[0x9410 + player]           # @0x3620E
    + turn / 30                                    # @0x36216
```
escalating historically by `sev` threshold:

| Severity (`[bp-0x52] <`) | Pretext key | handle | extra | site |
|--------------------------|-------------|--------|-------|------|
| `0x28A` (and `[0x53A7] < 0x1E`) | **`@KINGWIFE`** (royal wedding) | `0x1155` | bumps `[0x53A7]` | `@0x362C7` |
| `0x3B6` | **`@KINGWAR`** | `0x1166` | `random_int(1,8)` war no. | `@0x362FA` |
| `0x44C` | **`@KINGNAVACT`** (Navigation Acts) | `0x1178` | `random_int(3,4)` | `@0x36348` |
| else | **`@KINGSTAMPACT`** (Stamp Act) | `0x1183` | `random_int(5,8)` | `@0x36371` |

The chosen case/severity number `[bp-0x56]` is then written to the current
`PowerRecord +0x10` (`@0x36387`). So higher unrest/tax/gold raises the severity and
the stated reason escalates (wedding → war → Navigation Acts → Stamp Act). **B.**
`@KINGTAX`/`@KINGRAISE`/`@MERCANTILISM`/`@PURCHASETAX` are the surrounding tax-dialog strings.

## 4. UI layout — "what is drawn where"

The demand surfaces as the **King speech-bubble dialog**:
- **Message body:** `GAME.TXT @KINGTAX` (present in `GAME_sections.json`;
  cataloged at line 1622). The dispatcher substitutes the raise amount and the
  new rate. **BYTE_VERIFIED** key.
- **Options:** `@TAXOPTIONS` — *Kiss the pinky ring* (accept) / *Hold a [Good]
  Party* (refuse → boycott). Keys `@TAXOPTIONS`, `@TEAPARTY` confirmed in primary
  data. **BYTE_VERIFIED** keys.
- **Portrait:** `KING.SS` (standing king) for the routine demand; `KING1.SS`
  (mocking king + bound colonist) is a different sub-variant. **ANCHOR_VERIFIED**
  via `docs/KING_AND_CINEMATIC_AUDIT.md` (asset attribution, not raw bytes).
- Dialog geometry follows the shared framework — `docs/DIALOG_GEOMETRY.md`,
  `docs/POPUP_TEMPLATE_AUDIT.md`.

## 5. Evidence (citations)

- `code/VICEROY/disasm/func_034AE0_unknown.asm` — tax-raise attempt, read line by
  line (delta/turn-factor/IMUL/roll). **B**
- `code/VICEROY/disasm/func_0349F4_unknown.asm` — `CMP [bx+1],0x3C` (=60 gate). **B**
- `func_034318` (file `0x03434C..0x034365`) — `CMP [bx+1],0x4B` (=75 hard clamp on `tax_pct`), raw `80 7F 01 4B`. **B**
- `docs/DATA_MODEL.md` — PowerRecord base/stride; `tax_pct +0x01`, `gold +0x2A`,
  `+0x22` (+18/turn); REF globals `0x53DA/0x53DC/0x53DE/0x53E0` (USER-VERIFIED);
  globals `0x538E`, `0x53A6`, `0x84FC`. **B / runtime**
- `data_extracted/text/GAME_sections.json` — `@KINGTAX @KINGRAISE @KINGNAVACT
  @KINGSTAMPACT @KINGWAR @KINGWIFE @MERCANTILISM @PURCHASETAX @TAXOPTIONS
  @TEAPARTY` exist. **B**
- `docs/KING_AND_CINEMATIC_AUDIT.md` — portrait/option attribution. **A**

## 6. Confidence summary

- **Solid (B):** PowerRecord tax/gold offsets; REF = 4 globals; turn counter &
  difficulty globals; the tax-raise formula; the 60 threshold; the pretext &
  option message keys.
- **Runtime/Reconstructed:** the `KING.SS` portrait attribution. (The `+0x22`
  "REF budget" meaning is no longer inferred — it is BYTE_VERIFIED as the Royal/REF
  fund: `func_03E162` accrues to it and spends it at the 0x708 threshold.)
- **TBD:** Tea-Party boycott bookkeeping (per-good boycott field + lift mechanism).
  (The tax-revenue loop, REF-growth spend threshold `func_03E162`, and pretext
  selection `func_036138` are now BYTE_VERIFIED — see §3 and Open-Questions 2/3/4.)

## 7. Open questions (TBD) → feeds `spec/BACKLOG.md`

1. ~~**60 vs hard cap.**~~ **Resolved 2026-06-18:** `tax_pct` is hard-clamped to
   **75** (`0x4B`) at `func_034318` `0x03434F`; `0x3C`=60 (`func_0349F4`) is a
   separate message gate. Both `BYTE_VERIFIED`.
2. ~~**REF-growth threshold.** What spends `+0x22` (+18/turn) to add a REF unit at
   `0x53DA..0x53E0`?~~ **Resolved — `func_03E162` (@0x3E162..0x3E2E9).** Each turn it
   accrues `(diff*8+10)` into `PowerRecord +0x22` (era-doubled at years 1600/1700/1750),
   gates on the fund reaching **0x708 (1800)** (@0x3E1C6 `CMP [bx+0x22],0x708`/JAE), then
   picks the most under-strength REF type by ratio (Cavalry vs `([0x53DA]+2)/3` @0x3E1D5;
   Man-O-War vs `([0x53DA]+[0x53DC]+[0x53E0]+5)/10` @0x3E203; Artillery vs `|[0x53DA]|/4`
   @0x3E1EB), increments `[bx*2 + 0x53DA]` (@0x3E238 `INC [bx+0x53da]`), and subtracts
   0x708 from the fund (@0x3E271 `SUB [bx+0x22],0x708`). **BYTE_VERIFIED.**
3. ~~**Tax-revenue loop.** Byte-trace the European-sale tax cut (the per-good
   computation) from a primary function.~~ **Done (in §3, 2026-06-20)** — sell routine
   `@0x32A44..0x32AA2`: `tax = sale × tax% / 100`, `net` accrues to `gold +0x2A` and the
   tax accrues to the royal/REF fund `PowerRecord +0x22` (@0x32A92 add/adc). **B.**
4. ~~**Pretext selection.** Which condition picks `@KINGNAVACT` vs `@KINGSTAMPACT`
   vs `@KINGWAR` etc.~~ **Done (in §3, re-verified 2026-06-20)** — `func_036138`
   chooses by the composite severity score `[bp-0x52]` (`< 0x28A` `@KINGWIFE`, `< 0x3B6`
   `@KINGWAR`, `< 0x44C` `@KINGNAVACT` +`random(3,4)`, else `@KINGSTAMPACT` +`random(5,8)`);
   magnitude → `PowerRecord +0x10`. The re-trace independently confirms `[0x53D0]` in the
   score = rebel-sentiment/SoL (cross-ref `revolution.md`). **B.**
5. **Tea-Party boycott.** Which field holds the per-good boycott bitmask; how
   back-tax payment / Jakob Fugger clears it.
