# King & Royal Taxation

> **Layer 2 — Specification.** Built from PRIMARY data only (see `/METHODOLOGY.md`
> → "Primary data is the decider"). Tiers: `BYTE_VERIFIED` / `ANCHOR_VERIFIED` /
> `RECONSTRUCTED` / `TBD`. **Worked-example spec** — copy its shape and its
> discipline (every number read from the bytes, not from a secondary doc).

**Overall confidence:** state layout + tax-change formula `BYTE_VERIFIED`;
revenue loop + REF-growth threshold `TBD`. **Last updated:** 2026-06-18.
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
| `PowerRecord +0x22` | s32 | a per-player counter; grows **+18/turn** (Discoverer). Interpreted as a "royal/REF budget" but the spend rule is undecoded. | field+rate **RUNTIME-VERIFIED**; *meaning* **RECONSTRUCTED** | `docs/DATA_MODEL.md`: English 936→1062 over 7 turns |
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
`0x3C` = **60**. The game manual states a 75% cap; the **bytes use 60** as the
verified tax-level gate (per the trust hierarchy, EXE bytes win for numbers; 75
is recorded as manual design-intent / possible patch difference). Whether 60 is
the hard *clamp* or a "tax is high" branch is not provable from this function
alone — see §7.

**Tax revenue on European sales:** `TBD`. No primary trace read yet; the
per-good loop is not byte-verified here (do not import the old reconstructed
formula). → `spec/BACKLOG.md`.

**Tax-raise pretext keys** (all confirmed present in primary
`data_extracted/text/GAME_sections.json`, **BYTE_VERIFIED** that the keys exist;
the selection logic among them is `TBD`):
`@KINGTAX @KINGRAISE @KINGNAVACT @KINGSTAMPACT @KINGWAR @KINGWIFE @MERCANTILISM
@PURCHASETAX`.

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
- `code/VICEROY/disasm/func_0349F4_unknown.asm` — `CMP [bx+1],0x3C` (=60). **B**
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
- **Runtime/Reconstructed:** `+0x22` field (+18/turn verified; "REF budget"
  meaning inferred); the `KING.SS` portrait attribution.
- **TBD:** tax-revenue loop, REF-growth spend threshold, exact pretext selection,
  the 60-vs-hard-cap semantics, Tea-Party boycott bookkeeping.

## 7. Open questions (TBD) → feeds `spec/BACKLOG.md`

1. **60 vs hard cap.** Is `0x3C` in `func_0349F4` the tax clamp or a "high tax"
   message gate? Find the write site that clamps `tax_pct` and confirm the max.
   Reconcile with the manual's 75.
2. **REF-growth threshold.** What spends `+0x22` (+18/turn) to add a REF unit at
   `0x53DA..0x53E0`? Trace the writer of those globals.
3. **Tax-revenue loop.** Byte-trace the European-sale tax cut (the per-good
   computation) from a primary function; do not reuse the deleted reconstruction.
4. **Pretext selection.** Which condition picks `@KINGNAVACT` vs `@KINGSTAMPACT`
   vs `@KINGWAR` etc. — trace the dispatcher feeding `@KINGTAX`.
5. **Tea-Party boycott.** Which field holds the per-good boycott bitmask; how
   back-tax payment / Jakob Fugger clears it.
