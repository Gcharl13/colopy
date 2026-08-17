# Project Board

Ordered list of remaining work to ship a pixel-exact DOS Colonization clone.
Each task is small enough to complete in one session. Strike through when done.
Re-order only with user approval.

## Legend

- `[ ]` not started
- `[~]` in progress
- `[x]` done
- `[BLOCKED]` needs a prerequisite
- Agent assignments in `(parens)` indicate which subagent owns the task

---

## Tier 0 — Infrastructure (MUST finish before Tier 1)

- [x] 9 custom agents defined in `.claude/agents/`
- [x] Baseline goldens in `tests/golden/` for ONE/UNTITLED/BLANK4/AMER2
      (updated 2026-04-25 to "sand-band baseline" — see RULINGS.md (u);
      contains known gaps for rivers/resources/ocean-dither/forest-density
      that will be closed in subsequent sessions)
- [x] Regression runner `tests/run_regression.py`
- [x] `TRUTH_HIERARCHY.md` written
- [x] `docs/RULINGS.md` with first ruling (mountains/hills rows)
- [x] `SPRITE_CATALOG.md` written (with known gaps flagged)
- [x] `MAP_FORMAT.md` written (4 maps validated, 6 ambiguities flagged)
- [x] `FUNCTIONS_INVENTORY.md` written (A/B/C sections complete; D/E have
      ranked "not-yet-located" targets)
- [x] `CLAUDE.md` orientation doc for future sessions
- [x] `reference/dos/README.md` with capture procedure
- [x] `.gitignore` ready for git conversion
- [ ] `reference/dos/*.png` — DOSBox screenshots of every screen at a known (see CAPTURE_PLAN.md for detailed plan)
      game state. **Requires human action** (capture in DOSBox).
- [ ] Convert project to a git repo (so commits stop failing) — **user
      decision: do we want git here?**

## Tier 1 — Rendering gaps

Each of these is a known DOS behavior our renderer doesn't fully implement.

- [x] **Resource overlay sprites** — tiles with bonus resources show icons
      from PHYS0 row 0x60 (sprites 96-103). Only overlay values 3-14 trigger
      (values 0-2 are border/water/land tags). Sprite-to-resource mapping
      is provisional; `dos-disassembler` can refine once colony-production
      code is located.
- [x] **Water palette cycling** — 4-phase BLEND_ADD tint on PHYS0.SS.148.
      Phase 0 is unaltered baseline so goldens are deterministic. Advances
      every 8 frames.
- [x] **Selection cursor sprite** — PHYS0.095 now used in `_render_selection`
      (fallback white rect retained).
- [x] **Road overlay refinement** — row 0x50 sprites 80-94 indexed by 4-bit
      cardinal road-neighbor mask; mask=15 reuses sprite 80 (sprite 95 is
      the cursor, not a road variant).

- [ ] **River overlay** — feature-layer bit 0x01 (speculative per mapedit.c).
      Layer 2 is empty in all 4 test maps; needs a mid-game save to verify.
      *(renderer-implementer + map-format-decoder after save-game access)*

- [ ] **Per-terrain center variants** — table at VICEROY 0x1DB32 (documented
      in FUNCTIONS_INVENTORY.md). Draws sprite `0x5A + variant` at the center
      sub-cell of each tile. Blocked until the map-editor-slot → .MP-byte
      translation table is recovered. *(renderer-implementer + dos-disassembler)*

- [ ] **Unit sprites from CC-NN sheets** — currently units render as colored
      shape placeholders. Load CC-00..CC-24 sheets, map unit types to sheet
      indices, apply per-nation palette swap. Blocked on CC-NN sheet-to-
      unit-type mapping (hypothesis table in `SPRITE_CATALOG.md`).
      *(sprite-cataloger → renderer-implementer)*

- [ ] **Fog of war** — layer 3 value 1=water, 2=land-no-resource, 0=border.
      No explored/visible distinction observed in shipped maps (fog IS the
      game state, populated per-nation at runtime). Need a save-game to see
      per-nation visibility bits. *(renderer-implementer + map-format-decoder
      after save access)*

## Tier 2 — UI screens (one agent invocation per screen)

- [ ] **Menu bar polish** — DOS menu has specific font color/spacing.
      *(ui-layout-builder)*
- [ ] **Sidebar polish** — beige section dividers, embossed minimap border,
      currently selected unit shown as a proper sprite. *(ui-layout-builder)*
- [ ] **Status bar polish** — DOS uses slightly different hint text per game
      phase. *(ui-layout-builder)*
- [ ] **Colony screen** — pixel-exact rebuild using CLOS-BKG.PIK.
      *(ui-layout-builder)*
- [ ] **Europe screen** — pixel-exact rebuild using EUROPE.PIK.
      *(ui-layout-builder)*
- [ ] **Report screens (F2-F10)** — REPORT1.PIK through REPORT9.PIK.
      *(ui-layout-builder, one per invocation)*
- [ ] **Founding Fathers selection screen** — *(ui-layout-builder)*
- [ ] **Nation selection screen** — polish existing using NATIONS.PIK.
      *(ui-layout-builder)*
