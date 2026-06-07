# Verification Ledger

This is the source of truth for **what is byte-verified against VICEROY.EXE
and what is not**. Every claim in `viceroy_source/` falls into one of four
status levels:

| Status            | Meaning                                                |
|-------------------|--------------------------------------------------------|
| **BYTE_VERIFIED** | Bytes/values read directly from VICEROY.EXE at a confirmed offset |
| **ANCHOR_VERIFIED** | Supported by a confirmed anchor (function boundary, string xref, callgraph) but the specific value/formula is not byte-traced |
| **RECONSTRUCTED** | Plausible from accumulated knowledge — **needs work** |
| **WRONG**         | Found to be incorrect; awaiting correction            |

Any claim in this tree without one of these tags is treated as
**RECONSTRUCTED until proven otherwise**.

---

## Methodology

**Bytes** are read from `COLONIZE/VICEROY.EXE` (sha256 in MANIFEST.md).
**Anchors** come from `code/VICEROY/anchor_map.md` (function boundaries,
hot globals, string tables, callgraph).

To upgrade a claim from RECONSTRUCTED → ANCHOR_VERIFIED:
- Identify a function in `code/VICEROY/disasm/*.asm` that touches the
  data/formula in question.
- Cite that function's file offset.

To upgrade from ANCHOR_VERIFIED → BYTE_VERIFIED:
- Read the actual bytes at the claimed file offset and confirm they
  match the documented values.
- For formulas: read the disassembled bytes of the function that
  computes the formula, decompile each instruction, prove the formula
  matches.

---

## Ghidra Phase 1 import (2026-05-02)

**Source:** Ghidra Export Program → C/C++ across all 105 load-image
segments. ~30k-line .c file processed.

**Verification methodology:** Ghidra's pseudo-C is ground truth for
disassembled bytes; cross-checked against the byte-verified anchors in
`code/VICEROY/decompiled.md` for the 14 already-decompiled functions.

**New byte-verified anchors:**

| Address  | Symbol                | Confirmation |
|----------|----------------------|--------------|
| `0x013BED` (`210d:071d`) | `entry` (program entry) | Ghidra labels it `entry` automatically |
| `0x00FDB4` (`1d1d:07e4`) | `strcpy_near`           | Ghidra body matches MSC 6.0 strcpy exactly |
| `0x01072A` (`1d1d:0150`) | `cstart`                 | DOS-version check + heap init + setargv + LCALL `_main` |
| `0x01A5F0` (`281f:0000`) | **`_main()` overlay thunk** | First overlay function — confirms anchor_map.md |
| `0x011DAB` (`210d:0dab`) | RTLink overlay dispatcher | Called from EVERY `FUN_281f_xxxx` thunk |
| `0x011D91` (`210d:0d91`) | RTLink loader partner   | 353 callers — most-called function in load image |

**RTLink Plus runtime fully exposed:**
- All 1,020 thunks at file 0x1A5F0 are wrappers that LCALL into
  `0x011DAB` (`FUN_210d_0dab`) with the thunk's segment id and an
  in-stack arg.
- The dispatcher reads a flag at DGROUP byte `[0x28cd+0x44]` and
  bit-tests `[0x28cd+0x41] & 0x0C` to decide overlay-load vs. cached
  call.

**Strings now byte-resolved (DGROUP at 2b5a:):**
- `VICEROY.EXE` at 2755:0001 (file 0x019951)
- `AMERICA.MOV` at 2b5a:1e50, 2b5a:1e5f, 2b5a:1e71 (three call sites)
- `HALLFAME.DAT` at 2b5a:11f2, 2b5a:1227 (two call sites)
- All combat / native / king / FF strings in 2b5a:0xxx..2b5a:1cxx

**Critical finding — overlay code is NOT in this export:**

All `FUN_281f_xxxx` functions truncate with
`// WARNING: Control flow encountered bad instruction data` because
the LCALL goes into the overlay region (file 0x20665+) which Ghidra
hasn't loaded. The decompile of every game-logic function (combat,
raze, market, FF, AI, scoring, map gen) is therefore **NOT YET
verifiable** — Phase 2 (load overlays into Ghidra) required.

**See:** [`code/VICEROY/ghidra/GHIDRA_IMPORT_NOTES.md`](../code/VICEROY/ghidra/GHIDRA_IMPORT_NOTES.md) for the full analysis.

---

## First byte-traced game-logic function (2026-05-02)

**Function:** `compute_raze_loot` (`func_05C878`) — invoked when a
settlement is destroyed. File offset 0x05C878..0x05CA7E (518 bytes), in
overlay region.

**Output:** [`src/native/raze_treasure.c`](src/native/raze_treasure.c) —
hand-decompiled pseudo-C with `@asm` byte-citations on every block.

**Key byte-verified facts** found by tracing this one function:
- The function is **deterministic** — no RNG. The 0xD1D:0xF60 / 0xD1D:0xEC6
  LCALLs are C-runtime long-math helpers (NOT random).
- Hard clamp at **90** (`CMP ax, 0x5a`) on a "bounded" intermediate.
- Base amount = `100 × settlement_field`, where `settlement_field` is a
  byte from a 0x1C-stride table at **`DGROUP:0x315B`**.
- **PowerRecord table base is at `DGROUP:0x8808`** (CORRECTED 2026-05-30 from
  0x8809 off-by-one; verified `add ax,0x8808` @0x3055D; 0x8809 = +0x01 = tax byte) (derived from
  `[bx − 0x77F7]` with bx = power_id × 0x13C). New byte-verified anchor —
  anchor_map.md confirmed only the stride, not the base.
- AIPersonality base at **`DGROUP:0x540E`**, stride 0x34. Confirmed.
- PowerRecord has three 32-bit running totals at +0x21 / +0x25 / +0x29 that
  get incremented on every raze. At least one is the player's spendable
  gold. **My earlier `include/power.h` had `ff_owned_lo` at +0x20 — that
  struct is wrong in this region and needs re-derivation.**

**Methodology used (template for all future byte-verifications):**
1. `tools/find_imm_refs.py 0x1be0` → found PUSH 0x1be0 at file 0x05C8A1
2. `functions.json` lookup → containing function at 0x05C878
3. Read `disasm/func_05C878_unknown.asm` (195 lines)
4. Hand-decompile to pseudo-C, citing `@asm` per block
5. Cross-check string bytes at `2b5a:1bed..2b5a:1bfd`
6. Mark BYTE_VERIFIED on confirmed parts, TODO_VERIFY on inferred parts

**Still RECONSTRUCTED** (needs further trace to fully answer the user's
"min/max gold for Aztec raze" question):
- Exact formula combining state_factor × bounded × base_amount
- Which of +0x21 / +0x25 / +0x29 is spendable gold vs lifetime totals
- Semantics of `settlement_field` byte (population? wealth_tier? tribe?)

To close: decompile the long-math helpers `0xD1D:0xF60` and `0xD1D:0xEC6`
plus `0x181F:0x07B4` (the conditional gate). Three more small functions.

---

## Closing the raze-treasure trace (2026-05-02 — same session)

All three "still missing" helpers are now BYTE_VERIFIED. The
gold-from-raze formula is **fully byte-traceable**.

### LCALL-target resolution (baseline work — applies to every game-logic function)

The LCALLs in `func_05C878` looked like opaque overlay calls, but careful
analysis of [`overlay_thunks.json`](../code/VICEROY/overlay_thunks.json)
showed that the segment values 0x181F / 0x191F encode addresses INSIDE
the thunk table itself (0x181F + load_base 0x1000 = Ghidra paragraph
0x281F = file 0x1A5F0 = thunk table start). Each `LCALL 0x181F:offset`
is therefore a call to a specific thunk at `(table_start + offset)`, and
each thunk's bytes name the actual destination. Two destination kinds:

- **Type B thunks** (10 bytes): `LCALL dispatcher; JMP FAR target` — the
  `target` segment:offset is a **fixed image-relative paragraph**, often
  pointing **back into the load image**. These can be decompiled today
  from existing disasm files. Five of the seven non-overlay LCALLs in
  raze are Type B.
- **Type A thunks** (12–14 bytes): `LCALL dispatcher; trailer_words` —
  the trailer encodes (overlay_page, sub_offset). These do require the
  overlay to be loaded to follow.

This means **most "overlay" LCALLs are actually load-image calls in
disguise** — visible in the existing 1,241 disasm files. New methodology:
to follow `LCALL 0x181F:NNN`, look up thunk at table_offset NNN and read
its 10/14 bytes; if Type B, jump straight to the existing disasm file.

### BYTE_VERIFIED helpers (file offsets confirmed, bytes hand-decompiled)

| Helper                   | File offset | Disasm file | Verified |
|--------------------------|-------------|-------------|----------|
| `power_attribute_bit(power, bit)` (the BIT-TEST gate) | 0x00BC10..0x00BC4D (61 bytes) | `func_00BC10_is_arg2_negative.asm` | BYTE_VERIFIED — full body re-decompiled (the original 16-byte fragment was wrong; it's actually a 61-byte function with three exit paths and a `[BX+SI+0x880F]` PowerRecord-bitfield read) |
| `__aFlmul(int32, int32) → int32` (long multiply) | 0x010530..0x010561 (50 bytes) | `func_010530_unknown.asm` | BYTE_VERIFIED — matches MSC 6.0 LMUL pattern |
| `__aFldiv(int32, int32) → int32` (long divide) | 0x010496..0x01052D (152 bytes) | `func_010496_unknown.asm` | BYTE_VERIFIED — matches MSC 6.0 LDIV (sign-track + SAR/RCR normalize + back-correct) |

### Final raze formula (BYTE_VERIFIED)

```
gold_received = MIN(90, M0) * settlement_size

  where:
    settlement_size = NativeSettlement[idx].byte_at_315B
    M0              = if power_attribute_bit(attacker, 10) is SET:
                          treasure_pool_byte                       (no MAX, no doubling)
                      else:
                          MAX( (current_player + 10) * 5,
                               treasure_pool_byte * 2 )
    treasure_pool_byte = PowerRecord[attacker].byte_at_8809
                        (= byte 0 of PowerRecord, BYTE_VERIFIED twice in raze:
                         once at file 0x05C8F7, again at file 0x05C95D)
```

The function is **fully deterministic** — no RNG appears anywhere in the
518-byte trace. The `__aFlmul` × `__aFldiv` chain at file 0x05C9BF /
0x05C9C6 algebraically simplifies to `multiplier × settlement_size`
(the 100 in `base_amount = 100 * settlement_size` is divided out).

For a HUMAN player (attacker_power_idx 0..3) razing an Aztec village
where bit 10 is clear (the default state):
```
multiplier = MIN(90, MAX( (player_idx + 10) * 5,
                           treasure_pool * 2 ))
```
giving multiplier ranges of `[50, 90]` for player 0 up through `[65, 90]`
for player 3, multiplied by the village's `settlement_size` byte.

### Newly BYTE_VERIFIED DGROUP anchors (from this trace)

| Anchor                   | DGROUP address | Stride | What we know |
|--------------------------|----------------|--------|--------------|
| `NativeSettlement[]`     | `0x54EC`       | `0x12` | x +0x00, y +0x01, owner +0x02, mission +0x05; live-count @0x539A, max 84. (The old `0x315B`/`0x1C` entry was a retracted mislabel — that is UnitRecord field +0x17 (vet/profession); see RULINGS 2026-05-28.) |
| `PowerRecord[]`          | `0x8808`       | `0x13C`| base 0x8808 (was 0x8809, off-by-one, fixed 2026-05-30); +0x01=tax, +0x07=FF-owned bitmap, +0x0C/+0x0E=bells, +0x20=boycott, +0x2A=gold(dword), +0x4C=price_level[16], +0x5C=vol_accum[16], +0xFC=euro-supply[16] |
| `PowerRecord.gold`       | `0x882A` (= 0x21 within record) | dword | accumulated treasure gold |
| `PowerRecord.total_loot` | `0x882E` (= 0x25 within record) | dword | lifetime loot tracker |
| `PowerRecord.score_bonus`| `0x8832` (= 0x29 within record) | dword | score-component running total |
| `current_player_idx`     | `0x53A6`       | byte   | confirmed via raze + the raze message dispatcher |
| `g_flags_5382` bit 0     | `0x5382`       | byte   | demo / endgame flag — gates the no-gold message branch in raze |

These are **new** entries; they should propagate into
[`include/power.h`](include/power.h) (currently has wrong layout per
prior session note) and [`include/native.h`](include/native.h).

### What is STILL not byte-verified (narrow & tractable)

Two specific gaps remain on this thread:

1. **What sets bit 10** of `PowerRecord.attribute_bitfield`?
   Likely a Founding Father effect (Cortés is the design-intent
   candidate). Trace path: search for instructions that OR a value into
   `[BX+SI+0x880F]` with `BX = 1` and `1 << 2` in the immediate (= bit 10).
2. **The map-gen value of `NativeSettlement.byte_0`** for each tribe and
   tier. Trace path: find map-gen functions that WRITE to
   `[bx + 0x315B]` with a constant; their constants give the per-tribe
   settlement_size table.

Both are single-function byte-traces, no longer entire subsystems.

---

## Major correction (2026-05-02 — same session)

**`func_05C878` is NOT the raze function.** It's a TREASURE-TRANSPORT
event (King's Galleon ferries player loot back to Europe with a
percentage taken). Discovered when the user reported observed raze gold
of 4000–15000 — incompatible with my decompiled formula's ~600–1080.

### How the misidentification happened

I followed the chain "user asks about raze → search for `0x1be0` (which
I assumed was a string ref) → find PUSH at file 0x05C8A1 → containing
function is 0x05C878." All true. But I never **verified what string
0x1be0 actually is**. When I finally dumped `2b5a:0x1be0` it said
`CASHTREASURE`, and the surrounding strings 1bed=`KINGGALLEON`, 1bfd=
`LOOTCASH` told a treasure-transport story, not a raze story. The
"BURNED" / "BURNED2" / "BURNED3" verbs (the actual raze message keys)
live at `2b5a:1c28..1c37` and are referenced by `func_05CA7E` (a ~7437-
byte function ending RETF @0x5E709; corrected from the overshot "7521" —
see below — not the 518-byte one I traced).

