# Immigration & Recruitment

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** crosses loop control-flow + threshold shape `BYTE_VERIFIED`; immigrant-type selection + pool layout `TBD` (open conflict). **Canonical primary:** `docs/IMMIGRATION_RECRUIT_FINDINGS.md` (byte-cited), `docs/DATA_MODEL.md`; `data_extracted/text/NAMES_sections.json` `@CLASS`; `data_extracted/text/GAME_sections.json` `@RECRUIT*`.

## 1. Purpose & behavior
Religious freedom (crosses, from churches/cathedrals) accumulates immigrant points; when they reach a threshold a new colonist arrives on the Europe docks. The player may also pay gold to **recruit** a specific waiting colonist immediately. Some types (Artillery) escalate in cost each purchase. **RECONSTRUCTED** (manual + byte-cited control flow).

## 2. State & data
Operates on the CURRENT `PowerRecord` via far ptr `DGROUP:0x84FC` (= `0x8808 + player*0x13C`).

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| `PowerRecord +0x2E` | u16 | current accumulated crosses | **BYTE_VERIFIED** | `IMMIGRATION_RECRUIT_FINDINGS.md`: add @`0x0363F5`, reset @`0x03645E`, F2 read |
| `PowerRecord +0x30` | u16 | needed crosses / threshold | **BYTE_VERIFIED** | write @`0x0363EF`; F2 read |
| `PowerRecord +0x1E` | u16 | `artillery_bought_count` (Europe recruit escalation) | **BYTE_VERIFIED** (2026-05-31) | `DATA_MODEL.md`: read×100 @`0x035124`/`0x03527B`, inc @`0x035282`, zeroed @`0x03662F` |
| recruit-pool slot `+0x04` | u16 | recruit gold cost (pool @ `DGROUP:0x978C + slot*6`) | **BYTE_VERIFIED** | `DATA_MODEL.md`/`func_074688`: read @`0x051E52`,`0x035114` |
| pool slots `+0x02/+0x03/+0x04` | u8 | dock-pool unit-type bytes (selector) | **TBD — conflict** | `IMMIGRATION_RECRUIT_FINDINGS.md` §2: conflicts with `+0x02 = rebel_sentiment`; base may differ from `0x8808` |

`@CLASS` (immigrant/colonist classes, BYTE_VERIFIED present): Petty Criminals, Indentured Servants, Peasant Farmers, Skilled Craftsmen, Hardy Pioneers, Town Merchants, Trained Mercenaries, Educated Elite.

## 3. Formulas & rules
- **Crosses loop** `func_0363A2` (file `0x0363A2..0x036573`), gated by `(g_5382 & 1)`: accumulate `+0x2E`, clamp ≥0; if current > needed → spawn immigrant, reset `+0x2E := 0`. **BYTE_VERIFIED.**
- **Threshold helper** `func_035D9A` (file `0x035D9A`): `base 0x2`, then table loops over `DGROUP:0x5D60` (stride 202) and the UnitRecord table; `if accum<4000: accum*=2; accum+=8; clamp 4000`; difficulty scale `accum*(8-difficulty[0x53A6])/8`; **England (player 0): accum*2/3**. **BYTE_VERIFIED shape.**
- **Artillery recruit cost** = `base + artillery_bought_count*100`, then counter++ (NOT `base<<count`). **BYTE_VERIFIED** (`DATA_MODEL.md`).
- Immigrant **type** selection: **TBD** (selector reads pool slots; layout unresolved — do not assert).

## 4. UI
F2 Religious Adviser renders `(%d of %d)` from `+0x2E`/`+0x30` (`func_037958`, gauge `lcall 0x181f:0x236`). Recruit menu opened with `R`/`1`; strings `@RECRUIT @RECRUIT2 @RECRUITCHOOSE`. See `docs/ADVISOR_REPORTS_AUDIT.md`.

## 5. Evidence
- `docs/IMMIGRATION_RECRUIT_FINDINGS.md` — crosses loop `func_0363A2`, threshold `func_035D9A`, byte-cited. **B**
- `docs/DATA_MODEL.md` — `+0x2E/+0x30/+0x1E`, recruit-pool `0x978C` slot `+0x04`. **B**
- `data_extracted/text/NAMES_sections.json` `@CLASS`; `GAME_sections.json` `@RECRUIT*`. **B (present)**

## 6. Open questions (TBD)
1. Resolve the `+0x02` conflict: find the true dock-pool base/stride and the type-selector's `bx`.
2. Byte-verify per-turn crosses increment source and the exact spawn handler.
3. Map recruit-pool slot full layout (type, cost, count) and non-artillery cost rules.
