# DGROUP Memory Map — canonical address → field reference

**Purpose.** This is the single source of truth for VICEROY's data-segment
(DGROUP) layout: every record table, every scalar global, their bases, strides,
field offsets, and verification status. It is the reference that

1. **skeleton porting** uses, so new ports read named fields instead of inventing them, and
2. the **memory-model refactor** uses, so each absolute-address poke
   (`*(uint16_t near*)0x8542`) can be mechanically rewritten to a named C
   struct/global with a known address.

**Regenerate the evidence.** The address inventory backing this doc is produced
from the C tree itself:

```
python3 tools/extract_dgroup_map.py --json docs/dgroup_map.json
```

`docs/dgroup_map.json` lists all 757 distinct DGROUP addresses the code touches,
each with ref counts, access kind, and table classification. This `.md` is the
curated narrative; the `.json` is the machine-checkable index for the refactor.

---

## 1. Two addressing modes (read this first)

DGROUP state is reached two structurally different ways, and the map treats them
differently:

| Mode | Asm shape | Displacement means | Examples |
|---|---|---|---|
| **Index-addressed table** | `imul reg,idx,STRIDE` · `[reg+DISP]` | `DISP = table_base + field`; the **record index is in the register** | UnitRecord, AIPersonality, NativeSettlement, PowerRecord |
| **Pointer-addressed struct** | `mov bx,[ptr]` · `[bx+FIELD]` | `FIELD` is the **small** struct offset; base is a loaded far pointer | ColonyRecord (via `ctx`@`0x8542`) |

Consequence: a fixed displacement like `0x543F` in `[bx+0x543F]` is **not**
`UnitRecord[319]` — it is the *record-0 field address* `AIPersonality+0x31`, with
the index supplied by `bx`. The extractor classifies displacements only against
each table's **record-0 window** `[base, base+stride)`; those windows are
disjoint, so classification is unambiguous. ColonyRecord field offsets (`+0x9A`,
`+0x1F`, `+0x95`…) are small and pointer-relative, so they appear as scalars in
the raw index and are documented here by hand from `colony.h`.

---

## 2. DGROUP region spine (address order)

Whole-segment layout, low→high. "Authority" is the header/file that owns the
detailed definition.

| Range | Region | Stride | Status | Authority |
|---|---|---|---|---|
| `0x0158–0x0186` | Screen/cursor coord cluster | scalars | partial | dialog.c, ui/ |
| `0x015C / 0x0160` | Map-layer far pointers (×2) | far ptr | verified | globals.h |
| `0x0337–0x039F` | Render flags (`0x34D` skip-render, `0x35C/0x348` tutorial) | scalars | verified | globals.h |
| `0x07E8–0x08A0` | Render/cursor working cluster (`0x089E`) | scalars | partial | render/ |
| `0x1E7E / 0x1F5C–0x1F66` | UI/report working scalars | scalars | partial | ui/report |
| `0x267A` | Major state record far pointer | far ptr | verified | globals.h |
| `0x26A3–0x27D3` | C-runtime: DOS-exec save area, argc/argv/envp | scalars | verified | runtime/ |
| `0x2916 / 0x290E` | stdout / stdin `FILE` structs | far ptr | verified | iolib |
| `0x2B01–0x2D52` | C-runtime: open-mode, iob dispatch, printf stream | scalars | verified | iolib |
| `0x2F7B` | **Terrain-yield table** (16 B/terrain, ~64 ids) | `0x10` | verified base | globals.h |
| **`0x3144`** | **UnitRecord table** | **`0x1C`** | **BYTE_VERIFIED** | unit.h · §3.1 |
| `0x3995–0x39FF` | RTLink overlay layout (written by system_init) | `0xAA` words | verified | globals.h |
| `0x5237` | Per-unit-type table (stride 14) | `0x0E` | verified base | globals.h |
| `0x5382–0x53A6` | **Game phase / progress / counts / difficulty** | scalars | verified | §4 |
| **`0x540E`** | **AIPersonality table** (4 EU) | **`0x34`** | **BYTE_VERIFIED layout** | ai_personality.h · §3.2 |
| **`0x54EC`** | **NativeSettlement table** | **`0x12`** | **BYTE_VERIFIED base** | native.h · §3.3 |
| `0x54F6` | Native per-pair **alarm** word array | word`[9·N]` | verified shape | native.h · §6 ⚠ |
| **`0x5D46`** | **ColonyRecord table** (persistent, 0xCA) | **`0xCA`** | mostly verified | colony.h · §3.4 |
| `0x84FC` | `g_active_power` — far ptr to active PowerRecord | far ptr | verified | effects.c |
| `0x8542` | `ctx` — far ptr to **current colony** (102 callers) | far ptr | verified | globals.h |
| `0x853A / 0x853C` | Map width / height | scalars | verified | globals.h |
| **`0x8808`** | **PowerRecord table** (4 EU; ends ~`0x8CF8`) | **`0x13C`** | partial | power.h · §3.5 |
| `0x8D4A` | **current-native-settlement pointer** (`mov bx,[0x8D4A]`; deref [bx+field]) | far ptr | verified | native/ |
| `0x8D4C–0x8D7A` | unit-iter chain, render aux | scalars/ptr | partial | globals.h |
| `0x8DC8–0x8E66` | **Europe market** parallel WORD arrays (×4, 20 ea) | `0x28` | verified | globals.h |
| `0x8F86` | Stride-12 chain table | `0x0C` | verified base | globals.h |
| `0x917A / 0x9E12` | Render field / **active-power index** (`0x9E12`) | scalars | verified | globals.h |
| `0xA891–0xA896` | Colony-center pre-pass yields | scalars | verified | globals.h |

