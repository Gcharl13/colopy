# Specification Backlog — Layer-1 work that closes spec gaps

Each item is a unit of **evidence work** (disassemble + decode) that upgrades a
**spec** section from `RECONSTRUCTED`/`TBD` → `BYTE_VERIFIED`. Entry points were
identified during the 2026-06-18 inventory. Work top-down; record findings in the
relevant `spec/` doc and any conflict in `notes/rulings/RULINGS.md`.

Ordering favors **core game-loop systems** (combat, economy) first, then
secondary mechanics.

> **Status (2026-06-19 consolidation).** Items 2–12 are now **resolved or
> substantially byte-verified** (each row's note states what's closed vs the
> residual). The **only genuinely dump-blocked** value left is the King galleon-fee
> per-difficulty table `DGROUP:0x8394` (confirmed BSS, no static writer — needs a
> live data-segment snapshot). The remaining `TBD`s are either **fuzzy AI logic**
> (diplomacy willingness thresholds; war-matrix `0x08`/`0x80` bits) or **runtime-state
> magnitudes** with a known formula (per-Lost-City reward rolls). Item 9 (random
> map generator) is the one whole system still **unlocated**. The cross-branch
> reconstructions (`viceroy_source/src/...`) were mined as leads and every adopted
> finding was **re-verified against this branch's `raw/COLONIZE/VICEROY.EXE`**.

