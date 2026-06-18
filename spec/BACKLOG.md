# Specification Backlog — Layer-1 work that closes spec gaps

Each item is a unit of **evidence work** (disassemble + decode) that upgrades a
**spec** section from `RECONSTRUCTED`/`TBD` → `BYTE_VERIFIED`. Entry points were
identified during the 2026-06-18 inventory. Work top-down; record findings in the
relevant `spec/` doc and any conflict in `notes/rulings/RULINGS.md`.

Ordering favors **core game-loop systems** (combat, economy) first, then
secondary mechanics.

| # | Gap | Disasm entry point(s) | Upgrades spec doc | Notes |
|---|-----|-----------------------|-------------------|-------|
| 1 | Combat terrain/fort bonus **table values** + demotion ladder | `func_05CA7E` (decider; +50% chain located), demotion table reads `UnitRecord +0x15` | `systems/combat.md` §3/§7 | Land odds `ATK/(ATK+DEF)` now **B**; remaining: per-terrain/fort values & demotion ladder + capture branch. |
| 2 | Market price drift | thunk `0x181F:0x9A4`; `PowerRecord +0x4C[16]`; `0x53EA` | `systems/market.md` §3 | Commodity set B; per-turn drift formula TBD. |
| 3 | Founding-Father acquisition | `func_075AF8` + bell-cost table (NAMES.TXT thresholds) | `systems/founding_fathers.md` | 25 FFs cataloged; bell-cost computation TBD. |
| 4 | Tax **60-vs-hard-cap** + pretext selection | find the `tax_pct` clamp write site; trace dispatcher feeding `@KINGTAX` | `systems/king.md` §3/§7 | Delta formula now **B** (`func_034AE0` read); `0x3C`=60 threshold **B** (`func_0349F4`); is 60 the clamp or a gate? reconcile manual's 75. |
| 5 | REF growth threshold | writer of REF globals `0x53DA..0x53E0` and of `PowerRecord +0x22` (+18/turn) | `systems/king.md` §7 | REF = 4 globals (B); the spend rule that adds a unit is unknown. |
| 4b | Colony production formula + SoL | production routine; confirm SoL dividend/divisor offsets at read site | `systems/colony.md` §3 | Record stride + input data (@BUILDING/@JOB/@TERRAIN) B; arithmetic TBD. |
| 6 | Immigration / cross rate | recruit-pool `DGROUP:0x978C`; `func_074688`, `0x051E52`, `0x035114` | `systems/immigration.md` | Queue structure sketched; rate TBD. |
| 7 | Diplomacy outcomes | `func_03ECF0` (diplomatic actions) | `systems/diplomacy.md` | Entry known; decision formulas TBD. |
| 8 | Native conversion / mission | native dispatch `func_05BE84` (6 outcomes), `func_057F4E` (SMITE) | `systems/natives.md` | Raze (CHIEFKILL) already B; conversion TBD. |
| 9 | Map generation | mapgen routines (not yet hand-decoded) | `systems/map_generation.md` | Noise seeding sketched; code TBD. |
| 10 | Event triggers & timing | event-queue dispatcher | `systems/events.md` | Per-event conditions mostly TBD. |
| 11 | Save / load codec | `.SAV` loader; `docs/SAVE_FORMAT_CROSSREF.md` | `systems/save.md` | Structure sketched; per-field codec TBD. |
| 12 | Scoring weights | scoring routine | `systems/scoring.md` | Components known; multipliers TBD. |

**Definition of done per item:** the named spec section cites the byte offset(s),
states the formula/value, is tagged `BYTE_VERIFIED`, and the corresponding
`spec/README.md` tier is updated.