---

## 3. Record tables — verified field layouts

### 3.1 UnitRecord — base `0x3144`, stride `0x1C` (28 B) — **BYTE_VERIFIED**

Flat table; index-addressed (`imul reg,idx,0x1C; [reg+0x3144+field]`). Count =
`g_unit_count`@`0x539C`. Full layout in `unit.h`; field highlights:

| Off | Field | Notes |
|---|---|---|
| `+0x00/01` | map_x / map_y | `0xFF` = off-map |
| `+0x02` | type | `@UNIT` index (most-read field; was mislabeled as the base) |
| `+0x03` | owner_flags | owner = low nibble (`&0xF`) |
| `+0x06` | moves_remaining | init `0xFF` |
| `+0x08` | orders | activity state |
| `+0x09/0A` | goto_x / goto_y | |
| `+0x0C..0x15` | cargo (slot_count, packed kinds, qty[6]) | |
| `+0x16` | turn_counter | caps at 8 |
| `+0x17` | vet_type | profession `0x13..0x1C` |
| `+0x18 / +0x1A` | chain_prev / chain_next (word) | tile-occupancy chain; `0xFFFF`=null |

**Physical extent UNRESOLVED:** bounded dynamically by `g_unit_count`; the
contiguous cap is not pinned (next known global is `0x3995`).

### 3.2 AIPersonality — base `0x540E`, stride `0x34` (52 B) — **BYTE_VERIFIED layout**

4 EU records (next global at `0x54DE` ≈ 4·`0x34`, consistent with 4 powers).

| Off | Field | Notes |
|---|---|---|
| `+0x00` | leader_name[0x18] | `LEADERNAME` strcpy @`0x74C22` |
| `+0x18` | colony_name[0x18] | default `COLONYNAME` pool |
| `+0x30` | field_30 | zeroed at init |
| `+0x31` (`0x543F`) | **controller_flag** | 1=AI, 0=human, 2=dead; ~218 refs — *the* most-referenced field |
| `+0x32` | named_colony_count | |

Per-nation personality **weights are RECONSTRUCTED/overlay-resident** — not here.

### 3.3 NativeSettlement — base `0x54EC`, stride `0x12` (18 B) — **BYTE_VERIFIED base**

Count = `g_settle_count`@`0x539A` (max 84). x/y/owner/mission verified; rest partial.

| Off | Field | Notes |
|---|---|---|
| `+0x00/01` | x / y | verified |
| `+0x02` | owner | **power index** = tribe_id + 4 (natives are powers 4..11) |
| `+0x03` | flags | bit `0x04` = developed/visited |
| `+0x04` | population | CHIEFKILL raze input |
| `+0x05` | mission | `0x10 | owner` (verified) |
| `+0x06..0x0A` | byte/word ops verified, **roles not yet decoded** | |