| # | Gap | Disasm entry point(s) | Upgrades spec doc | Notes |
|---|-----|-----------------------|-------------------|-------|
| 1 | Combat terrain/fort bonus + capture branch | `func_05CA7E` (decider); `func_007D3E` (bonus filler); ladder at `func_05B2C2` | `systems/combat.md` §3/§7 | Land odds `ATK/(ATK+DEF)` **B**; demotion ladder **B**; **terrain/fort bonus now B** (2026-06-19): `func_007D3E` colony+2/fort+4/×2/river+(n+1)·2/open-terrain = `$TERRAIN` "Defensive" col (forests 2/Hills 4/Mountains 6). Remaining: capture-vs-destroy branch; `+0x15==24` semantics. |
| 2 | Market price drift | **`func_0305A8`** (B); per-good base `DGROUP:0x53EA[16]`; trade accumulator `PowerRecord +0xFC` dword[16] | `systems/market.md` §3 | **Drift formula B** (2026-06-19): `price_base[good] -= (base + Σ_players clamped_trade)/256` (`@0x305B3..0x30639`). Price base = random-seeded `[600,1000]` (`func_0755CC`, not a fixed table). Remaining: the turn-loop driver call site + the `+0xFC` buy/sell increment. |
| 3 | Founding-Father acquisition | bell-cost curve **`func_03C282`**; selection `func_03BFD2`; effects `func_03BC42` | `systems/founding_fathers.md` | **RESOLVED 2026-06-19:** bell pool + cost curve **B**; era-band weighted selection **B**; **9 immediate-effect fathers byte-verified** (`func_03BC42` — Fugger/Coronado/La Salle/J.P.Jones/Pocahontas/Bolivar/Brewster/de Brebeuf/las Casas). **UPDATED 2026-06-20:** per-father audit now **21/25 B** (+Minuit `@0x40BB4/0x465D5`, +Magellan `@0x41871`). Remaining 4 `R` = Smith(0)/Stuyvesant(3)/Drake(13)/Penn(21): proven **not** gated via the has-father helper (none of the 50 `0x181F:0x7B4` sites push bits 0/3/13/21) nor a direct `byte[+0x07]` mask test. Narrowed lead: the per-colony building-presence bitmap `ColonyRecord +0x8A` (`func_0085B2`/`0085D6`/`00863E`) + chain table `byte[idx*12+0x8F86]`; pin the colony-screen build-list overlay read for Smith/Stuyvesant. |
| 4 | Tax pretext selection | `func_036138` (pretext builder); clamp `func_034318`; gate `func_0349F4` | `systems/king.md` §3 | **RESOLVED 2026-06-19:** pretext chosen by escalating gate on `[bp-0x52]` (thresholds `0x28A`/`0x3B6`/`0x44C`) → KINGWIFE→KINGWAR→KINGNAVACT→KINGSTAMPACT (`@0x362C7..0x36371`); clamp **75** (`0x03434F`); 60 gate (`func_0349F4`). All **B**, incl. the cadence (turn≥30, interval 18→9 by era) and the `[bp-0x52]` severity score (random(1,1000)+(2·sentiment−tax)·5+gold+turn/30). |
| 5 | REF growth threshold | **driver `func_03E162`** (B); count writers `func_03CDA2`/`func_051EF4` (B) | `systems/king.md` §7, `systems/ref_growth.md` | **RESOLVED 2026-06-19:** `func_03E162` accrues `royal_money += (8·diff+10)·2^era` (eras 1600/1700/1750), buys a REF unit at **threshold 1800 (`0x708`)**, picks the slot by ratio (3:1 reg:cav, 4:1 reg:art, 10:1 land:naval), then spends `+0x22 -= 1800` (`@0x3E271`). +18/turn runtime == `diff=1`. |
| 4b | Colony hammers accumulation + warehouse | production `func_00A3E1`; stockpile array `ColonyRecord +0x9A` | `systems/colony.md` §3/§7 | Per-tile production + SoL% **B**. **Hammers reframed (2026-06-19):** it's a slot in the per-good `+0x9A` array (row `0xF`=Hammers), not a standalone field — **R** (accumulation site in `func_00A3E1` not yet re-verified). Warehouse thresholds (TBD). |
| 6 | Immigration / cross rate | crosses loop `func_0363A2`; threshold/production `func_035D9A` | `systems/immigration.md` | **RESOLVED 2026-06-19:** crosses loop + threshold shape **B**; **per-turn cross increment B** (base 2 + per-colony `+0x05`, spawn when `+0x2E>+0x30`); dock pool `+0x02..+0x04` confirmed (Brewster). Remaining: the per-slot immigrant-type selector RNG. |
| 7 | Diplomacy outcomes | **`func_057F4E`** (meeting) + **`func_057DC0`** (SIGNTREATY) | `systems/diplomacy.md` | **RESOLVED 2026-06-19:** handlers byte-verified (the "no xrefs" was a grep error — `[bx+si-0x77C4]` displacement). War matrix `+0x34` (bit `0x02`=war), treaty matrix `+0x40` (`0x02`/`0x20`/`0x40` bits), cooldown `[0x53C8+pw*2]=turn+0x10`, symmetric writes. Remaining: AI willingness thresholds + war-matrix `0x08`/`0x80` bits (fuzzy). |
| 8 | Native conversion / raid | `func_0572E6` (conversion); `func_05BE84` (raid); `func_04A7CA` (CHIEFKILL) | `systems/natives.md` | **RESOLVED 2026-06-19:** conversion RNG `random(0,15)`, `P=(TribeData[+2]+2)/15` **B**; CHIEFKILL roll `random(0,40·scout+100)` **B**; raid outcome→key wiring **B** (1 STORES/2 WREAK/3 GOLD/4 BURN-SHIP/0 NOTHING). Remaining: attitude-escalation thresholds; CHIEFKILL roll→gold conversion. |
| 9 | Map generation | mapgen routines (not yet hand-decoded) | `systems/map_generation.md` | Noise seeding sketched; code TBD. |
| 10 | Event triggers & timing | Lost-City `func_061454`; raid `func_05BE84`; trigger = features `0xB0` | `systems/events.md` | **RESOLVED 2026-06-19:** Lost-City trigger (features-layer `0xB0`, runtime-verified) + all 9 `@LOSTCITY<n>` outcomes + FoY=8 immigrants **B**; raid outcome→key wiring **B**. Remaining: per-Lost-City reward *magnitude* roll formulas (inline `[bp-0x10]`/`[bp-0x32]`). |
| 11 | Save / load codec | SAVE orchestrator `func_072F7A` → serializer **`func_0734F8`** (B); loader `func_073BB0`; HALLFAME.DAT `func_03ADA6` (B) | `systems/save.md` | **SAV format now B** (2026-06-19, verified vs EXE): magic `"COLONIZE"`+`0x1A`, file `COLONY<slot>.SAV`, then 4 tables at full stride (Colony·0xCA / Unit·0x1C / Power 4·0x13C / Native·0x12). HALLFAME.DAT B. Remaining: per-field order within a saved PowerRecord. |
| 12 | Scoring weights | scaler **`func_03A9C0`** (B); component sum `func_039EE2` (resolved) | `systems/scoring.md` | **Scaling + population component B** (2026-06-19): difficulty mult `[4,5,6,8,10]`, `score=(mult*base)/100>>1`, rank, accumulator `[0x372]`; population gates `{0x19,0x1A,0x1B}→+1`/`0x1C→+2`/else `+4`. Remaining: father(+5)/gold/sentiment/razed/revolution per-line weights (label-binding in `func_039EE2`). |

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
| Diplomacy war state | ~~`DGROUP:0x883C` layout~~ **DONE** — `+0x34` war / `+0x40` treaty matrices, bits byte-verified (`func_057F4E`/`func_057DC0`) | `systems/diplomacy.md` |
| Immigration / crosses | ~~`func_0363A2`/`func_035D9A`~~ **DONE** — loop + threshold + per-turn increment **B** | `systems/immigration.md` |
| Native raze treasure | ~~`func_04A7CA` CHIEFKILL~~ **DONE** — roll **B**; conversion RNG + raid wiring **B** | `systems/natives.md` |
| Exploration / scout | `func_05A20E` | `systems/exploration.md` |
| Colony production | `func_02D658` | `systems/colony.md` |
| Treasure transport | `func_05C878` **(B 2026-06-19)**: value=100×UnitRecord[+0x15]; King per-difficulty fee table `DGROUP:0x8394`; post-indep cashed direct | `systems/events.md` §3 |
| Dialog framework | `func_06F0F4` (popup dispatcher), sprite channels `[0x1F5C/5E/60]`, geometry `[0x839E..0x83A4]` | `ui/popups.md` |
| Cinematic dispatch | `func_075352` (king-defeats arg matrix), `func_03DA2A` (DoI signature) | `ui/cinematics.md`, `ui/declaration_independence.md` |
| Lost City outcomes | ~~index→outcome binding~~ **DONE** — all 9 `@LOSTCITY<n>` + `@BURIAL1-3` byte-verified (`func_061454`); FoY=8 | `systems/events.md` |

