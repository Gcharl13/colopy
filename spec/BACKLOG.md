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
| 2 | Market price drift | thunk `0x181F:0x9A4`; `PowerRecord +0x4C[16]`; `0x53EA` | `systems/market.md` §3 | Commodity set B; per-turn drift formula TBD. |
| 3 | Founding-Father acquisition | ~~`func_075AF8`~~ → bell-cost curve **`func_03C282`** (file `0x03C282`); selection-weight consumer of in-mem FF table `DGROUP:0x9652` | `systems/founding_fathers.md` | Bell pool (`PowerRecord +0x0C/+0x0E/+0x14`) + **bell-cost curve now BYTE_VERIFIED** (2026-06-18). Remaining: per-father selection weighting + concrete effect bindings. (`func_075AF8` offset was stale — not a function entry.) |
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
| Treasure transport | `func_05C878` | `systems/king.md`, events |
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
| Spanish-Succession trigger + colony-transfer | event firing `@SUCCESSION`; power-removal in data model | `systems/spanish_succession.md` |
| Mercenary price (`%NUMBER0`) + offer trigger | dialog firing `@MERCENARIES` | `systems/mercenary.md` |

**Lesson recorded:** the two fabrications (heir-succession, wilderness-camp) came
from an *empty-key* extraction. Always read the real `.TXT` body first; an empty
key is never a license to guess.
