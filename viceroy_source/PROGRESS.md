# PROGRESS — Honest status of VICEROY.EXE reconstruction

> **The bar.** Every numerical claim, table value, and formula in this
> tree must be **byte-traceable to VICEROY.EXE**. Anything less is
> RECONSTRUCTED until proven otherwise. See
> [VERIFICATION_LEDGER.md](VERIFICATION_LEDGER.md) for the methodology.

---

## What's done (BYTE_VERIFIED)

| Layer                                          | Status              |
|------------------------------------------------|---------------------|
| MZ header / entry point                        | BYTE_VERIFIED       |
| Load-image vs DGROUP vs overlay region map     | BYTE_VERIFIED       |
| 1,241 function boundaries (per `functions.json`) | BYTE_VERIFIED     |
| 872 distinct DGROUP global addresses inventoried | BYTE_VERIFIED     |
| Confirmed globals: `map_width@0x853A`, `map_height@0x853C`, `unit_table@0x3144`, `colony_t*@0x8542`, `267A` far ptr | BYTE_VERIFIED |
| RTLink Plus thunk table (1,020 entries at 0x1A5F0..0x1D5E6) | BYTE_VERIFIED |
| 14 hand-decompiled small/medium functions in `decompiled.md` | BYTE_VERIFIED |
| ColonyRecord layout (174-byte working buffer + 202-byte persistent) | BYTE_VERIFIED via accessor copy lengths |
| UnitRecord stride 0x1C, with chain field at -2 | BYTE_VERIFIED |
| PowerRecord stride 0x13C                       | BYTE_VERIFIED via table iteration |

## What's tentatively pinned (ANCHOR_VERIFIED)

| Layer                                          | Status              |
|------------------------------------------------|---------------------|
| ~80 functions with semantic interpretation     | ANCHOR_VERIFIED     |
| 14 LARGE_LOGIC dispatchers tagged with @inferred_role | ANCHOR_VERIFIED |
| 558 distinct overlay LCALL targets cataloged   | ANCHOR_VERIFIED (call boundary verified, semantics inferred) |
| String tables: NAMES.TXT @-section table at 0x01FB4C | BYTE_VERIFIED bytes; ANCHOR_VERIFIED interpretation |

## What's RECONSTRUCTED (not yet at the bar)

These are the items the user has called out as needing byte-traceability.

### Per-game-system formulas (all RECONSTRUCTED)

- Combat resolution roll
- Combat strength modifiers (fortify, terrain, SoL, FF bonuses)
- Promotion / demotion ladders
- Native settlement raze treasure (the immediate question that prompted this)
- Native raid trigger / aggression
- Mission convert rate
- Market price drift / decay / spread
- Tea Party effects
- King tax demand fire chance + escalation table
- REF growth rate + REF effective-strength
- Founding Father bell pool growth
- Continental Congress age unlock
- Per-FF effect dispatch (each effect needs separate trace)
- LCR outcome weights (11-outcome distribution)
- LCR per-outcome resolution (gold amounts, treasure ranges)
- Disease-risk per terrain
- Weather event chance + effects
- Score formula components
- Difficulty multipliers
- Map generation: climate gradients, mountain placement, river tracing,
  settlement placement, starting positions
- Save file structure (header, section order)

### Data tables (all RECONSTRUCTED)

The DGROUP file offsets I attached to data tables in `data/` were not
verified — a 2026-05-02 spot-check found that `0x05000`, `0x06530`,
`0x07A00`, `0x09800`, `0x0B400` are in the **code** region, not DGROUP.
Only `0x01DB32` looked plausible (contained word-sized values).

| Table                | File offset claimed | Actual content      |
|----------------------|---------------------|---------------------|
| terrain_yield        | 0x05000             | CODE — wrong        |
| unit_classes         | 0x06530             | CODE — wrong        |
| commodity_prices     | 0x07A00             | CODE — wrong        |
| tribe_data           | 0x09800             | CODE — wrong        |
| ff_effects           | 0x0B400             | CODE — wrong        |
| building_costs       | 0x01DB32            | plausible — pending |
| kings_demands        | 0x07D00             | not verified        |
| scenario_starts      | 0x08400             | not verified        |

All 8 tables need to be located via callgraph search (find functions
that touch the relevant DGROUP region with the right element stride and
count) and the bytes read from VICEROY.EXE.

### Render chain

`src/render/tile_chain.c` claims the chain is `func_O514 → O513 → O512`
per CLAUDE.md ruling. The renaming of these to `O514/O513/O512` is from
the project's prior pixel-verification work, not byte-anchored in this
session. The actual sprite-blit, tile-compose, and viewport-walk
functions are in the overlay region with the SKELETON-tier auto-traced
bodies.

---

## Infrastructure added 2026-05-02

| Tool / artifact                                   | Purpose |
|---------------------------------------------------|---------|
| [VERIFICATION_LEDGER.md](VERIFICATION_LEDGER.md)  | Methodology + ledger of every claim's status |
| `tools/audit_tag.py`                              | Stamps RECONSTRUCTED files with a clear banner so readers see status before trusting |
| `tools/dgroup_xref_scan.py`                       | First-time-populated DGROUP cross-reference index. Output: `code/VICEROY/dgroup_xrefs.json` (1,043 distinct DGROUP offsets, 4,818 ref sites) |

