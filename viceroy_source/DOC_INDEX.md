# DOC_INDEX — Documentation Audit & Source-of-Truth Map

**Generated:** 2026-05-30 (documentation audit).
**Scope:** every `.md` under `reverse_engineered/viceroy_source/` (top-level,
`docs/`, `formats/`, `data/`, `src/overlay/`). 54 source docs (+ this index).
(Three 2026-05-30 docs — `UI_VERIFICATION.md`, `OPENING_SEQUENCE.md`, plus a
concurrently-landing edit — were committed while this audit ran and are
included.)

This index answers one question: **for any topic, which document do I trust?**
Most prose system docs were written 2026-05-28 and predate the 2026-05-30 work
(the RTLink overlay wall being cracked + the wave-3..12 byte-verification waves).
Many carry a blanket `>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<` banner and are
explicitly contradicted by `docs/RULINGS.md` and the byte-verified `src/**/*.c`.

> **Note on dates.** "Date" = git last-commit date (`git log -1 --format=%cs`).
> A 2026-05-30 date does NOT automatically mean current/authoritative — two
> 2026-05-30 docs (`EUROPEAN_DIPLOMACY.md`, `RENDER_CHAIN.md`) are 2026-05-28
> reconstructions that only got *partial in-place retraction banners* appended,
> and `docs/DATA_MODEL.md` is a hybrid (a verified section appended atop a stale
> struct body). Conversely a 2026-05-28 format spec can still be fully correct.
> Verdicts below are based on **content cross-checked against RULINGS / src/**,
> not the date alone.

---

## Ground-truth hierarchy (cite in this order)

When two sources disagree, the higher tier wins:

1. **The byte-verified C source** — `reverse_engineered/viceroy_source/src/**/*.c`
   (and `data/*.c`, `include/*.h`) where the value carries an `@asm` citation and
   a `BYTE_VERIFIED` tag. This is the ULTIMATE truth: it is read directly from
   `COLONIZE/VICEROY.EXE` bytes. (Caveat: a `.c` file with a `RECONSTRUCTED` /
   `[TBD]` banner is *not* tier-1 for the un-verified parts — read the per-file/
   per-block status legend.)
2. **`docs/RULINGS.md`** (project root, **not** under viceroy_source) — the
   conflict-resolution truth log. A ruling overrides any prose doc and records
   *why*. Newest dated entry wins within a thread; overturned entries link forward.
3. **The 2026-05-30 generated catalogs + derived views** —
   `FUNCTION_INVENTORY.md`, `VERIFICATION_LEDGER.md`, `docs/DATA_MODEL.md`
   (verified sections only), `docs/EVENT_DISPATCH.md`, `docs/COMBAT_STATS.md`,
   `docs/OVERLAY_THUNKS.md`, `docs/NEXT_TARGETS.md`,
   `docs/{event_catalog,event_graph,decompile_status}.html`. Current derived views
   over tiers 1–2.
4. **Prose system docs** (`docs/*_SYSTEM.md`, `docs/COMBAT.md`, etc.) — summaries.
   May lag the code; treat numeric claims as RECONSTRUCTED unless cross-checked.

---

## Verdict legend

- **AUTHORITATIVE** — current; matches the code / RULINGS; keep using.
- **STALE-REVIEW** — predates the 2026-05-30 work; makes claims that may be
  outdated or are contradicted by RULINGS / src; needs review before use.
- **SUPERSEDED** — replaced by a newer doc/artifact (named in the table).

---

## AUTHORITATIVE (14)

| Doc | Date | Topic | Canonical source for this topic | Notes |
|---|---|---|---|---|
| `FUNCTION_INVENTORY.md` | 2026-05-30 | Master "where does X happen" — game-system entry-point functions | itself + `src/**` + `VERIFICATION_LEDGER.md` | Current. Carries wave-12 findings, corrected sizes (func_05B2C2 2926 B, func_02883E 1357 B), and links to the real `.c` files. Reflects the 2026-05-30 native/combat/event re-labels. |
| `docs/OPENING_SEQUENCE.md` | 2026-05-30 | Launch → playable-map opening-sequence decode audit (6 stages) | itself + `src/{boot,runtime,mapgen,ui}/*` + `docs/decompile_status.*` | Current. Byte-verified end-to-end spine (boot → @BEGINMENU dispatch func_0759E8 → difficulty/nation pickers → func_07431E/func_0755CC new-game init → mapgen func_064A10 → seed Caravel+Soldier+Pioneer trio). Honest bounded gaps (`_main()` not pinned; `system_init` PARTIAL; @VICEROY/@LANDHO emitter call-sites untraced). Independently flags stale-doc drift (decompile_status.json, title_screen.c skeleton, ASSET_ROLES.md fabricated TITLE.PIK). |
| `docs/UI_VERIFICATION.md` | 2026-05-30 | Per-screen UI map + how to TEST the UI/visuals | itself + `src/render/*` + `src/ui/*` + `reference/dos/` | Current. Byte-verified pixel pipeline (`tile_chain.c` O514→O513→O512, 0 skeletons) + layout geometry; honest about the 5 `*_screen.c` SHELLS and the missing colony/europe/report goldens. Correctly cites RULINGS on the editor-export "structure-not-pixels" caveat. **The UI/visuals authority.** |
| `VERIFICATION_LEDGER.md` | 2026-05-30 | What is BYTE_VERIFIED vs ANCHOR/RECONSTRUCTED/WRONG | itself | The status-tier source of truth. Use the 4-tier scale (BYTE_VERIFIED / ANCHOR_VERIFIED / RECONSTRUCTED / WRONG) it defines. |
| `docs/COMBAT_STATS.md` | 2026-05-30 | @UNIT column → stat-offset map; per-unit atk/def table | itself + `src/combat/combat.c` + `data/unit_classes.c` | BYTE_VERIFIED. Resolves the `[TBD-data]` and RULINGS wave-6 §3. LAND atk=0x5236/def=0x5235; SHIP guns=0x523b/hull=0x523c. **This is the combat-stats authority** (overrides `docs/COMBAT.md`). |
| `docs/EVENT_DISPATCH.md` | 2026-05-30 | Event/report dispatch (`func_0235D6`), European-events cluster | itself + `src/overlay/*` + `docs/event_*.html` | Current. Byte-verified dispatcher, 27-case switch, the @SUCCESSION/@INVASION/etc. handler table. Confirms independence gate = rebel% ≥ 50 (`[0x53D0]`). |
| `docs/OVERLAY_THUNKS.md` | 2026-05-30 | RTLink thunk resolution; the two high-value deciders | itself + `tools/rtlink/` + RULINGS 2026-05-30 (RTLink breakthrough) | BYTE_VERIFIED. Proves the overlay wall is statically resolvable. **Supersedes the format claims in `docs/RTLINK_OVERLAYS.md`** and the land.c BLOCKED corollary. land decider = func_05CA7E. |
| `docs/NEXT_TARGETS.md` | 2026-05-30 | Remaining unknown functions / residue after overlay port | itself | Current. Records "overlay C-port complete (0 orphans)" + the 12 bounded `TBD-inner` functions grouped by root cause. A live backlog, not a claims doc. |
| `GAME_SYSTEM_ANCHORS.md` | 2026-05-30 | System → entry-point function via string analysis | itself + `src/**` | Mostly current; reflects the 2026-05-30 func_05CA7E size + role and links current `.c` files. Minor caveat: a few rows still show truncated "detected size" alongside the real size, and some rows are "not yet decompiled" — read the Status column. |
| `RECONSTRUCTION_PLAN.md` | 2026-05-30 | The plan / scope / END GOAL (C source = the product) | itself | Current. Encodes the 2026-05-30 user directives (byte-accuracy + portable-spec structure; cite-or-TBD absolute). |
| `src/overlay/MANIFEST.md` | 2026-05-30 | Auto-generated overlay function list (691 fns / 24 files) | `overlay_functions_reseg.json` + the porting `.c` headers | Auto-generated; **its own banner warns the Size column is truncated** and lists the real extents (func_057F4E 7151, func_05B2C2 2926). Trust the structure/list, not the sizes. |
| `docs/ARCHITECTURE.md` | 2026-05-28 | Top-level binary facts (size, compiler, linker, memory model) | itself | No RECONSTRUCTED banner; structural facts (494,910 B, MSC 6.0, RTLink Plus, madsdev.lib) match RULINGS/PROGRESS. Low-risk; nothing here was overturned. Spot-check: file size + RTLink Plus identity confirmed by RULINGS 2026-05-30. |
| `formats/README.md` | 2026-05-28 | Index of the 15 file-format specs | itself + `formats/*.md` | Format-spec index; unaffected by the gameplay-logic waves. Status column (DONE/PARTIAL) is honest. |
| `README.md` | 2026-05-28 | Tree overview, citation convention, reading order | itself | The citation-convention + reading-order doc. The directory-layout block lists an older `src/` shape (e.g. `combat/{resolve,modifiers,demotion}.c`) that no longer matches (now `combat.c`/`land.c`/`naval.c`/`combat_demotion_ladder.c`/`combat_modifiers.c`), but the *convention* it teaches is current. Minor layout drift only. |

### Format specs (`formats/*.md`) — AUTHORITATIVE as a group (13 files, all 2026-05-28)

Byte-level format specs are stable; the 2026-05-30 work was gameplay logic, not
file formats. Treated as AUTHORITATIVE unless a RULINGS entry says otherwise.

| Doc | Topic | Notes |
|---|---|---|
| `formats/PAL.md` | VICEROY.PAL palette | DONE |
| `formats/SS.md` | MS_SPRITE sheet (206 .SS) | DONE — the sprite-format authority |
| `formats/PIK.md` | Packed image (CVPC + MS_SPRITE) | DONE |
| `formats/FF.md` | Font format (5 .FF) | DONE |
| `formats/MP.md` | Map file (.MP) | DONE — byte layout; cross-check map *semantics* against `MAP_FORMAT.md` / .MP bytes, never mapedit.c |
| `formats/TXT.md` | Sectioned text (NAMES/GAME/TRIBE/…) | DONE — names NAMES.TXT as the data authority (matches RULINGS) |
| `formats/DAT.md` | Binary tables (CYCLE/PATH/INSTALL) | DONE |
| `formats/COL.md` | **Sound-driver / config** .COL (ASOUND/GSOUND/…/CONFIG.COL) | PARTIAL. Correctly scopes .COL as *sound/config* — consistent with RULINGS 2026-05-29 ("CONFIG.COL is the only real .COL"). NOTE: the DOS *save* format is unrelated — magic `"COLONIZE"`, see RULINGS wave-10 + `src/save/*.c`; do not conflate with the Win16 `.COL2`. |
| `formats/BIN.md` | COLDIG.BIN sample bank | PARTIAL |
| `formats/MOV.md` | AMERICA.MOV cinematic | PARTIAL |
| `formats/PCX.md` | ZSoft PCX | DONE (standard) |
| `formats/GIF.md` | CompuServe GIF | DONE (standard) |
| `formats/MADSPACK.md` | MADS pack/compression wrapper | DONE |

---

## STALE-REVIEW (14)

These predate 2026-05-30 (or are hybrids) and carry the blanket
`>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<` banner unless noted. Each lists at
least one claim now contradicted by RULINGS or the code.

| Doc | Date | Topic | Canonical source for this topic | Contradicted-claim notes |
|---|---|---|---|---|
| `docs/SCORING.md` | 2026-05-28 | Final score formula + endgame flow | `src/scoring/{compute,endgame}.c` (rewritten 2026-05-30) + RULINGS wave-3/wave-5 | **Model is contradicted.** Its `compute_final_score` = pop×5 + treasury/100 + FF×50 + bells/50 then ×difficulty. RULINGS wave-5 WITHDREW the "+0x2A = score" framing (it is **GOLD**), and the real endgame score is the **rank ladder in `func_03A9C0`** ((k·k)/3 × difficulty) over an overlay value (0x191F:0x3AA) — see `src/scoring/compute.c` "CORRECTION 1" + `endgame.c`. The difficulty-multiplier table and per-component breakdown are unverified. HallFameEntry layout: DOS HALLFAME.DAT now resolved in `endgame.c` (cross-check there). |
| `docs/AI_SYSTEM.md` | 2026-05-28 | AI driver + personality | `src/ai/{driver,unit_ai_leaf,unit_orders}.c` + RULINGS 2026-05-28 (ai) / 2026-05-29 (AIPersonality) | **Contradicted.** Claims a "nine-axis" AIPersonality (aggression/expansion/…) — RULINGS 2026-05-28 (ai) says those weights are **NOT byte-verified and are contradicted**; only the **controller flag** is verified, at AIPersonality **+0x31** (base 0x540E), per RULINGS 2026-05-29 (RESOLVED). The "256 unit loop" / `ai_personality_id` field are reconstructions. Per-unit AI = func_04E2D6 / func_05CA7E. |
| `docs/NATIVE_RELATIONS.md` | 2026-05-28 | Tribes, settlements, missions, raze | `data/tribe_data.c` + `include/native.h` + `src/native/*.c` + RULINGS 2026-05-30 (native tribe data) | **Contradicted on the basics.** Says "2 advanced + 6 semi-nomadic", tribe order **Aztec=0/Inca=1**, binary type flag, and a wealth column. RULINGS 2026-05-30 (and `data/tribe_data.c`) prove: @TRIBES order is **Inca=0, Aztec=1, Arawak, Iroquois, Cherokee, Apache, Sioux, Tupi**; FOUR @LEVELS tiers (Semi-Nomadic/Agrarian/Advanced/Civilized); wealth tracks the advancement LEVEL. NativeSettlement = 18 B @0x54EC (+0x02 owner, +0x04 pop). Raze gold = `src/native/native_village_raze.c` (func_04A7CA, ×pop). |
| `docs/COMBAT.md` | 2026-05-28 | Combat resolution model | `src/combat/combat.c` (BYTE_VERIFIED) + `docs/COMBAT_STATS.md` + RULINGS combat waves 6/7/9/10 | **Wrong RNG form + over-broad bonuses.** Uses `roll=random_range(0,total-1); roll<atk`; the verified roll is `random_int(1,ATK+DEF); attacker wins iff roll<=ATK` (RULINGS 2026-05-28 combat says the old form "breaks replay"). The flat +50% fortified/veteran/SoL multipliers were SCOPED by wave-6/9: the ship roll reads RAW stats (no scaler); land bonuses live in the func_05CA7E modifier chain (manual-confirmed but table still partly TBD). Promotion/demotion ladder prose is close to `combat_demotion_ladder.c` but unverified in detail. *Mostly SUPERSEDED by `combat.c` + `COMBAT_STATS.md`; left as STALE-REVIEW because no single prose doc replaces its narrative scope.* |
| `docs/KING_TAX.md` | 2026-05-28 | King tax, demands, REF buildup | `src/king/*.c` (`tax_apply`, `king_tax_raise`, `king_events`, `ref`, `demands`, `intervention`, `war_turn`) + RULINGS 2026-05-28 (market) + GAME_SYSTEM_ANCHORS | Banner-reconstructed. Tax cap 75 (0x4B) IS byte-verified (GAME_SYSTEM_ANCHORS / func_034318), but the `market_sell_with_tax` formula and "tax accrues implicitly to king" prose are unverified; tax is PowerRecord **+0x01** (RULINGS market). CAUTION: RULINGS 2026-05-30 flags `king_tax_raise.c`'s `ovly_181F_04D4` as MISIDENTIFIED (it's `random_int`, not "ask king") — that bug is in the code, but it means king-tax accept-logic is itself under re-trace. |
| `docs/COLONY_SYSTEM.md` | 2026-05-28 | Colonies, production, buildings | `src/colony/*.c` (`turn_update`, `sol_tory`, `auto_manage`, `assignment`, `accessors`, `commodity`) + `data/{terrain_yield,building_costs}.c` | Banner-reconstructed. The colony struct is `*(0x8542)`; SoL/Tory + food + training handler = func_02D658 (`sol_tory.c`, BYTE_VERIFIED per FUNCTION_INVENTORY). Treat the prose production formulas / building tables as unverified until cross-checked against the colony `.c` files and `data/*.c`. |
| `docs/UNIT_SYSTEM.md` | 2026-05-28 | Unit types, movement, cargo | `include/unit.h` + `docs/COMBAT_STATS.md` (the 23-row @UNIT table) + `src/unit/*.c` | Banner-reconstructed. Says "45 active unit types"; the verified @UNIT table has **23 rows** (COMBAT_STATS.md §3, `cmp 0x17`). UnitRecord base **0x3144** stride 0x1C (RULINGS 2026-05-28 RESOLVED) — defer the field map to `unit.h` / DATA_MODEL §3, not this prose. |
| `docs/MAP_GENERATION.md` | 2026-05-28 | Procedural map algorithm | `src/mapgen/{generator,climate,rivers,settlements}.c` | Banner-reconstructed; algorithm not byte-verified. Use the mapgen `.c` files (themselves verify-as-you-read). Map grid is 58-wide (RENDER_CHAIN/MAP_SYSTEM). |
| `docs/FOUNDING_FATHERS.md` | 2026-05-28 | 25 fathers + Congress | `include/ff.h` + `data/ff_effects.c` + `src/founding_fathers/*.c` (`congress`, `effects`, `recruit`) | Banner-reconstructed. "25 fathers / 5 ages / bells-gated" is structurally right, but per-father effects + age-unlock numbers are unverified — cross-check `data/ff_effects.c`. (FF-recruit runtime crash was fixed in the Python port, unrelated; see project commit log.) |
| `docs/REVOLUTION.md` | 2026-05-28 | Independence + REF deployment | `src/king/{war_turn,intervention,ref}.c` + `docs/EVENT_DISPATCH.md` + RULINGS wave-6 (king-military) | Banner-reconstructed. The real per-turn War-of-Independence handler = func_02F3A2 (`war_turn.c`); FUNCTION_INVENTORY's old "func_02F3A2 = win/lose check (YOULOSE/YOUWIN)" was WRONG (RULINGS wave-6 §4). Independence gate = rebel% ≥ 50 (EVENT_DISPATCH). REF +50% / cancellation prose is unverified. |
| `docs/RANDOM_EVENTS.md` | 2026-05-28 | LCR / weather / disease | `src/random_events/{lcr,weather,disease}.c` | Banner-reconstructed; event probabilities/effects not byte-verified. LCR raze-treasure path IS partly verified elsewhere (`src/native/raze_treasure.c`, CASHTREASURE). Cross-check the `.c` files. |
| `docs/MAP_SYSTEM.md` | 2026-05-28 | Terrain/feature/resource layers (in-memory map) | `MAP_FORMAT.md` (project root) + `formats/MP.md` + RULINGS terrain-ordering rulings | Banner-reconstructed. Terrain-ID ordering must come from `extracted/text/NAMES_sections.json` / .MP bytes, **never mapedit.c** (CLAUDE.md hard rule). Useful as orientation; verify any specific terrain byte against the .MP / RULINGS. |
| `docs/ENGINE.md` | 2026-05-28 | madsdev.lib API surface | `D1D_181F_RUNTIME.md` + `formats/MADSPACK.md` + the runtime `.c` files | Banner-reconstructed API narrative. The concrete resident-call decoding lives in `D1D_181F_RUNTIME.md` (itself partly stale on Type-A, see below). Treat API signatures as illustrative. |
| `docs/ASSET_ROLES.md` | 2026-05-28 | Each COLONIZE/ asset → loader function | `docs/UI_VERIFICATION.md` + `formats/*.md` + `src/asset/asset_loader.c` + CLAUDE.md hard rules / `SPRITE_CATALOG.md` | Banner-reconstructed (`@ref COLONIZATION_TECHNICAL_REFERENCE.md`). *Less wrong* than the gameplay docs — its hard-rule facts match CLAUDE.md (BDARK.SS = orphan/never-load; CC-NN = FF portraits not unit sprites; TERRAIN.SS IS used). But the specific "loaded by `_main()` at boot" / on-demand attributions are not byte-cited; verify any loader claim against `src/asset/asset_loader.c` + the `load_image/` files. **Known defect:** contains a fabricated `TITLE.PIK` reference (~line 182) per `docs/OPENING_SEQUENCE.md` stale-doc note. |

---

## SUPERSEDED (6)

| Doc | Date | Topic | Superseded by | Notes |
|---|---|---|---|---|
| `docs/RTLINK_OVERLAYS.md` | 2026-05-28 | RTLink Plus overlay format | `docs/OVERLAY_THUNKS.md` + `tools/rtlink/RTLINK_V2.md` + `src/overlay/rtlink.c` + RULINGS 2026-05-30 (RTLink breakthrough) | OVERLAY_THUNKS.md explicitly states it "supersedes the RECONSTRUCTED thunk-format claims in docs/RTLINK_OVERLAYS.md". The "VPs cannot be statically resolved" premise is overturned — VICEROY = RTLink/Plus **V2**, fully statically flattenable. |
| `D1D_181F_RUNTIME.md` | 2026-05-28 | 0x181F / 0xD1D thunk-table runtime calls | `docs/OVERLAY_THUNKS.md` + `tools/rtlink/` (xref.py / rtlink_decode.py) | The Type-B (load-image) decoding is still valid and useful, but its core claim that **Type-A "cannot be decoded without loading the overlay"** is OVERTURNED by the 2026-05-30 V2 flattener — Type-A targets are now statically resolvable. Use the resolver, then this doc as a helper glossary. *Partial-stale → classed SUPERSEDED because its central limitation no longer holds.* |
| `docs/EUROPEAN_DIPLOMACY.md` | 2026-05-30* | European diplomacy, treaties, market | `src/diplomacy/{meeting,treaty,relations}.c` + RULINGS 2026-05-30 (wave-4 diplomacy) | *Hybrid: 2026-05-28 reconstruction + a 2026-05-30 retraction banner. Two sections are FABRICATED & marked in-place: the `-100..+100 rel_score[8]` model and the `rel_state[8]` Peace/War/Alliance enum + `ai_evaluate_treaty()`. Real diplomatic state = the **war bit-matrix at DGROUP 0x883C** (`treaty.c`). Trust the `.c` files; the rest of the prose is illustrative/unverified. |
| `docs/RENDER_CHAIN.md` | 2026-05-30* | Pixel pipeline (func_O514→O513→O512) | `src/render/{tile_chain,terrain,blit,units,hud}.c` + RULINGS 2026-05-30 (wave-4 render) | *Hybrid: 2026-05-28 reconstruction + a 2026-05-30 retraction banner. The **dirty-rect system is FABRICATED** (no `tile_dirty[]`/`tile_is_dirty()`/`tile_clear_dirty()` in the binary) and marked in-place; the verified chain redraws all 15×12 tiles unconditionally. The O514→O513→O512 chain itself is correct and ported; trust `tile_chain.c`. Layer-source table is a useful summary but verify sprite indices against `SPRITE_CATALOG.md`. |
| `COMPLETION.md` | 2026-05-28 | Per-module completion status snapshot | `VERIFICATION_LEDGER.md` + `docs/NEXT_TARGETS.md` + `COMPLETION` numbers in current `src/` | Pre-overlay-breakthrough snapshot. Headline counts are stale (e.g. "36 .c source files" / "~641 overlay auto-traced"; the tree now has **121 .c files** and the overlay C-port is COMPLETE with 0 orphans per NEXT_TARGETS). The ~47 BYTE_VERIFIED honesty caveat it states is still a fair characterization. |
| `COMPLETE_FINDINGS.md` | 2026-05-28 | Comprehensive 2026-05-03-era findings dump | `FUNCTION_INVENTORY.md` + `VERIFICATION_LEDGER.md` + RULINGS | Self-dated "as of 2026-05-03". A historical snapshot superseded by the 2026-05-30 catalogs for any current claim. The COLONIZE/ file-inventory table is still a handy reference, but function statuses are stale. |

---

## Logs / status snapshots (informational — not claim sources)

| Doc | Date | Topic | Notes |
|---|---|---|---|
| `SESSION_LOG.md` | 2026-05-28 | Per-session progress log | Latest entry is 2026-05-02. Historical record; NOT a current-state source. Newer work is logged in RULINGS + `src/` commit history. |
| `PROGRESS.md` | 2026-05-29 | Honest status (BYTE_VERIFIED vs ANCHOR vs TBD) | Good honesty framing and mostly-correct anchors (unit_table@0x3144, colony@0x8542, PowerRecord 0x13C). Predates the overlay breakthrough — its "RTLink … 1,020 thunk entries" and AI-overlay-blocked framing are now refined by RULINGS 2026-05-30 + OVERLAY_THUNKS.md. STALE-REVIEW-grade; kept here as a status snapshot. |
| `data/README.md` | 2026-05-28 | Index of the 8 `data/*.c` tables | Table index. The individual `data/*.c` files carry their own per-file verification banners (e.g. `tribe_data.c` was corrected 2026-05-30; `unit_classes.c` values verified, two offset comments need fixing per COMBAT_STATS §5). Trust the `.c` banners over this index. |
| `src/overlay/HAND_PORT_NOTES.md` | 2026-05-28 | Hand-port working notes (overlay) | Working notes; cross-check against the current overlay `.c` files + MANIFEST. |
| `src/overlay/OVERLAY_LCALL_REFERENCE.md` | 2026-05-28 | Catalog of overlay LCALL targets | Useful glossary; superseded for *resolution* by `tools/rtlink/` xref + OVERLAY_THUNKS.md. Predates the V2 flattener. |
| `src/overlay/SEGMENTS.md` | 2026-05-28 | Overlay segment layout | Cross-check against `tools/rtlink/RTLINK_V2.md` (which corrected the page-0x1A two-segment packing per RULINGS wave-10). |

---

## Gaps — topics with NO fully-AUTHORITATIVE standalone doc

For these, the prose doc is STALE-REVIEW and the only trustworthy source is the
`src/**/*.c` files + RULINGS. A dedicated byte-verified prose summary is missing:

1. **Scoring / endgame** — no authoritative prose doc. `docs/SCORING.md` is
   contradicted; the truth is in `src/scoring/{compute,endgame}.c` + RULINGS
   wave-3/wave-5 (score = func_03A9C0 rank ladder, NOT the SCORING.md formula).
2. **AI behaviour / personality math** — `docs/AI_SYSTEM.md` is contradicted;
   the personality-weighted decision math is still largely overlay-`TBD`
   (RULINGS 2026-05-28 ai). Only the controller flag (+0x31) is verified.
3. **King tax / demands / REF** — `docs/KING_TAX.md` + `docs/REVOLUTION.md` are
   reconstructed; spread across `src/king/*.c`, and `king_tax_raise.c` has a
   flagged misidentification (RULINGS 2026-05-30 `ovly_181F_04D4`). No clean
   verified summary.
4. **Colony production / building economics** — `docs/COLONY_SYSTEM.md` is
   reconstructed; the verified pieces are scattered (`sol_tory.c` func_02D658,
   `auto_manage.c`, `data/{terrain_yield,building_costs}.c`). The per-good
   production formulas remain partly `TBD`.
5. **Native behavioural tables** (aggression / pop / skills) — explicitly
   `TBD`/overlay-resident per RULINGS 2026-05-30; `data/tribe_data.c` carries
   only the verified @TRIBES/@LEVELS data, behavioural params demoted to TBD.
6. **Market price→coin-value (bid/ask) curve** — `TBD` behind overlay thunk
   0x181F:0x9A4 (RULINGS 2026-05-28 market); no doc states the actual curve.
7. **Land combat terrain/fort bonus table** (feeds `[0x8D04]`) — manual-confirmed
   to exist (RULINGS 2026-05-30 manual) but the numeric table is still `TBD`;
   `docs/COMBAT_STATS.md` covers the raw stats only.
8. **Data model / struct layouts** — *partial gap.* `docs/DATA_MODEL.md`
   (viceroy_source, 2026-05-30) is a HYBRID: its newly-appended NAMES.TXT
   38-section → DGROUP table-base map is verified, but it still carries the
   blanket RECONSTRUCTED banner and its **PowerRecord struct body is the OLD
   reconstructed layout** (controller@0x01, difficulty@0x02, buy_price@0x2E,
   ff_progress@0x2A) which CONTRADICTS the byte-verified PowerRecord
   (Tax@+0x01, Gold@+0x2A, FF-mask@+0x07, price_level byte[16]@+0x4C, volume
   word[16]@+0x5C — RULINGS wave-3 + PowerRecord-layout memory). **The verified
   data model is the SIBLING file `reverse_engineered/docs/DATA_MODEL.md`** (the
   one RULINGS repeatedly calls "the cited authority") + `include/*.h`. The
   viceroy_source copy is therefore STALE-REVIEW for struct layouts / AUTHORITATIVE
   only for its appended NAMES.TXT→DGROUP section. Listed here as a gap because no
   single doc *inside viceroy_source* is a clean authoritative data model.

---

## Audit method (reproducibility)

- File list: `find reverse_engineered/viceroy_source -name '*.md'` (54 source
  docs + this index).
- Dates: `git log -1 --format=%cs -- <path>` (≈39 @ 2026-05-28, 1 @ 2026-05-29,
  ≈14 @ 2026-05-30; a few 2026-05-30 docs landed during the audit).
- Each doc read/skimmed; claims spot-checked against `docs/RULINGS.md` (project
  root) and the byte-verified `src/**/*.c` headers (status legends + `@asm`
  citations).
- Verdicts reflect **content vs. tiers 1–2**, not date alone. Where a doc could
  not be independently byte-confirmed, the note says so rather than guessing.
