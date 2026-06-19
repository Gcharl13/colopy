# Specification Backlog — Layer-1 work that closes spec gaps

Each item is a unit of **evidence work** (disassemble + decode) that upgrades a
**spec** section from `RECONSTRUCTED`/`TBD` → `BYTE_VERIFIED`. Entry points were
identified during the 2026-06-18 inventory. Work top-down; record findings in the
relevant `spec/` doc and any conflict in `notes/rulings/RULINGS.md`.

Ordering favors **core game-loop systems** (combat, economy) first, then
secondary mechanics.

| # | Gap | Disasm entry point(s) | Upgrades spec doc | Notes |
|---|-----|-----------------------|-------------------|-------|
| 1 | Combat terrain/fort bonus **table values** + capture branch | `func_05CA7E` (decider; +50% `·3/2` chain located); ladder + override at `func_05B2C2` `0x5B5AA..0x5B61F` | `systems/combat.md` §3/§7 | Land odds `ATK/(ATK+DEF)` **B**; **demotion ladder now B** (1→0,4→1,7→9,8→6,9→0,else kill; `+0x15==24`→3). Remaining: per-terrain/fort byte values in `func_05CA7E`; capture-vs-destroy branch; `+0x15==24` profession semantics. |
| 2 | Market price drift | **`func_0305A8`** (B); per-good base `DGROUP:0x53EA[16]`; trade accumulator `PowerRecord +0xFC` dword[16] | `systems/market.md` §3 | **Drift formula now B** (2026-06-19): `price_base[good] -= (base + Σ_players clamped_trade)/256` (`@0x305B3..0x30639`), reached via resident thunk `@0x1C2AC`. **Note:** old `0x181F:0x9A4` attribution was WRONG (shared utility, 92 callers). Remaining: the turn-loop driver call site + the `+0xFC` buy/sell increment. |
| 3 | Founding-Father acquisition | ~~`func_075AF8`~~ → bell-cost curve **`func_03C282`** (file `0x03C282`); selection-weight consumer of in-mem FF table `DGROUP:0x9652` | `systems/founding_fathers.md` | Bell pool (`PowerRecord +0x0C/+0x0E/+0x14`) + **bell-cost curve now BYTE_VERIFIED** (2026-06-18). Remaining: per-father selection weighting + concrete effect bindings. (`func_075AF8` offset was stale — not a function entry.) |
| 4 | Tax pretext selection | trace dispatcher feeding `@KINGTAX` among the pretext keys | `systems/king.md` §3 | **Resolved 2026-06-18:** clamp = **75** (`func_034318` `0x03434F`); `0x3C`=60 is a message gate (`func_0349F4`) — both **B**. Remaining: which pretext key is chosen. |
| 5 | REF growth threshold | count writers `func_03CDA2`/`func_051EF4` (B); find the `PowerRecord +0x22` royal-money consumer | `systems/king.md` §7, `systems/ref_growth.md` | Writers located 2026-06-19 (war-assembly path; ≥1 Man-O-War guarantee; tallies player Man-O-Wars). Remaining: the +0x22 spend/threshold (>1188). |
| 4b | Colony hammers accumulation + warehouse | per-turn work-point accumulation (overlay-resident) toward `+0xBA`; warehouse spoilage | `systems/colony.md` §3/§7 | **Resolved 2026-06-18:** per-tile production formula (`compute_terrain_yield` `0x9B9C`) + SoL % (`sol_membership_pct` `0x8524`, dividend/divisor `+0xC2/+0xC6`) now **B**. Remaining: hammers per-turn accumulation (R); warehouse thresholds (TBD). |
| 6 | Immigration / cross rate | recruit-pool `DGROUP:0x978C`; `func_074688`, `0x051E52`, `0x035114` | `systems/immigration.md` | Queue structure sketched; rate TBD. |
| 7 | Diplomacy outcomes | **handler UNLOCATED** — `0x883C` war-matrix has **no code xrefs**; treaty/war GAME keys present | `systems/diplomacy.md` | **Corrected 2026-06-19:** `func_03ECF0` is NOT diplomacy — it's `unit_vs_tile_combat_terrain_eval` (touches combat ATK table `0x5236`, terrain `0x2F76`, random_int). Real diplomacy handler not yet found (no writer of `0x883C` in disasm). |
| 8 | Native conversion / raid | `func_0572E6` (conversion); `func_05BE84` (raid, 6 RAID* outcomes) | `systems/natives.md` | **Conversion + raid-outcome dispatch now B** (2026-06-19). Note: `func_05BE84` is native **raid** (RAIDWREAK/STORES/BURN/SHIP/GOLD/NOTHING), not Lost-City rumor. Remaining: conversion RNG bounds; CHIEFKILL formula; attitude thresholds; the separate Lost-City rumor selector. |
| 9 | Map generation | mapgen routines (not yet hand-decoded) | `systems/map_generation.md` | Noise seeding sketched; code TBD. |
| 10 | Event triggers & timing | native-encounter dispatch **`func_05BE84`** (B); per-outcome handlers `0x5C03E/0C0CA/0C252/0C29A/0C1AF` | `systems/events.md` | **Outcome-selection mechanism now B** (2026-06-19): gate roll + `random(1,4)` + difficulty/turn + availability gates + 5-way switch. Remaining: each handler's message binding. |
| 11 | Save / load codec | `.SAV` loader; HALLFAME.DAT writer **`func_03ADA6`** (B) | `systems/save.md` | **HALLFAME.DAT now B** (2026-06-19): 5×42B=210B records (24B name + ~8 score words). SAV per-field codec still TBD. |
| 12 | Scoring weights | scaler **`func_03A9C0`** (B); component sum behind paged `func_03B36A`→`0x191F:0x3AA` → file `0x39EE2` (resolved) | `systems/scoring.md` | **Scaling + population component now B** (2026-06-19): difficulty mult `[4,5,6,8,10]`, `score=(mult*base)/100>>1`, rank, accumulator `[0x372]`; **population gates** `{0x19,0x1A,0x1B}→+1`, `0x1C→+2`, else `+4` (`@0x3A09A..0x3A117`). Remaining: father(+5)/gold/sentiment/razed/revolution weights → label-binding in the same `0x39EE2` report builder. |

