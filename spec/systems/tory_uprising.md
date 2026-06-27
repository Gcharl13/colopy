# Tory Uprising (Internal Dissent During Independence)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** **uprising emitter + per-call probability gate + SoL-status (50/95/100%) cutoffs + target selection + Militia spawn (≤8 adjacent tiles) `BYTE_VERIFIED`** (2026-06-20, `func_03CAC6`/`func_02D658`). Only the WoI-loop call frequency for `func_03CAC6` is unpinned. · **Canonical primary:** `data_extracted/text/GAME_sections.json`; `tools/rtlink/event_emitters.json` (handle map).

## 1. Purpose & behavior

During the War of Independence, colonists loyal to the Crown (**Tories**) can
cause internal dissent — a **Tory uprising** — opposing the rebel cause. The
balance between **Tory** and **Rebel** (Sons of Liberty) sentiment governs
morale, production bonuses/penalties, and uprising events. **RECONSTRUCTED**
function from the manual; trigger and effects are not byte-traced.

## 2. State & data

Sentiment / uprising keys confirmed present in
`data_extracted/text/GAME_sections.json`:

| Key | Line | Note | Tier |
|---|---|---|---|
| `@TORYUPRISING` | 454 | uprising event string | **B** (key exists) |
| `@TORYMINORITY` | 396 | Tory-minority status string | **B** |
| `@TORYMAJORITY` | 397 | Tory-majority status string | **B** |
| `@REBELMAJORITY` | 394 | Rebel-majority status string | **B** |
| `@REBELUNANIMOUS` | 395 | full Rebel support string | **B** |

(Prose binding **BYTE_VERIFIED** from `data_extracted/text/GAME_sections.json` — the
five keys are **not** empty; each carries full message text and names the per-state
production effect: `@REBELUNANIMOUS` = SoL up to 100%, **+2** base production + faster
education; `@REBELMAJORITY` = SoL up to ≥50% majority, **+1** base production;
`@TORYMINORITY` = SoL down *from* 100%, colonists now gain **only +1**;
`@TORYMAJORITY` = SoL down <50%, **no** production bonus; `@TORYUPRISING` = `"Tory
uprising near %STRING0!  Parliament arms Tory Militia!"`. The `%STRING0`/`%STRING1`/
`%NUMBER0` fields bind the colony name, mother-country name, and the new SoL%. **B.**)

The **rebel fraction** that drives these states is byte-grounded: `ColonyRecord
+0xC2` = `rebel_dividend` (Sons of Liberty numerator), `+0xC6` = denominator —
e.g. 66/617 = 10.7% Sons of Liberty, RUNTIME-VERIFIED per `docs/DATA_MODEL.md`.
The Tory share is the complement.

**Uprising trigger — RESOLVED 2026-06-27 (`func_03CAC6 @0x3CAC6`, `ENTER 0x18`).** There is **no
standalone SoL-percent threshold** ("if SoL < X → uprising") — that earlier TBD is **answered
negative**. Instead: (1) a **per-call probability gate** `random_int(0, diff+1)` (`@0x3CAD0`,
`diff=[0x53A6]`); if the roll is `0` the function returns (so it fires with prob `(diff+1)/(diff+2)`
— more likely on harder levels). (2) It then scans the rebel power's colonies (`[0x539E]` count) and
picks the one with **maximum Tory strength**, where **`tory_strength = pop[+0x1F]·(100−SoL%)·2/100 +
diff + 1`** (`@0x3CBE6`; SoL% via `0x181F:0xC86`), **reduced by defending rebel units** on/around it
and requiring ≥1 free adjacent tile. So the Sons-of-Liberty fraction enters **only through the
magnitude** (lower SoL → more militia), not a fire/no-fire threshold. (3) Spawns **Tory-Militia**
(unit type `[0x53D2]`) on free adjacent tiles, **count = the strength value counted down** (not a
fixed 8), with two random per-militia upgrade gates; marks the colony `[+0x1C]|=1` so it cannot
re-fire, and **suppresses silently** if no tile was free. **B** (per-call gate + strength formula +
spawn); the **caller cadence** (how often the WoI loop invokes `func_03CAC6`) and the numeric
`[0x53D2]` militia type id remain **TBD**.