**Data caveats to resolve** (from the population pass): NAMES.TXT has **31**
`@`-sections (recount any list that says 23); ColonyRecord is reached via
`[0x8542]` (not a static base); PowerRecord base is `0x8808`/`0x8809` — confirm
which is the array head vs first field at a read site.

## Basis follow-ups (2026-06-18, from the bottom-up re-basis)

The text/table basis is now complete (`tools/extract_txt_sections.py`,
`build_tables.py`). Remaining byte-grounding:

| Task | Entry point | Upgrades |
|------|-------------|----------|
| Column→runtime mapping for `@CARGO`/`@JOB` loaders (`@TERRAIN`/`@BUILDING`/`@FATHERS` **DONE** 2026-06-19) | find each section's loader (start from `@UNIT`→`@0x74EC3`) | `spec/data/tables.md`, market/colony/FF specs |
| Align variable-length `@UNIT`/`@CARGO` special rows | `data_extracted/tables/names_tables.json` | `spec/data/tables.md` |
| Reconcile `viceroy_source/data/*.c` vs `data_extracted/tables/` | per-table compare | data tables |
| Reproduce DGROUP record **values** (not just layout) | `tools/analyze_session_mem.py` against a DOSBox memory dump; the layout catalog (`dgroup_tables.json`) gives offset/stride/count | `spec/data/tables.md` §C, `spec/data/records.md` |
| Name remaining raw/`TBD` table columns from loaders | `@ORDERS` key letters, `@TRIBES` extras, `@LEVELS`; legends in `NAMES.full.json` | `spec/data/tables.md` |
| Spanish-Succession **trigger** (handler `func_03C638` now B: unit+colony transfer) | find the dispatcher that fires `func_03C638` | `systems/spanish_succession.md` |
| ~~Mercenary price (`%NUMBER0`) + offer trigger~~ | **RESOLVED 2026-06-20:** price **B** — `((diff+K)*2 + rand(0,6))*100 * ((catA+catC)*2 + count)`, K=3 wartime (`func_03E442 @0x03E512`) / K=4 peacetime (`func_03E664 @0x03E707`); triggers **B** (1/3 wartime, 1/21 peacetime). Remaining: force composition (`%STRING1`) via `func_03EA42`. | `systems/mercenary.md` |

**Lesson recorded:** the two fabrications (heir-succession, wilderness-camp) came
from an *empty-key* extraction. Always read the real `.TXT` body first; an empty
key is never a license to guess.
