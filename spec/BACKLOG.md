# Specification Backlog — Layer-1 work that closes spec gaps

Each item is a unit of **evidence work** (disassemble + decode) that upgrades a
**spec** section from `RECONSTRUCTED`/`TBD` → `BYTE_VERIFIED`. Entry points were
identified during the 2026-06-18 inventory. Work top-down; record findings in the
relevant `spec/` doc and any conflict in `notes/rulings/RULINGS.md`.

Ordering favors **core game-loop systems** (combat, economy) first, then
secondary mechanics.

| # | Gap | Disasm entry point(s) | Upgrades spec doc | Notes |
|---|-----|-----------------------|-------------------|-------|
| 1 | Combat outcome roll & demotion | `func_05CA7E` (per-unit decider), `func_05B2C2` (consequence applier) | `systems/combat.md` (from `viceroy_source/docs/COMBAT.md`) | Stats already B; the win/loss roll & demotion selection are TBD. ATK/(ATK+DEF) confirmed wave-9. |
| 2 | Market price drift | `func_0305A8`; PowerRecord price table `+0x4C[16]` | `systems/market.md` | Entry known; per-turn drift formula TBD. |
| 3 | Founding-Father acquisition | `func_075AF8` + bell-cost table (NAMES.TXT thresholds) | `systems/founding_fathers.md` | 25 FFs cataloged; bell-cost computation TBD. |
| 4 | Tax delta + cadence (pilot follow-up) | `func_034AE0` (+ its `0x538E`-gated caller) | `systems/king.md` §3/§7 | Confirm `((diff&0xFE)*2+4)`; pin interval & pretext selection. |
| 5 | REF growth threshold | writer of `royal_money` PowerRecord `+0x22` | `systems/king.md` §7 | +18/turn observed; spend threshold unknown. |
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
