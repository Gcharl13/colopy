# Specification Backlog — Layer-1 work that closes spec gaps

Each item is a unit of **evidence work** (disassemble + decode) that upgrades a
**spec** section from `RECONSTRUCTED`/`TBD` → `BYTE_VERIFIED`. Entry points were
identified during the 2026-06-18 inventory. Work top-down; record findings in the
relevant `spec/` doc and any conflict in `notes/rulings/RULINGS.md`.

Ordering favors **core game-loop systems** (combat, economy) first, then
secondary mechanics.

> **Status (2026-06-19 consolidation).** Items 2–12 are now **resolved or
> substantially byte-verified** (each row's note states what's closed vs the
> residual). The King galleon **fee** is the byte-verified Crown-cut formula (Cortés/tax/difficulty,
> `func_05C878`) — **not** a table and **not** dump-blocked. `DGROUP:0x8394` (once
> mislabeled "the fee table") is just the per-difficulty king-salutation string
> pointers (`%STRING0` rank: Discoverer…Viceroy), resolved 2026-06-20. The remaining `TBD`s are either **fuzzy AI logic**
> (diplomacy willingness thresholds; war-matrix `0x08`/`0x80` bits) or **runtime-state
> magnitudes** with a known formula (per-Lost-City reward rolls). Item 9 (random
> map generator) is the one whole system still **unlocated**. The cross-branch
> reconstructions (`viceroy_source/src/...`) were mined as leads and every adopted
> finding was **re-verified against this branch's `raw/COLONIZE/VICEROY.EXE`**.

> **Residual-inventory campaign (2026-06-20).** Ran a 9-campaign sweep (C1–C9, ~3
> waves of parallel byte-trace agents) to close the 86-item "deep trivia" inventory.
> Every agent finding was **independently re-disassembled before commit** — this
> caught ~11 agent errors (tribe-seed direction, `+0xB6`≠tools, lumber=`+0x9A` Lumber
> slot, defense col `0x2F77` not `0x2F80`, `+0x32`=home_x not strength, tools-cost
> inline not overlay, UnitRecord base `0x3144`/position, `@UNIT` stride 14,
> `func_03E664`=mercenary not intervention, …). **6 RULINGS** recorded (terrain ids
> 24–28, P2 climate, alarm-thunk, `+0x32`=home_x, UnitRecord base, …). Closed: most
> static items + the previously all-TBD **terrain_improvement** system, near-complete
> **UnitRecord** map, diplomacy bits, intra-turn phase order, map-gen customize/scenario/
> post-passes, and the data-catalog legends. **Remaining residual** (genuinely
> unfound or runtime-only): `0x9408` REF value table + `0x9654` FF candidate table
> (both BSS/runtime-only); **BUILDING.SS per-building sprite index** — re-scoped
> 2026-06-20: blocked on the **MADSPACK-2 `mode=4` decoder**, and a bounded static hunt
> showed the `.SS` loader/decompressor is **RTLink-overlay-resident, not statically
> locatable** (the resident `func_0749E0`/`0x191F:0x928` are a config parser; the
> `MADSPACK`/`PIK`/`rb` strings have zero real instruction refs). Finishing needs
> **overlay-map reconstruction or a dynamic DOSBox trace** (see `formats/SS.md`); container
> layout + codec identity are byte-verified. CC-NN are **FF portraits** (`@FATHERS`,
> SPRITE-A; old "unit sheet" label corrected). Plus Tory-uprising effect magnitude (unit
> count) + the WoI-loop call frequency for `func_03CAC6`.
> **Closed 2026-06-20:** (a) **Spanish-succession** `func_03C638` fully byte-verified —
> power selection (weakest AI cedes/strongest receives, score `3a+2b+c`), single-player
> gate, map-tile/unit/colony owner transfer, controller `+0x543F:=2`; emits `@SUCCESSION`
> (handle `0x128C`). (b) **Lost-City burial `%NUMBER` rolls** (BURIAL2 `10·3d8`, BURIAL3
> `2·(1d8+2(scout+5))×100`), debug-Cibola path (`[0x5382]&1`), and the `0xA0`/`0xB0`
> feature-mask reconcile (feature = high nibble `0xF0`, discriminator in helper
> `0x181F:0x7E0`). (c) **Revolution SoL declare threshold = 50%** — `func_03E984`
> rejects with `@TOOTORY` when `[0x53D0] < 0x32` `@0x3E99E`, else `@DECLARE`→`func_03DE46`
> (`@INDEPENDENCE`); `[0x53D0]`=SoL meter, `[0x5398]`=rebel power; `revolution.md`
> R/TBD→**B/TBD**. (d) **Per-turn Tory-uprising** `func_03CAC6` (gate
> `random_int(0,diff+1)≠0`) + **intervention-arrival** `func_03D510` (weighted colony
> pick) byte-verified (`tory_uprising.md`). (e) **Spanish-succession** `func_03C638`
> fully verified (power select / asset transfer / `@SUCCESSION`). The succession shares
> the `[0x53D0]` SoL meter (auto-fires at ≥50) but is a distinct event — one interim
> commit briefly mis-filed it as the revolution threshold; resolved, see `RULINGS.md`.

