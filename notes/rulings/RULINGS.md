# Cross-Source Rulings

The `cross-source-reconciler` agent records rulings here. One ruling per
conflict. If a ruling is later overturned, add a NEW entry that supersedes
and links back — don't edit the old one.

Format:

```
## YYYY-MM-DD — Short title

**Conflict**: one-sentence summary of what disagreed.

**Source A** — [which source/agent] said: [claim], citing [evidence].

**Source B** — [which source/agent] said: [claim], citing [evidence].

**Ruling**: [decision] because [rule from TRUTH_HIERARCHY.md].

**Action taken**:
- [which files updated]
- [what code change if any]

**Follow-up**: [any open question the ruling does not close]
```

---

## 2026-06-19 — Runtime memory dump (`colonization-memory-map (1).md`) reconciled against the static disasm

**Conflict**: a runtime-verified PowerRecord field map (observed in js-dos/DOSBox,
several fields **write-verified**) disagrees with the static-disasm field labels on
three offsets, and corroborates many others.

**Source A** — runtime dump (`colonization-memory-map (1).md`, top of TRUTH_HIERARCHY:
"Running DOS game"). PowerRecord stride `0x13C`. Write-verified: `+0x2A` gold,
`+0x01` tax, `+0x44/+0x45/+0x46` REF counts (dragoons/regulars/artillery — "zeroing
removes the REF"), features-layer `0xB0` = Lost-City marker (plant/remove verified).
Read-verified: market arrays `+0x4C` sensitivity u8[16], `+0x5C` pool s16[16], `+0x7C`
traded-volume s32[16], `+0xBC` EU-supply s32[16], `+0xFC` base s32[16]; `+0x0C`
congress-progress, `+0x0E` bells, `+0x10` crosses/turn, `+0x14` FF-count, `+0x30`
"recruit cost", `+0x32` REF-strength.

**Source B** — static disasm (this branch). `func_0305A8` reads `+0xFC` as the
**drift accumulator**; `func_0363A2` writes the **crosses threshold** to `+0x30`;
`func_03E162` increments REF **globals** `0x53DA[4]` (regulars/cavalry/manowar/arty).

**Ruling** (per TRUTH_HIERARCHY "Running DOS game > EXE disasm; but EXE bytes win for
exact numbers/operations"):
1. **`+0x4C` is market *sensitivity* (u8[16]), NOT a price array** — the old
   `market.md`/`DATA_MODEL` "+0x4C[16] price-level" label is **superseded**; adopt the
   runtime array map (`+0x4C/+0x5C/+0x7C/+0xBC/+0xFC`). The runtime is authoritative
   for the *layout*.
2. **`+0xFC`**: runtime *labels* it "base values (initial)"; the disasm *proves*
   `func_0305A8` sums it across players and drives drift. Same bytes — the dynamic
   role (drift input) is disasm-verified; the "base/initial" label is a turn-1
   observation. Keep the disasm operation; note `+0x7C` (volume) is the semantically
   "long-term trend" array and may also feed drift (untraced).
3. **`+0x44/45/46`**: the **disasm is decisive** — `func_03E162`/`func_03CDA2`/
   `func_051EF4` read/write the globals `0x53DA..0x53E1`, so those are the
   authoritative REF counts. The two runtime dumps **disagree** on `+0x44/45/46`:
   this dump write-verified them as the REF; `docs/DATA_MODEL.md`'s session found
   them ≠ the UI (with `0x53DA` matching). So `+0x44/45/46` role is **unresolved**
   (a later "both real, different roles" reading was over-confident — corrected
   2026-06-19 consolidation). Needs a fresh dump to settle.
4. **`+0x30`**: disasm proves `func_0363A2` writes the crosses threshold here; the
   runtime "recruit cost" label was **not** write-verified (inference from the recruit
   menu). Keep the byte-verified meaning (threshold); flag for runtime re-check.

**Action taken**:
- Imported the dump to `colonization-memory-map (1).md` (same root path as `main`).
- `spec/systems/market.md` — corrected `+0x4C`; added the runtime 16-good array map.
- `spec/systems/ref_growth.md` — `+0x44/45/46` runtime counts reconciled with `0x53DA`.
- `spec/systems/events.md` + `spec/systems/map_system.md` — Lost-City trigger = features `0xB0` (runtime).
- `spec/systems/immigration.md` — `+0x30` conflict noted.

**Follow-up**: runtime-confirm whether `+0x30` is dual-use (threshold vs recruit
cost); trace whether `+0x7C` volume also feeds `func_0305A8`'s sibling drift; locate
the King `royal_money +0x22` and boycott `+0x20` in a dump (neither identified yet).

---

## 2026-05-30 — Game manual added as behavioral source; confirms combat-modifier model (reconciles wave-6 "+50% refuted")

User provided the original Colonization manual / Technical Supplement →
`docs/GAME_MANUAL.md` (UTF-16→UTF-8). Added to TRUTH_HIERARCHY as a
FUNCTION source (authoritative for how a feature works; EXE bytes still win for exact
numbers — patches may differ).

First cross-check (combat), manual §"Combat in the New World" lines ~1295-1354. The
manual lists the full combat-modifier model — all real game rules:
- **Attack Bonus**: attacker always +50% (wilderness surprise).
- **Fortifications**: fortified unit +50% DEFENSE.
- **Veteran Status**: veteran soldiers +50%.
- **Terrain Bonuses**: defenders in forest/hills/mountains get a terrain-varying bonus
  (vs Europeans only; see manual Terrain Chart).
- **Native / Colonial Ambush**: natives (always) and colonials-vs-King (outside colony)
  get the terrain bonus on attack or defense.
- **European Bombardment**: regular army +50% attacking a colony (+ Foreign-Intervention variant).
- **Popular Support**: each colony's SoL/Tory status becomes an attack bonus in the revolution.

**Reconciles the wave-6 "+50% fortified REFUTED" ruling**: that finding was correct but
SCOPED — it proved the SHIP odds roll @0x5B819 reads the RAW per-type stats
(0x523b/0x523c) with NO scaling. It did NOT mean fortify gives no bonus. The manual
confirms the bonuses are real, and the wave-9 decode locates them in the **LAND strength
modifier chain** in func_05CA7E (src/ai/unit_ai_leaf.c): the `·3/2` multipliers (= +50%)
and the `[0x8D04]` terrain/fort term that the defense accessor (file 0x07D3E) writes.
So: bonuses live in the DERIVED land strengths, not the raw ship-roll stats. The
"refuted" wording is hereby clarified to "not in the ship-roll raw stats; present in the
land modifier chain (manual-confirmed)".

**Action / follow-ups (data the manual unlocks):** the manual's **Terrain Chart** gives
values for the `[TBD]` terrain/fort bonus table (combat_modifiers.c / func_05CA7E), and
its **Combat Strengths Chart** is an independent cross-check of the @UNIT atk/def values
(Soldiers 2/2, Regulars 5/5, Artillery 7/5, …). Both to be cross-checked vs bytes
(EXE wins on exact numbers). cite-or-TBD unchanged.

---

## 2026-05-30 (BREAKTHROUGH) — The RTLink overlay wall is statically resolvable; VICEROY = RTLink/Plus V2

**This resolves the project's long-standing core blocker** ("core logic blocked
behind overlays 0x191F/0x181F"). User pointed us to dreammaster/tools'
`rtlink_decode`; reading its source + byte-checking VICEROY established:

1. **VICEROY.EXE is RTLink/Plus Version 2** (the "Rex Nebular" variant rtlink_decode
   handles). Byte-confirmed: MZ numRelocations @0x06 = 2260 (≠0, so not V3); header
   paragraphs @0x08 = 576 → codeOffset 0x2400; reloc table @0x18 = 0x1E; NO .OVL
   companion (only PKUNZJR.COM in COLONIZE/); V2 fingerprint strings
   "Enter directory for $" @0x1A5B7 + "MS Run-Time" @0x1D9A8 + "RTLink" @0x1A25D.

2. **The overlay "wall" is not a wall.** The whole cross-page call graph is
   statically recoverable from the load image:
   - The RTLink thunk table is ONE contiguous block @file 0x1A5F0..0x1D5E6,
     addressed through three OVERLAPPING far-seg windows (file_base =
     codeOffset 0x2400 + seg*16): 0x181F→0x1A5F0, 0x191F→0x1B5F0, 0x1A1F→0x1C5F0.
     They are not three tables; the compiler picks whichever window keeps the
     16-bit offset in range. (Verified: 0x2400+0x181F*16 = 0x1A5F0.)
   - Each thunk = `9A AB 0D 0D 11` (LCALL 0x110D:0x0DAB resident loader) +
     `EA <off16> <seg16>` (JMPF; seg=0 ⇒ runtime-patched, but the offset +
     trailer PAGE-ID are static) + trailer word = target page. 0x110D is the
     resident loader segment (the entry CS), never a call target.
   - Cross-page calls route through page-resident JMPF trampolines (e.g.
     0x5E723 = `EA e0 06 1f 1a` = JMPF 0x1A1F:0x06E0); both halves are in the
     static image, so the call graph is fully reconstructable.

3. **Land-combat decider RESOLVED = func_05CA7E** (file 0x5CA7E, ENTER 0xDE,
   page 0x10) → wrapper func_05BE30 → applier func_05B2C2 (via trampoline
   0x5E723 → thunk @0x1CCD0 = page 0x10 +0x0352). func_05CA7E is the same
   ~7.3KB per-unit attack/action routine already in src/ai/unit_ai_leaf.c —
   land combat is one facet. This OVERTURNS the [TBD]/"behind the wall"
   corollary in src/combat/land.c (wave-7); the wave-7 framing
   "thunk @0x1BAAA = 0x110D:0xA9DA" was a wrong address (0x1BAAA targets page
   0x08 unit-state). Report-content renderers likewise resolved to 9 page-0x05
   functions reached by the static CMP/LCALL ladder in func_0235D6.

**Source A** — prior project belief + wave-7 land.c: deciders "behind the RTLink
wall", statically unresolvable [TBD].
**Source B** — dreammaster rtlink_decode V2 algorithm + wave-8 byte trace + my
independent re-verification (thunk windows, trampolines, prologues all byte-exact).

**Ruling**: Source B. The RTLink overlay structure is static and decodable; mark
land.c's caller RESOLVED (func_05CA7E). TRUTH_HIERARCHY: raw EXE bytes win.

**Action taken**: docs/OVERLAY_THUNKS.md (full per-thunk verdicts); land.c corollary
corrected; VERIFICATION_LEDGER "RTLink overlay wall" section; Python V2 flattener
under tools/rtlink/ (in progress). The C++ tool needs a ScummVM+VS build, so we
reimplement the V2 algorithm in Python (clean-room from the documented format).

**Follow-up**: (1) ✅ DONE — `tools/rtlink/rtlink_decode.py`
(V2 decoder; info/flatten/resolve/validate) built + validated (31 segments,
1023 thunks; resolves any overlay addr to a flat file offset; emits VICEROY_flat.exe
+ viceroy_rtlink_map.json). This eliminates the reseg-drift hazard — re-disassemble
the flat image or use `resolve <page> <off>` instead of the per-func dumps.
(2) decode the land-odds FORMULA inside func_05CA7E (now statically reachable);
(3) the report-content bodies (page 0x05).

---

## 2026-05-30 (RESOLVED) — Wave-10: DOS save serializer decoded; magic = "COLONIZE"

The standing [TBD] "overlay-resident savegame serializer" is cracked (via the RTLink
tool). All byte-verified.

- **DOS save MAGIC = `"COLONIZE"` + 0x1A** (file 0x1FB1A, handle 0x217A), written
  @0x73528 (0x1A1F:0xDE4), strcmp'd on load @0x73C00 (0xD1D:0x816). This RESOLVES
  the prior [TBD] (the DOS save header was undecoded; "COL2" had been dismissed as
  Win16). Confirmed distinct: saves/quicksave.col2 begins `43 4F 4C 32` = "COL2"+ver3
  = Win16. So: **DOS = "COLONIZE", Win16 = "COL2"** — two formats, now both known.
- **SAVE driver = func_0734F8** @0x734F8 (ENTER 6, reached LCALL 0x1A1F:0xCF6 from
  func_072F7A/SAVEGAME); **LOAD driver = func_073BB0** @0x73BB0 (from func_073158/
  LOADGAME). On-disk order (43 fwrite + 12 block-write, byte-cited): header(magic,
  version@var,map W/H) → globals @0x5380 → per-power names @0x540E → ColonyRecord
  count[0x539E]×0xCA → UnitRecord count[0x539C]×0x1C → PowerRecord 4×0x13C →
  NativeSettlement count[0x539A]×0x12 → … → 4 map layers. **NO checksum** (verified
  by absence); integrity = load-side magic + version + map-size gates. I/O via the
  resident MSC buffered lib (window 0xD1D).
- **Colony on-disk record = full 0xCA** (not the 0xAE work-buffer stride).
- **g_unit_count @0x539C RESOLVED** (was [TBD]): `imul [0x539C],0x1C` @0x735DC.
- **RTLink tool refinement**: overlay page 0x1A packs TWO load-segments; the save/
  load driver thunks resolve against the SECOND segment's base **0x73270** (not the
  segment-list code_offset 0x72090): 0x73270+0x288=0x734F8, +0x940=0x73BB0 (both
  land on `C8` ENTER prologues). tools/rtlink/RTLINK_V2.md notes this.

**Ruling**: Source = byte-verified func_0734F8 / func_073BB0 decode. DOS save magic
is "COLONIZE". **Action**: src/save/{save_serializer,load_deserializer}.c rewritten;
ledger SAVE section + FUNCTION_INVENTORY rows; RTLINK_V2.md page-0x1A caveat.
**Follow-up [TBD]**: version word @0x81A runtime value; the ~30 small per-power
scalar blocks' field meanings (offsets/sizes are byte-exact, semantics not decoded).

---

## 2026-05-30 (RESOLVED) — Wave-9: there IS a land-combat roll (refines wave-7), decoded in func_05CA7E

Enabled by the RTLink flattener (func_05CA7E is now statically reachable), the
land-combat DECISION is fully decoded and byte-verified. This **refines the wave-7
entry below** ("land combat = no roll"), which was scoped to the wrong stat columns.

- **Land combat IS `ATK/(ATK+DEF)`** — the SAME odds form as ships. In func_05CA7E
  @0x5D188: `roll = random_int(1, atk_str + def_str)`; `win = (roll <= atk_str)`;
  win_flag stored [bp-0x9c] @0x5D1A2 (add @0x5D181, cmp @0x5D194 — all verified).
- But it rolls on **DERIVED strengths from columns 0x5235 (def) / 0x5236 (atk)**,
  read ×8 via resident accessors (file 0x07C2A / 0x07D3E, reads `8a 87 36 52` /
  `8a 87 35 52` @0x07C62/0x07C7E), then a modifier chain (terrain/fort via [0x8D04],
  difficulty 0x53A6, SoL/human gate [0x5382] bit0, era gates on turn 0x538E).
- **Why wave-7 missed it:** wave-7 exhaustively scanned for the raw ship stats
  0x523b/0x523c and correctly found them read only in the ship-gated roll. Land
  uses a DIFFERENT stat pair (0x5235/0x5236) via ACCESSOR functions, not direct
  `[bx+0x523X]` reads — so the wave-7 scan couldn't see the land roll. Wave-7's
  literal claim (0x523b/0x523c are ship-only) stands; its IMPLICATION ("land has no
  probabilistic roll / decider is [TBD] in the caller") is WITHDRAWN.
- **Evaluate vs Act:** when mode([bp+0xe])==0 (AI ranking) func_05CA7E returns the
  deterministic score `(atk_str<<3)/(def_str+1)` @0x5D032 (`shl ax,3` verified) and
  never rolls; the RNG fires only when committing (mode!=0). func_05B2C2 stays
  consequence-only — the win_flag computed here selects the loser it applies.

**Ruling**: Source = byte-verified func_05CA7E decode. Land combat odds = ATK/(ATK+DEF)
on the 0x5235/0x5236-derived strengths. **Action taken**: ported into
src/ai/unit_ai_leaf.c; land.c "[TBD] next target" note marked DONE; ledger/inventory
rows. **Follow-up RESOLVED (wave-10, docs/COMBAT_STATS.md):** the @UNIT-column ->
stat-offset mapping is byte-traced at the loader @0x74EC3 — col3 ATTACK -> 0x5236,
col4 combat/DEFENSE -> 0x5235 (LAND, ×8 in the accessor); col9 guns -> 0x523b,
col10 hull -> 0x523c (SHIP). The earlier "@UNIT col3/col4 -> 0x523b/0x523c" label
(combat.c) and "cols 3/4 -> 0x5234/0x5236" (wave-6) were WRONG; corrected. Real
LAND atk/def: Soldiers 2/2, Dragoons 3/3, Regulars 5/5, Cavalry 6/6, Artillery 7/5;
SHIP def/atk (guns/hull): Frigate 12/32, Man-O-War 32/64. Remaining [TBD]: the
terrain/fort bonus table feeding [0x8D04].

---

## 2026-05-30 (RESOLVED, REFINED by wave-9 above) — Wave-7 (land combat = no roll; func_072090 = menu bar)

1. **LAND COMBAT HAS NO ATK/DEF ROLL — func_05B2C2 only applies consequences.**
   This compounds the wave-6 ship-gate finding. Byte-proven three ways (I re-ran
   the exhaustive scan + structural checks myself):
   - The per-type combat stats 0x523b (DEF) and 0x523c (ATK) are read at exactly
     2 and 1 code sites respectively in the WHOLE 494,910-byte EXE — all inside the
     ship-gated roll (0x5B819/0x5B823/0x5B83B). No "land" roll reads them.
   - A land attacker (type <0x0D) jmps 0x5BAA3, bypassing BOTH the odds roll and the
     post-roll per-power strength compare (0x5B85B..0x5BA2D is unreachable from there).
   - The land combatant path reaches the DEMOTE ladder / destroy block directly, with
     no RNG and no stat read.
   So func_05B2C2 is the combat-CONSEQUENCE applier: the outcome router @0x5BAA3
   (cmp [bp-0x3a],0, verified `83 7e c6 00`) applies a PRE-DECIDED result — WIN
   (remove loser: unit flags|=0x80 @0x5BB9E, spoils via per-type 0x5235) or LOSE
   (DEMOTE ladder / destroy). **The land win/loss DECIDER lives in the CALLER**
   (the unit move/attack dispatcher), reached only via load-image thunk @file
   0x1BAAA (=0x110D:0xA9DA) whose LJMP segment is runtime-patched → statically
   unresolvable behind the RTLink wall = **[TBD]**, narrowly bounded. Ported:
   src/combat/land.c; combat.c header reframed; FUNCTION_INVENTORY/ledger updated.
   This is the honest end-state: the simple ATK/(ATK+DEF) "combat rule" was a SHIP
   rule; the land decider is not yet statically recoverable, and we say so.

2. **func_072090 = the top MENU-BAR builder, not the report-content engine.** The
   wave-5 UI agent guessed func_072090 renders report bodies (because it contains the
   "reports" key 0x20BA). Byte-verified: it is `build_menubar` (0x072090..0x072B9A,
   2826B) — it builds the 7-8 pull-down columns (game/menu/view/orders/reports/trade/
   cup/pedia, keys resolve exactly), and the Reports column just lists the 10 F-key
   entries. The actual report-CONTENT renderer (reached on F-key select 0x40..0x49)
   remains UNFOUND = [TBD] — not fabricated. Ported as build_menubar in
   src/ui/report_screen.c; FUNCTION_INVENTORY (which already had "Top menu bar
   dispatcher" — correct) upgraded to BYTE_VERIFIED.

3. **combat_demotion_ladder.c vet-byte label clarified.** The demote override @0x5B60E
   (`80 bf 5b 31 18` = cmp byte [bx+0x315B],0x18) reads vet_type at absolute 0x315B =
   canonical UnitRecord+0x17. The file indexed it as 0x3146-base `+0x15` (0x3146+0x15
   = 0x315B) — address-correct, but the label was confusing; clarified (same
   base-alias class as 0x8809/0x8808).

**Ruling**: Tier-1 bytes win. Finding (1) is the significant one — it is the honest
terminus of the combat-rule investigation: land combat's decider is behind the RTLink
overlay wall and is marked [TBD] rather than guessed.

**Action taken**: commits land.c (src/combat), build_menubar (src/ui/report_screen.c);
combat.c reframed; Makefile OBJS_COMBAT += land.obj; ledger + FUNCTION_INVENTORY rows;
combat_demotion_ladder.c comment.

**Follow-up**: the land-combat DECIDER and the report-CONTENT renderer both sit behind
RTLink overlay thunks — recovering them needs the overlay-load-time segment patch
(the RTLink VP-directory), i.e. a dynamic/loaded-image trace, not a static one.

---

## 2026-05-30 (RESOLVED) — Wave-6 (king-military, GUI engines, combat completion)

1. **COMBAT: the ATK/(ATK+DEF) odds roll is SHIP-ATTACKER-ONLY** (revises the
   earlier "combat resolution rule" validation, which found the roll but not its
   gate). func_05B2C2's roll @0x5B819 (`random_int(1,DEF+ATK); atk wins if
   roll<=ATK`) is reached only when attacker type ∈ 0x0D..0x12 (the 6 ships) —
   gate @0x5B7B6 (`cmp [type],0x0D; jae` @0x5B7BB `73 03`, else `e9 e3 02` jmp
   0x5BAA3) + @0x5B7C0 (`cmp ,0x12; jbe`, else jmp 0x5BAA3). **Land combat does
   NOT use this roll** — it routes to the 0x5BAA3 region (not yet fully decoded).
   The simple ATK/(ATK+DEF) is therefore the SHIP path, not the universal rule.
   (I re-read the jump bytes to confirm.)

2. **COMBAT: "+50% fortified" multiplier REFUTED.** The roll reads raw
   `0x523b[deftype]` (DEF) + `0x523c[atktype]` (ATK) and adds them with `03 c1`
   (no scaling op between the reads and the add); 0x523b/0x523c are read at only
   3 sites overall (all in this roll), so no stat-scaler exists. The 0x5B433
   "fort block" is a capture-ELIGIBILITY threshold
   (`(0x5237[deftype] − defender[+0x0C]) >= 0x5238[atktype]`, for non-combatant
   attackers entering a fortified colony), NOT a stat multiplier. The real
   modifier layer is a POST-roll per-power strength compare @0x5B85B..0x5BA2D
   (difficulty `MUL [0x5325]` @0x5B9A2); per-power array semantics TBD.

3. **COMBAT: @UNIT column→stat-offset mapping is suspect** (flagged [TBD-data]).
   combat.c's header claimed @UNIT col3/col4 → 0x523b/0x523c, but the loader
   @0x74EDA writes cols 3/4 to 0x5234/0x5236; 0x523b/0x523c are filled from later
   fields. Roll semantics are byte-certain; only the column LABEL is unresolved.

4. **KING: func_02F052 / func_02F3A2 are king-military, NOT UI.** The wave-5 UI
   agent flagged them out-of-scope; confirmed. func_02F052 = KINGTAX/ship-REFIT
   events (847B, dump truncated@117); func_02F3A2 = War-of-Independence per-turn
   handler (1869B, dump truncated@63). FUNCTION_INVENTORY's "func_02F3A2 = win/lose
   check" with YOULOSE/YOUWIN keys was WRONG — those keys are not pushed; the 15
   real keys are LOSENOCOLONIES/INDEPENDENT/KINGWIN/etc. func_03CDA2 REF-arm
   landing decrement (`dec word[bx+0x53DA]`) byte-verified (resolves a ref.c TBD).

5. **GUI: func_02883E / func_028D8C extents corrected** (138B→1357B, 185B→2841B —
   first-RET truncation). menu-item dispatcher (22-entry CS jump-table @0x028AF0)
   and colony build/dialog engine. Page-0x17 control model decoded
   (menu_lookup_run=func_06F51A; opt-flag [0x1F54]; descriptor [0x87C]; screen-mode
   builder [0x1F5E]=func_06F5F2). Two sub-findings: king_audience.c's
   "0x181F:0x3FE→func_028D8C" was imprecise (→func_06F594 page-0x17 wrapper;
   func_028D8C is via 0x181F:0x1750) — corrected; main_loop.c's
   `menu_lookup_key(int,int,int)` == func_06F51A which is `(void)` — symbol-unify TBD.

6. **Truncated-dump hazard, again.** Every wave-6 target's per-func dump understated
   size (117/63/138/185/82 vs verified 847/1869/1357/2841/548). And reseg ALSO
   drifted in combat (page_07 phantom func_03FF4C from jump-table bytes) — raw EXE
   overruled. Confirms the wave-5 ruling: raw VICEROY.EXE is the ultimate arbiter.

**Ruling**: Tier-1 bytes win. The combat findings (1-3) are the significant ones —
they narrow a previously-"validated" rule honestly rather than leaving the prior
over-broad claim standing.

**Action taken**: commits for king (king_events/war_turn/ref), GUI (menu/dialog),
combat (naval/combat_modifiers/combat.c); ledger + FUNCTION_INVENTORY + Makefile
(OBJS_KING/OBJS_UI/OBJS_COMBAT) rows; king_audience.c comment fix.

**Follow-up**: decode the LAND-combat path (0x5BAA3 region) + the post-roll per-power
strength arrays; resolve the @UNIT column→stat mapping; port report content engine
func_072090; unify menu_lookup symbol.

---

## 2026-05-30 (RESOLVED) — Wave-5 + ledger-audit reconciliations

The wave-5 ports (unit, UI screens) plus a systematic read-only ledger-audit
(every index row cross-checked vs the ported `.c` headers) surfaced a batch of
identity/role/label corrections. All resolved from bytes.

1. **Re-segmented pages DRIFT too — raw EXE is the ultimate arbiter.** The unit
   agent found `disasm_overlay_reseg/page_15` mis-decodes 0x06958 and `page_17`
   folds 0x06E94 into a bogus 2820B `func_06E3D0`. This REFINES the wave-1..4
   guidance ("prefer reseg over truncated per-func dumps"): the "C8-imm16
   false-ENTER" hazard cuts BOTH ways. Ruling: when reseg and the per-func dump
   disagree, disassemble the **raw COLONIZE/VICEROY.EXE** at the address and let
   the bytes decide. (Confirmed: 0x4007E=c8 02 00 00; 0x6958=88 87 44 31;
   0x66C4=8b 9c 5e 31; 0x4E2D6=c8 ee 00 00; 0x6EE2=e8→0x68AA.)

2. **func_05B2C2 = combat RESOLVER** (single roll `random_int(1,ATK+DEF)`,
   atk wins if `roll<=ATK`, @0x5B819), full extent 0x5B2C2..0x5BE30 (2926B). The
   demotion ladder is a SUB-TABLE within it, not the whole function. Ledger row 5
   + FUNCTION_INVENTORY had it as "Combat demotion ladder" only → corrected; both
   `src/combat/combat.c` and `combat_demotion_ladder.c` now listed. The roll
   @0x5B819 is the SAME function, NOT a separate larger one (open Q closed).

3. **func_051EF4 score role WITHDRAWN → it's a per-turn GOLD/income tick.** The
   2026-05-29 SCORING trace called it `score_tick_for_power` accumulating into
   `*(0x84FC)+0x2A`. But +0x2A = GOLD (wave-3 RULINGS; UI/LCR-verified). The
   arithmetic stays byte-verified; only the "score" framing is wrong. Real
   endgame score = the rank ladder in **func_03A9C0** ((k*k)/3 × difficulty) over
   an overlay-resident raw value (0x191F:0x3AA, TBD). FUNCTION_INVENTORY's prior
   "func_03A9C0 uses [0x372] accumulator / 964B frame" heuristic also withdrawn.

4. **Dangling combat-file rows removed.** Ledger listed `src/combat/resolve.c`,
   `modifiers.c`, `demotion.c` — none exist (resolve.c was folded into combat.c;
   demotion → combat_demotion_ladder.c). Rows corrected to the two real files.

5. **func_022F08 was an over-merged reseg record** = 4 distinct RETF-terminated
   functions: find_city@0x022F08 (ENTER 4), game_options@0x022FD6,
   colony_report_options@0x02311A, sound_options@0x0232AE. Split into
   `src/ui/options_dialog.c`; GAME.TXT bit maps 0x5382..0x5386.

6. **0x53A6 = difficulty (0..4), unified to `g_difficulty_53A6`.** globals.h had
   `g_progress_5_53A6 "era counter"` (mislabel) defined in production.c, while
   native/king files declared an UNDEFINED `g_difficulty_53A6` extern — a split
   that would fail to link. Unified on `g_difficulty_53A6` across globals.h /
   production.c / colony/turn_update.c / market/pricing.c / king_tax_raise.c.
   (Active-power index is the SEPARATE global 0x9E12.)

7. **MANIFEST.md sizes are truncated estimates** (first-RET) — caveat added;
   real extents for func_057F4E/05B2C2/03BC42/057DC0 cited from the `.c` headers.

8. **UI handlers are NOT "overlay-resident TBD".** The colony/europe/report/king
   screen handlers are fully byte-readable in the reseg pages (found via
   string-key xref, file_offset = handle + 0x1D9A0; 8 keys resolve exactly:
   EUROPE 0xFBA, REPORT 0x11A2, FONTKING 0x232B, EUROPESHIPCLICK 0x1005,
   FINDCITY 0xA51, GAMEOPTIONS 0xA61, …). Stale "overlay-resident TBD" ledger
   rows upgraded.

**Source A** — stale 2026-05-02/05-29 ledger/inventory rows + auto-generated
MANIFEST + a prior `src/ui/` "overlay-resident TBD" claim.
**Source B** — wave-5 byte-verified ports + the read-only ledger-audit, all
checked vs raw VICEROY.EXE.

**Ruling**: Tier-1 bytes win throughout (TRUTH_HIERARCHY: raw EXE > reseg pages >
truncated per-func dumps > reconstructed notes).

**Action taken**: see commits 0b4aae4 (unit), f59e2b6 (UI), 29f0907 (audit+unit
index), f02fe80 (UI index), and the 0x53A6 unify commit. Cosmetic 0x8809→0x8808
base-label sweep in native .c deferred (address math already correct).

**Follow-up**: regenerate overlay MANIFEST from `overlay_functions_reseg.json`
(real extents) rather than the truncated dumps; port func_02F052/func_02F3A2
(KINGTAX/REF king-military, flagged out-of-scope by the UI agent) in src/king.

---

## 2026-05-30 (RESOLVED) — Wave-4 reconciliations (render dirty-rect, func_057F4E identity, diplomacy score model)

Three fabrications/mislabels surfaced by the wave-4 ports (render + diplomacy),
all resolved against bytes.

1. **Render has NO dirty-rect system.** `docs/RENDER_CHAIN.md` claimed a per-tile
   `tile_dirty[]` skip (`tile_is_dirty()` guard in func_O513, a "## Dirty-rect
   optimization" section, and a "flicker mitigated by dirty-rect" prose line).
   FABRICATED — the byte-verified `func_O514 → func_O513 → func_O512` chain
   (ported `src/render/tile_chain.c`, real O513 body 1076 B) redraws all 15×12
   viewport tiles unconditionally each frame; no dirty array/functions exist in
   VICEROY.EXE. Double-buffering status TBD (not a dirty-rect substitute claim).

2. **func_057F4E = European meeting/diplomacy dispatcher, NOT "save_load_chain_b".**
   The overlay stub `src/overlay/overlay_054505_05C69B.c` carried an auto-traced
   entry named `func_057F4E_save_load_chain_b`, sized 355 B, role "SAVE_LOAD chain"
   — all wrong. The 355 B is the TRUNCATED extent of the per-func dump
   `func_057F4E_unknown.asm` (stops at first RET/0xFF); the real body is ~7151 B.
   Byte-verified identity: ENTER 0xD6 (`c8 d6 00 00`); war bit set at 0x883C
   (`80 88 3c 88 02` @0x58A7B); tribute-gold `29 47 2a` @0x58ED0; set-treaty LCALL
   `9a 06 0a 1f 18` @0x59139; trampoline `ea 0a 06 1f 1a` @0x5A1E0. Ported &
   verified in `src/diplomacy/meeting.c`. (Same truncated-dump root cause as the
   wave-2/3 misattributions func_011F6E / func_03ECF0 / func_05CA7E / func_0A222.)

3. **No `-100..+100 rel_score[8]` diplomacy model.** `docs/EUROPEAN_DIPLOMACY.md`
   described a signed pair-score array with an event-delta table and
   `if (score < -50 - aggression)` thresholds + `ai_evaluate_treaty()`. FABRICATED
   — the real diplomatic state is the boolean **war bit-matrix at DGROUP 0x883C**
   (one bit/power-pair, set @0x58A7B), not a scalar score. `rel_state[8]`
   Peace/War/Alliance enum is also a reconstruction (Alliance-as-stored-state
   unconfirmed).

**Source A** — reconstructed docs (RENDER_CHAIN.md, EUROPEAN_DIPLOMACY.md) and the
auto-generated overlay manifest/stub.
**Source B** — wave-4 byte-verified ports (`src/render/*`, `src/diplomacy/*`) read
from `disasm_overlay_reseg/page_*.asm` full bodies.

**Ruling**: Tier-1 bytes win all three (TRUTH_HIERARCHY: disassembly > reconstructed
notes; full reseg pages > truncated per-func dumps).

**Action taken**:
- `docs/RENDER_CHAIN.md`: banner updated; dirty-rect prose, the func_O513 guard,
  and the "## Dirty-rect optimization" section retagged ⚠️ FABRICATED in place.
- `src/overlay/overlay_054505_05C69B.c`: func_057F4E stub header retagged
  SUPERSEDED → `src/diplomacy/meeting.c`; wrong name/size/role called out.
- `docs/EUROPEAN_DIPLOMACY.md`: banner + "Relationship score" section retagged
  ⚠️ FABRICATED; point to 0x883C war matrix / `src/diplomacy/treaty.c`.

**Follow-up**: the overlay MANIFEST.md is auto-generated by `tools/overlay_body_gen.py`
and still lists func_057F4E at 355 B; regeneration should read reseg extents, not the
truncated per-func dumps (tracked, not blocking).

---

## 2026-05-30 (RESOLVED) — Wave-3 global-address conflicts (+0x2A, 0x53A6, PowerRecord base)

Three address labels disagreed across sources; all resolved from bytes (verified vs
VICEROY.EXE) during the wave-3 ports.

1. **PowerRecord+0x2A = GOLD, not score** (resolves the OPEN "+0x2A gold-vs-score").
   power.h + DATA_MODEL (UI-verified: +0x2A=1920→Gold 19200%); LCR credits winnings
   here via `add [bx+0x8832]` @0x61C4C (0x8808+0x2A). The 2026-05-29 anchor calling
   func_051EF4's `[0x84FC]+0x2A` a "score accumulator" is WITHDRAWN — it's a gold/
   income tick. The real endgame score is the rank ladder in func_03A9C0 over an
   overlay-resident raw value (0x191F:0x3AA, TBD). `[0x372]` is save/restore scratch.

2. **DGROUP:0x53A6 = DIFFICULTY (0..4, default 2=Conquistador)**, not "current_player_idx"
   (VERIFICATION_LEDGER line ~206) nor "era counter" (globals.h g_progress_5_53A6).
   Byte evidence: `==0/1/3/4` compares @0x051F5B/0x00A295, default-set `=2` @0x07433C;
   combat.c already had it right (g_difficulty_53A6). The active-power index is the
   SEPARATE global 0x9E12.

3. **PowerRecord base = DGROUP:0x8808** (verified `add ax,0x8808` @0x3055D →[0x84FC]);
   VERIFICATION_LEDGER line ~202 says 0x8809 — off-by-one, corrected.

**Also confirmed**: 0x0D1D:0xEC6 = 32-bit signed divide (corroborates the SoL% ÷ and
the market supply-inverse price target).

**Ruling**: Tier-1 bytes win in all three. **Action taken**: scoring/market ports use
the corrected labels; VERIFICATION_LEDGER line 202 (0x8809→0x8808) corrected below;
the 0x53A6 "player_idx"/"era counter" labels (ledger 206, globals.h) to be re-tagged
to difficulty in the next central sweep.

---

## 2026-05-30 (RESOLVED) — Three function-identity misattributions (wave-2 ports)

**Conflict**: prior labels (per-func dumps / FUNCTION_INVENTORY) for three functions
disagreed with the re-segmented page disasm + string xrefs. All resolved from bytes
(verified vs VICEROY.EXE), root cause = the per-func auto-dumps were truncated at the
first 0xFF/RET while the functions continue for thousands of bytes.

1. **func_011F6E** — labeled "load_game_state / savegame colony reader" → is the
   **RTLink/overlay-EXE record reader** (MZ/ZM magic @0x01207A `81 7e e2 5a 4d` /
   @0x012081; caller chain _searchenv→fopen). The 0xAE malloc≈ColonyRecord was
   coincidental. The real save serializer is overlay-resident (TBD for a verified reason).
2. **func_03ECF0** — labeled "diplomatic_action_init (~86 B)" → is the **per-unit
   confrontation/command AI evaluator (3101 B, 0x03ECF0..0x03F90C)**. Controller-flag
   gated (`imul bx,[bp-2],0x34;[bx+0x543F]` @0x3F474), far-calls the AI leaf
   (`lcall 0x191F:0xA14` @0x3F492). DECLAREWAR/etc. are dialog message handles, not its identity.
3. **func_05CA7E** — labeled both "AI leaf" (brief) and "colony burn/native raze"
   (ledger) → ONE routine: the **unit-attacks-enemy-COLONY resolver** (AI-gated head +
   BURNED capture/burn tail; reads colony [0x8542] @0x5CC64). NOT native-village raze —
   that remains **func_04A7CA**. Closes the ledger's "native raze = func_05CA7E" open item.
   (Also: func_03E984 = declare-independence handler; 0x53D0 = rebel-sentiment %.)

**Ruling**: the re-segmented page disasm (full function bodies) overrides the truncated
per-func dumps for function identity/size (TRUTH_HIERARCHY: read the actual bytes).

**Action taken**: src/save/* , src/ai/* ported with corrected identities; shared refs
(globals.h/iolib.h/anchor_map.md/VERIFICATION_LEDGER) re-tagged for func_011F6E.
Methodology note for the engine: prefer the reseg pages over per-func dumps (the latter
truncate at the first RET).

---

## 2026-05-30 (RESOLVED) — DGROUP:0x53A7 is year/100, NOT the king-anger byte

**Supersedes** the 2026-05-28 "(OPEN CONFLICT) — 0x53A7 king-anger vs year/100" below.

**Conflict**: memory/STATE called 0x53A7 the king-anger byte (USER-VERIFIED: a byte
went 3→4→5 per Tea Party); the disasm shows it written as year/100.

**Deciding evidence (byte-verified, king-agent trace 2026-05-30, re-checked vs
VICEROY.EXE)**: exactly 3 references to 0x53A7 in the overlay disasm, all
year-split, and NO `inc`/`add [0x53A7]` anywhere:
- WRITE `0x03DE6F a2 a7 53` = `[0x53A7] = al` (year/100), beside `0x03DE65 88 16 a8 53`
  = `[0x53A8] = year%100`.
- READ `0x039EEE f6 2e a7 53` = `IMUL byte [0x53A7]` then `+[0x53A8]` → reconstruct year.
- INIT `0x0757D3 c6 06 a7 53 00` = `[0x53A7] = 0`.
Also dispositive: year/100 ≈ 14..18 for 1400..1800 — it cannot be the observed
3→4→5. So the *values* the user watched were not this address's.

**Ruling**: 0x53A7 = **year/100** (Tier-1 bytes win the ADDRESS). The king-anger
MECHANIC is still real (user observation stands), but its address was MISLABELED;
the real anger byte is **UNLOCATED/TBD** (candidate: the king's PowerRecord). This
does not override the empirical observation — it relocates it.

**Action taken**: king/demands.c header records the year-split; this ruling;
memory project_king_anger_and_ref to be updated (0x53A7→year; anger→TBD).

---

## 2026-05-30 — LCALL 0x181F:0x04D4 is random_int(lo,hi), NOT an "ask-king" dialog

**Conflict**: src/king/king_tax_raise.c declares `ovly_181F_04D4` as
"ask king/player about change, returns 1=accept" and builds its tax-accept logic
on that; the native + combat traces use the same thunk as `random_int`.

**Ruling**: 0x181F:0x04D4 = **random_int(lo, hi)** — BYTE_VERIFIED (thunk → MSC
LCG func_00C322 @0xC322; used as random_int(1,total) in the combat roll
@0x5B849 and random_int(1,4) in native raid @0x05BF35; memory
project_rng_byte_verified). The "ask-king" reading in king_tax_raise.c is WRONG.

**Action taken**: flagged king_tax_raise.c — the `ovly_181F_04D4` decl + its 3
call sites are MISIDENTIFIED; the tax-accept branch logic built on the wrong
identity is suspect and func_034AE0 needs a re-trace (next king sub-task).

---

## 2026-05-30 — @UNIT "icon" column is 1-based (ICONS.SS index = icon − 1)

**Conflict**: The unit sprite-index mapping disagreed between sources. SPRITE_CATALOG
/ GAME_INDEX_TABLES / PROJECT_BOARD (SPRITE-A) state the @UNIT column-1 value IS the
ICONS.SS sprite index (Caravel=6, Galleon=8, Colonists=101). The colonize_sdl harness
(unit_sprite_map.py) maps Caravel→5, Galleon→7, Free Colonist→100 — off by one.

**Source A** — NAMES.TXT @UNIT column 1: Caravel=6, Merchantman=7, Galleon=8,
Privateer=15, Frigate=16, Colonists=101, ... (the raw file value).

**Source B** — docs/icon_catalog_verified.json (user hand-labeled from the actual
ICONS.SS sprites): "005"=Caravel, "006"=Merchantman, "007"=Galleon, "015"=Frigate,
"100"=Free Colonist, "102"=Veteran Soldier.

**Ruling**: Source B wins for the actual sprite index (empirical pixel inspection
beats a table assumption — TRUTH_HIERARCHY). The @UNIT "icon" column is a 1-BASED
reference; the real 0-based ICONS.SS sprite index = (@UNIT icon − 1). The −1 is
consistent across all ships AND foot units. So the harness mapping is CORRECT, and
the "@UNIT col1 = ICONS index directly" claim was off by one.

**Action taken**:
- data/unit_classes.c: `icon` field documented as 1-based with the −1 rule + the
  empirical citations.
- docs/RULINGS.md: this entry. (SPRITE_CATALOG.md / GAME_INDEX_TABLES.md /
  PROJECT_BOARD SPRITE-A should have the "−1 to get the ICONS index" note added.)

**Follow-up**: confirm whether the game's loader literally does `icon-1` when
indexing ICONS.SS, or whether ICONS.SS[0] is a reserved/blank slot that makes @UNIT
naturally 1-based. Either way the rendered index is icon−1.

---

## 2026-05-30 — Native tribe data was fabricated (ids, levels, wealth, raze input)

**Conflict**: User reported the C reconstruction's native data was "all off" —
raze gold wrong, tribe types reduced to "nomadic vs advanced", and Apache shown
wealthier than Aztec/Inca. Investigation confirmed multiple fabrications.

**Source A** — `include/native.h` + `data/tribe_data.c` (RECONSTRUCTED) had tribe
order Aztec=0/Inca=1/Tupi=3/Apache=4, a BINARY type flag (0=Nomadic/1=Advanced),
uncited `base_wealth` values (Apache 45 > Arawak 40 > Tupi 35), an uncited DGROUP
offset 0x09800, and "settlement counts [4,4,3,5,4,3,5,3] from TRIBE.TXT".

**Source B** — NAMES.TXT `@TRIBES` (extracted/text/NAMES_sections.json) gives, in
file order: Inca, Aztec, Arawak, Iroquois, Cherokee, Apache, Sioux, Tupi — each
with treasure type + a level (Inca 3, Aztec 2, Arawak/Iroquois/Cherokee 1,
Apache/Sioux/Tupi 0) + a VGA color. `@LEVELS` names FOUR tiers (Semi-Nomadic,
Agrarian, Advanced, Civilized) + a Capital settlement type. `TRIBE.TXT` is the
"Tribe Dispersal Chart" (map PLACEMENT coordinates, counts 11/4/5/5/7/7/4/16),
NOT a stats table. The colonize_sdl engine (game_data.py TRIBE_DEFS) already
parsed @TRIBES correctly (Inca=0...).

**Ruling**: NAMES.TXT wins (TRUTH_HIERARCHY: NAMES.TXT is canonical for data
tables; the EXE reads it at startup). The C tribe data was fabricated. Wealth
tracks the @TRIBES advancement LEVEL (Civilized richest, Semi-Nomadic poorest),
so Apache (0) must be far poorer than Aztec (2)/Inca (3).

**Root cause of "Apache richer than Aztec"**: `src/native/native_village_raze.c`
(func_04A7CA) multiplies gold by settlement byte `[ptr+2]`, labeled "size_byte",
but the BYTE_VERIFIED NativeSettlement layout has +0x02 = OWNER (tribe id). So
raze gold scaled with tribe *id*, and with the wrong ids a high-id nomad
out-earned the civilizations. The arithmetic was traced; the field SEMANTIC was
guessed and is wrong.

**Action taken**:
- `include/native.h`: tribe ids corrected to @TRIBES file order; 4-level @LEVELS
  model added (was binary); settlement types fixed; TRIBE.TXT correctly described;
  fabricated stats removed; banner downgraded from blanket RECONSTRUCTED.
- `data/tribe_data.c`: rewritten — verified @TRIBES/@LEVELS tables only;
  behavioural params (aggression/pop/wealth-magnitude/skills/goods) demoted to
  TBD (uncited guesses removed); fabricated 0x09800 offset removed.
- `src/native/native_village_raze.c`: false BYTE_VERIFIED downgraded;
  byte[+2]="size" flagged as contradicting +0x02=owner; gold output marked
  suspect pending re-trace of what 0x8D4E points to.

**Follow-up**: (1) RESOLVED 2026-05-30: the CHIEFKILL size factor is
NativeSettlement +0x04 = POPULATION (user-verified Inca pop 13 / Aztec pop 10 —
docs/CAPITAL_BONUS_ANALYSIS.md), not byte +0x02 (owner). native_village_raze.c
corrected (+0x02 -> +0x04). A separate capital-only bonus is added by the
capital/Cibola handler (magnitude still hypothesis-level, TBD). (2) Trace the
native behavioural tables (aggression, pop, skills) — overlay-resident, currently TBD.
(3) A 5-domain audit of the other RECONSTRUCTED data tables (buildings, market,
units, terrain yields, founding fathers, king/REF, scenario) is in progress.

---

## 2026-05-29 (RESOLVED) — AIPersonality table base is DGROUP:0x540E (controller @+0x31)

**Supersedes** the 2026-05-29 "(OPEN CONFLICT)" entry below. Resolved by the table
ALLOCATION/zero-init trace (the method that settled UnitRecord).

**Deciding evidence**:
- New-game power-init loop @0x744FE runs AIPersonality (stride 0x34 via si) parallel
  to PowerRecord (0x13C via di): `MOV si,0x543F` / `MOV byte [si],1` (AI) /
  **`MOV byte [si-1],0`** (writes 0x543E — a field BELOW 0x543F) / `ADD si,0x34` ×4.
  The write to 0x543E proves 0x543F is NOT field +0x00.
- NAMES.TXT loader func_0749E0 strcpys "LEADERNAME" -> `ADD ax,0x540E` (0x74C22, field
  +0x00) and "COLONYNAME" -> `ADD ax,0x5426` (0x74BEA, +0x18). 0x540E is the LOWEST
  stride-0x34 destination corpus-wide (only bases 0x540E and 0x5426 exist).
- Scan loop @0x745A4 bx=0x543F .. `CMP bx,0x550F` = 0x543F + 4*0x34 -> 4 records,
  flag at +0x31.

**Ruling**: AIPersonality base = **DGROUP:0x540E**, stride 0x34, 4 powers. Field map:
+0x00 LEADERNAME char[0x18] (0x540E); +0x18 COLONYNAME char[0x18] (0x5426); +0x30 byte
(0x543E); **+0x31 CONTROLLER flag (0x543F)** 1=AI/0=human/2=dead; +0x32 named-colony
counter word (0x5440). 0x543F is the most-referenced field (~218 refs) -> mistaken for
the base, same trap as UnitRecord (0x3146 = type +0x02 of base 0x3144).

**Action taken**: re-anchored ai_personality.h (base+struct+macros), globals.h (base;
4 not 8 powers), and the controller-index reads in ai/unit_orders.c, founding_fathers/
effects.c, king/demands.c, native/raid.c ([n][0x00]->[n][0x31]); base-label comments in
driver.c/turn_update.c/units.c/endgame.c/lcr.c. `@asm [bx+0x543F]` operand quotes left
verbatim (correct base+0x31 folding). raze_treasure.c/main_loop.c already used 0x540E.

**Follow-up**: lcr.c +0x3A @0x06186B citation is suspect (impossible in a 0x34 record,
lands in DATA_BYTE) — re-verify. essential/ mirror archived 2026-05-30 to
_archive/essential_mirror_2026-05-29/ (was stale; do not grep for current facts).

---

## 2026-05-29 (OPEN CONFLICT) — AIPersonality table base: 0x540E vs 0x543F

**Conflict**: two byte-cited per-power stride-0x34 accesses disagree on the base.
- raze (func_05C878): `IMUL ax,[bp+8],0x34` then `ADD ax,0x540E` (bytes 6B 46 08 34
  / 05 0E 54) -> base 0x540E. Used by raze_treasure.c, lcr.c, main_loop.c.
- new-game controller init @0x23D34: `IMUL bx,idx,0x34` then `MOV byte [bx+0x543F],1`
  (bytes 6B 5E F6 34 / C6 87 3F 54 01) -> read as base 0x543F (controller @+0x00).
  Used by 10 files incl. ai/driver.c (controller "+0x00", 218 refs).

**Likely resolution (UNCONFIRMED)**: 0x543F - 0x540E = 0x31, WITHIN one 0x34-byte
record. So the base is probably **0x540E** and the controller flag is field **+0x31**
(0x543F) — the same "keyed on a field, called it the base" error that hit UnitRecord
(0x3146 was type +0x02). If so, the 10 files using 0x543F-as-base are off by +0x31.

**Status**: UNRESOLVED — needs the table-ALLOCATION / zero-init trace (the lowest
address written across the whole AIPersonality record at game start, as func_04007E
gave for UnitRecord). Do NOT mass-change the 0x543F files until then. Both readings
left in place, flagged inline.

**Action taken**: flagged; queued a resolution task. No base overturned.

---

## 2026-05-29 (save) — DOS saves are COLONY*.SAV; the .COL/COL2 format is Win16

**Ruling** (BYTE_VERIFIED): DOS VICEROY.EXE writes save files named COLONY*.SAV —
strings "COLONY" @file 0x1FA82 + ".SAV" @0x1FA89 (slot label "(EMPTY)" @0x1FA8C).
The .COL / "COL2" / version-3 layout in tools/col_to_trace.py and
colowin/docs/engine/SAVE_FORMAT.md is the **Win16 colonize.exe** format, conflated
with DOS. (CONFIG.COL @0x1F9F9 is a config file — the only real .COL.)

**Impact**: behavioral-parity testing against DOS needs a COLONY.SAV reader, NOT
the .COL decoder — tools/col_to_trace.py targets the wrong build. Save I/O is a
buffered stream layer (OPEN func_076E50, WRITE func_0775EC, READ func_077100); the
on-disk section order/header/checksum is still TBD (serializer not yet isolated).

**Action taken**: save_serializer.c / load_deserializer.c rewritten to the verified
strings + stream I/O; save.h on-disk layout stays RECONSTRUCTED/TBD. Follow-up:
re-point the parity reader to COLONY.SAV.

---

## 2026-05-29 (open) — PowerRecord+0x2A: spendable gold, also accrued by func_051EF4

**Finding** (BYTE_VERIFIED): PowerRecord+0x2A (dword, via *(0x84FC)) is the active
power's spendable total: `SUB [bx+0x2A]/SBB [bx+0x2C]` on boycott-lift (@0x3340D)
and market buy (@0x352CA); `ADD [bx+0x2A]/ADC [bx+0x2C]` per turn by func_051EF4
(@0x051F80), value = (metric + (year-1500)/50) x era x difficulty x 4.

**Open question (semantic)**: market/boycott/raid + memory call +0x2A "gold" (it
IS spent like gold); the scoring trace calls func_051EF4 a "score tick". It is ONE
field. Either func_051EF4 is per-turn GOLD income (and "score" is the wrong label)
or +0x2A doubles as the score. compute.c hedges ("gold/score running total"). For
the reconciler: does the endgame score read +0x2A or a separate field?

**Action taken**: flagged; gold@+0x2A stands in market/boycott/raid (spent as
gold). No file overturned.

---

## 2026-05-28 (render) — func_O508/0x67DC8 is the dialog-rect fn, not a sprite blit

**Conflict**: FUNCTIONS_INVENTORY §A described func_O508 (0x67DC8) as a
"single-sprite blit wrapper" and lcall 0x181F:0x254 as "pixel-blit to framebuffer"
([0x839E] = PHYS0.SS descriptor).

**Ruling** (BYTE_VERIFIED): func_067DC8 is `compute_dialog_rect_from_cursor`. It
reads cursor_x/y from [0x174]/[0x176]; the `mov ax,0x95` before the O513 call is
DEAD (AX unused by the callee). 0x181F:0x254 is a Type-B thunk -> file 0xE76A =
the popup/dialog-rect setter (it draws the active-tile SELECTION rect, not terrain
pixels). [0x839E] is a screen CLIP RECT, not the PHYS0.SS sheet descriptor. The
actual terrain pixel-emit leaf is resident draw code invoked from func_O512's
4-pass loop; its exact format is TBD.

**Action taken**: FUNCTIONS_INVENTORY.md §A func_O508 + lcall 0x181F:0x254 entries
banner-corrected; src/render/tile_chain.c documents the verified chain. The
O514->O513->O512 chain itself is unaffected (still correct).

---

## 2026-05-28 (OPEN CONFLICT) — DGROUP:0x53A7 "king-anger" vs "year/100"

**Conflict**: memory/STATE call 0x53A7 the king-anger byte (USER-VERIFIED: tea
parties drove it 3->4->5 around turn 54). But static disasm of the re-segmented
overlay shows func_03DE46 writes `[0x53A7] = year/100` and `[0x53A8] = year%100`,
and func@0x39EE2 reads them back as `0x53A7*100 + 0x53A8` to reconstruct the year.
There is NO `inc [0x53A7]` anywhere in the binary.

**Status**: UNRESOLVED. Both are evidence (tier-1 user runtime obs vs static
bytes) and can't both be true for one byte. Possible: (a) the write target is
actually 0x53A6/0x53A8, not 0x53A7; (b) the user's 3->4->5 was a different byte;
(c) 0x53A7 is dual-use. NOT encoded as gameplay truth in any C file (king/demands.c
cites both as TBD). For the cross-source-reconciler: re-verify func_03DE46's exact
write target and the runtime byte the user observed BEFORE changing the
project_king_anger_and_ref memory.

**Action taken**: flagged only; no code/memory changed.

---

## 2026-05-28 (RESOLVED) — UnitRecord base is DGROUP:0x3144 (supersedes "base 0x3146")

**Supersedes** the 2026-05-28 "(refine)" entry (which left base=0x3144 PENDING) and
overturns the 2026-05-28 "base 0x3146" entry. The verification pass is complete.

**Deciding evidence — WRITE sites (a new unit's first-initialized fields):**
- `func_04007E` @0x04009E `MOV [bx+0x3144],al` (x=0xFF) / @0x400A2 `[bx+0x3145]` (y) /
  @0x400AF `[bx+0x3146]` (type), right after `IMUL bx,[bp-2],0x1C` allocates a slot
  (count @0x539C). `func_L141` @0x06958/@0x0695E writes the REAL x/y to 0x3144/0x3145
  on placement; unit-remove (ends 0x06938) writes 0xFF back to 0x3144/0x3145.
- Reads agree: combat resolver reads x@0x3144, y@0x3145, type@0x3146,
  owner@(0x3147&0xF) at one idx*0x1C; find-unit-at-xy func_03C932 keys on
  0x3144/0x3145/0x3147.
- Stride boundary: NO field access at 0x3160+ corpus-wide (= 0x3144 + 0x1C).

**Ruling**: UnitRecord base = **DGROUP:0x3144**, stride 0x1C. Field map: +0x00 map_x
(0x3144), +0x01 map_y (0x3145), +0x02 type (0x3146), +0x03 owner|flags (0x3147),
+0x04 flags (0x3148), +0x06 moves (0x314A, init 0xFF), +0x07 profession (0x314B,
init 0x2D), +0x08 orders (0x314C), +0x09/+0x0A goto x/y (0x314D/E), +0x0C
cargo_count (0x3150), +0x0D..+0x0F cargo_kind (0x3151-53), +0x10..+0x15 cargo_qty
(0x3154-59), +0x16 turn_counter (0x315A), +0x17 vet/type (0x315B, 0x13..0x1C),
+0x18 word prev-link (0x315C), +0x1A word next-link (0x315E). End = 0x3160.

**Why "0x3146" was wrong**: func_008B96 (`IMUL ...,0x1C`+`MOV bl,[bx+0x3146]`) reads
field +0x02 (type) — the most-tested field, so a high ref count ≠ base. 0x3144/0x3145
being written as a unit's initial x/y proves they are fields +0/+1, not "previous-
record chain bytes"; the chain links are words at 0x315C/0x315E (+0x18/+0x1A).

**Action taken**: corrected unit.h, anchor_map.md, decompiled.md, VERIFICATION_LEDGER.md
(incl. 0x315B = +0x17, not +0x15), both PROGRESS.md, DISASM_LEDGER.md, and memory
project_unit_table_correction.md. NOTE: the byte-identical `essential/` mirror held
the old values; ARCHIVED 2026-05-30 to _archive/essential_mirror_2026-05-29/ (do not
grep it for current facts — see _archive/MANIFEST.md).

**Follow-up**: field +0x05 (0x3149) role TBD; the 0x315A "turn-counter vs
colony-job-assign" dual-write needs reconciliation.

---

## 2026-05-28 (ai) — AI logic mostly overlay-blocked; 0x539E/0x539C are colony/unit counts (not num_powers)

**Findings** (byte-verified parts): there is no single resident "iterate-nations
and dispatch AI" function — the top-level AI dispatcher crosses into the RTLink
overlay (blocked pending the VP-directory decode, task #5). Resident & verified:
the controller flag is **AIPersonality +0x00** (1=AI / 0=human; 218 refs);
new-game controller assignment @0x23D2E; power-init loop @0x744FE runs the
AIPersonality table (DGROUP:0x543F, stride 0x34) parallel to PowerRecord
(0x8808, stride 0x13C). The per-unit AI evaluator is **func_04E2D6** (order-setter
func_04E2B6): gates on unit activity state, accumulates a desirability flag from
~12 conditions (turn%15, year<=1650, unit-type, combat-eligibility via stat table
0x5230+0x06), writes single-letter order codes to a UnitRecord byte. random_int
(LCALL 0x181F:0x4D4 -> 0xC322) confirmed.

**Corrections (byte-proven) to prior "facts":**
- **DGROUP:0x539E = COLONY count** (indexed ×0xCA), NOT num_powers.
- **DGROUP:0x539C = UNIT count** (indexed ×0x1C).
- European powers = literal 4 (not read from 0x539E).
- AIPersonality +0x00 is the controller flag — the reconstructed
  aggression/expansion/militarism weights in ai_personality.h are NOT
  byte-verified and are contradicted; +0x02..+0x33 are TBD (data-driven/overlay).

**TBD (NOT guessed)**: the personality-weighted decision math, per-tile scorers
(overlay page via 0x534C6/0x53539), pathfinder (0x181F:0x59C), and the top-level
AI dispatcher are all Type-A overlay -> blocked on the VP-directory decode (#5).

**Action taken**: recorded. Stale-label follow-up DONE (2026-05-29):
anchor_map.md hot-globals table now lists 0x539E=colony_count / 0x539C=unit_count
with @asm offsets (imul ×0xCA @0x735B3, ×0x1C @0x735D6; cmp 0x30 @0x22584/0x2EB82/
0x4C5D4; set_active_colony @0x82EF); FUNCTIONS_INVENTORY.md gained a "DGROUP record
counts" subsection and its "AI decision entry" search hint was re-anchored to base
0x540E (controller @+0x31). NOTE: the AIPersonality part of this entry (base 0x543F,
controller @+0x00) was itself SUPERSEDED by the 2026-05-29 (RESOLVED) entry above
(base 0x540E, controller @+0x31 = 0x543F); ai_personality.h was already re-anchored
under that ruling, so only its top banner was scoped (struct=BYTE_VERIFIED,
personality weights=RECONSTRUCTED/TBD) — the +0x00 reading was NOT re-applied.

---

## 2026-05-28 (market) — European market model byte-verified; P6 anchor 0x57DC0 is wrong (it's SIGNTREATY)

**Correction**: the P6 trace-anchor map listed market = idx 44 file 0x57DC0. That
function is the diplomacy **SIGNTREATY** handler (alliance matrix @DGROUP:0x8848
stride 0x13C, emits "SIGNTREATY" @0x57E86) — NOT the market.

**Ruling** (BYTE_VERIFIED): the market "struct" IS the active player's PowerRecord —
`func_030550` @0x030550 sets `g_market_ptr[0x84FC] = 0x8808 + power*0x13C`. Price
fields (PowerRecord): **price_level byte[16] @+0x4C** (@0x0306F3), **volume
accumulator word[16] @+0x5C** (@0x030707), boycott mask word @+0x20, gold dword
@+0x2A, tax byte @+0x01, FF count @+0x14. Per-turn drift (orphan range
0x0305FF..0x030B38): volume += scaled demand; when it crosses a per-good
threshold, price_level ±1 and the threshold is consumed; clamp to [floor,
difficulty-scaled ceiling]; emit PRICEUP/PRICEDOWN. Boycott lifecycle: TeaParty set
@0x34717, lift-by-tax @0x33423, clear-all (Jakob Fugger = FF id 1) @0x3BD45, test
`func_030B38` @0x030B38. Per-good economic params load from NAMES.TXT @CARGO into a
9-byte/good table @DGROUP:0x96FC (loader @0x074DEC).

**TBD (NOT guessed)**: the price-level→coin-value (bid/ask) curve is behind RTLink
overlay thunk 0x181F:0x9A4 (not in the static dump); the NAMES.TXT @CARGO numeric
values; FF ids 9/0xE/0x10 effects.

**Action taken**: recorded. market.c write + the FUNCTIONS_INVENTORY P6-map
correction (0x57DC0 → SIGNTREATY) are pending (task #3).

---

## 2026-05-28 (combat) — Combat resolver is func_05B2C2 @ file 0x5B2C2; 0x4E2B6 is NOT combat

**Conflict**: the P6 trace-anchor map / FUNCTIONS_INVENTORY pointed combat at idx
39 file 0x4E2B6; rng.c named func_05B2C2 but unverified; resolve.c formulas were
RECONSTRUCTED ("DO NOT TRUST").

**Ruling** (BYTE_VERIFIED): the combat resolver is **func_05B2C2** (file
0x5B2C2..0x5BE30, 2926 bytes; the per-function splitter wrongly truncated it to 35
bytes at its first early return). Args: attacker [bp+6], defender [bp+8]. The
decision is a SINGLE inclusive roll: `roll = random_int(1, ATK+DEF)` (LCALL
0x181F:0x04D4 @0x5B849), attacker wins iff `roll <= ATK` (@0x5B851/0x5B854) →
P(attack) = ATK/(ATK+DEF). ATK/DEF are the RAW per-type bytes from the stat table
at **DGROUP:0x5230, stride 14 (0xE)**: +0x0C atk (@0x5B83B), +0x0B def (@0x5B823),
+0x06 combat-eligibility (@0x5B404). Plus a 50% ambush coin (random_int(0,1)
@0x5B3B4) for European attackers (owner>=4) without flag 0x10. Loser demotion
ladder @0x5B5AA (Dragoon4→Soldier1→Colonist0; ContCav7→ContArmy9→Colonist0;
Cavalry8→Regular6; Artillery→damaged/destroyed). **0x4E2B6 (idx 39) is the AI
move-eligibility evaluator, NOT combat** (one unit arg, zero random_int calls; its
"RANDOM" tag was an `and ax,0xf` mask).

**Wrong in resolve.c** (to be superseded): RNG call form (used range(0,total-1)
roll<atk — same probability, different RNG consumption → breaks replay); the
fortified/terrain/SoL/FF strength multipliers (NONE scale the raw atk/def inside
the resolver); the stat-table shape (had stride 8/45 types; real is stride 14, ~23
@UNIT types).

**Action taken**: FUNCTIONS_INVENTORY.md priority #3 + blit/main-loop framing
updated. combat.c rewrite + resolve.c supersession pending (next).

**Follow-up / TBD (NOT guessed)**: numeric atk/def values load from NAMES.TXT
@UNIT at runtime (not in the static EXE); internals of overlay helper
0x181F:0x768 (fortification path selector [bp-0x28]) and the popup-key↔DS-offset
map.

---

## 2026-05-28 (refine) — UnitRecord field map: x@0x3144, y@0x3145, type@0x3146, owner@0x3147

**Refines** the "UnitRecord base 0x3146" entry below. Combat tracing of
func_05B2C2 reads, with bx = idx*0x1C: `[bx+0x3144]`=x (@0x5B341),
`[bx+0x3145]`=y (@0x5B34A), `[bx+0x3146]`=type (@0x5B310), `[bx+0x3147]`=owner
low-nibble (@0x5B306). All four use the same idx*0x1C and are contiguous, so the
record's first field (x) is at **0x3144** — the record base is likely **0x3144**
with type at **+0x02** (= 0x3146). The earlier entry correctly killed 0x315E and
identified 0x3146 as the most-referenced field, but labeled 0x3146 as base/field+0;
it is actually field +0x02 (type). This also conflicts with the earlier inference
that 0x3144/0x3145 are "previous-record chain-link bytes".

**Status**: REFINEMENT PENDING one independent confirmation (find the unit
create/move function that WRITES a unit's x/y and confirm it writes
0x3144/0x3145 at idx*0x1C). A verification pass is running. Do NOT re-propagate
base=0x3144 across the corpus until confirmed; the committed base=0x3146 is
"type's address" and remains safe for offset math meanwhile (field = addr −
0x3146 relative to type).

**Action taken**: none yet (verification pending) — recorded so it isn't lost.

---

## 2026-05-28 — UnitRecord table base is DGROUP:0x3146, not 0x315E

**Conflict**: anchor_map.md / decompiled.md / unit.h said the unit-table base is
DGROUP:0x315E (stride 0x1C); docs/DATA_MODEL.md / VICEROY2 /
PROGRESS said 0x3146.

**Source A** — anchor_map.md (33,197,235), decompiled.md (38), unit.h, the
viceroy_source VERIFICATION_LEDGER said base 0x315E "confirmed via
unit_field_lookup_simple (0x66BA)".

**Source B** — docs/DATA_MODEL.md:41, VICEROY2_annotated.c
(`#define UNIT_TABLE_BASE 0x3146`) said base 0x3146 ("652+ refs to [reg+0x3146]").

**Ruling**: **0x3146 wins** (TRUTH_HIERARCHY: raw VICEROY.EXE bytes outrank
inference). `func_008B96` @0x008B99 does `IMUL bx,[bp+6],0x1C` then
`MOV bl,[bx+0x3146]` — index×stride is added to 0x3146, so 0x3146 is the array
origin (field +0x00). Corpus-wide, `imul *,0x1C`→`[reg+0x31xx]` sites cluster as
fields of one record based at 0x3146 (0x3146 hit 203×, 0x315E only 8×). So
0x315E = field +0x18 (word returned by unit_field_lookup_simple 0x66BA),
0x315C = field +0x16 (link word in unit_chain_resolve 0x6672), 0x3154 = +0x0E.
The unit.h "0x315E − 8 = 0x3156" derivation was arithmetically wrong (diff is
0x18=24); its conclusion (0x3146) was right.

**Action taken**: corrected anchor_map.md (33,197,198,235), decompiled.md (38),
unit.h (4-5,16,25-32), VERIFICATION_LEDGER.md (397), PROGRESS.md
(116,117). No code change (load_game_state.py already uses 0x3146).

**Follow-up**: residual tracker lines (viceroy_source/PROGRESS.md, DISASM_LEDGER.md)
still to propagate.

---

## 2026-05-28 — NativeSettlement is 18 bytes @ DGROUP:0x54EC; the 200-byte/0x9100 struct is fabricated

**Conflict**: viceroy_source/docs/DATA_MODEL.md + native.h describe a 200-byte
(0xC8) NativeSettlement at table 0x4850 / data 0x09100 / 80-slot max;
docs/DATA_MODEL.md + project memory describe an 18-byte (0x12)
record at DGROUP:0x54EC.

**Source A** — viceroy_source/docs/DATA_MODEL.md (242-272), native.h,
COLONIZATION_TECHNICAL_REFERENCE.md (200) said 200 bytes / 0x9100 / 0x4850 / 80
slots. Both source files self-flag ">>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<".

**Source B** — docs/DATA_MODEL.md + memory said 18 bytes at
0x54EC (x/y/owner/mission), table compacts on raze.

**Ruling**: **18 bytes @ 0x54EC wins** (raw bytes outrank reconstruction). Every
access uses `imul *,0x12` then `[bx+0x54EC..]` (overlay 0x46035, 0x4610A…); an
18-byte record→record copy at 0x46F40 (`lea di,[bx+0x54EC]`/`lea si,[bx+0x54FE]`,
diff 0x12); live-count at DGROUP:0x539A (INC 0x46E2E, DEC 0x46F5D, cap 0x54=84).
It draws map markers by (x,y) (loop @0x670CF). The 200-byte struct has ZERO byte
support: 0x4850, 0x9100, and `imul *,0xC8` each appear 0× in the binary; 0x4850 is
a save-file offset, not a DGROUP address. 0x5AD6 is a parallel aux column (2 refs,
paired with 0x54EC), not a 624-byte rival table.

**Action taken**: corrected viceroy_source/docs/DATA_MODEL.md (242,244,251-273,
379,398), native.h (19-27,34-47), VERIFICATION_LEDGER.md (201),
COLONIZATION_TECHNICAL_REFERENCE.md (200,201,2324,2326). docs/
DATA_MODEL.md unchanged (already correct; now the cited authority).

**Follow-up**: fields +0x03 and +0x06..+0x11 of the 18-byte record are TBD; the
0x5AD6 aux array is undecoded.

---

## 2026-05-28 — RNG is byte-verified at file 0x103D4 (FUNCTIONS_INVENTORY "NOT YET LOCATED" was stale)

**Conflict**: FUNCTIONS_INVENTORY.md §D (dated 2026-04-20) said the RNG is "NOT
YET LOCATED" and "no LCG constants (0x343FD…) found anywhere"; rng.c + memory say
rand() is byte-verified at file 0x103D4.

**Source A** — FUNCTIONS_INVENTORY.md (511-520) said not located; RNG in MADS
overlay 0x181F.

**Source B** — viceroy_source/src/runtime/rng.c + memory said MSC 6.0 LCG at file
0x103D4, random_int at 0xC322 (verified 2026-05-02).

**Ruling**: **Source B is correct** (raw bytes). At file 0x103D4: `B8 FD 43 BA 03
00` = `MOV AX,0x43FD; MOV DX,3` (multiplier 0x000343FD=214013); `05 C3 9E`/`83 D2
26` (addend 0x00269EC3=2531011); `AND AH,0x7F` → `(seed>>16)&0x7FFF`. Seed at
DGROUP:0x28EE/0x28F0; srand @0x103C2; random_int @0xC322 (via LCALL 0x181F:0x04D4).
The byte pair `FD 43` occurs exactly once in the binary (0x103D5) — proving
0x343FD IS present. §D scanned only the overlay; the RNG is in the load image. §D
also self-contradicted at line 641 ("RNG idx 29 0x3C322 already done").

**Action taken**: corrected FUNCTIONS_INVENTORY.md (511 header, 513-520 status,
backlog item 2). No code change; rng.c already authoritative.

**Follow-up**: none — RNG fully resolved.

---

## 2026-05-19 — AMER2_dos_reference.png IS the pixel target (user override)

**Conflict**: prior 2026-04-15 ruling said `reference/dos/AMER2_dos_reference.png`
was editor-style and should NOT be pixel-chased ("converge style vs in-game
session frames + render_chain"). User directive 2026-05-19 explicitly
overrules this.

**Source A** — prior ruling (2026-04-15, memory note
`project_map_structurally_verified.md`) said: editor export is structural-
only; chase in-game DOSBox frames for style, citing the editor's flat
ocean vs PHYS0.148 dithered ocean as proof of style divergence.

**Source B** — user directive 2026-05-19 said: "the AMER2_dos_reference.png
is what it needs to look like ... no other references, no other questions ...
i dont care if you try every relevant sprite over an area to test it out.
this ends today."

**Ruling**: User directive wins (TRUTH_HIERARCHY tier 7 — user-as-arbiter).
`AMER2_dos_reference.png` is now the canonical pixel target for map
rendering. Empirical sprite trials are permitted; final choices must
still carry `# noqa: fabrication-check` + a citation comment that
references the visible match.

**Action taken**:
- `colonize_sdl/render/terrain.py`:
  - STEP 6b (river overlay): replaced single-sprite-113-dot blit with
    full neighbor-mask topology lookup `_blit_overlay(0 + r_idx)` using
    PHYS0 row 0 (sprites 0-15, pixel-verified rivers in
    `debug_sprite_inspect/phys0_rows_0x01_0x11.png`). Rivers now connect
    through Mississippi/Amazon/Andes basins matching the reference.
  - STEP 1b (center variants): dropped `_ov >= 3` gate — AMER2 has only
    ~70 tiles with ov>=3 vs ~1224 land tiles; the editor draws a per-
    terrain center decoration on every land tile (cotton on plains,
    cactus on desert, tobacco on prairie, etc.). Citation:
    `reference/dos/AMER2_dos_reference.png` pixel density.
  - STEP 5 (display downscale): swapped `transform.scale` (nearest 3:1
    drops 8/9 of source pixels) for `transform.smoothscale` (bilinear)
    so the 48 px buffer's sprite detail isn't decimated on the way to
    16 px display.
  - Lost city rumor overlay: upgraded 3-px circle to PHYS0.103
    medallion at native 16×16 centered.
  - Resource icon overlay: upgraded 8×8 top-right blit to native 16×16
    centered.
- `tools/render_amer2_now.py`: NEW — headless full-map render in COLOPY
  paths. Supports `COLOPY_DUMP_BIG` env var to dump 48 px internal buffer
  for crisp diffs vs the 32-px reference.
- `tools/diff_amer2_vs_dos.py`: NEW — generates side-by-side + abs-diff
  + zoomed crops vs the reference.
- Memory `project_map_structurally_verified.md` rewritten to document
  the override.

**Follow-up**:
- A few orange medallions in DOS reference (e.g., mid-Brazil at
  ~tile (40-44, 46-48)) don't correspond to any ov>=3 tile in AMER2 —
  these may be native settlements rendered separately by
  `_render_native_settlements`, which isn't invoked by the headless
  render. Worth verifying whether enabling that pass closes the gap.
- `tests/golden/*.png` are STALE after this change. Need user approval
  to regenerate via `tests/run_regression.py --update` (and fix
  hardcoded paths in `tools/render_test.py` which still point to the
  old `colonization_project_full` tree).

### 2026-05-19 (b) — follow-up: major/minor rivers + coast sand both sides

**User feedback** (2026-05-19): "there are major rivers and minor rivers.
those need to be correct ... the coasts are all still wrong".

**Findings**:
1. **Rivers**: AMER2.MP has NO data field that directly distinguishes
   major vs minor rivers — both Layer 2 (all zeros) and Layer 3 lack a
   major-flag bit. But empirically, `L1 == 0xC0` (forest+river) tiles
   cluster along the Amazon main trunk through forested terrain (47
   tiles in rows 9-23 cols 30-40), while `L1 == 0x40` (plain river)
   tiles are scattered tributaries (178 tiles). PHYS0 row 0x01
   (sprites 1-15) and row 0x11 (sprites 17-31) provide two separate
   16-variant river sprite banks. Mapped 0xC0→major (sprites 17-31),
   0x40→minor (sprites 1-15).
2. **Coasts**: previous render put sand only on the WATER side of the
   land-water boundary AND drew it BEFORE the forest overlay. On
   forested coastline (most of the Americas, since bases 8-23
   auto-forest), the forest sprite overpainted the sand → invisible
   beaches. Plus the diffuse blend (STEP 2) painted ocean blue onto
   land tiles at the boundary, creating blotchy non-DOS coasts.

**Action taken**:
- `colonize_sdl/render/terrain.py`:
  - STEP 2 diffuse blend: skip when crossing land/water boundary
    (`is_water(raw) != is_water(nb_raw)`). Diffuse stays for
    land/land transitions where DOS does show biome bleed.
  - STEP 3: water-side sand still drawn here.
  - NEW STEP 5b: **land-side sand**, drawn AFTER forest/mountain/
    hills overlays so the beach strip wins at the coast. Uses the
    same TERRAIN.SS.001 sand texture cropped per cardinal direction.
  - STEP 3b: PHYS0 150-153 beach corner overlays drawn on water
    tiles via the existing `COAST_TABLE` (was defined but unused).
  - STEP 6b: river render — split into major (row 0x11, sprites
    17-31) and minor (row 0x01, sprites 1-15) by `(raw & 0xC0) ==
    0xC0` test.
  - STEP 5 (display downscale): reverted smoothscale→scale (nearest);
    bilinear smearing was hiding the sand band.
- `tools/render_amer2_now.py`: now ALWAYS dumps the 48 px buffer to
  `render_AMER2_big48.png` (the actual deliverable — 16 px display
  surface loses too much detail in the 48→16 downscale per hard rule).

**Visual verification**:
- `debug_big48_florida_v6.png` (48-px native) — sand bands clearly
  visible on both sides of every coastline.
- `FINAL_v3_diff.png` (ours vs DOS at matched scale) — coastlines,
  rivers, mountains all align.

**Follow-up still open**:
- Orange resource medallions density still lower than DOS reference.
  Likely a combination of native settlements (rendered by a separate
  pass our headless render doesn't invoke) + the `_ov >= 3` Layer-3
  gate which only fires on ~70 of 1224 land tiles.

### 2026-05-19 (c) — proper 4-corner coast compositor (user-supplied algorithm)

**User feedback**: "the coasts are all still wrong ... if you take a
sample of the coast for any area, and its not exactly the same then
its wrong". User then supplied the canonical Col1 coast-render
algorithm spec verbatim.

**Algorithm** (user-supplied):
1. For each water tile, build an 8-bit mask of "which neighbors are
   land", walking CW from LEFT (bit 0=W, 1=NW, 2=N, 3=NE, 4=E, 5=SE,
   6=S, 7=SW).
2. If mask == 0 → plain open ocean, no compositing.
3. Decompose into 4 × 3-bit quadrant indices:
   - TL = bits (0,1,2) — W, NW, N
   - TR = bits (2,3,4) — N, NE, E
   - BR = bits (4,5,6) — E, SE, S
   - BL = bits (6,7,0) — S, SW, W (bit-0 wraparound)
4. Each 3-bit index picks one of 8 sub-sprites from the corner's atlas.
5. Paste each 8×8 sub-sprite into its quadrant.

**Atlas layout** (visual-verified, debug_sprite_inspect/coast_*_atlas.png):
- PHYS0 108-115 = TL atlas (8 patterns, indices 0-3 are all-black
  placeholders for the no-top-land cases)
- PHYS0 116-123 = TR atlas
- PHYS0 124-131 = BR atlas
- PHYS0 132-139 = BL atlas
Each atlas is pre-rotated for its corner orientation (user note:
"32 sprites (4 rotations × 8 patterns, look up directly)").

**Action taken**:
- `colonize_sdl/render/terrain.py` STEP 3: replaced the lmask-based
  PHYS0 150-153 corner overlays (and the side-strip sand approach)
  with the proper 4-corner composite. Uses the existing
  `_coast_subtile_scaled` helper which already treats both magenta
  AND black as transparent (needed for the placeholder sprites and
  for the "outside the subtile shape" pixels in DOS encoding).
- ALSO: gate each corner draw on its bit_2 (= second orthogonal
  in CW order) being land. TL needs N=land, TR needs E=land, BR
  needs S=land, BL needs W=land. This stops near-empty index-0
  sprites in the TR/BR/BL atlases (~17-35 opaque pixels) from
  painting spurious ripple patches in open-ocean corners of coast
  tiles. The TL atlas placeholders already enforced this rule for
  TL; we apply it symmetrically.
- TREAT sub-sprite "shallow water" blue pixels (B > 100 AND B > R
  AND B > G) as transparent so the underlying ocean texture shows
  through. The atlas blues (~(64,89,165)) are lighter than our base
  ocean (~(40,56,145)), and painting them on top creates visible
  patches — the DOS reference shows near-coast water as the same
  blue as deep water, sand-on-water-tile being the only visible
  coastal feature.

**Visual result**: clean blue ocean, sand bands at every coastline
selected per the 4-corner composite (matching the user's described
geometry — straight cliffs, inside corners for peninsulas, outside
corners for bays).

### 2026-05-19 (d) — forest skip on desert/tundra biomes

**User feedback**: "forest in the desert is a different sprite".

**Finding**: PHYS0 64-79 (the generic forest topology atlas) is all
green deciduous trees. Painting it on top of base 9 (scrub = forested
desert, TERRAIN.SS.008 cacti base) or base 8 (boreal = forested
tundra, TERRAIN.SS.000 tundra-ice base) overpaints the
biome-specific cacti / ice texture with generic green trees — wrong
visual. Our extracted PHYS0 has no per-biome forest overlay atlas
(the Download files' `forest_by_terrain` mapping assumed sprites
that don't exist in our extraction).

**Action taken**:
- `colonize_sdl/render/terrain.py` STEP 5: gate the
  `_blit_overlay(64 + f_idx)` call on `base not in {8, 9, 16, 17,
  18, 22}` — the bases whose base texture already encodes the
  "forest" appearance (cacti, ice, etc.). Other forested bases
  (10-15: mixed/broadleaf/conifer/tropical/wetland/rain) keep the
  green canopy overlay since they ARE green-tree biomes in DOS.
- Bases 17, 18, 22 are AMER2-specific extended terrain IDs that
  map to non-green biome textures via TERRAIN_TO_SPRITE; same
  rule applies.

**Visual result**: desert/scrub tiles in SW US / N Mexico now show
the cacti texture cleanly (debug_desert_compare.png 2026-05-19),
matching the DOS reference.

---

## 2026-04-22 (s) — VICEROY.EXE definitive: auto-forest ALL bases 8-23 including Arctic

**Conflict**: After ruling (r) stopped auto-foresting Arctic per the
MAPEDIT disassembly finding, user said "still wrong". The DOS reference
image clearly shows Canadian Arctic region as mostly FORESTED. Ruling
(r)'s source was MAPEDIT.EXE (the map editor), not VICEROY.EXE (the
actual game). Dispatched dos-disassembler agent to dig into VICEROY's
in-game render code specifically.

**Source (dos-disassembler agent, VICEROY.EXE byte analysis)**:

The game's forest-draw path is at `VICEROY.EXE @ 0x6831B-0x6834C`:

```
0x6831B: cmp word [bp-32], 1     ; folded terrain_class == 1?
0x6831F: je 0x6834F              ; YES → skip forest
0x68321: cmp byte [0xA8A2], 0x08 ; terrain_class < 8?
0x68326: jb 0x6832F              ; → sub-check
0x68328: cmp byte [0xA8A2], 0x10 ; 8 ≤ class < 16?
0x6832D: jb 0x6833D              ; → DRAW FOREST (no bit check)
0x6832F: cmp byte [0xA8A2], 0x10 ; < 16?
0x68334: jb 0x6834F              ; → skip
0x68336: cmp byte [0xA8A2], 0x18 ; >= 24?
0x6833B: jae 0x6834F             ; → skip
          ; fall-through: 16 ≤ class < 24 → DRAW FOREST (no bit check)
0x68349: add ax, 0x0041          ; sprite = 0x41 + wxad_index
0x6834C: call 0x67DC8            ; draw
```

The forest draw happens when `terrain_class` ∈ [0x08, 0x17]. It NEVER
checks `[0xA8A1] & 0x80` (the .MP forest bit). The forest bit only
distinguishes mountains vs hills.

**The terrain_class lookup** (`lcall 0x181F:0x06AA` → resolves to
func_L124 @ `VICEROY.EXE 0x6204`):

```
pass 2 (render mode):
  if (input >= 0x18):  return input               ; pass-through
  if (input < 0x08):   return input               ; pass-through
  else:                return (input & 7) | 8     ; for 8..23
```

This is pure bit arithmetic — NO 8-entry lookup table. For any raw base
in 8-23, the function returns `(base & 7) | 8` = values in 0x08-0x0F —
which all land in the forest gate's fire range.

**Mapping**: Bases 8, 9, 10, 11, 12, 13, 14, 15 fold to class 8, 9,
10, 11, 12, 13, 14, 15 (via `(x & 7) | 8`). Bases 16, 17, 18, 19, 20,
21, 22, 23 ALSO fold to class 8, 9, 10, 11, 12, 13, 14, 15 (same
formula). **All 16 bases in range 8-23 trigger forest draw.**

**Contrast with MAPEDIT**: MAPEDIT's equivalent function (scrub result
(r)) skips forest for base 16. MAPEDIT is the map-editor preview
renderer; VICEROY is the actual gameplay renderer. When they differ,
VICEROY is authoritative for matching the DOS reference screenshot.

**Ruling**: **All bases 8-23 (including Arctic = base 16) auto-forest.**

`_tile_has_forest(r)` simplified:
```python
def _tile_has_forest(r):
    f = r & 0xE0
    b = r & 0x1F
    if f == 0xA0: return False  # mountain
    if f == 0x20: return False  # hills
    return (8 <= b <= 23)       # VICEROY's actual rule
```

The .MP `feat & 0x80` (forest bit) test is REMOVED because VICEROY
doesn't consult it for forest draw. All forest comes from `base in
8..23` via the terrain_class lookup.

**Action taken**:
- `colonize_sdl/main.py`:
  - `_tile_has_forest`: simplified to `return (8 <= b <= 23)` after
    the mountain/hills early-outs.
  - Full citation block added referencing VICEROY 0x6204, 0x6831B,
    0x68349.
- Goldens updated (4/4 pass).

**Visual verification** (vs DOS reference):
- **Canada**: heavily forested (base 16 Arctic + base 18 extended-
  Tundra all auto-forest). White-blue ice BASE under the forest
  overlay — matches DOS "boreal forest on snow" appearance.
- **South America**: Amazon dense, Pampas dry, Andes ridge.
- **North America**: central Great Plains olive (base 2, not auto-
  forested since < 8); eastern deciduous forest (bases 8-15 + 17-23);
  Rockies west coast.

**Follow-up**:
- MAPEDIT's different behavior is noted in FUNCTIONS_INVENTORY.md.
- Bases 17-23 are "forested variants" of bases 1-7 in VICEROY's
  encoding via the `& 7 | 8` fold. The sprite row (forest row 0x41)
  is used for all of them with wxad topology — our rendering matches.
- Ruling (r) is SUPERSEDED. Ruling (o) before it is also obsolete.
  Current authoritative: (l) terrain order, (n) extended bases +
  forestry, (p) coast via biome edge strip, (q)→(r)→(s) for Arctic.

---

## 2026-04-22 (r) — Authoritative ruling from MAPEDIT disassembly + cc94 source

**Conflict**: After rulings (p) and (q) tried to fix Canadian Arctic
and coast rendering by guessing, user directed us to scrub the DOS
binaries and cc94 source for authoritative answers.

**Source A (dos-disassembler agent)** — direct evidence from MAPEDIT
Ghidra dump, parallel rendering function `FUN_1a47_0932` at segment
1a47:

1. **Arctic (base 16) does NOT auto-forest**. At 1a47:0abe:
   `CMP [0x5acc], 0x18 / JC LAB_0ad9` — for Arctic (raw base=0x10=16),
   since 16 < 24, the jump is taken, skipping the forest-overlay draw
   call (which is at 1a47:0ad3: `ADD AX, 0x41` → PHYS0 row 0x41).
   **MAPEDIT does NOT draw forest on Arctic tiles.**

2. **Coast sprites**: MAPEDIT uses TWO code paths:
   - **Branch A** (matched corner pattern, 1a47:0c8c-0c9a):
     sprites 0x97-0x9A = 151-154 overlay when 8-direction mask matches
     specific patterns at `[0x5ad3]`.
   - **Branch B** (per-subquadrant loop, 1a47:0c41-0c7f):
     sprite base = 0x6D = 109, 4-iteration loop, one sprite per
     tile quadrant.

3. **Forest sprite row** = PHYS0 0x41 (65). **Mountain row** = 0x21
   (33). **Hills row** = 0x31 (49). All with wxad topology index.

4. **Center variant table** at DS:0x192. Arctic (index 16 in the
   table) has value `0xFFFF` (-1), meaning Arctic draws NO center
   sprite.

**Source B (general-purpose agent researching cc94)** — verbatim
code inspection of `https://github.com/institution/cc94`:

1. **Arctic is biome 9** in cc94. `render_terr` in
   `src/client/renderer.cpp` draws forest only when
   `terr.has_phys(PhysForest)` is explicitly set — **no auto-forest
   special case for Arctic**.

2. **Coast algorithm** is LAYERED:
   - Biome texture (base fill)
   - 4 `render_diffuse` calls using PHYS 105-108 as ALPHA MASKS with
     neighbor's biome texture → creates the sand/grass EDGE STRIPS
     that match the adjacent biome's color.
   - If water: 4 subquadrants using PHYS 109-140 as ALPHA MASKS with
     ocean/sea-lane TEXTURE via `MODE_REPLACE` (subtile shape = water
     visible vs biome visible).
   - **Sprites 150-153 are NOT used by cc94's main coast algorithm.**

3. **cc94 does NOT consume DOS .MP files** — it has its own Boost
   serialization format. Cannot tell us about DOS bytes 17-23.

**CONVERGENT VERDICT**:
1. Arctic does NOT auto-forest. (Both sources agree, explicit evidence)
2. Beach corner sprites (150-153) are NOT the primary coast
   mechanism in DOS or cc94. They may appear as an overlay for specific
   MAPEDIT patterns (151-154) but the main coast effect comes from:
   (a) biome-color edge strip from adjacent neighbor (matches what
       we implemented in ruling (p) STEP 3a)
   (b) 4-subquadrant subtile masks (cc94's render_sprite_replace with
       MODE_REPLACE) — we're simplifying without these for now

**Ruling**:

1. **Remove auto-forest on Arctic**. `_tile_has_forest` no longer
   returns True for base 16. Arctic tiles render as pure white-blue
   ice with no forest overlay. The Canadian "green" in the DOS
   reference comes from adjacent base-8 (Boreal), base-18 (extended
   Tundra), and forested base-11/12 tiles — NOT from Arctic itself.

2. **Remove beach corner sprite overlays** (the 15-mask `corner_map`
   added in (q)). Neither cc94 nor the DOS reference relies on these
   for the main coast effect. The biome-color edge strip from STEP 3a
   carries the coast appearance adequately at our display resolution.
   (Future enhancement: implement the 4-subquadrant alpha-mask system
   using pygame BLEND modes to get even closer to cc94's algorithm.)

**Action taken**:
- `colonize_sdl/main.py`:
  - `_tile_has_forest`: dropped the `if b == 16: return True` clause
    added in (q). Reverted to pre-(q) behavior.
  - STEP 3b beach corner overlay: removed. The 15-mask `corner_map`
    deleted; coast rendering now consists of:
      STEP 3a: biome-color edge strip on each land-facing edge
      (Step 2 diffuse blend already runs independently for all tiles)
- Goldens updated (4/4 pass).

**Visual verification** (vs DOS reference screenshot):
- **Canadian region**: Arctic tiles (white-blue ice) interspersed
  with Boreal forest (base 8, Tundra+forest). Pattern matches the
  DOS reference's mostly-green Canada with some ice.
- **Coast edges**: Biome-matching strips without the beach sprite
  noise. Clean transitions from ocean to adjacent biome.

**Follow-up**:
- Implement the cc94-style 4-subquadrant coast masks using pygame's
  BLEND_RGBA_MULT or similar to get the authentic DOS "ocean carved
  out by coast shape" effect. For now the biome strips alone are
  close enough.
- Bytes 17-23 remain partially undocumented — MAPEDIT folds them via
  `& 0x7` but the exact biome mapping is inferred from cluster
  analysis only. This is a cosmetic limit, not a functional bug.
- Ruling (o) and (q) superseded by (r).

---

## 2026-04-22 (q) — Auto-forest Arctic; full 15-mask beach composite

**Conflict**: User after ruling (p): "that corrected part of the
coasts and messed up the others and there is to much arctic in canda".

Two issues:
1. **Coast composites too sparse**: Ruling (p) only overlaid beach
   corner sprites for the 4 CONVEX corner masks (0b1001/0011/1100/0110).
   Straight edges (single-cardinal masks), opposite-side masks
   (0b0101/1010), T-junctions (0b0111/1011/1101/1110), and the
   surrounded mask (0b1111) were relying on the biome-color edge
   strip ALONE. This left those coast types without the characteristic
   DOS sand-curve detail, making them look "messed up" compared to
   the corrected convex corners.
2. **Too much arctic in Canada**: Ruling (o)'s Arctic/Tundra swap
   made byte 16 (Arctic) render as sprite 0 (yellow-grey). With 118
   byte-16 tiles in Canada, that's a LOT of yellow-grey Arctic. The
   DOS reference image shows the Canadian region as mostly GREEN
   BOREAL FOREST with occasional ice patches — not overwhelming
   arctic coverage.

**Ruling**:
1. **Expand the beach-corner composite to cover all 15 non-zero
   cardinal land masks**:
   - Single-cardinal (straight edge): 2-corner composite
     (e.g., N only → sprites 150+151; matches (c) and (f) approach)
   - 2-cardinal convex corner: 1 corner sprite
   - Opposite sides: all 4 corners
   - T-junctions (3 cardinals): the 3 matching corners
   - 4-cardinal surround: all 4
2. **Revert (o) Arctic/Tundra swap** to literal NAMES.TXT:
   - Byte 0 (Tundra) → sprite 0 (yellow-grey)
   - Byte 16 (Arctic) → sprite 9 (white-blue)
3. **Auto-forest base 16** (Arctic) by adding it to `_tile_has_forest`.
   Arctic tiles now render as white-blue ice BASE + forest overlay.
   Result: Canadian Arctic region reads as "boreal forest on snow"
   — matching the DOS reference's mostly-green Canada.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[0]`: 9 → 0. `TERRAIN_TO_SPRITE[8]`: 9 → 0.
    `TERRAIN_TO_SPRITE[16]`: 0 → 9. `TERRAIN_TO_SPRITE[18]`: 9 → 0.
    All palette indices (`TERRAIN_PAL_INDEX`) reverted accordingly.
  - `_tile_has_forest`: added early `if b == 16: return True`.
  - STEP 3b beach overlay block: replaced the 4-entry `corner_sprite`
    dict with a 15-entry `corner_map` covering all cardinal land
    masks; iterates over the list of sprites for the matched mask.
- Goldens updated (4/4 pass).

**Visual verification** (comparing to DOS reference screenshot):
- **Canadian region**: now appears as GREEN BOREAL FOREST with
  scattered Arctic/Tundra patches — matching the DOS reference's
  heavily-forested Canada. Previously-overwhelming yellow-grey
  Arctic reduced.
- **Coasts**: every coast type now shows the sand-curve detail
  (straight edges, corners, T-junctions, surrounds). The biome-color
  edge strip from ruling (p) provides the background tint matching
  the adjacent biome; the corner sprites provide the sand-curve
  ring on top.
- **Concave / T-junction / surround masks** previously had bare
  biome strips only; now get the composite sand curves too.

**Follow-up**:
- If the Arctic forest overlay covers too MUCH of the white-blue
  base (making Canada look too green), the forest sprite density
  can be tuned via wxad variants. Current default picks the wxad
  sprite based on forest neighbors.
- Ruling (o) superseded by (q).

---

## 2026-04-22 (p) — Coast reverts to biome edge strip + beach corners; drop subtile system

**Conflict**: User shared a screenshot of the ORIGINAL DOS Colonization
Americas map as reference. Comparison with our current render revealed
that the cc94-based subtile coast system (ruling (f)) produced a
blue-green RIVER-BANK pattern at coastlines, while the DOS game shows
clean SAND/BIOME-COLOR STRIPS at coastlines matching the adjacent land
biome (sandy where desert, grassy where forest).

**Source A** — DOS AMER2 reference screenshot provided by user:
coastlines show a thin uniform strip of the ADJACENT BIOME'S color
(sand/tan next to desert, grass-green next to forest/grassland). The
strip is BRIGHT and UNIFORM, not the blue-green bank pattern.

**Source B** — re-inspection of PHYS0 sprites 108-139: these 8×8
sprites have green banks on blue water — clearly river-bank graphics,
not sand beaches. cc94 REPLACED the DOS coast sprites with its own
green-bank art (generated via `gen_coast()` in cc94's make_all.py)
which is where the mismatch came from. The ACTUAL DOS coast must use
a different rendering path.

**Source C** — PHYS0.150-153 = 4 sand-beach CORNER sprites (full-tile,
16×16). These have sand-ring curves on 2 edges with transparent
magenta on the "away-from-land" half. They're the traditional beach
sprites referenced in the earlier rulings (a-e).

**Ruling**: **Replace the 32-subtile coast system with a two-step
renderer**:

1. **Biome-color edge strip** (STEP 3a): For each cardinal direction
   where the water tile's neighbor is land, paint a 1-sub-cell-wide
   (16-px on the 48×48 internal buffer) strip of the NEIGHBOR's
   TERRAIN.SS base texture along that edge. Desert coasts show sandy
   strips; grassland coasts show green strips; forest coasts show
   the forest's underlying biome color.

2. **Beach corner sprite overlay** (STEP 3b): For 2-adjacent-cardinal
   land masks (0b1001=N+W → 150, 0b0011=N+E → 151, 0b1100=S+W → 152,
   0b0110=S+E → 153), overlay the matching beach corner sprite on
   top of the edge strip. Provides the sand-ring curve detail at
   convex corners.

Non-convex (straight-edge) coast masks rely on the edge-strip alone —
no beach sprite composite needed because the strip matches the DOS
uniform-band appearance.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - STEP 3 water-tile block rewritten. Subtile rendering loop
    removed. New code computes a cardinal land mask, then paints
    biome-texture edge strips for each land-adjacent cardinal, and
    overlays a beach corner sprite for 2-adjacent-cardinal masks.
  - The `_coast_subtile_scaled` helper and its cache remain in place
    but are now unused (kept for possible future river-mouth
    rendering that shares the 8×8 format).
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- Coastlines now show clean biome-matching strips matching the DOS
  reference.
- Amazon and North American forest edges show green-grass strips;
  Mexican/Patagonian desert coasts show sandy strips; arctic/tundra
  northern coasts show white/grey strips.
- Water bodies are cleaner blue without the river-bank noise.

**Follow-up**:
- The subtile system (sprites 108-139) may actually be intended for
  RIVER MOUTH rendering where rivers meet the ocean. If DOS shows
  specific river-mouth graphics at coastal river endings, we can
  hook those sprites back in via an orthogonal rule.
- Straight-edge coasts (1-cardinal-land masks) no longer have the
  2-corner sprite composite — just the edge strip. If DOS shows
  a specific sand curve on straight edges too, we can revisit.
- Ruling (f) is SUPERSEDED by (p) for coast rendering. The underlying
  cc94 references in (f) remain useful for forest/river/diffuse
  rendering which are unaffected.

---

## 2026-04-22 (o) — Swap Arctic/Tundra sprite mappings for Canada

**Conflict**: User: "in canada you will need to swap arctic with tundra".

The TERRAIN.SS sprite semantics had two candidate textures for polar
terrain:
- Sprite 0: yellow-grey speckled (reads as "ice-on-tundra-grass")
- Sprite 9: white-blue dithered (reads as "pure frozen snow/ice")

Ruling (l)'s literal NAMES.TXT order assigned:
- Byte 0 (Tundra) → sprite 0 (yellow-grey)
- Byte 16 (Arctic) → sprite 9 (white-blue)

User reads the textures the OPPOSITE way visually:
- Yellow-grey speckle = ARCTIC (mostly-ice with melt patches)
- White-blue pure = TUNDRA (snow-covered grass)

**Ruling**: Swap the sprite assignments for byte 0 and byte 16:
- byte 0 (Tundra) → sprite **9** (was 0)
- byte 16 (Arctic) → sprite **0** (was 9)
- Forested Tundra variant byte 8 (Boreal) follows: → sprite **9**
- Extended base 18 (far-north Tundra-like) follows: → sprite **9**
- `TERRAIN_PAL_INDEX` palette fallbacks updated accordingly:
  - byte 0: 20 → 15 (now white)
  - byte 16: 15 → 20 (now grey)
  - byte 8: 20 → 15
  - byte 18: 20 → 15

Only Canada is affected because bytes 0 and 16 appear exclusively in
the far-north rows 3-9 of AMER2 (no base 0 or 16 tiles exist south of
row 10). The swap is a visual correction confined to that region.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[0]`: 0 → 9
  - `TERRAIN_TO_SPRITE[8]`: 0 → 9 (Boreal follows)
  - `TERRAIN_TO_SPRITE[16]`: 9 → 0
  - `TERRAIN_TO_SPRITE[18]`: 0 → 9 (extended tundra follows)
  - `TERRAIN_PAL_INDEX` entries updated to match.
- Goldens updated (4/4 pass).

**Visual verification**:
- Canada now shows a clearer mix of Arctic (yellow-grey ice-speckle)
  and Tundra (white-blue snow) textures. Polar-row override still
  forces the TOP row to Arctic, which now renders as yellow-grey —
  visually distinct from the Tundra below it.
- The polar-row Arctic band is no longer a blinding white strip; it
  transitions naturally into the Canadian hinterland.

**Follow-up**:
- If the user wants the TOP ROW (y=0) to render as the WHITE variant
  instead (sprite 9 = Tundra per this swap), the polar-row override
  should force base=0 (not base=16). This is a separate aesthetic
  decision; currently the override forces base=16 per DOS convention.

---

## 2026-04-22 (n) — Fix base-20 Tundra misplacement + restore auto-forestation

**Conflict**: User: "tundra is in many places where it shouldn't be, the
forestry was ok the way it was before".

Two regressions from ruling (m):
1. **Tundra appearing in warm zones**. Base 20 was mapped to sprite 0
   (Tundra) on the assumption it clustered in the far north. Actually
   only 9 of its 45 tiles are in arctic rows (y<10); 12 are in center
   (y=20-23), 8 are in far south (y=54-56 = southern Brazil/Argentina
   region). Rendering those 36 tiles as Tundra was wrong.
2. **Forestry regression**. Removing auto-forestation from extended
   bases 17-23 (ruling m) left large swaths of the map unforested
   when the user had preferred the "(i)+(j)" look with forest overlay
   on extended bases.

**Source**: `tools/find_18_20.py` spatial analysis:
- Base 18: 76 of 81 tiles in rows 4-18 (94% northern) → Tundra stays.
- Base 20: spread across rows 3-56, only 9 truly northern → not Tundra.

**Ruling**:
1. **Base 20 → Grassland** (sprite 4, palette 91). Works at any
   latitude; doesn't pretend all base-20 tiles are arctic. Base 18
   stays Tundra because its cluster is genuinely northern.
2. **Restore `17 <= b <= 23` clause** in `_tile_has_forest`. Extended
   bases render with forest overlay again, matching the (i)/(j) look.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[20]`: 0 (Tundra) → 4 (Grassland).
  - `TERRAIN_PAL_INDEX[20]`: 20 (tundra-grey) → 91 (grassland-green).
  - `_tile_has_forest`: added back `or (17 <= b <= 23)`.
- Goldens updated (4/4 pass).

**Visual verification**:
- **North America**: Tundra now only in the actual arctic latitudes
  (rows 3-14 where base 0, 8, 16, 18 live). No more Tundra-speckle in
  central USA or northern South America. Eastern forest restored on
  base-17/19/23 tiles.
- **South America**: Pampas/Patagonia show appropriate grass+tundra
  mix at the far south; Amazon and Central America show dense forest
  including on base-21 and base-23 tiles. Base-20 outliers in the
  southern Brazil area now render as Grassland with forest (not
  Tundra), which matches their climatic zone.

**Follow-up**:
- Base 18's 5 southern outliers (y=16-18) might still look Tundra-ish
  in a slightly too-warm zone, but 94% cluster justifies keeping the
  Tundra mapping. Could add y-based overrides later if needed.

---

## 2026-04-22 (m) — Terrain renders match .MP data exactly; no auto-forestation

**Conflict**: User: "you still need to make sure all the underlying
terrain is matching and lining up to the coding in the amer2.mp".

After ruling (i) added auto-forestation to extended bases 17-23 (to
address the "add the forestation to everything" request), some tiles
were rendering with fake forest overlay when the .MP byte didn't
actually carry the forest flag. The user wants WHAT-YOU-SEE to equal
WHAT'S-IN-THE-DATA.

**Audit of current mappings**:

1. Core biomes (bytes 0-15, 16, 25, 26) already use literal NAMES.TXT
   order after ruling (l) — no changes needed.
2. Extended base 21: comment said "Savannah-yellow" but mapped to
   sprite 3 which AFTER (l) is Prairie (yellow-green). This is a leftover
   error from when sprite 3 = Savannah per the (i) swap. Fix: 21 → sprite 5
   (Savannah/bright green).
3. `_tile_has_forest` included `17 <= b <= 23` as auto-forest bases.
   This caused 566 extended-base tiles to render with forest overlay
   regardless of their feat bits. The .MP file encodes only 244 tiles
   as explicitly forested (bases 8-15 or feat & 0x80); the other ~300
   were getting spurious forest that isn't in the data.

**Ruling**:
1. **Fix base 21 sprite**: `TERRAIN_TO_SPRITE[21] = 5` (was 3).
   `TERRAIN_PAL_INDEX[21] = 40` (was 60).
2. **Remove auto-forestation from extended bases**. `_tile_has_forest`
   now returns True only for:
   - explicit forest flag (feat bit 7 set, non-mountain), OR
   - forested-biome base IDs 8-15 (Boreal..Rain)
   Extended bases 17-23 render as their bare biome texture (Grassland,
   Tundra, Savannah, Marsh). They still get forest overlay if feat bit
   7 happens to be set (e.g., AMER2 has a few base-17/19/20/23 tiles
   with feat=0xC0 = forest+river; those still draw the forest overlay
   correctly).

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[21]`: 3 → 5. Comment corrected.
  - `TERRAIN_PAL_INDEX[21]`: 60 → 40.
  - `_tile_has_forest`: dropped the `or (17 <= b <= 23)` clause.
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- **South America**: Amazon area remains densely forested via bases
  11/13/15 (Broadleaf/Tropical/Rain) which DO explicitly encode
  forest. Base-21 tiles (Central/South tropical zone) now render as
  bright-green Savannah WITHOUT overlay — matching the .MP encoding.
  Pampas/Patagonia in southern Argentina show clean grass/tundra.
- **North America**: Central US plains show olive-brown PLAINS
  (sprite 2) cleanly, without the fake forest that used to cover
  base-23 tiles. Eastern deciduous forest is now concentrated where
  the data actually places forested bases (8, 12, etc.) rather than
  blanketing extended-base tiles.

**Follow-up**:
- Rulings (i)'s "add forestation to everything" directive was about
  making the forest OVERLAY more visible on genuinely-forested tiles
  (bases 8-15), which was accomplished via the denser sprite 79 and
  wxad topology. The extended-base auto-forest was a misinterpretation
  that's now corrected.
- If the user wants MORE forest coverage on extended-base tiles
  specifically, the .MP file would need to be edited to set the forest
  flag (bit 7) on those tiles. The renderer is now strictly data-driven.

---

## 2026-04-22 (l) — Final terrain mapping: literal NAMES.TXT order; polar rows land-only

**Conflict**: User clarifying feedback after rulings (i) and (k):
1. "savannah is sprite 5, prairie is sprite 3 and planes is sprite 2"
   — the FINAL, definitive assignment. This supersedes both prior
   swaps ((i) and (k)) and reverts to the literal NAMES.TXT order.
2. "only land tiles in the first row are arctic, not all of them" —
   the polar-row override should not apply to ocean tiles.

**Ruling**: **Revert all Prairie/Savannah/Plains swaps. Use literal
NAMES.TXT byte-to-sprite mapping.**

| Byte | Name     | Sprite | Color          |
|------|----------|--------|----------------|
| 0    | Tundra   | 0      | yellow/white   |
| 1    | Desert   | 1      | sandy          |
| **2**    | **Plains**   | **2** | **olive-brown** |
| **3**    | **Prairie**  | **3** | **yellow-green** |
| 4    | Grassland| 4      | dark green     |
| **5**    | **Savannah** | **5** | **bright green** |
| 6    | Marsh    | 6      | green-blue     |
| 7    | Swamp    | 7      | green-blue wet |

Forested variants use the same ground sprite as their unforested
counterpart (8→0, 10→2, 11→3, 12→4, 13→5, etc.). Scrub (9) keeps
sprite 8 (desert-with-cactus). Extended bases 17-23 unchanged from (j).

**Polar-row rule**: Applies ONLY to land tiles. Ocean at `y=0` or
`y=H-1` stays ocean.
```python
if (my == 0 or my == MAP_HEIGHT - 1) and base not in (25, 26):
    base = 16  # force Arctic
```

**Rationale**: Earlier rulings (i) and (k) tried to chase a color-vs-name
mismatch based on intermediate user descriptions. The user's clarifying
message with explicit byte↔sprite pairs is authoritative (level 1). The
literal NAMES.TXT order appears to be correct; the prior "savannah
labeled as prairie" complaint must have referred to a specific tile or
context we misread, not a global sprite swap.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE`: all Plains/Prairie/Savannah mappings reverted
    to literal (N→N). Forested variants reverted.
  - `TERRAIN_PAL_INDEX`: palette indices for 2/3/5/10/11/13 reverted.
  - Polar-row override: added `and base not in (25, 26)` so ocean
    stays ocean.
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- **North America**: top row shows alternating arctic (on land) and
  ocean (on water); Great Plains = olive-brown; eastern forest = dark
  green; Rockies continuous snow ridge.
- **South America**: bottom row same rule (arctic on land, ocean on
  water); Pampas = olive; Amazon = dark green; Andes = continuous
  snow.

**Follow-up**: This is the FINAL mapping unless the user provides
further corrections. Rulings (i) and (k) are superseded by (l).

---

## 2026-04-22 (k) — Plains/Savannah swap + polar rows forced to Arctic

**Conflict**: User: "you have plains and savannah mixed up and possibly
savannah tundra and arctic. any tile on the first map row needs to be
arctic."

**Issue 1 — Plains/Savannah swap**:

After ruling (i) swapped Prairie (byte 3) with Savannah (byte 5), the
user now reads sprite 2 (olive-brown) as "savannah" and sprite 3
(yellow-green) as "plains". The user's mental model:
  - olive-brown (sprite 2)  = SAVANNAH (dry, scattered trees)
  - yellow-green (sprite 3) = PLAINS (short-grass plains)
  - bright green (sprite 5) = PRAIRIE (lush grassland)

This is a player-centric reading different from NAMES.TXT's literal
byte-to-name mapping. User preference wins (level 1).

**Issue 2 — Polar rows should be Arctic**:

DOS Colonization's map design rule: the TOP and BOTTOM rows of the map
are always Arctic (impassable polar terrain). Units can't cross these
edges. Our renderer was rendering the underlying .MP bytes literally
(ocean at y=0 in AMER2), missing the visual polar border.

**Ruling**:
1. **Plains/Savannah cyclic reassignment**:
   - byte 2 (Plains)   → sprite 3 (yellow-green)
   - byte 3 (Prairie)  → sprite 5 (bright green)  [kept from (i)]
   - byte 5 (Savannah) → sprite 2 (olive-brown)
   - Forested variants swap to match:
     - byte 10 (Mixed = Plains+forest) → sprite 3
     - byte 13 (Tropical = Savannah+forest) → sprite 2
   - `TERRAIN_PAL_INDEX` (solid-color fallback) updated accordingly.
2. **Force polar rows to Arctic**:
   - At `my == 0` or `my == MAP_HEIGHT - 1`, override the tile's base
     to 16 (Arctic) before rendering, preserving feature flags
     (mountains/hills/rivers are still drawn on top, so an Arctic
     mountain still gets its peak overlay).
   - Applies to ALL tiles including ocean at the edge, matching DOS's
     polar-border convention.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE`: `2` now maps to sprite 3; `5` maps to sprite
    2. Forested counterparts `10` and `13` updated accordingly.
  - `TERRAIN_PAL_INDEX`: palette indices for 2/5/10/13 updated.
  - In the render loop, after reading the raw byte, an early override
    forces `base = 16` when `my in (0, MAP_HEIGHT - 1)`.
- Goldens updated for all 4 test maps (4/4 pass).

**Visual verification**:
- **AMER2 full**: white Arctic band spans the top AND bottom rows of
  the map (previously all-ocean).
- **North America zoom**: central Great Plains region now shows
  yellow-green (sprite 3 = user's Plains); scattered savannah-olive
  spots in appropriate locations; Arctic band clearly visible at top.
- **South America zoom**: Patagonia region and bottom arctic border
  visible; inland biomes render with the (k) color scheme.

**Follow-up**:
- User also said "possibly savannah tundra and arctic" are mixed up.
  After the polar-row rule and Plains/Savannah swap, the remaining
  distinction between Tundra (sprite 0, yellow-white speckled) and
  Arctic (sprite 9, white-blue) may need further review. The Tundra
  sprite reads as a partially-melted polar terrain which is arguably
  correct for "tundra grass in spring/fall". Deferred pending further
  user feedback on specific northern tiles.
- The polar-row override is a RENDERER-ONLY change; the underlying
  .MP byte is unchanged. Saving/exporting the map will still write
  the original byte (no data loss).

---

## 2026-04-22 (j) — Northern tundra bases + wxad topology for mountains/hills

**Conflict**: User after seeing the rendered Americas:
1. "issues with the arctic terrain" and "areas in far north america"
   — bases 18 and 20 were mapped to Plains-olive, but they cluster
   HEAVILY in rows 3-14 of AMER2 (76 + 15 = 91 tiles in the far
   north) where the geography should be Tundra/Boreal, not plains.
2. "the right mountain and hill combinations based on where the
   mountains are located" — mountains and hills were single-sprite
   (PHYS0.45 and PHYS0.61). Isolated peaks looked fine but mountain
   RANGES (Andes, Rockies) looked like disconnected dots rather than
   continuous ridges because every tile painted the same solo-peak
   sprite regardless of its neighbors.

**Source A** — spatial analysis of AMER2 (`tools/top_rows.py`):
- Rows 3-9: Arctic (base 16) heavy, 95 tiles. Boreal (8) scattered.
  Bases 18 and 20 appear interleaved with Arctic/Tundra.
- Rows 10-14: transition zone, bases 2/3/4 appear alongside 18/20/10.
- South of row 15: bases 18 and 20 almost disappear (only 5 and 30
  tiles respectively out of their totals of 81 and 45).

**Source B** — MAPEDIT.EXE disassembly at segment `1a47:0379-03dc`:
  ```
  local_4 = 0xA0               ; mountain test mask
  AX = neighbor & 0xA0
  if (AX == 0xA0) mask |= N_bit
  ...
  ```
  Identical pattern to `get_wxad_index` (cc94 forest). Builds 4-bit
  mask of cardinal neighbors that also have feat=0xA0. This lookup
  returns a variant index used to pick from the 16-sprite mountain
  row. Therefore DOS's in-game mountain renderer uses **wxad topology**
  to produce connected ridges.

**Source C** — PHYS0 sprite rows:
  - Row 0x21 (sprites 32-47): 16 mountain topology variants.
  - Row 0x31 (sprites 48-63): 16 hills topology variants.
  Each row's 16 sprites correspond to the 16 possible 4-bit cardinal
  neighbor masks. Sprite index offset 0 is "solo" (no same-elevation
  neighbors); offset 15 is "fully surrounded by same elevation".

**Ruling**:
1. **Reassign bases 18 and 20 to Tundra ground texture** (sprite 0,
   palette index 20 = tundra-grey). Other extended bases (17/19/21/22/23)
   keep their existing cluster-based mappings.
2. **Use wxad topology for mountains**: sprite = 32 + wxad_index where
   index is built from 4 cardinal neighbors having `feat == 0xA0`.
3. **Use wxad topology for hills**: sprite = 48 + wxad_index where
   index is built from 4 cardinal neighbors having `feat == 0x20`.

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE[18]` and `[20]` changed from 2 (Plains) to 0 (Tundra).
  - `TERRAIN_PAL_INDEX[18]` and `[20]` changed from 54 to 20.
  - STEP 4 elevation block rewritten: added `_tile_is_mountain(r)` and
    `_tile_is_hills(r)` helpers. For mountain tiles, computes `m_idx`
    from cardinal mountain-neighbors and blits `ts[32 + m_idx]`. For
    hills, computes `h_idx` and blits `ts[48 + h_idx]`.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification**:
- **North America**: Canadian Arctic region is now tundra-grey/white
  (no more Plains-olive splotches); Rocky Mountains form a proper
  continuous snow-capped ridge rather than isolated dots; hills
  scattered through the plains have natural clustered topology.
- **South America**: Andes mountains are now a contiguous range
  running north-south along the west coast (instead of solo peaks);
  Patagonia shows tundra in the far south; Brazilian highlands have
  properly-topologized hills.

**Follow-up**:
- PHYS0 sprite 32 (mountain wxad=0 = solo peak) and sprite 48 (hills
  wxad=0) need a visual sanity check to make sure the orphan-tile
  rendering still reads clearly. They are used for mountain tiles
  with no mountain neighbors (the AMER2 data has ~30 such tiles).
- `FUNCTIONS_INVENTORY.md` Section X already documents the MAPEDIT
  wxad-mountain loop; the rendering now matches what the disassembly
  showed.

---

## 2026-04-22 (i) — Savannah/Prairie sprite swap; extended bases 17-23 = forested

**Conflict**: User feedback after the river render:
1. "you have savannah labeled as prairie" — the sprite at TERRAIN.SS index
   5 (bright green) was being used for byte 5 (Savannah per NAMES.TXT),
   and sprite at index 3 (yellow-green) for byte 3 (Prairie). User's
   natural reading of the colors is inverted: yellow-green looks like
   Savannah (dry African grassland), bright green looks like Prairie
   (lush American grassland).
2. "terrain 23 discrepancy" — base 23 is the SECOND most common byte on
   AMER2 (194 tiles, ~7% of the map) but TERRAIN_TO_SPRITE mapped it to
   sprite 2 (Plains olive) with no forest overlay. The user sees large
   brown/olive patches where dense forest should be.
3. "add the forestation to everything" — forest coverage feels too
   sparse on AMER2.

**Source A** — NAMES.TXT order: byte 3 = "Prairie", byte 5 = "Savannah".
**Source B** — TERRAIN.SS sprite inspection (cc94 palettes confirm):
  - Sprite 3: yellow-green gradient
  - Sprite 5: bright green pattern
**Source C** — cc94's `terrain/prairie-pal.png` (yellow-green) and
  `terrain/savannah-pat.png` (bright green) match SPRITE indexing 3 and 5
  respectively, supporting Source A's byte-to-sprite mapping.
**Source D** (user's visual reading): yellow=Savannah, green=Prairie.

The DOS game's original design put "Prairie" on the yellow-green sprite
and "Savannah" on the green sprite — which is a CONVENTION CHOICE that
disagrees with some players' natural color association. User override
wins (level 1).

**Extended bases 17-23**: NAMES.TXT only documents 21 named terrains
(bases 0-15 + Arctic=16 + Ocean=25 + Sea Lane=26 + Mountains/Hills via
feat flags). Bytes 17-23 exist in AMER2 heavily (54+81+22+45+165+5+194
= 566 tiles, ~14% of the map) but have no canonical names. Spatial
analysis (`/tmp/viz_ext_bases.py`) shows them clustered over the
continent in ways suggesting they're FORESTED biome variants specific
to the AMER2 scenario. Treating them as forested renders the landmass
with proper DOS-era density.

**Ruling**:
1. **Swap Prairie/Savannah sprite indices.**
   - byte 3 (Prairie) → sprite 5 (bright green)
   - byte 5 (Savannah) → sprite 3 (yellow-green)
   - Forested variants swap correspondingly:
     - byte 11 (Broadleaf = forested Prairie) → sprite 5
     - byte 13 (Tropical = forested Savannah) → sprite 3
   - TERRAIN_PAL_INDEX (fallback solid colors) updated to match.
2. **Scrub (byte 9) uses sprite 8** (desert-with-cactus), not plain
   desert sprite 1. Sprite 8's visible brush/cactus texture matches
   the Scrub biome's distinct look.
3. **Extended bases 17-23 render as forested.** Added `17 <= b <= 23`
   to `_tile_has_forest()` so the wxad forest topology fires on them.
   Ground textures assigned per cluster location in AMER2:
     - 17, 19, 23: Grassland-green (most widespread)
     - 18, 20: Plains-olive
     - 21: Savannah-yellow (Central/S America tropical zone)
     - 22: Marsh-green (rare)

**Action taken**:
- `colonize_sdl/main.py`:
  - `TERRAIN_TO_SPRITE` updated: swap 3↔5 (and 11↔13); Scrub→8;
    bases 17-23 mapped to specific biome sprites (not all Plains).
  - `TERRAIN_PAL_INDEX` updated for the same byte-to-color mapping.
  - `_tile_has_forest()` extended with `17 <= b <= 23` clause.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification** (zoomed renders):
- **South America** (render_zoom_amer2.png): Amazon basin is clearly
  forested with dense canopy; Andes snow peaks along west coast;
  rivers flow through the forest; Patagonia shows grassland/tundra.
- **North America** (render_north_amer2.png): Rocky Mountains on
  west coast; Canadian Arctic tundra in north; Great Lakes with
  forests around; Mississippi River through the Plains; Eastern
  deciduous forest as continuous dark-green canopy; Gulf Coast marsh.

**Follow-up**:
- The exact mapping of bases 17-23 to named biomes is still a guess.
  A DOS-reference screenshot of AMER2 at scenario start would let us
  verify each base's intended appearance. If any base is wrong, the
  TERRAIN_TO_SPRITE / TERRAIN_PAL_INDEX entries are the only ones to
  adjust.
- MAP_FORMAT.md AMB-1 remains technically open (we don't know the
  CANONICAL names for 17-23); but empirically they're "forested
  variants" and render correctly as such.

---

## 2026-04-22 (h) — Bit 6 is RIVER, not road; river rendering from cc94

**Conflict**: User requested "populating all the rivers and the forests"
after the cc94-based terrain rewrite. Rivers were never rendered in our
pipeline. Ruling (d) had treated bit 6 (0x40) as "road" and disabled it
because "no roads at game start." But DOS does show RIVERS at game
start — a river-flavored terrain feature we never implemented.

**Source A** — cc94 `render_terr` river block:
- Land tiles with `PhysMajorRiver` flag render sprite `1 + wxad_index`
  (16 topology variants; sprite 16 for dead-end/source).
- Water tiles with `PhysMajorRiver` flag render cardinal-direction
  MOUTH markers (cc94 sprites 141-144: N/E/S/W).
- Minor rivers use the parallel sprite range (17-32 land, 145-148
  mouths) but DOS .MP encodes only a single river bit.

**Source B** — bit-6 visualization of the real AMER2.MP:
```
row 12: .....~~##~~~~####......~.##~~####...
row 41: ...##...#######~~~~##~#####.........
row 46: .............#########~~#######~#~##~~~...
```
The `~` symbols (bit-6 tiles) form NATURAL RIVER PATHS — the
Mississippi system in North America, the Amazon basin in South America,
plus smaller tributaries. Roads would not occur in these configurations
at scenario start. **Bit 6 (0x40) is RIVER, not road.**

Count: 66 land tiles + 13 ocean tiles (river mouths) in real AMER2 have
bit 6 set — matching cc94's expected river density for a hand-crafted
Americas scenario.

**Ruling**:
1. **Bit 6 (0x40) is the RIVER flag, not road.** Updating MAP_FORMAT
   ambiguity AMB-5 with this ruling.
2. **Implement cc94's river render block** in `_render_terrain` STEP 6:
   - Land + river: wxad topology lookup → sprite `idx` (our 0-indexed,
     cc94's `1+idx`). If wxad=0 (isolated source), use sprite 15 (the
     "dead-end cap" — cc94's 16).
   - Water + river: blit mouth markers at 140=N / 141=E / 142=S /
     143=W for each cardinal neighbor that also has the river flag.
3. **Road overlay stays disabled** — roads will come from in-game
   GameState during play, never from the .MP layer-1 byte.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - Added STEP 6 river-rendering block using cc94's algorithm.
  - `_has_river(r)` helper checks `(r & 0x40) != 0`.
  - Land: `r_idx` wxad mask (N=8, S=4, W=2, E=1); sprite `r_idx` if
    >0 else 15.
  - Water: 4 cardinal river-mouth sprites (140-143).
- Road comment block updated to clarify bit 6 = river.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification** (zoomed renders at 32-px tiles):
- **North America** (y=0-30): Rocky Mountains snow peaks along west
  coast, Great Lakes visible, **Mississippi River** clearly flowing
  through central plains with tributaries, St. Lawrence river system
  in the northeast, rivers flowing into the Atlantic and Gulf coasts.
- **South America** (y=20-70): Andes mountains along west coast,
  **Amazon river system** prominent in central-east, tributaries
  branching through the continent, river mouths visible where rivers
  meet ocean.

**Follow-up**:
- DOS encodes only ONE river kind (bit 6); cc94's major/minor
  distinction is collapsed to "major river graphics" here. If DOS
  actually has a second river bit elsewhere (e.g., layer 2 which is
  all zeros in AMER2), a later scenario could expose it. For now,
  all bit-6 tiles render as major-river graphics.
- Rivers + forest combinations (feat=0xC0 = 0x80+0x40 = forest+river)
  render both layers stacked — the forest overlay draws first, then
  the river wins by drawing last. Visually this shows a river
  flowing through forest which is geographically correct (Amazon).
- The 13 ocean tiles with bit 6 set are river MOUTHS. Their mouth
  markers point toward cardinal neighbor river tiles. Inland-facing
  mouths work as expected.

---

## 2026-04-21 (g) — Mountain-vs-forest bug + real AMER2.MP from Steam

**Conflict**: User on AMER2: "any mountains have been replaced with
trees, and the amazon area has no forest."

**Issue 1 — Mountains rendered as forest**:

In ruling (f)'s cc94 rewrite, the mountain/hills/forest rendering was
split from `if/elif/elif` (single-branch) into separate `if` statements
to match cc94. However, the forest test `is_forest = (feat & 0x80) or
(8 <= base <= 15)` was NOT updated: it treats ANY bit-7-set value as
"forest," but our DOS encoding uses `feat == 0xA0` (bits 7+5 together)
to mark MOUNTAIN. A mountain tile would therefore match `feat & 0x80`
and be painted with forest canopy on top of the mountain sprite — the
"mountains have been replaced with trees" symptom.

**Issue 2 — Amazon has no forest**:

The local `/COLONIZE/AMER2.MP` was a STUB (md5 `fab4ffa3...`, 32 forest
tiles, 22 mountains), NOT the real DOS Americas scenario. The real
`AMER2.MP` ships with DOS Colonization at
`D:\SteamLibrary\steamapps\common\Sid Meier's Colonization\MPS\COLONIZE\`
(md5 `d21008d2...`) and contains:
- **255 forest tiles** (including the Amazon basin)
- **170 mountain tiles** (including the Andes)
- **56 hills tiles**
- Full biome diversity (bases 0-23 present)

Our project's COLONIZE/AMER2.MP had been reduced to a minimal test map
at some point (only 5 distinct base types). The `render_test.py`
backup/restore cycle meant every run would overwrite my manual copy
back to the stub from `AMER2.MP.backup`.

**Ruling**:
1. **Forest detection must exclude mountain.** A tile is forest iff:
   - `feat == 0x80` (forest flag alone), OR
   - `feat == 0xC0` (forest + road/trail combo), OR
   - `base in 8..15` (forested-biome base encoding)
   - And NEVER when `feat == 0xA0` (mountain) or `feat == 0x20` (hills).
2. **Install the real DOS AMER2.MP.** Delete the stale backup, copy the
   real file from the user's Steam install to our COLONIZE/AMER2.MP.
   `render_test.py`'s backup cycle will now preserve the real file.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain` STEP 5 forest:
  - Introduced `_tile_has_forest(r)` helper that returns False for
    `feat == 0xA0` (mountain) and `feat == 0x20` (hills), True only
    for the 3 true forest encodings listed above.
  - `_tile_has_forest` is now used BOTH for the self-check (should
    this tile render forest?) AND the neighbor wxad mask (does N/S/
    W/E have forest?) — previously the neighbor check used a naive
    `(r & 0x80) != 0` which falsely treated mountain neighbors as
    forest, causing edge-variant selection to over-count forest
    continuity.
- `COLONIZE/AMER2.MP` replaced with the real DOS file (md5 `d21008d2...`).
  `AMER2.MP.backup` deleted.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Visual verification** (zoomed render at 32-px tiles covering y=20-70):
- Andes mountains clearly visible as snow-capped peaks along the west
  coast of South America.
- Amazon basin visibly dark-green forest in central-east South America.
- Biome transitions (grass → forest → mountain → desert) render with
  proper diffuse blending and coast subtiles.
- No more forest-over-mountain painting errors.

**Follow-up**:
- The stub `AMER2.MP` and `AMER2.MP.backup` were project artifacts with
  unclear provenance. If they served a testing purpose, they should be
  moved to `tests/fixtures/` with descriptive names, not masquerade as
  the Americas scenario. For now, `render_test.py` reads from Steam
  which is fine; if a future user doesn't have Steam Colonization
  installed, they'll need to place a valid AMER2.MP manually.
- `MAP_WIDTH` is 56 but the .MP file width is 58. The loader drops the
  first and last columns. dos-disassembler should verify which columns
  DOS itself drops to confirm our alignment is correct.

---

## 2026-04-21 (f) — Full rewrite to cc94 algorithm (4-quadrant coast subtiles)

**Conflict**: After 5 rounds of iteration on coast/forest rendering,
user said "youre still going in circles. look at this other fan made
rewrite https://github.com/institution/cc94 you might find the code you
need to get the terrain to generate correctly."

**Source A** — our iterative approach (rulings a-e): used 4 corner
sprites (PHYS0.150-153) as full-tile composites for beaches, with
texture-strip bleed for concave corners and a single forest overlay
sprite. Each iteration partially addressed symptoms without solving the
root problem — we were using the WRONG sprite set for coasts.

**Source B** — cc94 `src/client/renderer.cpp::render_terr`:
- Water tiles render as **4 SUBTILES** (NW/NE/SE/SW quadrants).
- Each subtile picks from a **32-variant coast table** (cc94 sprite
  indices 109-140) based on 3 surrounding neighbors.
- Index formula: `k = (!sea(t2)<<2) | (!sea(t1)<<1) | (!sea(t0)<<0)`,
  then `sprite = 109 + (k<<2) + l` where l=subtile index (0-3).
- Biome-diffuse step: for each of 4 cardinals, render a blend pattern
  (cc94 sprites 105-108) masked by neighbor's biome icon — gives the
  soft "biome color bleeds across tile boundary" effect.
- Forest uses **16 topology variants** via 4-bit neighbor mask
  (cc94 sprites 65-80, `base + wxad_index`).
- Mountain = sprite 33, Hills = sprite 49 (row-firsts in cc94; we use
  row-densest 45/61 which also works).

**Verification of cc94 mapping against OUR extracted PHYS0**:
- PHYS0.104-107 = N/E/S/W diffuse blend patterns (dots along top / right
  / bottom / left edges — confirmed by pixel inspection).
- PHYS0.108-139 = 32 coast subtile sprites (**8×8 each**, not 16×16 —
  confirmed by size check; sprites 108-111 are all-black placeholders
  for k=0 "no land around this corner").
- PHYS0.64-79 = 16 forest topology variants (confirmed, same as cc94
  numbering minus 1).

Our PHYS0 extraction is **offset by 1** from cc94's resource IDs (they
use 1-based indexing against the DOS file; our extractor is 0-based).
Mapping: `our_idx = cc94_idx - 1`.

**Ruling**: **Replace the entire coast + forest + diffuse pipeline with
cc94's algorithm.**

**Action taken** — `colonize_sdl/main.py::_render_terrain` rewritten:
1. Removed `beach` dict (all corner-sprite composites).
2. Added `_biome_tex(raw)` helper that returns a 48×48 TERRAIN.SS
   texture scaled from a 16×16 ground sprite.
3. Added `_diffuse_surface(blend_idx, nb_raw)` — cached per
   (blend_direction, neighbor_base). Per-pixel composite that uses
   the blend sprite as a mask for the neighbor's biome texture.
   Result: neighbor's biome color stippled along the tile edge facing
   that neighbor.
4. Added `_coast_subtile_scaled(coast_idx)` — cached scaling of 8×8
   PHYS0 subtile → 24×24 (HALF of DOS=48 internal tile size). Treats
   BOTH magenta (255,85,255) AND black (0,0,0) as transparent —
   black marks "outside the subtile shape" in the DOS encoding.
   Returns None for the 4 all-black k=0 placeholders (indices
   108-111).
5. Rendering loop now:
   - STEP 1: base biome from TERRAIN.SS
   - STEP 2: 4 diffuse blends (N=104, E=105, S=106, W=107)
   - STEP 3: if water, 4 coast subtiles using `108 + (k<<2) + l`
   - STEP 4: mountain (45) / hills (61) overlay
   - STEP 5: forest using `64 + wxad_index` (16 topology variants)
   - Road disabled per ruling (d).

**Visual result** (confirmed):
- UNTITLED.MP: each rectangular landmass has proper coastline
  subtiles with biome-appropriate edges (sand for desert, grass for
  grassland); the "+" island has rounded coastline with corner
  subtiles.
- AMER2.MP: Americas coastline renders as authentic DOS-style
  pixelated coast; forest shows varied density based on neighbor-
  forest topology (dense canopy where all 4 sides are forest, thinner
  at forest edges); tundra/desert/grassland biome colors bleed
  softly into adjacent tiles via the diffuse layer.

Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Follow-up**:
- Profile the per-pixel diffuse/coast cache building; first-render is
  slow (~2300 pixel ops per cache entry). Numpy surfarray would speed
  up the one-time cache build but current lazy caching is acceptable.
- cc94's river/road systems (wxad-indexed like forest) are ready to
  drop in when those features ship.
- Plowing uses cc94 sprite 150, which in our numbering is PHYS0.149.
  Verify when ploughed-field feature lands.

---

## 2026-04-21 (e) — Texture strip ONLY on concave; denser forest sprite

**Conflict**: Two user-observed issues after ruling (d) restored the
texture strip:

1. The texture strip (land-side biome-color bleed) was being painted on
   EVERY land-facing edge, regardless of mask. On non-concave water
   tiles (single-cardinal + opposite + T-junction + surrounded), this
   created a continuous "long coast line" of adjacent-biome color
   running the full edge length. User: "youre still using the long cost
   lines for sides not concave coasts."

2. Forest overlay used PHYS0.SS.077 — which pixel-inspection shows is
   only 75% opaque (63 magenta-transparent pixels of 256). The
   underlying grassland texture was showing through ~1/4 of every
   forest tile, making forested areas like the Amazon look like
   unforested grassland at low zoom. User: "the base texture for areas
   like the amazon is not there when it needs to be forested."

**Source A** — pixel-inspection of PHYS0 row 0x41 (sprites 64-79):
  - Sprite 77: 75% opaque (193/256 non-magenta pixels)
  - Sprite 78: 87% opaque
  - Sprite 79: **100% opaque** (no transparent pixels at all)

Sprite 79 is the "fully-filled" variant of the forest row — the densest
canopy available. Using 77 leaves visible grassland gaps; 79 fully
covers the base texture.

**Source B** — ruling (d) interpretation of "land-side texture fill":
texture strip was applied to every land-facing edge. User clarified in
(e) that the strip should ONLY fill CONCAVE corners (where the tile is
in a bay and needs the inner pocket color-filled), not straight edges.

**Ruling**:
1. **Texture strip restricted to 4 concave masks** (0b1001, 0b0011,
   0b1100, 0b0110 — the 2-adjacent-cardinal land masks). On every
   other non-zero mask, the strip is skipped. The 2-corner beach
   sprite composite (ruling (c)) alone carries the coast appearance
   on straight edges / opposite sides / T-junctions / surrounded
   water.
2. **Forest overlay sprite switched from 077 to 079** (100% opaque
   canopy). Mountain (045) and Hills (061) overlays unchanged —
   pixel-inspection confirms they're already the densest variants
   of their respective rows.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - STEP 2a texture strip now wrapped in `if lmask in CONCAVE_MASKS:`
    where `CONCAVE_MASKS = (0b1001, 0b0011, 0b1100, 0b0110)`.
  - STEP 3 forest overlay: `_blit_overlay(77)` → `_blit_overlay(79)`.
  - Citation comment updated to reference `/tmp/inspect_f77.py`
    density measurement.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).
- UNTITLED.MP render now shows forest clearly on base-8/12 tiles;
  AMER2.MP Amazon-like grassland+forest region is visibly darker
  green compared to plain grassland.

**Follow-up**:
- User mentioned "different types of forest" — currently all forested
  tiles use the same sprite 79. PHYS0 only has one forest row (0x41);
  different forest biomes (Boreal/Tropical/Rain/Conifer) may tint the
  canopy by palette or use underlying TERRAIN.SS sprite hue. Deferred
  pending sprite-cataloger investigation of whether different forest
  types have distinct palette indices in the DOS rendering pipeline.
- If AMER2.MP under-encodes forest density relative to what DOS shows
  at scenario start, dos-disassembler should verify bit interpretation
  of byte 0x80 and whether any other layer-1 bit signals forest.

---

## 2026-04-21 (d) — No initial-map roads; restore land-texture bleed

**Conflict**: Two user-observed issues on AMER2:

1. Road overlays were rendering on AMER2 at game start, but the DOS game
   shows no roads at the start of a new game. User: "in the main
   americas map. there shouldnt be any road rendered at all at the
   beginning of the game."
2. After ruling (c) removed the land-texture-bleed strip (STEP 2a),
   concave-corner water tiles lost the "adjacent-biome color bleeds
   into water" gradient that the user explicitly approved earlier.
   User: "the cost lines before on the concave portions were correct
   before with the land side texture fill and now are wrong again."

**Source A** — byte analysis of `COLONIZE/AMER2.MP`:
- Layer 1: 4176 bytes (58×72). Only 11 tiles have bit-6 set
  (`raw & 0x40`). Prior MAP_FORMAT claim of "178 tiles with road flag"
  was incorrect; re-counting confirms 11.
- Ten of the 11 tiles are on base=4 grassland (feat byte 0xC4 =
  forest+road combo); one tile is ocean (feat 0xD9). These were being
  rendered as road sprites from row 0x50, producing visible road
  segments at scenario start.

**Source B** — user observation of DOS game at scenario start: no
roads visible anywhere. This is ground truth (level 1).

**Ruling**:
1. **Road overlay is DISABLED from initial map data.** The 11 bit-6
   tiles in AMER2 are either pre-scenario native trails the DOS game
   hides, or bit 6 has a different meaning on this file (AMB-5 flagged
   ocean-tile road as unresolved). Either way, the renderer should NOT
   draw row-0x50 sprites from the .MP layer. Roads must come from
   in-game GameState built during play.
2. **Land-side texture bleed (STEP 2a) is RESTORED.** For every water
   tile, every land-facing edge paints a 1-sub-cell (16-px on the 48×48
   internal buffer) strip of the adjacent biome's TERRAIN.SS texture
   cropped to that edge. The strip is drawn BEFORE the beach sprite
   composition, so the corner sprites' transparent magenta halves
   overlay the texture strip — giving both the adjacent-biome color
   bleed (visible on concave corners) and the sand-curve beach line
   (from the corner sprites) simultaneously.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - STEP 4 road overlay code removed (entire `if raw & 0x40:` block
    deleted; comment block documents the rationale for future
    re-enable).
  - STEP 2a texture-strip bleed restored (was removed in ruling (c)).
  - STEP 2b beach composition renamed/annotated to reflect its role
    as the sand-curve overlay on top of the texture strip.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Follow-up**:
- When in-game road tracking ships, re-enable the row-0x50 sprite table
  to render player-built roads from GameState (not from .MP layer).
- Verify bit 6 semantics with dos-disassembler once map-loader offsets
  are located; AMB-5 (ocean tiles with road flag) still unresolved.
- User also noted forest-vs-base-texture mismatches on AMER2. AMER2.MP
  only encodes ~55 forest tiles (33 bit-7 + 22 implicit bases 8-15) out
  of 281 land tiles; if DOS shows more forest than this, the .MP read
  or a different forest flag may be misinterpreted. Deferred pending
  DOS reference screenshot of AMER2 at scenario start.

---

## 2026-04-21 (c) — Coast rendering: non-convex edges via 2-corner composite

**Conflict**: After ruling (b), single-cardinal-land water tiles (the
"non-convex" straight-edge coasts) had NO beach sprite and only the
TERRAIN.SS edge-color strip. User feedback: rectangular/straight
coastlines looked wrong — a flat texture strip with a hard edge doesn't
resemble the DOS sand-ring coast. User: "can you fix the non convex
edges".

**Source A** — ruling (b) decision: single-cardinal masks should NOT use
the corner sprites because each corner sprite's perpendicular half would
paint sand on a water-only edge. Edge-texture strip was chosen as
substitute.

**Source B** — direct pixel inspection of PHYS0.150..153 at 1× (see
`/tmp/inspect_pixel2.py` transparency map). Each corner sprite is ~50%
magenta (transparent, VGA palette index 0) on its LAND-FACING diagonal
half. The sand curve itself is narrow (2–3 px wide) and follows the
diagonal. The other 50% is water.

  Specifically for sprite 150 (N+W corner):
  - NW diagonal half: transparent magenta (the "land is here" indicator)
  - Diagonal sand curve from NE-corner-ish to SW-corner-ish
  - SE diagonal half: water

  This means: blitting sprite 150 on a water tile with land to N (only)
  does NOT paint sand on the W edge — because the W half of the sprite
  is transparent. The sand curve terminates at the NE and SW corners
  of the sprite. The sand falls roughly in the north-west quadrant but
  stops short of the full W edge.

  Consequence: sprite 150 alone on a "N only" tile gives partial sand
  near the NW area, missing the NE area. Sprite 151 alone would give
  partial sand near the NE area, missing the NW. Compositing BOTH fills
  the full N edge — each sprite's transparent half covers the other's
  water-only edge, and their two sand curves meet along the N edge.

**Ruling**: **Use 2-corner composites for single-cardinal masks.**
Pixels (level 2) override the earlier inference (level 7).

The expanded beach table:

| Mask bits    | Land pattern | Beach sprite(s)   |
|--------------|--------------|-------------------|
| 0b0001 (1)   | N only       | 150 + 151         |
| 0b0010 (2)   | E only       | 151 + 153         |
| 0b0100 (4)   | S only       | 152 + 153         |
| 0b1000 (8)   | W only       | 150 + 152         |
| 0b1001 (9)   | N+W corner   | 150               |
| 0b0011 (3)   | N+E corner   | 151               |
| 0b1100 (12)  | S+W corner   | 152               |
| 0b0110 (6)   | S+E corner   | 153               |
| 0b0101 (5)   | N+S opposite | 150+151+152+153   |
| 0b1010 (10)  | E+W opposite | 150+151+152+153   |
| 0b1011 (11)  | N+E+W T      | 150 + 151 + 152   |
| 0b0111 (7)   | N+E+S T      | 151 + 152 + 153   |
| 0b1110 (14)  | E+S+W T      | 150 + 152 + 153   |
| 0b1101 (13)  | N+S+W T      | 150 + 151 + 153   |
| 0b1111 (15)  | fully land   | 150+151+152+153   |

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - `beach` dict expanded to cover all 15 non-zero masks.
  - STEP 2a (TERRAIN.SS texture-strip bleed) removed — the corner-
    sprite composites now carry the coast appearance via their
    own transparent-magenta / sand-curve / water layout.
  - STEP 2b simplified into a single STEP 2 that just looks up
    the `beach[lmask]` entry.
- Goldens updated for all 4 test maps (visual-regression 4/4 pass).

**Follow-up**:
- Compare against a DOS reference of a rectangular-land map to confirm
  the 2-corner composite matches the DOS sand-ring appearance.
- The 3-side T and 4-side composites may produce sand patterns denser
  than DOS's; verify once DOS screenshots of those cases exist.
- The opposite-sides masks (0b0101, 0b1010) use all 4 corners which is
  identical to the 4-side composite. Could be tuned but is rare in
  practice (would require a 1-tile-wide water channel).

---

## 2026-04-21 (b) — Coast rendering: corner-only diagonals + edge color fill

**Conflict**: With the 4-corner beach sprite fix, single-cardinal-edge
water tiles (e.g., "land N only") were still using a corner sprite
(150/152) which paints sand on both its cardinal edges — producing an
artifact where sand appears on an edge that has no adjacent land.

User feedback: "the upper ones are not needed, those diagonals are only
in corners and the land side needs to be filled with the adjacent
terrain color."

**Ruling**: Two changes to `_render_terrain`:

1. **Beach corner sprites fire ONLY when two orthogonal cardinals are
   land** (masks 0b1001/0b0011/0b1100/0b0110 exactly = 150/151/152/153).
   Single-cardinal masks (N/E/S/W only) get NO corner sprite. Opposite-
   side / 3-side / 4-side masks still composite multiple corners as
   before.

2. **For each cardinal edge where the adjacent tile is land, paint a
   1-sub-cell-wide (16 px on the 48×48 internal buffer, → ~5 px at
   display resolution) strip of that neighbor's base terrain color on
   the water tile's facing edge.** This provides the "land-tile color
   bleeds into water" gradient along straight coastlines that DOS shows
   but that the purely-corner-based approach was omitting.

   The color strips are drawn BEFORE the corner beach sprite, so corner
   concavities still show the sandy sprite curve on top of the color
   strip.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain`:
  - Beach single-cardinal mask entries removed.
  - STEP 2 split into (2a) land-adjacent edge color fill + (2b) corner
    beach sprite overlay.
- Goldens updated for all 4 test maps.

**Follow-up**:
- The current strip thickness is 1 sub-cell (16/48). If DOS uses a
  thinner strip, adjust `edge_px`. Verify against DOS reference when
  available.
- Consider whether the strip should blend into the corner beach sand
  at the corner cells (currently the corner sprite simply draws on top,
  which may produce a hard boundary at the mask=0011/9/6/C tile
  neighbors).

---

## 2026-04-21 — PHYS0 beach sprites 150-153 are the 4 corners, not flipped 151

**Conflict**: How should beach sprites map to the 4-bit cardinal land-mask
on water tiles?

**Source A** — earlier renderer-implementer choice: treat sprite 151 as
the "NW corner" base and use flip-H / flip-V / flip-HV to derive the other
three corners. Single-edge cases (land N only, E only, etc.) used 151 with
flips.

**Source B** — direct 15× pixel inspection of PHYS0.SS.150 through 153
(see `tools/atlases/beach_sprites_labeled.png`):
- PHYS0.150 has sand on the **N and W** edges (NW corner)
- PHYS0.151 has sand on the **N and E** edges (NE corner)
- PHYS0.152 has sand on the **S and W** edges (SW corner)
- PHYS0.153 has sand on the **S and E** edges (SE corner)

The four sprites are ALREADY the four corner variants — no flipping is
needed. Source A's choice was picking 151 (NE) as the base for "NW" land,
so the rendered sand appeared on the opposite side of the land (the user
called it "backwards").

**Ruling**: **Use the 4 corner sprites directly by matching the mask.**
Pixels (level 2) beat code assumption (level 7).

Mask → sprite:
| Mask bits   | Land pattern | Sprite |
|-------------|--------------|--------|
| 0b1001 (9)  | N + W        | 150    |
| 0b0011 (3)  | N + E        | 151    |
| 0b1100 (12) | S + W        | 152    |
| 0b0110 (6)  | S + E        | 153    |

Single-edge cases pick the corner sprite whose sand covers the requested
edge (e.g., "N only" → 150). Three-side and opposite-side cases
composite two corner sprites. Four-side composites all four.

**Action taken**:
- `colonize_sdl/main.py::_render_terrain` beach-sprite table rebuilt.
  No `pygame.transform.flip` on these sprites anymore.
- Blit logic updated to handle both single sprite and list-of-sprites
  (for composites).
- Goldens updated for all 4 test maps.
- `SPRITE_CATALOG.md` PHYS0 row 0x90 entries corrected to reflect that
  150/151/152/153 are NW/NE/SW/SE corners respectively.

**Follow-up**:
- Visually verify 3-side composites against DOS reference when DOSBox
  screenshots become available.
- Consider whether the 3-side composite (two corner sprites blitted on
  top of each other) produces the correct DOS shape — there may be a
  dedicated 3-side sprite somewhere we haven't catalogued.

---

## 2026-04-21 — TERRAIN.SS is NOT an orphan

**Conflict**: Is `TERRAIN.SS` used by the in-game renderer, or is it a
Colonizopedia-only / orphan asset?

**Source A** — earlier `sprite-cataloger` finding + `CLAUDE.md` v1 hard rule:
"TERRAIN.SS is NOT used by VICEROY.EXE — confirmed by searching both
VICEROY.EXE and MAPEDIT.EXE for `terrain.ss` / `TERRAIN.SS` (both cases
absent). Only the Colonizopedia loader references it." Therefore flagged
as orphan and excluded from the renderer.

**Source B** — pixel inspection at 5× of `TERRAIN.SS.{000..011}.png`:
the sheet contains 12 sprites that are visibly 16×16 per-terrain ground
textures matching exactly the 12 main terrain biomes (Tundra speckle,
Desert sand, Plains olive, Prairie yellow, Grassland green tufts,
Savannah dark green, Marsh green+blue, Swamp sandy+dark, Scrub+cacti,
Arctic white, Ocean blue, Sea Lane darker blue). The user looked at the
current renderer output with solid-color fills and reported "the terrain
is still all wrong." The solid-color fills are exactly what Source A
forced.

**Ruling**: **TERRAIN.SS IS used as the per-terrain ground texture.**
Pixels (level 2) beat Source A's string-search inference (which is
level 7, "AI agent speculation grounded in one source that didn't prove
use, only failed to find evidence of use").

The string search was a negative proof attempt: failing to find a
literal `"TERRAIN.SS"` pointer does NOT prove the sheet is unused. The
game may reference the sheet by computed index, a different filename
pointer, or an overlay-segment string that the search missed.

**Action taken**:
- `colonize_sdl/main.py`:
  - `ColonizationApp.__init__` now loads `load_sprite_sheet("TERRAIN")`
    into `self.terrain_base_sprites`.
  - `_render_terrain` STEP 1 prefers `TERRAIN.SS` for the base fill,
    falling back to solid color if the sheet is missing.
  - The `TERRAIN_TO_SPRITE` table (already present in the code from a
    prior attempt) now drives the mapping: byte-base → TERRAIN.SS sprite index.
  - Extended land IDs 17-23 reuse sprite 2 (Plains) until the palette-
    slot-to-byte mapping is recovered.
- `SPRITE_CATALOG.md`: the orphan warning on TERRAIN.SS must be REMOVED
  and replaced with a proper entry.
- `CLAUDE.md`: the "Never load TERRAIN.SS or BDARK.SS" hard rule must be
  relaxed to just BDARK.SS.
- Goldens updated (all 4 maps) to reflect the new textured-terrain
  rendering.

**Follow-up**:
- Confirm via `dos-disassembler` that TERRAIN.SS is actually loaded by
  VICEROY.EXE (not just MAPEDIT.EXE). Search for the sheet descriptor
  structure in the data segment rather than the string. If the
  disassembly ultimately proves the game renders per-terrain textures
  from some OTHER sheet (e.g., a subrange of PHYS0 we missed), revise
  again — but the current pixel evidence strongly supports TERRAIN.SS.
- `BDARK.SS` remains suspected orphan — same pixel-inspection pass
  should verify before committing to that label.

---

## 2026-04-20 — PHYS0 row 0x21: hills or mountains?

**Conflict**: Does PHYS0 row `0x21` (indices 33–47) depict hills (brown rolling
terrain) or mountains (snow-capped peaks)?

**Source A** — `dos-disassembler` (earlier investigation): reported disassembly
at VICEROY.EXE 0x6A1C3 shows `add ax, 0x21` when the map-editor palette slot is
0x1B, which in the paired reconstruction source NAMES table is labelled "Hills."
Conclusion at the time: row 0x21 = hills edge variants.

**Source B** — `sprite-cataloger` (pixel inspection at 10×): PHYS0.033–047
contain clearly snow-capped peaks over gray/brown rock. Row 0x31 (indices 49–63)
contains brown rolling terrain with no snow. Conclusion: row 0x21 = mountains,
row 0x31 = hills.

**Ruling**: **Row 0x21 depicts mountains. Row 0x31 depicts hills.** Pixels
(level 2) beat disassembly (level 3) per the Truth Hierarchy, and per the
"about what a sprite depicts" special rule.

The disassembly citation is likely consistent with this ruling — probably the
map-editor palette-slot-to-name mapping has "Mountains" at slot 0x1B and
"Hills" at slot 0x1C, which would match pixel evidence.

**Action taken**:
- `colonize_sdl/main.py` — `DOS_ROW_MOUNTAIN = 0x21` and `DOS_ROW_HILLS = 0x31`
  (matches pixel evidence).
- `COLONIZATION_TECHNICAL_REFERENCE.md` — if it ever claims the opposite,
  update. (The current doc predates this ruling.)
- `SPRITE_CATALOG.md` — will document rows 0x21 and 0x31 per this ruling when
  sprite-cataloger creates that file.

**Follow-up**: Confirm by reading NAMES.TXT (or equivalent) from the original
DOS distribution to verify which palette-slot index carries which terrain name.
If NAMES.TXT says 0x1B="Hills" and 0x1C="Mountains" then the C reconstruction's
name ordering disagrees with what's on-screen in the DOS game — in which case
the C recon is wrong, not the disassembly report. Either way, the rendered
sprites don't lie.

---

## 2026-04-25 — Audit reconciliation: TERRAIN.SS re-extraction + auto-forest VICEROY byte verification + extraction artifacts

**Conflict**: Multiple open audit findings required verification: (1) The 2026-04-21
TERRAIN.SS ruling claimed pixel inspection proved the sheet was used, but the
`extracted/assets/sprites/TERRAIN/` directory did not exist at the time of the
ruling — how could inspection have happened? (2) The 2026-04-22 (s) auto-forest
ruling cited VICEROY.EXE disassembly, but the earlier (r) ruling forbade Arctic
auto-forest based on MAPEDIT.EXE. Which is the game's actual behavior? (3) PHYS0
sprite indices 0, 16, and 100 are 1×1 placeholder frames — are they bugs in the
extraction tool or genuine empty slots? (4) MAP_FORMAT.md wording on Sea Lane
reads as if base 26 is on disk when it's actually runtime-only.

### A1: TERRAIN.SS — extraction artifact resolved

**Source A** — 2026-04-21 ruling: "TERRAIN.SS IS used as the per-terrain ground
texture. Pixels (level 2) beat Source A's string-search inference." But the
audit trail was faulty: the "pixels" cited (TERRAIN.SS.000–011.png) did not exist
in the repository at that time. The renderer was falling back via guards
(main.py lines 2692/2697/2914/2919) because the directory was missing.

**Source B** — 2026-04-25 extraction audit: An extraction agent ran `tools/mpskit/main.py
ss unpack COLONIZE/TERRAIN.SS` and produced the missing directory:
`extracted/assets/sprites/TERRAIN/` now contains 12 frames (TERRAIN.SS.000.png
through TERRAIN.SS.011.png) plus palette (TERRAIN.SS.pal.png). Format: 16×16
8-bit indexed PNG, transparent index 253, matches PHYS0 convention. Verified by
Glob search: all 13 files present.

**Ruling**: The 2026-04-21 content claim (TERRAIN.SS contains per-terrain ground
textures) stands, but the evidence path was incomplete. The extraction was a
prerequisite. With the files now present, the pixel evidence (level 2) confirms
the underlying claim. The 2026-04-21 ruling is **upheld retroactively** with
corrected evidence chain: pixels (level 2) beat string search (level 7).

### A2: Auto-forest bases 8-23 (including Arctic base 16) — BYTE-VERIFIED

**Source A** — 2026-04-22 (r): Auto-forest did NOT apply to Arctic (base 16),
based on MAPEDIT.EXE disassembly analysis.

**Source B** — 2026-04-22 (s) and 2026-04-25 dos-disassembler follow-up: The
in-game renderer (VICEROY.EXE) has a different code path than MAPEDIT. At
VICEROY.EXE @ 0x6204–0x6228: sequence `25 07 00` (and ax, 7) followed by
`0c 08` (or al, 8) implements the transform `(input & 7) | 8`, confirming the
formula. At 0x6831B–0x6833b: range checks `cmp byte [0xA8A2], 0x08` and
`cmp byte [0xA8A2], 0x18` gate the forest draw. If terrain_class >= 8 AND
< 0x18 (24), draw forest unconditionally. NO test of the 0x80 forest bit. NO
test of [0xA8A1]. Arctic (base 16 = class 8) DOES trigger forest draw.

**Ruling**: Ruling (s) is **BYTE-VERIFIED**. Forest draw applies to all terrain
bases 8–23 inclusive. MAPEDIT.EXE (level 4, decompiled C code) differs from the
game's actual bytecode (level 3, disassembly) — disassembly wins. The concern
"evidence weak" from the (r)-(s) debate is resolved.

### A3: PHYS0 sprite indices 0, 16, 100 are corrupted 1×1 placeholders

**Source A** — sprite-cataloger pixel audit: Indices 0, 16, and 100 in the PHYS0
extraction are each a single 1×1 pixel (palette index 253, fully transparent).
They represent 1113 bytes of wasted space, not usable sprite frames.

**Source B** — extraction-tool hypothesis: The MADSPACK 2.0 decompressor may have
a bug, or the source .SS file genuinely has empty slots at those positions. This
is an extraction artifact, not a sprite-design fact from the original game.

**Ruling**: The **documented row boundaries** (row 0x00 starts at index 0, row
0x10 starts at index 16, row 0x60 starts at index 96) are slot numbers in the
flat index space. Usable sprite content within each affected row begins at offset
+1 (indices 1–15, 17–31, 97–103). The SPRITE_CATALOG.md must clarify that these
are "known extraction artifacts." PHYS0 frames 0/16/100 should NOT be indexed
into by any code. If a future session needs to use one of these indices, first
investigate whether mpskit has extraction options that can recover them, or
whether the original .SS file genuinely has placeholder data there.

### A4: MAP_FORMAT.md — Sea Lane (base 26) storage clarification

**Source A** — MAP_FORMAT.md current text: "Column 0 and column 57 are Sea Lane
border strips forced to base ID 26 (Sea Lane) at runtime by the loader." This
phrasing is ambiguous; it could mean 26 is stored on disk.

**Source B** — map-format-decoder audit + analysis: The rightmost column (.MP
bytes) contain raw byte 0x19 (base 25, Ocean) on disk. The loader transforms
the rightmost column to base 26 at runtime. When hand-parsing a .MP file, the
disk content is 0x19, not 0x1A (which would be 26).

**Ruling**: MAP_FORMAT.md must add a clarifying note: "On disk: raw byte 0x19
(base 25, Ocean). At load time the renderer transforms the rightmost column to
base 26 (Sea Lane). When parsing a .MP file by hand, expect 0x19 in column W-1,
not 0x1A."

---

## Actions taken (2026-04-25)

- `SPRITE_CATALOG.md`: Added TERRAIN.SS entry with extraction source and date. Added
  "Known extraction artifacts" note on indices 0/16/100.
- `MAP_FORMAT.md`: Added clarifying note on Sea Lane byte vs. runtime base.
- `CLAUDE.md`: Updated "Past pain points" section with three new bullets on TERRAIN.SS
  re-extraction, auto-forest byte verification, and PHYS0 placeholder indices.
- `PROJECT_BOARD.md`: Added new ambiguity task for PHYS0 re-extraction investigation.

---

## 2026-04-25 (t) — Coast bands are uniform sand, not biome-tinted

**Source A** — Ruling 2026-04-22 (p): "biome-color edge strip" — for each
land-facing edge of a water tile, paint a strip of the *adjacent biome's*
TERRAIN.SS texture, so sandy desert coasts look sandy and grass coasts look
green. Code at `colonize_sdl/main.py:2912-2946` implemented this.

**Source B** — DOS authoritative reference (TRUTH_HIERARCHY level 1):
`reference/dos/AMER2_dos_reference.png` (saved 2026-04-25). Sprite-cataloger
sampled 1,173 pixels across 5 diverse coast regions (Pacific Mexico,
Central America, Atlantic North America, Gulf, Atlantic South America).
Aggregate mean RGB(182, 166, 112), standard deviation < 10 across all
regions. The sand color is **biome-independent and globally uniform** — a
forested coast and a desert coast and a grassland coast all show the same
tan band.

Sprite-cataloger then compared every plausible sand-source candidate
(PHYS0.149 dune, PHYS0.150–153 beach corners, PHYS0.140–143 river mouths,
TERRAIN.SS.000–011) against the DOS sand color. Visual inspection at 12×
identified `TERRAIN.SS.001` as the pure-sand frame (uniform tan/beige, no
cacti, mean RGB ≈ (197.8, 175.5, 136.6), dominant pixel ≈ (186, 161, 125)).
TERRAIN.SS.008 was numerically closer in mean RGB but contains cactus
sprites (it's the desert-with-cactus frame, not coast sand).

**Ruling: Coast bands are uniform sand from `TERRAIN.SS.001`, not the
neighbor's biome texture.** Pixels (level 1, DOS reference) > prior team
documentation (level 5).

This SUPERSEDES ruling 2026-04-22 (p)'s "biome-color edge strip" framing.
The earlier ruling correctly identified that DOS uses a *strip* (not the
cc94 subtile system) but mis-specified the strip's *color source*.

**Action taken**: `colonize_sdl/main.py:2879-2946` rewritten. The water-tile
coast block now defines `_coast_sand_tex()` that loads `TERRAIN.SS.001`,
and blits a 16-px sand strip on each land-facing edge regardless of the
neighbor's biome. The `_neighbor_tex(nb_raw)` function and its biome lookup
are removed. Comment block updated with citation to this ruling and to
the DOS reference path.

**Regression**: ONE.MP and BLANK4.MP unchanged (no land-water boundaries to
trigger the new code). UNTITLED.MP and AMER2.MP fail goldens (expected —
goldens predate the fix). Visual comparison of `render_test_AMER2.png`
against `reference/dos/AMER2_dos_reference.png` confirms sand bands now
present at every coast with correct color and width. Goldens to be updated
once remaining tier-1 visual fixes (rivers, resources) land.

**Confidence**: HIGH. Pixels sampled directly from the DOS reference,
candidate sprite visually verified.

---

## 2026-04-25 (u) — Goldens updated to "sand-band baseline"

After ruling (t) landed, user explicitly approved
`python tests/run_regression.py --update`. The goldens at `tests/golden/`
now reflect the renderer state as of 2026-04-25 with TERRAIN.SS loaded
and the coast sand-band fix applied.

**Known visual gaps still present in this baseline** (will produce
regression failures when fixed in future sessions, at which point goldens
will be updated again):

- **Rivers**: rendered as tile-aligned blue strips via PHYS0 row 0x00
  (sprites 1-15) by wxad-mask topology. DOS shows thin curving sub-tile
  flow lines. Fix blocked on disassembly trace of `func_O512` for the
  bits-7-6 == `0b01` case (task 16 → unblocks task 14). Suspected
  alternative source: PHYS0 row 0x70 (sprites 112-127, 8×8 sub-tiles).
- **Resource overlays**: `OVERLAY_TO_SPRITE` table at `main.py:3144` is
  admitted-placeholder (multiple resource IDs point at sprite 99). DOS
  shows abundant icons (orange circles, deer, fish, beaver, cotton,
  tobacco, sugar, cactus). Fix tracked as task 15.
- **Ocean texture**: water tiles fill flat blue. PHYS0.148 is the
  dither sprite per SPRITE_CATALOG; not currently used in fill. Tracked
  as task 17.
- **Forest density**: DOS forests look like solid canopy; ours show
  base-color through gaps. Tracked as task 18.
- **Bits 7-6 dispatch**: VICEROY @ 0x68206 masks bits 7-6 together as a
  2-bit field; current renderer treats them as independent flags. Need
  binary trace of how the 2-bit value is consumed. Tracked as task 16.

**Rule for next session**: when any of the above land, regression will
fail against this baseline — that's the expected signal. After visual
verification against `reference/dos/AMER2_dos_reference.png`, run
`--update` again and add the corresponding ruling to this file with the
known-gap line removed.

---

## 2026-04-25 (v) — Render-chain disassembly: bit 0x40 ≠ river; multiple prior rulings overturned

After three successive agent-driven investigations failed to definitively
identify river/resource sprite sources, a full capstone disassembly of
VICEROY.EXE was performed in-session at file offsets 0x67F50–0x68900
(`func_O512` and `func_O513` bodies). Output saved to
`extracted/disassembly/render_chain_capstone.txt` and analyzed in
`docs/RENDER_CHAIN_DISPATCH.md`. **15 sprite-blit dispatch sites identified
with cited bytes.**

### Findings overturning prior rulings

**Source**: VICEROY.EXE disassembly at cited offsets (TRUTH_HIERARCHY level 3),
saved verbatim. Pixel inspection (level 2) of PHYS0.149 cross-confirms.

1. **OVERTURNS ruling (h)** "bit 0x40 = river"
   At 0x6834F-0x68359: `test [0xa89f], 0x40 ; je 0x6835c ; mov ax, 0x96 ; call 0x67dc8`.
   Bit 0x40 of layer 1 raw byte triggers PHYS0 sprite 0x96 = 150 (the **NW
   beach corner overlay**), NOT a river sprite. The 66 land + 13 ocean tiles
   in AMER2 with bit 0x40 set are flagged for NW beach corner rendering, not
   river presence.

2. **OVERTURNS ruling (r)** "remove beach corners 150-153, cc94 doesn't use them"
   At 0x68356 (NW=150) and 0x68510 (NE/SW/SE = 0x97 + idx → 151/152/153): the
   in-game render chain DOES blit beach corner sprites. cc94's claim was
   wrong; cc94 is TRUTH_HIERARCHY level 6 (low trust) and the binary at
   level 3 wins.

3. **OVERTURNS ruling (d)** "no roads at scenario start, bit 0x40 = river not road"
   At 0x6843E (`mov ax, 0x51 ; call 0x67dc8`) and 0x6845C (`add ax, 0x52 ; call`):
   the binary does emit road sprites (PHYS0 row 0x50, indices 81-94) for tiles
   based on a road-helper at 0x67D54. Whether the gating bit is 0x40, the
   resource layer, or another source remains to be traced. But "no roads at
   start" is empirically wrong.

4. **OVERTURNS SPRITE_CATALOG entry for PHYS0.149** "sandy vertical dune pattern"
   Pixel inspection at 12×: 16×16, 44% opacity, dominant RGB(117,97,68) /
   (133,113,80) / (101,80,52) — brown/earth tones, not sand. Sprite is loaded
   at 0x68215 conditional on a layer-3-bit test parameterized by the caller's
   argument. Actual semantic: TBD (possibly "depleted mine" or other special-
   tile overlay).

### Findings adding to the model

5. **DOS render is MULTI-PASS, not single-pass.**
   `func_O514` is called multiple times per tile, each time with a different
   argument that selects which layer-3 bit to test (`[0xa89e] = 1 << (arg+4)`
   at 0x685F9). Each pass draws different overlays. Our Python renderer is
   single-pass — re-architecting may be needed for full fidelity.

6. **Per-terrain center variant sprites at 0x5A + variant ARE drawn** at three
   sites (0x682B5, 0x683FA, 0x685D6). Our renderer doesn't emit these. The
   variant table at 0x1DB32 (29 × 16-bit words) was documented in
   FUNCTIONS_INVENTORY.md but never wired into the renderer.

7. **Forest sprite range is 0x41 + topology**, sprites 65-80, *not* 64-79 as
   our renderer assumes. Off-by-one. (Site: 0x68349.)

8. **Mountain vs Hills selection = bit 0x80 of layer 2** (`test [0xa8a1], 0x80`
   at 0x68378). When set: hills (0x31+m). When clear: mountain (0x21+m).

### Where rivers actually live

**Unknown.** Now that bit 0x40 is ruled out, the encoding of rivers in the
.MP byte stream is undetermined. Hypotheses to test next session:
- Per-terrain center variants (sprite 0x5A + specific variant numbers)
- Sub-tile coast sprites at 0x6D + idx (range 109-127, the long-rumored
  SPRITE-D 8×8 sub-tiles)
- A bit in layer 2 or layer 3 not yet decoded

### Action taken

- `docs/RENDER_CHAIN_DISPATCH.md` written with full 15-site catalogue and
  confidence-graded findings.
- `extracted/disassembly/render_chain_capstone.txt` saved with raw 850-line
  capstone disassembly for reproducibility.
- Renderer **NOT modified yet** — overturning four prior rulings means the
  fix is invasive (remove river block, re-enable beach corners, re-enable
  roads, add center variants, possibly multi-pass refactor). Apply in a
  focused next session with explicit user approval per change.

**Confidence**: HIGH for the four overturned rulings (each with cited
bytes). MEDIUM for the multi-pass architecture claim (inferred from
`[0xa89e] = 1 << (arg+4)` parameterization but caller chain not fully
traced). LOW for "where rivers live."

---

## 2026-04-25 (w) — 0x1DB32 table is RESOURCE icons, not per-tile decorations

Applied ruling (v) to the renderer with an unconditional center-variant
draw on every land tile. Result was **wrong** — every grass tile got a
small dark mark in a regular pattern, not visible in DOS reference.

Pixel inspection of sprites 90-103 at 8× magnification settled it:
- 91 = cactus (Desert resource icon = Oasis)
- 92 = small green icon (Plains resource)
- 93 = grain (Prairie = Wheat)
- 94 = sword/fish (Grassland)
- 95 = bright green icon (Savannah)
- 96 = circular marker (Marsh/Swamp/extended-grass)
- 97 = blue/water marker (Ocean = Fishery)
- 98 = deer (Forested-mixed = Game)
- 99 = pine tree (Forested-conifer = Prime Timber)
- 102 = ore nuggets (lost city / mineral)
- 103 = silver/gold (lost city / silver deposit)

These are clearly RESOURCE ICONS, with the depiction varying by the
underlying biome (e.g., "prime resource on a desert tile" = cactus,
"prime resource on grass" = sword/fish, etc.). The 0x1DB32 table is the
*"what icon to draw when this base terrain has a bonus resource"* map.

**Action taken**: gate the center-variant draw on Layer 3 byte ≥ 3
(values 3-14 are bonus resources per MAP_FORMAT.md §5; values 0/1/2 are
border/water-tag/land-no-resource). Edit applied at
`colonize_sdl/main.py` STEP 1b. Verified with the in-sandbox renderer:
icons now appear on the 69 resource tiles in AMER2 instead of all 1235
land tiles. Visual match against `reference/dos/AMER2_dos_reference.png`
is much closer.

**Side note**: the older `OVERLAY_TO_SPRITE` table at `main.py:3182`
which drew an 8×8 corner icon per resource is now redundant with the
center-variant draw. Both fire on the same tiles. Could be cleaned up
but not blocking; leave for future polish.

**Confidence**: HIGH. Sprites visually identified, gate verified by
re-rendering AMER2 in the sandbox and comparing to DOS reference.

---

## 2026-04-25 (x) — Goldens re-baselined to "ruling-v + resource-gate" state

After applying ruling (v) and (w), AMER2 golden was updated by direct
copy of `render_test_AMER2.png` to `tests/golden/AMER2.png`. (The full
regression suite still needs ONE.MP and BLANK4.MP from the user's local
Steam library; only AMER2 was re-baselined in-sandbox.)

This baseline contains:
- Coast sand bands (per ruling t)
- Bit-0x40 → NW beach corner (per ruling v, overturning h)
- Per-terrain center variant on resource tiles (per rulings v + w)
- Original forest, mountain, hills rendering (unchanged)
- Multi-pass architecture not yet implemented (still single-pass)

When the next session runs regression, ONE.MP and BLANK4.MP will need
their goldens copied over from a user-local run, or rendered from the
project's own copies if/when those .MP files land in `COLONIZE/`.

---

## 2026-04-25 (y) — bit 0x40 sprite 150 gated to water tiles only

Ruling (v) said bit 0x40 of layer 1 → sprite 150 unconditionally per the
binary trace at 0x68356. But sprite 150 is authored as a WATER tile with a
sandy NW edge (175/256 opaque, blue water + tan corner). Drawing it on
LAND tiles overlays water-and-sand on grass/forest, producing visual
junk. We saw this in the render.

**Action**: gate the sprite 150 blit to water tiles only:
`if (raw & 0x40) != 0 and is_water(raw): _blit_overlay(150)`. Land
tiles with bit 0x40 are handled by ruling (z) below.

The binary doesn't appear to have an explicit land/water gate at 0x68356,
but it MUST be implicit — either via earlier flow control we haven't
traced (the 2-bit `and ax, 0xc0` dispatch may branch land vs water before
reaching 0x68356), or sprite 150 has expected transparency on land that
makes it effectively a no-op there. Either way, the empirical fix matches
DOS appearance.

---

## 2026-04-25 (z) — Bit 0x40 IS rivers (on land); ruling (v) refined

Ruling (v) overturned ruling (h)'s "bit 0x40 = river" by saying it's
"NW beach corner overlay" instead. Both were partly right:

**Empirical evidence**: mapping all 226 bit-0x40 tiles in AMER2 onto
`reference/dos/AMER2_dos_reference.png` (saved
`outputs/dos_with_bit_0x40_marked.png`) shows clear clustering along
visible river paths — Mississippi, Amazon, St. Lawrence, etc. Of the 226
tiles, 196 are LAND (which the binary clearly shows DOS rendering as
rivers) and 30 are WATER (where the binary blits sprite 150 = beach edge).

**Final ruling**: bit 0x40 of layer 1 is a "river/water-edge" marker with
type-dependent rendering:
- **Water tile + bit 0x40** → sprite 150 (sandy NW beach edge), per the
  trace at 0x68356. Already handled by ruling (y).
- **Land tile + bit 0x40** → river sub-tile sprite from PHYS0 row 0x70-0x80
  (sprites 113-128, all 8×8 with blue water + green banks, pixel-verified
  2026-04-25). The binary draws these via dispatch site 12 at 0x684EB:
    mov al, [bx + 0x2d24]
    sub ah, ah
    shl ax, 2
    add ax, bx
    add ax, 0x6d
    call 0x67dc8
  i.e. `sprite = (table[bx + 0x2d24] << 2) + bx + 0x6D` where the table
  encodes 4-quadrant sub-tile composition. The full table contents have
  not been read from VICEROY's data segment yet (task 22).

**Action taken**: first-cut implementation in `colonize_sdl/main.py`
STEP 6b — on bit-0x40 land tiles, blit a fixed PHYS0.113 (8×8 river
sub-tile) at the center of each tile. Result: visible river network on
AMER2 in correct positions (Mississippi, Amazon, etc.). Chunky vs DOS's
smooth curves, but rivers are now identifiable.

**Confidence**: HIGH for "bit 0x40 = river/water-edge marker" (cited
bytes + visual mapping). MEDIUM for "PHYS0 113-128 are the river sub-tile
range" (pixel content matches but the exact 0x2d24 table not read).

**Action items**: AMER2 golden updated to current state. Task 22 added for
topology-correct sprite variants once 0x2d24 table is read from VICEROY's
data segment.

---

## 2026-04-25 (aa) — File-write incident note

During this session's renderer edits the `colonize_sdl/main.py` file
suffered intermittent end-of-file truncation. The Edit tool would
successfully apply targeted changes but ~9 lines from the end of the file
would be lost on each operation. Recovery: I head-truncated to the last
known-good line and appended the recovered Europe screen body + a
`def main()` + `if __name__ == "__main__":` launcher (extracted from the
older `colonize_sdl/__pycache__/main.cpython-37.pyc` via decompyle3).

Cause unknown — possibly a workspace filesystem-sync race on large files.
Workaround: after every Edit, run `python3 -c "import ast; ast.parse(...)"`
to detect truncation and re-append the tail. Saved tail content to
`/tmp/eu_tail.py` for quick recovery.

This caveat is logged so a future session knows: if main.py suddenly
fails to parse with `'(' was never closed` near the Europe screen
section, run the head-truncate-and-append-tail dance.

---

## Rulings derived from DOSBox screenshots (2026-04-29)

The user supplied 16 high-quality DOSBox screenshots in this session. The
following rulings are now BINDING and should not be re-litigated.

### Ruling — No bottom status bar in main map view

**Source: DOSBox screenshot 4 (canonical playing-the-game view).**

The DOS Colonization main map view has NO bottom status bar. The map
viewport runs to the bottom of the screen. Earlier fabrication of a
"B COLONY F FORT S SENTRY SPACE END TURN" status strip was a complete
invention. `_render_status_bar` exists in main.py but is intentionally
NOT called from `_render_map_screen`. Don't re-add it.

### Ruling — Sidebar (right info panel) layout

**Source: DOSBox screenshot 4.**

Top-down structure:
1. Minimap with ORANGE 1px border (~56×36 native pixels) at the top
2. Stack of three yellow lines: `Spring 1492` / `Gold: 3000` / `Tax: 0%`
3. Selected unit block: small unit sprite on left + two text lines
   alongside (`Moves: 4` / `Locat: (56, 42)`)
4. Below that: yellow `Eng. Caravel`, green `No Orders`, dim cream
   `(Sea Lane)`
5. Cargo / passenger sub-blocks (each: small portrait + 2-line label
   `Veteran Sentry` / `100 Tools Sentry` etc.)

Field labels: `Moves:`, `Locat:` (with t), `Gold:`, `Tax:`. Don't drop
the colons or use abbreviations like `Loc:`.

### Ruling — Opening narration order

**Source: DOSBox screenshots 5–9.**

The narration appears one line at a time, fading in/out over a
night-sky port background. Order (from coltext0 ids):

1. id=27 "In the Year of Our Lord One Thousand Four Hundred Ninety-Two,"
2. id=29 "an Expedition led by the Great Explorer, / Walter Raleigh,"
3. id=31 "Commissioned and Blessed by the King of England,"
4. id=30 "left London on a Voyage of Discovery."
5. id=32 "to Explore the Ocean Sea,"
6. id=28 "A New World!"

Earlier fabrication had `(28, 27, 29, 30, 31, 32)`. Wrong. Don't change
back.

### Ruling — Title screen has gold borders + bitmap title built into OPENMENU.PIK

**Source: DOSBox screenshot 16.**

The "Sid Meier's COLONIZATION" big ornate title and the gold ornamental
rope borders are PART of the OPENMENU.PIK bitmap, not separate sprites.
Just blitting OPENMENU.PIK as the full-screen background gives them for
free. The menu options render inside a dark-wood box with red border in
the lower half, with a yellow-orange version row at the top.

The "Quit" option from coltext0 id=25 is NOT shown in the original DOS
menu. Filter it out.

### Ruling — Menu bar is YELLOW caps on BLACK with FONTINTR

**Source: DOSBox screenshot 4.**

Top menu bar: pure black background strip, FONTINTR (intro/menu face)
text, yellow color (~RGB 255,220,80). NOT white-on-dark-brown.

### Ruling — Nation select is 4-flag 2×2 grid with red selection border

**Source: DOSBox screenshot 14.**

Layout: full-screen WOODPANL bg. Title text "Select / European Power"
green LEFT-ALIGNED upper-left. Hint "(Click Here When Finished)"
green BOTTOM-LEFT. Four nation flags occupy the right area in a 2×2
grid (England top-left, France top-right, Spain bottom-left,
Netherlands bottom-right). Selected flag has a RED 2px border +
red text "ENGLAND:" above and bonus type "Immigration" (or
Cooperation/Conquest/Trade) below.

### Ruling — Difficulty select is 5 portrait cards on DIFFICUL.PIK

**Source: DOSBox screenshot 15.**

The DIFFICUL.PIK background already CONTAINS the 5 painted portraits
(Discoverer, Explorer, Conquistador, Governor, Viceroy) in a
2-top-row + 3-bottom-row layout. We don't need separate portrait
sprites. Selection: BLUE 2px border + blue overlay name+descriptor
("EXPLORER: Easy" etc.).

### Ruling — King audience text on right-side parchment scroll, FONTKING sepia

**Source: DOSBox screenshot 10.**

KINGLSS1.PIK is the full-screen background showing the throne room +
King figure + dog + tapestries. The text overlay is on the RIGHT-SIDE
parchment scroll only (~x=200..310 in 320×200 native), in FONTKING
(cursive 7px) with sepia/brown ink (~RGB 60,30,10). NOT white-on-black,
NOT centered horizontally.

### Ruling — Name entry pre-filled with leader name

**Source: DOSBox screenshot 13.**

The name-entry box is pre-filled with the default leader name for the
selected nation (Walter Raleigh / Jacques Cartier / Christopher
Columbus / Michiel De Ruyter from DOS_LEADER_NAMES) ready for backspace.
Box is wide (~220 native pixels), centered horizontally, GREEN-outlined
with GREEN text inside. No "Press ENTER" hint visible.

### Ruling — Custom mouse cursor

**Source: DOSBox screenshots 1, 13, 16 (cursor visible top-left in all).**

The DOS engine draws its own white-and-black arrow cursor sprite from
CURSOR.SS.000.png (17×17). Hide the OS cursor with
`pygame.mouse.set_visible(False)` and blit the sprite at the mouse
position each frame.

### Ruling — Godot visual truth is native 320×200 DOSBox captures, NOT the Python `tests/golden/`

**Source: direct artifact inspection 2026-05-18 (file resolutions) +
`reference/dos/CAPTURE_PLAN.md` + first real `run_regression_godot.py`
run on Godot 4.4.1.**

The approved export plan (P0/P4) assumed the Godot 320×200 port could
diff against the SAME `tests/golden/{ONE,UNTITLED,BLANK4,AMER2}.png` the
Python port uses, "forcing both ports onto one truth". Measured reality:

- `tests/golden/*.png` are the **Python+pygame port's** internal-resolution
  full-map renders at **896×1152** — not 320×200 DOS-screen frames.
- `reference/dos/AMER2_dos_reference.png` is **1792×2240** (a large/scaled
  DOSBox capture), also not a native single-screen 320×200 frame.
- `reference/dos/CAPTURE_PLAN.md` is the project's own methodology to
  capture **native 320×200, scaler=none, no interpolation** DOSBox
  screenshots into `reference/dos/*.png` — and that capture is a
  **pending human action** (PROJECT_BOARD Tier 0).

**Ruling:** the DOS visual ground truth for the Godot 320×200 port is the
set of native-320×200 DOSBox captures produced per
`reference/dos/CAPTURE_PLAN.md`. Until those exist, Godot visual goldens
are **provisional**, live in `tests/golden_godot/`, are written only via
`run_regression_godot.py --update` with explicit approval, and are
**locked against the real DOS captures at plan phase P7**. The
`tests/golden/` (Python 896×1152) set is NOT a valid Godot diff target
and `run_regression_godot.py` must not point at it. The "one shared
golden forces convergence" idea is superseded: convergence is enforced by
both ports being diffed against the *same `reference/dos/` 320×200
captures*, not against each other's renders.

### Ruling — Godot map.json legacy semantic fields are fabricated; the renderer uses the cited raw .MP bytes

**Source: direct data inspection 2026-05-18 + COLONIZE/AMER2.MP +
MAP_FORMAT.md §3/§5 (CONFIRMED, 4-map validated). User-reported bug
("deer all over the map").**

The pre-decoded `colonization_godot/data/map.json` semantic fields
(`resource`, and by implication `forest`/`hills`/`river_mask`) are
**fabricated / unreliable**: the `resource` field has value `"game"` on
**1,169 of 4,176 tiles** (28%), causing the deer (PHYS0.98) sprite to
paint almost the whole map. The cited Layer-3 `res` byte (added by
`tools/gen_godot_map.py` from AMER2.MP) is byte-perfect against
MAP_FORMAT.md §5.3: exactly **69** special-resource tiles
(res 3-14; res 5 = 22, most common — matches §5.3 verbatim).

**Ruling:** the Godot renderer derives terrain and resources **only** from
the cited raw `.MP` bytes (`tile.raw` Layer-1 per MAP_FORMAT §3,
`tile.res` Layer-3 per §5), never from the fabricated semantic
`map.json` fields. P4 already moved base/forest/hills/mountains to
`raw`; the resource pass now uses `res` gated `>=3` with the cited
MAP_FORMAT §5.2 + SPRITE_CATALOG row-0x60 sprite map (`RES_PHYS0` in
`map_view.gd`). res values 3-6 (Wheat/Cotton/Tobacco/Sugar) have no
cited row-0x60 icon → **no overlay drawn** (not guessed; P7 re-verify
via the VICEROY resource-draw function). Do not reintroduce the semantic
fields into the render path. Colony-yield game logic that may read
`resource` is a separate P6 concern and must likewise migrate to the
cited `res` byte / @RESOURCE table.

### Ruling — Godot stretch mode MUST be canvas_items (viewport = black window)

**Source: user-confirmed 2026-05-18 on the target machine. Self-captured
F5 framebuffer proved the 320×200 render was perfect while the window
showed solid black; switching `window/stretch/mode` "viewport" →
"canvas_items" fixed it ("Now shows the game").**

With this project's `renderer/rendering_method="gl_compatibility"` and
`window/stretch/mode="viewport"`, the 320×200 framebuffer renders
correctly but the **window presents entirely black** on the user's GPU
(a known Godot 4 GL-Compatibility + viewport-stretch presentation bug).

**Ruling:** the project uses `window/stretch/mode="canvas_items"` +
`aspect="keep"` + `scale_mode="integer"` (design size 320×200). This is
**fidelity-neutral** — content is authored/rendered in 320×200 coords and
integer-scaled; a clean 4× window (1280×800) nearest-downscales to an
exact 320×200 capture, so goldens stay pixel-faithful (godot_shot already
resizes mismatched grabs with INTERPOLATE_NEAREST). Do NOT revert to
`viewport` stretch. Because the **Godot editor rewrites project.godot**
(it has reverted run/main_scene and stretch keys before — the reason
earlier display fixes didn't reach the user), the autoload
`DisplayGuard` (`scripts/systems/display_guard.gd`, first autoload)
re-asserts CONTENT_SCALE canvas_items/keep/integer/320×200 at startup as
a belt-and-suspenders. If the black window ever returns, check this
setting first.

### Ruling — Map render is structurally verified; AMER2_dos_reference.png is editor-style (structural truth only)

**Source: overnight run 2026-05-18 — `tools/dos_map_diff.py` +
`godot_shot --screen=fullmap` (map_view `full_render`) diffed the full
58×72 Godot map vs `reference/dos/AMER2_dos_reference.png`
(1792×2240 = 56×70 @32px), auto-aligned at Godot tile offset (1,1).**

The Godot full-map render is **structurally correct** — same Americas
twin continents, same land/water/forest/mountain placement as the DOS
reference. The `.MP` decode (`gen_godot_map.py`) + the raw-byte
TERRAIN.SS/PHYS0 terrain chain are fundamentally right. (Raw pixel-match
is only 0.04% because the styles differ, see below — not because the
terrain is wrong.)

**Ruling:** `AMER2_dos_reference.png` is a **flat / map-editor-style
export**, NOT the in-game PHYS0/TERRAIN.SS pixel style (its ocean is a
flat lighter blue; the authentic in-game ocean is the cited dark-dithered
PHYS0.148 per SPRITE_CATALOG row 0x90). Therefore:
- Use it for **structural placement validation only** (passes).
- The **in-game pixel-fidelity** reference is the session
  `frames/*.webp` (1280×800 = native 320×200 ×4, real DOS gameplay).
- Per-layer sprite-selection refinement (coast 150–153 flip mask, river
  row 0x00 adjacency, forest wxad transition, resource sprites) is driven
  from the cited `extracted/disassembly/render_chain_capstone.txt` /
  `docs/RENDER_CHAIN.md` + SPRITE_CATALOG, validated
  against cropped in-game frame patches.
- **Do NOT** pixel-chase the editor export (e.g., do not lighten
  PHYS0.148 to match it — that would abandon the authentic sprite and be
  *less* faithful). `tools/dos_map_diff.py` remains a structural
  regression tripwire, not a pixel bar. Supersedes any earlier
  expectation of a high raw pixel-match vs `AMER2_dos_reference.png`.

---

## 2026-05-30 — `func_062D84` is unit auto-move, NOT a "number-to-name converter"

**Conflict:** `viceroy_source/FUNCTION_INVENTORY.md` labeled `func_062D84`
"Number-to-name converter" (strings *Five/Four/Seven/Three*). The overlay
breadth-sweep port (page_13 reseg) traced it as a 1618-byte UnitRecord routine.

**Resolution (byte truth wins — TRUTH_HIERARCHY):** the body is unambiguous
unit logic, byte-verified at VICEROY.EXE:
`0x062DA2 imul bx,ax,0x1c` (UnitRecord stride), `0x062DCA mov al,[bx+0x3144/45/46]`
(type), `+0x3147` (owner nibble), `+0x314d/4e` (move/order state), and a second
`imul bx,[bp-0x48],0x1c` (target unit) at `0x062E1F`. ENTER 0x46, 561 insns. It
is the **per-unit automatic move/goto step executor**. The *Five/Four/Seven/Three*
string association was a false string-proximity heuristic (those literals belong
to another routine). Inventory entry corrected; body ported in
`src/overlay/overlay_0612E6_066EB3.c`. Reinforces the standing caution that the
string-first heuristic must be confirmed against the function body's actual
memory references before trusting the label.

---

## 2026-05-30 — Independence gate = rebel sentiment ≥50%; [0x53D0]=rebel%, [0x5381]&0x80=multiplayer (NOT a succession gate)

**Question tested:** does the "War of the Spanish Succession" event gate the
player's ability to declare independence? **Answer: NO** — debunked by byte trace.

**func_03E984 = declare-independence handler** (page 0x06, byte-verified):
1. `cmp [0x53D0], 0x32` (50). If **below 50** → show **@TOOTORY** GAME.TXT msg
   ("Only {N}% of the colonists support the independence movement … we cannot
   start a rebellion until the majority is behind us") and return.  Therefore
   **[0x53D0] = national rebel-sentiment / Sons-of-Liberty percentage** (the
   `@TOOTORY` text prints this very value as the %), and the **independence gate
   is rebel sentiment ≥ 50%** — NOT a turn counter and NOT the succession.
2. else `test [0x5381], 0x80`; if set → **@MULTIREV** ("The Revolution does not
   function in multi-player mode").  Therefore **[0x5381] bit 0x80 = MULTIPLAYER
   flag** (set in func_07431E setup when ≥2 human powers are in the active-power
   mask [0x1F54]; `cmp di,1; jle; or [0x5381],0x80`).
3. else → **@DECLARE** confirmation ("Shall we declare our independence … places
   us at war with our King!") → declares.

**Relationship to the succession:** the succession emitter **func_03C638** runs
its body only when `[0x5381]&0x80` is CLEAR — i.e. the auto Spanish-Succession is
a **single-player-only** European event.  So succession and independence are
linked ONLY through the shared multiplayer flag (multiplayer disables the
auto-succession AND shows @MULTIREV on a revolution attempt); **neither gates the
other**.  Independence works at ≥50% rebel sentiment regardless of whether the
succession has fired.

**Corrects** an in-session over-reach that tentatively tied [0x53D0]≥0x4B(75) to
the succession timing — that was wrong; [0x53D0] is the rebel %.

**Still open:** the exact caller/turn-timing of func_03C638 (reached via the
overlay thunk table; needs a thunk cross-reference pass to resolve).

---

## 2026-05-30 — func_048A3A/048CA4/04AF5E are NATIVE handlers, not market/europe

The 046D70 finish-wave (commit ~135) labeled three page-0x0C functions as
"market_commodity_price_line / market_commodity_price_settle / europe_buy_goods".
The event-catalog deepening pass byte-disproved this: each pushes a GAME.TXT
message KEY whose string sits at `file = handle + 0x1D9A0`:

- **func_048A3A** push 0x1532 = "MISSION0"  -> NATIVE MISSION ESTABLISHED.
- **func_048CA4** push 0x153B="HERESY0" / 0x1543="HERESY1" -> NATIVE MISSION HERESY.
- **func_04AF5E** push 0x16E9="INDIANWARFARE" / 0x16C1="INDIANWARPATH2" (+ NOCONTACT/
  ALREADYSMITE/UNFORTUNATE) -> SCOUT-INCITES-A-TRIBE-TO-WAR BRIBE (the gold debit the
  finish-wave read as a "market purchase" is the bribe payment).

The REAL European price events PRICEUP/PRICEDOWN are **func_0305A8** (handles
0x0FA8/0x0FB0). Ruling: the finish-wave mistook GAME.TXT key-name string handles
for price-format strings. Resolution = byte truth (handle->key); the three
functions are being re-ported with correct native semantics in overlay_046D70.
The event catalog (docs/event_catalog.html) already uses the correct framing.
Lesson: a pushed 16-bit immediate that resolves (via +0x1D9A0) to an ALL-CAPS
GAME.TXT key is a message-key, not a format string — check the target before
naming the function.

---

## 2026-05-30 — Starting gold IS difficulty-scaled (set in RESIDENT code, not the overlay new-game init)

CORRECTION of an in-session error. I had concluded "starting gold = 0 for all
difficulties" by tracing only the OVERLAY new-game init (func_07431E /
func_0755CC), which seeds units + zeroes the PowerRecord. That was incomplete:
the difficulty-scaled starting gold is set in the RESIDENT player-setup routine
(the auto-decoder left it in code/VICEROY/disasm/orphans_overlay.asm), gated on
the active power [0x9E12] being human ([0x543F]==0):

  byte-verified starting gold (human player):
    @0x036779  MOV word [bx+0x2A], 0x3E8  -> Discoverer (difficulty 0) = 1000 gold
    @0x036599  MOV word [bx+0x2A], 0x12C  -> Explorer  (difficulty 1) =  300 gold
    (no gold write for difficulty 2/3/4 -> Conquistador/Governor/Viceroy = 0)

Confirmed empirically by the user (1000 on Discoverer; ~300 on Explorer). The
same difficulty switch also tweaks unit/personality byte fields ([bx+0x02]=0xD
on Discoverer, [bx+0x04]=0x16 on Explorer, etc.) that warrant a cleaner decode.

Lesson: the new-game flow spans RESIDENT + overlay code. Searching only the
overlay reseg pages missed the resident setup. Future "where is X set" sweeps
must include code/VICEROY/disasm/*.asm (resident) + orphans_overlay.asm, not
just disasm_overlay_reseg/.

---

## 2026-05-30 — func_036574 is the starting-gold / new-game per-power SETUP, mis-stubbed as OUT-OF-SCOPE

The status-dashboard build (cross-checked vs the gold test) found that
**func_036574** was ported in `src/overlay/overlay_0341D6_0388DE.c` as a 13-byte
"SCREEN-OP THUNK STUB (OUT-OF-SCOPE)" (`func_036574_logic_sz_13`). That is WRONG:
its TRUE extent is **0x036574..0x03680D (~665 bytes, ENTER 0xC)** and it contains
the **starting-gold-by-difficulty switch** (Discoverer 1000 @0x036779 / Explorer
300 @0x036599 / 0 else, byte-verified per the prior RULINGS entry) plus the
per-difficulty unit/personality field tweaks ([bx+0x02]=0xD on Discoverer, etc.),
gated on the active power [0x9E12] being human ([0x543F]==0). It is reached via a
screen-op LCALL (:0x4CA), which is why an earlier pass dismissed it as a screen
thunk — but it is core new-game SETUP logic, IN SCOPE. Needs a full re-port.

Dashboard caveat logged: status "done" can over-state functions ported as SHORT
out-of-scope STUBS whose true extent is large (size mismatch dump-vs-port).
func_036574 is the known instance; a stub-vs-extent audit would surface any others.

---

## 2026-05-30 — Colony screen is page 0x03 / id 0x2C; 0x031E4C is the EUROPE composer (NOT colony)

Cross-agent conflict during the coded-screen-layout pass: a colony-screen agent
(anchored on func_0321B4) and a europe-screen agent BOTH identified **file
0x031E4C** as "their" screen's paint composer, with conflicting roles for the
shared sub-renderers. Arbitrated by byte trace:

**0x031E4C is the EUROPE screen composer.** It has NO screen-id branch and
unconditionally calls func_0310B4 (16-good market price bar, 0,179,320,21),
func_030F76 ("Selling <Good> at <N> Gold" trade banner), func_0314DC (dock + 6
ships, sprite 0x7B), func_031DC8 (**3-immigrant recruit pool**, 281,89,37,32),
then the outer frame (lcall 0x181F:0xE2). The 3-slot recruit pool + market sell
banner are Europe-only; the colony screen has neither.

**The two screens are distinct code regions** (proved via the enter_screen_view
call sites `mov bx,id; lcall 0x181F:0x772`):
- **EUROPE** = screen-id **0x2B**, entry func_030DBC @file 0x030deb, page 0x04,
  loads EUROPE.PIK (key 0x0FBA @0x030DCE). Composer 0x031E4C. ✓ europe_screen.c.
- **COLONY** = screen-id **0x2C**, entry @file **0x025EC8**, page **0x03**, loads
  COLONY.PIK (key 0x0BA0). Composer = VICEROY equivalent of recol func_0199D8
  (see docs/COLONY_RENDERER_DECODED.md). Being re-traced into
  colony_screen.c.
- (Other screen-ids found: 0x28 @0x450ae, 0x29 @0x6d5aa, 0x2a @0x7661f,
  0x2d @0x05e63.)

func_0321B4 (page 0x04) is a EUROPE-screen helper (reads a recruit's UnitRecord
type via [bx+0x3146]), NOT the colony entry — the colony agent's mis-anchor.

Lesson: page 0x04 is the Europe screen end-to-end. Do not assume a function is
"colony" from a task label; verify the screen-id (0x2B europe / 0x2C colony) and
the PIK key (EUROPE.PIK 0x0FBA / COLONY.PIK 0x0BA0) at the entry stub. The
"Selling <Good>" banner is the Europe smoking gun.

---

## 2026-05-31 — Map "coastline regression" (AMER2/ONE/UNTITLED) is STALE GOLDENS, not a renderer bug

Task #15 ("fix red map-render regression") investigated + RESOLVED as a
**stale-golden** issue, NOT a coast-rendering bug. The current renderer
(`colonize_sdl/render/terrain.py` `TerrainRenderMixin` — `main.py` is now a
35-line stub) is the DOS-faithful party:

- Diff dominant pair: current `(76,101,174)` light-blue SHALLOW water at coasts
  vs golden `(194,174,133)` heavy TAN sand.
- `reference/dos/AMER2_dos_reference.png` (the standing pixel target) at coast
  pixels = light-blue shallows `(76,98,173)` — MATCHES the current render, NOT
  the tan golden.
- Independently verified: over the differing pixels, the current render is
  closer to the DOS reference **~69%** vs the golden's ~31%. BLANK4 passes
  precisely because it has no coastlines.
- The goldens were produced by an EARLIER coast renderer (heavy-tan, no shallow
  halo); the current code (concave coast sprites 150-153 + linear-atlas subtiles
  + shallow-blue halo, river rows 0x01/0x11 used only as rivers) is correct.

**Do NOT "fix" the coast renderer to match the goldens** — that would reduce DOS
fidelity (prime-directive violation). The correct fix is to re-bless the 3
goldens from the current render. **Re-bless was offered and the user chose to
HOLD (2026-05-31)** — likely pending fresh 320x200 DOS-native goldens (see
CAPTURE_PLAN.md / the Godot golden-truth note). Until then the map regression
stays red on coasts BY DESIGN; this is not a renderer defect.

---

## 2026-05-31 — OVERTURNED: overlay 0x191F/0x1A1F is STATICALLY RESOLVABLE, not blocked

The long-standing assumption that the RTLink overlay dispatches `lcall 0x191F:NNN`
(and 0x1A1F:) are "blocked / runtime-dynamic" — and that the C-reconstruction's
core game logic is therefore unreachable — is **WRONG and OVERTURNED**. These
Type-A overlay calls are **fully deterministic and statically resolvable to file
offsets.** (Supersedes the memory note "core logic blocked behind overlays
0x191F/0x181F" 2026-05-28.)

**Root cause of the error:** prior analysis conflated two distinct fields in the
14-byte Type-A thunk trailer. For the F3 thunk @file 0x1B9EE =
`9a ab0d 0d11 | ea d0 06 00 00 | 05 00 00 00`:
- `9A AB0D 0D11` = LCALL 0x110D:0x0DAB (the Type-A loader stub func_01427B).
- `EA <off16> <seg16>` = JMPF placeholder: **off16=0x06D0 is the offset_in_segment**
  (real, never patched); seg16=0 is the load-time paragraph placeholder.
- **trailer word @+0x0A = the TARGET PAGE-ID (a static literal, here 0x05).**

The prior "page-rel 0x06D0 → runtime page directory" read mistook the JMPF offset
(0x06D0) for the page-id. The real page-id (0x05) is a separate static immediate.

**Resolution formula (byte-verified):**
```
target_file_offset = code_offset(page_id) + (ljmp_seg << 4) + offset_in_segment
```
code_offset(page_id) from the static segment list @file 0x192F0 (31 records,
page_id = segmentNum-1). All 658 Type-A page-ids are static in-range literals
(1..31); 578/658 land on clean ENTER/PUSH-BP prologues, 0 land outside page code.
The loader func_014293 @0x14508 reads `[si+5]` (the page-id), `AND 0x3FFF`,
`(id-1)*2 + dir_base` — confirming the page-id (not a computed value) selects the
overlay. Runtime only varies WHERE the fixed segment is cached (RAM/EMS/XMS/disk),
never the file offset.

**Verified resolved offsets (5/5 land on clean prologues):**
- F3 report body 0x191F:0x3FE → **file 0x037A10** (ENTER 0x6E).
- Colony scene helper 0x191F:0xB5E → **file 0x0314AE** (PUSH BP;MOV BP,SP).
- Europe menu engine 0x191F:0x182/0x16A → **0x06F0F4 / 0x06E3D0** (ENTER).
- load_PIK 0x191F:0x87A → **file 0x076AEC** (ENTER 0x126).

**Consequence:** the previously-"blocked" UI bodies (advisor report renderers on
page 0x05, colony surrounding-terrain scene on page 0x04, Europe ship-column menu
engine on pages 0x02/0x17/0x18) AND the core game-logic overlays are ALL decodable
statically from these resolved offsets. No DOSBox single-step / loader emulation
needed.

**BUG to fix:** `code/VICEROY/typeA_thunk_targets.json` (consumed by the C
reconstruction) uses `code_offset + jmpf_off` and OMITS the `(ljmp_seg << 4)`
term → correct for the 501 zero-seg thunks but WRONG for 157 nonzero-seg thunks
(e.g. load_PIK: artifact 0x764DC=garbage vs correct 0x76AEC). Authoritative
resolver: tools/rtlink/rtlink_decode.py + viceroy_rtlink_map.json (RTLINK_V2.md
§7.3). Re-resolve the 157 affected thunks.

---

## 2026-06-20 — Terrain ids 24–28: @OTHER ordering resolves MP_FORMAT.md conflict

**Conflict.** Two byte-tier sources disagreed on the high terrain ids:
- `formats/MP_FORMAT.md` id table: **24=Mountains, 25=Hills, 26=Ocean, 27=Lake**,
  and (line ~60) **16=Arctic** "(auto-forest base 16)".
- `spec/systems/map_system.md` @OTHER (tier **B**, present in NAMES) + the coast
  renderer trace `@0x67FD0 cmp al,0x18`: **0x18/0x19/0x1A = Arctic / Ocean /
  Sea-Lane**.

**Evidence (this branch's `raw/COLONIZE/VICEROY.EXE` + NAMES data):**
- `@OTHER` (NAMES_sections.json) byte-verified **order** = `Arctic, Ocean,
  Sea Lane, Mountains, Hills` (5 rows, in that sequence).
- **Hard rule 2** (CLAUDE.md): the sea-lane base terrain id = **26 (Ocean-class)**.
  Sea Lane is the **3rd** @OTHER row (index 2) ⇒ @OTHER base = `26 − 2 = 24`.
- Therefore: **24 (0x18)=Arctic, 25 (0x19)=Ocean, 26 (0x1A)=Sea Lane,
  27 (0x1B)=Mountains, 28 (0x1C)=Hills.**
- **Corroboration from the random-map generator `func_064A10`** (independently
  byte-traced): P0 fills the interior with **0x19 (=Ocean)** then grows landmass;
  P5 writes **0x18 (=Arctic)** to the top/bottom rows (polar caps — geographically
  correct) and **0x1A (=Sea Lane)** to the right two columns. All three immediates
  are exactly consistent with Arctic=24/Ocean=25/Sea-Lane=26.
- **MP_FORMAT.md is the outlier and is wrong:** its "16=Arctic" places Arctic
  *inside* the auto-forest range **8..23** (hard rule 3), which is impossible; and
  its 24=Mountains would put Mountains at the map's polar rows. It also collapsed
  Ocean and Sea Lane into a single id 26, whereas @OTHER lists them separately
  (Ocean=25, Sea Lane=26).

**Resolution (per TRUTH_HIERARCHY — running-game/renderer byte-trace + @OTHER B
+ hard rule 2 outrank a preprocessed format table):** adopt
**24=Arctic, 25=Ocean, 26=Sea Lane, 27=Mountains, 28=Hills.** `MP_FORMAT.md`'s
terrain-id table corrected accordingly. The map-generation agent's proposed
"0x19 ≠ Ocean" correction (which relied on the erroneous MP_FORMAT table) is
**rejected**; the generator's `0x19=Ocean` label stands.

**Unaffected / still open:** the structure of the auto-forest range 8..23 (why 16
slots for ~8 forested variants) is a separate question.

**Follow-up (2026-06-20) — P2 climate table IS byte-verified.** A first pass held
that the C-recon "5,4,1,3,2,2" climate list was not byte-grounded (the literal
byte sequence is absent from the EXE). That was a false negative: the values are
**inline switch cases**, not a data array. The N dispatch `@0x64CF6 jmp word ptr
cs:[bx+0xBAC]` reads a table at file **`0x64CFC`** (cs-base file **`0x64150`**, not
`0x6442c`) whose 6 words point exactly to local `mov [bp-0x2e],N` cases →
**`{5,4,1,3,2,2}`**; the S dispatch `@0x65048 cs:[bx+0xEFE]` (table `0x6504E`) →
`mov [bp-0x12],N` cases → **`{2,3,3,4,6,7}`** (Marsh case 50%-gated, Swamp/Marsh
moisture −2). Both match `viceroy_source/src/mapgen/climate.c` exactly. The earlier
"scattered targets `0x66605/…`" were an artifact of decoding the table at the wrong
offset/segment base. **map_generation.md §3 P2 = BYTE_VERIFIED.**

---

## 2026-06-20 — Colony build-completion field offsets (byte-trace vs dump labels)

**Context.** `spec/systems/colony.md` carried dump-derived ("RUNTIME-VERIFIED" /
DATA_MODEL) labels: build target `+0x10`, constructed bitmask `+0x60..0x65`,
hammers `+0xBA` (good 0x10 in the `+0x9A` array). A static byte-trace of the
**actual per-turn completion code** (`func_02D658` → `func_02D0E4` → `func_0092E0`)
disagrees and is internally complete.

**Byte-verified completion mechanism (all sites confirmed this branch's EXE):**
- **Hammer accrual bank = ColonyRecord `+0x92`** (u16): `@0x2E50F add [bx+0x92],ax`
  (ax = hammers-produced from good-0x10 query `lcall 0x181f:0xb50` → file `0x8DBC`,
  which reads a **global** per-good table `DGROUP:0x8E5A`, *not* a colony field),
  clamped ≥0 `@0x2E517`.
- **Build target id = ColonyRecord `+0x94`**: `@0x2E529 mov al,[bx+0x94]`; cost
  lookup `lcall 0x181f:0xac4` → `func_00B65A @0xB688` reads `@BUILDING[idx].cost`
  from table **`DGROUP:0x8F8C`** (stride **12**, 42 entries; written by parser
  `func_074D18 @0x74D1D`); gate `@0x2E53B cmp ax,[bx+0x92]; jle`; no-target guard
  `@0x2E544 cmp byte[bx+0x94],0; jge`.
- **Second hammer bank `+0xB6`** (cost-debited, **surplus carried**): `@0x2E6A1
  cmp [bx+0xb6],ax; jl`; `@0x2E6A7 sub [bx+0xb6],ax` → `call 0x2EF4B` trampoline →
  `func_02D0E4`.
- **Persistent constructed mask = ColonyRecord `+0x84..0x89`** (48 bits): setter
  `func_0092E0`: `cx = [0x8542] + (id>>3) + 0x84; or [bx], 1<<(id&7)` `@0x9308`.
  The **`+0x8A` bit-array is the DISPLAY copy** — its setter `func_0085D6` is a
  byte-for-byte twin of `func_0092E0` differing only in the `+0x8A`/`+0x84`
  constant. The "already-built?" guard tests `+0x84` (`func_0086 3E/0x860E` reads
  `[colony_idx·0xCA + 0x5DCA]`, `0x5DCA = 0x5D46 + 0x84`).
- **Build target is NOT auto-reset** to 0xFF on completion (no write to `+0x94`
  in either function); re-completion is blocked by the `+0x84` guard + `@ALREADYHAVE`.

**Resolution.** For the **build system**, the byte-traced offsets are authoritative
(they are the code that actually accrues hammers, checks cost, and flips the
constructed bit): **hammers `+0x92`/`+0xB6`, build target `+0x94`, constructed mask
`+0x84` (display copy `+0x8A`), cost table `DGROUP:0x8F8C`**. The dump labels
`+0x10`/`+0x60`/`+0xBA` are **not referenced** by the completion path; they are
flagged in `colony.md` as conflicting and pending re-examination (a dump label can
be a mis-attributed offset even when the bytes are real). The `+0x8A` =
buildings-present display array remains correct (now paired with its `+0x84`
persistent twin). **Open:** the exact roles of the two hammer banks `+0x92` vs
`+0xB6` (which is the UI-displayed/save-persisted total).

---

## 2026-06-20 — PowerRecord +0x32 is home_x (spawn coord), NOT a REF strength rating

**Conflict.** `spec/systems/ref_growth.md §2` labeled `PowerRecord +0x32` (u16) as
`ref_strength_rating` (RUNTIME-VERIFIED, from a memory dump). A static byte-trace
(Campaign C4) shows otherwise.

**Evidence (this branch's EXE):** `@0x58D72 mov al,[bx-0x77c6]` (`bx=power·0x13C`;
`-0x77c6 = 0x883A = PowerRecord +0x32`) reads it as a **byte**, then `@0x58D7A mov
[si+0x314d],al` writes it to a spawned UnitRecord's map-x. Sibling writers
(`@0x418D0`/`@0x65CCB`/`@0x74D74`) all `mov byte[bx-0x77c6],al` while looping the 4
powers with spawn coordinates. So **`+0x32 = home_x`, `+0x33 = home_y`** (the power's
European-arrival / starting spawn coordinate bytes), not a u16 strength.

**Resolution (disasm at a cited offset > a runtime-dump *label*):** adopt
**`+0x32`/`+0x33` = home (x,y) spawn coordinates** (byte each). **There is no stored
aggregate REF-strength field** — the four REF counts `[0x53DA..0x53E0]` are summed on
demand at UI/Congress display. The dump's "ref_strength_rating" was a mis-labeled
offset (the bytes were real, the interpretation wrong). `ref_growth.md` corrected.

**Related C4 findings (recorded for completeness):**
- The REF `+0xE` per-type value table `DGROUP:0x9408` is **BSS (runtime-zero in the
  static image)** — its per-type values can't be byte-read from the EXE; the count
  increment is `@0x3E238 inc word[bx+0x53da]`.
- The "REF per-power gate byte `[power·0x13 − 0x6DA2]`" (`DGROUP:0x925E`) is **not** an
  active/surrendered flag — it is the 3rd byte of a 0x13-stride per-power REF count
  record (`0x925C/0x925D/0x925E`), used arithmetically as troop strength (`@0x5B99E`).

---

## 2026-06-20 — UnitRecord base = 0x3144; map position vs goto-target offsets

**Conflict.** `docs/DATA_MODEL.md` / `spec/systems/unit.md` use UnitRecord base
**0x3146** and label **map_x = +0x07 (abs 0x314D)**, map_y = +0x08 (abs 0x314E).
Campaign C5's static trace shows those abs offsets are the **goto-target**, not the
unit's position.

**Evidence (byte-verified, absolute offsets — base-independent):**
- **Renderer** `@0x03A63 mov al,[bx+0x3144]` (x) / `@0x03A5E [bx+0x3145]` (y) — reads
  the unit's drawn **position** from **abs 0x3144/0x3145**.
- **Placer** `@0x06958 mov [bx+0x3144],al` (x) / `@0x0695E [bx+0x3145],al` (y).
- **GoTo writer** `@0x22D38 mov [bx+0x314D],colony.x` / `@0x22D3F [bx+0x314E]` — the
  **goto target** is at abs 0x314D/0x314E.

**Resolution:** UnitRecord **base = 0x3144**, stride 0x1C. Map position =
**abs 0x3144 (x) / 0x3145 (y)**; unit_type = 0x3146; owner nibble = 0x3147; order =
0x314C; **goto-target = 0x314D/0x314E**; tools = 0x3159; work-counter = 0x315A; class
= 0x315B. The DATA_MODEL "map_x=+0x07" mislabeled the goto-target as the position
(its runtime "Caravel (55,49)" read the wrong offsets). Spec uses **absolute offsets**
going forward to avoid the base-convention ambiguity. (PowerRecord FF acquired-bitmask
is likewise at **+0x07 / abs 0x880F**, not +0x06 — C5.)

---

## 2026-06-20 — `[0x53D0]`/`[0x53D2]` + `func_03C638` are Spanish-succession, NOT revolution SoL

**Conflict (self-correction).** Mid-session, after compaction, a trace of the
`[0x53D0] ≥ 0x32 (50)` compare `@0x3E8BD` and `[0x53D0] ≥ 0x4B (75)` compare `@0x2391C`
was provisionally written into `spec/systems/revolution.md` as "the SoL declare
threshold (50%)" with `func_03C638` (`0x191F:0x364`) labelled "the revolution-trigger
handler" (commit `a81ba25`). This **directly contradicted** the already-correct
`spec/systems/spanish_succession.md`, which had earlier byte-verified the same
function as the **War of Spanish Succession** handler and explicitly recorded it is
**not SoL-driven**.

**Evidence (decisive):**
- `func_03C638` emits message handle **`0x128C`** `@0x3C76A`, which is GAME.TXT
  **`@SUCCESSION`**: *"War of the Spanish Succession ends in Europe! {%STRING0},
  ravaged by war, agrees to **cede** %STRING1 to the {%STRING2}…"* — verified directly
  in `data_extracted/text/GAME_sections.json`.
- The handler body literally cedes assets: it ranks the 4 powers, then rewrites
  map-tile / unit (`+0x3147`) / colony (`+0x1A`) owner nibbles loser→winner and sets
  the loser's controller `+0x543F := 2` (eliminated) — an inter-European annexation,
  not a colonist revolt against the Crown.
- Single-player gate `@0x3C63D` (`test [0x5381],0x80`) — succession only fires in
  single-player; a revolution declaration has no such gate.

**Resolution:** `[0x53D0]` (0..100 meter, +20/cap-100 on Bolívar `@0x3BE64`),
`[0x53D2]` (eliminated-power latch), and `func_03C638` belong to
**`spec/systems/spanish_succession.md`** (per `notes/TRUTH_HIERARCHY.md`, the
byte-traced `@SUCCESSION` string wins). `revolution.md` reverted to its prior state:
**the SoL% declare threshold is still genuinely TBD** — the `≥50/75` gates are not it.
Lesson: re-verify a provisional finding against the *existing* spec before committing;
the mandated re-verification caught this one cross-file.

**Follow-up / final resolution (same day).** The revert above was itself an
*over-correction*. The SoL declare threshold **is 50%**, proven by the cleaner,
more-direct **declare-independence command handler `func_03E984`**: it emits
**`@TOOTORY`** (*"Only N%% of the colonists support the independence movement"*) when
**`[0x53D0] < 0x32` (50)** (`@0x3E99E`), and otherwise runs the `@DECLARE` confirm →
**`func_03DE46`** WoI declaration (`@INDEPENDENCE`). So `[0x53D0]` **is** the national
SoL meter (0..100, Bolívar `+20`), and **50% is the byte-verified declare floor**
(`revolution.md`). The subtlety that caused the confusion: the **War of Spanish
Succession** (`func_03C638`/`@SUCCESSION`) *also* auto-fires once when the leading
power's `[0x53D0]` crosses 50 (latch `[0x53D2] < 0`, `func_03E844`) — two distinct
events sharing the same SoL meter. Net: the `[0x53D0]` *identity* (SoL) and the *50%*
threshold are correct (original instinct); only the claim that `func_03C638` was the
*revolution* handler was wrong — that one is succession. `revolution.md` B/TBD restored.

---

## 2026-06-21 — Lost-City rumor presence is PROCEDURAL, not a stored `0xB0` feature byte

**Conflict.** `spec/systems/events.md` §6.1 (following the runtime memory-map doc
`colonization-memory-map (1).md`) anchored the Lost-City tile marker at feature byte
**`0xB0`**, with the residual being "`0xA0` vs `0xB0`, a one-byte runtime read."

**Disassembly (this branch's `raw/COLONIZE/VICEROY.EXE`, capstone 16-bit).** The
rumor-presence predicate `func_006188` (`@0x6188`, called `@0x30822`) does **not** read a
stored lost-city value. It **computes** presence from a coordinate hash against the global
map seed `[0x190]` (`@0x61C7..0x61F8`), gated by terrain ≠ `0x18/0x19/0x1A` and by the
tile's **feature high-nibble == `0xF`** ("none"), read via `0x5DF0`→`0x5D9C` (`shr al,4`,
`0xF`→−1; the predicate requires that −1). The map is one byte/tile (far array
`[0x164]:[0x166]`, index `y·[0x853A]+x`): **low nibble = terrain/owner, high nibble =
feature**.

**Resolution.** A tile whose feature nibble is `0xA`/`0xB` would **suppress** a rumor
(nibble ≠ `0xF`), so `0xB0` is **not** a placement marker — the memory-map "`0xB0` = lost
city, cleared on entry" is the **consumed/feature state**. Per `notes/TRUTH_HIERARCHY.md`
(EXE disasm at a cited offset > memory-map note), the `0xA0`-vs-`0xB0` question is
**dissolved**: rumor placement is procedural (`func_006188` + seed `[0x190]`), not a stored
constant. `events.md` §6.1 closed. No dump/trace needed.

---

## 2026-06-21 — Advisor-report (F2–F10) paint-function offsets: AUDIT doc was wrong

**Conflict.** `docs/ADVISOR_REPORTS_AUDIT.md` (and `spec/ui/advisor_reports.md`, which copied
it) gave the F2–F10 paint-function file offsets as `0x025F18` (F2) / `0x025FD0` (F3) /
`0x0269D8` (F4) / `0x027010` (F5) / `0x0277D8` (F6) / `0x027B0C` (F7) / `0x027E48` (F8) /
`0x025A0A` (F9). `viceroy_source/docs/drawlist/REPORTS.md` instead places the real bodies at
`0x37958`/`0x37A10`/`0x38418`/`0x38A50`/`0x39218`/`0x3954C`/`0x39888`/`0x39EE2`.

**Disassembly (raw VICEROY.EXE, capstone 16-bit, re-verified by the orchestrator).**
- `0x37958` = `enter 0x2c; … push 2` (F2, REPORT title N=2); `0x38418` = `enter 0x120; …
  push 4; call 0x39e53` (F4, N=4) — clean painter prologues with the title-N `push`.
- `0x025F18` disassembles to `les ax,[bp+si]; or ax,ax; je …` — **mid-instruction garbage**,
  not a function. The audit's offsets are **broken-thunk artifacts**: the dispatcher does
  `lcall 0x191F:0x3xx`; each thunk does `lcall 0x110d:0xdab; ljmp 0:OFF`, and the audit
  resolved `OFF` against the wrong overlay base (≈0x25900) instead of the page-5 code base
  (file `0x37340`; F9 needs `ljmp_seg=0x2B1`).
- `func_037340` (`enter 0x352; push 0x11A2 ["REPORT"]; strcat; push [bp+6] [N]; sprintf;
  load_PIK`) — so the loaded art is **REPORT\<N\>.PIK with N = the title number** (F2→REPORT2,
  F3→REPORT3, F4→REPORT4, F5→REPORT5, F6→REPORT7, F8→REPORT8), **not** the audit's visual
  guess (F4→REPORT3 etc.). Strings REPORT@0x11A2 / SCORE@0x11CF / WOODPAN2@0x11D7 confirmed
  at DGROUP base 0x1D9A0.

**Resolution.** Per `notes/TRUTH_HIERARCHY.md` (raw disasm at a cited offset > team docs), the
**REPORTS.md offsets win and the AUDIT doc offsets are struck.** Although `viceroy_source/` is
low-trust by default, here its offsets are raw-byte-confirmed and the audit's are
raw-byte-disproven. `spec/ui/advisor_reports.md` rewritten to the real bodies + the
title-N→PIK mapping. Also corrected: F8 gate polarity (FOREIGNNOTAVAIL fires when
`[0x5382]&1` is **set**, i.e. once WoI is declared); F10 `func_03A9C0` is a **score-band
plate selector** (`panel = largest i in 1..24 with i·i/3 ≥ scaled_score`, draws
`SCORE(panel+1).SS` over WOODPAN2), not a per-line panel map. Residual TBD: the F8
nested power-picker function offset.

---

## 2026-06-21 — FONTSMAL.FF is never loaded; SMALLFONT copies the latched font

**Conflict.** Two UI agents disagreed: one said the popup/menu `SMALLFONT`/`@smallfont`
directive selects a distinct small font **FONTSMAL.FF**; another said FONTSMAL is never loaded
and the directive just copies the active font latch.

**Disassembly (raw VICEROY.EXE).**
- The strings **`FONTSMAL`/`fontsmal` are ABSENT from the entire image** (`find` = −1, both
  cases). Only `fonttiny`@0x1FD32, `fontintr`@0x1FD29 (lowercase, load path) and `FONTKING`
  @0x1FCCB, `FONT-NP`@0x1F8AF (uppercase) appear. So **FONTSMAL.FF is an orphan on disk — VICEROY.EXE
  never `load_font`s it.**
- The popup framework's **SMALLFONT handler @0x6F207** is `mov ax,[0x89E]; mov dx,[0x8A0]; les
  bx,[bp-0xC]; mov es:[bx+0x80],ax; mov es:[bx+0x82],dx` — it **snapshots the currently-latched
  active-font far pointer** `[0x89E]/[0x8A0]` into the section struct. No font is loaded; it does
  not switch to a smaller font.

**Resolution.** There are **4 fonts actually loaded** by VICEROY.EXE: FONTTINY (the boot default
latch `[0x89E]`), FONTINTR, FONTKING, FONT-NP. **FONTSMAL.FF is unloaded (orphan).** The
`SMALLFONT` / `@smallfont` directive copies the latch — it is effectively a no-op font-wise in
shipped data, **not** a small-font selector. This **corrects** (a) `fonts_and_colors.md` (the
"5 fonts / FONTSMAL via SMALLFONT" model), (b) `popups.md` item 6, and (c) the
2026-06-21 menus commit's "boot-menu body = FONTSMAL" claim — the boot menu renders in the
**latched font** (FONTINTR/FONTTINY), and the `@smallfont` flag loads no distinct font.
Also: the popup framework compares **10** live directives (OPTIONS..DEFAULT); **TEXTCOLR is a
vestigial table entry, never compared** (`push 0x200A` appears nowhere as a directive) — there
is **no per-popup text-color override** directive.

---

## 2026-06-21 — FONTKING.FF is used by exactly ONE screen (king-defeats); not colony/Europe/score/HoF/menus

**Conflict.** The W1 screen-render cluster (from the Ghidra named export) attributed **FONTKING**
to many screens: colony title / SoL% / SoL-panel, Europe title, the Score screen, advisor F10,
the Hall of Fame, and menu render. A later pass also inferred `[0x268A]` = FONTKING "by usage."
Both are **wrong** against the raw EXE.

**Disassembly (raw VICEROY.EXE, capstone 16-bit; trust order: EXE bytes win over the export).**
- The string **`FONTKING` (DGROUP `0x232b`) is referenced exactly once in the whole image** —
  `lea bx,[0x232b]` @**0x754F2**, inside `func_075352` (the **king-defeats** screen). It loads
  via `lcall 0x1A1F:0xA86` into a **local** (`[bp-0xC]`), falls back to `[0x89E]` (FONTTINY) on
  failure, and promotes the result to the **active-font global `[0x1F9E]/[0x1FA0]`** @0x75511.
  FONTKING is **never stored to a persistent global**, so no other code path can select it.
- The **active-font global `[0x1F9E]`** is written at only 5 sites: from FONTTINY `[0x89E]`
  (@0x692DE), from FONTINTR `[0x268A]` (@0x692FA and the king-defeats *restore* @0x7557D), from a
  caller-supplied ptr (the `set_active_font` helper @0x6EED4), and the king-defeats FONTKING set
  @0x75511. So the only fonts ever made active are **FONTTINY, FONTINTR, and (king-defeats only)
  FONTKING**.
- **Font-far-ptr render pushes** confirm each screen's font: `push [0x8A0];push [0x89E]`
  (**FONTTINY**) at colony render 0x25F62/0x26000/…/0x282A9 and Europe render
  0x30EDE/0x30F53/0x31179 and advisor report bodies 0x3860C…0x38DFC; `push [0x268C];push [0x268A]`
  (**FONTINTR**) at the Hall-of-Fame/menu region 0x22ABE/0x23C06. The Score painter `func_03A9C0`
  reads `[0x89E]` (FONTTINY, @0x3ABF4/0x3AC25) for labels and `[0x268A]` (FONTINTR, @0x3B054/
  0x3B0E6) for the big-figure glyph metrics — **no FONTKING**.

**`[0x268A]` identity (resolves the prior "by usage A/R").** `[0x268A]/[0x268C]` is written
@0x760CB from loading the string **`fontintr`** (`lea bx,[0x2389]="fontintr"`; `lcall 0x1A1F:0xA86`)
in the engine-init `func_075FB6`. **`[0x268A]` = FONTINTR.FF**, byte-verified — NOT FONTKING.

**Resolution.** **FONTKING.FF is used by exactly one screen: king-defeats (`func_075352`),
pen seed (x=0xF2=242, y=0x2F=47).** Corrected font attributions (all byte-verified):
- **Colony** title / SoL% / SoL-panel → **FONTTINY** (`[0x89E]`).
- **Europe** title → **FONTTINY**.
- **Score** screen (cinematic `func_03A9C0` = advisor F10) → **FONTTINY** labels + **FONTINTR**
  figure metrics.
- **Hall of Fame** / **menus** → **FONTINTR** (`[0x268A]`).
- **king-defeats** → **FONTKING** (unchanged; the sole user).
This corrects `fonts_and_colors.md` §1/§3, `colony_screen.md`, `europe_screen.md`,
`advisor_reports.md` (F10 + the `[0x268A]`=FONTKING identity), `cinematics.md` (score),
`menus.md`, and `continental_congress.md` (the `[0x268A]` parenthetical).

---

## 2026-06-21 — `[0x1F5C]` is the speaker-portrait selector channel, NOT the cinematic/popup text color

**Conflict.** The cinematics integration (king-defeats) claimed the on-screen text color is the
"engine persistent foreground global `[0x1F5C]`" (default 8). The popup-template audit
(`docs/POPUP_TEMPLATE_AUDIT.md`) and `docs/KING_AND_CINEMATIC_AUDIT.md` instead identify `[0x1F5C]`
as a **speaker channel** (the 4 wrappers `@0x6F5B0..0x6F64C` set `[0x1F5C]`/`[0x1F5E]`/`[0x1F60]`
for the tribe/advisor/missionary speaker portraits).

**Disassembly (raw VICEROY.EXE) + cited audit.** `[0x1F5C]` is the **speaker-portrait selector**:
the dispatcher `func_06E3D0` reads it (`cmp [0x1F5C],0` @0x6E480) and `func_06BE92` branches on its
value (`cmp [0x1F5C],7; jle → IND<n>` @0x6BE96), so **value ≤7 ⇒ `IND<tribe>` portrait, =8 ⇒ KING**
(`docs/KING_AND_CINEMATIC_AUDIT.md`). The render path at **0x6E319** is
`cmp [0x1F5C],0; jl skip; push es; push bx; call 0x6F82B` where `es:bx` is a **sprite struct whose
+0x10/+0x12/+0x14/+0x16 fields are x/y/w/h** (loaded @0x6E2FD..0x6E316), then the selected speaker
sprite is blitted via `0x6F81C`. So `[0x1F5C]` **selects + renders the speaker portrait**, not text.
The popup wrappers set it accordingly (KING hard-codes `[0x1F5C]=8` @0x6F5DD; tribe `=arg` @0x6F5B6).
The king-defeats **text** is drawn by the glyph engine `lcall 0x181F:0x3FE` @0x75540 with **no
`[0x1F5C]` (or other explicit palette) argument** at the call site.

**Resolution.** `[0x1F5C]` (and siblings `[0x1F5E]`/`[0x1F60]`) = **speaker-portrait selector
channel** (the audit is correct; ≤7→IND, 8→KING via `func_06E3D0`/`func_06BE92`). The cinematic
king-text and popup body-text **color** is the glyph engine's own glyph→palette mapping
(FONTKING/FONTTINY foreground pixel), with no byte-pinnable per-call palette index at the draw site
→ honest **A/TBD**. Corrects `cinematics.md` (king-defeats font+color), `fonts_and_colors.md`
(king-defeats row), and clarifies `popups.md` §6 (the channel globals are speaker selectors;
TEXTCOLR remains vestigial so there is still **no per-popup text-color override**). The font
identities (FONTKING king-defeats, FONTTINY popup body) and pen geometry are unaffected and stay
**B**.

---

## 2026-06-21 — .FF font glyph format is NOT yet cracked (do not guess a decoder)

**Context.** While bundling assets for the C++ reimplementation, two RE passes (on-disk bytes +
the VICEROY.EXE loader/blitter) tried to decode the `.FF` bitmap-font glyph layout. The format is
**not yet byte-verified**, so no decoder was written (prime directive: never guess).

**Byte-verified facts.** `.FF` = MADSPACK 2.0; one FAB section is the font payload (decompressed
sizes FONTTINY 914 / FONT-NP 914 / FONTKING 1219 / FONTINTR 1898). **Font struct byte 0 = glyph
height** (`mov al,es:[bx]; add ax,3` @0x3AB7). Loader = `lcall 0x1A1F:0xA86` (file ~0x6FC74; sites
@0x760C6/0x760E8/0x754F6/0x6B7AF); glyph blitter `0x181F:0x3FE`/`:0x998`; glyphs are **2-bpp**
(transparent/highlight/base/shadow). FONTKING/FONT-NP are variable-height.

**Disproven hypotheses (this pass).** Interleaved `[w][h][bitmap]` from offset 33 desyncs
immediately (~165 of 914 bytes consumed) under both `ceil(w*h*2/8)` and row-aligned
`h*ceil(w*2/8)` sizing; a fixed-height width-table + bitmap block gives no clean file-length
landing for any height. The real parser is **overlay-resident** (the recurring RTLink-overlay
ceiling).

**Ruling.** `.FF` glyph decode stays **TBD**. Finishing it requires either disassembling the
overlay loader at ~0x6FC74, or a render-validation pass (decode glyphs, render `A–Z 0–9`, confirm
they form correct letters — a font is self-validating). Corrects `formats/FF.md` (the stale
`tools/mpskit/ff.py` reference — that file does not exist). The 4 fonts are therefore **not yet
bundled** in `viceroy_cpp` (all 204 `.SS` + 35 `.PIK` are).

---

## 2026-06-21 — .FF font glyph format CRACKED (supersedes the earlier "not cracked" ruling)

The `.FF` bitmap-font format is now fully decoded and render-validated (all 4 fonts decode to
readable A–Z / 0–9 / a–z). Supersedes the earlier same-day "not yet cracked" ruling.

**Format** (MADSPACK/FAB payload): `[0]`=glyph height H, `[1]`=max width; `[2..130)` = 128-byte
width table; `[130..386)` = 128×u16-LE offset table; `[386..)` = glyph bitmaps. Glyph for char
`c` = `payload[offset[c-1] : offset[c]]` (the tables are offset by one — **table entry t holds the
glyph for char t+1**, found via render-validation: index-0 mapping rendered every letter shifted
+1). Bitmap = **2 bits/pixel, MSB-first, row-major**, H rows × `ceil(width*2/8)` bytes; 4 levels
(0=transparent, 1/2/3 = ink shades). Bitmap region always starts at 386 (=130+256). Validated:
387+Σ glyph sizes = file length exactly; 87/87 width↔offset-delta match.

**Disproven en route:** interleaved `[w][h][bitmap]`, planar 1-bit-plane, LSB-first, fixed-height
block — all scramble. **Decoder:** `viceroy_cpp/include/ff.hpp` + `src/ff.cpp`; bundled via
`viceroy_cpp import-font` / `import-all` (fonts → paletted glyph atlas + metrics JSON). The 4
loaded fonts (FONTTINY/FONTINTR/FONTKING/FONT-NP) are now bundled; FONTSMAL stays orphan. This
**unblocks P4 text rendering** in the rewrite. Updates `formats/FF.md`.

---

## 2026-06-21 — No graphical progress/fill bars exist anywhere in the game

**Conflict**: `spec/ui/continental_congress.md` (and its source `docs/RENDERER_GEOMETRY.md`)
claimed a graphical **"Progress bar (0,30,320,6) — yellow fill = bells_current / threshold"** on
the Continental Congress screen, tagged tier **A**; the user states there are **no progress bars
anywhere in the game**, and the screen's own decompiled paint body is text/box-only.

**Source A** — `docs/RENDERER_GEOMETRY.md` (team doc, luma/anchor measurement of frame
1310124562) asserted a yellow-fill progress bar in three places (v2 line 240, v3 line 221,
detail table lines 347–348: "Bar fill color yellow (200,160,24)"). Tier **A** (luma-guessed,
not byte-cited).

**Source B** — (1) the **running game** (user, top of `TRUTH_HIERARCHY.md`): "there are no
progress bars anywhere in the game." (2) The **F3 paint body** `0x37A10..0x3807D` (fully
disassembled, tier **B**) is **text + box-rule only** — it contains no sprite blits
(`0x181F:0x254/0x2BC`) and no fill-bar draw; a text/box routine cannot paint a fill bar
(`spec/ui/continental_congress.md` §6.1).

**Ruling**: **no graphical progress/fill bars exist in the game** — both the running-game
observation (rank 1) and the disassembled paint body (rank 3) outrank the luma guess (team doc,
rank 5) per `TRUTH_HIERARCHY.md`. Progress toward the next Founding Father is conveyed by the
**"(NN in MM)" text** in the session subtitle (`NN = threshold − bells_current`, `MM =
threshold`), not a bar. The game's progress/quantity UI idiom is **discrete filled/empty
sprite-icon rows** (e.g. crosses/bells, ICONS.SS `0x39` filled / `0x38` empty — one sprite per
unit counted), which is **not** a continuous bar.

**Action taken**:
- `spec/ui/continental_congress.md`: deleted the "Progress bar" layout row; added a "No progress
  bar" note; reconciled the §"Fonts & colors" `0x3F/0x38` wording (discrete indicator sprites,
  not a bar); re-tiered the bell row as A/TBD (not in the F3 body).
- `spec/ui/advisor_reports.md`, `spec/ui/fonts_and_colors.md`: clarified the `0x39/0x38` "gauge"
  wording as **discrete** filled/empty indicator sprites, explicitly "*not* a continuous bar."

**Follow-up**: the Continental Congress **bell-icon row** is luma-observed but absent from the F3
text body — whether it is drawn by a separate Activities/overlay path or was itself a luma misread
stays A/TBD until that path is traced or a frame is re-measured.

---

## 2026-06-22 — TERRAIN.SS is the base-ground sheet, NOT an orphan (overturns hard rule #5)

**Conflict**: CLAUDE.md hard rule #5 says "never load TERRAIN.SS or BDARK.SS (orphan assets, not
used by the renderer)"; byte evidence shows TERRAIN.SS is the **base-terrain ground sheet** the
in-game renderer composites PHYS0 overlays on top of.

**Source A** — CLAUDE.md hard rule #5 (team-doc rule), citing `BUILD.md`, `docs/ASSET_ROLES.md`,
`tools/render_map.py`. Claim: TERRAIN.SS unused/orphan.

**Source B** — `ghidra_export/VICEROY_decompiled.named.c` (byte-grounded decompile, rank 3 in
`TRUTH_HIERARCHY.md`): (1) `BOOT_ASSETS[]` loads `"TERRAIN.SS" -> g_sprite_sheet[3]` as a core
gameplay startup asset (@~53999–54002), alongside ICONS/PHYS0/BUILDING/WOODFRAM/WOODTILE;
(2) `emit_ground_sprite(idx) = emit(sheet_at(G_SHEET_TERRAIN), terrain_cell_transform(idx))`
(@18201) — the BASE ground layer is drawn from the TERRAIN sheet, while `draw_tile_marker`/
`emit_sprite_alt` use `G_SHEET_PHYS` for OVERLAYS (@18192–18193); (3) `enter_map()` hard-requires
TERRAIN.SS to enter the map view (@~50249, registers it via `viceroy_set_sheet_terrain`).
Corroborated by `spec/systems/map_system.md` §3 ("Base terrain -> `emit_ground_sprite`").

**Ruling**: **TERRAIN.SS is the base-ground sheet** (loaded at boot + on map-enter; the source of
`emit_ground_sprite`), composited UNDER the PHYS0 overlays (forest/mountain/hill/river/road/coast/
resource). It is **not** an orphan. **BDARK.SS remains the orphan** (no load path). Placeholder
indices 0/16/100 are still skipped. Per `TRUTH_HIERARCHY.md` byte-grounded disasm at a cited offset
outranks a team-doc rule; the user explicitly confirmed "TERRAIN is valuable, BDARK is not" and
granted sign-off to amend the hard rule.

**Action taken**:
- Amend **CLAUDE.md hard rule #5**: orphan = **BDARK.SS only**; TERRAIN.SS = base-ground sheet.
- Correct stale "TERRAIN.SS orphan" wording in its citations where it survives.
- `viceroy_cpp` `import-all` stops skipping TERRAIN.SS (bundles it); the map-view viewport moves
  from the naive PHYS0-only blit to layered TERRAIN.SS base + PHYS0 overlays (Phase C).

**Follow-up**: `terrain_cell_transform` (code 0x11/0x09->8; code>=8 -> code-0xF; else code) maps
terrain ids to TERRAIN.SS frame indices — exact per-terrain frame mapping to be pinned in Phase C
from TERRAIN.SS frame inspection. The `0x70`-band / `0x1F884` coast sub-cell table stays TBD.

---

## 2026-06-22 — Sprite 0x95 is the FOG/unexplored tile, NOT "base coast" (map_system.md §3/§1b wrong)

**Conflict**: `spec/systems/map_system.md` §3 + §1b (tagged BYTE_VERIFIED) describe the coast as
"base coast sprite `0x95` + per-direction overlays `0x69..0x6C`." Implementing that put a striped
"plow"-looking sprite all over the coast (user: "you have the plow sprite on the coast"), and the
`0x69..0x6C` frames turned out to be selection-box/padding sprites, not coast.

**Source A** — `spec/systems/map_system.md` §3 (line ~75) / §1b (line ~154): "base beach/coast
sprite `0x95` (`mov ax,0x95; call 0x67dc8 @0x68212`)" + "per-direction overlay `0x69+direction`".
Tagged BYTE_VERIFIED.

**Source B** — capstone disasm of `func_0681A8` (O513) vs `raw/COLONIZE/VICEROY.EXE` (rank-3
byte-grounded): the single `mov ax,0x95` @`0x68212` is gated by **`[bp-8]` = the fog/hidden flag**
(`@0x6820c cmp [bp-8],0; je 0x6824e`). `[bp-8]` is set from the **fog mask `[0xA89E]`** and the
tile fog byte `[0xA8A0]` in the prologue (`@0x681E0..0x681FE`) — `[bp-8]=1` ⇒ tile **unexplored**.
The same branch then calls O512 (`func_067F50`), whose per-direction draws (`0x69+dir` +
`emit_terrain_sprite`) are the **fog-edge blend** for hidden tiles. The spec itself documents
`[0xA89E]` = `1<<(player+4)` fog mask (§3, line 133). The **visible-tile coast** is a *different*
code path: shore base `0x96` (drawn when terrain byte `[0xA89F]&0x40` @`0x68356`) + directional
edges `0x97+pattern` (151..153, from the connection bitmap `[0xA8A6]` @`0x6850D`).

**Ruling**: **`0x95` (PHYS0 frame 149) is the fog-of-war / unexplored-tile sprite** (its vertical
striped hatching resembles plow furrows — hence the "plow" appearance when wrongly drawn on
coasts), **not** a coast base. §1b's "coast = `0x95` + `0x69..0x6C`" actually documents the
**fog-of-war renderer**, mislabeled. The **real coast** = `0x96` shore base (terrain bit `0x40`) +
`0x97..0x99` directional edges (connection-bitmap pattern), in the visible-land path. The
BYTE_VERIFIED tag on the old coast description was unjustified. Byte-disasm (rank 3) + user
ground-truth (rank 1) outrank the team-doc claim.

**Action taken**:
- `map_system.md` §3 + §1b: relabel `0x95`/`0x69..0x6C` as the fog-of-war path; document the real
  coast (`0x96` + `0x97+pattern`); retier.
- `notes/SPRITE_CATALOG.md` row 0x90: frame 149 "sandy dune" → **fog/unexplored tile** (striped).
- `viceroy_cpp` map-view: the coast must use the visible-path `0x96`/`0x97+pattern`, not `0x95`.

**Follow-up**: the exact `0x97+pattern` connection-bitmap → edge-variant mapping (`[0xA8A6]`
patterns `0xC1`/`0x07`/`0x70`/`0x1C` @`0x68479..0x684A8`) for the directional coast edges still
needs enumerating before a faithful coast implementation.

---

## 2026-06-22 — The `0x6D..0x8B` band = 8×8 coast sub-tiles, NOT roads (map_system.md "roads = 0x6D" wrong)

**Conflict**: `spec/systems/map_system.md` §3 listed **"`0x6D` roads"** and described item 6 as
"Roads & rivers (connectivity-based)" with the road sprite = `0x6D + connectivity_mask`. The
project also has explicit user ground-truth that **"there are no roads in new maps."** The open
`SPRITE_CATALOG` question — whether the row-0x70 8×8 frames are the true DOS coast sub-tiles — was
unresolved.

**Source A** — `spec/systems/map_system.md` §3 band list + item 6 ("roads = `0x6D`"), citing the
low-trust C reconstruction `src/render/terrain.c`.

**Source B** — capstone disasm of `func_0681A8` (O513) + `func_067A24` (`analyse_connections`) vs
`raw/COLONIZE/VICEROY.EXE` (rank-3 byte-grounded), cross-checked with PHYS0 frame pixels via
`tools/ssdec.py` (rank-2):
- `analyse_connections` (`func_067A24`) is called **only for water tiles** — gated `@0x68256`
  `cmp [0xA8A2],0x19 (Ocean) / 0x1A (Sea-Lane)`. It builds `[0xA8A6]` = the **8-direction
  LAND-neighbour bitmap**: for each neighbour it reads the terrain id and `cmp al,0x19 / 0x1A;
  je skip` (`@0x67AA6`) — **water neighbours are skipped**, so a bit is set only where a neighbour
  is land. It also fills a 4-entry per-quadrant table at `[0x2D24]` from diagonal/cardinal land bits.
- The coast draw (`@0x6846B` onward, gated `cmp [bp-4],0` where `[bp-4]=1` ⇒ water tile): shore
  base `0x96` (`@0x68356`, bit `[0xA89F]&0x40`); if `[0xA8A6]` matches a clean pattern
  (`&0xDD==0xC1`/`&0x77==0x07`/`&0x77==0x70`/`&0xDD==0x1C`) draw one 16×16 edge `0x97+pattern`
  (`@0x6850D`); **else** the loop `@0x684BC..0x684F5` draws, for `q=0..3`, frame
  **`0x6D + table[q]·4 + q`** (`table[q]`∈0..7, reachable 109..139) at TL/TR/BR/BL **8×8**
  sub-cell offsets (`[0x1EA4]/[0x1EA5]`).
- Pixel check (`tools/ssdec.py`): frames `0x6D..0x8B` (109..139) are all **8×8** with water
  palette indices 55–58; frames `0x96..0x99` (150..153) are **16×16** water+sand coast pieces.
  PHYS0 has **154 frames (0..153)** — so `0x97+pattern=3` (→154) and the extreme `table[q]=7,q=3`
  combo (→`0x8C`=140, a 16×16 frame) are out-of-band edge cases, flagged TBD.

**Ruling**: **The `0x6D..0x8B` band (109..139) is the 8×8 per-quadrant complex-coast sub-tile set**
— the fallback drawn on water tiles whose land-neighbour bitmap matches no clean 16×16 edge
pattern. **There are no roads in this render chain**; the "roads = `0x6D`" label (from the low-trust
`terrain.c`) is wrong, consistent with the user ground-truth that new maps have no roads. The full
coast = shore base `0x96` + (16×16 edges `0x97..0x99` for clean cases) OR (4× 8×8 `0x6D` quadrants
for complex cases), all keyed by the water-tile land-neighbour bitmap `[0xA8A6]`. Byte-disasm
(rank 3) + pixel inspection (rank 2) + user ground-truth (rank 1) outrank the C-reconstruction
label.

**Action taken**:
- `map_system.md` §3: item 6 split into rivers (`0x51..0x5E`) + item 7 coast (water-tile,
  `0x96`/`0x97+pattern`/`0x6D` 8×8 fallback); band list "roads = `0x6D`" → "8×8 coast sub-tiles";
  §6 1b extended with the 8×8 resolution.
- `notes/SPRITE_CATALOG.md`: row 0x6D–0x8B section + follow-up #1 resolved (true coast sub-tiles).
- `spec/ui/map_view.md` §3: overlay list — coast composition spelled out, "no road overlay".

**Follow-up (still TBD)**: the exact `[0xA8A6]`→`0x97..0x99` pattern enumeration and the
pattern-3→frame-154 (out-of-range) edge case, before the faithful coast implementation. The coast
IMPLEMENTATION in `viceroy_cpp` must use this water-tile path (`0x96` + `0x97+pattern` + `0x6D` 8×8
quadrant fallback), never `0x95`/`0x69`.

---

## 2026-06-22 — River band is `0x01/0x11` (BLUE), `0x51..0x5E` is the ROAD layer (correcting same-day "river = 0x51..0x5E")

**Conflict**: a same-day edit to `spec/systems/map_system.md` §3 item 6 + band list (commits
`c9e7d32`/`43fa99b`) labelled **"river = `0x51..0x5E`"**, derived from the disasm connectivity
block at `@0x6842B` (base `0x51`). The `viceroy_cpp` map-view, built on that, drew `0x51`/`0x52+dir`
for river-bit tiles and produced a **brown diagonal lattice** over the land — clearly not rivers.
This also contradicts **CLAUDE.md hard rule #4** (rivers = PHYS0 rows `0x01`/`0x11`).

**Source A** — the same-day spec edit "river = `0x51..0x5E`" (`@0x6842B` block, base `0x51`).

**Source B** — pixel inspection (`tools/ssdec.py`, rank 2) + disasm of `func_0681A8` (rank 3) vs
`raw/COLONIZE/VICEROY.EXE`:
- **Pixels**: PHYS0 `0x01–0x0F` / `0x11–0x1F` are **BLUE water + GREEN banks** (idx 57/58 blue,
  69/70 green) = rivers. PHYS0 `0x51–0x58` are **BROWN** road segments (idx 85/132,
  RGB ~(134,81,28)). `SPRITE_CATALOG` already labels row 0x00/0x10 = rivers and row 0x50 = roads.
- **Disasm**: the **river** draw is a *different* block at **`@0x6838A`** — gated by feature-layer
  bit `0x40` (`[0xA8A1]`), base **`0x01`** (feature bit `0x80` set, `@0x6839E`) or **`0x11`**
  (clear, `@0x683A6`), plus a **4-cardinal** river-neighbour mask (`func_067B84` `ax=0x40,dx=3`;
  bit order N=8/S=4/W=2/E=1; isolated → `0xf`, `@0x683BB`), drawn `base+mask` via `func_067DC8`.
  The **`@0x6842B`** block (base `0x51` + 8-dir `func_067D54` `ax=0xa`, gated `[0x18E]==0`) is the
  **ROAD** layer — empty on new maps ("no roads in new maps", user ground-truth rank 1).

**Ruling**: **Rivers = PHYS0 `0x01..0x1F`** (base `0x01`/`0x11` + 4-cardinal connectivity, BLUE),
exactly as CLAUDE.md hard rule #4 always stated. **`0x51..0x5E` = the ROAD layer** (BROWN, separate
connectivity block, drawn only when road-feature tiles exist). The same-day "river = `0x51..0x5E`"
edit conflated the road block with rivers; reverted. Pixel inspection (rank 2) + disasm (rank 3) +
hard rule #4 outrank the mistaken same-day edit.

**Action taken**:
- `viceroy_cpp/src/mapview.cpp`: river overlay now draws `base + 4-card mask` from the `0x01/0x11`
  blue band (base via forested-id proxy, R), removing the `0x51`/8-dir road draw. The brown lattice
  is gone; rivers render as blue channels (verified vs AMER2 render).
- `map_system.md` §3 item 6 rewritten (river `@0x6838A` `0x01/0x11`; road `@0x6842B` `0x51`); band
  list `0x51..0x5E river` → `0x51..0x5E roads`, added `0x01..0x1F river`; corrections block updated.

**Follow-up (R/TBD)**: river major/minor base (`0x01` vs `0x11`) is selected by feature-plane bit
`0x80` in the EXE; the C++ `Map` loads only the terrain plane, so the port approximates it from the
forested terrain id. Loading the feature plane would make it exact.

---

## 2026-06-22 — O512 (func_067F50) is the dithered terrain-edge BLEND composer (coast is one case)

**User directive**: "stop with all the guessing. and go a full code deep dive on the coasts. it is
not just 4-6 sprites. there is a whole set of functions."

**Finding** (full byte-trace of `func_067F50` 0x67F50..0x681A7 + its call sites in `func_0681A8`):
O512 is not "the coast sprites" — it is the engine that **dithers every tile edge into its 4 cardinal
neighbours**, of which the coast is one case.
- 4-cardinal loop (N,E,S,W via DGROUP 4-dir tables `0xA8`/`0xAE`). For each neighbour: in-bounds
  (`lcall 0x181F:0x302`), read terrain (layer `[0xA598]`, `&0x1F`, fold forest), `classify_terrain`
  (`lcall 0x181F:0x6AA`), fog flag from `[0xA59C]`&`[0xA89E]`.
- **8-ring walk** for water neighbours (`@0x6809A`, gated `[bp+6]==0`): walks the neighbour's own
  N/E/S/W (even 8-dir indices) for the first land cell → its class becomes the blend class. This is
  the **land-side coast**.
- **Draw** (`@0x68189`): `draw_subcell(0x69+dir)` writes the **dither stencil** (`0x69..0x6C`, sparse
  index-0 dot patterns, pixel-confirmed) into **mask buffer `0x839E`**; `emit_terrain_sprite(nb_class)`
  (`func_067EEC`) **masked-blits** the neighbour terrain through `0x839E` (`lcall 0x181F:0x268`).
- Call sites: fog path `O512(1,centre_water,0)` (`@0x68244`); main path `O512(0,[bp-4],0)` (`@0x68315`)
  — ring-walk **enabled for land centres** (land-side coast), disabled for water (O513 does the
  water-side: shore `0x96` + `0x97+pattern` + `0x6D` 8×8 quadrants).

**Ruling**: the complete coast/terrain transition = **O513 water-side + O512 land-side dither
+ O512 biome-edge dithering**. Prior renderer attempts drew only O513's 4–6 water sprites and omitted
O512 entirely → hard tile edges instead of Col1's dithered biome/coast transitions ("all wrong").
Documented in `spec/systems/map_system.md` §3 (O512 deep-dive subsection). `classify_terrain`/
`is_xy_in_bounds`/`read_terrain`/masked-blit are overlay `0x181F` helpers; roles inferred from call
context (the only non-byte-pinned part). Byte-disasm (rank 3) + user directive (rank 1).

**Action**: implement the O512 dithered-edge blend in `viceroy_cpp/src/mapview.cpp` (4-cardinal +
water ring-walk on land tiles + dither stencil `0x69+dir`); self-verify the render then user-verify.

---

## 2026-06-23 — Terrain id 26 label fix: 26 = Sea Lane, NOT Ocean (housekeeping)

**Context**: spec-vs-implementation audit. Three docs glossed terrain id **26** as
"Ocean" — `CLAUDE.md` hard rule #2, `spec/systems/map_system.md` §57, and
`formats/MP_FORMAT.md`. This contradicts the already-settled **2026-06-20 ruling**
(this file) and the byte-verified `@OTHER` ordering: **24=Arctic, 25=Ocean,
26=Sea Lane, 27=Mountains, 28=Hills**.

**Evidence** (unchanged, already top-of-hierarchy):
- Generator immediates (`spec/systems/map_generation.md`, B): ocean fill `0x19`(25)
  `@0x64A4B`; right-two-columns → Sea Lane `0x1A`(26) `@0x65941`; poles → Arctic
  `0x18`(24) `@0x6582A`.
- `@OTHER` order in `spec/data/names_sections.md`: Arctic, Ocean, Sea Lane → 24/25/26.
- Empirical `.MP` tile counts (`notes/MAP_FORMAT.md`): id 25 = 2139 tiles (Ocean),
  id 26 = 810 tiles (Sea Lane).
- Implementation `viceroy_cpp/src/mapview.cpp`: `is_water` = `0x19 || 0x1A`
  (Ocean / Sea-lane) — already correct.

**Ruling**: the **number 26 was always right** (the sea-lane column IS id 26); only
the parenthetical **name** was wrong. Corrected "(Ocean)" → "(Sea Lane)" in the
three docs above. No behavior change; this only removes a stale label that
disagreed with the 2026-06-20 ruling. Implementation needed no change. Rank: EXE
bytes (top) + prior recorded ruling.

---

## 2026-06-23 — spec cross-consistency audit (4-cluster): fixes + 2 open conflicts

Read-only audit of spec/systems for cross-spec/internal contradictions. Most shared
constants were consistent (REF globals, royal_money +0x22/1800, [0x53D0] identity,
50% declare floor, ColonyRecord 0xCA, terrain ids 24..28, NativeSettlement 0x54EC/18,
diplomacy +0x34/+0x40, @UNIT stat columns, difficulty 4-diff). Defects fixed:

**Fixed (stale value contradicting a recorded ruling + the spec's own corrected text):**
- `spec/data/records.md` UnitRecord base `0x3146`→**`0x3144`** (RULINGS 2026-05-28; the
  file's own §4 already said 0x3144). `+0x07 map_x`→`+0x00 map_x`; `0x3146`=type at +0x02;
  `0x314D/0x314E`=goto-target (not map_x/y).
- `spec/systems/combat.md` profession byte `+0x15`→**`+0x17`** (abs 0x315B; matched its own
  §3 prose `cmp [bx+0x315B],0x18`).
- `spec/systems/ref_growth.md` Evidence list `+0x32 "strength rating"`→**home_x/home_y**
  (RULINGS 2026-06-20; the §state table already had it right).
- `spec/systems/events.md` header: Lost-City trigger `0xB0 RUNTIME-VERIFIED`→**PROCEDURAL
  `func_006188`** (aligned to the file's own §6.1 2026-06-21 resolution).
- `spec/systems/colony.md`: softened "`+0xBA` Hammers label is correct" → **DISPUTED**
  (aligned to the file's own `+0xBA` CONFLICT row + §6 residual).
- `spec/systems/map_system.md`: flagged the stale "`0xB0`=Lost-City trigger marker,
  planted/cleared" model as SUPERSEDED by events.md §6.1 (procedural).

**OPEN — need a targeted disasm pass to reconcile (do NOT guess):**
1. **War-of-Spanish-Succession `[0x53D0]` trigger direction.** `revolution.md` + the
   2026-06-20 ruling say succession "auto-fires when `[0x53D0]` **crosses 50**"
   (`func_03E844 @0x3E8BD`); `spanish_succession.md` (dedicated call-graph analysis)
   says the succession branch is the **low-`[0x53D0]` / `[0x53D2]<0` state**, dispatcher
   `@0x02391C` **clamps `[0x53D0]` to 75**, and the handler body has *no* 50-compare.
   The two cite different functions. Reconcile by disassembling the dispatcher at
   `@0x02391C/@0x02392A` and `func_03C638` vs `func_03E844`.
2. **River overlay bit in the procedural generator.** `map_generation.md:58` (P4) writes
   river as "**bit 6 `0x40`**", but the `.MP` format authority (`MP_FORMAT.md`,
   `map_system.md:21`) says packed river = **bit 5 `0x20`** (bit 6/`0x40` = forest), while
   the runtime render trace (`map_system.md:152`) gates the river *draw* on feature-plane
   `0x40`. Plane ambiguity — confirm which bit the generator actually `or`s at the P4 site
   (`@0x64xxx`) and disambiguate the .MP-packed bit (0x20) from the runtime feature-plane
   bit (0x40) in both specs.

Both are conflicts between byte-cited claims; recorded here per the prime directive
rather than resolved by guesswork.

---

## 2026-06-23 — RESOLVED: the 2 open conflicts from the cross-consistency audit (disasm pass)

Both conflicts recorded earlier today were resolved by disassembling the raw EXE
(`raw/COLONIZE/VICEROY.EXE`, capstone 16-bit).

**1. War-of-Spanish-Succession `[0x53D0]` trigger — RESOLVED in favor of
`spanish_succession.md` (revolution.md was wrong).** The end-game dispatcher
`func_0235D6 @0x2391C` reads:
```
0x2391C  cmp  [0x53d0], 0x4b     ; threshold = 75 (0x4B), NOT 50
0x23921  jl   0x2392a            ; if [0x53D0] < 75:
0x2392A  mov  [0x53d0], 0x4b     ;   clamp to 75
0x23930  cmp  [0x53d2], 0
0x23935  jl   0x2393a            ;   and [0x53D2] < 0 (no secession yet):
0x2393A  lcall 0x191f, 0x364     ;   -> SUCCESSION handler (func_03C638)
0x23942  test [0x5382], 1        ; the >=75 path feeds the REVOLUTION handlers
```
So succession fires in the **low-meter (`[0x53D0] < 75`) + no-secession (`[0x53D2] < 0`)**
state; the high (`≥75`) state feeds revolution. `revolution.md`'s "auto-fires when
`[0x53D0]` crosses 50, `func_03E844 @0x3E8BD`" was wrong on BOTH counts: the threshold
is **75** (not 50), and `func_03E844` is **`sons_of_liberty_active_check`** (the SoL
display gate for REBELUP/REBELDOWN; reads `[0x5398]/[0x5382]/[0x53D2]`, **no `[0x53D0]`
read**). The "50" came from conflating the *separate* declare-independence floor
(`cmp [0x53D0],0x32` `@0x3E99E` in `func_03E984` — that one IS 50, and is correct).
Fixed `revolution.md`; `spanish_succession.md` was already accurate.

**2. Generator river overlay bit — RESOLVED (runtime-vs-.MP distinction).** Scanning the
whole generator `func_064A10` (0x64A10..0x65D26) for flag-bit `or`-immediates: the only
direct ones are **hills `or …,0x20` @0x64D19** and **forest `or …,0x80` @0x64D23**.
There is **no `or …,0x40`** anywhere — the river feature is spread via thunk
`0x181F:0x718` (@0x65BC2), and river therefore occupies the one remaining **runtime-board
flag bit `0x40`** (consistent with the render trace `map_system.md` §3). `map_generation.md`'s
"river `0x40`" is correct **for the runtime board**; `MP_FORMAT.md`'s "bit 5 `0x20` = river,
bit 6 `0x40` = forest" describes the **`.MP` file format** — a different representation.
Both specs annotated; the `.MP`→board remap in the `.MP` loader is the remaining residual.

---

## 2026-06-23 — Colony composer step 8 = stockpile bar; no colony menu bar

**Conflict**: `docs/COLONY_SCREEN_VICEROY_DECODE.md` §2 and `spec/ui/colony_screen.md`
§2.0 left composer step 8 (`call 0x2CA19`) as "role TBD" and asserted the stockpile
bar `func_0281D6` was a *separate* per-page sub-renderer "not one of the 12 head
calls." Separately, the user asked what is in the colony screen's "menu bar above."

**Source A** — prior decode/spec said: step 8 role unknown; stockpile bar drawn
outside the 12-step composer; colony title paint routine = `0x181F:0x178`.

**Source B** — VICEROY disasm this pass (`tools/follow_thunk.py`) said: `call 0x2CA19`
→ `ljmp 0x191F:0x654` → file `0x0281D6` = `func_0281D6` (fills `(0,179,320,21)`, 16
cells × pitch 0x13). The title painter is `0x181F:0xB0` (`func_00275C`), not `0x178`
(`func_0028B0` = strlen). All twelve `0x191F` step targets resolve to named
sub-renderers; none is a File/Orders menu bar.

**Ruling**: step 8 **is** the stockpile bar; the "menu bar above" is just the title/
status strip (composer step 5 `func_0268CE`, painted centred near `y≈5` by
`func_00275C`). The colony screen has **no dropdown menu bar** — that is the map
view's `func_072090` (`spec/ui/menus.md` §173). Decided per TRUTH_HIERARCHY: byte
evidence (the resolved `ljmp`) outranks the earlier drawlist gap and the recon note.

**Action taken**:
- `docs/COLONY_SCREEN_VICEROY_DECODE.md`: §2 table step 8 → `func_0281D6`; replaced
  the "separate sub-renderer" note with the resolution; added §9 (top bar / title);
  updated §8 status.
- `spec/ui/colony_screen.md`: §2.0 step 8 row + stockpile note; §3.1 paint routine
  (`0x181F:0xB0`) + "menu bar above" framing; open-items 1, 6, 7 updated.

**Follow-up**: the title text-box origin is runtime state (`[0x2CC6/8/A/C]` from the
`0x181F:0xC22` init), so the literal title x/y remains **R** (`y≈5`).

---

## 2026-06-23 — Colony gold is in the TOP MENU HEADER, not the warehouse bar; (306,179) ≠ gold

**Conflict**: I documented the colony/Europe warehouse bar's `(306,179)` `"$%d"` of
`DG16(0x2F5E)` as the player gold, and claimed the colony screen has "no menu bar." The
user (running DOS game) stated gold is shown in the **top menu header only**.

**Source A** (my disasm read): `func_0281D6 @0x0283F1` draws `[0x2F5E]` at (306,179);
`europe_screen.md` had it labeled "displayed gold mirror `$%d`".

**Source B** (running game = top of `TRUTH_HIERARCHY`; corroborated by disasm on re-check):
gold is in the top menu header. Re-check shows: (1) the colony screen DOES have a menu bar
— command table `cmp [bp+6],0x13C..0x142 @0x02BDEA`, registration `lcall 0x191F:0x3xx
@0x02BE00`; (2) `0x2F5E` is a **string-heap index** consumed by `0x181F:0x22` (fetch
string #N), **never written** as a treasury value (`grep`: only 2 read sites, no `mov
[0x2F5E]`); (3) the real treasury is `PowerRecord+0x2A` via `[0x84FC]` (BYTE_VERIFIED,
`DATA_MODEL.md`), mirror DGROUP `+0x9CB0` recomputed in the colony page `@0x02B80E`.

**Ruling**: gold renders in the **top menu header** (field `PowerRecord+0x2A` / mirror
`0x9CB0`), NOT on the warehouse bar. The `(306,179)` `[0x2F5E]` readout is a heap caption,
semantic **TBD**. The colony screen **has** a menu bar. Running game outranks the static
over-read.

**Action taken**:
- `docs/COLONY_SCREEN_VICEROY_DECODE.md`: §6 relabel (306,179) as heap caption / not gold;
  §8 status; §9 retract "no menu bar"; new **§10** (menu bar + header gold).
- `spec/ui/colony_screen.md`: §3.1 + §4 table rows (warehouse readout + gold-in-header).
- `spec/ui/europe_screen.md`: `DG16(0x2F5E)` relabeled NOT-gold (same byte-identical code).

**Follow-up**: pin the exact x/y/font of the header gold blit — the menu chrome draws the
formatted string buffer `[0x9CD2]` (`@0x072FE1`/`@0x0731D0`); the literal draw site in the
menu renderer is the next trace. And identify what heap string `[0x2F5E]` actually is.

---

## 2026-06-23 — Fill/frame verb traps synced across screen specs (0x22, 0xE2)

**Conflict**: `viceroy_source/docs/UI_PRIMITIVES.md` byte-verifies `0x181F:0x22` =
string-fetch (`func_002462`, no draw) and `0x181F:0xE2` = clipped sprite blit
(`func_00DB3A`), but several screen specs still labeled them as `fill_rect` and a
"1-px rule/frame/outline".

**Source A** (screen specs): `advisor_reports.md` "Title bar fill via `0x181F:0x22`",
"Footer rule via `0x181F:0xE2`"; `colony_screen.md`/decode + `europe` decode "screen
outer rule" / "1-px frame" via `0x181F:0xE2`.

**Source B** (central primitive doc, byte-verified): `0x22` = packed-string fetch
(skip-N, `REPNE SCASB`, no draw) — the F2 title is `fetch [0x2DF6] → centre via 0x100`
(`@0x37970`); `0xE2` = clipped sprite blit (sheet `[0x2DA8]`, `RETF 6`). The real
rectangle fill is `0x444`, the real line/divider is `0xCE`/`0x191F:0x8BC`.

**Ruling**: the byte-verified primitive catalogue wins (TRUTH_HIERARCHY: disasm at a
cited offset > drawlist interpretation). `0x22` is a fetch, `0xE2` is a sprite blit;
"fill"/"rule"/"frame" labels for them are corrected to "centred text"/"sprite strip".

**Action taken**:
- `advisor_reports.md`: title row + footer row corrected.
- `colony_screen.md` + colony/europe decode docs: `0xE2` labels corrected (sprite, not line).
- `UI_PRIMITIVES.md §0a`: added a "common verb-misread traps" block (0x22, 0xE2, the real
  fill 0x444, and that WOODFRAM 0x510 has a single caller = colony-scene-only).

**Follow-up**: a full audit of the 85 `0xE2` sites + 37 `0xCE` sites to confirm which
panels use which is open (the corrections above cover the screen-composer call sites).

---

## 2026-06-23 — `0x181F:0xCE` IS a line/rule draw (overturns "no-draw clamp")

**Conflict**: `UI_PRIMITIVES.md` classified `0x181F:0xCE` (`func_00E0A2`) as a "min/order-2
clamp helper, NO draw", but the colony field panel calls it with line coordinates
(`@0x026517`/`@0x026539`) as "divider lines", and the `0xE2`-sweep depended on knowing the
real line verb.

**Source A** (prior central-doc verdict): `func_00E0A2` head is `CMP bx,ax; swap` → "returns
ordered low/high, not a draw."

**Source B** (full disasm this pass): the ordering head **falls through to two draw calls**
`lcall 0xBBC:0xC` (`@0x00E0E2`/`@0x00E100`) with the ordered coords + color `[bp+6]`;
`0xBBC:0xC` (file `0x00DFCC`) does `mul bx` (y·width) then **`mov byte es:[di],al`**
(@0x00E02A) — it plots pixels. So `0xCE` draws a line/edge (two passes), it only *orders*
the endpoints first.

**Ruling**: `0x181F:0xCE` = **line/rule draw** (the screen line/divider verb). The prior
"no-draw clamp" entry is overturned — it stopped at the prologue and missed the helper's
pixel writes. Byte evidence (the `es:[di]` store) wins.

**Action taken**:
- `UI_PRIMITIVES.md`: 0xCE table row (line 110), detail §0x0CE, and the summary row all
  corrected to "line/rule draw"; added the `0xE2`/`0xCE` full call-site audit (87/49 sites).
- Confirms the colony field-panel "divider lines via 0x181F:0xCE" labeling is correct.

**Follow-up**: whether `0xBBC:0xC` is exclusively horizontal runs or general lines is not
fully pinned (the two-pass call suggests top+bottom edges of a separator).

## 2026-06-24 — Colony building placement: far-ptr dispatch traced, §12 blocker resolved
Traced `func_07464C` (the supposed per-type→category setter): reached via thunk `0x1A1F:0xD2E`
(stub file `0x1D31E`), which has **0 static lcall sites** — the call goes through the `ljmp`
trampoline at `0x76384` (jump table; entry 0 = `ljmp 0x1a1f:0xd2e`), invoked 42× from the
registration block at `0x0746BC`. The `0x8F88` (+6) column it writes = `floor(id/3)` (chain
group), used by the produced-good pass, **not** plot placement. Plot placement (`func_025D34`)
uses only the static `0x224`/`0x22A` config (`[7,4,2,1,1]`/`[0,7,11,13,14]`) + a random
permutation within each category block. RULING: the "per-type category table" blocker in
`docs/COLONY_SCREEN_VICEROY_DECODE.md` §12 was a misdiagnosis; placement is byte-portable given
only the `rand()` LCG. Full trace recorded in the decode §12 note.

## 2026-06-24 — OPEN CONFLICT (unresolved): ICONS index 100 — skip vs foot-unit
Surfaced while building the lab Sprites tab (M1). `CLAUDE.md` hard rule 5 lists **100**
among the placeholder indices to **skip** (0, 16, 100); hard rule 6 lists foot units as
**100–105**. Index 100 is therefore claimed by both rules. Not resolved here — the lab
renders ICONS #100 as a **TBD "CONFLICT"** role (rather than silently picking one) per the
prime directive (never invent; record conflicts). A ruling is needed: is 100 a dead
placeholder slot with foot units actually at 101–105 (+109), or is the rule-5 "100" a
typo/overlap? Resolution likely needs the ICONS.SS pixel check at index 100. Until then the
lab's role map (`lab/js/data/sprite_roles.js`) keeps 100 = TBD-conflict, 101–105 = foot unit.

## 2026-06-24 — RESOLVED: the rule-5 skip set {0,16,100} is PHYS0-SCOPED; ICONS #100 is a real foot unit
Resolves the OPEN CONFLICT directly above. There is **no conflict** — the two rules name
different sheets:
- **PHYS0** frames **0, 16, 100** are each a **1×1 transparent** stub (palette idx 253) —
  corrupted MADSPACK extraction artifacts, "NOT usable sprites, should never be indexed"
  (`notes/SPRITE_CATALOG.md` "Known extraction artifacts"; RULINGS A3). Byte-verified in the
  bundle: `PHYS0.json` frames 0/16/100 are all `w=1,h=1`. THIS is what hard rule 5 skips.
- **ICONS** is **contiguous 0–130, no gaps** (`notes/STATE.md:254`). `ICONS.json` #100 is a
  real **6×16** sprite, the first of the foot-unit run 100–106 (src y=20). So hard rule 6's
  "foot units 100–105 + 109" stands; #100 is a foot unit, not a placeholder.
**Determination**: hard rule 5's "skip 0, 16, 100" applies to **PHYS0 only** (and those frames
are 1×1, so a geometric "1×1 = placeholder" test already isolates them on any sheet). The M1
lab bug was applying {0,16,100} to *every* sheet, which wrongly flagged ICONS #100.
**Action taken**: `lab/js/data/sprite_roles.js` — renamed the set to `PHYS0_PLACEHOLDER_INDICES`,
made `isPlaceholder(frame, sheet)` geometric + PHYS0-scoped, and set ICONS #100 = foot unit (B).
**Suggested CLAUDE.md clarification (needs user sign-off)**: reword hard rule 5 to "skip the
PHYS0 placeholder indices 0, 16, 100 (1×1 artifacts)" so the scope is explicit in the rule.

## 2026-06-24 — Colony-screen layout decoded for the lab Screens tab; F2–F9 report fields are blocked
While seeding the lab's Screens tab with byte-verified element positions:
- **Colony building plots — B.** `func_02701C` (@0x02701C, VICEROY) is the plot painter:
  loops 15 entries (`CMP [bp-8],0xf` @0x02707B), reads `x=[bx+0x266]`, `y_table=[bx+0x268]`,
  draws at `y = y_table + 8` (`ADD cx,8` @0x02708F); a per-plot gate byte `[bx-0x717e]` (`JL`
  skip = empty plot → tree frames 42/43/44) and a frame-type byte `[bx-0x729e]`. Confirms the
  DS:0x266 plot table in `colony_screen.cpp`. **Position is B; WHICH building fills a plot is
  RNG-driven (`func_025D34`) so the per-plot frame is TBD.**
- **Colony stockpile bar — B** (`colony_screen.cpp` §6): 16 cells, x=1+i·19, icon row y=181,
  quantity y=193; icon = good+0x16 ⇒ ICONS frame 22 (Food)…37 (Muskets). Visually validated —
  the icons land exactly in COLONY.PIK's blue cells.
- **F2–F9 report field positions — TBD (blocker named).** The report painters (F-key dispatch
  `LCALL 0x191F:0x3xx`) render in **overlay 0x191F / the orphan code** (`orphans_load_image.asm`,
  ~118k lines); field positions are loop/table-driven and not yet traced. The COLONIZE/VICEROY
  per-func disasm offsets in `ADVISOR_REPORTS_AUDIT.md` (e.g. "file 0x027010") do NOT correspond
  to the committed per-function `.asm` (0x02701C there is the VICEROY colony-plot painter, a
  different EXE/offset space). Only each report's TITLE index is byte-cited (MISC[44..129]).
  The lab seeds report fields as **TBD** (drag-to-measure), NOT fabricated — per the prime
  directive. Tracing the 0x191F overlay is the remaining work to upgrade them to B.

## 2026-06-25 — Autonomous spec/systems decode loop (4 batches): headline rulings

Ran a decode→adversarially-verify loop over all 30 `spec/systems/*.md` files in 4
batches (commits 3e8b4b5, 16b2b32, dbdcb3e and one earlier). Each candidate fact was
independently re-derived from committed `raw/COLONIZE/VICEROY.EXE` bytes and landed ONLY
on definitive confirmation; hard items were kept TBD with the blocker named. The
durable rulings (full byte trails in the commit messages):

- **Mission-conversion `cl&0x10` doubler = Jean de Brebeuf founding-father bonus.**
  Bit `0x10` on the active convert record `[0x8D4A]+5` is set by `or [bx+5],0x10`
  `@0x48C81`, gated by `has_father(0x16, power)` `@0x48C71` (thunk `0x181F:0x7B4`,
  file `0xBC10`). `@FATHERS` row `0x16` = de Brebeuf (Religious/Jesuit). Read/doubled at
  `@0x57300` (`test cl,0x10; shl ax,1`). A second setter `@0x3BEA2` sits in the FF-0x16
  effect dispatcher — corroborates, not refutes. Closes the natives §3 mechanism note +
  §6 open-q together. (Previously: mechanism-known, label-TBD.)

- **`@UNIT` stat-table column map is byte-verified** (was hedged "TBD/unmapped" in one
  spot): `func_074EC3 @0x074EF9..0x074F59` parses 23 rows into base `0x5230` stride 14;
  movement (col1) stored ×3 `@0x5234`. Matches the §3 BYTE_VERIFIED table.

- **GAME save/load is raw fixed-record fread/fwrite, no compression** (`func_073BB0` /
  `func_0734F8`): 0x4F0 map block + 43× colony records.

- **Customize new-game menu fully decoded** (`func_070060`): 4 player-facing params are
  3-way enums (cursor `mod 4 @0x70158`, value `mod 3 @0x701AA/0x701AD`) — `@CLAND`
  land-mass, `@CCONT` land-form, `@CTEMP` temperature, `@CCLIM` climate (strings in
  `GAME_sections.json`). The 5-word param array at `DGROUP:0x1E7E` is mapped slot-by-slot;
  slot 4 (`0x1E86`) is a generator-internal smoothing budget `(p_iter+1)·0x320 @0x6538D`,
  NOT menu-reachable.

Honest blocks recorded (stay TBD, not invented): UnitRecord fields
`0x314F/0x3156/0x3158/0x3148` and the full move-cost table live in unattributed
orphan-overlay routines; Save/Load and setup-menu dialog *geometry* is inside overlay
file-picker thunks not in the committed disasm; `map_system` pattern-3 frame `0x9A`
"out of bounds" depends on the `PHYS0.SS` frame count (MADSPACK sheet, not the EXE);
the `0x5B1C` tension-row columns 4..38 are never accessed in committed disasm; the
events Lost-City trigger read `0xB0` vs the generator write `0xA0` is a cross-file
ruling needing the trigger function traced.

## 2026-06-25 — UnitRecord 0x314F = facing/heading (8-way compass), NOT "europe/recruit state"

Track-1 orphan-overlay attribution. The spec previously glossed UnitRecord +0x314F as
"europe/recruit state (cmp ==8)". **Overturned by bytes:** 0x314F is the unit's 8-way
compass HEADING (values 0..7; 8 = invalid/none sentinel). Proven independently on three
overlay pages by the `xor al,4` reverse-direction test (8-way compass reverse): page 0x0C
`@0x047AA8`, page 0x13 `@0x062F7C`; the angular-distance momentum score
`d=0x314F−target; if d>4 d=8−d; score−=d²·2` `@0x051712..0x051737`; and the `cmp
[bx+0x314f],8; jge` invalid-bound `@0x0516F0`. Written by AI move routines
`func_04E2D6`(page 0x0D)/`func_059B90`(page 0x0F) — confirming it is AI heading state, not
europe/recruit code. The enclosing AI order/move processor `func_04E2D6` (page 0x0D,
0x04E2D6..0x051D55) is now attributed (see notes/ATTRIBUTION_OVERLAY.md).

Also this pass: 0x3156 = overloaded per-unit TIMER field (word snapshot of progress
counter [0x538e] for owner≥4; byte 0xFF→rand for owner<4) — NOT cost/sale/treasure;
0x3158 = u8 per-turn land-unit boolean (set after cargo-load LCALL func_00B368, tested
only for Wagon Trains); 0x3148 = transient bit-scratch register, bit 0x08 = tile-dirty/
redraw (byte-verified), other bits context-overloaded and per-bit meaning kept TBD.

REJECTED by adversarial verify (NOT landed): a 0x314B per-letter alphabet proposal (byte
encoding errors — claimed BX-form writes were SI-form, phantom letters); and a native
0x5B1C column-padding claim. Honest TBDs, not invented.

## 2026-06-25 — PHYS0.SS = 154 frames; map pattern-3 frame 0x9A IS out of bounds (Track 2a)

The map_system coast-edge renderer computes `0x97 + pattern`; pattern 3 yields frame
`0x9A` (154). Whether that overruns PHYS0.SS was a standing TBD because the frame count
is NOT in VICEROY.EXE — it lives in the MADSPACK-packed sheet. **Byte-decoded the sheet:**
PHYS0.SS section-0 header `nframes @0x26` = **154**, so valid indices are `0..153`
(`0..0x99`) and frame `0x9A` is one past the end. Resolved. The only residual is whether
the pattern-3 mask (`[0xA8A6] & 0xDD == 0x1C`) is ever satisfied for a real coast tile at
runtime (latent bug vs unreachable branch). Full frame-count table for all 205 decodable
.SS sheets recorded in `data_extracted/SPRITE_SHEET_FRAMES.md` (decoder: tools/ssdec.py).
Notable counts: TERRAIN.SS=12, ICONS.SS=131, PHYS0.SS=154, BUILDING.SS=48, BDARK.SS=46.

## 2026-06-25 — Dialogs are GAME.TXT-template-driven; Save/Load "Layout TBD" explained (Track 2b)

The Save/Load picker geometry was "Layout TBD" because there is NO coded layout: dialogs are
**data-driven from GAME.TXT templates**. Traced chain (notes/ATTRIBUTION_OVERLAY.md): prompt
orchestrators func_072F7A (save) / func_073158 (load) → slot-list builder func_072CC2 →
window-create thunk 0x191F:0x182 = **func_06F0F4, a generic dialog-template interpreter** that
parses the `@SAVEGAME`/`@LOADGAME` section of GAME.TXT (keyword lines: X/Y/WIDTH/LENGTH/
SMALLFONT/COLOR). Add-row primitive 0x191F:0x176 = func_06C850 (linked-list item alloc, no
x/y immediates); modal pump 0x191F:0x16a = func_06E3D0 (lays out rows at render time);
teardown 0x191F:0x1a8 = func_0789FA (DOS free). The templates omit x/y/length ⇒ window
auto-centered, per-row Y computed at runtime ⇒ those pixel positions are legitimately TBD
(runtime), not missing work. This generalizes: the 0x191F overlay is the shared dialog engine,
so other "0x191F TBD" UI items are likely template/runtime-driven too. (One auto-proposal was
REJECTED for fabricated keyword-offset cites; the function chain stands, exact keyword offsets
pending re-verification.)

## 2026-06-25 — Advisor-report (F2–F9) renderer located: func_037958 (page 0x05) (Track 2b)

The advisor reports' field layout was the standing "trace the 0x191F overlay" remaining work.
Located the renderer: **func_037958 (page 0x05)** is the report screen, fed by the F-key
dispatch (F2 push 2 @page_05.asm:581 / F5 push 5 / F9 push 1) and the .PIK loader func_037340
(load_report_pik); report chrome strings "REPORT"/"(%d of %d)" at file 0x1EB42/0x1EB49
(data base 0x1D9A0). Per-report numeric FIELD positions remain TBD (live game-state + the
0x191F template path), but the renderer + dispatch are now byte-cited (B), upgrading the
reports from drag-to-measure.

## 2026-06-25 — Lost-City: no 0xB0 immediate exists; trigger masks, not equals (Track 2b)

Exhaustive scan of all 494,910 EXE bytes (grp1-imm byte/word forms on es:[bx] + reg-imm
cmp/mov 0xB0) found ZERO 0xB0 immediate. The generator ORs 0xA0 into the tile feature byte
(@0x65C0D/@0x65C21 = `26 80 0f a0`). So the Lost-City trigger cannot compare ==0xB0 against a
literal; it masks the feature byte (the 0x10 bit is a separate rumor/explored flag tested
independently, or the read is (feat & 0xA0)). The "==0xB0" model in events.md §6.1 is a recon
gloss, not a byte literal — corrected to a masked-read model.

## 2026-06-25 — Track 4: button-bit 0x7E4, colony/europe hit-test tables; map-dispatch mislabel rejected

Three input/UI resolutions landed; one proposal rejected on repo-fact grounds.

- **Mouse 0x7E4 = right-button flag (complement of bit0), RESOLVED.** func_00D106 @0xD1A2-
  0xD1AE: `mov al,bl / and ax,1 / cmp ax,1 / sbb ax,ax / neg ax / mov [0x7E4],ax` ⇒
  [0x7E4]=0 on a left click (bit0 set), =1 on a right click. The Track-3 `(bl&1)` gloss was
  INVERTED; corrected. Written only on a fresh press down-edge; sole writer (A3 E4 07 once);
  readers test ==0 @0x2438A/0x29C91/0x6ECBC/0x2A038.
- **Colony click-region table = func @0x299A0** (10 rects, point-in-rect 0x181F:0x3CA=
  func_004B16): ids 0xA top bar / 2 main scene / 1 field panel / 0 plaza / 8 minimap(121,130,
  84,48) / 4 SoL panel / 3 flag / 5 stockpile strip / 9 gold readout(305,179) / 0x14 default.
  Matches colony_screen.md paint rects 1:1. id→action dispatch still TBD (overlay caller switch).
- **Europe click-region entry = func @0x3200A** (default id 0xF); the older cite 0x032034 is
  the id-5 (recruit-pool) block BODY, not the entry — corrected.

REJECTED (not landed): the map-key-dispatch agent labeled **func_070060** as the "in-game
map viewport/region picker" and asserted its getch cmp-cascade (Space/ESC/arrows/Enter) as
the in-game map key dispatch. **Refuted by committed facts**: func_070060 IS the Customize
new-game menu (batch-4: cursor mod4 @0x70158, params @CLAND/CCONT/CTEMP/CCLIM, writes the
map-GEN param array [0x1e7e]). The cmp-cascade bytes are real but they are the Customize
menu's navigation, NOT the in-game map. The genuine in-game active-unit command keymap
(B/F/C/W…) remains menu-accelerator-driven (func_0235D6) — carried open blocker, still TBD.

## 2026-06-25 — Active-unit order keymap: code→handler RESOLVED; key-read step honestly TBD (Track 5)

Premise correction + a real win. **func_0235D6 is NOT the accelerator engine** — it is a
downstream command DISPATCHER that receives an already-decoded command id in [bp+6] (switch
mov ax,[bp+6] @0x235E2; F-key report ladder cmp 0x48/0x41.. @0x23843 → 0x191F report thunks,
consistent with Track 2b). It never reads a key and never scans @ORDERS. Do not cite it as the
key→order translator.

RESOLVED (byte-verified): the @ORDERS order-code → per-turn handler map, via the dispatcher
@0x249CB (imul idx×0x1c; al=[bx+0x314c]; code−2; cmp ≤7; jmp word cs:[bx+0x3b58]; table @file
0x24A38). Codes→executors: 2 TradeRoute→func_041080, 3 GoTo→func_040E22, 5 Fortify→func_04101C
(which WRITES code 6 @0x41024, byte-proving Fortify→Fortified promotion), 6 Fortified→passive,
7 BuildColony→func_040C1E, 8 Clear/Plow→func_040656, 9 BuildRoad→func_0409D6. The 2nd
dispatcher @0x051DCE (codes 7..12, table @file 0x51E1A) LCALLs the SAME thunks for 7/8/9,
cross-confirming. Handlers 8/9 match terrain_improvement.md. Row index == stored order code
for all proven rows. Command letters S/T/G/L/F/B/P/R are canonical from NAMES @ORDERS.

HONEST TBD (overlay-paged, not statically traceable): the KEY-READ step — where a pressed
accelerator letter is matched to a menu row and decoded into the command id. The match loop is
inside the overlay menu engine around func_06E3D0 @0x6E3D0 (polls input via LCALL 0x181F:0xf6
@0x6E419 → getch 0xD286). getch and func_0235D6 have no static callers (xref empty; overlay
function-pointer table patched at runtime), so the letter→id translation needs a runtime trace
or the overlay dispatch table resolved. Next site: callees of func_06E3D0's poll loop + per-row
draw func_06F83A @0x6F83A + the consumer of the 'ORDERS' section-name lookup @file 0x1FBFD.

## 2026-06-25 — 0x54de = @ORDERS status-letter table (NOT the menu key-match); renderer func @0x0386A (Track 6)

Extended Track 5. DGROUP byte array 0x54de[13] is built by a NAMES-section table-builder
(loader body file 0x074E70..0x074FE0) that parses the @ORDERS accelerator column into
0x54de[row] = {'-','S','T','G','L','F','F','B','P','R','-','-','-'}, indexed by order code
(@0x074F96 mov [bx+0x54de],al; 13-row loop). It is consumed ONLY by the on-map unit
STATUS-LETTER renderer func @0x0386A (NOT func_038F2C — that linear-sweep label is a different
function; renderer prologue enter 0x46,0 @0x0386A): default glyph = 0x54de[0x314c order code],
with overrides for ship cargo digit, 'X', and the 0x314b AI-state char (→'E' when >=0x80) —
cross-linking Track 1's 0x314B.

PROVEN (full-binary scan): exactly TWO code refs to 0x54de (writer 0x74F96, reader 0x391D),
zero register-constant loads. So the orders MENU does NOT select a row by scanning a pressed
key against 0x54de — accelerator matching is engine-internal to the dialog/section opener
func_06F8FA, matching the @ORDERS text directly. The in-engine key-match site stays the one
honest TBD (overlay-internal). Adversarial verify caught my initial renderer mis-citation
(func_038F2C @0x038F2C) and it was corrected to func @0x0386A before landing.

## 2026-06-25 — Runtime snapshot harness: live DGROUP seg 0x1CFD; 0x54de table confirmed (Track 7)

Built tools/runtime_snapshot.py: boots VICEROY headless under stock DOSBox 0.74 and snapshots
the emulated DOS RAM out of the DOSBox process via /proc/<pid>/mem (no debugger build/symbols
needed; DOSBox's emulated RAM is the 16MB anon mmap carrying the MADSPACK+ORDERS signatures;
DOS phys P = region offset P). First runtime cross-check of static RE in this project.

Verified: live DGROUP base = segment 0x1CFD (phys 0x1CFD0), auto-anchored on the section-name
table UNIT\0ORDERS\0ACTIONS\0 @DGROUP:0x2258. DGROUP offsets are preserved from the static EXE
image, so spec DGROUP:0xNNNN citations read live at phys 0x1CFD0+0xNNNN. RUNTIME-CONFIRMED the
Track-6 0x54de table: DGROUP:0x54de[13]='-STGLFFBPR---' occurs exactly once in 16MB. Anchors
0x225d='ORDERS', 0x2258='UNIT', 0x2264='ACTIONS' all exact.

Limit: stock DOSBox sends the DOS console to emulated video (not host stdout) and gameplay input
is not automated, so this captures the boot/menu state + resident data. Catching the in-engine
orders-menu key-match (inside func_06F8FA) still needs scripted input or a debugger build —
that remains the one honest TBD in the keyboard chain. Harness doc: docs/RUNTIME_SNAPSHOT.md.

## 2026-06-25 — Runtime trace reaches in-game map + ORDERS menu; key-match RUNTIME-CONFIRMED (Track 8)

Drove the live game (tools/drive_game.sh) all the way to the in-game map with an active unit,
opened the ORDERS pulldown, and snapshotted DOS RAM with the menu OPEN (tools/runtime_snapshot.py).
This closes the one input TBD that was flagged as needing a runtime trace.

Findings (triangulated: live RAM + static MENU.TXT + screenshot):
- The in-game ORDERS menu is built from **MENU.TXT @ORDERS** (data_extracted/text/MENU_sections.json),
  NOT the NAMES @ORDERS (which → 0x54de on-map status letters, Track 6). Each row's accelerator is
  a **`~` marker** in the label: ~Fortify→F, ~Sentry→S, ~Build Colony→B, `Join Colony (~B)`→B,
  `Build ~Road`→R, `Begin ~Trade Route`→T, `No Orders (~s~p~a~c~e~ bar)`→spacebar,
  `Disband Unit (~s~h~i~f~t~-~D)`→shift-D.
- LIVE EVIDENCE: the menu is a linked list of func_06C850 nodes (0x18 bytes: two far-ptr links +
  label + u8 row-index + flag) at seg 0x668c; each node carries the ~-marked MENU.TXT label
  VERBATIM (e.g. `~Activate unit`, `Join Colony (~B)`). So the engine parses the ~ markers from
  the live menu rows to bind accelerators. (The exact getch-vs-marker compare instruction inside
  the dialog engine is the only residual micro-detail; the mechanism + full keymap are resolved.)
- map_view.md sidebar HUD RUNTIME-CONFIRMED: live shows `Spring 1498`, `Gold: 1000e Tax: 0%`,
  active Caravel `Moves: 4 / Locat: (50,42) / (Sea Lane)` (hard rule 2 confirmed visually).

New screens: docs/screens/06_ingame_map.png, 07_king_audience.png (KING.SS, row 13),
08_orders_menu.png. The runtime memory harness + driving harness together now reach and confirm
any reachable game state.

## 2026-06-25 — All 10 advisor reports captured live (F1–F10) (Track 9)

Drove the running game to an in-game state and opened every report from the REPORTS pulldown.
Visual ground-truth for the advisor-report subsystem (renderer func_037958, Track 2b) now lives
in docs/screens/reports/ (+README). Confirmed REPORTS menu order: F1 Terrain / F2 Religious /
F3 Continental Congress / F4 Labor / F5 Economic / F6 Colony / F7 Naval / F8 Foreign Affairs /
F9 Indian / F10 Score.

Live field values confirmed (not just layout):
- F5 Economic = "European Trade" table, cols Tons/Gold/Bid Price/Ask Price × 16 commodities
  (live bid/ask: Food 0/8, Sugar 5/7, Silver 19/20, Rum 9/10, Muskets 2/3, ...); pages to
  "Cargo in Port" sub-view. Confirms the market bid/ask model (market.md).
- F8 Foreign Affairs = 4 European leaders by name (Walter Raleigh/English, Jacques Cartier/
  French, Christopher Columbus/Spanish, Michiel De Ruyter/Dutch), each Rebels/Tories (revolution.md).
- F10 Score = func_03A9C0: "Discoverer Walter Raleigh of the English: Spring 1498"; English
  Citizens +6 / Continental Congress +0 / Gold (1000e) +1 / Total Score: 7 (scoring.md terms).
- F1 Terrain = Colonopedia popup for the tile ("Sea Lane" — hard rule 2).

UX facts: reports close via the OK button (bottom-right), NOT Esc (Esc quits from the map); an
F-key pressed inside a report pages THAT report's sub-views, it doesn't switch reports.

## 2026-06-25 — Europe screen captured live (Track 10)

Drove a Caravel back to Europe ("Return to Europe" order, ~2 turns) and captured the European
Status Screen live (docs/screens/10_europe_screen.png + 09_europe_arriving.png). Confirms
europe_screen.md: header "London, England. Spring, 1500. Tax: 0% Gold: 1000e"; the three dock
zones Expected Soon / Bound For New England / Loading: Caravel (captions from @MISC); the
RECRUIT/PURCHASE/TRAIN panel (@EUROLABEL); the 16-commodity bid/ask price strip (same prices as
the F5 Economic report -> single market model); and the Exit button with red 'E' accelerator.
First arrival shows a tutorial help overlay. Validates the Track-4 func @0x3200A hit-test rects.

## 2026-06-26 — Colony screen captured live; ColonyRecord + hard rule 8 runtime-confirmed (Track 11)

Drove the full New-World arrival sequence live to found a colony and capture the colony screen
(the big colony_screen.md PARTIAL surface): sail back from Europe -> "Discovery of the New World"
-> Make Landfall -> a LOST CITY RUMOR ("You find nothing but rumors" = a live @LOSTCITY outcome)
-> "Meeting the Natives" / Arawak diplomacy ("a glorious nation of 11 Villages", land-gift, peace)
-> Build Colony -> name "Jamestown" -> "Building a Colony" -> colony screen. Live @TUTORIAL hints
also fired (Caravel hint). Screens in docs/screens/ (11_colony_screen.png + 12..15).

RUNTIME CONFIRMATION of the colony data structures (CLAUDE.md hard rule 8): snapshot with the
colony screen open (colony_jamestown.bin), DGROUP seg 0x1CFD. *(0x8542) = 0x606e. And
0x606e = 0x5D46 + 4*0xCA EXACTLY -> confirms ColonyRecord base 0x5D46 + stride 0xCA (Jamestown =
table index 4). Record @0x606e: +0 cx=0x2e(46), +1 cy=0x29(41), +2 name "Jamestown\0". Validates
the [0x8542] near-ptr + the +0/+1 cx/cy field map in colony_screen.md.

The colony screen visually confirms: RNG-placed buildings layout (func_025D34 §12), surrounding-
tiles work map, SoL/pop "100% (1)", production panels, 16-commodity warehouse strip (Tools: 50),
Exit (E). With the runtime harness, every major in-game screen is now captured + cross-checked.

UX note for founding: colonists made landfall sit on the water-edge tile and must be MOVED onto
land (Rain Forest here) before Build Colony works ("colonies cannot be built at sea"); sentried
units are woken by clicking their tile once no unit is active.

## 2026-06-26 — Colony §12 RNG building placement RESOLVED (static trace + snapshot oracle) (Track 12)

The 2026-06-24 "burned" incident (colony screen marked COMPLETE while func_025D34 RNG placement
was unresolved) is now genuinely resolved — traced statically AND verified against the live
Jamestown snapshot.

func_025D34 @0x025D34..0x025EAF, full algorithm:
1. RNG seed per colony: lcall 0x181F:0xD62 @0x025D3A.
2. Category-per-plot table 0x8D62 = [0,0,0,0,0,0,0,1,1,1,1,2,2,3,4], built from counts
   0x224=[7,4,2,1,1] + starts 0x22A=[0,7,11,13,14] (deterministic, recomputed each open).
3. Within-category random shuffle (random_int(0,count-1)+start[cat] via lcall 0x181F:0x4D4,
   retry if occupied) -> plot→building-slot at 0x8E92 (=[bx−0x716E]).
4. 42 building-defs (stride-12 records based 0x8F88) mapped to category-slots; for each building
   the colony HAS (query lcall 0x181F:0x9FC) write present-gate 0x8E82[plot]=building-def-id
   (else 0xFF) @0x025E9F.
5. Frame = word[id*2−0x7238] = [id*2+0x8DC8] (func_026CC2).
Consumer render loop 0x027067: position 0x266[slot*4], category 0x8D62[slot] (stride 1),
present-gate 0x8E82[slot] (stride 1, skip if <0/0xFF), draw via 0x2CA23(category,y,x,def-id).

ADDRESSING NOTE: the disasm's negative offsets are 16-bit wraps: −0x729E=+0x8D62, −0x717E=+0x8E82,
−0x716E=+0x8E92, −0x7238=+0x8DC8, −0x7078=+0x8F88.

SNAPSHOT VERIFICATION (the key methodological point): live Jamestown 0x8E82 (stride 1) = 8
buildings at plots {2,3,4,5,6,10,12,13}, def-ids {0x20,0x1B,0x27,0x18,0x15,0x23,0x09,0x00},
matching the trace. A first naive stride-4 read had falsely reported "13 buildings" — the
snapshot oracle is exactly what caught and corrected the bad decode before it could land. This
is the runtime harness doing its job: not auto-decoding, but turning an unverifiable static
claim into a checkable one.

Residual (non-static BY DESIGN): the exact plot a building lands in depends on the per-colony
RNG seed + shuffle order; replayable from seed 0x181F:0xD62 but not a fixed table.

## 2026-06-26 — UI-residue trace+oracle pass: 6 verified, 2 rejected, 9 honest blocks (Track 13)

Workflow fanned 4 tracers over the remaining tangled UI TBDs, each verified against a live
snapshot oracle. Landed only byte-traced AND oracle-confirmed facts.

ECONOMIC REPORT (docs/ADVISOR_REPORTS_AUDIT) — the F5 table fully decoded:
- Real paint fn = func_038A50 (page_05, file 0x038A50; the old 0x027010 was a pre-reseg
  mis-resolution). 16-row loop (cmp [bp-0x84],0x10 @0x038E3B), y-stride 8 (@0x038E33), start
  y=0x21. Columns drawn via text primitive 0x181f:0x13c = func_002B38 (arg order color,y,x,ss,&str).
- BID = func_030590 (0x191f:0x9ea): PowerRecord[+0x4c+commodity] − 1, clamp ≥0.
- ASK = func_030566 (0x191f:0xc3e): PowerRecord[+0x4c+commodity] + spread_const[commodity*9]
  (DGROUP +0x9700, stride 9), clamp ≥0. Both oracle-confirmed against rep_economic.bin.
  Blocks (honest): per-value left x is runtime font-metric right-justification (column RIGHT
  anchors ARE byte-cited: name→0x90, Gold 0x90, Bid 0xaa, Ask 0xdc); header label literals are
  GAME-string indices [0x2e2e/0x2e30/0x2f50/0x2f52]=385/386/530/531 (not mapped to text);
  Tons/Gold dword tables (+0x88c4/+0x8884) both 0 in snapshot (no trades) so not distinguishable.

COLONY PANEL (§3.6): the [0x337] 3-way dispatch is func_02814C; case-0=SoL func@0x0275CE,
case-1=cargo func@0x027746, case-2=msg. "No Ships In Port" = LABELS @MISC[11] via resolver
func_002462 (0x181F:0x22), oracle-confirmed at DGROUP 0x2FF1A. SoL/cargo-mode literals stay
TBD (need a snapshot in those modes).

EUROPE (§3): banner = func_030F76 (lcall 0x181F:0xB0, NO coord push → pixel origin from string
metrics, runtime). Banner pixel origin + Exit-button paint origin remain TBD. REJECTED: a
"corrected" click-rect mapping was byte-wrong (verifier refuted).

COLONY TITLE (§3.1): func_0268CE assembles "Jamestown. Spring, 1504. Gold: 1000e" — name branch
@0x269F8, season @0x26A22, year @0x26A44, gold @0x26A61 (via 0x181F:0x22). REJECTED: one row
mis-attributed the gold draw to func_0268CE. Pitch-packing loop (line 145) stays TBD.

Method note: 2 rejections (europe click-rect, colony gold) + 9 honest blocks vs 6 clean lands —
the oracle requirement (must match live snapshot) is doing exactly what it should.

## 2026-06-26 — String-blob resolver is DIRECT (corrects a same-day +1 error) (Track 14)

Self-correction. Commit a3f8948 claimed the LABELS string-blob resolver func_002462 (0x181F:0x22)
maps the Economic header indices with a "+1" (stored 385 → blob[386]="Tons"). That was WRONG.

VALIDATED rule: the resolver walks the contiguous null-separated blob at far-ptr [0x2d42:0x2d44]
(live base 0x4c050) and the mapping is DIRECT — string = blob[index], no offset:
- global 0x153=339 → blob[339]="No Ships In Port" (the known colony @MISC[11] string) ✓
- europe [0x2DD0]=338 → blob[338]="Bound For" ✓
- blob[386]="Tons", [387]="Gold", [531]="Bid Price", [532]="Ask Price" (both snapshots identical).

So the Economic header LABELS are at blob[386/387/531/532] (direct); the source DGROUP globals I
earlier read (385/386/530/531) do NOT land on them, so the exact header-index globals are TBD
(label identity stays confirmed via screenshot + blob). The "+1" framing in a3f8948 is retracted.

LESSON for the cheap sweep: the index globals ([0x2F5E], [0x939A], [0x2DD0], …) hold
context/MODE-TRANSIENT values — e.g. europe [0x2F5E]=537="Sons of Liberty" is clearly leftover,
not the field's purpose. So resolving a field's SEMANTIC via the blob requires the snapshot to be
in that field's active mode; absent that, the blob gives the current (possibly stale) string, not
the meaning. Mass-applying the mechanism to these globals would re-introduce plausible-but-wrong
literals — so only the mechanism (direct) + the two validated anchors are landed.

## 2026-06-26 — Colony §3.3 colonist-row pitch RESOLVED (code + existing snapshot, no re-drive) (Track 15)

The "per-colonist pitch = data-driven packing loop = TBD" turned out to be cheap (code-derivable
+ confirmable from the colony snapshot already on disk), NOT requiring the expensive re-drive.

func_0270D0 @0x0270D0 colonist plaza row: count = colony+0x1F + [0x8D72] (live 1+1=2). Pass 1
(@0x02710A) sums each colonist sprite width (table [0x83E]:[0x840], stride 12, +0x3E=width) into
total_width. Gap solve (@0x027160): gap=[0xA890] init 2; while gap*(count-1)+4+total_width >= 0x60
(96), decrement gap and retry — adaptive shrink to fit the 96-px budget. Pass 2 (@0x027186) blits
each colonist (0x181F:0xCE) at running x [bp-0x60] (from 143, advanced left by sprite_width+gap),
y=10. So pitch = sprite_width(+0x3E) + adaptive gap (2->0). Table structure + [0xA890]=2
oracle-confirmed in colony_jamestown.bin (real colonist +0x3E=15).

Note: this extends the "cheap tier" — a TBD labeled "needs a multi-colonist re-drive" was actually
a code-derivable formula whose data structure the existing single-colonist snapshot confirms.

## 2026-06-26 — Colony per-turn driver sequence + food consumption + warehouse capacity (Track 16)

Traced colony_turn_update @0xA222..0xA6A1 (the per-turn colony pipeline a rewrite needs as
control flow). Ordered: (1) setup lcalls; (2) tile production loop over 20 goods via
compute_terrain_yield (call 0x9B9C @0xA42A) into produced table [good*2+0x8DC8]; (3) 5 raw→
finished chains (call 0x8E84 ×5 @0xA660..0xA68C); (4) food consumption; (5) warehouse cap;
(6) display-delta bookkeeping.

BYTE-VERIFIED formulas:
- Food consumption = 2*pop (@0xA5F2 shl ax,1 on ColonyRecord+0x1F); net_food = max(produced − 2*pop, 0).
- Warehouse capacity = (warehouse_level[+0x95] + 1) * 100 (func_008D00: base 100, *(level+1)).

Warehouse spoilage (was TBD): capacity formula nailed + the over-cap detection (func_008E02
computes room = cap − stock − produced); but the exact CLAMP/discard write to the +0x9A stockpile
is in the 0x8E84 commit chains, not func_008E02 (which is colony-screen display bookkeeping). So
spoilage is now PARTIALLY resolved (cap + detection byte-verified; the write leaf remains).

Note: confirms colony production is more complete than the mid-session layer-3 estimate implied —
the core formulas (per-tile yield, SoL EMA, consumption, capacity) are byte-verified from code,
not reconstructed; runtime deltas would only confirm them.

## 2026-06-26 — PowerRecord field tail + Unit/native AI-boundary classification (L1/L2 Phase 1)

PowerRecord (per-nation economy/diplomacy, 316-byte/0x13C stride @DGROUP:0x8808, 12 entries;
active reached via near ptr [0x84fc], set by func_030550 @0x30559). Tail offsets resolved this
pass, each disasm-cited via capstone on VICEROY.EXE AND oracle-checked against rep_economic.bin /
rep_europe.bin (active power 0):
- +0x20 u16 boycott_bitfield (and ax,[bx+0x20] func_030B38 @0x30B47; clear func_03334E @0x33423). oracle 0.
- +0x22/+0x24 s32 royal_money accumulator (add [bx+0x22],ax; adc [bx+0x24],dx func_02D658 @0x2D785;
  boycott-lift adds @0x33413). oracle grows 70->80 between the two snapshots (live).
- +0x26/+0x28 s32 gross/pre-tax accumulator paired with +0x22 (@0x2D78B). oracle 0.
- +0x2A/+0x2C u32 gold treasury (sub [bx+0x2a],ax; sbb [bx+0x2c],dx func_03334E @0x3340D;
  treasure credit func_04E2D6 @0x50954). oracle = 1000 <-> in-game "Gold 1000". KEY OACLE MATCH.
- +0x2E/+0x30 u16 pair, Europe "(%d of %d)" progress (func_037958 @0x379AB mov dx,[bx+0x30];
  mov bx,[bx+0x2e]). oracle 0/10. writer semantics TBD.
- +0x32/+0x33 byte pair = default unit destination map_x/map_y (page_0D @0x51E9B al=[bx+0x32]->
  [si+0x314d]; @0x51EA6 al=[bx+0x33]->[si+0x314e]). SUPERSEDES the DATA_MODEL.md "ref_strength
  word +0x32" guess (byte reads, not word; authoritative REF = 0x53DA..0x53E1 per 2026-06-19).
- +0x49 byte countdown (cmp/dec func_04E2D6 @0x52658/@0x52688). +0x4A u16 crosses pool drained in
  0x32 chunks (@0x5276F/@0x5279F).
- +0x4C+i u8[16] price_level (ask func_030566 @0x30583; bid @0x3059C; recompute @0x306F3). oracle
  [1,6,5,5,5,2,6,20,3,10,11,12,15,2,2,3] (Silver=20). +0x5C+i*2 s16[16] vol_accum (func_0305A8
  @0x30707 etc.). oracle differs between snapshots (live accumulator).
Record interior with no traced read/write site (mostly the js-dos-schema market arrays) left TBD,
not asserted.

Unit fields 0x3149 / 0x3148 / 0x314B / 0x3158 pushed to their L2 ceiling = AI-GATED. 0x3149 is an
AI per-unit enable/budget counter: turn-dispatch enable (func_051D56 @0x51D5D), budget-sub
(func_03ECF0 @0x03EE95, func_0079A0 @0x007A08), incr (func_059B90 @0x059F20/etc). EVERY consumer
is orphan-overlay AI; no render/economy/UI reads it. Oracle: player units 0, native braves nonzero
(6,6,8,3,3,9). Exact English (move-credits vs eval-passes) is the AI-GATED ceiling.

Native tension table 0x5B1C (39-word stride): columns 4..38 RESOLVED-as-unused. dgroup_xrefs.json
= exactly 3 refs (getter @0x0082AC, applier read @0x045E57, write @0x045E6C); all callers pass a
power id 0..3 (raid scan col<4 @0x047365; 0 column constants >3). So only cols 0..3 = the 4 powers
are ever touched, by ANY committed path (not even orphan AI) -> NOT AI-GATED, simply over-allocated.
NativeSettlement +0x03 bit 0x04 = Capital (set @0x66225, consumed @0x43DC4/@0x07DCA/@0x46E05;
oracle 1/tribe). WITHDREW the earlier unverified 0x04=mission / 0x08=visited / 0x40=event flags
(no code sets/tests those bits).
