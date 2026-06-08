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
| `rel_query`/`power_handle`/`power_set_flag`/`ui_notify_key`/`rel_apply_event`/`rel_clear_event` helper BODIES | resolved targets cited (e.g. 0x181F:0x0A38→file 0x5FC30) but not decompiled | not yet decoded |
| Treaty PROPOSAL / AI accept-reject / gold-goods transfer | caller not located | not yet decoded (reconstructed content removed from treaty.c) |

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
| FF "owned" bitmap PowerRecord+0x07 set on acquire | NOT written in this function (only count+0x14 / slot+0x12) | not yet decoded — caller/congress path |
| Bell accumulator (+0x0C/+0x0E) + Continental-Congress trigger + bell COST curve (85,103,…) | not located; cost table not in NAMES.TXT, no cited EXE offset | not yet decoded (reconstructed formulas removed from recruit.c) |
| Helper bodies behind every `0x181F:NNNN` lcall | resolved target file offsets cited in effects.c | not yet decoded |

### Note / follow-up
~~`include/ff.h` still contains a WRONG reconstructed FF-id ordering~~ —
**RESOLVED (stale note, 2026-05-30).** ff.h was corrected to the verified @FATHERS
order back in the ff.h/@FATHERS pass and re-confirmed by the FF Congress port
(2026-05-30): de Soto=7, Hudson=8, La Salle=9, … Las Casas=24, FF_COUNT=25, all
matching effects.c/recruit.c. Do NOT "re-fix" ff.h — it is already correct.

---

## SAVE/LOAD format + SCORING byte-trace (2026-05-29)

Four `src/` files rewritten from fabricated content to strict cite-or-not-yet-decoded:
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
| ~~Colony record reader~~ → RTLink/overlay-EXE record reader (CORRECTED 2026-05-30) | func_011F6E @**0x011F6E** (403 B) is the C-runtime/RTLink reader for VICEROY's own overlay/EXE segments, NOT the savegame colony loader: MZ/ZM exe-magic @0x01207A `81 7e e2 5a 4d` / @0x012081 `81 7e e2 4d 5a`; caller chain 0x0103FC→0x011B56(_searchenv)→0x012102(fopen+searchpath)→0x011F6E; malloc(0xAE)=RTLink scratch (ColonyRecord match coincidental) | BYTE_VERIFIED — supersedes the "fills colony array" misattribution. Real game-state SERIALIZER is overlay-resident (0x181F/0x191F/0x1A1F thunks) → on-disk order/header/checksum not yet decoded for a verified reason |
| Load menu framework | func_0759E8 @0x0759E8: "OPENMENU"@0x1FCDC, "MAPTOLOAD"@0x1FCFC, "*.MP"@0x1FCF7, "AMER2.MP"@0x1F2166 | BYTE_VERIFIED (structural, 2026-05-04) |
| On-disk SECTION ORDER (Power/Colony/Unit/Native/Map/discovery), header, checksum | serializer not isolated to one offset; not traced | **not yet decoded** |

In-memory table strides used by the serializer (all per docs/RULINGS.md
2026-05-28): UnitRecord 0x3144/0x1C, ColonyRecord 0x5D46/0xCA (work buf 0xAE),
PowerRecord 0x8808/0x13C, NativeSettlement 0x54EC/0x12 — BYTE_VERIFIED strides;
their *disk* strides are not yet decoded.

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
> over an overlay-resident raw value at 0x191F:0x3AA (not yet decoded).

Per-power per-turn **gold/income** increment, hand-decompiled from
`code/VICEROY/disasm/func_051EF4_unknown.asm`. The amount is **accumulated
incrementally** into the 32-bit gold field at PowerRecord+0x2A.