**Definition of done per item:** the named spec section cites the byte offset(s),
states the formula/value, is tagged `BYTE_VERIFIED`, and the corresponding
`spec/README.md` tier is updated.

## Depth-pass queue (per-spec §6)

The taxonomy is now fully populated with breadth-first stubs. **Each
`spec/**/*.md` file's §6 "Open questions" is its own depth queue** — that is the
authoritative, per-system list. Below are the highest-value concrete entry
points surfaced during the population pass (2026-06-18), to seed that work:

| Topic | Entry point (primary) | Upgrades |
|-------|------------------------|----------|
| Diplomacy war state | `DGROUP:0x883C` war bit-matrix — decode layout (which bit = which pair) | `systems/diplomacy.md` |
| Immigration / crosses | `func_0363A2` (crosses loop), `func_035D9A` (threshold) | `systems/immigration.md` |
| Native raze treasure | `func_04A7CA` (CHIEFKILL) — already B; conversion/mission TBD | `systems/natives.md` |
| Exploration / scout | `func_05A20E` | `systems/exploration.md` |
| Colony production | `func_02D658` | `systems/colony.md` |
| Treasure transport | `func_05C878` **(B 2026-06-19)**: value=100×UnitRecord[+0x15]; King per-difficulty fee table `DGROUP:0x8394`; post-indep cashed direct | `systems/events.md` §3 |
| Dialog framework | `func_06F0F4` (popup dispatcher), sprite channels `[0x1F5C/5E/60]`, geometry `[0x839E..0x83A4]` | `ui/popups.md` |
| Cinematic dispatch | `func_075352` (king-defeats arg matrix), `func_03DA2A` (DoI signature) | `ui/cinematics.md`, `ui/declaration_independence.md` |
| Lost City outcomes | index→outcome binding for `@LOSTCITY0..9` + `@BURIAL1-3` + `@VANISH` | `systems/events.md`, `ui/popups.md` |

**Data caveats to resolve** (from the population pass): NAMES.TXT has **31**
`@`-sections (recount any list that says 23); ColonyRecord is reached via
`[0x8542]` (not a static base); PowerRecord base is `0x8808`/`0x8809` — confirm
which is the array head vs first field at a read site.

## Basis follow-ups (2026-06-18, from the bottom-up re-basis)

The text/table basis is now complete (`tools/extract_txt_sections.py`,
`build_tables.py`). Remaining byte-grounding:

| Task | Entry point | Upgrades |
|------|-------------|----------|
| Column→runtime mapping for `@BUILDING`/`@CARGO`/`@TERRAIN`/`@JOB`/`@FATHERS` loaders | find each section's loader (start from `@UNIT`→`@0x74EC3`) | `spec/data/tables.md`, market/colony/FF specs |
| Align variable-length `@UNIT`/`@CARGO` special rows | `data_extracted/tables/names_tables.json` | `spec/data/tables.md` |
| Reconcile `viceroy_source/data/*.c` vs `data_extracted/tables/` | per-table compare | data tables |
| Reproduce DGROUP record **values** (not just layout) | `tools/analyze_session_mem.py` against a DOSBox memory dump; the layout catalog (`dgroup_tables.json`) gives offset/stride/count | `spec/data/tables.md` §C, `spec/data/records.md` |
| Name remaining raw/`TBD` table columns from loaders | `@ORDERS` key letters, `@TRIBES` extras, `@LEVELS`; legends in `NAMES.full.json` | `spec/data/tables.md` |
| Spanish-Succession **trigger** (handler `func_03C638` now B: unit+colony transfer) | find the dispatcher that fires `func_03C638` | `systems/spanish_succession.md` |
| Mercenary price (`%NUMBER0`) + offer trigger | dialog firing `@MERCENARIES` | `systems/mercenary.md` |

**Lesson recorded:** the two fabrications (heir-succession, wilderness-camp) came
from an *empty-key* extraction. Always read the real `.TXT` body first; an empty
key is never a license to guess.