### What's still salvageable from the func_05C878 trace

Despite the wrong function, three byte-verifications survive intact:
- `__aFlmul` (file 0x010530) and `__aFldiv` (file 0x010496) — MSC 6.0
  long-arithmetic helpers. These are reusable across every game-logic
  function.
- `power_attribute_bit` (file 0x00BC10, 61 bytes) — confirmed reads
  `[BX+SI+0x880F]` from PowerRecord bitfield.
- The `LCALL 0x181F:NNN → in-thunk-table` insight: most "overlay" calls
  are actually load-image calls disguised as thunks. Type B thunks expose
  the load-image target directly.

### What's wrong (now fixed)

- `raze_treasure.c` had a header `>>> BYTE_VERIFIED <<<` claim with a
  formula that produces ~600–1080 gold. **Wrong function.** File now
  has a `>>> WRONG FUNCTION <<<` header explaining the mistake; the
  original (incorrect) writeup is preserved inside `#if 0` for reference.
- The DGROUP-anchor list above had `NativeSettlement[]@0x315B (stride
  0x1C) byte 0 = settlement_size`. **Wrong table.** `[BX+0x315B]` with
  stride 0x1C is byte +0x17 of an UnitRecord whose base is
  `DGROUP:0x3144` (0x315B − 0x3144 = 0x17 = the vet/profession type field;
  func_036038 writes constants 0x15/0x1B/etc. there after creating a unit;
  values 0x13..0x1C, the veteran/profession enum — not village size).

### Real raze function: `func_05CA7E`

- Spans **0x05CA7E..~0x05E709 (~7437 bytes)** — body ends at the RETF
  @0x5E709 (then 0x5E70B..0x5E740 is the page-0x10 JMPF trampoline block, incl.
  the 0x5E723 combat-applier trampoline; the page-0x10 code segment ends 0x5E740).
  CORRECTED 2026-05-30 (wave-11 flat-image check): the earlier "0x05E7DF / ~7521"
  overshot 159 bytes PAST the segment into the page-0x11 header — wrong. The body
  understanding is unaffected (JMP targets 0x5E66E/0x5E706 are inside, both ≤0x5E709).
- References `BURNED`/`BURNED2`/`BURNED3` strings at file 0x05DAE6 etc.
- Has TWO long-math sites:
  - File 0x05DC9D: single `__aFldiv` — appears to scale `colony.dword_C2`
    by 2/3 (colony-capture wealth decay).
  - File 0x05DE35..0x05DE3C: `__aFlmul` + `__aFldiv` pair — the actual
    loot computation: `loot = (colony.byte_1F × power.field_8832) /
    MAX(local_82, 1)`. With realistic fields (colony.byte_1F ~ 10,
    power.field_8832 ~ 1000, divisor ~ 1) this produces ~10000 gold —
    **consistent with the user's observed 4000-15000 range.**