| Claim | Evidence | Status |
|-------|----------|--------|
| Score accumulator = `int32 *(0x84FC)+0x2A` (active power's PowerRecord+0x2A) | @asm 051F7C `mov bx,[0x84FC]`; 051F80 `add [bx+0x2a],ax`; 051F83 `adc [bx+0x2c],dx`. 0x84FC = g_active_power (ledger 2026-05-02 + FF entry 2026-05-29) | BYTE_VERIFIED |
| `base = metric[power] + (year-1500)/50` | @asm 051F1F `ax=[0x538A]`; 051F22 `-0x5DC`; 051F29 `idiv 50`; 051F2E `cl=[bx-0x6D68]`; 051F34 `add` | BYTE_VERIFIED (metric byte table semantics not yet decoded) |
| `if (turn < 20) base = 0` | @asm 051F39 `cmp [0x538E],0x14`; 051F40 `mov [bp-0x10],0` | BYTE_VERIFIED |
| `if (year >= 1700) base *= 2` | @asm 051F45 `cmp [0x538A],0x6A4`; 051F4D `shl …,1` | BYTE_VERIFIED |
| difficulty scaling: `acc = base*diff; diff==3 → *1.5; diff==4 → *2; then *4` | @asm 051F50 `al=[0x53A6]`/`imul`; 051F5B `cmp 3`/`sar+add`; 051F6A `cmp 4`/`shl`; 051F74 `shl …,2` | BYTE_VERIFIED — supersedes fabricated {50,100,150,200,250} table |
| year @0x538A, turn @0x538E, difficulty @0x53A6, colony-count @0x539E | cross-confirmed (king tax, raze, FF) | BYTE_VERIFIED |
| high-water-mark tracking vs `[0x9796]/[0x97A8]/[0x97AE]`; SoL/event bonuses @0x5206E.. | @asm 0x52157/0x52177/0x52197 (32-bit max+store); 0x5206E reads [bx-0x6D68]/[bx-0x6BF4]/[bx-0x6BEC]/[bx-0x6BDC] | BYTE_VERIFIED present; purpose/formula **not yet decoded** |
| FINAL endgame total + revolution/year bonus + component breakdown | endgame total render lives in func_0759E8/075xxx region; not decompiled | **not yet decoded** |

### ENDGAME / Hall of Fame

| Claim | Evidence | Status |
|-------|----------|--------|
| Win-state strings exist | @bytes "VICTORY"@0x1EAE3, "REVOLUTION"@0x1ED1B, "CONTINENTAL"@0x1F566, "INDEPENDENT"@0x1EBA8 | BYTE_VERIFIED (locations) |
| Hall of Fame file = `HALLFAME.DAT`, fopen("rb")/("wb") | @bytes "HALLFAME.DAT"@0x1EB92 & 0x1EBC7, "rb"/"wb" flanking; "SCORE"@0x1EB6F/0x1EB89 | BYTE_VERIFIED (file+mode) |
| HALLFAME.DAT DOS record layout (3×42 + 82 deco + u16 csum) | only the **Win16** 210-byte file is decoded (colowin hallfame_format.py); DOS reader/writer not traced | **not yet decoded for DOS** |
| Game-over trigger set / "1850 timeout" | no 1850/0x73A threshold in EXE; only era gates 0x640/0x672/0x6A4/0x6D6 | **not yet decoded** (1850 was fabricated) |
| Endgame `chain_to_exe("CLOSING.EXE")` | "CLOSING.EXE" string NOT in EXE; AH=4Bh loader = dos_exec_load_overlay_4B3@0x01287A | **not yet decoded** (fabricated, removed) |

### Follow-ups (single-function traces to close the gaps)
1. Turn-loop caller of func_051EF4 → end-of-game branch + win-state enum + final total.
2. HALLFAME.DAT reader/writer (fopen sites referencing ptr to string @0x1EB92) → real DOS entry layout + sort/insert.
3. The game-state serializer driving the page-0x1C stream (gated by SAVEGAME@0x1FA96) → on-disk section order + header.

---

## UI screens byte-trace + de-fabrication (2026-05-29)

Five `src/ui/` files rewritten from fabricated content to strict cite-or-not-yet-decoded:
`colony_screen.c`, `europe_screen.c`, `dialog.c`, `title_screen.c`,
`hall_of_fame.c`. The in-game HUD and full-screen UIs are OVERLAY-emitted
(resident EXE sets state + clip rect + dispatches; the pixel draw is overlay-
resident), so most per-screen draw code is honestly not yet decoded. What was citable was
cited; fabricated PIK names, coordinates, structs, and strings were removed.

### dialog.c — `compute_dialog_rect_from_cursor` = func_067DC8 (BYTE_VERIFIED)

Hand-decompiled from `code/VICEROY/disasm/func_067DC8_unknown.asm` (cross-cited
docs/DIALOG_GEOMETRY.md). File 0x067DC8..0x067E09 (65 B).

| Claim | Evidence | Status |
|-------|----------|--------|
| Popup rect = 4 DGROUP words at 0x839E/0x83A0/0x83A2/0x83A4; only ever written via `LEA bx,[0x839E]`+indirect call (0 direct-MOV hits EXE-wide) | @asm 067DFE `LEA bx,[0x839E]`; docs/DIALOG_GEOMETRY.md byte-scan | BYTE_VERIFIED |
| Gate: setter runs only if `[0x186] >= 0x64` | @asm 067DDA `CMP [0x186],0x64`; 067DDF `JL` | BYTE_VERIFIED |
| `arg1(x) = [0xA5A4] + [0x1EA4] - 8` ; `arg2(y) = [0xA5A6] + [0x1EA5] - 0xF` ; arg3=cursor_x [0x174] ; arg4=cursor_y [0x176] | @asm 067DE1..067DFB (PUSH order R-to-L) | BYTE_VERIFIED |
| Setter call `LCALL 0x181F:0x254` → thunk @file 0x01A844 (type B) → overlay 0x0C36:0x000A | @asm 067E02; typeA_thunk_targets.json | BYTE_VERIFIED (target); setter **file offset not yet decoded** (seg 0x0C36 unresolved) |
| arg→field mapping in [0x839E..0x83A4]; the WOODFRAM/WOODTILE frame + FONTSMAL text DRAW | overlay-resident, undecoded | **not yet decoded** |
| Upstream writers: cursor_x [0x174]@0x0765AC, cursor_y [0x176]@0x0765AF, font_cell_w [0xA5A4]@0x068771, font_cell_h [0xA5A6]@0x06872C | docs/DIALOG_GEOMETRY.md | BYTE_VERIFIED; [0x186]/[0x1EA4]/[0x1EA5] writers **not yet decoded** |

Sibling setters at func_067E8C / func_075352 / func_075FB6 (other LEA-[0x839E]
sites) may use different formulas → not yet decoded. Removed fabrications: Dialog/
DialogButton structs, DIALOG_X/Y/W/H=(40,40,240,120), save/restore_screen_region,
show_yes_no/alert/error labels, KING_DEMAND_TABLE[7] + demand string, FF picker.

### colony_screen.c / europe_screen.c (data + geometry cited; draw not yet decoded)

| Claim | Evidence | Status |
|-------|----------|--------|
| Colony data: ColonyRecord 0x5D46/0xCA; name +0x02, size +0x1F, stockpile +0x9A (16×u16), SoL ratio +0xC2/+0xC6 | docs/DATA_MODEL.md (Plymouth +0x9A runtime-matched frame 1310196718) | BYTE_VERIFIED |
| Colony band geometry (title 0..8, scene 0..199, minimap 224..296, mid-band 128..178, stockpile 8..178 16×19px) | docs/RENDERER_GEOMETRY.md "Colony screen VERIFIED v3" (frame 1310196718) | FRAME_VERIFIED |
| Europe data: PowerRecord 0x8808/0x13C; boycott +0x20, gold +0x2A, market_sensitivity +0x4C (0xC8=saturated) | docs/DATA_MODEL.md | BYTE_VERIFIED |
| Europe geometry (title 0..8, transaction 8..45, dock 45..135, button col 270, stockpile 179) + @EUROLABEL {RECRUIT,PURCHASE,TRAIN,x} | docs/RENDERER_GEOMETRY.md "Europe v3"; docs/LABELS_TXT_CATALOG.md | FRAME_VERIFIED / BYTE_VERIFIED (strings) |
| Assets: colony = composed BUILDING.SS scene + COLONY.PIK strip + WOODPANL.PIK; europe = EUROPE.PIK + COLONY.PIK strip; @CTITLE label set | SCREEN_ASSET_REQUIREMENTS.md; COLONIZE_DATA_FILES_INDEX.md (.PIK names) | VERIFIED-by-catalog (PIK load call sites not yet decoded; names not in resident strings.json) |
| Per-sprite blit order, building (x,y) placement, build-menu hit-test, market/recruit/ship click dispatch | overlay-resident, undecoded | **not yet decoded** |

Removed fabrications: full-screen "COLONY.PIK", ring/building/stock pixel coords,
worker_slots[16], building[]/hammers/hammers_required/sol_pct/tory_pct/
defense_strength, BUILDING_SS_SPRITE/GOOD_ICON_SPRITE/SPRITE_EMPTY_SLOT (colony);
sell_price[]/buy_price[]/recruit_pool[]/recruit_cost_for_type/custom_house_enabled
/ship cargo layout + market/recruit/dock coords (europe).

### title_screen.c (asset/string facts cited; menu+dispatch not yet decoded)

| Claim | Evidence | Status |
|-------|----------|--------|
| Boot/title PIKs: MPSLOGO, MPSNAME, OPENING ("OCEANVS OCCIDENTALIS" world map), OPENMENU (menu over OPENING), OPENBORD (border) | docs/SESSION_UI_CATALOG.md | VERIFIED-by-catalog |
| New-game PIKs: NATIONS (4 flag plaques), DIFFICUL (Discoverer/Explorer/Conquistador/Governor/Viceroy), CUSTOMIZ | docs/SESSION_UI_CATALOG.md; COLONIZE_DATA_FILES_INDEX.md | VERIFIED-by-catalog |
| Opening cinematic is a SEPARATE program OPENING.EXE (OPENING.TXT + PATH.DAT + AMERICA.MOV), not a resident loop | docs/ASSET_ROLES.md | BYTE_VERIFIED (file roles) |
| Setup label strings (Easiest..Toughest, European Power, CUSTOMIZE NEW WORLD, Land Mass/Form, …) | docs/LABELS_TXT_CATALOG.md | BYTE_VERIFIED (strings) |
| Main-menu item list/order, layout, dispatch targets | overlay-resident, undecoded | **not yet decoded** |

Removed fabrications: "TITLE.PIK", SPRITE_LOGO@(32,32), 5-item menu literals at
(120,100), chain_to_exe("OPENING.EXE")/ask_difficulty/ask_power/ask_map flow.

### hall_of_fame.c (file+strings cited; DOS record layout not yet decoded)

| Claim | Evidence | Status |
|-------|----------|--------|
| HALLFAME.DAT @0x1EB92/0x1EBC7, fopen("rb")/("wb"); "SCORE"@0x1EB6F/0x1EB89 | VERIFICATION_LEDGER "ENDGAME" 2026-05-29; strings.json | BYTE_VERIFIED |
| Column strings: "COLONIZATION HALL OF FAME","President","General, Continental Army","Leader","Score","Colonization_Rating","to","A.D." | docs/LABELS_TXT_CATALOG.md "Hall of Fame" | BYTE_VERIFIED (strings) |
| Writer ~func_03ADA6; ~1362 B detected | docs/DATA_MODEL.md | ANCHOR (heuristic size, not record-traced) |
| DOS per-record byte layout / entry count / sort+insert | only Win16 210-B form decoded (colowin) | **not yet decoded for DOS** |

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
qty. Dialog/format thunk bodies + data-table contents not yet decoded.

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
| Per-match action = near `call 0x5402` → `ljmp 0x191F:0x0248` | @asm 0x046FE9; trampoline @0x04BA02 | ANCHOR_VERIFIED (target in opaque overlay 0x191F → action not yet decoded) |

### func_05BE84 raid outcome roll + dispatch (BYTE_VERIFIED control flow)

Extends `src/native/raid.c`. Corroborates the existing "Native raid outcome
breakdown" table (sound codes 0x4F/0x4E/0x5B independently re-derived — MATCH).

| Claim | Evidence | Status |
|-------|----------|--------|
| Outcome = `random_int(1,4)` | @asm 0x05BF35 `push 4;push 1;LCALL 0x181F:0x04D4`; random_int = func_00C322 (ledger row 2) | BYTE_VERIFIED |
| 5-way dispatch on final `[bp-4]` (0=NOTHING,1=STORES,2=WREAK,3=GOLD,4=BURN/SHIP) | @asm 0x05C023..0x05C03B (dec/je/jmp chain to 0x16EE/0x177A/0x1902/0x194A/0x185F) | BYTE_VERIFIED |
| Difficulty/feasibility remaps reduce outcome via `0x181F:0x09FC(k)` predicates | @asm 0x05BF44..0x05C01E | ANCHOR_VERIFIED (predicate semantics not yet decoded) |
| `0x181F:0x04C0` = play_sound (SFX before each message) | @asm 0x05C39C / 0x05C5ED / 0x05C62D `mov ax,SFX;LCALL 0x181F:0x04C0` | ANCHOR_VERIFIED |
| Per-branch loot magnitudes | branches cross many unresolved thunks | not yet decoded |

### 0x54F6 alarm/tension array (BYTE_VERIFIED index shape + threshold)

| Claim | Evidence | Status |
|-------|----------|--------|
| Word array, index `A*9 + B` (row stride 9), threshold 0x80 | @asm 0x04734E `cmp [bx+0x54F6],0x80` & 0x047487 (read) with bx=`(link*9+j)*2`; @asm 0x05C651 clear with bx=`(raider*9+victim)*2` | BYTE_VERIFIED (indexing + threshold) |
| One axis = raiding settlement/unit-home index; other = power index | the two index expressions (link / raider vs j / victim) | BYTE_VERIFIED (axes) |
| Stored-value units + what raises it toward 0x80 | not traced | not yet decoded |

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
| Meaning of +0x08 (0xFF at create, inc'd by STORES raid) / +0x0A fields | create @0x46EAE sets 0xFF; STORES raid @0x05C3E1/0x05C3E4 inc/add | byte ops verified; semantics not yet decoded |

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
| func_006672 walks chain_prev (+0x18) to head; func_0066CC tile→head via 0x037F:0xA/0x314 | @asm 0x0667C/0x06689/0x066DF | BYTE_VERIFIED (edges; helper bodies not yet decoded) |
| unit_move_step (func_04E2D6, ENTER 0xEE) order-byte dispatch: 0/5/6/>=0xA proceed; 1-4,7-9 busy-skip | @asm 0x04E2FE/0x04E313(jae)/0x04E347(validity gate 0x181F:0x302) | BYTE_VERIFIED (head/dispatch) |
| unit_move_step per-candidate scoring tail (file 0x6218+, data-resident weight tables) | — | **not yet decoded** |

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
(to retire when that file is batch-promoted). label-ptr tables / 0x5230 / text-helper bodies not yet decoded.

Prior `src/ui/` work wrongly tagged these "overlay-resident not yet decoded"; they are fully
byte-readable in `disasm_overlay_reseg/page_*.asm`. Found via string-key xref
(file_offset = handle + 0x1D9A0); 8 keys re-confirmed exact + push/prologue bytes.

| Claim | Evidence | Status |
|-------|----------|--------|
| europe_ship_click=func_03314E: keys EUROPESHIPCLICK(0x1005)/EUROPESHIPOPTIONS(0x1015)/SOMEBOYCOTT(0x1027); UnitRecord type [bx+0x3146]; stat row stride-14 @0x5230 | @asm 0x03318D/0x0331AD/0x033152(6b 5e 06 1c)/0x03331A | BYTE_VERIFIED (struct+keys); GUI-leaf calls ANCHOR |
| europe_open=func_030DBC: key EUROPE(0xFBA), dispatch 0x191F:0x87A, enter-view 0x181F:0x772 | @asm 0x030DCE(68 ba 0f)/0x030DD1/0x030DEE | BYTE_VERIFIED (struct); leaf internals ANCHOR |
| report_open=func_037340: strcpy REPORT(0x11A2)→lookup(0x181F:0x182)→dispatch(0x181F:0x44E) over region[0x2DA8]; content engine func_072090 IDENTIFIED (body not yet decoded) | @asm 0x037344(68 a2 11)/0x03735B/0x03737F | BYTE_VERIFIED (dispatch) |
| king_audience=func_075352: nation portrait by [0x5398] (ENGLND/FRANCE/SPAIN/DUTCH); KING1/KINGLOSE/KINGWIN; FONTKING(0x232B) font swap; 2 portraits rect[0x839E..0x83A4] | @asm 0x07536E(68 f2 22)/0x0753B8/0x0754F2 | BYTE_VERIFIED (sites); draw thunks ANCHOR |
| func_022F08 over-merged record SPLIT into 4 RETF funcs: find_city@0x022F08(ENTER 4)/game_options@0x022FD6/colony_report_options@0x02311A/sound_options@0x0232AE; GAME.TXT bit maps 0x5382..0x5386 | @asm 0x022F08(c8 04 00 00)/0x022FD6(9a..)/page_01 RETF boundaries | BYTE_VERIFIED |
| game_command_dispatch=func_0235D6: screen-mode arm [0x1F5E] (Europe=4/Report=5); F-key report sub-dispatch 0x41..0x49 | @asm 0x0236D3(c7 06 5e 1f 04 00)/0x02381D/0x023843 | STRUCTURE BYTE_VERIFIED; leaf cmds not yet decoded |

Files: src/ui/{europe_screen,report_screen,king_audience,options_dialog,main_loop,colony_screen}.c
(committed f59e2b6). Makefile OBJS_UI added. SCOPE FLAG: func_02F052/func_02F3A2
(KINGTAX/REF) are king *military* logic → belong in src/king/ (wave-6), NOT ported in ui.

### King-military + GUI-engine byte-trace (2026-05-30, wave-6)

Both per-func dumps for these targets were truncated 7×–30×; raw EXE + reseg pages
(page_02/page_03, no drift) are authoritative. All headline offsets re-verified byte-exact.

| Claim | Evidence | Status |
|-------|----------|--------|
| func_02F052=king_process_power_events: ship REFIT + KINGTAX grant; REFIT key 0xEEF; sets [0x14C]=1; spawn king unit type 0x11 | @asm 0x2F052(c8 0a 00 00)/0x2F1D7(68 ef 0e)/0x2F201(c7 06 4c 01 01 00); file 0x2F052..0x2F3A0 (847B) | BYTE_VERIFIED (flow); helper semantics not yet decoded |
| func_02F3A2=king_war_turn (WoI): defeat yr>=1600, king-warning gate, at-war REF-landing matrix budget (8-diff)*10, dated msgs 1790/1800/1840/1850; 15 keys verified | @asm 0x2F3A2(c8 78 00 00)/0x2F3FD(cmp yr,1600)/0x2FAE8(cb); file 1869B | BYTE_VERIFIED (structure); per-arm spawn coords not yet decoded |
| func_03CDA2 REF per-arm landing decrement | @asm 0x3D4C0 dec word[bx+0x53DA], bx=arm*2 | BYTE_VERIFIED (resolves a ref.c not-yet-decoded item) |
| func_02883E=colony-services menu dispatcher: 22-entry CS jump-table @0x028AF0 decoded w/ per-arm string xrefs | @asm 0x2883E(c8 6a 00 00)/0x28AEB(2e ff a7 f0 31 JMP cs:[bx+0x31f0])/0x28D88(tail); file 0x2883E..0x028D8B (1357B, NOT 138) | ANCHOR_VERIFIED (dispatch+strings; per-arm popups not yet decoded) |
| func_028D8C=colony build/dialog engine: colony [0x8542], cursor [0x8D7C], win_create 0x191F:0x23C, modal loop, result [0x034E] | @asm 0x28D8C(c8 48 01 00)/0x28DA9(3b 06 7c 8d)/0x29238(win_create)/0x298A2(tail); file ~2841B (NOT 185) | ANCHOR_VERIFIED (control flow; blit leaves not yet decoded) |
| page-0x17 control model: menu_lookup_run=func_06F51A (signature (void), reads staged descriptor); opt-flag bitmask [0x1F54]; descriptor base [0x87C]; screen-mode builder [0x1F5E]=func_06F5F2 | @asm 0x6F5F8 (a3 5e 1f mov[0x1F5E],ax) | BYTE_VERIFIED |

Files: src/king/{king_events,war_turn}.c + ref.c (75bumped); src/ui/{menu(new),dialog}.c.
GUI reconciliation: (1) king_audience.c's "0x181F:0x3FE→func_028D8C" was imprecise →
func_06F594 (corrected in that file). (2) main_loop.c's `menu_lookup_key(int,int,int)`
== func_06F51A which is (void) — 3-arg form is a caller-side approximation (symbol-unify not yet decoded).

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
| LAND-COMBAT DECIDER = func_05CA7E (file 0x5CA7E, ENTER 0xDE c8 de 00 00, page 0x10) -> wrapper func_05BE30 (ENTER 2) -> applier func_05B2C2; chain via trampoline 0x5E723 `EA e0 06 1f 1a` = JMPF 0x1A1F:0x06E0 = thunk @0x1CCD0 (page 0x10 +0x0352). func_05CA7E reached by LCALL 0x191F:0x0A14 (thunk @0x1C004) from func_02D3C6/func_03ECF0/func_04E2D6. (Same routine as the per-unit AI leaf in src/ai/unit_ai_leaf.c — land-combat is one facet; its land-odds FORMULA is not yet decoded, next decode target.) OVERTURNS land.c's not-yet-decoded/0x1BAAA framing. | all bytes verified | BYTE_VERIFIED (chain); decider formula not yet decoded |
| REPORT-CONTENT renderers = 9 page-0x05 functions (file 0x37958/0x37A10/0x38418/0x38A50/0x39218/0x3954C/0x39888/0x3744A/0x387E8), reached by the static CMP/LCALL ladder in func_0235D6 (NOT func_072090, which only builds the menu) | prologues all `c8 NN 00 00` (ENTER) verified | BYTE_VERIFIED (entries); bodies not yet decoded |

#### `src/` system modules — formulas need byte-traced derivation

| File                              | Reconstructed claims |
|-----------------------------------|---------------------|
| `src/render/terrain.c`            | TERRAIN_SS_BASE / PHYS0 row IDs (SOME verified per CLAUDE.md, others reconstructed) |
| `src/render/units.c`              | ICONS_UNIT_SPRITE per-type indices (SOME verified, others reconstructed) |
| `src/combat/combat.c`             | **BYTE_VERIFIED** resolver (func_05B2C2). Roll @0x5B819 = `random_int(1,DEF+ATK); atk wins if roll<=ATK` — but it is **SHIP-ATTACKER-ONLY** (gate @0x5B7B6, type 0x0D..0x12; land jmp 0x5BAA3). Modifiers RESOLVED 2026-05-30 (see combat_modifiers.c). (SUPERSEDES never-existed resolve.c/modifiers.c rows.) |
| `src/combat/combat_demotion_ladder.c` | **BYTE_VERIFIED** demotion sub-table of func_05B2C2 (SUPERSEDES the never-existed demotion.c row) |
| `src/combat/combat_modifiers.c`   | **BYTE_VERIFIED mechanism** — "+50% fortified" REFUTED (roll uses raw 0x523b/0x523c, no scale); 0x5B433 fort block = capture-eligibility threshold (0x5237/0x5238); real modifier layer = post-roll per-power strength compare @0x5B85B..0x5BA2D (difficulty MUL [0x5325]); per-power array SoL/defense semantics not yet decoded. **Land-combat DECIDER decoded 2026-05-30 (wave-9, src/ai/unit_ai_leaf.c func_05CA7E):** land = ATK/(ATK+DEF) `random_int(1,atk+def)` @0x5D188 on DERIVED strengths from columns 0x5235/0x5236 (accessors 0x07C2A/0x07D3E) — same odds form as ships, different stat pair; func_05B2C2 stays consequence-only. |
| `src/combat/naval.c`              | **BYTE_VERIFIED** func_03FDDE ship move/landfall/ship-combat dispatch @0x3FDDE..0x40002 (548B; overrules functions.json 82B truncation + reseg phantom func_03FF4C); 9-entry jump table @0x3FF44; strings LANDFALL/SHIPCOMBAT/SHIPLAKE/SAILHOME/NODOCKS/EUROPENOTLEAVE/LANDFIRST |
| `src/combat/land.c`               | **BYTE_VERIFIED control flow (wave-7)** — func_05B2C2 is the combat-CONSEQUENCE applier, NOT the land decider. LAND combat has NO ATK/DEF roll in the EXE (0x523b/0x523c each read exactly once — independently re-scanned — both ship-gated). Land attacker bypasses roll+compare via gate @0x5B7B6 (jmp 0x5BAA3). Outcome router @0x5BAA3 (cmp [bp-0x3a],0) dispatches WIN (@0x5BAAC: msg-table @0x5D48, unit flags\|=0x80 @0x5BB9E, spoils via per-type 0x5235) vs LOSE (@0x5BC84: DEMOTE ladder/destroy). The land win/loss DECIDER is the CALLER, behind RTLink (thunk file 0x1BAAA = 0x110D:0xA9DA) = not yet decoded. @UNIT col->offset map not yet decoded from data. |
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
| `src/scoring/compute.c`           | **PARTIAL — ROLE CORRECTED 2026-05-30**: func_051EF4@0x051EF4 credits `*(0x84FC)+0x2A` each turn, but **+0x2A = GOLD** (UI-verified, LCR-corroborated; wave-3 RULINGS) — so func_051EF4 is a per-turn **gold/income tick**, NOT a "score tick". The arithmetic (base + difficulty x1/1.5/2 then x4) stays BYTE_VERIFIED; only the "score" framing is WITHDRAWN. Real endgame score = the rank ladder in func_03A9C0 over an overlay-resident raw value (0x191F:0x3AA, not yet decoded). Prior {5,50,1000,...} numbers were fabricated, removed. |
| `src/scoring/endgame.c`           | **PARTIAL** — win-state strings + HALLFAME.DAT fopen BYTE_VERIFIED; win-flow, HoF layout, 1850 timeout, CLOSING.EXE all not yet decoded/removed (see 2026-05-29 entry). |
| `src/ai/*`                        | EU per-unit chain (func_03ECF0/func_040E22/func_05CA7E) + driver/unit_orders ported; **native_unit_ai.c (func_046FFA, wave-8) BYTE_VERIFIED structure** (native per-unit AI: 0x54F6 alarm thr 0x80, INDIANSURPRISE, argmax move-tasking; weight tables 0x2F77/0x5236 [SAVE-GAME BSS]; 0x9410 RESOLVED 2026-06-08 = g_power_gate_9410 per-power popsum indexed by ColonyRecord.owner_power (+0x1A from 0x5D46=0x5D60), same table as sons_of_liberty.c). Remaining 0x2F77/0x5236 weight values are data-resident not yet decoded. |
| `src/diplomacy/treaty.c`          | **BYTE_VERIFIED** — treaty/war/peace state machine `treaty_set_state` decompiled from func_057DC0 @0x057DC0 (see 2026-05-29 entry) |
| `src/diplomacy/relations.c`       | **PARTIAL** — relation-state storage (PowerRecord+0x40 matrix) + flag bits BYTE_VERIFIED; numeric attitude/score model still not yet decoded |
| `src/diplomacy/* (proposal/AI)`   | Treaty proposal scoring — RECONSTRUCTED |
| `src/mapgen/*`                    | All map generation parameters |
| `src/save/*`                      | **SERIALIZER DECODED wave-10** (via RTLink tool) — SAVE driver func_0734F8@0x734F8, LOAD func_073BB0@0x73BB0 (page 0x1A 2nd-seg base 0x73270; reached 0x1A1F:0xCF6/0xD12 from SAVEGAME/LOADGAME orchestrators func_072F7A/func_073158). **DOS magic = "COLONIZE"+0x1A** (file 0x1FB1A; "COL2" is Win16-only). On-disk order BYTE_VERIFIED (header→globals 0x5380→names 0x540E→ColonyRecord ×**0xCA**→UnitRecord count[0x539C]×0x1C→PowerRecord 4×0x13C→NativeSettlement count[0x539A]×0x12→…→4 map layers); NO checksum (verified by absence); I/O via resident MSC lib (window 0xD1D). Resolves g_unit_count 0x539C. (func_011F6E remains the overlay-EXE record reader, not savegame.) not yet decoded: version@0x81A runtime value; ~30 per-power scalar blocks' field meanings. |
| `src/audio/*`                     | Audio device probes (mix of standard DOS + reconstructed) |
| `src/ui/title_screen.c`           | **PARTIAL** — boot/menu PIK asset names (MPSLOGO/OPENING/OPENMENU/OPENBORD, NATIONS/DIFFICUL/CUSTOMIZ) + setup label strings VERIFIED-by-catalog; menu item list/layout/dispatch overlay-resident not yet decoded. Fabricated TITLE.PIK/SPRITE_LOGO/menu coords/dispatch removed (see UI entry 2026-05-29) |
| `src/ui/colony_screen.c`          | **UPGRADED 2026-05-30 (wave-5)** — colony OPEN path (func_0321B4) + colony_report_options decoded BYTE_VERIFIED (NOT "overlay-resident not yet decoded" — that prior claim was wrong; handlers are byte-readable in reseg). ColonyRecord sources (0x5D46/0xCA; stockpile +0x9A) cited. See "UI screens byte-trace" section. |
| `src/ui/europe_screen.c`          | **UPGRADED 2026-05-30 (wave-5)** — europe_ship_click=func_03314E + europe_open=func_030DBC + europe_clip_blit BYTE_VERIFIED (NOT "overlay-resident not yet decoded"). PowerRecord sources (boycott +0x20, gold +0x2A, market +0x4C) cited; GUI-leaf draw thunks ANCHOR. See "UI screens byte-trace" section. |
| `src/ui/dialog.c`                 | **PARTIAL** — `compute_dialog_rect_from_cursor`=func_067DC8 @0x067DC8 BYTE_VERIFIED (rect formula + globals 0x174/0x176/0x186/0x1EA4/0x1EA5/0xA5A4/0xA5A6 + setter LCALL 0x181F:0x254); overlay setter file offset + WOODFRAM frame/text draw not yet decoded. Fabricated Dialog struct/DIALOG_X.../save_region/KING_DEMAND_TABLE removed (see UI entry 2026-05-29) |
| `src/ui/hall_of_fame.c`           | **PARTIAL** — HALLFAME.DAT fopen("rb"/"wb") @0x1EB92/0x1EBC7 + @MISC column strings ("COLONIZATION HALL OF FAME"/President/Leader/Score/Colonization_Rating) BYTE_VERIFIED; DOS record layout not yet decoded (only Win16 210-B decoded). Fabricated HallFameEntry/g_hof[10]/HOF.PIK/insert logic removed (see UI entry 2026-05-29) |
| `src/ui/main_loop.c`              | **PARTIAL (wave-5)** — game_command_dispatch=func_0235D6 structure BYTE_VERIFIED (screen-mode arm [0x1F5E] Europe=4/Report=5; F-key sub-dispatch 0x41..0x49); leaf command handlers (unit orders/save/zoom) not yet decoded. See "UI screens byte-trace" section. |
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
| `building_chain_walk_to_top(start)` | 0x86C0..0x86E2 | **BYTE_VERIFIED** (1st-iter ret edge-case not yet decoded; no LI caller) | 0x86C3 `JMP 0x86CE`; 0x86DA `CMP [bx-0x707A],0` |
| `highest_building_chain_bit_set(start)` | 0x86E4..0x871F | **BYTE_VERIFIED** | 0x86F4 `CALL 0x863E`; 0x870D chain read; 0x8715 `CMP [bp+6],0/JGE` |
| `sol_membership_pct()` (= `rebel_sentiment_pct`) | 0x8524..0x85B1 | **BYTE_VERIFIED** | 0x8531/0x8535 read [+0xC2]/[+0xC4]; 0x8557 `LCALL 0xD1D:0xF60` (x100); 0x855E `LCALL 0xD1D:0xEC6` (/B); 0x859F `ADD ax,0x14` |
| `func_2D658` SoL/Tory+training+food turn handler (UPDATES what sol_membership_pct reads) — wave-12, src/colony/sol_tory.c | 0x2D658..0x2EABB (5220B, thunk 0x191F:0x688) | **BYTE_VERIFIED** (extent+formulas) | bell EMA `A+=bells-(A>>6)` @0x2DA9C, threshold `B-=B>>6` @0x2DA3C (ColonyRecord +0xC2/+0xC6); Tory div 10-diff @0x2DCBC; REBELMAJORITY rebel%>=50 @0x2DB29; per-power bells tally **PowerRecord+0x2E** (0x8836) @0x2E6C0 — NEW field, distinct from +0x0C/0x0E FF bells; report-format leaves not yet decoded |
| `func_053B7E` colony AI auto-manage (work re-alloc + build planner + status flags) — wave-12, src/colony/auto_manage.c. **NOT KINGTAX** (NEXT_TARGETS tag was false; 0 king handles pushed). | 0x53B7E..0x5628C (9999B, ENTER 0x1C0, thunk 0x1A1F:0x35E) | **BYTE_VERIFIED** (spine + all 0x8542/king/0x35E writes; 14 spot-checks) | status flags *(0x8542)+0x1B bit4 @0x5419E; king build debit king[+0x2A]/[+0x2C] @0x5493B (cost 0x14*kingcost[owner<<4 @0x84CA]); result [0x35E]=1 @0x54FC9; mfg-goods jump tbl @0x5563E. Per-good/per-power weight tables not yet decoded |
| `lookup_signed_2F4(index)` | 0x8D9C..0x8DBA | **BYTE_VERIFIED** | 0x8DA5 `CMP [bp+6],0x13/JGE`; 0x8DAE `MOV al,[bx+0x2F4]`; CWDE |
| `commodity_net_minus_chain(idx,*out)` | 0x8DBC..0x8E00 | **BYTE_VERIFIED** (no LI caller) | 0x8DC5/0x8DC9 `[0x8DC8]-[0x8E0A]`; 0x8DD3 `CMP [bx+0x2A2],0`; 0x8DE6 `SUB ...,[0x8E5A]` |
| `update_finished_good_from_raw(raw,fin)` | 0x8E84..0x8F01 | **BYTE_VERIFIED** | 0x8E9B `CALL 0x8D9C`; 0x8EA3 `CALL 0x864E`; 0x8EA9 `CMP ax,2/JLE`+`x2/3`; 0x8EC3 `CALL 0x8E46`; 0x8EED `x3/2` |

### Identification basis (cite-or-not-yet-decoded honesty)
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
  `g_8DC6` is the current-colony INDEX (writer overlay-resident -> not yet decoded).

### New globals discovered (declared `extern` w/ cited addrs; BSS defs not yet decoded by data owner)
`g_8DC6` (0x8DC6 current-colony idx), `g_colony_bits_5DCA` (0x5DCA),
`g_byte_2F4` (0x2F4 chain-start id per good), `g_byte_2A2` (0x2A2 related-raw id
per good). Numeric contents are NAMES.TXT/overlay-driven -> values not yet decoded.

### Still not yet decoded
- numeric cells of DGROUP:0x2F4 / 0x2A2 / the 0x8F86 chain table (data-driven)
- which @BUILDING the >2 chain-count maps to (the forge/factory production cap)
- the writer of `g_8DC6` (overlay-resident)
- advances backlog item **9 (SoL / Tory percentages)**: SoL membership % formula
  now byte-verified; the bell-per-colonist threshold lives in the +0xC6
  accumulator (incremented +100/colonist-growth @asm 0x9453). TORY% and the
  REBEL*/TORY* threshold dispatch remain overlay-resident not yet decoded.

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
  from NAMES.TXT @CARGO (values external, not yet decoded).
- Drift step is **exactly ±1** price unit: `inc byte[bx+di+0x4c]` @0x309B5 (rise),
  `dec` @0x30A4C (fall) on `price_level[16]` = active PowerRecord+0x4C.
- Trigger: volume accumulator `vol_accum[16]` (PowerRecord+0x5C) crossing
  **−100×rise_factor** (al=0x9c @0x30986) to rise, **+100×fall_factor**
  (al=0x64 @0x30A22) to fall; the crossed threshold is subtracted back out
  (hysteresis). Supply→target uses **÷256** (8× sar/rcr @0x30618).
- Euro-supply read per power at **DS:0x8904 = PowerRecord+0xFC**, dword stride 0x13C
  (`imul ...,0x4f` ×4 @0x305CE). Price-target word array **DS:0x53EA** decayed
  @0x30639. Emits **PRICEUP**(DG 0xfa8)/**PRICEDOWN**(DG 0xfb0). Bell-curve reprice
  cap **0x19(25)** @0x30ACE. not yet decoded: bid/ask spread = overlay thunks 0x181F:0xcc2/0xac4.

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
  (guard [bp-8], set only when active==local human player). not yet decoded: overlay helper
  identities behind the 0x181F/0x191F thunks; caller of the dispatcher.

---

## Endgame scoring rank ladder — `func_03A9C0` (verified 2026-06-07) + raw_power_score LOCATED (2026-06-08)

The Hall-of-Fame rank ladder is byte-traced (display/ranking layer). The raw
score-total sum function `raw_power_score` is now **located** at `func_039EE2`
(file 0x039EE2, 2781 bytes, ENTER 0x7E) via the confirmed Type-A RTLink thunk
formula (see Type-A section below). `func_03A9C0` file 0x03A9C0 (ENTER 0x3C4),
early-return RETF @0x3AA08 for score<=0, body extends to 0x3B2F8.

| Claim | Evidence | Status |
|-------|----------|--------|
| raw_power_score = func_039EE2 @ file 0x039EE2 (2781 B, ENTER 0x7E) via Type-A thunk `0x191F:0x3AA` | thunk @ file 0x1B99A: `9A AB 0D 0D 11` (Type-A), off=0x0092, segid=5, extra=0x02B1; base[5]=0x037340; 0x037340+0x02B1×16+0x0092=0x039EE2 (confirmed ENTER `C8 7E 00 00`). Call chain: 03A9F6 `call 0x3B36A` → 03B36A `EA AA 03 1F 19` → thunk → func_039EE2 | BYTE_VERIFIED (location + head) |
| raw_power_score head: reads [0x53A8] + 100×[0x53A7] as cap init | @asm 039EE6 `A0 A8 53` (mov al,[0x53A8]); 039EEC `B0 64` (mov al,0x64); then IMUL [0x53A7] | BYTE_VERIFIED |
| raw_power_score loops i=0..3 counting other-nation colonies with flag set | @asm 039F1C..039F3B loop body: tests PowerRecord[i×0x13C-0x77F8] bit 2; inc [bp-0x56] | BYTE_VERIFIED (loop structure) |
| raw_power_score arg gate: arg==0 → skip display path | @asm 039F42 `75 03` (jne +3); jmp → 0x3A09A | BYTE_VERIFIED |
| raw score from overlay routine 0x191F:0x3AA via thunk 0x3B36A | @asm 0x3A9F5 `push cs; call 0x3b36a`; result -> [bp-0xBE] @0x3A9FC | BYTE_VERIFIED |
| difficulty multiplier = diff+4, +1 if diff>=3, +1 if diff>=4 (0..4 -> 4,5,6,8,10) | @asm 0x3AA0A `mov al,[0x53a6]`; 0x3AA0F `add ax,4`; 0x3AA15 `cmp [0x53a6],3`/inc; 0x3AA20 `cmp ...,4`/inc | BYTE_VERIFIED |
| scaled = (mult * rawScore) / 100 | @asm 0x3AA34 `imul [bp-0xbe]`; 0x3AA38 `mov cx,0x64`; 0x3AA3C `idiv cx` | BYTE_VERIFIED |
| rank = largest i-1 (i=1..24) with i*i/3 < scaled; loop bound 24, cap 23 | @asm 0x3AA4D `imul cx`; 0x3AA4F `mov bx,3`; 0x3AA53 `idiv bx`; 0x3AA63 `cmp ...,0x18`; 0x3AA71 `cmp ax,0x17`/`mov ax,0x17` | BYTE_VERIFIED |
| displayed score = scaled / 2 | @asm 0x3AA6A `sar [bp-2],1` | BYTE_VERIFIED |
| fanfare id by tier: rank 23->0x24, 7..22->0x25, <=6->0x21 | @asm 0x3AD51 `cmp [bp-0xc0],0x17`; 0x3AD58 `mov ax,0x24`; else 0x25/0x21 | BYTE_VERIFIED |
| HOF record builder func_03B2F8 (file 0x3B2F8, ENTER 0x2C, RETF 0x3B368): country-name @[0x5398]*0x34+0x540E, indep flag [0x5382]&1, year [0x538A], difficulty [0x53A6], score from same overlay routine | @asm 0x3B2FC/0x3B317/0x3B329/0x3B335/0x3B33D | BYTE_VERIFIED (record fields); component sum not yet decoded |
| HALLFAME.DAT load/sort/insert func_03ADA6: rep-movsw sort up to 6 records (0x2A words) by descending score field +0x26 | @asm 0x3AED0/0x3AED8 | BYTE_VERIFIED (structure) |
| win-state master flag word [0x5382]: bit0=independence (set @func_03DE46 0x3E031 `or [0x5382],1`), bit3 -> HOF, bit4 suppresses interactive HOF | @asm 0x3E031; 0x3B320; 0x3A9BB `test [0x5382],0x10` | BYTE_VERIFIED |

Not yet decoded: (1) the score-TOTAL component formula (colonies/population/FFs/gold/bells/
difficulty-bonus/revolution-bonus weights) is in the 2781-byte body of
func_039EE2. The head (first 70 bytes) is BYTE_VERIFIED; the weight payloads for
each component remain to be traced (ongoing — see compute.c). (2) Rank-title
text (Discoverer..Viceroy) is loaded by key+rank from an external message file;
the EXE holds only keys ("SCORE" DG 0x11CF, "EXPLOITS" DG 0x11E0). The string
"Colonization_Rating" is NOT in the EXE (external).

## Coverage instrumented (2026-06-07)

`tools/coverage.py` + `docs/COVERAGE.md`: 1248 functions, 1236 (99%) with @asm
citations, 342 (27%) with a BYTE_VERIFIED-adjacent citation (heuristic upper
bound). audit.py regression baseline now 69/69.

---

## Native mission convert rate — `func_0572E6` (verified 2026-06-07)

The per-check conversion probability is byte-traced (identified via the
INDIANSCONVERT key DG 0x182A pushed @0x57341). func_0572E6 file 0x0572E6
(ENTER 0x0F25).

| Claim | Evidence | Status |
|-------|----------|--------|
| convert_rate = `*(0x8D4E)[+2] + 2` (active tribe record field +2) | @asm 0x572F2 `mov bx,[0x8d4e]`; 0x572F6 `mov al,[bx+2]`; 0x572FB `inc ax;inc ax` | BYTE_VERIFIED |
| rate doubled when mission-bonus flag CL&0x10 set | @asm 0x57300 `test cl,0x10`; 0x57305 `shl ax,1` | BYTE_VERIFIED (mechanism); CL source not yet decoded |
| convert occurs iff `random_int(0,15) < rate` | @asm 0x5730A `push 0xf;push 0`; 0x5730E `lcall 0x181F:0x4D4`; 0x57316 `cmp ax,[bp-4]`; 0x57319 `jge` exit | BYTE_VERIFIED |
| INDIANSCONVERT message shown on success, human-visible only | @asm 0x57341 `push 0x182a`; gate 0x5731B `cmp [bp+6],4`/0x57325 `cmp [bx+0x543f],0` | BYTE_VERIFIED |

So P(convert per eligible check) = MIN(rate,16)/16 where rate = tribe[+2]+2
(×2 with the mission-bonus flag). The tribe +2 byte's per-tribe values are
external (TRIBE.TXT/NAMES.TXT @TRIBE); the CL bit-0x10 source (expert missionary
vs mission building) is not yet decoded. mission.c updated; audit 75/75.

---

## King tax demand + REF growth — `func_034AE0` / `func_03E162` (verified 2026-06-07)

### King tax adjust `func_034AE0` (file 0x34AE0, RETFs 0x34B43/0x34B7D)
Per-evaluation RAISE/LOWER/NOTHING decision (KINGRAISE DG 0x10b2 / KINGLOWER
0x10a8 / KINGNOTHING 0x109c). There is NO internal random gate on whether to run
(cadence is overlay-driven, not yet decoded); the only randomness is the step amounts and the
LOWER fire-chance.

| Claim | Evidence | Status |
|-------|----------|--------|
| target = `((diff&0xFE)*2 + 4) * (turn/400 + 1)` | @asm 0x34AEE..0x34B0D (`mov al,[0x53a6];and ax,0xfe;shl ax,1;add ax,4` × `[0x538e]/0x190+1`) | BYTE_VERIFIED |
| RAISE when target+5 >= current tax; step = `random_int(1,diff)*2` | @asm 0x34B10 `add al,5`/`cmp [bx+1],al/jge`; 0x34B6A `lcall 0x181F:0x4D4`; 0x34B72 `shl ax,1` | BYTE_VERIFIED |
| LOWER only when tax >> target, 1-in-(diff+1) chance; step = -`random_int(1,5-diff)` | @asm 0x34B1F `random_int(1,diff+1)`; 0x34B30 `dec/je`; 0x34B44 `random_int(1,5-diff)`; 0x34B59 `neg ax` | BYTE_VERIFIED |
| tea-party/tax-apply cap 75 (func_034318) re-confirmed | @asm 0x3434F `cmp byte[bx+1],0x4b` | BYTE_VERIFIED |
| KINGTAX rebate/fund grant (func_0349F4) gold = `max(1,6-(cnt+1)/2 - taxfactor)*100` -> King gold +0x2A | @asm 0x34A63..0x34A7B; 0x34AA9 `add [bx+0x2a],ax` | BYTE_VERIFIED |

### REF growth `func_03E162` = king_buy_REF_unit (file 0x3E162, RETFs 0x3E288/0x3E2E8)
**REF growth is funded by the King's tax/trade budget, NOT player bells/SoL.**

| Claim | Evidence | Status |
|-------|----------|--------|
| only grows pre-war: gate `[0x5382]&1`==0 | @asm 0x3E172 `test byte[0x5382],1`/je | BYTE_VERIFIED |
| per-turn budget add = `(diff*8 + 10)`, ×2 at year>=1600/1700/1750 (cumulative) | @asm 0x3E181 `shl ax,3`; 0x3E184 `add ax,0xa`; 0x3E18A/0x3E197/0x3E1A2 year cmp 0x640/0x6a4/0x6d6 + shl | BYTE_VERIFIED |
| budget accumulates in King record dword +0x22; +1 REF unit per 1800 (0x708) | @asm 0x3E1B5 `add [bx+0x22],ax`; 0x3E1C6 `cmp [bx+0x22],0x708/jae`; 0x3E271 `sub [bx+0x22],0x708` | BYTE_VERIFIED |
| chosen arm balanced by ratio; growth = `inc word[bx+0x53da]` (arm*2) | @asm 0x3E1D5..0x3E20E ratio compares; 0x3E238 `inc word[bx+0x53da]` | BYTE_VERIFIED |
| REF = 4-arm word array DS:0x53DA..0x53E0 (+ "arrived" tally 0x53E2); landing decrements (func_03CDA2 @0x3D4C0) | @asm 0x37DA0 `cmp [bp-0x62],4`; 0x3D4C0 `dec word[bx+0x53da]` | BYTE_VERIFIED (layout) |
| budget fed by tariff: `+= goods_sold * king_tax/100` (func_2D6C0 @0x2D785) | @asm 0x2D737 `mov al,[bx+1]`; 0x2D785 `add [bx+0x22],ax` | BYTE_VERIFIED |

CORRECTION: func_02F052's KINGTAX string (DG 0x1094) is a king-unit-SPAWN message,
not the tax demand; the tax decision is func_034AE0. King record +0x22 is the
tax-BUDGET accumulator (funds REF), not a bells counter.

## Founding-father bell economy — `func_03C322`/`func_03C282`/`func_03BFD2` (verified 2026-06-07)

The full liberty-bell -> Continental Congress -> founding-father pipeline is now
byte-traced (the per-FF EFFECTS in func_03BC42 were already done).

| Claim | Evidence | Status |
|-------|----------|--------|
| bells accumulate: `[bx+0x0C] += bells` (spend acc, reset on elect) and `[bx+0x0E] += bells` (lifetime) | @asm 0x3C336 `add [bx+0xc],ax`; 0x3C339 `add [bx+0xe],ax`; 0x3C3EA `mov [bx+0xc],0` | BYTE_VERIFIED |
| **threshold = (ff_count+1) × cost_factor + 1**, halved for the first FF | @asm 0x3C2FA `mov al,[bx-0x77e4]`(ff_count +0x14); 0x3C302 `inc ax`; 0x3C303 `imul [bp-4]`; 0x3C30B `sar ax,1` if ff_count==0 | BYTE_VERIFIED |
| cost_factor = base ×8 ×1.5/era; base = human `(diff+3)*2`, AI `(14-diff)` | @asm 0x3C297/0x3C2A4 base; 0x3C2B1 `shl [bp-4],3`; 0x3C2B5/0x3C2C5/0x3C2D5/0x3C2E5 year>=1600/1650/1700/1750 each `+=(v>>1)` | BYTE_VERIFIED |
| election fires when `[bx+0x0C] >= threshold` | @asm 0x3C3BA `cmp ax,[bx+0xc]`/jg skip; 0x3C3DC `push [bx+0x12]` elect | BYTE_VERIFIED |
| selection: per-category weighted `random_int(1,total_weight)` over not-yet-owned FFs; writes pending slot +0x12 | @asm 0x3C0DB `lcall 0x181F:0x4D4`; subtract-walk; 0x3C269 `mov [bx+0x12],ax` | BYTE_VERIFIED |
| human powers (idx<4, AI-flag [bx+0x543f]==0) get a choice dialog; AI commits the roll | @asm 0x3C10A `imul bx,[bp+6],0x34`; 0x3C10E `cmp byte[bx+0x543f],0` | BYTE_VERIFIED |
| FF category table DS:0x9654 (stride 6 +0), era/weight DS:0x9655 (+1), name-ptrs DS:0x9652 | @asm 0x3C0B1/0x3C0C4 reads | BYTE_VERIFIED (location); values external (NAMES.TXT @FATHERS) |

audit.py now 96/96.

---

## Random map generation — `func_0645F6` / `func_064A10` (verified 2026-06-07)

The world generator is **fully in-EXE code** (two overlay functions), NOT external
data-driven — only the invocation/seeding and the CUSTOMIZE-form parameter binding
are overlay-blocked.

| Claim | Evidence | Status |
|-------|----------|--------|
| PASS 1 landmass/continent blob growth = func_0645F6 (file 0x645F6, ENTER 0x26) | @asm 0x64616 `lcall 0xd1d:0xfb2` grid memcpy; 4-cardinal walk 0x646EC/0x646F8 | BYTE_VERIFIED |
| PASS 2 terrain/climate/rivers/features/starts = func_064A10 (file 0x64A10, ENTER 0x3C) | @asm 0x64A16 `random_int(1,0x7fff)` salt -> DS:0x190; param [bp+6]=0 full vs edge-repaint | BYTE_VERIFIED |
| tile grid = row-major 1 byte/tile, addr = y*map_width + x, base far-ptr DS:0x15C:0x15E | @asm 0x05CED `imul [0x853a]`; 0x05CF1 `add ax,[0x15c]` | BYTE_VERIFIED |
| map dims map_width DS:0x853A / map_height DS:0x853C (BSS, runtime) | @asm 0x64B33/0x64C5D word reads | BYTE_VERIFIED |
| equator row = map_height/2; climate-band divisor = map_height/4 | @asm 0x64C8D `sar ax,1`; 0x64DE5 `sar ax,2` | BYTE_VERIFIED |
| forest/moisture budget = random_int(0, \|height/4 - lat\| + 4*climate[0x1E84]) -> denser at equator | @asm 0x64DFE `mov cx,[0x1e84]`; 0x64E02 `shl cx,2`; 0x64E0A `lcall 0x4d4` | BYTE_VERIFIED |
| gen params (CUSTOMIZE outputs, real defaults): DS:0x1E7E..0x1E84=1, 0x1E86=0 (land-form iters); 0x1E82 water-level, 0x1E84 climate | @bytes file 0x1F81E..0x1F826 (initialized data) | BYTE_VERIFIED (values); label binding not yet decoded |
| terrain byte: type = low 5 bits; 0x19 base land, 0x1A forest, 0x18 mountain; flags 0x20/0x40(land)/0x80 | @asm 0x64D0E `mov [bp-0x2e],0x19`; 0x65552 `mov bx,0x18`; 0x64764 `or [bp-4],0x40` | BYTE_VERIFIED |
| terrain-type dispatch via CS-relative jump tables (6/6/8-way) | @asm 0x64CF6 `jmp cs:[bx+0xbac]`; 0x65048 `jmp cs:[bx+0xefe]`; 0x65318 `jmp cs:[bx+0x11ce]` | BYTE_VERIFIED (tables); per-arm terrain semantics not yet decoded |
| river/coast tracer walks 8-dir deltas, dir=random_int(0,8), +8/+0x10 elevation tiers | @asm 0x653A3 `random_int(0,8)`; 0x653B9 `add ...,[bx+0xb4]`; 0x653F8 `add ...,8` | BYTE_VERIFIED |
| 4 player starts: struct DS:0x883A stride 0x13C, scattered into vertical fifths (map/5), rotation via [0x5398]%4 | @asm 0x65CC6 `imul [bp-0x28],0x13c`; 0x65CCB row/0x65CD2 col writes; 0x65C78 `add [0x5398]`/idiv 4 | BYTE_VERIFIED |
| AMER2 fixed-start override gated by DS:0x2174, hard coords (0x2B,0x44) | @asm 0x65BF6 `cmp [0x2174],0`; 0x65C11 `push 0x44;push 0x2b` | BYTE_VERIFIED |
| 4-cardinal delta table DS:0xA8 dx{0,1,0,-1}/DS:0xAE dy{-1,0,1,0}; 20-entry ring DS:0xC8/0xDE | @asm 0x646EC/0x65B43/0x65B4F | BYTE_VERIFIED |

Not yet decoded: generation invoker + RNG seed source (overlay-swapped, trail ends at RTLink
loader 0x110D:0x0D91); CUSTOMIZE-form -> DS:0x1E7E.. parameter wiring (form-handler
overlay); per-terrain-arm semantics of the CS jump-table targets. The 4-cardinal and
20-ring delta tables are now in data/embedded_control_tables.c. audit.py 108/108.

---

## Combat strength modifier stack — `func_07C2A`/`func_07D3E`/`func_05CA7E` (verified 2026-06-07)

The pre-roll modifier layer (previously not yet decoded in combat_modifiers.c) is now
byte-traced. **Fortification IS a real multiplier** — applied to the strength
accumulators before the roll, not as a literal "+50%" at the comparison.

### Base accessors
| Claim | Evidence | Status |
|-------|----------|--------|
| func_07C2A (file 0x7C2A, ENTER 6, RETF 0x7D3D): ATTACK = column DS:0x5236, DEFENSE = column DS:0x5235, indexed by unit type×6 | @asm 0x7C62 `mov al,[bx+0x5236]` (sel!=0); 0x7C7E `mov al,[bx+0x5235]` (sel==0) | BYTE_VERIFIED (column semantics); values external (NAMES.TXT @UNIT) |
| strength held ×8 internally (`shl ax,3`); scout/criminal type 0x0B w/ flag 0x80 → −2; artillery type 0x10 → ×3/2; colonist on feature 0x15 → ×3/2; ship type 0x0D..0x12 → − hull damage [+0x3150] | @asm 0x7CA9 `shl ax,3`; 0x7C99 `sub [bp-6],2`; 0x7CFC ×3/2; 0x7CCC ×3/2; 0x7D20 `sub [bp-2],ax` | BYTE_VERIFIED |
| func_07D3E (file 0x7D3E, ENTER 0x18, RETF 0x7F33): DEF = ((fort/terrain_factor + 4) × base) / 4 (factor 0→×1, 2→×1.5, 4→×2) | @asm 0x7F26 `add ax,4; imul [bp-0xa]; sar ax,2` | BYTE_VERIFIED |
| terrain-defense table DS:0x2F77 (stride 16) added to factor; settlement+ship → +2 | @asm 0x7E5D/0x7EEA `mov al,[bx+0x2f77]`; 0x7EFE `add [bp-0x18],2` | BYTE_VERIFIED (mechanism); table values not yet decoded/external |

### Land combat (func_05CA7E, file 0x5CA7E, ENTER 0xDE, RETF 0x5E709)
| Claim | Evidence | Status |
|-------|----------|--------|
| ATK normalized ((0x8d04+4)/4 then ×3/2); player terrain bonus +(4-difficulty) to each side | @asm 0x5CE05/0x5CE16; 0x5CE29 ATK / 0x5CE49 DEF `add ...,(4-[0x53a6])` | BYTE_VERIFIED |
| amphibious penalty ATK×(k/3); weak-attacker DEF÷2; artillery-vs-fort DEF÷4; settlement DEF×2; scout ambush ATK×3/2; cross-terrain ATK×3/2 | @asm 0x5CE69 idiv 3; 0x5CEB7 `sar [bp-0xa6],1`; 0x5CF11 `sar [bp-0xa6],2`; 0x5CF2B `shl [bp-0xa6],1`; 0x5CF43/0x5CF82 `sar/add` ATK | BYTE_VERIFIED |
| roll = random_int(1, ATK+DEF); attacker wins iff roll <= ATK (on MODIFIED strengths) | @asm 0x5D188 `lcall 0x181F:0x4D4`; 0x5D194 `cmp ax,[bp-0x90]/jg` | BYTE_VERIFIED |
| difficulty<=1 AI returns odds = ATK*8/(DEF+1) | @asm 0x5D032 `shl ax,3; .. idiv (DEF+1)`; RETF 0x5D044 | BYTE_VERIFIED |
| difficulty MUL DS:0x5325 scales the AI bombardment THREAT assessment (func_05B2C2 @0x5B9A2), NOT the roll | @asm 0x5B9A2 `mul byte[0x5325]` | BYTE_VERIFIED |

### Outcome (func_05B2C2, file 0x5B2C2, ENTER 0x3A, RETF 0x5BE2E)
| Claim | Evidence | Status |
|-------|----------|--------|
| win/lose dispatch on [bp-0x3a]; loser captured (convert-table DS:0x5D46 scan) or destroyed (KILLED flag) | @asm 0x5BAA3 `cmp [bp-0x3a],0`; 0x5BB9E `or byte[bx+0x3148],0x80` | BYTE_VERIFIED |
| ships demote via hull-damage ladder [+0x315A] (type 0x11 floor 4, 0x12 floor 8) not destroyed | @asm 0x5BC1D `mov [bx+0x315a],al`; 0x5BC2C/0x5BC49 floors | BYTE_VERIFIED |
| winner veteran promotion gated on flag [+0x3148]&0x40, promote-table scan, vet count [-0x77f7]-- | @asm 0x5BD1E `test [bx+0x3148],0x40`; 0x5BD34 scan; 0x5BD93 dec | BYTE_VERIFIED (mechanism); promote-table values not yet decoded |

audit.py 116/116.

---

## Native raid magnitudes — `func_05BE84` (verified 2026-06-07)

The raid dispatcher loot/damage magnitudes are now byte-traced (file 0x5BE84,
ENTER 0x24, RETF 0x5C659). Outcome = random_int(1,4), then forced to a feasible
outcome by target-availability gates.

| Claim | Evidence | Status |
|-------|----------|--------|
| GOLD stolen = `(PowerRecord[tribe_id][+0x2A] * colony[+0x1F]) / (g_tribe_6BF0[tribe_id]+1) + 10`, clamped to [INT_MIN, 0x7FFF]; subtracted from victim PowerRecord+0x2A. `tribe_id = colony[+0x1A]`; `g_tribe_6BF0[]` accessed as `[tribe_id - 0x6BF0]` | @asm 0x5C29A `mov bx,[bp-0x22]`; 0x5C29D `mov al,[bx-0x6bf0]`+1; 0x5C2B0 `mov al,[si+0x1f]`; 0x5C2B7 `imul bx,bx,0x13C`; 0x5C2BB/0x5C2BF push pwr +0x2C/+0x2A; 0x5C2C5 `lcall 0xD1D:0xF60 __aFlmul`; 0x5C2CC `lcall 0xD1D:0xEC6 __aFldiv`; 0x5C2D1 `add ax,0xa`; 0x5C2D9/0x5C2DD/0x5C2E2 clamp 0x7FFF; 0x5C5D4 `sub [bx-0x77ce],ax` | BYTE_VERIFIED (magnitude fully resolved 2026-06-08) |
| STORES: take `random_int(0, min(10, colonyGoods/2))` of a commodity, floored 1, `sub [bx+si+0x9a]`; sound 0x4F | @asm 0x5C374 `sar ax,1`; 0x5C37B cap 0xA; 0x5C3AD `sub [bx+si+0x9a],ax`; 0x5C3C2 sound 0x4F | BYTE_VERIFIED |
| BURN goods/buildings sound 0x53; WREAK unit sound 0x4B+0x4D (destroy via overlay 0x5E723); GOLD-apply sound 0x4E; SHIP-burn sound 0x5B | @asm 0x5C501/0x5C569/0x5C571/0x5C5ED/0x5C62D | BYTE_VERIFIED (sounds); unit/ship removal overlay-resident not yet decoded |
| TRIGGER: tribe hostile when alarm `[0x54F6][(p*9+t)*2] >= 0x80`; successful raid zeroes that alarm | @asm 0x4734E `cmp word[bx+0x54f6],0x80`; 0x5C651 `mov word[bx+0x54f6],0` | BYTE_VERIFIED |
| alarm accumulation clamped to [0x20,0x60] normally; AIPersonality active flag +0x31 (DS:0x543F) gates sound/message | @asm 0x45F9B/0x45FB9; many `cmp byte[bx+0x543f],0` | BYTE_VERIFIED |

### Pointer-base CORRECTIONS (byte-verified)
- colony record ptr `[0x8542]` = `colony_idx*0xCA + 0x5D46` (stride 0xCA, base 0x5D46) — @asm 0x8302
- raiding-tribe TribeData ptr `[0x8D4E]` = `tribe*0x4E + 0x5AD6` (stride 78, = TribeData 0x59D8 + 0xFE) — @asm 0x81E6
- owner id `[0x8D50]` = tribe + 4 — @asm 0x81E0
- **CORRECTION:** the STORES `inc [bx+8]`/`add [bx+0xa],0x19` (@0x5C3E1/0x5C3E4) write **TribeData[tribe]+8/+0xA** (via [0x8D4E]), a per-tribe raid tally — NOT the NativeSettlement +0x08 field. The prior note attributing these to the settlement was wrong.
- NativeSettlement (DS:0x54EC stride 0x12): +0x00 x, +0x01 y, +0x02 owner(tribe+4); fields +0x07/+0x08/+0x09 (0x54F3/4/5) written 0xFF at create (@0x46EAE) with **no other code reference** — semantics not yet decoded.

### NATIVE_GROWTH_PCT — remains not yet decoded (correction)
No per-turn NativeSettlement population/goods growth write exists in the static
code region. The prior "field += field/(0xFFFF-n)" growth claim was a
mis-reading: that site (@0x4700B) scales the **global** word DS:0x538E (~×24/25),
not a settlement field. Native settlement growth (if modeled) is overlay-resident
-> not yet decoded. audit.py 128/128.

---

## Colony surrounding-tile production scan — `func_048F34` (verified 2026-06-08)

Full 1740-byte body (file 0x048F34..0x0495FF) byte-traced end to end; the prior
port covered only the first ~922 bytes (phases A/B) and left phases C/D skeleton.

### Phase C — 5×5 terrain classify (0x04904A..0x049241)
| Claim | Evidence | Status |
|-------|----------|--------|
| scan window rows/cols = scan.{y,x}±2 from BoundRecord *(0x8D4A) [+0]=x [+1]=y | @asm 0x04904E/0x049229/0x04923B | BYTE_VERIFIED |
| visited[row_idx*5+col_idx] skips tiles claimed by other colonies (phase B) | @asm 0x049159/0x049178 | BYTE_VERIFIED |
| terrain id from 0x181F:0x078C; exact-match 0x1B→forest++,0x1C→mineral++,0x18→grain+=4 | @asm 0x049185/0x049195/0x04919E/0x0491A7 | BYTE_VERIFIED |
| ids 8..0x17 → food++ and terrain_sub=(id&7); sub<3 → special++/grain+=2, else ore/fish + cotton/sugar/tobacco | @asm 0x0491C5/0x0491EF/0x0491F9 | BYTE_VERIFIED |
| secondary classifier (id 0..7 and 0x19/0x1A): hills batch-convert market[+2]+1 to food in 3s; per-id cotton/sugar/tobacco/fur/fish/grain buckets | @asm 0x049066/0x04907F/0x04909B | BYTE_VERIFIED |
| **CORRECTION:** ids 2/3 `!(id&4)` arm is `jmp 0x04905F` (grain+=2 ONLY); it does NOT pass 0x04905C (special++). Only the food-branch sub<3 path (`jmp 0x04905C`) bumps special_cnt | @asm 0x0490FD `e9 5f ff` → 0x04905F vs 0x0491F6 `e9 63 fe` → 0x04905C | BYTE_VERIFIED |

### Phase D — finalize per-resource outputs (0x049242..0x0495FF)
| Claim | Evidence | Status |
|-------|----------|--------|
| base = colony level *(0x8D4A)[+4] + 1; tiles = base² | @asm 0x049242..0x049250 | BYTE_VERIFIED |
| outputs are two CONTIGUOUS 16-word arrays: cap[16] @0x9E58..0x9E76, yield[16] @0x9E78..0x9E96; the clear-loop zeroes the whole block and the cap-normalize/fort-bonus loops re-scan it. The `mov [0x9eXX],..` slot writes ARE elements of these arrays (e.g. 0x9E80=yield[4], 0x9E6E=cap[11]) | @asm 0x049259 `[bx-0x61a8]/[bx-0x6188]` (0x9E58/0x9E78 signed) | BYTE_VERIFIED |
| food yield[0] += (mkt+base)*food_cnt/(7-mkt); food cap[0] = (tiles*4) >> (mkt>1) | @asm 0x049285/0x0492A7 | BYTE_VERIFIED |
| lumber yield[7] = market[+0xc]/max(1,saw_level) + forest*(mkt>2?8:4); saw_level = g_power_scalar_962A[cur_power] (= [cur_record-0x69D6]) | @asm 0x0492B8/0x0492C3/0x0492F0 | BYTE_VERIFIED |
| silver/tobacco caps use signed (x/4)*2 (cdq/xor/sub/sar2/xor/sub/shl); inputs ≥0 so == abs | @asm 0x049334/0x049379 | BYTE_VERIFIED |
| per-slot cap-normalize via 0x181F:0x035C(cap[i],0,50); fort flag *(0x8D4A)[+3]&4 doubles cap[0..7], ×1.5 cap[13..15], doubles yield[7..15] | @asm 0x04944D/0x049466/0x049476/0x049493/0x0494AA | BYTE_VERIFIED |
| per-slot decay: yield -= cap/2 (floor 1 if prior yield>0); cap -= prevyield/2 (floor 1 if prior cap>0); demand market[i*2+0xe] adjusts cap (supply) or yield (negative demand) | @asm 0x049537..0x049591/0x0495B9 | BYTE_VERIFIED |

audit.py 152/152 after this function; 12 anchors added.

---

## TABLE_C shift-down — `func_04C2CE` (verified 2026-06-08)

Last remaining STILL-SKELETON game-logic stub. The per-func dump is the COMPLETE
55-byte body (ENTER 0x04C2CE .. RETF 0x04C304), not truncated/mis-addressed.

| Claim | Evidence | Status |
|-------|----------|--------|
| sibling of overlay_grid16_shift_down but for TABLE_C @0xA0DC (16 slots × 6 bytes), a flat 1-D array (no column arg) | @asm 0x04C2CE ENTER 2,0; one arg stop_row [bp+6] | BYTE_VERIFIED |
| r = 0x0E downto stop_row: copy 3 words from record[r] (si=0xA0DC+r*6) to record[r+1] (di=si+6) via movsw×3, es=ds | @asm 0x04C2DC bx=r*6; 0x04C2E7 di; 0x04C2EB si; 0x04C2F3 movsw×3 | BYTE_VERIFIED |

audit.py 159/159. With these two functions, no explicitly-marked game-logic
SKELETON stub remains in src/; the residual work is OUT-OF-SCOPE leaves,
EXTERNAL-DATA `.TXT` values, and RTLink overlay-swapped bodies (see COVERAGE.md).

---

## RTLink thunk resolution — bid/ask-spread + score-total leads (verified 2026-06-08)

Resolved the three "overlay-blocked" formula leads by decoding the RTLink/Plus
dynamic-link thunks directly (no flattener needed). Each LCALL `0x18xx/0x19xx:off`
lands on a 10-byte thunk: `9A lo hi lo hi` (call far the loader 0x110D:0x0D9x)
immediately followed by `EA off seg` (jmp far the real target). The real target
is the **second-stage `EA` operand**:

| Lead (FORMULAS/COVERAGE) | thunk file | 2nd-stage jmp far | target file | verdict |
|--------------------------|-----------:|-------------------|------------:|---------|
| buy  spread `0x181F:0xCC2` | 0x1B2B2 | `EA F8 32 EB 05` → 0x05EB:0x32F8 | 0x0B5A8 | **RESIDENT** (func_00B5A8) |
| sell spread `0x181F:0xAC4` | 0x1B0B4 | `EA AA 33 EB 05` → 0x05EB:0x33AA | 0x0B65A | **RESIDENT** (func_00B65A) |
| score total `0x191F:0x3AA` | 0x1B99A | Type-A: `9A AB 0D 0D 11`; off=0x0092, segid=5, extra=0x02B1 | 0x039EE2 | **CONFIRMED** (func_039EE2; Type-A formula: base[5]+extra×16+off) |

Findings:
- **score-total CONFIRMED at func_039EE2** (2026-06-08) via Type-A RTLink thunk
  formula: `file_offset = base[segid] + extra*16 + off`. The thunk at 0x1B99A is
  a 14-byte Type-A shape (`9A AB 0D 0D 11`) with off=0x0092, segid=5,
  extra=0x02B1. `base[5]=0x037340`; `0x037340 + 0x02B1×16 + 0x0092 = 0x039EE2`.
  func_039EE2 confirmed (ENTER `C8 7E 00 00`). See Type-A section in COVERAGE.md.
  Score component weights (colonies/pop/FF/gold/bells) are in the 2781-byte body
  — head BYTE_VERIFIED; full trace in progress.
- **bid/ask spread is NOT at these thunks.** func_00B5A8/00B65A read the
  per-unit-TYPE stat table (base 0x5230 stride 14; cols +9=0x5239, +10=0x523A —
  same block as DEFENSE 0x5235 / ATTACK 0x5236) via a price-band index from a
  0x8F89-stride-12 record; their game role is unit/combat-adjacent, NOT market.
  The `0x181F:0xcc2/0xac4` "bid-ask spread" citation was a **misattribution**.
- The real market transaction spread was already resident & ported:
  `market_sell_price` func_030566 = price_level[good]+cargo_burden[good];
  `market_buy_price` func_030590 = price_level[good]-1 (both clamp >=0). The
  FORMULAS.md "overlay-resident [TBD]" spread note is corrected accordingly.
- func_00B5A8 (buy-band classifier, 82B) / func_00B65A (170B; the auto-skeleton's
  "39B" is a truncation) are decodable resident stubs but low-value (murky
  unit-stat semantics); left unported, no longer counted as RTLink-blocked.

---

## RTLink Type-A thunk format CONFIRMED (2026-06-08)

The 14-byte overlay thunk shape ("Type-A", loader 0x110D:0x0DAB) carries an
`extra` paragraph-count field at bytes [12:14], confirmed by disassembling the
post-load patching code at 0x110D:0x1111:

```
add  ax, word ptr es:[di+7]   ; di = EA byte offset → [di+7] = thunk[12] = extra
mov  word ptr es:[di+3], ax   ; patch placeholder segment with base+extra
```

**Type-A resolution formula:** `file_offset = base[segid] + extra * 16 + off`

Three thunk shapes (all confirmed by byte scan of the thunk table 0x1A000–0x1E000):

| Shape | Size | Loader | segid field | extra field |
|-------|-----:|--------|-------------|-------------|
| RESIDENT | 10B | (none; `EA <real-seg>`) | — | — |
| OVERLAY Type-B | 12B | 0x110D:0x0D91 | [10:12] | (none) |
| OVERLAY Type-A | 14B | 0x110D:0x0DAB | [10:12] | [12:14] |

Fingerprint validation (tools/rtlink/flatten.py):
- 23/31 overlay segments resolve STRONG (≥50% thunk offsets hit exact function starts)
- Resident-thunk control: 323/362 (89%) land on resident function starts

**Audit assertions added** to audit.py (all PASS, total 179/179):
- Score thunk at 0x1B99A: Type-A header `9A AB 0D 0D 11`, off=`92 00`, segid=`05 00`, extra=`B1 02`
- func_039EE2 ENTER `C8 7E 00 00` at file 0x039EE2
- raw_power_score reads [0x53A8] at 0x039EE6; imul operand at 0x039EEC
- arg gate `75 03` at 0x039F46; trampoline ljmp `EA AA 03 1F 19` at 0x03B36A
- score_endgame_rank call-site `E8 71 09` at 0x03A9F6

---

## Group D modal-loop TBD-inner closure (2026-06-08)

### func_06E3D0 — panel_run_modal

Full cursor hit-scan and key-dispatch path byte-traced. Both TBD-inner
regions are now BYTE_VERIFIED.

#### Cursor hit-scan (Phases 0/1/2)

| Claim | Evidence | Status |
|-------|----------|--------|
| Phase 0: outer-rect early-exit guard (cursor outside panel boundary skips all hit-testing) | @asm phase-0 outer-rect cmp sequence in func_06E3D0 | BYTE_VERIFIED |
| Phase 1: row-list walk tests `row.y−1 <= cursor.y <= row.y+1`; disabled-bit check gates hit | @asm row-list loop with y±1 comparisons; disabled-bit test | BYTE_VERIFIED |
| Phase 2: button-list walk; adj = (p[+0xa]&0x10) ? 0 : 3 (extra inset when flag 0x10 clear) | @asm button-walk; `test byte[bx+0xa],0x10`; conditional adj assignment | BYTE_VERIFIED |

#### Key dispatch

| Claim | Evidence | Status |
|-------|----------|--------|
| Edit-field path: BS/Enter/ESC/F1/F3 handled directly; printable keys classified via char-class table CS:[key+0x27ED]&0x57 | @asm edit-path key switch; `mov al,cs:[bx+0x27ed]`; `and al,0x57` | BYTE_VERIFIED |
| Non-edit row path: Space/Enter activate; UP/DOWN follow prev/next ptrs in row-list | @asm non-edit row branch; `mov bx,[bx+prev]`/`[bx+next]` | BYTE_VERIFIED |
| Non-edit button path: separate dispatch after row path falls through | @asm button-path tail | BYTE_VERIFIED |

### func_070060 — report_screen_run

Full key-navigation and mouse hit-scan byte-traced. Both TBD-inner regions
are now BYTE_VERIFIED.

| Claim | Evidence | Status |
|-------|----------|--------|
| Key-nav: row = (row ± 1) % 4; col = (col ± 1) % 3 | @asm key-nav section; modulo via idiv/sub pattern | BYTE_VERIFIED |
| Redraw after nav via func_070C4B | @asm `call func_070C4B` after row/col update | BYTE_VERIFIED |
| Mouse hit-scan: 3×4 grid double loop; cell size w=0x30 h=0x48 | @asm mouse hit-scan outer/inner loop; `mov cx,0x30`; `mov ax,0x48` | BYTE_VERIFIED |
| Point-in-rect test: func_070C41 for preliminary rect + 0x181F:0x3CA for cell rect | @asm `call func_070C41`; `lcall 0x181F,0x3ca` | BYTE_VERIFIED |

---

## Group A overlay-call resolution (2026-06-08)

### func_04CC50 — ai_strategic_plan_build (TBD-inner substantially reduced)

All four intra-page trampolines in the function body resolved to named targets.

| Lead (cs: offset) | Target | Resolved file offset | Status |
|-------------------|--------|---------------------|--------|
| cs:0x7A71 | func_04C35A | 0x04C35A | BYTE_VERIFIED |
| cs:0x7A76 | func_04CAF6 | 0x04CAF6 | BYTE_VERIFIED |
| cs:0x7ABC | func_04C4AE | 0x04C4AE | BYTE_VERIFIED |
| cs:0x7AD5 | func_04C50C | 0x04C50C | BYTE_VERIFIED |

| Claim | Evidence | Status |
|-------|----------|--------|
| Second ai_queue_a_find_or_insert call: b3=3 always, b0=colony_x, b1=colony_y | @asm second call-site arg pushes; constant 3 for b3 | BYTE_VERIFIED |
| ai_table_c_insert call: w0=colony_idx, w1=score_clamped, b4=demand_count, b5=has_civilian_flag | @asm ai_table_c_insert call-site arg pushes | BYTE_VERIFIED |
| Remaining not yet decoded: 0x181F far-call chain interiors at thunks 0x8BC/0x2EE/0x37A | targets not yet decoded | not yet decoded |

### func_052F7E — war-matrix (TBD-inner CLOSED)

All three RTLink overlay leads resolved via 0x1A1F thunk table.

| Lead (cs: offset) | Thunk offset | Resolved target | Status |
|-------------------|-------------|-----------------|--------|
| cs:0x7AD0 | 0x1A1F:0x554 | func_02B4D2_colony_sz_517 | BYTE_VERIFIED |
| cs:0x7ADF | 0x1A1F:0x578 | func_025C32_colony_reassign_after_sort | BYTE_VERIFIED |
| cs:0x7AB2 | 0x1A1F:0x50C | war-matrix row setup helper @file 0x26360 | BYTE_VERIFIED |

### func_065D26 — TBD-inner CLOSED

| Lead | Thunk file offset | Resolved target | Status |
|------|------------------|-----------------|--------|
| 0x1A1F:0x88A | 0x1CE7A | func_025A1E_colony_build_advisor (mid-function entry; returns build-advisor reason codes) | BYTE_VERIFIED |

### func_0772FA — TBD-inner CLOSED

| Lead | Thunk file offset | Resolved target | Status |
|------|------------------|-----------------|--------|
| 0x1A1F:0xEE4 | 0x1D4D4 | func_025900_colony_survey_adjacent_tiles (mid-loop cursor gate) | BYTE_VERIFIED |

---

## raw_power_score cite corrections (2026-06-08)

Two corrections to previously-documented byte cites in func_039EE2:

| Claim | Correction | Status |
|-------|-----------|--------|
| score_ff_pts loop @asm cite was 0x03A2E8 | Correct cite is **0x03A2BE** | BYTE_VERIFIED (corrected) |
| vet_mult formula: gate=`100>>n_other`, factor=`8>>n_other` (both right-shift the base constant by the other-power count); total = raw × (8+factor)/8 | @asm 0x03A8B4 recomputed | BYTE_VERIFIED |

---

## Tea party, king-tax control flow, SoL gate corrections (2026-06-08)

### Tea party secondary effects (func_034318, file 0x034439..0x03471E)

Full re-trace of the tea-party handler closed all prior TBDs:

| Claim | Evidence | Status |
|-------|----------|--------|
| King force net change on tea party = **ZERO** | @asm 0x034348 `add [bx+1],al` (pre-dialog raise) then @asm 0x03467F `sub [bx+1],al` (undo after branch taken) | BYTE_VERIFIED |
| EuropeStock dump: `Colony[c][good] -= min(current_stock, 100)` | @asm 0x034678..0x03469B: cmp/clamp ax=min(stock,0x64); sub from [bx+0x5de0] | BYTE_VERIFIED |
| Colony +0xC0 (DGROUP:0x5e08) += dumped_amount (32-bit) | @asm 0x0346A9/0x0346AD: add/adc word ptr [...] | BYTE_VERIFIED write-site; no read-site found — consumed by save/score overlay |
| Boycott mask set: `PowerRecord[active]+0x20 \|= (1<<good)` | @asm 0x034717: or word ptr [bx+0x20],ax | BYTE_VERIFIED |
| SoL +25 / king_anger +10 / FF +25 on tea party | ABSENT — not in this handler | BYTE_VERIFIED absent |

### King-tax raise control flow corrections (func_034AE0, func_034318)

| Claim | Evidence | Status |
|-------|----------|--------|
| Three-outcome routing: KINGRAISE@0x034B62 (guards 1+2), KINGNOTHING@0x034B33 (guard 3 + normal fall-through), KINGLOWER@0x034B44 (prob 1/(diff+1)) | Full re-trace; all goto targets byte-confirmed | BYTE_VERIFIED |
| Prior label `raise_was_blocked` (= 0x034B62) was WRONG | 0x034B62 IS the raise path; guarded by `tax≤1` OR `proposed+5≥current` | CORRECTED |
| `random_int(lo=1, hi=diff+1)` at @0x034B28 — KINGLOWER prob = 1/(diff+1) | lcall 0x181F:0x4D4 arg sequence | BYTE_VERIFIED |
| `random_int(lo=1, hi=5-diff)` at @0x034B51 — KINGLOWER lower delta | @asm 0x034B51 | BYTE_VERIFIED |
| `random_int(lo=1, hi=diff)×2` at @0x034B6A — KINGRAISE delta | @asm 0x034B6A | BYTE_VERIFIED |
| Refuse-side anger model "+5 king anger on refuse" | ABSENT — func_034318 refuse path (choice≠2, 0x034675→0x03471A RETF) writes NOTHING | BYTE_VERIFIED absent |

### PowerRecord+0x18 = king-enforcement counter (not "battles_won")

| Claim | Evidence | Status |
|-------|----------|--------|
| Two write sites: zeroed @0x034206 (per-nation init); INC @0x05BF21 (human player wins vs REF, guarded by atk_power<4 AND [bx+0x543F]==0) | @asm operands at both sites | BYTE_VERIFIED |
| Score formula: `PowerRecord[+0x18] × -(difficulty+1)` = larger penalty if more king-force engagements won | @asm 0x03A4A4..0x03A543 | BYTE_VERIFIED |

### POWER_GATE_9410 stride correction + semantics (sons_of_liberty.c)

| Claim | Evidence | Status |
|-------|----------|--------|
| Table DGROUP:0x9410 stride = **1** (compact array per power_idx) NOT 0x13C | Agent trace: read site @0x03E8D0 uses bx=raw_power_idx; [bx-0x6BF0] = DS[0x9410+power_idx] | BYTE_VERIFIED |
| Prior `gate[power_id * POWER_STRIDE]` (= power×0x13C) was a **BUG** in sons_of_liberty.c | Fixed to `gate[power_id]` | CORRECTED |
| Semantic: accumulated total colonist count (popsum) per power | func_03FD38: zero on entry, +1/colonist-in-colony, +entity[+0x1F] per entity (pop byte 0..32) | BYTE_VERIFIED |
| Threshold >= 4 → SoL milestone messages; >= 8 → cavalry/military effects | @asm 0x03E8D0 (SoL), @0x055FFA/@0x05F450 (cavalry) | BYTE_VERIFIED |

---

## Diplomacy tables + clamp resolution (2026-06-08, commit c434295)

### ovly_181F_035C = pure clamp(value, lo, hi)

| Claim | Evidence | Status |
|-------|----------|--------|
| `ovly_181F_035C` is a pure clamp — not random, not modulo | Implementation at file 0x0048CC (runtime 0x024C:0x000C); dispatched via overlay stub 0x181F:0x035C at file 0x1A94C | BYTE_VERIFIED |
| Arg order: `clamp(value=[bp+6], lo=[bp+8], hi=[bp+0xa])` = `max(lo, min(value, hi))` | Hand-traced from file 0x0048CC | BYTE_VERIFIED |
| File 0x28792 is a DIFFERENT function (calls 0x181F:0x0092 then 0x181F:0x00B0) | Bytes at 0x28792 confirmed ≠ clamp body | BYTE_VERIFIED |

### DGROUP:0x942C — g_diplo_contact_942C / DGROUP:0x941C — g_trade_accum_941C

| Claim | Evidence | Status |
|-------|----------|--------|
| 0x942C: per-power byte[4]; diplomatic contact count 0..255 saturating | Reset @0x042171; saturating increment @0x042126; display read @0x03DF67 | BYTE_VERIFIED |
| 0x941C: per-power word[4]; cumulative trade/gold accumulator | Zeroed @0x042142; accumulated @0x042335; trade-partner selection @0x03F0C5 | BYTE_VERIFIED |
| Smite-gold: `player_factor = contact_count + trade_volume`; full formula gold = clamp((treasury/50 × factor)/50, 10, 200) × 50 ∈ [500, 10000] | meeting.c / diplomacy_smite_gold.c | BYTE_VERIFIED |

### DS:0x2F77 offset +0 correction / DS:0x5236 renamed combat strength

| Claim | Evidence | Status |
|-------|----------|--------|
| `g_occtype_weight_2F77[occt]` byte is at struct offset +0 (not +1) | @asm 0x07461B: `[bx+0x2F77]` with bx=type×16 | BYTE_VERIFIED |
| Field `g_unittype_combatstr_5236` is combat strength (not boolean flag) | Accumulated at 0x04619D | BYTE_VERIFIED |

---

## KINGNOTHING + unit-type names + g_unit_stat stride-14 (2026-06-08)

### KINGNOTHING call form at 0x034B33

| Claim | Evidence | Status |
|-------|----------|--------|
| "KINGNOTHING" string at DS:0x109C (file 0x1EA3C) | @bytes `4b 49 4e 47 4e 4f 54 48 49 4e 47 00` at file 0x1EA3C | BYTE_VERIFIED |
| Call form: `LEA BX,[0x087C]` / `LEA AX,[0x109C]` / `SUB DX,DX` / `LCALL 0x181F:0x0998` / `LEAVE/RETF` | @bytes `8d 1e 7c 08 8d 06 9c 10 2b d2 9a 98 09 1f 18 c9 cb` at file 0x034B33 | BYTE_VERIFIED |
| Register-based arg passing (BX/AX/DX — no PUSH before LCALL) | No PUSH between ADD-SP cleanup and LCALL | BYTE_VERIFIED |

### NAMES.TXT @UNIT type-id mapping (BYTE_VERIFIED via data/unit_classes.c)

23 types; row = `UnitRecord.type`. Key demotion entries (func_05B2C2 combat resolver):
types 1→0 (Soldiers→Colonists), 4→1 (Dragoons→Soldiers), 7→9 (Cont.Cav.→Cont.Army),
8→6 (Cavalry→Regulars), 9→0 (Cont.Army→Colonists).
Special: outcome==0 AND vet_type==0x18 → outcome=3 (Missionaries).
`combat_demotion_ladder.c` TODO_VERIFY cleared.

### g_unit_stat stride-14 correction

Prior `overlay_03C5A8_040C11.c` comments and code used stride 6 for g_unit_stat accesses. Wrong.

| Claim | Evidence | Status |
|-------|----------|--------|
| Stride is 14 (not 6) | @asm 0x03CB00: `d1 e3 03 d8 d1 e3 03 d8 d1 e3` = 3×SHL+2×ADD = ×14; same @0x03F990 / @0x03FA20 | BYTE_VERIFIED |
| `type*14+0x5236`=ATK, `+0x5237`=cargo, `+0x5238`=size | Matches @UNIT loader @0x074F11/0x074F1E/0x074F27 | BYTE_VERIFIED |

Code bugs fixed: `t * 6` → `t * 14` at two sites (lines 2221, 2234) in `overlay_03C5A8_040C11.c`.
