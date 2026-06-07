# Data Model — Record Types and DGROUP Layout

Every record type used by VICEROY.EXE, with field offsets and stride
sizes. All BYTE_VERIFIED via decompiled access-site code unless flagged
TBD.

---

## PowerRecord — per-power state (12 entries, 0..11)

**Base**: `DGROUP:0x8809`. **Stride**: `0x13C` (= 316 bytes).
**BYTE_VERIFIED** via SMITE, raze, king-tax, combat decompilations.

Indices:
- 0..3: European powers (Dutch, English, French, Spanish — order per
  NAMES.TXT $COUNTRY)
- 4..11: Native tribes (Sioux, Iroquois, Apache, Cherokee, Aztec, Inca,
  Tupi, Arawak — order per NAMES.TXT $TRIBES)

**Known fields** (offset within record):

| Offset | Type | Field | Verified by |
|------:|------|-------|-------------|
| +0x00 | byte | `treasure_pool_byte` (used in SMITE multiplier) | SMITE byte-trace |
| +0x06 | bytes | `attribute_bitfield` (start) — read by `power_attribute_bit` | BYTE_VERIFIED at file 0x00BC10 |
| +0x21 | dword | `gold` (32-bit running total) | raze byte-trace |
| +0x25 | dword | `total_loot` (32-bit) | raze byte-trace |
| +0x29 | dword | `treasury` (32-bit, decremented in SMITE / colony-burn) | SMITE + colony-burn |
| +0x33 | byte | `score_or_flags` byte (start) — read by `get_per_power_byte` for EU powers | universal accessor BYTE_VERIFIED |

**Bitfield semantics** (offset +6):
- bit 10 — controls SMITE jackpot path (skip MAX → use treasure_pool directly)
- bit 19 — halves SMITE gold result
- bit 6 — combat / promotion modifier (TBD)
- Other bits TBD

---

## UnitRecord — per-unit state (300 max)

**Base**: `DGROUP:0x3146`. **Stride**: `0x1C` (= 28 bytes).
**BYTE_VERIFIED** via 652+ refs to `[reg+0x3146]` plus unit-creation
plus runtime cross-validation 2026-05-05.

### UnitRecord field layout (28 bytes, RUNTIME-VERIFIED across 256 records)

| Offset | Type | Field | Verification |
|------:|------|-------|--------------|
| +0x00 | byte | **`unit_type`** = NAMES.TXT @UNIT row index (0..23) | Type freq matches @UNIT idx (Colonists=190, Braves=37, Caravel=3, etc.) |
| +0x01 | byte | **`power | flags`** (low nibble = power_idx 0..11; high nibble = state flags) | Braves (type 0x13) have +0x01 ∈ {0x04, 0x07, 0x09, 0x0A} = native tribe power indices; player Colonists +0x01 = 0x00 |
| +0x02 | byte | varies (order/destination state) | Caravel=0, Merchantman=0x20, Soldier=0x0C |
| +0x03 | byte | varies (sub-state) | Different per unit |
| +0x04 | byte | varies — 0xFF = "no destination tile"? | ships often 0xFF, land units have small values |
| +0x05 | byte | unit-type-specific code | Caravel=0x45, Merchant=0x34, Brave=0x58, Soldier=0x3F, Treasure=0x2D — possibly NAMES.TXT @ORDERS code (0x2D='-' = No Orders) |
| +0x06 | byte | varies (current orders progress?) | usually 0; non-zero for active orders |
| +0x07 | byte | **`map_x`** | Verified — Caravel at (55,49) matches expected ship pos |
| +0x08 | byte | **`map_y`** | Verified |
| +0x09 | byte | possibly ship size or movement-spec | varies per unit type |
| +0x0A..+0x0B | bytes | varies | TBD |
| +0x0C..+0x0F | 4 bytes | mostly 0; ships have non-zero (cargo or destination?) | Caravel: `00 00 14 0F`, Brave: zeros |
| +0x10..+0x11 | bytes | usually `0xFF 0x00` sentinel | "no target" marker |
| +0x12..+0x13 | bytes | varies | TBD |
| +0x14..+0x17 | bytes | per-unit state | TBD |
| +0x18..+0x1B | bytes | tail bytes — often varying small values | possibly `unique_id` / generation counter |

Power index encoding:
- 0 = English, 1 = French, 2 = Spanish, 3 = Dutch
- 4 = Inca, 5 = Aztec, 6 = Arawak, 7 = Iroquois
- 8 = Cherokee, 9 = Apache, 10 = Sioux, 11 = Tupi


functions writing to byte +0x15 with constants 0x15..0x1C.