- [ ] **Difficulty screen** — polish existing using DIFFICUL.PIK.
      *(ui-layout-builder)*
- [ ] **Dialog / popup system** — use WOODFRAM 9-slice + WOODTILE fill.
      *(ui-layout-builder)*
- [ ] **King audience screen** — KINGLSS1.PIK / KINGLSS2.PIK.
      *(ui-layout-builder)*

## Tier 3 — Game logic fidelity

- [ ] **Map generation algorithm** — decode DOS's continental generator so
      "New Game" produces authentic maps. *(game-logic-verifier + dos-
      disassembler)*
- [ ] **Combat resolution** — attack/defense base values, terrain modifiers,
      veteran bonus, artillery bonus. Validate against save-game replays.
      *(game-logic-verifier)*
- [ ] **European market prices** — base prices per good, random walks,
      Founding Father effects. *(game-logic-verifier)*
- [ ] **Colony production per turn** — yields tables by terrain × good,
      expert bonus, building modifiers. *(game-logic-verifier)*
- [ ] **AI turn order + decisions** — nation personality, priority weights.
      *(game-logic-verifier)*
- [ ] **Founding Father election** — age-based escalating cost, cross-nation
      competition. *(game-logic-verifier)*
- [ ] **Native tribe behavior** — temperament, attack probabilities, tribute.
      *(game-logic-verifier)*
- [ ] **Lost City rumor outcomes** — probability table. *(game-logic-verifier)*

## Tier 4 — I/O and persistence

- [ ] **.COL save-game reader** — parse DOS save files into our GameState.
      *(game-logic-verifier or dos-disassembler)*
- [ ] **.COL save-game writer** — roundtrip-compatible. Enables
      save-game comparison testing. *(same)*
- [ ] **Sound / music** — MIDI playback for in-game music, PCM effects.
      Lower priority. *(not assigned)*

## Tier 5 — Polish / stretch

- [ ] Window resize / DPI handling
- [ ] Save-slot UI
- [ ] Hotseat multiplayer (if DOS had it)
- [ ] AI vs AI auto-play benchmarking

---

## Known ambiguities (from MAP_FORMAT.md / SPRITE_CATALOG.md / RULINGS.md)

Track these separately — they block specific Tier tasks but aren't tasks
themselves:

- **AMB-1** (MAP_FORMAT): Base terrain IDs 17-23 exist in AMER2 but have no
  names. Currently colored as generic land. Needs `dos-disassembler` to
  find the palette-slot → NAMES mapping.
- **AMB-2** (MAP_FORMAT): Bit-5 dual interpretation (Hills vs prime_resource).
  Current code treats it as Hills; empirical data supports this.
- **AMB-3** (MAP_FORMAT): Feature layer (Layer 2) semantics unknown because
  shipped maps have Layer 2 all zero. Needs a save-game to observe non-zero.
- **AMB-5** (MAP_FORMAT): 30 ocean tiles in AMER2 have the road flag. Meaning
  unresolved (harbour markers? river mouths?).
- **AMB-6** (MAP_FORMAT): Forest flag 0x80 in isolation never observed.
  Current renderer handles it speculatively.
- **SPRITE-A**: ~~CC-NN sheet → unit type mapping is hypothesis-only.~~
  **FULLY RESOLVED 2026-05-05**: CC-NN are Founding Father portraits
  (NAMES.TXT @FATHERS by index). UNIT-to-ICONS mapping is now
  byte-cited from NAMES.TXT @UNIT column 1 (Icon). 24 units mapped
  to specific ICONS.SS sprite indices (Caravel=6, Merchantman=7,
  Galleon=8, Wagon Train=9, Artillery=10, Treasure=17, Colonists=101,
  ..., Cont. Cav.=130). See `GAME_INDEX_TABLES.md` "24 Unit types"
  section.
- **SPRITE-B**: ~~BUILDING.SS index → building name not cataloged.~~
  **PARTIALLY RESOLVED 2026-05-05**: PEDIA.TXT @BUILDING0..41
  documents 42 buildings with upgrade chains. Build-menu cost
  table verified for 15 first-tier buildings from session frame
  1310206750. Sprite index → PEDIA index alignment documented in
  `GAME_INDEX_TABLES.md`. **BLOCKER identified 2026-06-20:** the remaining
  per-sprite→building mapping needs the **decoded BUILDING.SS pixels**, but the
  `mpskit` FAB/MADSPACK decoder (`tools/mpskit/*`) is **absent from the repo** and the
  FAB codec is **undocumented** — every `.SS` section is FAB-compressed, so the sheet
  can't be unpacked without first **implementing a decoder** (RE the codec from the
  `.SS` loader in `VICEROY.EXE`). Verified the container is genuine (MADSPACK 2.0,
  4 sections, SHA matches `MANIFEST.md`). This is a decoder-build task, not inspection.
- **SPRITE-C**: Nation-tinting palette-index range for CC-NN not known.
  (CC-NN are FF portraits — nation-tinting probably applies to
  per-power flag sprites ENGLND1/FRANCE1/SPAIN1/DUTCH1 instead.)