> **Audit pass (2026-06-20).** Re-tested the RESOLVED rows' specific byte claims
> vs the EXE: #1 combat-bonus filler `[0x8D04]` writer `func_007D3E`, #4 tax clamp
> `0x4B`(75), #5 REF spend `0x708`(1800), #11 `"COLONIZE"` magic, #12 score mult
> `[4,5,6,8,10]` (computed `diff+4 (+1≥3)(+1≥4)`) — **all hold.** The earlier
> galleon-fee "table" was an isolated **data-global misID** (`0x8394` = king
> salutation strings, now fixed), not a formula error; the resolved mechanics are
> reliable.

## ★ Authoritative Residual Ledger (2026-06-20 certification)

The single source of truth for **what is left**. Every game system's *byte layer* is
`BYTE_VERIFIED` (`spec/README.md`); the items below are the only open `§6` questions,
each tagged by **why** it is open. Categories **R/O** are not closeable by static
disassembly; **S** is the honest static depth-queue; **F** is inherently soft.

**Category R — runtime/BSS-bound (need a memory dump; out of static scope):**
- `DGROUP:0x9408` REF per-type value table — BSS, runtime-zero in the image (`ref_growth.md`).
- `DGROUP:0x9654` FF candidate-scorer table — BSS at runtime, but its **content is
  loaded verbatim from `@FATHERS`** (known data): so `founding_fathers.md` §6.3 is
  **RESOLVED** (no type-5 father exists; category 5 never instantiates). Only the
  per-father continuous-effect *magnitudes* (§6.1) remain partial (mostly hardcoded,
  documented in §3).
- `training.md` §6.1 — human-side school teaching rate (UI-driven; AI path is **B**).
- ~~`tory_uprising.md` §6.3 — Tory-Militia spawn count.~~ **DONE 2026-06-20** — ≤8 militia on free tiles adjacent to the max-tory-strength rebel colony (`func_03CAC6`); tier → **B**.
- `events.md` §6.1 — Lost-City trigger feature value (runtime-verified `0xB0`; statically reconciled to the `0xF0` high-nibble + an overlay helper).

**Category O — overlay/asset-bound (need RTLink overlay-map reconstruction or a DOSBox trace):**
- BUILDING.SS index→building catalog + CC-NN portrait pixel-confirmation
  (`index_tables.md` §4, `unit.md` §6.3, `notes/SPRITE_CATALOG.md`). Blocked on the
  **MADSPACK-2 `mode=4` decoder**; the `.SS` loader/decompressor is overlay-resident and
  **not statically locatable** (verified 2026-06-20 — `formats/SS.md` §"Loader"). Container
  layout + codec identity are byte-verified; CC-NN = FF portraits (`@FATHERS`, SPRITE-A).

**Category S — static depth-queue (closeable by disassembly; genuinely not yet traced):**
- ~~`save.md` — the SAV write/read format.~~ **DONE 2026-06-20** — full 43-block on-disk
  sequence + autosave (slot 10) byte-verified (`save.md` §3; tier → **B**); only residual
  is HALLFAME per-word score-field *semantics*.
- ~~`warehousing.md` — capacities, `@CARGO` columns, spoilage.~~ **DONE 2026-06-20** —
  cap `(level+1)·100` (`func_008D00`), `@CARGO` 9-col price-drift legend (NAMES.TXT),
  per-good overflow in `func_02D658`; tier → **B** (only wastage-ordering detail left).