| Offset | Type | Field | Notes |
|------:|------|-------|-------|
| -2 | byte | (chain link to prev record — uses last 2 bytes of preceding record's slot) | |
| -1 | byte | (chain link) | |
| +0x00 | byte | `unit_type_or_flags` (most-accessed: 652 refs) | Possibly is_alive flag |
| +0x01 | byte | low nibble = power_idx (0..11) | AI dispatcher uses `[reg+0x3147] & 0x0F` |
| +0x06 | byte | (frequent access: 189 refs — likely orders or state) | |
| +0x15 | byte | `unit_class` or `profession` (initialized 0..0x1C at creation) | Combat demotion table reads this |
| +0x18 | byte | `direction` or `facing` (used by render chain) | |

The 28-byte record uses bytes 0..0x19; bytes 0x1A..0x1B are chain
fields linking adjacent records (linked-list within the array).

---

## ColonyRecord — per-colony state (~50 max)

**Stride**: `0xCA` (= 202 bytes per colony) — verified by adjacent
records: Jamestown @ 0x5D46, Quebec @ 0x5E10 (diff = 0xCA).

**BYTE_VERIFIED** via accessor copy-lengths. 30+ refs to `[reg+0xCA]`
stride patterns. Also verified by direct memory inspection 2026-05-05.

**Earlier "+0xAE working buffer" hypothesis was wrong**: the area
between persistent records is filled with the NEXT colony's
persistent record, not a working buffer. Working state (per-tile
yields, hammers progress, etc.) may be:
- Computed on-demand from persistent fields (not stored)
- Stored in a separate per-colony table (location TBD)

The 50-max-colonies persistent area extends from 0x5D46 to ~0x84D6
(50 × 202 = 0x2790 bytes), but only first N slots are populated.

**Pointer**: `[DGROUP:0x8542]` = far pointer to currently-active
colony record (BYTE_VERIFIED in many functions, including colony burn
at file 0x05DE1A).

**Known fields** (offset within record):

| Offset | Type | Field | Verified by |
|------:|------|-------|-------------|
| +0x1A | byte | `owner_power_idx` (0..3) | colony burn byte-trace |
| +0x1F | byte | size/population factor (used in colony-burn loot formula) | colony burn byte-trace at file 0x05DE1E |
| +0x1B | byte | foreign-colony status (0 for player-owned; varies for foreign) | Quebec=0x98, Isabella=0x18, NewAms=0x98, StoDom=0x10 — possibly trade reputation byte |
| +0x1C | byte | constant 0x40 across all 6 colonies | likely "warehouse base capacity" or config flag |
| +0x20 | byte | foreign-colony marker (0 for player; 0x0D=13 for foreign typical) | Off-by-one candidate for the displayed "12" in foreign-colony hover info |
| +0x22 | u16 | `colony_state_packed` (low byte + high byte): non-zero only for player-owned + visible colonies | CROSS-COLONY: Eng=(0x09 0x09 0x11), Du=(0x05 0x0D), Sp/Fr=0 |
| +0x40..+0x4? | byte[N] | **`colonist_job_skills`** (1 byte per colonist; length = +0x1F size) | RUNTIME-VERIFIED: Plymouth size 5→6 added new byte 0x0d (Carpenter, NAMES.TXT @JOB[13]) at end of array |
| +0x60..+0x65 | u48 | **`buildings_constructed_bitmask`** (bit i = building i constructed; visible only for player-owned colonies) | RUNTIME-VERIFIED 2026-05-05: Plymouth 19 bits set (well-developed); Jamestown 14 bits; Roanoke 2 bits (new); Foreign colonies 0 bits (player can't see). Bit assignment likely matches PEDIA @BUILDING0..41 indices but exact mapping needs disasm to confirm (Plymouth bits 2-19,21 set without bits 0,1 suggests upgrade chains may overwrite lower-tier bits). |
| +0x70..+0x77 | byte[8] | **`tile_worker_assignment`** (8 surrounding tiles in NW/N/NE/W/E/SW/S/SE order; value = colonist index in +0x40 array, 0xFF = empty tile) | RUNTIME-VERIFIED across 7 colonies: Plymouth has 3 colonists on tiles (W=1, E=2, SE=0), Jamestown 3 (E=0, S=1, SE=2), New Amsterdam 5 (NW=4, N=1, NE=5, SW=0, SE=2). Foreign colonies have all 0xFF (player can't see). |
| +0x9A | u16[16] | **`stockpile` array** (current cargo per good, NAMES.TXT @CARGO order) | RUNTIME-VERIFIED 2026-05-05: Plymouth +0x9A = (31, 96, 0, 0, 0, 100, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0) matches in-game inventory bar at frame 1310196718 |
| +0xBA | u16 | colony-counter pair (lo=building progress?, hi=tier) | Plymouth=262 (lo=6, hi=1); Quebec=513 (lo=1, hi=2) |
| +0xBC | u16 | colony-counter pair | New Amsterdam=1537 stands out |
| +0xC2 | s32 | **`rebel_dividend`** (Sons of Liberty fraction numerator) | RUNTIME-VERIFIED 2026-05-07 via pavelbel/smcol_saves_utility schema cross-reference: Plymouth at frame 1310196718 had +0xC2 = 66, +0xC6 = 617 → 66/617 = 10.7% Sons of Liberty (matches in-game display "10..."). NOT wealth as previously labeled. |
| +0xC6 | s32 | **`rebel_divisor`** (Sons of Liberty fraction denominator) | Same source — Plymouth 617 → 724 across session |
| +0xC6 | u16 | colony counter (NOT lifetime bells — increments slowly +1/2 per turn, jumped +101 when Plymouth grew from size 5→6) | Plymouth trace: 617→621→722→724 across turns 51-58, big jump at colony growth |

The 202-byte persistent buffer is what gets serialized to the .MP file;
the 174-byte working buffer is RAM-only, regenerated each turn.

---

## NativeSettlement — per-native-village

**Base**: `DGROUP:0x54EC`. **Stride**: 18 (= 0x12 bytes).
**RUNTIME-VERIFIED 2026-05-04** by extracting all 42 active settlements
from `session_1777952458/mem/1310473156000000.zst` and matching
positions against TRIBE.TXT dispersal templates and user-reported
mission ground-truth.

Capacity: ≥ 60 records (table extends well past last active entry).

### Field layout (18 bytes)

| Offset | Type | Field | Verified by |
|------:|------|-------|-------------|
| +0x00 | byte | `map_x` | matches dispersal templates |
| +0x01 | byte | `map_y` | same |
| +0x02 | byte | `owner_power_idx` (4=Inca, 5=Aztec, 6=Arawak, 7=Iroquois, 8=Cherokee, 9=Apache, 10=Sioux, 11=Tupi) | per-tribe grouping in dump |
| +0x03 | byte | flags: bit `0x04` = capital, bit `0x08` = "spoke with chief" / visited | inferred (capitals always have higher pop at +0x04) |
| +0x04 | byte | `population` (typical: Inca=9 reg/13 cap, Aztec=7/10, mid-tier=5/7, low-tier=3/4) | matches civ-tier pattern |
| +0x05 | byte | `mission`: `0xFF` = none, else `0x10 \| owner_power_idx` (0=Eng, 1=Fr, 2=Sp, 3=Du) | **USER-VERIFIED** — Inca (38,54)=0x13=Dutch, (35,58)=0x10=Eng |
| +0x06 | byte | **`growth_counter`** (signed; per pavelbel cross-ref) | Increments per turn by `population` while brave-missing or pop-below-max. At 20, spawns brave or grows pop. Matches my earlier observations. |
| +0x07 | byte | sentinel (always 0xFF — pavelbel `unknown28a`) | All records have 0xFF here. |
| +0x08 | byte | **`last_bought`** (cargo-type idx of last good bought from this dwelling) | per pavelbel |
| +0x09 | byte | **`last_sold`** (cargo-type idx of last good sold to this dwelling) | per pavelbel |
| +0x0A..+0x11 | 4×{byte,byte} | **`alarm[4]`** = (friction, attacks) per European nation | Per pavelbel: friction goes up when attacked; attacks queues retaliation. My observation that Inca (27,43) had +0x0A=0x20 = English-friction=32; Arawak (45,35) had +0x0E=0x26, +0x0F=0x03 = Spanish friction=38, attacks=3. |

### Settlement counts by tribe (this game)

| Tribe | Active | Note |
|-------|-------:|------|
| Iroquois | 9 | |
| Sioux    | 9 | 3 duplicate (2,13) entries — possibly stale slots |
| Apache   | 7 | |
| Inca     | 5 | (38,54) Dutch mission, (35,58) Eng mission |
| Arawak   | 5 | |
| Cherokee | 4 | |
| Aztec    | 3 | |
| Tupi     | 0 | not spawned in this scenario |

### CHIEFKILL formula uses NativeSettlement[+0x04] (population)

**RUNTIME-VERIFIED 2026-05-04** by the user razing the Inca village at
(35,55) — population byte +0x04 = 9 — for exactly 4,800 gold.

```
gold = sum_3 × roll_4 × 4 × (population + 1)
```

Working through 4,800 = sum_3 × roll_4 × 4 × 10:
- size_byte = +0x02 (power_idx = 4): would require sum_3·roll_4 = 240,
  max possible 180 — **mathematically impossible**, ruling out the
  earlier "byte +2 of TribeData" interpretation.
- size_byte = +0x04 (population = 9): requires sum_3·roll_4 = 120, which
  is achievable at every difficulty except Viceroy (max would be 4,320).

So the CHIEFKILL formula's size_byte sources from **NativeSettlement
+0x04 (population)**, not TribeData[+2]. The `g_settlement_ptr_8D4E`
pointer is repointed to the active NativeSettlement record at attack
time (the disasm read offset is +4, not +2 as previously documented).

---

## TribeData — per-native-tribe defaults (8 entries)

**Base**: `DGROUP:0x5AD6`. **Stride**: 78 (= 0x4E bytes).
**BYTE_VERIFIED** via `func_0081C6` (`set_active_tribe`) which sets
`g_settlement_ptr_8D4E = 0x5AD6 + tribe_idx × 78`.

Indices: 0..7, mapping to power indices 4..11.

The 8 tribes (per Colonization design):
0=Sioux, 1=Iroquois, 2=Apache, 3=Cherokee, 4=Aztec, 5=Inca, 6=Tupi,
7=Arawak.

**Known fields** (offset within record):

| Offset | Type | Field | Verified by |
|------:|------|-------|-------------|
| +2 | byte | `settlement_size_factor` (× by random rolls in raze formula) | CHIEFKILL byte-trace at file 0x04AB24 |

Other fields TBD (78 bytes total — many fields per tribe).

The actual byte values are set at game-init from NAMES.TXT $TRIBES
section data + the scenario-specific tweaks loaded by
`func_0749E0`.

---

## AIPersonality — 4 European-power AI personalities

**Base**: `DGROUP:0x540E`. **Stride**: `0x34` (= 52 bytes).
**Count**: 4 entries (only the 4 European powers — NOT 12).
**RUNTIME-VERIFIED 2026-05-05** by extracting leader-name strings.

The address span is `0x540E..0x54DE` (4 × 0x34 = 208 bytes).
Native tribes (powers 4..11) do NOT have AIPersonality records —
they use NativeSettlement + TribeData instead.

### Field layout (52 bytes per record)

| Offset | Type | Field | Example (English) |
|------:|------|-------|-------------------|
| +0x00..+0x17 | char[24] | `leader_name` (NUL-terminated) | "Walter Raleigh" |
| +0x18..+0x2F | char[24] | `country_name` | "New England" |
| +0x30 | byte | TBD | English=0xC0 |
| +0x31 | byte | `is_active` (game-state flag) | English=0 |
| +0x32 | byte | TBD | English=0x03 |
| +0x33 | byte | TBD | English=0x00 |

### Verified leader names (NAMES.TXT @LEADERNAME confirms)

| Power | Leader (`+0x00`) | Country (`+0x18`) |
|------:|------------------|-------------------|
| 0 English | Walter Raleigh | New England |
| 1 French | Jacques Cartier | New France |
| 2 Spanish | Christopher Columbus | New Spain |
| 3 Dutch | Michiel De Ruyter | New Netherlands |

### What was wrongly documented before

Earlier doc claimed "12 entries" of AIPersonality. Runtime extraction
shows the 4 entries fit exactly in 208 bytes (0x540E..0x54DE). Memory
beyond that is occupied by NativeSettlement at 0x54EC.

### TribeData fully separate

For native tribes, see TribeData below at DGROUP:0x5AD6 stride 78.
TribeData is the analogous "per-tribe AI personality" but uses a
different structure.

---

## Game-state globals (DGROUP scalars)

| Address | Type | Meaning | Verified by |
|---------|------|---------|-------------|
| `0x18E` | word | terrain-display mode | auto-forest function |
| `0x28EE` | word (low) | RNG seed | rand() byte-trace |
| `0x28F0` | word (high) | RNG seed | rand() byte-trace |
| `0x372` | word | score accumulator | inferred from `func_03A9C0` |
| `0x5382` | byte | game flags (bit 0 = endgame) | SMITE + win-check byte-trace |
| `0x538A` | word | turn counter (alt?) | king-events byte-trace |
| `0x538E` | word | turn counter (main) | king tax raise formula |
| `0x5398` | word | current human player | SOL display |
| `0x53A6` | byte | difficulty / current player (0..4) | king tax + SMITE byte-traces |
| `0x53D2` | word | self power | SOL display |
| `0x53A7` | byte | **King anger** (increments per Tea Party / anger event) | USER-VERIFIED 2026-05-04: 2 tea parties caused 3→5 transition |
| `0x53DA` | word | **REF Regulars count** | **USER-VERIFIED 2026-05-04: 23 matches in-game** |
| `0x53DC` | word | **REF Cavalry/Dragoons count** | **USER-VERIFIED: 10 matches in-game** |
| `0x53DE` | word | **REF Man-O-War count** | **USER-VERIFIED: 5 matches in-game** |
| `0x53E0` | word | **REF Artillery count** | **USER-VERIFIED: 8 matches in-game** (NOTE slot 3 not 2) |
| `0x53EA` | word[4] | per-player market base | market function |
| `0x84FC` | far ptr | -> PowerRecord[active_power] (was: "king/payer record") | gold at +0x2A matches in-game UI |

---

## PowerRecord — per-European-power state (4 entries)

**Base**: `DGROUP:0x8808`. **Stride**: 316 (= 0x13C bytes).
**RUNTIME-VERIFIED 2026-05-04** by extracting 4 records and comparing
gold/tax/FF count to in-game UI; cross-validated against an
independent js-dos-based reverse-engineering effort (see
`colonization-memory-map (1).md`).

Power index → record offset:
- 0: English   @ DGROUP:0x8808
- 1: French    @ DGROUP:0x8944
- 2: Spanish   @ DGROUP:0x8A80
- 3: Dutch     @ DGROUP:0x8BBC

### Field layout (relative to power's base address)

| Offset | Type | Field | Verified by |
|------:|------|-------|-------------|
| +0x01 | byte | `tax_pct` (0..100) | BYTE_VERIFIED — `func_034AE0`; user's 0%→1% transition |
| +0x02 | byte | **`rebel_sentiment_pct`** (0..100, displayed as Rebel Sentiment %) | USER-VERIFIED frame 1310124562: byte=13 ↔ "Rebel Sentiment: 13%" |
| +0x07 | u32 | **`acquired_ff_bitmask`** (bit i = FF idx i acquired) | RUNTIME-VERIFIED for player English: bits=[0]→[0,20] when player acquired Adam Smith → +William Brewster between turns 54-56. AI nations may use this slot differently. |
| +0x0C | u16 | **`bells_toward_next_ff`** (resets on each FF acquisition) | CORRECTED 2026-05-05: At snap 0 (turn 51) value=99 with Brewster as next (cost 129); display formula = `threshold - current = 129 - 99 = 30` shown as "30 in 129". After Brewster acquired (between snaps 250-300), value RESET — turn 58 value=30 (accumulated toward NEW next FF). |
| +0x0E | u16 | `bells_per_turn` (Liberty Bells generated last turn) | Frame 1310124562 had 7 bell sprites = +0x0E=7 |
| +0x10 | u16 | `crosses_per_turn` (Cathedral immigrant points) | runtime cross-power check |
| +0x14 | u16 | `founding_father_count` | Frame 1310124562: =1 ↔ Adam Smith only acquired |
| +0x20 | u16 | **`boycott_bitfield`** (bit i = good i boycotted by King) | USER-VERIFIED: only Food (bit 0 = 0x0001) boycotted; Eng record only, all others 0 |
| +0x22 | s32 | **`royal_money`** (King's REF expansion budget — drives REF growth) | RUNTIME-VERIFIED 2026-05-07 via pavelbel cross-ref. Player English: 936→1062 over 7 turns @ Discoverer = **exactly +18/turn**. Continued at +18/turn into session_1777955389 (1188 at turn 65). King_anger went 3→5 mid-session but +18/turn rate UNCHANGED. Threshold > 1188 (no REF added across both sessions). Other nations: 0 (royal_money is player-only). |
| +0x26 | s32 | unknown (pavelbel labels as `unknown24b`) | varies per power |
| +0x2A | u32 | **`gold`** (treasury) | BYTE_VERIFIED — write-back updates UI immediately; user's 3552 / 4032 visible matches |
| +0x1e | u16 | **`artillery_bought_count`** (Europe artillery-recruit escalation counter) | BYTE_VERIFIED 2026-05-31 — read×100 at `0x035124`/`0x03527B`, `inc` at `0x035282`, zeroed at new-game init `0x03662F`. Drives the artillery-only recruit escalation (see below). |
| +0x30 | (none) | ~~`recruit_cost_europe`~~ — **NOT a runtime field** (zero accesses; see RESIDUAL_FINDINGS §14/§21). Recruit gold cost = recruit-pool slot `+0x04` word at DGROUP:0x978C+slot*6 (`func_074688`/read `0x051E52`,`0x035114`). For colonist type 0x0B (Artillery): `cost = base + artillery_bought_count*100`, then counter++ (`0x03527B`/`0x035282`). NOT `base<<count`. The pavelbel SAV "+0x30" is a serializer offset, not the runtime layout. |
| +0x32 | u16 | `ref_strength_rating` (aggregate REF power) | Eng=12599, Du=15153, Sp=4899, Fr=5154 |
| +0x4C..+0x5B | 16×u8 | `market_sensitivity` per good | js-dos doc; values 1..20 typical |
| +0x5C..+0x7B | 16×s16 | `market_pool` (supply/demand imbalance) | js-dos doc |
| +0x7C..+0xBB | 16×s32 | `market_traded_volume` (cumulative units) | js-dos doc |
| +0xBC..+0xFB | 16×s32 | `market_eu_supply` | js-dos doc |
| +0xFC..+0x13B | 16×s32 | `market_base_values` (initial state at game start) | js-dos doc |

### Goods order (all market arrays use this index)

`0=Food, 1=Sugar, 2=Tobacco, 3=Cotton, 4=Furs, 5=Lumber, 6=Ore,
7=Silver, 8=Horses, 9=Rum, 10=Cigars, 11=Cloth, 12=Coats,
13=Trade, 14=Tools, 15=Muskets`

### Conflict — REF location

The js-dos doc places REF (dragoons/regulars/artillery) at
`+0x44/+0x45/+0x46` of each PowerRecord. Runtime check: those bytes
read (1, 11, 62) for the player while the in-game UI shows (23 reg,
10 cav, 8 art, 5 mow). The standalone REF array at
**`DGROUP:0x53DA..0x53E1` (4 words)** matches the in-game UI exactly.
Treat 0x53DA as authoritative; treat the +0x44/+0x45/+0x46 PowerRecord
bytes as TBD (possibly a different counter, like garrison strength).

### Capital-raze popup buffer (ephemeral)

When a CIBOLA / Aztec-or-Inca capital raze popup is being prepared,
DGROUP region around `0x9CB0` holds the substitution values for the
@CASHTREASURE / @LOSTCITY2 message:
- `+0x9CB0` (u32): displayed gold amount (e.g. 10,000)
- `+0x9CB8` (u32): count
- `+0x9CBC` (u32): tribe map-marker palette color index (149..150
  for Aztec). **Correction 2026-05-04**: this was previously
  labelled "tribe base wealth" — it is actually the `@TRIBES`
  column-5 palette color (Aztec=149 = `#c7a220` gold/ochre, Inca=97
  = `#f7f3c7` cream). Not a gold-amount field.
- `+0x9CD2`: substituted tribe name string (e.g. "Aztec\0")

Verified 2026-05-04: only present in last 6 snapshots of
`session_1777955389` when the user razed the Aztec capital — value
10000 matched the in-game popup display.
| `0x84FC` | far ptr | king/payer record | SMITE + king tax |
| `0x8542` | far ptr | active colony record | many functions (102 refs per anchor_map) |
| `0x853A` | word | map_width | many functions |
| `0x853C` | word | map_height | many functions |
| `0x8904` | dword[N] | market price-state table (stride 79×4) | market function |
| `0x8CFC + N` | byte | per-power active-unit count | destroy_unit byte-trace |
| `0x8D4E` | far ptr | active TribeData record | `set_active_tribe` BYTE_VERIFIED |
| `0x8D50` | word | active tribe's power_idx | set_active_tribe |
| `0x8D52` | word | active tribe_idx (0..7) | set_active_tribe |
| `0x9298 + N` | byte | per-power active flag | colony burn |
| `0x940C + N` | byte | per-power stockpile | colony burn |
| `0x941C + N×2` | word | per-power factor (SMITE) | SMITE byte-trace |
| `0x942C + N` | byte | per-power factor (SMITE) | SMITE byte-trace |

---

## NativeSettlement table compaction (verified 2026-05-05)

When a native settlement is razed, the table gets COMPACTED — slot
0 always points to the FIRST currently-active settlement, not a
free slot. Verified by:

- Session_1777952458 end: NativeSettlement[0] = (38, 54) Inca
  capital
- Session_1777955389 end (after Inca razes): NativeSettlement[0]
  = (35, 66) Inca village (the (38,54) capital was razed and
  removed; subsequent slots shifted forward)

This means renderer code SHOULD walk the table from index 0 until
a (0, 0) byte pair is encountered (terminator), rather than
expecting fixed slots per tribe.

## ColonyRecord slot recycling (verified 2026-05-05)

ColonyRecord slots are reused when a colony is razed/abandoned.
Across session_1777952458:

- Snap 0 (turn 51): Slot 0x6202 = "San Salvador" (Spanish)
- Snap 395 (turn 58): Slot 0x6202 = "Roanoke" (English)

San Salvador was razed/captured between turns 51-58, and the
slot was reused for Roanoke (a new English colony founded by
the player). This explains why the same memory address can hold
different colony names across snapshots.

The active colony list always walks from the first slot
(0x5D46 = Jamestown) through allocated slots. Slot validity is
determined by checking the name field at +0x02 — empty/zero =
slot is free.

## "%" currency display

The in-game gold display uses `%` as a stylized currency symbol
(NOT a percentage). Game text "Gold: 19200%" actually displays
the in-memory dword 1920 (4 digits) followed by the % symbol.
The renderer should interpret `%` in displayed strings as a
currency-symbol postfix, not as a multiplier.

Verified: PowerRecord +0x2A = 1920 (snap 0) displayed as
"Gold: 19200%" (looks like 5-digit number but 4-digit value +
currency).

## AI FF bitmask caveat

PowerRecord +0x07 bitmask is reliable for the PLAYER nation
(matches actual acquisition). For AI nations, the bitmask may
not reflect real acquisitions but instead game-state flags.
Example: at the latest snap, both Spanish and Dutch had bit 8
(Henry Hudson) set in +0x07 — but only one nation can actually
acquire each FF, so this bit's meaning for AI is TBD.

For player UI rendering (Continental Congress display), use
PowerRecord[player_idx] +0x07 as ground truth. For AI nation
status displays, treat +0x07 as informational only.

## Save file structure (HALLFAME.DAT + game-save)

The `func_03ADA6` function writes HALLFAME.DAT (1,362 bytes detected,
larger). Game-save format TBD (find via `func_0749E0` SAVEAS code path).

---

## SoL → bells/turn formula (Task 096)

Sons of Liberty percentage per colony = `rebel_dividend / rebel_divisor`
(stored at ColonyRecord +0xC2 / +0xC6 as s32 each).

Both fields update each turn based on bells produced. Per pavelbel
schema and runtime observation:
- **rebel_dividend** = sum of "rebel-leaning" colonist contributions
- **rebel_divisor** = total colonist contributions (rebel + tory)
- Each Liberty Bell produced increases the dividend by +1
- Each Tory point produced increases the divisor by +1 (without
  changing the dividend), shifting the ratio toward Tory side

Per-nation bells/turn at `PowerRecord +0x0E` is the SUM of bell
output across all colonies for the player's nation. This is what
the Continental Congress display "Rebel Sentiment N%" sources from
(via PowerRecord +0x02 byte directly, which is computed from the
sum of (rebel_dividend / rebel_divisor) across player colonies × 100).

Plymouth at frame 1310196718:
- rebel_dividend=66, rebel_divisor=617 → 10.7% colony SoL
- bells_per_turn (nation-wide) = 7
- Plymouth contributes ~5 bells/turn (Carpenter's Shop + Statesman
  if present)

Verification: Across the session, Plymouth SoL grew (66/617 = 10.7%)
→ (93/724 = 12.8%). Same direction as nation-wide rebel_sentiment
(13% → 28%) but at a lower scale because Plymouth is just one of
several colonies aggregating into nation total.

## Foreign-colony trade With:/Ask: fields (Task 099)

When the player clicks on a foreign (AI-owned) colony to negotiate
trade, the right sidebar shows:
- **Locat**: (x, y) coordinates + a number (Task 035 candidate at
  ColonyRecord +0x20)
- **With:** = goods the foreign colony has available to SELL TO YOU
- **Ask:** = goods the foreign colony WANTS FROM YOU
- Ship list (Merchantman / Caravel etc.) docked at that colony
- "+ More +" link if there's overflow

Per pavelbel schema:
- ColonyRecord stockpile (+0x9A 16×u16) = what the colony HAS
- The "Ask:" list is computed at runtime from "what the colony
  needs but doesn't have" — likely a derived list, not stored
- Per-nation `last_bought` (NativeSettlement +0x08) and `last_sold`
  (+0x09) track recent trades; equivalent for foreign colonies
  may exist in their ColonyRecord (TBD which offset)

The trade-prices used in the foreign-colony dialog are derived
from the FOREIGN nation's market_price array (PowerRecord +0x4C
of that nation), modified by the diplomacy relation status.

## Food-boycott trigger (Task 040)

The Food boycott observed in the test game (PowerRecord +0x20 =
0x0001) was likely imposed by the King via a random-event handler.
Per GAME.TXT @SOMEBOYCOTT template, the King can declare a boycott
on any commodity in retaliation for player actions. The trigger
function is in the random-events code path:

- `viceroy_source/src/random_events/` (RECONSTRUCTED, not byte-verified)
- `func_03ECF0` (native diplomatic) and adjacent overlay functions
  handle event triggers

The boycott bit at PowerRecord +0x20 is SET by code that:
1. Picks a random commodity index (0..15)
2. Sets bit at that index in PowerRecord +0x20
3. Triggers @SOMEBOYCOTT popup

Boycott is LIFTED via:
- Player paying tribute (gold) to the King
- Boston Tea Party (NOT — actually triggers REBEL sentiment, but
  a non-player-controlled event may also clear specific boycotts)
- Successful Revolution (at which point the King doesn't matter)

Without specific game observations of the trigger event firing,
the exact byte that flips +0x20 cannot be byte-verified. This
task is **deferred**: needs in-game capture of a boycott-trigger
event with before/after memory snapshots.

## NAMES.TXT — the canonical data dictionary

40+ named sections loaded by `func_0749E0`. Lists in
[`viceroy_source/FUNCTION_INVENTORY.md`](../viceroy_source/FUNCTION_INVENTORY.md).
This is the authoritative source for ID-to-name mappings. NEVER
hardcode unit/terrain/FF names from disassembly — read NAMES.TXT.

---

## 2026-05-03 update — Dialog/popup state globals

These DGROUP globals control the popup-window geometry and dialog
context. All cited from byte-level analysis in
`code/VICEROY/disasm/func_067DC8_unknown.asm`:

| Global | Type | Purpose | Writer site (file offset) |
|--------|------|---------|----------------------------|
| `[0x174]` | word | cursor_x | 0x0765AC (`MOV [0x174], AX` short form) |
| `[0x176]` | word | cursor_y | 0x0765AF (`MOV [0x176], DX`) |
| `[0x186]` | word | dialog_state flag (>=0x64 enables popup) | TBD |
| `[0x1EA4]` | byte | char_width_cols (parsed from GAME.TXT @width) | 0x0684CC, 0x0684FC, 0x068507 |
| `[0x1EA5]` | byte | char_height_rows | 0x0684D7, 0x0684F9, 0x068504 |
| `[0xA5A4]` | word | font_cell_width | 0x068771 (`MOV [0xA5A4], CX`) |
| `[0xA5A6]` | word | font_cell_height | 0x06872C (`MOV [0xA5A6], AX`) |
| `[0x839E]` | word | dialog_rect.field0 (computed) | overlay 0x0C36:0x000A (TBD file offset) |
| `[0x83A0]` | word | dialog_rect.field1 (computed) | same setter |
| `[0x83A2]` | word | dialog_rect.field2 (cursor_x) | same setter |
| `[0x83A4]` | word | dialog_rect.field3 (cursor_y) | same setter |

The dialog rect is COMPUTED by `func_067DC8` (file
`0x067DC8..0x067E09`, BYTE_VERIFIED) using the formula:

```
rect.field0 = font_cell_width  + char_width_cols  - 8
rect.field1 = font_cell_height + char_height_rows - 0x0F
rect.field2 = cursor_x
rect.field3 = cursor_y
```

See `docs/DIALOG_GEOMETRY.md` for the complete data flow.

---

## 2026-05-04 update — RUNTIME-VERIFIED ColonyRecord layout

Source: `session-12/` DOSBox memory dumps (112 snapshots). DGROUP base
located at dump-offset 0x1CFE0 by anchoring on the WOODPANL string at
DS:0x2189. See `tools/analyze_session_mem.py` for the extractor.

ColonyRecord stride = **202 bytes (0xCA)** per record. Empirically
verified by 6 active colonies in the session at consecutive DGROUP
offsets (delta = 202 between each):

| DGROUP offset | Nation | Name (extracted from bytes 0x02..0x10) |
|--------------:|:------:|:---------------------------------------|
| 0x5D46 | England (0) | Jamestown |
| 0x5E10 | Spain (2)   | Quebec |
| 0x5EDA | Spain (2)   | Isabella |
| 0x5FA4 | Netherlands (3) | New Amsterdam |
| 0x606E | England (0) | Plymouth |
| 0x6138 | Spain (2)   | Santo Domingo |

### ColonyRecord field layout (verified)

| Offset | Size | Field | Notes |
|-------:|-----:|-------|-------|
| 0x00   | byte | map_x | Tile column (0..56 on AMER2.MP) |
| 0x01   | byte | map_y | Tile row (0..70) |
| 0x02..0x19 | 24 bytes | name | NUL-terminated colony name (max 23 chars per COLONY.TXT spec) |
| 0x1A   | byte | owner_nation | 0=England, 1=France, 2=Spain, 3=Netherlands |
| 0x1B   | byte | unknown | TBD |
| 0x20   | word | flags? | Observed value 0x1002 |
| 0x90   | word | field_a | Observed Jamestown=272 |
| 0x9A   | word | field_b | Observed 1 (read by func_02D658 line 02D6BB) |
| 0xC6   | word | field_c | Observed 193 (read by func_02D658 line 02D6C8) |

### Verification example

Jamestown (DGROUP+0x5D46, 102-byte slice from session-12 frame 1):

```
33 2A 4A 61 6D 65 73 74 6F 77 6E 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 ?? ?? ?? ?? ??
```

- `0x33 0x2A` = (51, 42) — Jamestown's tile coordinates on AMER2.MP
- bytes 2..10 = `Jamestown\0` — colony name
- byte 0x1A = 0 = England — confirmed in sidebar text "New England"

This validates the byte-level layout claim end-to-end.