- **SPRITE-D**: Row 0x70 (indices 112-127) may be the true DOS coast sub-tile
  sprites at 8×8 resolution — currently unused; current coast approach uses
  sprites 150-153 which is a simplification.

## 2026-05-05 — Major UI / memory finds

PowerRecord layout corrected: stride = **316 bytes** (0x13C),
not 128. New fields:

- `+0x02 byte` = **rebel_sentiment_pct** (USER-VERIFIED frame 1310124562)
- `+0x14 u16` = **founding_father_count**
- `+0x20 u16` = **boycott_bitfield** (per-good; only Food bit set in test)
- `+0x32 u16` = REF aggregate strength rating

DGROUP scalars added:
- `0x53A7 byte` = **king_anger** (+1 per Tea Party — USER-VERIFIED)
- `0x53DA..0x53E1 4×u16` = **REF count** (Reg/Cav/MoW/Art order)

NativeSettlement table at `0x54EC stride 18` — fully decoded
(mission/population/capital — USER-VERIFIED via Inca raze).

CHIEFKILL formula corrected: uses NativeSettlement `+0x04`
(population), NOT TribeData `+2` as previously claimed.

Capital bonus exists on top of CHIEFKILL: Inca pop=13 → 15,000
total; Aztec pop=10 → 10,000 total. Both exceed CHIEFKILL ceiling.
Best-fit hypothesis is `bonus = 1000 × civ_tier × roll(1..5)`.
See `CAPITAL_BONUS_ANALYSIS.md`.

Asset library full identification 2026-05-05:
- 510 GAME.TXT message sections (`GAME_TXT_CATALOG.md`)
- 7 LABELS.TXT sections (`LABELS_TXT_CATALOG.md`)
- 163 PEDIA.TXT indexed entries (`PEDIA_TXT_CATALOG.md`)
- 35 PIK backgrounds (REPORT1..9 mapped to advisor types)
- 25 CC-NN founding-father portraits (each FF visually identified)
- 13 WDCUT event scenes (each event correlated)
- 8 IND tribe sprites (per NAMES.TXT @TRIBES order)
- All MSS/MYR/KING half-figure speakers
- ICONS commodity range (slots 12-27 for 16 goods)
- ICONS slot 043 = boycott red-X overlay marker

Renderer geometry now lives byte-cited in `viceroy_source/docs/SCREEN_LAYOUTS.md` +
the per-screen `spec/ui/*.md` (the older overlay-measured `RENDERER_GEOMETRY.md` was
removed in the 2026-06-22 cleanup).

- **AMB-7** (SPRITE_CATALOG): PHYS0 sprite indices 0, 16, 100 are 1×1 placeholders
  in the current extraction. Investigate whether mpskit has options to recover
  the actual frame data, or whether the source .SS file genuinely has empty slots.
  (Blocked on mpskit investigation; not blocking any Tier task currently.)

Each of these is a discrete unblock task. Assign to the appropriate Tier 1
agent when it becomes the bottleneck.

---
## Rules for this file

1. Tasks always start at the top of a tier and work down.
2. If a task is blocked, mark `[BLOCKED]` and note the dependency.
3. When a task completes, mark `[x]` and note any new follow-up tasks it
   spawned (add them to the appropriate tier).
4. Re-orderings require user approval.
5. If a task seems too big for one session, split it.

---
## Out of fidelity scope — audio (now a separately-scoped cport milestone)

Audio is **explicitly excluded** from the "100% identical except audio"
done-bar (user scope decision). It does not gate any Tier task and cannot
regress the pixel/behaviour fidelity gate.

- Spike findings: `notes/rulings/AUDIO_SPIKE.md` (in-scope go/no-go = **NO-GO**;
  that bar stands).
- Verified fact: `COLONIZE/{A,G,P,R}SOUND.COL` are `MZ` DOS executables
  (sound *drivers*), not decodable sample banks; `AMERICA.MOV` is a decoded
  demo script, not audio (`spec/ui/cinematics.md` §11.3,
  `data_extracted/data/AMERICA_MOV.json`).
- **2026-08-16: commissioned as a separately-scoped pragmatic milestone**
  targeting `cport/` (user directive; ruling in `notes/rulings/RULINGS.md`
  2026-08-16; design in `docs/AUDIO_PORT.md`). Still does not pull into P1–P7.
- **2026-08-17: delivered through the software phases.** Scheduler/gate/class
  verbs byte-pinned (spec §4/§5) and ported (`cport/audio/`, host tests
  green); full capture sweep done (all tunes, fanfares, SFX; 3 ids silent =
  unmapped); `COLAUDIO.PAK` 67 entries (16 bit-clean COLDIG slices + 51
  renders) validator-clean; cues + pump wired in both shells; P4 I2S and
  Teensy MQS backends written. **Remaining = hardware:** flip `COLOPY_AUDIO`
  on a real board, run the A/B listen pass (`docs/AUDIO_PORT.md` §listen),
  record outcomes. Cue gaps (European-contact fanfare, combat SFX) and the
  Pick-Music/Sound-Options screens in cport's input layer stay open.