- ~~`tutorial.md` — trigger binding / state / sequencing.~~ **DONE 2026-06-20** —
  event-driven, step-shown bitmask `[0x5386]/[0x5387]`, per-step event wiring; tier → **B**.
- ~~`map_system.md` §6.3 `@RESOURCE`→bonus~~ **DONE** (value = bonus magnitude); §6.2
  tile bit-7 **partially** done (bit 0x20+0x80 → terrain 27/28); `.MP` record boundaries remain.
- ~~`immigration.md` §6.3 — recruit-pool slot layout.~~ **DONE 2026-06-20** — pool
  `DGROUP:0x978C` stride 6 (`func_074688`: type `+0x00`, attrs `+0x01–3`, cost word
  `+0x04`); non-artillery cost = `+0x04`, artillery = base+count·100.
- ~~`data/{records,tables}.md` — per-column→loader confirmation sweeps.~~ **DONE
  2026-06-20** — all loaders located; ColonyRecord load-bearing field map resolved.
- **The Category-S static depth-queue is now empty.** Residual narrow bits (all with a
  byte-verified backbone): `map_system.md` `.MP` record boundaries + `§1b` coast
  beach-halo truth table; `warehousing` exact wastage ordering; `events.md` §6.2
  Lost-City bias-cascade per-gate probabilities; `immigration` §6.2 field-unit `-2`
  override + placement handler; `revolution.md` §6.3 WoI end-game flow (PARTIAL);
  `founding_fathers.md` §6.1 per-father effect magnitudes (mostly done; some hardcoded).

**Category F — RESOLVED 2026-06-20.** `diplomacy.md` willingness thresholds + `0x08`/
`0x80` war-bits → **B** (tier → **B**); `natives.md` §6.3 tribute-gold = clamp
`[10, min(3·tribe_wealth+10, 100)]` (`func_04AC00`) → **B**. No fuzzy-AI items remain.

**Closed this certification (2026-06-20):** `0x53A6` = difficulty `0..4` (not current
player; current power = `[0x5394]`) (`difficulty.md`/`turn_dispatch.md`); power-index
fixed `0..3` (`national_powers.md`); **SAV format** (43-block layout + autosave,
`save.md` → **B**); **warehousing** (cap `(level+1)·100`, `@CARGO` legend, overflow →
**B**); **tutorial** (event-driven shown-bitmask → **B**); `@JOB` col-4 = Europe cost;
`@RESOURCE` value = bonus; tile-byte bits; immigration recruit-pool; exploration =
per-player fog (no shared sight); **revolution score bonus = additive `(1780−year)×2`**
(not a multiplier — corrected the manual); unit→sprite = ICONS.SS; data-table loaders.