## 3. Formulas & rules

- **Sentiment:** Sons-of-Liberty % = `+0xC2 / +0xC6` (per colony).
  **RUNTIME-VERIFIED** (field meaning).
- **Majority/minority status cutoffs — BYTE_VERIFIED (2026-06-20).** In the colony
  processor `func_02D658`, the colony SoL% (`[bp-0xB6]`) drives four **hysteresis
  announcements** latched by `ColonyRecord +0x1C` (bit `0x04` = "rebel-majority
  announced", bit `0x02` = "rebel-unanimous announced"):
  | Transition | Cutoff | Message (handle) | Latch action | Site |
  |---|---|---|---|---|
  | rises to **≥ 50%** | `cmp,0x32; jl` | `@REBELMAJORITY` (`0xD8A`) | set `+0x1C |= 4` | `@0x2DB29`/`@0x2DB55` |
  | rises to **= 100%** | `cmp,0x64; jl` | `@REBELUNANIMOUS` (`0xD98`) | set `+0x1C |= 2` | `@0x2DB6E`/`@0x2DB9A` |
  | falls **< 95%** (was unanimous) | `cmp,0x5F; jge` | `@TORYMINORITY` (`0xDA7`) | clear `+0x1C &= ~2` | `@0x2DBB4`/`@0x2DBE0` |
  | falls **< 50%** (was majority) | `cmp,0x32; jge` | `@TORYMAJORITY` (`0xDB4`) | clear `+0x1C &= ~4` | `@0x2DBFA`/`@0x2DC26` |
  Each fires once per crossing (gated by the latch bit) and only for a visible/owned
  colony (`[bp-0xAE] != 0`). **B.**
- **Uprising trigger — BYTE_VERIFIED (2026-06-20).** `@TORYUPRISING` (handle `0x12AE`)
  is emitted by **`func_03CAC6`** (`@0x3CD94`, per `tools/rtlink/event_emitters.json`),
  the during-WoI Tory-uprising processor. Its **per-call probability gate** is
  `random_int(0, difficulty+1)` (`@0x3CADD`, `0x181F:0x4D4`, difficulty byte `[0x53A6]`,
  `inc ax` → `diff+1`): if the roll is **0** the function exits (`@0x3CAE5 or ax,ax;
  je → 0x3CD9F`); a **nonzero** roll proceeds with the uprising. So it fires with
  probability **`(difficulty+1)/(difficulty+2)`** per call — 50% at Discoverer (diff 0)
  rising to ~83% at Viceroy (diff 4). **B.** *(Call frequency — i.e. how often the WoI
  loop invokes `func_03CAC6` — not yet pinned; the gate itself is byte-exact.)*
- **Uprising target — BYTE_VERIFIED 2026-06-20.** `func_03CAC6` scans the rebel power's
  (`bp+6`) colonies (`@0x3CBC1..0x3CC20`, skipping those with `ColonyRecord +0x1C & 1`)
  and picks the one with the **highest tory-strength**
  `= population[+0x1F]·2·(100 − SoL%)/100 + difficulty + 1` (`@0x3CBE6`: `(100−SoL)·2`
  via `0x181F:0xC86`; `@0x3CBF9` ×pop ÷100; `@0x3CC06` `+ [0x53A6] + 1`). The winner's
  `+0x1C` bit 0 is set so it can't re-fire (`@0x3CC3C`).
- **Effect — BYTE_VERIFIED 2026-06-20.** Crown-loyal **Tory Militia** spawn on the
  **valid empty tiles adjacent to the target colony**: the loop `[bp-0xA]` 0..7 walks the
  **8 neighbours** (delta tables `[bx+0xBE]`/`[bx+0xB4]`), and for each tile that is
  passable (`0x181F:0x768`), in-bounds (`0x181F:0x6BE`), and **not occupied by a rebel
  unit** (`0x181F:0x682`), it calls **`spawn_unit(col,row,[0x53D2],1)`** (`0x181F:0x95C`
  `@0x3CCCF`). So **up to 8 militia** arm (one per free adjacent tile); `[bp-8]` is the
  *spawned-any* flag — if **no** adjacent tile is free, the uprising is **suppressed**
  (clear `+0x1C` bit 0, return — no message/units, `@0x3CD59`). Otherwise the colony
  coords (`+0/+1`) + name (`+0x02`, `%STRING0`) are bound and `@TORYUPRISING` emitted
  (`@0x3CD6C..0x3CD97`). **B.**

> **Foreign-intervention arrival (cross-ref `revolution.md`).** The companion
> `@INTERVENE` "Intervention Force arrives" event (handle `0x12C4`) is emitted by
> **`func_03D510`** (`@0x3D7BB`): it enumerates the rebel power's eligible colonies
> (flag `ColonyRecord +0x1C & 0x40`, up to 10, `@0x3D538..0x3D55E`), weights each by
> `+0x1F`, and picks the **arrival colony** by `random_int(1, Σweights)` (`@0x3D57E`).
> Distinct from the one-time `@INTERVENTION` *declaration* (`func_03D948`). **B** (site
> + selection roll).

## 4. UI

Status messages (`@TORYMAJORITY`/`@TORYMINORITY`/`@REBELMAJORITY`/
`@REBELUNANIMOUS`) in colony/advisor reports; uprising event dialog
(`@TORYUPRISING`). Geometry per shared framework. **R**.

## 5. Evidence

- `data_extracted/text/GAME_sections.json` — `@TORYUPRISING` (454),
  `@TORYMINORITY` (396), `@TORYMAJORITY` (397), `@REBELMAJORITY` (394),
  `@REBELUNANIMOUS` (395). **B**
- `func_03CAC6` (file `0x3CAC6`) — Tory-uprising processor: difficulty gate `@0x3CADD`, rebel-strength sum `@0x3CB0A`, `@TORYUPRISING` emit `@0x3CD94`. **B**
- `func_03D510` (file `0x3D510`) — intervention-arrival: colony enumeration `@0x3D528`, weighted pick `@0x3D57E`, `@INTERVENE` emit `@0x3D7BB`. **B**
- `func_02D658` (file `0x2D658`) — colony processor: SoL-status hysteresis
  announcements at 50/95/100% (`@0x2DB29..0x2DC2A`), latch `ColonyRecord +0x1C`. **B**
- `tools/rtlink/event_emitters.json` — handle map (`@TORYUPRISING`=`0x12AE`, `@INTERVENE`=`0x12C4`, `@INTERVENTION`=`0x12DB`, `@REBELMAJORITY`=`0xD8A`, `@REBELUNANIMOUS`=`0xD98`, `@TORYMINORITY`=`0xDA7`, `@TORYMAJORITY`=`0xDB4`). **B**
- `docs/DATA_MODEL.md` — `ColonyRecord +0xC2/+0xC6` rebel fraction. **B/runtime**
- `docs/GAME_MANUAL.md` — Tory/Rebel sentiment & dissent during independence. **R**

## 6. Open questions (TBD)

1. ~~**Uprising trigger** — byte-trace the condition firing `@TORYUPRISING`.~~
   **Done 2026-06-20** — emitter `func_03CAC6` `@0x3CD94`; per-call gate
   `random_int(0,difficulty+1)≠0` (prob `(diff+1)/(diff+2)`) `@0x3CADD`. Residual: the
   WoI-loop call frequency. **B** (§3).
2. ~~**Majority/minority cutoffs** on the rebel fraction selecting the `@TORY*`/
   `@REBEL*` status strings.~~ **Done 2026-06-20** — hysteresis at 50/95/100%
   (`func_02D658`, latch `ColonyRecord +0x1C` bits `0x04`/`0x02`); see §3 table. **B.**
3. ~~**Effect magnitude** of an uprising (Tory Militia unit count).~~ **Done 2026-06-20**
   — up to **8** Tory Militia spawn on the free tiles adjacent to the target colony
   (the rebel colony with max tory-strength `pop·2·(100−SoL%)/100 + diff + 1`); suppressed
   if no adjacent tile is free (§3). **B.**