### 3.4 ColonyRecord — base `0x5D46`, stride `0xCA` (202 B persistent) — base BYTE_VERIFIED

Base proven at `func_0082DC` @`0x008307` (`imul bx,idx,0xCA; add bx,0x5D46`).
**Pointer-addressed** via `ctx`@`0x8542` (174-B working buffer shares the 202-B
prefix). Count = `g_colony_count`@`0x539E`. Field highlights from `colony.h`
(`+0x1A` owner_power == absolute `0x5D60` for record 0):

| Off | Field | Notes |
|---|---|---|
| `+0x00/01` | map_x / map_y | 1-based origin |
| `+0x1A` | owner_power | indexes AIPersonality (stride 0x34) |
| `+0x1F` | population | bounds the per-colonist arrays |
| `+0x20 / +0x40 / +0x60` | job / unit_type / expertise per-colonist arrays | |
| `+0x70..0x83` | tile_state[20] | surrounding-tile state |
| `+0x84 / +0x8A` | building-present / feature bit-arrays | |
| `+0x95` | 8-bit counter (level/stage; drawlist pile 0xf) — **NOT food** | §5.2 |
| `+0x96` | 8-bit counter companion (drawlist pile 0x1e) | §5.2 |
| `+0x9A..0xC1` | stockpile[20] (15 commodities + slack) | |
| `+0xAA` | liberty/rebellion counter | |
| `+0xC2/0xC4/0xC6` | SoL "bells" 32-bit numerator/denominator | |

### 3.5 PowerRecord — base `0x8808`, stride `0x13C` (316 B) — partial

Physically **4 EU records** (table ends ~`0x8CF8`; native cursors begin `0x8D4A`).
BYTE_VERIFIED scalars (from `effects.c`, scoring, king-tax traces):

| Off | Field | Status |
|---|---|---|
| `+0x01` | tax_rate | verified |
| `+0x07` | FF bitmap | verified |
| `+0x0C / +0x0E` | bells current / total | verified |
| `+0x12` | pending/last-acquired FF slot (`0xFFFF` on acquire) | verified |
| `+0x14` | founding_fathers_count | verified |
| `+0x20` | boycott bitmap (cleared by Jakob Fugger) | verified |
| `+0x2A` | **gold** (dword) | verified |
| `+0x32/+0x33` | home x/y (copied into new units) | verified |
| `+0x34` | war matrix (abs `0x883C`) | verified |
| `+0x4C` | price_level byte[16] | verified |
| `+0x4C..0x13C` | market pool/volume/supply/base arrays | **RECONSTRUCTED** (widths unconfirmed) |

> `power.h` still carries the older "8 powers / market arrays" reconstruction and
> a stale prefix; trust this section + `effects.c` `@asm` over it until `power.h`
> is reconciled (tracked in §5).

---

## 4. Game phase / progress / counts cluster (`0x5382–0x53A6`)

The hottest scalar cluster. Index-free globals:

| Addr | Name | Meaning | Status |
|---|---|---|---|
| `0x5382` | `g_game_phase` | bitfield: bit0 independence-declared, bit1 boycott, bit2 congress-notified latch, bit8 war/revolution, bit0x10 independence-won | BYTE_VERIFIED (scoring/compute.c) |
| `0x539A` | `g_settle_count` | native-settlement count (×0x12 index) | verified |
| `0x539C` | `g_unit_count` | unit-table count (×0x1C index) | verified |
| `0x539E` | `g_colony_count` | colony-table count (×0xCA index) | verified |
| `0x53A6` | `g_difficulty` | 0..4, default 2 (Conquistador); **global, not per-power** | BYTE_VERIFIED |
| `0x5392/4/6/8` | `g_progress_*` | era/turn-stage progress scalars | partial |
| `0x9E12` | active-power index | separate from difficulty | verified |

Full per-scalar list with citations: `include/globals.h`.

---

## 5. Open conflicts & boundaries to resolve

These are the items the refactor must **not** paper over. Each needs one more
byte-trace before its field can be named with confidence.