| # | Gap | Disasm entry point(s) | Upgrades spec doc | Notes |
|---|-----|-----------------------|-------------------|-------|
| 1 | Combat terrain/fort bonus + capture branch | `func_05CA7E` (decider); `func_007D3E` (bonus filler); ladder at `func_05B2C2` | `systems/combat.md` §3/§7 | Land odds `ATK/(ATK+DEF)` **B**; demotion ladder **B**; **terrain/fort bonus now B** (2026-06-19): `func_007D3E` colony+2/fort+4/×2/river+(n+1)·2/open-terrain = `$TERRAIN` "Defensive" col (forests 2/Hills 4/Mountains 6). **Capture branch RESOLVED 2026-06-20:** func_05B2C2 seizes loser types {0 Colonists/0xA Treasure/0xC Wagon} via owner-reassign (0x181F:0x894 @0x5B4C7); ship-victor-without-room destroys. Remaining: `+0x17==0x18` override runtime check. |
| 2 | Market price drift | **`func_0305A8`** (B); per-good base `DGROUP:0x53EA[16]`; trade accumulator `PowerRecord +0xFC` dword[16] | `systems/market.md` §3 | **Drift formula B** (2026-06-19): `price_base[good] -= (base + Σ_players clamped_trade)/256` (`@0x305B3..0x30639`). Price base = random-seeded `[600,1000]` (`func_0755CC`, not a fixed table). Remaining: the turn-loop driver call site + the `+0xFC` buy/sell increment. |
| 3 | Founding-Father acquisition | bell-cost curve **`func_03C282`**; selection `func_03BFD2`; effects `func_03BC42` | `systems/founding_fathers.md` | **RESOLVED 2026-06-19:** bell pool + cost curve **B**; era-band weighted selection **B**; **9 immediate-effect fathers byte-verified** (`func_03BC42` — Fugger/Coronado/La Salle/J.P.Jones/Pocahontas/Bolivar/Brewster/de Brebeuf/las Casas). **UPDATED 2026-06-20:** per-father audit now **21/25 B** (+Minuit `@0x40BB4/0x465D5`, +Magellan `@0x41871`). Remaining 4 `R` = Smith(0)/Stuyvesant(3)/Drake(13)/Penn(21): proven **not** gated via the has-father helper (none of the 50 `0x181F:0x7B4` sites push bits 0/3/13/21) nor a direct `byte[+0x07]` mask test. Narrowed lead: the per-colony building-presence bitmap `ColonyRecord +0x8A` (`func_0085B2`/`0085D6`/`00863E`) + chain table `byte[idx*12+0x8F86]`; pin the colony-screen build-list overlay read for Smith/Stuyvesant. |
| 4 | Tax pretext selection | `func_036138` (pretext builder); clamp `func_034318`; gate `func_0349F4` | `systems/king.md` §3 | **RESOLVED 2026-06-19:** pretext chosen by escalating gate on `[bp-0x52]` (thresholds `0x28A`/`0x3B6`/`0x44C`) → KINGWIFE→KINGWAR→KINGNAVACT→KINGSTAMPACT (`@0x362C7..0x36371`); clamp **75** (`0x03434F`); 60 gate (`func_0349F4`). All **B**, incl. the cadence (turn≥30, interval 18→9 by era) and the `[bp-0x52]` severity score (random(1,1000)+(2·sentiment−tax)·5+gold+turn/30). |
| 5 | REF growth threshold | **driver `func_03E162`** (B); count writers `func_03CDA2`/`func_051EF4` (B) | `systems/king.md` §7, `systems/ref_growth.md` | **RESOLVED 2026-06-19:** `func_03E162` accrues `royal_money += (8·diff+10)·2^era` (eras 1600/1700/1750), buys a REF unit at **threshold 1800 (`0x708`)**, picks the slot by ratio (3:1 reg:cav, 4:1 reg:art, 10:1 land:naval), then spends `+0x22 -= 1800` (`@0x3E271`). +18/turn runtime == `diff=1`. |
| 4b | Colony hammers accumulation + warehouse + completion | production `func_00A3E1`; completion `func_02D658`→`func_02D0E4`→`func_0092E0` | `systems/colony.md` §3/§7 | Per-tile production + SoL% (+ EMA accumulator) **B**. **Warehouse capacity B:** `func_008D00` = `(+0x95+1)·100` (100/200/300); food base 200. **Build-completion RESOLVED 2026-06-20 (B):** inline in `func_02D658` — hammer banks `+0x92` (accrual `@0x2E50F`) + `+0xB6` (cost-debit, surplus carried `@0x2E6A7`); build target `+0x94`; cost from `@BUILDING` table `DGROUP:0x8F8C` (stride 12, `func_074D18`/`func_00B65A`); commit sets persistent mask `+0x84` (display copy `+0x8A`) via `func_0092E0 @0x9308`; target not auto-reset. **Corrects dump labels `+0x10`/`+0x60`/`+0xBA`** (RULINGS 2026-06-20). Residual: `+0x92` vs `+0xB6` roles. |
| 6 | Immigration / cross rate | crosses loop `func_0363A2`; threshold/production `func_035D9A` | `systems/immigration.md` | **RESOLVED 2026-06-19:** crosses loop + threshold shape **B**; **per-turn cross increment B** (base 2 + per-colony `+0x05`, spawn when `+0x2E>+0x30`); dock pool `+0x02..+0x04` confirmed (Brewster). Remaining: the per-slot immigrant-type selector RNG. |
| 7 | Diplomacy outcomes | **`func_057F4E`** (meeting) + **`func_057DC0`** (SIGNTREATY) | `systems/diplomacy.md` | **RESOLVED 2026-06-19:** handlers byte-verified (the "no xrefs" was a grep error — `[bx+si-0x77C4]` displacement). War matrix `+0x34` (bit `0x02`=war), treaty matrix `+0x40` (`0x02`/`0x20`/`0x40` bits), cooldown `[0x53C8+pw*2]=turn+0x10`, symmetric writes. Remaining: AI willingness thresholds + war-matrix `0x08`/`0x80` bits (fuzzy). |
| 8 | Native conversion / raid | `func_0572E6` (conversion); `func_05BE84` (raid); `func_04A7CA` (CHIEFKILL) | `systems/natives.md` | **RESOLVED 2026-06-19:** conversion RNG `random(0,15)`, `P=(TribeData[+2]+2)/15` **B**; CHIEFKILL roll `random(0,40·scout+100)` **B**; raid outcome→key wiring **B** (1 STORES/2 WREAK/3 GOLD/4 BURN-SHIP/0 NOTHING). Remaining: attitude-escalation thresholds; CHIEFKILL roll→gold conversion. |
| 9 | Map generation | mapgen routines (not yet hand-decoded) | `systems/map_generation.md` | Noise seeding sketched; code TBD. |
| 10 | Event triggers & timing | Lost-City `func_061454`; raid `func_05BE84`; trigger = features `0xB0` | `systems/events.md` | **RESOLVED 2026-06-19:** Lost-City trigger (features-layer `0xB0`, runtime-verified) + all 9 `@LOSTCITY<n>` outcomes + FoY=8 immigrants **B**; raid outcome→key wiring **B**. **Magnitudes RESOLVED 2026-06-20:** n=3 gold `10·3d8`, n=7 gift `2·4d10`, n=2 Cibola treasure `100·(10·(scout+2)+1d20)` (`func_061454 @0x6166A/@0x61776/@0x617C6`), scout/difficulty-scaled. Residual: n=2 treasure-unit ×100 + burial rolls. |
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
| Exploration / scout | `func_05A20E`; **sight radius `func_006608`/`func_006468` (B 2026-06-20)** | `systems/exploration.md` |
| Sight radius per unit | ~~radius source~~ **DONE 2026-06-20** — `func_006608` selector (R=1 land, R=2 Scout type 5 / big ships 0x0F-0x11 / any naval with ability #7), `func_006468` `(2R+1)²` reveal, `func_00631A` fog OR `1<<(player+4)`. Residual: FF/ability #7 identity (overlay seg 0x981). | `systems/exploration.md` |
| Difficulty per-level modifiers | ~~`[0x53A6]` modifier table~~ **DONE 2026-06-20** — starting REF (`8·diff+15`/`5·(diff+1)`/`6·diff+2`/`3·diff+2` @0x7569B), combat human handicap `+(4−diff)` (`func_05CA7E`), native attitude human/AI split (@0x46500/@0x46538), AI diplomacy grace `10·(10−diff)`/demand/prob — all **B**. Economy/king touch points **R** with sites. `king_galleon[diff]` confirmed UI-text-only. | `systems/difficulty.md` §3 |
| Colony production | `func_02D658` | `systems/colony.md` |
| Treasure transport | `func_05C878` **(B 2026-06-19)**: value=100×UnitRecord[+0x15]; King cut% = Cortés→tax / else max(5·diff+50, 2·tax) cap 90% (`0x8394` is the king-salutation string table, not a fee); post-indep cashed direct | `systems/events.md` §3 |
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
| ~~Mercenary price (`%NUMBER0`) + offer trigger~~ | **RESOLVED 2026-06-20:** price **B** — `((diff+K)*2 + rand(0,6))*100 * ((catA+catC)*2 + count)`, K=3 wartime (`func_03E442 @0x03E512`) / K=4 peacetime (`func_03E664 @0x03E707`); triggers **B** (1/3 wartime, 1/21 peacetime). **Force composition RESOLVED 2026-06-20:** `func_03EA42→func_03D510` lands a **Man-O-War** at a pop-weighted coastal colony carrying per-category counts from the offer package `[0x9E46/48/4C]`; types via `func_03C4A2` (war: Cont.Army(9)+Cont.Cav(7)+Artillery(11); peace: Dragoons(4)+Artillery), all stamped Veteran (`+0x17 vet_type=0x15`). **B**. | `systems/mercenary.md` |

**Lesson recorded:** the two fabrications (heir-succession, wilderness-camp) came
from an *empty-key* extraction. Always read the real `.TXT` body first; an empty
key is never a license to guess.