The dgroup_xref_scan finally fills the gap that `strings.json::xrefs`
was supposed to have but never did. With it, queries like "who reads
DGROUP:0xNNNN" become tractable — and that's the foundation for tracing
formulas back to bytes.

### What 4,818 ref-sites buys us

- 0x853A (map_width): 40 confirmed refs
- 0x8542 (colony_t*): 203 confirmed refs (matches anchor_map.md "102 fns" — multiple refs per fn)
- 0x3144 (unit_table base); 0x3146 = type field +0x02 (203 refs); 0x315E = +0x1A next-link

These numbers match prior anchors → tool is correct. Now it's a sweep
problem: take each unidentified DGROUP global with N refs and trace.

---

## What "done" looks like

A claim is DONE when:

```c
/* @asm_offset    file 0xNNNNNN..0xNNNNNN
 * @bytes         hex of the relevant table or instruction sequence
 * @cited_in      code/VICEROY/disasm/func_NNNNNN_<name>.asm  line NN
 * @verified_by   matched against VICEROY.EXE bytes 2026-MM-DD
 */
```

VERIFICATION_LEDGER.md has the priority order. Closing the gap is a
multi-session effort.

---

## Honest summary (updated 2026-05-02 — 2nd session)

- **Function boundaries**: 100% (verified, but boundary detector misses
  early-exit RETFs in many large functions — true sizes are larger than
  the ledger reports)
- **Function names**: 100% renamed by inferred role (renames are
  hypothesis-tier, not byte-verified for most)
- **Function bodies**: 22+ hand-decompiled (BYTE_VERIFIED), ~80 semantically
  interpreted (ANCHOR_VERIFIED), the rest auto-traced control flow only
- **Data tables**: 0% byte-verified. All 8 in `data/` need re-anchoring.
  Approach: data tables live mixed with code in DGROUP; need to find them
  via accessor patterns (IMUL stride + base address) not by random offset.
- **Game-system formulas in `src/`**: 4 BYTE_VERIFIED (raze [retracted],
  treasure transport, smite gold, king tax raise+cap, combat demotion ladder).
  Most of the ~30 systems still need full byte-trace.
- **Subsystem docs**: narrative-only; specific numbers are RECONSTRUCTED.

### Newly BYTE_VERIFIED in 2nd session (2026-05-02)

| Item | Function | File | Doc |
|------|----------|------|-----|
| `__aFlmul` (32×32 → 32 multiply) | func_010530 | 0x010530 | code/VICEROY/disasm/func_010530_unknown.asm |
| `__aFldiv` (signed long divide) | func_010496 | 0x010496 | code/VICEROY/disasm/func_010496_unknown.asm |
| `power_attribute_bit` | func_00BC10 | 0x00BC10 | code/VICEROY/disasm/func_00BC10_is_arg2_negative.asm |
| `rand()` (MSC 6.0 LCG) | func_0103D4 | 0x0103D4 | src/runtime/rng.c |
| `random_int(lo, hi)` | func_00C322 | 0x00C322 | src/runtime/rng.c |
| Treasure-transport gold formula (KingsGalleon) | func_05C878 | 0x05C878 | src/native/raze_treasure.c (`#if 0` — not raze, but real function) |
| SMITE gold formula | func_057F4E | 0x057F4E | src/native/diplomacy_smite_gold.c |
| King tax raise formula | func_034AE0 | 0x034AE0 | src/king/king_tax_raise.c |
| King tax cap (= 75 = 0x4B) | func_034318 | 0x034318 | (in king_tax_raise.c summary) |
| Combat demotion ladder | func_05B2C2 | 0x05B2C2 | src/combat/combat_demotion_ladder.c |
| 5 messaging API helpers (04B6, 048E, 09A4, 0808, 07B4) | various | (load image) | D1D_181F_RUNTIME.md |

### 12 game-system functions identified (Phase D output)

See [GAME_SYSTEM_ANCHORS.md](GAME_SYSTEM_ANCHORS.md) for the full table
mapping each major Colonization mechanic to its canonical entry-point
function (treasure transport, colony burn, diplomacy/SMITE, market
buy/drift, king tax, tea party, declaration, intervention, ship combat,
SOL, raid dispatcher).

### Key methodology lessons (saved to memory)

1. **Identify function via STRING ANALYSIS first** — never decompile by
   pattern-matching call signatures. The 1-session waste on
   func_05C878-as-raze taught this. See
   `feedback_string_first_function_id.md`.
2. **Boundary detector is unreliable for large functions** — every
   significant game-logic function has early-exit RETFs that fool it.
   When a JMP target lies past the reported end, the function is bigger.
3. **`LCALL 0x181F:NNN` is a thunk-table call**, not an overlay call.
   Type B thunks (10 bytes) point directly into the load image — fully
   decodable today. Most "overlay" calls are actually load-image calls
   in disguise.
4. **The unit_table base is DGROUP:0x3144** (0x3146 = type field +0x02; 0x315E
   = +0x1A next-link). Proven by WRITE sites func_04007E/func_L141; RULINGS 2026-05-28.

### Remaining work (long pole)

The ~30 game-system formulas, the 8 data tables, and the per-overlay-page
loading still require multiple sessions. The infrastructure built this
session (RNG byte-verified, message API decoded for the load-image part,
12 system anchors identified) makes the per-system work much faster than
before — but it's still 1-2 sessions per major formula.
