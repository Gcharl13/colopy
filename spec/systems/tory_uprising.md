# Tory Uprising (Internal Dissent During Independence)

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** message keys `BYTE_VERIFIED`; **uprising emitter + per-call probability gate + SoL-status (50/95/100%) cutoffs `BYTE_VERIFIED`** (2026-06-20, `func_03CAC6`/`func_02D658`); uprising effect magnitude `RECONSTRUCTED`. · **Canonical primary:** `data_extracted/text/GAME_sections.json`; `tools/rtlink/event_emitters.json` (handle map).

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

(Values empty in extracted section — markers; prose binding `TBD`.)

The **rebel fraction** that drives these states is byte-grounded: `ColonyRecord
+0xC2` = `rebel_dividend` (Sons of Liberty numerator), `+0xC6` = denominator —
e.g. 66/617 = 10.7% Sons of Liberty, RUNTIME-VERIFIED per `docs/DATA_MODEL.md`.
The Tory share is the complement. The specific **uprising-trigger threshold** on
this fraction is **TBD**.

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
- **Uprising target & strength — partial.** When it proceeds, `func_03CAC6` sums the
  **rebel army strength** (per-unit attack stat `@UNIT[type·14 + 0x5236]`, accumulated
  `@0x3CB0A..0x3CB10`) over the rebel power's (`[0x53D2]`) units, then arms a **Tory
  Militia** near a rebel colony (`%STRING0`). The exact rebel-vs-Tory strength
  comparison and the number of Tory units spawned are `RECONSTRUCTED`.
- **Effect:** Crown-loyal **Tory Militia** units appear adjacent to a rebel colony
  ("Parliament arms Tory Militia!"). The militia count `[bp-8]` is derived from the
  body's rebel-army-strength vs colony-tory-strength comparison loop
  (`@0x3CB60..0x3CD40`); when it resolves to **0** the uprising is **suppressed**
  (clear `ColonyRecord +0x1C` bit 0, return — no message, no units, `@0x3CD59`).
  Otherwise the colony coords (`ColonyRecord +0/+1`) and name (`+0x02`, `%STRING0`) are
  bound and `@TORYUPRISING` emitted (`@0x3CD6C..0x3CD97`). The **exact count formula**
  is `RECONSTRUCTED` (deep multi-variable loop). **B** (gate/emit); **R** (count).

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
3. **Effect magnitude** of an uprising (Tory Militia unit count / morale / production).