- Operates on `colony_t* @ DGROUP:0x8542` — so this is COLONY burn /
  capture (one power burns or captures another's colony), not native-
  settlement raze. Both operations share message strings BURNED*.
- The actual NATIVE-VILLAGE raze function is yet another (still
  unidentified) function.

### Methodology lesson recorded

**Identify a function via STRING ANALYSIS first.** The order should be:
1. Find a string that names the gameplay event you care about
2. Verify what the string actually says by dumping its bytes
3. Find PUSH-references to that string
4. THEN locate the containing function

What I did wrong was step 4 → step 2: I trusted the "0x1be0 looks like
a string offset" pattern without confirming. Cost: a session-worth of
detail decompilation against the wrong function. The decompilation
itself is correct; only the labeling was wrong.

---

## Phase 2 batch additions (2026-05-02 — same session)

### New BYTE_VERIFIED items

| # | Item | Function | File | Doc / source |
|---|------|----------|------|--------------|
| 1 | MSC 6.0 `rand()` LCG | func_0103D4 | 0x0103D4 | [src/runtime/rng.c](src/runtime/rng.c) |
| 2 | `random_int(lo, hi)` (the universal roll helper) | func_00C322 | 0x00C322 | src/runtime/rng.c — `LCALL 0x181F:0x04D4` |
| 3 | King tax raise formula | func_034AE0 | 0x034AE0 | [src/king/king_tax_raise.c](src/king/king_tax_raise.c) |
| 4 | King tax CAP at 75 (= 0x4B) | func_034318 | 0x034318 | (in king_tax_raise.c summary) |
| 5 | func_05B2C2 = COMBAT RESOLVER (single-roll `roll=random_int(1,ATK+DEF); atk wins if roll<=ATK`, @0x5B819); demotion ladder is a SUB-TABLE within it ← corrected 2026-05-30 (was "Combat demotion ladder") | func_05B2C2 | 0x05B2C2 (full extent 0x5B2C2..0x5BE30, 2926B; MANIFEST's 35B is a truncation artifact) | [src/combat/combat.c](src/combat/combat.c) (resolver) **and** [src/combat/combat_demotion_ladder.c](src/combat/combat_demotion_ladder.c) (demotion sub-table) |
| 6 | func_057F4E = European diplomacy MEETING dispatcher (7151B); the SMITE-loot formula is ONE branch of it ← corrected 2026-05-30 (was "SMITE gold formula") | func_057F4E | 0x057F4E | [src/diplomacy/meeting.c](src/diplomacy/meeting.c) (dispatcher + European treaty/war/tribute/peace) **and** [src/native/diplomacy_smite_gold.c](src/native/diplomacy_smite_gold.c) (smite-loot branch, file 0x05997C..0x059AD9) |
| 7 | 5 messaging API helpers | various | (load image) | [D1D_181F_RUNTIME.md](D1D_181F_RUNTIME.md) |

### 12 game-system functions identified via string analysis

See [GAME_SYSTEM_ANCHORS.md](GAME_SYSTEM_ANCHORS.md). Each major
Colonization mechanic now has a canonical entry-point function:
treasure transport, colony burn, diplomacy/SMITE, market buy/drift,
king tax, tea party, declaration, intervention, ship combat, SOL,
6-outcome native raid dispatcher.

### Native raid outcome breakdown (BYTE_VERIFIED structure)

`func_05BE84` is the native raid dispatcher. Six outcomes, each with a
distinct sound effect played via `LCALL 0x181F:0x04C0` (= sound helper):

| Outcome | String addr | Sound code | What it does |
|---------|-------------|-----------|--------------|
| RAIDWREAK | 2b5a:0x1B8A | (bypassed for sound) | wrecks something |
| RAIDSTORES | 2b5a:0x1B94 | 0x4F (=79) | takes stores |
| RAIDBURN | 2b5a:0x1B9F | 0x53 (=83) | burns colony |
| RAIDSHIP | 2b5a:0x1BA8 | 0x4B + 0x4D (=75 + 77) | takes a ship |
| RAIDGOLD | 2b5a:0x1BB1 | 0x4E (=78) | takes gold |
| RAIDNOTHING | 2b5a:0x1BBA | 0x5B (=91) | no effect |

The selection roll happens earlier in the function. Each branch is
gated by `owner < 4 && AIPersonality[owner].byte_at_+0x31 != 0`.

### DGROUP-anchor table (refined — see GAME_SYSTEM_ANCHORS.md for full table)

New anchors discovered in this session:
- `0x18E` — terrain-display mode word (BYTE_VERIFIED via auto-forest)
- `0x28EE/0x28F0` — RNG seed (BYTE_VERIFIED via rand())
- `0x538E` — turn counter (BYTE_VERIFIED via king tax)
- `0x5398` — current human player marker (BYTE_VERIFIED via SOL)
- `0x53D2` — self power marker (BYTE_VERIFIED via SOL)
- `0x84FC` — far ptr to king/payer record (BYTE_VERIFIED via SMITE+king tax)
- `0x8CFC + N` — per-power active unit count (BYTE_VERIFIED via destroy_unit)
- `0x9298 + N` — per-power something (BYTE_VERIFIED via colony burn)
- `0x940C + N` — per-power stockpile (BYTE_VERIFIED via colony burn)
- King record byte +1 = current tax rate, **capped at 75** (BYTE_VERIFIED)

### Cumulative status (end of 2nd session)

| Tier | Count | Notes |
|------|-------|-------|
| BYTE_VERIFIED functions | ~22 | up from 14 |
| BYTE_VERIFIED game-system formulas | 4 | king tax (raise+cap), combat demotion ladder, SMITE gold, raze treasure (retracted but the misidentified function's body is still verified) |
| Game-system functions identified by name | 12 | combat, market, king (×2), SMITE, raid, colony burn, tea party, independence, intervention, ship combat, SOL |
| Messaging API helpers decoded | 5 (Type B) + 6 inferred (Type A) | all Type B in load image; Type A still locked behind overlay loading |
| New DGROUP anchors | 11+ | all BYTE_VERIFIED in this session |

The bar for "1.5% byte-verified" rises modestly to ~2-3% but the
**RNG verification + thunk table insight + 12 system-anchors** are
load-bearing infrastructure that makes future sessions much faster.

---

## Diplomacy + Founding-Father dispatch byte-trace (2026-05-29)

Two complete game-logic functions hand-decompiled from the re-segmented
overlay (`code/VICEROY/disasm_overlay_reseg/`); the matching `src/` files were
rewritten to mirror the bytes with `@asm` citations on every load-bearing line.

### DIPLOMACY — `treaty_set_state` = `func_057DC0` @0x057DC0 (page 0x0F)

`overlay_functions_reseg.json`: size 397, prologue `push bp;mov bp,sp`, RETF.
Two args: `a`=`[bp+6]`, `b`=`[bp+8]` (European power indices). Status:

| Claim | Evidence | Status |
|-------|----------|--------|
| Relation/treaty STATE = byte `*(0x8848 + A*0x13C + B)`, written SYMMETRICALLY | @asm 057EBD `imul si,[bp+6],0x13c`; 057EC5 `mov [bx+si-0x77b8],al`; 057ED0 symmetric (−0x77B8≡+0x8848) | BYTE_VERIFIED |
| Matrix base 0x8848 == PowerRecord(0x8808)+0x40, stride 0x13C | 0x8848−0x8808=0x40; matches docs/RULINGS.md 2026-05-28 | BYTE_VERIFIED |
| SET value = 1 (treaty/ally), CLEAR value = 0 (war/none) | @asm 057EBB `mov al,1`; 057F23 `sub al,al` | BYTE_VERIFIED |
| Relation flag bits: 0x02=war, 0x20=peace-pending, 0x40=treaty-in-force | @asm 057E05 `test al,2`; 057DF0 `test al,0x20`; 057E7D `test al,0x40` | BYTE_VERIFIED (bit→meaning labels inferred from branch targets) |
| Emits "SIGNTREATY" on establish | @asm 057E84 `push 2`; 057E86 `push 0x188d`; 057E89 `lcall 0x181f,0x652`; string "SIGNTREATY" @ file 0x1F22D (strings.json) | BYTE_VERIFIED (call site); key→string mapping ANCHOR_VERIFIED |
| Early-out guard `[0x5382]&1`; phase gate `(a+[0x538e]+b)%3` | @asm 057DC4 / 057DCE..057DE0 (`idiv cx`=3) | BYTE_VERIFIED |
| `rel_query`/`power_handle`/`power_set_flag`/`ui_notify_key`/`rel_apply_event`/`rel_clear_event` helper BODIES | resolved targets cited (e.g. 0x181F:0x0A38→file 0x5FC30) but not decompiled | TBD |
| Treaty PROPOSAL / AI accept-reject / gold-goods transfer | caller not located | TBD (RECONSTRUCTED removed from treaty.c) |

`relations.c`: the prior file's numeric "relationship score" (−100..100), per-
event deltas, REL_* enum values, and "+20 Pocahontas" were **fabricated** and
were removed. Only the verified storage + flag predicates remain.

### FOUNDING FATHERS — `ff_acquire_dispatch` = `func_03BC42` @0x03BC42 (page 0x06)

`overlay_functions_reseg.json`: size 911, prologue `ENTER 0x60,0`, RETF. Args:
`power`=`[bp+6]`, `ff_id`=`[bp+8]`. The brief's anchor 0x3BD37 is the ff_count
increment INSIDE this function.

| Claim | Evidence | Status |
|-------|----------|--------|
| `g_active_power` ptr at DGROUP:0x84FC | @asm 03BD33 `mov bx,[0x84fc]`; cross-confirmed by 32-bit gold add/sub at `[bx+0x2a]/[bx+0x2c]` across pages 0x0E/0x0F | BYTE_VERIFIED |
| ff_count++ at PowerRecord+0x14 | @asm **03BD37** `inc byte [bx+0x14]` | BYTE_VERIFIED |
| pending-FF slot PowerRecord+0x12 = 0xFFFF | @asm 03BD3A `mov word [bx+0x12],0xffff` | BYTE_VERIFIED |
| **ff_id == NAMES.TXT @FATHERS line index** (0-based) | switch values match documented effects 1:1 (Fugger=1, La Salle=9, JPJones=14, Pocahontas=16, Bolivar=18, Brebeuf=22, LasCasas=24) | BYTE_VERIFIED |
| id 1 Jakob Fugger → boycott mask PowerRecord+0x20 = 0 | @asm 03BD45 `mov word [bx+0x20],0` | BYTE_VERIFIED |
| id 9 Sieur De La Salle → per-colony, owner==power & pop(+0x1f)>=3 | @asm 03BD68 `cmp [bx+0x1a],al`; 03BD6D `cmp [bx+0x1f],3` | BYTE_VERIFIED |
| id 14 John Paul Jones → create unit type 0x11 at home coords | @asm 03BDAC `lcall 0x95c` (type 0x11); 03BDBB `imul bx,ax,0x1c`; writes UnitRecord+0x06/+0x07/+0x08/+0x14 from PowerRecord+0x32/+0x33 | BYTE_VERIFIED |
| id 16 Pocahontas → reset native alarm/tension toward power | @asm 03BDDD..03BE4B (two loops, settle tables 0x8D4E/0x8D4A) | BYTE_VERIFIED |
| id 18 Simon Bolivar → meter `[0x53D0]+=0x14` clamp 0x64, human only | @asm 03BE64 `add [0x53d0],0x14`; 03BE6C `cmp 0x64` | BYTE_VERIFIED |
| id 22 Jean de Brebeuf → set mission flag 0x10 on settlements owned by power | @asm 03BE91 `[bx+5]&0xf`; 03BEA2 `or byte [bx+5],0x10` (NativeSettlement+0x05) | BYTE_VERIFIED |
| id 24 Bartolome de las Casas → unit subtype 0x1B→0x1C | @asm 03BEDB `cmp [bx+0x315b],0x1b`; 03BEE2 `mov [bx+0x315b],0x1c`; +2nd pass via 0xc54/0xcae | BYTE_VERIFIED → confirms unit subtype 0x1B=Indian Convert, 0x1C=Free Colonist |
| id 6 Coronado → reveal all colonies of all powers | @asm 03BF54..03BF83 loop `[0x539e]`, `lcall 0x7aa` | BYTE_VERIFIED |
| id 20 William Brewster → dock-pool 0x19/0x1A→0x1C, 3 slots at PowerRecord+0x02..+0x04 | @asm 03BF98/03BF9F `cmp [bx+si-0x77f6],0x19/0x1a`; 03BFAB set 0x1C | BYTE_VERIFIED → PowerRecord+0x02 begins the 3-byte immigration pool |
| FF_TABLE (id, category, 3 era weights) | NAMES.TXT @FATHERS @ file 0x3047 (verbatim) | BYTE_VERIFIED (data) |
| In-CATEGORY unlock rule (not global age ladder) | NAMES.TXT @FOUNDING @ file 0x2F03 comment | BYTE_VERIFIED (data) |
| FF "owned" bitmap PowerRecord+0x07 set on acquire | NOT written in this function (only count+0x14 / slot+0x12) | TBD — caller/congress path |
| Bell accumulator (+0x0C/+0x0E) + Continental-Congress trigger + bell COST curve (85,103,…) | not located; cost table not in NAMES.TXT, no cited EXE offset | TBD (RECONSTRUCTED formulas removed from recruit.c) |
| Helper bodies behind every `0x181F:NNNN` lcall | resolved target file offsets cited in effects.c | TBD |

### Note / follow-up
~~`include/ff.h` still contains a WRONG reconstructed FF-id ordering~~ —
**RESOLVED (stale note, 2026-05-30).** ff.h was corrected to the verified @FATHERS
order back in the ff.h/@FATHERS pass and re-confirmed by the FF Congress port
(2026-05-30): de Soto=7, Hudson=8, La Salle=9, … Las Casas=24, FF_COUNT=25, all
matching effects.c/recruit.c. Do NOT "re-fix" ff.h — it is already correct.

---

## SAVE/LOAD format + SCORING byte-trace (2026-05-29)

Four `src/` files rewritten from fabricated content to strict cite-or-TBD:
`src/save/save_serializer.c`, `src/save/load_deserializer.c`,
`src/scoring/compute.c`, `src/scoring/endgame.c`. Fabrications removed:
"COLONY94" magic, save version byte, XOR-rotate checksum, `DIFFICULTY_SCORE_MULT
={50,100,150,200,250}`, SCORE_PER_COLONIST=5, SCORE_PER_FF=50, REVOLUTION_BONUS
=1000, treasury/100, bells/50, `(1820-year)*10`, "INDEPDAY.PIK"/"KING_WIN.PIK",
MUSIC_VICTORY, "year>=1850" timeout, "CLOSING.EXE" chain, HallFameEntry layout.

### SAVE-FILE NAMING (DOS) — corrects the `.COL`/`COL2`/v3 assumption

| Claim | Evidence | Status |
|-------|----------|--------|
| DOS save name = `"COLONY"` + slot + `".SAV"` (two adjacent literals) | @bytes file **0x1FA82** `43 4F 4C 4F 4E 59 00` ("COLONY\0"); file **0x1FA89** `2E 53 41 56 00` (".SAV\0"); "(EMPTY)" slot label @0x1FA8C | BYTE_VERIFIED |
| `.COL` / `COL2` magic / version 3 is the **Win16** format, NOT DOS | DOS EXE has no "COL2"; `CONFIG.COL` @0x1F9F9 is the only `.COL` (a config file). col_to_trace.py / colowin SAVE_FORMAT.md describe Win16 colonize.exe | BYTE_VERIFIED (the conflation is the bug) |
| Save/Load UI message keys | @bytes "SAVEGAME"@0x1FA96, "SAVEGOOD"@0x1FA9F, "SAVEMEM"@0x1FAA8, "SAVEERROR"@0x1FAB0, "LOADGAME"@0x1FABA, "LOADGOOD"@0x1FAC3, "LOADNOT"@0x1FACC, "LOADOLD"@0x1FAD4 | BYTE_VERIFIED (locations); key→meaning ANCHOR_VERIFIED |
| Save/Load uses a buffered STREAM layer (not direct INT 21h from game state) | page_1C.asm: stream OPEN func_076E50@0x076E50 (LCALL 0x181F:0xE86=DOS open), WRITE func_0775EC@0x0775EC, READ func_077100@0x077100, SEEK func_0772FA@0x0772FA, CLOSE func_07706C@0x07706C; struct +0x06 handle/+0x04 mode/+0x14-0x16 buf/+0x28 count | BYTE_VERIFIED (structural) |
| ~~Colony record reader~~ → RTLink/overlay-EXE record reader (CORRECTED 2026-05-30) | func_011F6E @**0x011F6E** (403 B) is the C-runtime/RTLink reader for VICEROY's own overlay/EXE segments, NOT the savegame colony loader: MZ/ZM exe-magic @0x01207A `81 7e e2 5a 4d` / @0x012081 `81 7e e2 4d 5a`; caller chain 0x0103FC→0x011B56(_searchenv)→0x012102(fopen+searchpath)→0x011F6E; malloc(0xAE)=RTLink scratch (ColonyRecord match coincidental) | BYTE_VERIFIED — supersedes the "fills colony array" misattribution. Real game-state SERIALIZER is overlay-resident (0x181F/0x191F/0x1A1F thunks) → on-disk order/header/checksum TBD for a verified reason |
| Load menu framework | func_0759E8 @0x0759E8: "OPENMENU"@0x1FCDC, "MAPTOLOAD"@0x1FCFC, "*.MP"@0x1FCF7, "AMER2.MP"@0x1F2166 | BYTE_VERIFIED (structural, 2026-05-04) |
| On-disk SECTION ORDER (Power/Colony/Unit/Native/Map/discovery), header, checksum | serializer not isolated to one offset; not traced | **TBD** |

In-memory table strides used by the serializer (all per docs/RULINGS.md
2026-05-28): UnitRecord 0x3144/0x1C, ColonyRecord 0x5D46/0xCA (work buf 0xAE),
PowerRecord 0x8808/0x13C, NativeSettlement 0x54EC/0x12 — BYTE_VERIFIED strides;
their *disk* strides are TBD.

### SCORING — `func_051EF4` @0x051EF4 (page 0x0D) — ROLE CORRECTED 2026-05-30

> **⚠️ ROLE WITHDRAWN.** This section was titled "score_tick_for_power" and
> framed func_051EF4 as a per-turn SCORE accumulator into `*(0x84FC)+0x2A`.
> Wave-3 byte-work established **+0x2A = GOLD** (UI-verified +0x2A=1920→Gold
> 19200%; LCR credits winnings via `add [bx+0x8832]`; RULINGS 2026-05-30) and
> `compute.c` CORRECTION 1 confirms it. So func_051EF4 is a per-turn
> **gold/income tick**, not a score tick. The arithmetic rows below remain
> BYTE_VERIFIED (they correctly trace what gets computed and added); only the
> word "score" is wrong — read it as "the per-turn gold credit". The real
> end-of-game SCORE is the rank ladder in `func_03A9C0` (compute.c CORRECTION 2)
> over an overlay-resident raw value at 0x191F:0x3AA (TBD).

Per-power per-turn **gold/income** increment, hand-decompiled from
`code/VICEROY/disasm/func_051EF4_unknown.asm`. The amount is **accumulated
incrementally** into the 32-bit gold field at PowerRecord+0x2A.

| Claim | Evidence | Status |
|-------|----------|--------|
| Score accumulator = `int32 *(0x84FC)+0x2A` (active power's PowerRecord+0x2A) | @asm 051F7C `mov bx,[0x84FC]`; 051F80 `add [bx+0x2a],ax`; 051F83 `adc [bx+0x2c],dx`. 0x84FC = g_active_power (ledger 2026-05-02 + FF entry 2026-05-29) | BYTE_VERIFIED |
| `base = metric[power] + (year-1500)/50` | @asm 051F1F `ax=[0x538A]`; 051F22 `-0x5DC`; 051F29 `idiv 50`; 051F2E `cl=[bx-0x6D68]`; 051F34 `add` | BYTE_VERIFIED (metric byte table semantics TBD) |
| `if (turn < 20) base = 0` | @asm 051F39 `cmp [0x538E],0x14`; 051F40 `mov [bp-0x10],0` | BYTE_VERIFIED |
| `if (year >= 1700) base *= 2` | @asm 051F45 `cmp [0x538A],0x6A4`; 051F4D `shl …,1` | BYTE_VERIFIED |
| difficulty scaling: `acc = base*diff; diff==3 → *1.5; diff==4 → *2; then *4` | @asm 051F50 `al=[0x53A6]`/`imul`; 051F5B `cmp 3`/`sar+add`; 051F6A `cmp 4`/`shl`; 051F74 `shl …,2` | BYTE_VERIFIED — supersedes fabricated {50,100,150,200,250} table |
| year @0x538A, turn @0x538E, difficulty @0x53A6, colony-count @0x539E | cross-confirmed (king tax, raze, FF) | BYTE_VERIFIED |
| high-water-mark tracking vs `[0x9796]/[0x97A8]/[0x97AE]`; SoL/event bonuses @0x5206E.. | @asm 0x52157/0x52177/0x52197 (32-bit max+store); 0x5206E reads [bx-0x6D68]/[bx-0x6BF4]/[bx-0x6BEC]/[bx-0x6BDC] | BYTE_VERIFIED present; purpose/formula **TBD** |
| FINAL endgame total + revolution/year bonus + component breakdown | endgame total render lives in func_0759E8/075xxx region; not decompiled | **TBD** |

### ENDGAME / Hall of Fame

| Claim | Evidence | Status |
|-------|----------|--------|
| Win-state strings exist | @bytes "VICTORY"@0x1EAE3, "REVOLUTION"@0x1ED1B, "CONTINENTAL"@0x1F566, "INDEPENDENT"@0x1EBA8 | BYTE_VERIFIED (locations) |
| Hall of Fame file = `HALLFAME.DAT`, fopen("rb")/("wb") | @bytes "HALLFAME.DAT"@0x1EB92 & 0x1EBC7, "rb"/"wb" flanking; "SCORE"@0x1EB6F/0x1EB89 | BYTE_VERIFIED (file+mode) |
| HALLFAME.DAT DOS record layout (3×42 + 82 deco + u16 csum) | only the **Win16** 210-byte file is decoded (colowin hallfame_format.py); DOS reader/writer not traced | **TBD** for DOS |
| Game-over trigger set / "1850 timeout" | no 1850/0x73A threshold in EXE; only era gates 0x640/0x672/0x6A4/0x6D6 | **TBD** (1850 was fabricated) |
| Endgame `chain_to_exe("CLOSING.EXE")` | "CLOSING.EXE" string NOT in EXE; AH=4Bh loader = dos_exec_load_overlay_4B3@0x01287A | **TBD** (fabricated, removed) |

### Follow-ups (single-function traces to close the gaps)
1. Turn-loop caller of func_051EF4 → end-of-game branch + win-state enum + final total.
2. HALLFAME.DAT reader/writer (fopen sites referencing ptr to string @0x1EB92) → real DOS entry layout + sort/insert.
3. The game-state serializer driving the page-0x1C stream (gated by SAVEGAME@0x1FA96) → on-disk section order + header.

---

## UI screens byte-trace + de-fabrication (2026-05-29)

Five `src/ui/` files rewritten from fabricated content to strict cite-or-TBD:
`colony_screen.c`, `europe_screen.c`, `dialog.c`, `title_screen.c`,
`hall_of_fame.c`. The in-game HUD and full-screen UIs are OVERLAY-emitted
(resident EXE sets state + clip rect + dispatches; the pixel draw is overlay-
resident), so most per-screen draw code is honestly TBD. What was citable was
cited; fabricated PIK names, coordinates, structs, and strings were removed.

### dialog.c — `compute_dialog_rect_from_cursor` = func_067DC8 (BYTE_VERIFIED)

Hand-decompiled from `code/VICEROY/disasm/func_067DC8_unknown.asm` (cross-cited
docs/DIALOG_GEOMETRY.md). File 0x067DC8..0x067E09 (65 B).

| Claim | Evidence | Status |
|-------|----------|--------|
| Popup rect = 4 DGROUP words at 0x839E/0x83A0/0x83A2/0x83A4; only ever written via `LEA bx,[0x839E]`+indirect call (0 direct-MOV hits EXE-wide) | @asm 067DFE `LEA bx,[0x839E]`; docs/DIALOG_GEOMETRY.md byte-scan | BYTE_VERIFIED |
| Gate: setter runs only if `[0x186] >= 0x64` | @asm 067DDA `CMP [0x186],0x64`; 067DDF `JL` | BYTE_VERIFIED |
| `arg1(x) = [0xA5A4] + [0x1EA4] - 8` ; `arg2(y) = [0xA5A6] + [0x1EA5] - 0xF` ; arg3=cursor_x [0x174] ; arg4=cursor_y [0x176] | @asm 067DE1..067DFB (PUSH order R-to-L) | BYTE_VERIFIED |
| Setter call `LCALL 0x181F:0x254` → thunk @file 0x01A844 (type B) → overlay 0x0C36:0x000A | @asm 067E02; typeA_thunk_targets.json | BYTE_VERIFIED (target); setter **file offset TBD** (seg 0x0C36 unresolved) |
| arg→field mapping in [0x839E..0x83A4]; the WOODFRAM/WOODTILE frame + FONTSMAL text DRAW | overlay-resident, undecoded | **TBD** |
| Upstream writers: cursor_x [0x174]@0x0765AC, cursor_y [0x176]@0x0765AF, font_cell_w [0xA5A4]@0x068771, font_cell_h [0xA5A6]@0x06872C | docs/DIALOG_GEOMETRY.md | BYTE_VERIFIED; [0x186]/[0x1EA4]/[0x1EA5] writers **TBD** |

Sibling setters at func_067E8C / func_075352 / func_075FB6 (other LEA-[0x839E]
sites) may use different formulas → TBD. Removed fabrications: Dialog/
DialogButton structs, DIALOG_X/Y/W/H=(40,40,240,120), save/restore_screen_region,
show_yes_no/alert/error labels, KING_DEMAND_TABLE[7] + demand string, FF picker.

### colony_screen.c / europe_screen.c (data + geometry cited; draw TBD)

| Claim | Evidence | Status |
|-------|----------|--------|
| Colony data: ColonyRecord 0x5D46/0xCA; name +0x02, size +0x1F, stockpile +0x9A (16×u16), SoL ratio +0xC2/+0xC6 | docs/DATA_MODEL.md (Plymouth +0x9A runtime-matched frame 1310196718) | BYTE_VERIFIED |
| Colony band geometry (title 0..8, scene 0..199, minimap 224..296, mid-band 128..178, stockpile 8..178 16×19px) | docs/RENDERER_GEOMETRY.md "Colony screen VERIFIED v3" (frame 1310196718) | FRAME_VERIFIED |
| Europe data: PowerRecord 0x8808/0x13C; boycott +0x20, gold +0x2A, market_sensitivity +0x4C (0xC8=saturated) | docs/DATA_MODEL.md | BYTE_VERIFIED |
| Europe geometry (title 0..8, transaction 8..45, dock 45..135, button col 270, stockpile 179) + @EUROLABEL {RECRUIT,PURCHASE,TRAIN,x} | docs/RENDERER_GEOMETRY.md "Europe v3"; docs/LABELS_TXT_CATALOG.md | FRAME_VERIFIED / BYTE_VERIFIED (strings) |
| Assets: colony = composed BUILDING.SS scene + COLONY.PIK strip + WOODPANL.PIK; europe = EUROPE.PIK + COLONY.PIK strip; @CTITLE label set | SCREEN_ASSET_REQUIREMENTS.md; COLONIZE_DATA_FILES_INDEX.md (.PIK names) | VERIFIED-by-catalog (PIK load call sites TBD; names not in resident strings.json) |
| Per-sprite blit order, building (x,y) placement, build-menu hit-test, market/recruit/ship click dispatch | overlay-resident, undecoded | **TBD** |

Removed fabrications: full-screen "COLONY.PIK", ring/building/stock pixel coords,
worker_slots[16], building[]/hammers/hammers_required/sol_pct/tory_pct/
defense_strength, BUILDING_SS_SPRITE/GOOD_ICON_SPRITE/SPRITE_EMPTY_SLOT (colony);
sell_price[]/buy_price[]/recruit_pool[]/recruit_cost_for_type/custom_house_enabled
/ship cargo layout + market/recruit/dock coords (europe).

### title_screen.c (asset/string facts cited; menu+dispatch TBD)

| Claim | Evidence | Status |
|-------|----------|--------|
| Boot/title PIKs: MPSLOGO, MPSNAME, OPENING ("OCEANVS OCCIDENTALIS" world map), OPENMENU (menu over OPENING), OPENBORD (border) | docs/SESSION_UI_CATALOG.md | VERIFIED-by-catalog |
| New-game PIKs: NATIONS (4 flag plaques), DIFFICUL (Discoverer/Explorer/Conquistador/Governor/Viceroy), CUSTOMIZ | docs/SESSION_UI_CATALOG.md; COLONIZE_DATA_FILES_INDEX.md | VERIFIED-by-catalog |
| Opening cinematic is a SEPARATE program OPENING.EXE (OPENING.TXT + PATH.DAT + AMERICA.MOV), not a resident loop | docs/ASSET_ROLES.md | BYTE_VERIFIED (file roles) |
| Setup label strings (Easiest..Toughest, European Power, CUSTOMIZE NEW WORLD, Land Mass/Form, …) | docs/LABELS_TXT_CATALOG.md | BYTE_VERIFIED (strings) |
| Main-menu item list/order, layout, dispatch targets | overlay-resident, undecoded | **TBD** |

Removed fabrications: "TITLE.PIK", SPRITE_LOGO@(32,32), 5-item menu literals at
(120,100), chain_to_exe("OPENING.EXE")/ask_difficulty/ask_power/ask_map flow.

### hall_of_fame.c (file+strings cited; DOS record layout TBD)

| Claim | Evidence | Status |
|-------|----------|--------|
| HALLFAME.DAT @0x1EB92/0x1EBC7, fopen("rb")/("wb"); "SCORE"@0x1EB6F/0x1EB89 | VERIFICATION_LEDGER "ENDGAME" 2026-05-29; strings.json | BYTE_VERIFIED |
| Column strings: "COLONIZATION HALL OF FAME","President","General, Continental Army","Leader","Score","Colonization_Rating","to","A.D." | docs/LABELS_TXT_CATALOG.md "Hall of Fame" | BYTE_VERIFIED (strings) |
| Writer ~func_03ADA6; ~1362 B detected | docs/DATA_MODEL.md | ANCHOR (heuristic size, not record-traced) |
| DOS per-record byte layout / entry count / sort+insert | only Win16 210-B form decoded (colowin) | **TBD for DOS** |

Removed fabrications: HallFameEntry{player_name[20]/nation[16]/score/year_won/
difficulty/reserved/timestamp}, g_hof[10] array, "HOF.PIK", "HALL OF FAME"
title + column coords, hallfame_insert/save with dos_time_now timestamps.

---

## Native subsystem byte-trace extension (2026-05-30)

**Wave-13 add:** `func_49600` native trade haggling resolver (src/native/haggle.c,
0x49600..0x4A37A, 3451B, ENTER 0xD8, thunk @0x1CA3C) — **BYTE_VERIFIED** BUY/SELL
price formulas + gold transfers (PowerRecord+0x2A via [bx-0x77ce] @0x49B92/0x4A1C8):
SELL `(base-diff-want2+mood+4)*2 *stock +mood*5 *qty/100 /2`; BUY `ask 0xC8 + tier/
display-price + rand - relation*4, *qty/100, +diff, floor 0x32`; 4-way BADHAGGLE
escalation. Inputs 0x97C0/@CARGO-col0, 0x7B44 display price, 0x5B1C relation, 0x8DC4
qty. Dialog/format thunk bodies + data-table contents [TBD].

Continued the NATIVE subsystem from the re-segmented overlay
(`code/VICEROY/disasm_overlay_reseg/`). Touched only
`src/native/{tribe_query.c (new), raid.c, settlement.c}` and
`include/native.h`. Page 0x0C code_base = 0x46600 (confirmed via
overlay_pages.json + the disasm file/page-offset columns).

### NativeSettlement +0x02 = POWER INDEX, not raw tribe id (BYTE_VERIFIED)

| Claim | Evidence | Status |
|-------|----------|--------|
| `NativeSettlement.owner` (+0x02) stores `tribe_id + 4` (natives = powers 4..11) | @asm 0x046FC9 `add ax,4` then 0x046FDF `cmp [bx+0x54EE],al` (func_046FC2); independently @asm 0x046DE9/0x046DFB read +0x02 and index a table by `(class-4)` (func_046DE0) | BYTE_VERIFIED |
| Raw tribe id recovered as `owner - 4` | both sites agree on the +4 bias; matches native-unit owner-nibble test `[bx+0x3147]&0xF >= 4` (raid.c) | BYTE_VERIFIED |

`include/native.h` updated: `owner` field comment + `TRIBE_TO_POWER`/
`POWER_TO_TRIBE` macros. settlement.c `native_settlement_add` still writes
`[bp+6]` raw — the caller passes the already-biased power index.

### func_046FC2 — settlement-by-owner iterator (BYTE_VERIFIED loop)

`src/native/tribe_query.c` (new). File 0x046FC2..0x046FF9 (56 bytes).

| Claim | Evidence | Status |
|-------|----------|--------|
| Descending walk `i = count(0x539A)-1 .. 0`, stride 0x12 | @asm 0x046FCF..0x046FF6 | BYTE_VERIFIED |
| Match key = `tribe+4` vs record +0x02 | @asm 0x046FC9 / 0x046FDF | BYTE_VERIFIED |
| Per-match action = near `call 0x5402` → `ljmp 0x191F:0x0248` | @asm 0x046FE9; trampoline @0x04BA02 | ANCHOR_VERIFIED (target in opaque overlay 0x191F → action TBD) |

### func_05BE84 raid outcome roll + dispatch (BYTE_VERIFIED control flow)

Extends `src/native/raid.c`. Corroborates the existing "Native raid outcome
breakdown" table (sound codes 0x4F/0x4E/0x5B independently re-derived — MATCH).

| Claim | Evidence | Status |
|-------|----------|--------|
| Outcome = `random_int(1,4)` | @asm 0x05BF35 `push 4;push 1;LCALL 0x181F:0x04D4`; random_int = func_00C322 (ledger row 2) | BYTE_VERIFIED |
| 5-way dispatch on final `[bp-4]` (0=NOTHING,1=STORES,2=WREAK,3=GOLD,4=BURN/SHIP) | @asm 0x05C023..0x05C03B (dec/je/jmp chain to 0x16EE/0x177A/0x1902/0x194A/0x185F) | BYTE_VERIFIED |
| Difficulty/feasibility remaps reduce outcome via `0x181F:0x09FC(k)` predicates | @asm 0x05BF44..0x05C01E | ANCHOR_VERIFIED (predicate semantics TBD) |
| `0x181F:0x04C0` = play_sound (SFX before each message) | @asm 0x05C39C / 0x05C5ED / 0x05C62D `mov ax,SFX;LCALL 0x181F:0x04C0` | ANCHOR_VERIFIED |
| Per-branch loot magnitudes | branches cross many unresolved thunks | TBD |

### 0x54F6 alarm/tension array (BYTE_VERIFIED index shape + threshold)

| Claim | Evidence | Status |
|-------|----------|--------|
| Word array, index `A*9 + B` (row stride 9), threshold 0x80 | @asm 0x04734E `cmp [bx+0x54F6],0x80` & 0x047487 (read) with bx=`(link*9+j)*2`; @asm 0x05C651 clear with bx=`(raider*9+victim)*2` | BYTE_VERIFIED (indexing + threshold) |
| One axis = raiding settlement/unit-home index; other = power index | the two index expressions (link / raider vs j / victim) | BYTE_VERIFIED (axes) |
| Stored-value units + what raises it toward 0x80 | not traced | TBD |

### Tribe eliminate / redistribute (BYTE_VERIFIED; CORRECTION)

settlement.c STEP 3 of `native_settlement_remove` — the prior banner said the
removed settlement's +0x08/+0x0A were "spread evenly across remaining
settlements." **CORRECTED**: the code modifies the removed record IN PLACE,
scaling each field down by `n/(n+1)`.

| Claim | Evidence | Status |
|-------|----------|--------|
| `tribe_settlement_count_dec`: `dec byte [tribe-0x69D6]`, eliminate when 0 | @asm 0x46F65 `dec [bx-0x69D6]`; 0x46F69 `je` | BYTE_VERIFIED |
| `native_tribe_eliminate`: `[removed+3] \|= 0x80` + extinction message @seg 0x14D4 | @asm 0x46F96 `or [bx+3],0x80`; 0x46FB3 `push 0x14D4;LCALL 0x181F:0x652` | BYTE_VERIFIED (flag); ANCHOR_VERIFIED (message) |
| `native_tribe_redistribute`: `field += field / (0xFFFF-n)` = `field*n/(n+1)` (byte +0x08, word +0x0A) | @asm 0x46F6F..0x46F8A (`cwd;idiv cx`, cx=0xFFFF-n=-(n+1)) | BYTE_VERIFIED arithmetic |
| Meaning of +0x08 (0xFF at create, inc'd by STORES raid) / +0x0A fields | create @0x46EAE sets 0xFF; STORES raid @0x05C3E1/0x05C3E4 inc/add | byte ops verified; semantics TBD |

### Cross-source flag (not resolved here)

`LCALL 0x181F:0x04D4` is byte-verified as `random_int(lo,hi)` (func_00C322,
ledger row 2; combat.c; this raid trace). `src/king/king_tax_raise.c`
interprets the SAME thunk as an "ask king, returns 1=accept" dialog call —
**inconsistent**. Left for a `cross-source-reconciler` pass; the native files
use the byte-verified random_int reading.

---

## Top-level audit summary (2026-05-02)

### What IS byte-verified

| Claim                                             | Source        | Status         |
|---------------------------------------------------|---------------|----------------|
| VICEROY.EXE total size = 494,910 bytes            | `os.path.getsize` | BYTE_VERIFIED |
| MZ header bytes (entry CS:IP = 110D:071D)         | header.asm    | BYTE_VERIFIED |
| Code load image at 0x002400..0x00DDDD             | anchor_map.md | BYTE_VERIFIED |
| DGROUP region 0x010000..0x01FFFF                  | anchor_map.md | BYTE_VERIFIED |
| `entry_point` at file 0x013BED, 10 bytes          | anchor_map.md | BYTE_VERIFIED |
| `system_init` at 0x013BF7, 1,368 bytes            | anchor_map.md | BYTE_VERIFIED |
| `rtlink_loader_A` at 0x01427B                     | anchor_map.md | BYTE_VERIFIED |
| `rtlink_loader_B` at 0x01426B                     | anchor_map.md | BYTE_VERIFIED |
| `rtlink_overlay_thunk_table` at 0x01A5F0..0x01D5E6, 1020 thunks | anchor_map.md | BYTE_VERIFIED |
| Overlay region 0x020665..0x078DEE                 | anchor_map.md | BYTE_VERIFIED |
| 1,241 function boundaries (filename-correct)      | functions.json | BYTE_VERIFIED |
| `map_width` global at DGROUP:0x853A               | anchor_map.md | BYTE_VERIFIED |
| `map_height` global at DGROUP:0x853C              | anchor_map.md | BYTE_VERIFIED |
| `unit_table base` at DGROUP:0x3144, stride 0x1C   | func_04007E @0x4009E (write x) | BYTE_VERIFIED |
| `colony_t*` ptr at DGROUP:0x8542 (102 callers)    | anchor_map.md | BYTE_VERIFIED |
| 872 distinct DGROUP global addresses              | hot_globals.md | BYTE_VERIFIED |
| NAMES.TXT section name table at file 0x01FB4C     | bytes match | BYTE_VERIFIED |

### What is ANCHOR_VERIFIED (anchor exists, value not byte-confirmed)

| Claim                                             | Anchor source |
|---------------------------------------------------|---------------|
| ColonyRecord stride 0x202 / colony_t 174 bytes    | anchor_map.md derived from accessor copy lengths |
| PowerRecord stride 0x13C                          | anchor_map.md |
| UnitRecord stride 0x1C                            | unit_field_lookup_simple decompile |
| 21 base terrain types                             | NAMES.TXT @TERRAIN sections counted |
| 25 Founding Fathers in NAMES.TXT @FATHER          | NAMES.TXT raw string count |
| 8 tribes in NAMES.TXT @TRIBE                      | NAMES.TXT raw string count |
| 16 commodity slots                                | colony_turn_update produces 16 → 5 production chains |
| 39 building IDs (BLD_NONE..BLD_FUR_FACTORY_END)   | NAMES.TXT @BUILDING |
| `_open` / `_read` / `_close` / `_write`           | hand-decompiled in iolib/ |
| Asset filename strings (VICEROY.PAL, AMER2.MP, etc.) | strings.json |

### What is RECONSTRUCTED (NEEDS WORK — bar not yet met)

The following files contain claims that are plausible but **not yet
byte-verified or anchor-verified**. Every line in them needs a verification
status before this tree meets the project's stated bar.

#### `data/` tables — all DGROUP offsets need re-anchoring

The file offsets I attached to these (`0x05000`, `0x06530`, `0x07A00`,
`0x09800`, `0x0B400`, `0x07D00`, `0x08400`, `0x01DB32`) were chosen
*from accumulated knowledge*, not verified. A spot-check on
2026-05-02 confirmed:

- `0x05000` — actually CODE bytes, not DGROUP (DGROUP starts at 0x10000)
- `0x06530` — CODE
- `0x07A00` — CODE
- `0x09800` — CODE
- `0x0B400` — CODE
- `0x01DB32` — appears to contain plausible data (word values 0x0006, 0x0001, 0x0002…) but not yet byte-confirmed against documented building cost table

| File                             | Status         | Required work |
|----------------------------------|----------------|---------------|
| `data/terrain_yield.c` table values | RECONSTRUCTED | Find actual table in DGROUP (likely 0x10000+ region), read bytes |
| `data/unit_classes.c` 45-entry table | RECONSTRUCTED | Same |
| `data/building_costs.c` 39-entry × 16-byte table | RECONSTRUCTED (offset 0x01DB32 promising) | Verify actual bytes match |
| `data/ff_effects.c` 25-entry × 12-byte | RECONSTRUCTED | Find table |
| `data/kings_demands.c` 7-stage escalation | RECONSTRUCTED | Find actual demand schedule |
| `data/scenario_starts.c` 4×4 starts | RECONSTRUCTED | Find table |
| `data/commodity_prices.c` 16×16-byte | RECONSTRUCTED | Find table |
| `data/tribe_data.c` 8×24-byte | RECONSTRUCTED | Find table |

### UNIT subsystem byte-trace (2026-05-30, wave-5) — verified vs RAW EXE

NOTE: the re-segmented pages DRIFT here (page_15 mis-decodes 0x06958; page_17 folds
0x06E94 into a bogus 2820B func_06E3D0) — the "C8-imm16 false-ENTER" hazard cutting
the OTHER way. Raw COLONIZE/VICEROY.EXE was the arbiter; I re-confirmed 5 headline
offsets byte-exact (0x4007E=c8 02 00 00; 0x6958=88 87 44 31; 0x66C4=8b 9c 5e 31;
0x4E2D6=c8 ee 00 00; 0x6EE2=e8→0x68AA).

| Claim | Evidence | Status |
|-------|----------|--------|
| unit_create (func_04007E) allocs at [0x539C]++, off-map (0xFF,0xFF), type=(flag?0x0D:0), moves=0xFF | @asm 0x040085/0x04009E/0x0400AF (ENTER 2 @0x4007E) | BYTE_VERIFIED |
| unit_place_on_tile (func_00693A) writes x/y, inserts at chain HEAD (prev=-1,next=oldhead,oldhead.prev=new) | @asm 0x06958(mov[bx+0x3144],al)/0x06962/0x06976 | BYTE_VERIFIED |
| unit_chain_unlink (func_0068AA) patches prev.next & next.prev, off-maps unit | @asm 0x068CB/0x068E7/0x0692D | BYTE_VERIFIED |
| unit_destroy (func_006E94, ENTER 8) count--, REP-MOVSW compaction, renumber links>idx, fix [0x5392] | @asm 0x06EE2(call→0x68AA)/0x06F0B(rep movsw cx=0xE)/0x06F52 | BYTE_VERIFIED |
| **CORRECTION**: func_0066BA returns chain_next (UnitRecord+0x1A), NOT type | @asm 0x066C4 mov bx,[si+0x315E] (0x3144+0x1A) | BYTE_VERIFIED |
| func_006672 walks chain_prev (+0x18) to head; func_0066CC tile→head via 0x037F:0xA/0x314 | @asm 0x0667C/0x06689/0x066DF | BYTE_VERIFIED (edges; helper bodies TBD) |
| unit_move_step (func_04E2D6, ENTER 0xEE) order-byte dispatch: 0/5/6/>=0xA proceed; 1-4,7-9 busy-skip | @asm 0x04E2FE/0x04E313(jae)/0x04E347(validity gate 0x181F:0x302) | BYTE_VERIFIED (head/dispatch) |
| unit_move_step per-candidate scoring tail (file 0x6218+, data-resident weight tables) | — | **TBD** |

Files: src/unit/{lifecycle,chain,move}.c (committed 0b4aae4); duplicate-symbol collision with
src/render/units.c stubs resolved centrally (those stubs removed — chain.c owns the real bodies).

### UI screens byte-trace — overlay handlers decoded (2026-05-30, wave-5)

**Wave-14 add:** `func_43074` = cursor-tile / unit-stack INFO PANEL renderer
(src/render/tile_info_panel.c, 0x43074..0x443C9, 4950B, ENTER 0xC0, thunk
0x181F:0x424) — **BYTE_VERIFIED** (control flow + globals + field offsets). Reads
cursor 0x8540/0x853E, PowerRecord gold +0x2A / tax +0x01 for DISPLAY, UnitRecord
fields; ONLY write = panel extent [0x9E56] @0x443B0; ZERO turn-counter refs.
ROLE-CORRECTED from the NEXT_TARGETS "per-power turn dispatcher" guess (false).
Supersedes the fabricated 85B func_043074_snd_sz_85 stub in overlay_040C1E_04458A.c
(to retire when that file is batch-promoted). label-ptr tables / 0x5230 / text-helper bodies [TBD].

Prior `src/ui/` work wrongly tagged these "overlay-resident TBD"; they are fully
byte-readable in `disasm_overlay_reseg/page_*.asm`. Found via string-key xref
(file_offset = handle + 0x1D9A0); 8 keys re-confirmed exact + push/prologue bytes.

| Claim | Evidence | Status |
|-------|----------|--------|
| europe_ship_click=func_03314E: keys EUROPESHIPCLICK(0x1005)/EUROPESHIPOPTIONS(0x1015)/SOMEBOYCOTT(0x1027); UnitRecord type [bx+0x3146]; stat row stride-14 @0x5230 | @asm 0x03318D/0x0331AD/0x033152(6b 5e 06 1c)/0x03331A | BYTE_VERIFIED (struct+keys); GUI-leaf calls ANCHOR |
| europe_open=func_030DBC: key EUROPE(0xFBA), dispatch 0x191F:0x87A, enter-view 0x181F:0x772 | @asm 0x030DCE(68 ba 0f)/0x030DD1/0x030DEE | BYTE_VERIFIED (struct); leaf internals ANCHOR |
| report_open=func_037340: strcpy REPORT(0x11A2)→lookup(0x181F:0x182)→dispatch(0x181F:0x44E) over region[0x2DA8]; content engine func_072090 IDENTIFIED (body TBD) | @asm 0x037344(68 a2 11)/0x03735B/0x03737F | BYTE_VERIFIED (dispatch) |
| king_audience=func_075352: nation portrait by [0x5398] (ENGLND/FRANCE/SPAIN/DUTCH); KING1/KINGLOSE/KINGWIN; FONTKING(0x232B) font swap; 2 portraits rect[0x839E..0x83A4] | @asm 0x07536E(68 f2 22)/0x0753B8/0x0754F2 | BYTE_VERIFIED (sites); draw thunks ANCHOR |
| func_022F08 over-merged record SPLIT into 4 RETF funcs: find_city@0x022F08(ENTER 4)/game_options@0x022FD6/colony_report_options@0x02311A/sound_options@0x0232AE; GAME.TXT bit maps 0x5382..0x5386 | @asm 0x022F08(c8 04 00 00)/0x022FD6(9a..)/page_01 RETF boundaries | BYTE_VERIFIED |
| game_command_dispatch=func_0235D6: screen-mode arm [0x1F5E] (Europe=4/Report=5); F-key report sub-dispatch 0x41..0x49 | @asm 0x0236D3(c7 06 5e 1f 04 00)/0x02381D/0x023843 | STRUCTURE BYTE_VERIFIED; leaf cmds TBD |

Files: src/ui/{europe_screen,report_screen,king_audience,options_dialog,main_loop,colony_screen}.c
(committed f59e2b6). Makefile OBJS_UI added. SCOPE FLAG: func_02F052/func_02F3A2
(KINGTAX/REF) are king *military* logic → belong in src/king/ (wave-6), NOT ported in ui.

### King-military + GUI-engine byte-trace (2026-05-30, wave-6)

Both per-func dumps for these targets were truncated 7×–30×; raw EXE + reseg pages
(page_02/page_03, no drift) are authoritative. All headline offsets re-verified byte-exact.

| Claim | Evidence | Status |
|-------|----------|--------|
| func_02F052=king_process_power_events: ship REFIT + KINGTAX grant; REFIT key 0xEEF; sets [0x14C]=1; spawn king unit type 0x11 | @asm 0x2F052(c8 0a 00 00)/0x2F1D7(68 ef 0e)/0x2F201(c7 06 4c 01 01 00); file 0x2F052..0x2F3A0 (847B) | BYTE_VERIFIED (flow); helper semantics TBD |
| func_02F3A2=king_war_turn (WoI): defeat yr>=1600, king-warning gate, at-war REF-landing matrix budget (8-diff)*10, dated msgs 1790/1800/1840/1850; 15 keys verified | @asm 0x2F3A2(c8 78 00 00)/0x2F3FD(cmp yr,1600)/0x2FAE8(cb); file 1869B | BYTE_VERIFIED (structure); per-arm spawn coords TBD |
| func_03CDA2 REF per-arm landing decrement | @asm 0x3D4C0 dec word[bx+0x53DA], bx=arm*2 | BYTE_VERIFIED (resolves a ref.c TBD) |
| func_02883E=colony-services menu dispatcher: 22-entry CS jump-table @0x028AF0 decoded w/ per-arm string xrefs | @asm 0x2883E(c8 6a 00 00)/0x28AEB(2e ff a7 f0 31 JMP cs:[bx+0x31f0])/0x28D88(tail); file 0x2883E..0x028D8B (1357B, NOT 138) | ANCHOR_VERIFIED (dispatch+strings; per-arm popups TBD) |
| func_028D8C=colony build/dialog engine: colony [0x8542], cursor [0x8D7C], win_create 0x191F:0x23C, modal loop, result [0x034E] | @asm 0x28D8C(c8 48 01 00)/0x28DA9(3b 06 7c 8d)/0x29238(win_create)/0x298A2(tail); file ~2841B (NOT 185) | ANCHOR_VERIFIED (control flow; blit leaves TBD) |
| page-0x17 control model: menu_lookup_run=func_06F51A (signature (void), reads staged descriptor); opt-flag bitmask [0x1F54]; descriptor base [0x87C]; screen-mode builder [0x1F5E]=func_06F5F2 | @asm 0x6F5F8 (a3 5e 1f mov[0x1F5E],ax) | BYTE_VERIFIED |

Files: src/king/{king_events,war_turn}.c + ref.c (75bumped); src/ui/{menu(new),dialog}.c.
GUI reconciliation: (1) king_audience.c's "0x181F:0x3FE→func_028D8C" was imprecise →
func_06F594 (corrected in that file). (2) main_loop.c's `menu_lookup_key(int,int,int)`
== func_06F51A which is (void) — 3-arg form is a caller-side approximation (symbol-unify TBD).

### RTLink overlay wall — STATICALLY RESOLVABLE (2026-05-30, wave-8 + dreammaster ref)

VICEROY.EXE is RTLink/Plus **Version 2** (byte-confirmed: numRelocations 2260, no .OVL,
markers "Enter directory for $" @0x1A5B7 + "MS Run-Time" @0x1D9A8 + "RTLink" @0x1A25D;
this is the variant dreammaster/tools rtlink_decode handles — user-provided lead). The
cross-page call graph is fully static; the "wall" was an artifact of an undecoded
trampoline layer + two wrong addresses. A Python V2 flattener is being built under
tools/rtlink/. See docs/OVERLAY_THUNKS.md for the full per-thunk verdicts.

| Claim | Evidence | Status |
|-------|----------|--------|
| Thunk table = ONE block @file 0x1A5F0..0x1D5E6, three overlapping windows: file_base = codeOffset(0x2400)+seg*16 -> 0x181F=0x1A5F0/0x191F=0x1B5F0/0x1A1F=0x1C5F0 | verified 0x2400+0x181F*16=0x1A5F0; thunks at all three start `9a ab 0d 0d 11` | BYTE_VERIFIED |
| Thunk format: `9A AB 0D 0D 11` (LCALL 0x110D:0x0DAB loader) + `EA off seg` (JMPF) + trailer word = target PAGE-ID. 0x110D = resident loader seg (entry CS), never a target | @0x1A5F0/0x1C004/0x1CCD0 verified | BYTE_VERIFIED |
| LAND-COMBAT DECIDER = func_05CA7E (file 0x5CA7E, ENTER 0xDE c8 de 00 00, page 0x10) -> wrapper func_05BE30 (ENTER 2) -> applier func_05B2C2; chain via trampoline 0x5E723 `EA e0 06 1f 1a` = JMPF 0x1A1F:0x06E0 = thunk @0x1CCD0 (page 0x10 +0x0352). func_05CA7E reached by LCALL 0x191F:0x0A14 (thunk @0x1C004) from func_02D3C6/func_03ECF0/func_04E2D6. (Same routine as the per-unit AI leaf in src/ai/unit_ai_leaf.c — land-combat is one facet; its land-odds FORMULA is [TBD], next decode target.) OVERTURNS land.c's [TBD]/0x1BAAA framing. | all bytes verified | BYTE_VERIFIED (chain); decider formula TBD |
| REPORT-CONTENT renderers = 9 page-0x05 functions (file 0x37958/0x37A10/0x38418/0x38A50/0x39218/0x3954C/0x39888/0x3744A/0x387E8), reached by the static CMP/LCALL ladder in func_0235D6 (NOT func_072090, which only builds the menu) | prologues all `c8 NN 00 00` (ENTER) verified | BYTE_VERIFIED (entries); bodies TBD |

#### `src/` system modules — formulas need byte-traced derivation

| File                              | Reconstructed claims |
|-----------------------------------|---------------------|
| `src/render/terrain.c`            | TERRAIN_SS_BASE / PHYS0 row IDs (SOME verified per CLAUDE.md, others reconstructed) |
| `src/render/units.c`              | ICONS_UNIT_SPRITE per-type indices (SOME verified, others reconstructed) |
| `src/combat/combat.c`             | **BYTE_VERIFIED** resolver (func_05B2C2). Roll @0x5B819 = `random_int(1,DEF+ATK); atk wins if roll<=ATK` — but it is **SHIP-ATTACKER-ONLY** (gate @0x5B7B6, type 0x0D..0x12; land jmp 0x5BAA3). Modifiers RESOLVED 2026-05-30 (see combat_modifiers.c). (SUPERSEDES never-existed resolve.c/modifiers.c rows.) |
| `src/combat/combat_demotion_ladder.c` | **BYTE_VERIFIED** demotion sub-table of func_05B2C2 (SUPERSEDES the never-existed demotion.c row) |
| `src/combat/combat_modifiers.c`   | **BYTE_VERIFIED mechanism** — "+50% fortified" REFUTED (roll uses raw 0x523b/0x523c, no scale); 0x5B433 fort block = capture-eligibility threshold (0x5237/0x5238); real modifier layer = post-roll per-power strength compare @0x5B85B..0x5BA2D (difficulty MUL [0x5325]); per-power array SoL/defense semantics TBD. **Land-combat DECIDER decoded 2026-05-30 (wave-9, src/ai/unit_ai_leaf.c func_05CA7E):** land = ATK/(ATK+DEF) `random_int(1,atk+def)` @0x5D188 on DERIVED strengths from columns 0x5235/0x5236 (accessors 0x07C2A/0x07D3E) — same odds form as ships, different stat pair; func_05B2C2 stays consequence-only. |
| `src/combat/naval.c`              | **BYTE_VERIFIED** func_03FDDE ship move/landfall/ship-combat dispatch @0x3FDDE..0x40002 (548B; overrules functions.json 82B truncation + reseg phantom func_03FF4C); 9-entry jump table @0x3FF44; strings LANDFALL/SHIPCOMBAT/SHIPLAKE/SAILHOME/NODOCKS/EUROPENOTLEAVE/LANDFIRST |
| `src/combat/land.c`               | **BYTE_VERIFIED control flow (wave-7)** — func_05B2C2 is the combat-CONSEQUENCE applier, NOT the land decider. LAND combat has NO ATK/DEF roll in the EXE (0x523b/0x523c each read exactly once — independently re-scanned — both ship-gated). Land attacker bypasses roll+compare via gate @0x5B7B6 (jmp 0x5BAA3). Outcome router @0x5BAA3 (cmp [bp-0x3a],0) dispatches WIN (@0x5BAAC: msg-table @0x5D48, unit flags\|=0x80 @0x5BB9E, spoils via per-type 0x5235) vs LOSE (@0x5BC84: DEMOTE ladder/destroy). The land win/loss DECIDER is the CALLER, behind RTLink (thunk file 0x1BAAA = 0x110D:0xA9DA) = [TBD]. @UNIT col->offset map [TBD-data]. |
| `src/market/pricing.c`            | Drift/decay arithmetic |
| `src/market/boycott.c`            | Tea Party SoL +25 / king anger +10 |
| `src/king/demands.c`              | Demand fire-chance formula |
| `src/king/ref.c`                  | REF growth + REF effective-strength formula |
| `src/native/settlement.c`         | NATIVE_GROWTH_PCT, MISSION_CONVERT_PCT, **settlement_treasure_value()** |
| `src/native/raid.c`               | Aggression / raid trigger / colony burn logic |
| `src/native/mission.c`            | Convert spawn rate |
| `src/founding_fathers/recruit.c`  | **PARTIAL** — FF_TABLE (@FATHERS) + in-category unlock rule BYTE_VERIFIED; bell pool growth + bell COST curve still RECONSTRUCTED (see 2026-05-29 entry) |
| `src/founding_fathers/effects.c`  | **BYTE_VERIFIED** — full per-FF effect dispatch decompiled from func_03BC42 @0x03BC42 (see 2026-05-29 entry) |
| `src/random_events/lcr.c`         | LCR_WEIGHTS table (11 outcomes), `lcr_resolve()` |
| `src/random_events/weather.c`     | 5% bad-weather chance, -1 movement, -25% production |
| `src/random_events/disease.c`     | Disease-risk table per terrain |
| `src/scoring/compute.c`           | **PARTIAL — ROLE CORRECTED 2026-05-30**: func_051EF4@0x051EF4 credits `*(0x84FC)+0x2A` each turn, but **+0x2A = GOLD** (UI-verified, LCR-corroborated; wave-3 RULINGS) — so func_051EF4 is a per-turn **gold/income tick**, NOT a "score tick". The arithmetic (base + difficulty x1/1.5/2 then x4) stays BYTE_VERIFIED; only the "score" framing is WITHDRAWN. Real endgame score = the rank ladder in func_03A9C0 over an overlay-resident raw value (0x191F:0x3AA, TBD). Prior {5,50,1000,...} numbers were fabricated, removed. |
| `src/scoring/endgame.c`           | **PARTIAL** — win-state strings + HALLFAME.DAT fopen BYTE_VERIFIED; win-flow, HoF layout, 1850 timeout, CLOSING.EXE all TBD/removed (see 2026-05-29 entry). |
| `src/ai/*`                        | EU per-unit chain (func_03ECF0/func_040E22/func_05CA7E) + driver/unit_orders ported; **native_unit_ai.c (func_046FFA, wave-8) BYTE_VERIFIED structure** (native per-unit AI: 0x54F6 alarm thr 0x80, INDIANSURPRISE, argmax move-tasking; weight tables 0x2F77/0x5236/0x9410 [TBD]). Remaining AI scoring weights are data-resident [TBD]. |
| `src/diplomacy/treaty.c`          | **BYTE_VERIFIED** — treaty/war/peace state machine `treaty_set_state` decompiled from func_057DC0 @0x057DC0 (see 2026-05-29 entry) |
| `src/diplomacy/relations.c`       | **PARTIAL** — relation-state storage (PowerRecord+0x40 matrix) + flag bits BYTE_VERIFIED; numeric attitude/score model still TBD |
| `src/diplomacy/* (proposal/AI)`   | Treaty proposal scoring — RECONSTRUCTED |
| `src/mapgen/*`                    | All map generation parameters |
| `src/save/*`                      | **SERIALIZER DECODED wave-10** (via RTLink tool) — SAVE driver func_0734F8@0x734F8, LOAD func_073BB0@0x73BB0 (page 0x1A 2nd-seg base 0x73270; reached 0x1A1F:0xCF6/0xD12 from SAVEGAME/LOADGAME orchestrators func_072F7A/func_073158). **DOS magic = "COLONIZE"+0x1A** (file 0x1FB1A; "COL2" is Win16-only). On-disk order BYTE_VERIFIED (header→globals 0x5380→names 0x540E→ColonyRecord ×**0xCA**→UnitRecord count[0x539C]×0x1C→PowerRecord 4×0x13C→NativeSettlement count[0x539A]×0x12→…→4 map layers); NO checksum (verified by absence); I/O via resident MSC lib (window 0xD1D). Resolves g_unit_count 0x539C. (func_011F6E remains the overlay-EXE record reader, not savegame.) [TBD]: version@0x81A runtime value; ~30 per-power scalar blocks' field meanings. |
| `src/audio/*`                     | Audio device probes (mix of standard DOS + reconstructed) |
| `src/ui/title_screen.c`           | **PARTIAL** — boot/menu PIK asset names (MPSLOGO/OPENING/OPENMENU/OPENBORD, NATIONS/DIFFICUL/CUSTOMIZ) + setup label strings VERIFIED-by-catalog; menu item list/layout/dispatch overlay-resident TBD. Fabricated TITLE.PIK/SPRITE_LOGO/menu coords/dispatch removed (see UI entry 2026-05-29) |
| `src/ui/colony_screen.c`          | **UPGRADED 2026-05-30 (wave-5)** — colony OPEN path (func_0321B4) + colony_report_options decoded BYTE_VERIFIED (NOT "overlay-resident TBD" — that prior claim was wrong; handlers are byte-readable in reseg). ColonyRecord sources (0x5D46/0xCA; stockpile +0x9A) cited. See "UI screens byte-trace" section. |
| `src/ui/europe_screen.c`          | **UPGRADED 2026-05-30 (wave-5)** — europe_ship_click=func_03314E + europe_open=func_030DBC + europe_clip_blit BYTE_VERIFIED (NOT "overlay-resident TBD"). PowerRecord sources (boycott +0x20, gold +0x2A, market +0x4C) cited; GUI-leaf draw thunks ANCHOR. See "UI screens byte-trace" section. |
| `src/ui/dialog.c`                 | **PARTIAL** — `compute_dialog_rect_from_cursor`=func_067DC8 @0x067DC8 BYTE_VERIFIED (rect formula + globals 0x174/0x176/0x186/0x1EA4/0x1EA5/0xA5A4/0xA5A6 + setter LCALL 0x181F:0x254); overlay setter file offset + WOODFRAM frame/text draw TBD. Fabricated Dialog struct/DIALOG_X.../save_region/KING_DEMAND_TABLE removed (see UI entry 2026-05-29) |
| `src/ui/hall_of_fame.c`           | **PARTIAL** — HALLFAME.DAT fopen("rb"/"wb") @0x1EB92/0x1EBC7 + @MISC column strings ("COLONIZATION HALL OF FAME"/President/Leader/Score/Colonization_Rating) BYTE_VERIFIED; DOS record layout TBD (only Win16 210-B decoded). Fabricated HallFameEntry/g_hof[10]/HOF.PIK/insert logic removed (see UI entry 2026-05-29) |
| `src/ui/main_loop.c`              | **PARTIAL (wave-5)** — game_command_dispatch=func_0235D6 structure BYTE_VERIFIED (screen-mode arm [0x1F5E] Europe=4/Report=5; F-key sub-dispatch 0x41..0x49); leaf command handlers (unit orders/save/zoom) TBD. See "UI screens byte-trace" section. |
| `src/ui/report_screen.c`          | **wave-5 + wave-9** — report_open=func_037340 dispatch; func_072090=build_menubar (NOT report content); the 9 page-0x05 F-key report renderers DECODED (wave-9, via RTLink tool): F2 Religious 0x37958 / F3 Congress 0x37A10 / F4 Labor 0x38418 / F5 Economic 0x38A50 / F6 Colony 0x39218 / F7 Naval 0x3954C / F8 Foreign 0x39888 / F9 Indian 0x3744A / F10 Score 0x38778. CONTENT byte-verified; per-row draw primitives ANCHOR. Player-context selector func_030550 (0x181F:0x582): [bp+6]=active player, sets [0x9E12] + [0x84FC]=0x8808+player*0x13C (re-confirms PowerRecord base/stride). |
| `src/ui/king_audience.c`          | **NEW wave-5** — func_075352 BYTE_VERIFIED (nation portrait by [0x5398]; FONTKING font swap; rect 0x839E..0x83A4); draw thunks ANCHOR. |
| `src/ui/options_dialog.c`         | **NEW wave-5** — func_022F08 cluster (find_city/game_options/colony_report_options/sound_options) BYTE_VERIFIED; GAME.TXT bit maps 0x5382..0x5386. |

#### `formats/` — most are documented from accumulated knowledge

| File                | Status |
|---------------------|--------|
| `formats/PAL.md`    | ANCHOR_VERIFIED (file size matches 783 bytes) |
| `formats/SS.md`     | ANCHOR_VERIFIED (8-byte magic confirmed in extracted files) |
| `formats/PIK.md`    | ANCHOR_VERIFIED (RLE algorithm decoded against extracted bytes) |
| `formats/MP.md`     | ANCHOR_VERIFIED (3 layers × 4176 = 12,528 confirmed in file size) |
| Other format specs  | RECONSTRUCTED |

#### `docs/` — narrative reconstructions

All narrative formula claims in `docs/COMBAT.md`, `docs/AI_SYSTEM.md`,
`docs/SCORING.md`, etc. are RECONSTRUCTED unless cross-cited to a
hand-decompiled function in `code/VICEROY/decompiled.md`.

---

## What "byte-verified" looks like, concretely

A fully byte-verified entry should look like this:

```c
/* @asm           code/VICEROY/disasm/func_064A10_compute_raze_treasure.asm
 * @asm_offset    0x064A10..0x064A6F (96 bytes)
 * @bytes         [tribe_wealth_table] at file 0x012F40, 8 × 2 bytes:
 *                  90 00 5F 00 28 00 23 00 2D 00 32 00 32 00 32 00
 * @decompile     mov ax,[bx+0x12F40]   ; load tribe_wealth[tribe]
 *                imul ax,[bp-2]        ; * type_mult (loaded from table at +0x12F50)
 *                ...
 * @verified_by   reapply_hand_ports.py + manual review 2026-05-02
 */
int compute_raze_treasure(int tribe, int settlement_type) { ... }
```

Anything less than this is RECONSTRUCTED.

---

## Priorities for closing the gap

The user-facing-question test: any time the user asks "what's the
min/max gold for X" or "what's the formula for Y", I should be able to
point to bytes. If I can't, the answer is "RECONSTRUCTED, here's the
plausible answer; here's the function I need to hand-decompile."

Ordered backlog of claims most likely to be asked about:

1. **Native settlement raze treasure** — `settlement_treasure_value()`
   formula + randomization
2. **Combat resolution** — exact roll formula, modifier stacking
3. **Building costs** — hammers/tools per building (table at 0x01DB32 promising)
4. **Founding Father bell costs** — escalation formula
5. **King's tax escalation** — fire chance + tax delta
6. **REF growth rate** — turns + treasury scaling
7. **Market price drift** — volume threshold + drift amounts
8. **LCR outcome weights** — 11-outcome distribution
9. **SoL / Tory percentages** — bell-per-colonist threshold
10. **Score formula** — per-component multipliers, difficulty
11. **Map generation** — climate transitions, mountain placement

Each of these maps to one or a few overlay functions. Hand-decompiling
those functions is the work to close the gap.

---

## COLONY production-support cluster byte-trace (2026-05-30)

Ported the load-image helpers the three big colony-economy functions
(`compute_terrain_yield` 0x9B9C, `compute_colony_center_yields` 0xA222,
`colony_turn_update` 0xA3E1) and the per-colonist handler 0x9FFC depend on.
These were previously `extern`-declared-only in `turn_update.c` (one-line
cites) with empty `return 0; /* TODO */` skeletons in the load_image auto-tree.
Full bodies were re-disassembled from `COLONIZE/VICEROY.EXE` (capstone, 16-bit)
because the `disasm/func_*.asm` auto-segmenter had **truncated** several of them
mid-instruction (e.g. `func_008524` cut at 18 B; the real body is 142 B).

New file: **`src/colony/production_support.c`** (all definitions below).
Header decls added to `include/colony.h`. Colony struct `colony_t` got two
fields named at +0xC2/+0xC4 (a latent 2-byte struct hole that had pushed
`cumulative_c6` to land at +0xC4 instead of +0xC6 — now corrected).

| Function | @asm range | Status | Key spot-check offsets |
|----------|-----------|--------|------------------------|
| `test_colony_building_bit(bit,colony_idx)` | 0x860E..0x861D | **BYTE_VERIFIED** | 0x861E `IMUL si,[bp+6],0xCA`; 0x8629 `MOV al,[bx+si+0x5DCA]` |
| `test_building_or_father_bit(bit)` | 0x863E..0x864D | **BYTE_VERIFIED** | 0x8644 `PUSH [0x8DC6]`; 0x8649 `CALL 0x860E` |
| `count_building_chain_present(start)` | 0x864E..0x8684 | **BYTE_VERIFIED** | 0x865B `CALL 0x863E`; 0x8674 `MOV al,[bx-0x707A]` (=0x8F86, stride 12 via `(idx*3)<<2`) |
| `count_building_chain_present_colony` | 0x8686..0x86BF | **BYTE_VERIFIED** (no LI caller) | 0x8696 `CALL 0x860E`; 0x86AF chain read |
| `building_chain_walk_to_top(start)` | 0x86C0..0x86E2 | **BYTE_VERIFIED** (1st-iter ret edge-case TBD; no LI caller) | 0x86C3 `JMP 0x86CE`; 0x86DA `CMP [bx-0x707A],0` |
| `highest_building_chain_bit_set(start)` | 0x86E4..0x871F | **BYTE_VERIFIED** | 0x86F4 `CALL 0x863E`; 0x870D chain read; 0x8715 `CMP [bp+6],0/JGE` |
| `sol_membership_pct()` (= `rebel_sentiment_pct`) | 0x8524..0x85B1 | **BYTE_VERIFIED** | 0x8531/0x8535 read [+0xC2]/[+0xC4]; 0x8557 `LCALL 0xD1D:0xF60` (x100); 0x855E `LCALL 0xD1D:0xEC6` (/B); 0x859F `ADD ax,0x14` |
| `func_2D658` SoL/Tory+training+food turn handler (UPDATES what sol_membership_pct reads) — wave-12, src/colony/sol_tory.c | 0x2D658..0x2EABB (5220B, thunk 0x191F:0x688) | **BYTE_VERIFIED** (extent+formulas) | bell EMA `A+=bells-(A>>6)` @0x2DA9C, threshold `B-=B>>6` @0x2DA3C (ColonyRecord +0xC2/+0xC6); Tory div 10-diff @0x2DCBC; REBELMAJORITY rebel%>=50 @0x2DB29; per-power bells tally **PowerRecord+0x2E** (0x8836) @0x2E6C0 — NEW field, distinct from +0x0C/0x0E FF bells; report-format leaves [TBD] |
| `func_053B7E` colony AI auto-manage (work re-alloc + build planner + status flags) — wave-12, src/colony/auto_manage.c. **NOT KINGTAX** (NEXT_TARGETS tag was false; 0 king handles pushed). | 0x53B7E..0x5628C (9999B, ENTER 0x1C0, thunk 0x1A1F:0x35E) | **BYTE_VERIFIED** (spine + all 0x8542/king/0x35E writes; 14 spot-checks) | status flags *(0x8542)+0x1B bit4 @0x5419E; king build debit king[+0x2A]/[+0x2C] @0x5493B (cost 0x14*kingcost[owner<<4 @0x84CA]); result [0x35E]=1 @0x54FC9; mfg-goods jump tbl @0x5563E. Per-good/per-power weight tables [TBD] |
| `lookup_signed_2F4(index)` | 0x8D9C..0x8DBA | **BYTE_VERIFIED** | 0x8DA5 `CMP [bp+6],0x13/JGE`; 0x8DAE `MOV al,[bx+0x2F4]`; CWDE |
| `commodity_net_minus_chain(idx,*out)` | 0x8DBC..0x8E00 | **BYTE_VERIFIED** (no LI caller) | 0x8DC5/0x8DC9 `[0x8DC8]-[0x8E0A]`; 0x8DD3 `CMP [bx+0x2A2],0`; 0x8DE6 `SUB ...,[0x8E5A]` |
| `update_finished_good_from_raw(raw,fin)` | 0x8E84..0x8F01 | **BYTE_VERIFIED** | 0x8E9B `CALL 0x8D9C`; 0x8EA3 `CALL 0x864E`; 0x8EA9 `CMP ax,2/JLE`+`x2/3`; 0x8EC3 `CALL 0x8E46`; 0x8EED `x3/2` |

### Identification basis (cite-or-TBD honesty)
None of these leaves has a direct message-key STRING xref — they are pure
bit/table/arithmetic helpers. Roles established by **byte-trace + callgraph**
(which big colony function calls them, with what args). The SoL% role
(`func_008524`) is corroborated by the `REBELMAJORITY / REBELUNANIMOUS /
TORYMINORITY / TORYMAJORITY / REBELUP50 / REBELUP / REBELDOWN` message-key
family in `strings.json` and by the existing +0xC2/+0xC6 "SoL ratio" data cite
in colony_screen.c (UI entry 2026-05-29). The +20 bonus is the Jan-de-Witt
founding father (FF flag op 0x12 via `LCALL 0x981:0`).

### Corrected prior semantics
- `building_present_count` was documented "0 or 1" — the byte trace proves it is
  a **chain-present COUNT** (walks the stride-12 chain at DGROUP:0x8F86 counting
  set bits in the current colony). `update_finished_good_from_raw` uses
  `count > 2` as its factory-tier threshold (@asm 0x8EA9).
- `highest_building_le` walks that same chain to the highest **set** link.
- The building/feature bit-array is keyed on the **persistent ColonyRecord**
  (DGROUP:0x5DCA + colony_idx*0xCA), not the +0x84/+0x8A working-buffer arrays;
  `g_8DC6` is the current-colony INDEX (writer overlay-resident -> TBD).

### New globals discovered (declared `extern` w/ cited addrs; BSS defs TBD by data owner)
`g_8DC6` (0x8DC6 current-colony idx), `g_colony_bits_5DCA` (0x5DCA),
`g_byte_2F4` (0x2F4 chain-start id per good), `g_byte_2A2` (0x2A2 related-raw id
per good). Numeric contents are NAMES.TXT/overlay-driven -> values TBD.

### Still TBD
- numeric cells of DGROUP:0x2F4 / 0x2A2 / the 0x8F86 chain table (data-driven)
- which @BUILDING the >2 chain-count maps to (the forge/factory production cap)
- the writer of `g_8DC6` (overlay-resident)
- advances backlog item **9 (SoL / Tory percentages)**: SoL membership % formula
  now byte-verified; the bell-per-colonist threshold lives in the +0xC6
  accumulator (incremented +100/colonist-growth @asm 0x9453). TORY% and the
  REBEL*/TORY* threshold dispatch remain overlay-resident TBD.

---

## BINARY AVAILABLE — toolchain rebuilt in-repo (2026-06-07)

The user supplied `COLONIZE/VICEROY.EXE` (494,910 bytes, sha256
`a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3`). Prior
sessions lacked the binary in-repo and were blocked on byte-verification. A
from-scratch analysis toolchain now lives in `viceroy_source/tools/`
(`viceroy_exe.py`, `strings_scan.py`, `funcscan.py`, `audit.py`); the binary +
generated disasm stay in the git-ignored `re_work/`.

**Calibration (independent rebuild reproduces every documented anchor):**
- load_base 0x2400 (e_cparhdr 576); entry 110D:071D @file 0x13BED; init SS:SP 25E5:4096
- 2260 relocations; image_len/overlay-start 0x20665 — all match docs exactly
- thunk[0] @0x1A5F0 = `9a ab 0d 0d 11` (LCALL 0x110D:0x0DAB) — exact
- 788 strings located; every documented key (VICEROY.EXE@0x19951, SMITEINDIANS
  dg 0x1a1a, KINGTAX dg 0x0f01, BURNED dg 0x1c28, TEAPARTY dg 0x106a, …) at its
  documented offset; DGROUP string base 0x1D9A0 confirmed
- funcscan: 1,248 prologue-seeded functions (matches documented 1,241), 98% clean RETF

**`audit.py`: 27/27 headline BYTE_VERIFIED claims re-confirmed against this exact
binary** — rand() LCG, unit_create/place/move, king tax cap=75, PowerRecord base
0x8808, FF dispatch (count++ @0x3BD37, slot @0x3BD3A), treaty imul 0x13c,
combat resolver prologue, gold-tick `add [bx+0x2a],ax`, dialog rect LEA [0x839e],
colony bit `[bx+si+0x5dca]`, native owner +4, report renderers. Two initial
mismatches were harness off-by-ones (rand mov dx @0x103D7 not 0x103D8; dialog
func_067DC8 is `ENTER 4,0` not push-bp), now corrected — the binary matches the
prior reconstruction faithfully. This is the regression baseline; every new
byte-trace appends an assertion here.

---

## Re-verification wave against the supplied binary (2026-06-07)

With VICEROY.EXE now in-repo, three core subsystems were independently
re-traced from the binary (via background agents, every cited offset
spot-checked by hand) and locked into `tools/audit.py` (now 61/61 green). All
confirm — and tighten — the existing source.

### Market price drift — `func_0305A8` (file 0x0305A8 .. 0x030B37, ENTER 0x66)
- Per-turn loop over **16 commodities × 4 powers**; commodity record stride **9**
  (fields +0 min, +1 max, +3 rise_factor, +4 fall_factor, +5 demand) — BSS, loaded
  from NAMES.TXT @CARGO (values [TBD-external]).
- Drift step is **exactly ±1** price unit: `inc byte[bx+di+0x4c]` @0x309B5 (rise),
  `dec` @0x30A4C (fall) on `price_level[16]` = active PowerRecord+0x4C.
- Trigger: volume accumulator `vol_accum[16]` (PowerRecord+0x5C) crossing
  **−100×rise_factor** (al=0x9c @0x30986) to rise, **+100×fall_factor**
  (al=0x64 @0x30A22) to fall; the crossed threshold is subtracted back out
  (hysteresis). Supply→target uses **÷256** (8× sar/rcr @0x30618).
- Euro-supply read per power at **DS:0x8904 = PowerRecord+0xFC**, dword stride 0x13C
  (`imul ...,0x4f` ×4 @0x305CE). Price-target word array **DS:0x53EA** decayed
  @0x30639. Emits **PRICEUP**(DG 0xfa8)/**PRICEDOWN**(DG 0xfb0). Bell-curve reprice
  cap **0x19(25)** @0x30ACE. [TBD] bid/ask spread = overlay thunks 0x181F:0xcc2/0xac4.

### Sons-of-Liberty / Tory — `func_02D658` + `func_008524` (sol_membership_pct)
- membership% = **bell_EMA×100 / threshold_accum**, fields ColonyRecord
  +0xC2/+0xC4 (EMA) over +0xC6/+0xC8 (threshold); ×100 via 0xD1D:0xF60, ÷ via
  0xD1D:0xEC6 @0x8557/0x855E. **+20** Jan de Witt FF bonus `add ax,0x14` @0x859F
  (gated cmp [bx+0x1a],4 + FF-flag table DS:0x543F stride 0x34); clamp **100**
  @0x85A8.
- EMA update `A += bells − (A>>6)`: six sar/rcr (÷64) then `add [bx+0xC2],ax`
  @0x2DA9C. Threshold `B −= B>>6; B += 2×colonists` (`shl ax,1` @0x2DA68).
- **Tory% = 100 − rebel%**; tory_count = pop×tory%/100; tolerated Tories before
  INEFFICIENT = **(10 − difficulty)** (`mov al,[0x53A6]; sub ax,0xa; neg ax`
  @0x2DCBC). Band messages: **REBELMAJORITY ≥50** (cmp 0x32 @0x2DB29),
  **REBELUNANIMOUS ≥100** (cmp 0x64 @0x2DB6E), TORYMINORITY <95, TORYMAJORITY <50,
  SONSUP/SONSDOWN on 10-pt band crossings (+4 hysteresis down). Latched via
  ColonyRecord+0x1C bits {0x02 unanimous, 0x04 majority, 0x08 tory-overload}.
  Per-power bells tally PowerRecord+0x2E (DS:0x8836) `imul ...,0x13c` @0x2E6BA.
- CORRECTION to a prior note: there is **no `TORYFLED` key** (not in the binary);
  the adjacent keys are SONSUP/SONSDOWN/INEFFICIENT/EFFICIENT. REBELUP/REBELUP50/
  REBELDOWN belong to a separate UI func near 0x3E900, not func_02D658.

### Lost City Rumor — `func_061454` (file 0x061454 .. 0x061C9C, ENTER 0x3C)
- Confirms the existing lcr.c: outcome is **procedural, not a weight table**.
  Primary roll **random_int(1,9)** @0x614F6, floored ≥1, then remapped by ~10
  gates (scout/seasoned-scout, per-rumor option [0x5382]&1, tile-value thresholds
  0x18/0x1b/0x1c, roll thresholds 0xA/0x19/0x32/0x41, repeat counters
  [0x1DC6]/[0x1DC7]) before the tail switch `cmp ax,9` @0x61C2C.
- **Scout** = unit type 5 (`cmp byte[bx+0x3146],5` @0x614A6, `imul [bp+6],0x1c`);
  Seasoned Scout role 0x16 → payout shift bonus ∈{0,1,2}.
- Outcome 5 = Fountain of Youth: **8× immigrant queue** (loop 0..8, LCALL
  0x191F:0xd2c). Outcome 9 = Cibola treasure-train (create unit via 0x181F:0x95c).
- Gold to all paths: `imul bx,[0x5394],0x13c; add [bx-0x77ce],ax; adc [bx-0x77cc],dx`
  @0x61C4C = **PowerRecord+0x2A gold dword** (DS:0x8832). UI suppressed for AI
  (guard [bp-8], set only when active==local human player). [TBD] overlay helper
  identities behind the 0x181F/0x191F thunks; caller of the dispatcher.

---

## Endgame scoring rank ladder — `func_03A9C0` (verified 2026-06-07)

The Hall-of-Fame rank ladder is now byte-traced (display/ranking layer; the raw
score-total sum is overlay-resident, see TBD). `func_03A9C0` file 0x03A9C0
(ENTER 0x3C4), early-return RETF @0x3AA08 for score<=0, body extends to 0x3B2F8.

| Claim | Evidence | Status |
|-------|----------|--------|
| raw score from overlay routine 0x191F:0x3AA via thunk 0x3B36A | @asm 0x3A9F5 `push cs; call 0x3b36a`; result -> [bp-0xBE] @0x3A9FC | BYTE_VERIFIED (call); body TBD (overlay) |
| difficulty multiplier = diff+4, +1 if diff>=3, +1 if diff>=4 (0..4 -> 4,5,6,8,10) | @asm 0x3AA0A `mov al,[0x53a6]`; 0x3AA0F `add ax,4`; 0x3AA15 `cmp [0x53a6],3`/inc; 0x3AA20 `cmp ...,4`/inc | BYTE_VERIFIED |
| scaled = (mult * rawScore) / 100 | @asm 0x3AA34 `imul [bp-0xbe]`; 0x3AA38 `mov cx,0x64`; 0x3AA3C `idiv cx` | BYTE_VERIFIED |
| rank = largest i-1 (i=1..24) with i*i/3 < scaled; loop bound 24, cap 23 | @asm 0x3AA4D `imul cx`; 0x3AA4F `mov bx,3`; 0x3AA53 `idiv bx`; 0x3AA63 `cmp ...,0x18`; 0x3AA71 `cmp ax,0x17`/`mov ax,0x17` | BYTE_VERIFIED |
| displayed score = scaled / 2 | @asm 0x3AA6A `sar [bp-2],1` | BYTE_VERIFIED |
| fanfare id by tier: rank 23->0x24, 7..22->0x25, <=6->0x21 | @asm 0x3AD51 `cmp [bp-0xc0],0x17`; 0x3AD58 `mov ax,0x24`; else 0x25/0x21 | BYTE_VERIFIED |
| HOF record builder func_03B2F8 (file 0x3B2F8, ENTER 0x2C, RETF 0x3B368): country-name @[0x5398]*0x34+0x540E, indep flag [0x5382]&1, year [0x538A], difficulty [0x53A6], score from same overlay routine | @asm 0x3B2FC/0x3B317/0x3B329/0x3B335/0x3B33D | BYTE_VERIFIED (record fields); component sum TBD |
| HALLFAME.DAT load/sort/insert func_03ADA6: rep-movsw sort up to 6 records (0x2A words) by descending score field +0x26 | @asm 0x3AED0/0x3AED8 | BYTE_VERIFIED (structure) |
| win-state master flag word [0x5382]: bit0=independence (set @func_03DE46 0x3E031 `or [0x5382],1`), bit3 -> HOF, bit4 suppresses interactive HOF | @asm 0x3E031; 0x3B320; 0x3A9BB `test [0x5382],0x10` | BYTE_VERIFIED |

TBD: (1) the score-TOTAL component formula (colonists/FFs/treasure/rebel
sentiment) is computed inside the RTLink-swapped overlay at 0x191F:0x3AA (thunk
descriptor `05 00 b1 02` -> overlay seg 0x02B1) — not statically resolvable from
the thunk chain; needs the RTLink flattener or a runtime dump. (2) Rank-title
text (Discoverer..Viceroy) is loaded by key+rank from an external message file;
the EXE holds only keys ("SCORE" DG 0x11CF, "EXPLOITS" DG 0x11E0). The string
"Colonization_Rating" is NOT in the EXE (external).

## Coverage instrumented (2026-06-07)

`tools/coverage.py` + `docs/COVERAGE.md`: 1248 functions, 1236 (99%) with @asm
citations, 342 (27%) with a BYTE_VERIFIED-adjacent citation (heuristic upper
bound). audit.py regression baseline now 69/69.