1. ~~**ColonyRecord base `0x5D46` vs `0x5D60`**~~ — **RESOLVED 2026-06-08: base is
   `0x5D46`.** `func_0082DC` @`0x008307` does `imul bx,idx,0xCA; add bx,0x5D46;
   mov [0x8542],bx` — the canonical record-pointer idiom (same proof shape as
   UnitRecord `0x3144`). `0x5D60` is therefore `+0x1A` = **owner_power**, not the
   base — the identical base-vs-field trap. The same block confirms `0x8542` =
   current-colony ptr and that `owner_power` indexes AIPersonality
   (`imul *,0x34; [bx+0x543F]`). `colony.h` prose corrected to match.
2. **ColonyRecord `+0x95`** — **RESOLVED 2026-06-08: NOT food stock.** The real
   food stock is the 16-bit `+0x9A[0]` stockpile array (independently verified).
   `+0x95` is a small **8-bit per-colony counter**: zeroed at colony init
   (`func_02EB78 @0x2EC00`), inc/dec by 1 (`func_02BC72 @0x2C240` does
   `inc [bx+0x95]; inc [bx+0x96]` as a pair; `dec` @0x5C44E), drawn as drawlist
   pile item `0xf` (`func_026DD4 @0x26F8D`; companion `+0x96` = item `0x1e`). The
   `0x8D00` helper's `(val+1)*100` is used only as a **threshold** vs food
   (`+0x9A`) and liberty (`+0xAA`), never as a coordinate — so `+0x95` is a
   level/stage multiplier feeding a population-scaled food-growth gate
   (`population/6` test @`func_055760 0x55B3F`). Both reads hit the same field
   consistently (not overloaded). *Residual:* exact gameplay name (growth tier vs
   building level) not pinned; food misread is decisively rejected.
3. **PowerRecord count** — **RESOLVED 2026-06-08: 4 EU records** (`0x8808..0x8CF8`).
   The next global `0x8D4A` sits exactly `0x542 = 4·0x13C` above the base, and is
   itself a **pointer** (`mov bx,[0x8D4A]` then deref) = current-native-settlement
   cursor, parallel to `ctx`@`0x8542`. Native "powers" 4..11 (from
   `NativeSettlement.owner`) do **not** own `0x13C` records; their per-tribe state
   lives in the `0x54EC` settlement records + the alarm array. *Remaining:*
   reconcile `power.h` prose (drop "8 powers", flag the market-array widths as
   RECONSTRUCTED).
4. **Native alarm array overlaps settlement record 0** — `0x54F6` = `0x54EC`+`0xA`;
   `native.h` says the alarm word array is *separate* from the 18-B settlement
   records, yet it numerically sits inside record 0's `+0x0A`. Either the
   settlement table is not contiguous from `0x54EC` or the alarm array has a
   different base. Trace the alarm read/write (`0x04734E`, `0x05C651`) vs a
   settlement-record write to disambiguate.
5. **UnitRecord physical cap** — dynamic count known (`0x539C`); contiguous
   maximum not pinned.

---

## 6. How this drives the modern refactor

When milestone 2 (memory-model refactor) begins, `dgroup_map.json` is the input:

- **Index-addressed table fields** → replace `*(T near*)(idx*STRIDE + DISP)` with
  `table[idx].field`, where `(STRIDE, DISP→field)` come from §3.
- **Pointer-addressed colony** → replace `*(T near*)(bx+FIELD)` (bx=`ctx`) with
  `ctx->field`.
- **Scalar globals** → replace `*(T near*)0xADDR` with the named `extern` from
  `globals.h`.
- **Unresolved (§5) addresses** → left as explicit, named TODO globals; never
  silently renamed.

A field is only eligible for automated rewrite when it appears in §3/§4 with a
verified status. Everything else routes through §5 first.

---

*Generated narrative over `tools/extract_dgroup_map.py` output. Field layouts
consolidated from `include/{unit,colony,power,native,ai_personality,globals}.h`
and the `@asm`-cited bodies in `src/`. Update the `.json` (re-run the extractor)
whenever new address references land, and reconcile §5 as conflicts close.*
