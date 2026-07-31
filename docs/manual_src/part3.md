## 8. Colonies

Every colony is a fixed-size 202-byte record in a single DGROUP array. The record
carries the colony's position, name, owner, population, profession roster,
constructed-building bitmask, warehouse stockpile, and the Sons-of-Liberty bell
pool; everything the colony screen draws is derived from it plus a handful of BSS
scratch tables rebuilt on screen entry. The most surprising subsystem — fully
byte-verified and replay-validated — is that the on-screen *placement* of the
colony's buildings among the 15 plots is produced by a deterministic RNG shuffle
seeded from the colony's map coordinates.

### 8.1 ColonyRecord

The colony table lives at `DS:0x5D46`, stride `0xCA` (202 bytes); the live count
is the word `[0x539E]`, capped at 48 (`cmp [0x539E],0x30` at 0x2EB82). The
currently-active colony is the **near pointer `[0x8542]`**, written by the
set-active-colony routine at 0x8302..0x830B (`imul bx,idx,0xCA; add bx,0x5D46;
mov [0x8542],bx`). Slots are recycled: a razed colony's slot is reused for the
next founded colony, and slot validity is determined by a non-empty name at
`+0x02`. Live-verified in the running game: `*[0x8542]` → a record decoding as
`(51,29) "Jamestown"`, exactly `0x5D46 + 4·0xCA`.

```c
typedef struct {                 // array DS:0x5D46, stride 0xCA; active = *[0x8542]
    uint8_t  map_x;              // +0x00: tile column (live-verified)
    uint8_t  map_y;              // +0x01: tile row
    char     name[24];           // +0x02..+0x19: NUL-terminated colony name
    uint8_t  owner;              // +0x1A: 0 English 1 French 2 Spanish 3 Dutch;
                                 //        <4 = European test at 0x830F
    uint8_t  status_1B;          // +0x1B: numeric prefix of the foreign-title
                                 //        builder (zero-padded append at 0x26915)
    uint8_t  flags_1C;           // +0x1C: bit flags — colony-marker population-number
                                 //        colour (0x00448B..0x0044A4) and
                                 //        centre-tile yield bits (0x00A32F/0x00A339)
    uint8_t  _pad1D[2];          // +0x1D..+0x1E unmapped (2 bytes)
    uint8_t  population;         // +0x1F: colonist count (burn-loot formula 0x05DE1E;
                                 //        plaza-row count 0x0270E6)
    uint16_t flags_20;           // +0x20: (measured; not byte-cited — observed 0x1002;
                                 //        foreign-colony marker byte in low half)
    uint16_t state_22;           // +0x22: (measured; not byte-cited)
    uint8_t  _pad24[0x1C];       // +0x24..+0x3F unmapped (28 bytes)
    uint8_t  professions[0x30];  // +0x40..: one @JOB byte per colonist
                                 //        (live length = population; context-help
                                 //        reads the +0x40 profession field at
                                 //        0x02BD90; bytes past the roster up to
                                 //        +0x6F are unmapped)
    uint8_t  tile_worker[8];     // +0x70..+0x77: colonist index working each
                                 //        surrounding tile, 0xFF = unworked
                                 //        (worked-slot test func_008956 reads
                                 //        +0x70+slot against the offset tables
                                 //        DS:0xC8/DS:0xDE)
    uint8_t  _pad78[0x0C];       // +0x78..+0x83 unmapped (12 bytes)
    uint8_t  buildings[6];       // +0x84..+0x89: 42-bit constructed mask, bit i =
                                 //        building id i (reader func_0860E:
                                 //        byte = rec+0x84+(id>>3), bit = id&7;
                                 //        setter func_092E0 at 0x9308;
                                 //        build-complete write at 0x02D19A)
    uint8_t  _pad8A[2];          // +0x8A..+0x8B unmapped
    uint8_t  title_num[4];       // +0x8C..+0x8F: four numeric fields appended by the
                                 //        foreign-owner title builder (0x26942)
    uint16_t field_90;           // +0x90: (measured; not byte-cited)
    uint8_t  _pad92[2];          // +0x92..+0x93 unmapped
    uint8_t  cargo_94;           // +0x94: cargo-holds datum read by the colony
                                 //        cargo panel (func_027746)
    uint8_t  warehouse_level;    // +0x95: Warehouse Expansion counter (building id
                                 //        0x10 has NO bit — it increments this)
    uint8_t  capitol_level;      // +0x96: Capitol Expansion counter (building id 0x1F)
    uint8_t  _pad97[3];          // +0x97..+0x99 unmapped
    uint16_t stockpile[16];      // +0x9A..+0xB9: warehouse quantity per good,
                                 //        @CARGO order (runtime-verified against the
                                 //        stockpile bar func_0281D6)
    uint16_t counter_BA;         // +0xBA: counter pair lo/hi (measured; not byte-cited)
    uint16_t counter_BC;         // +0xBC: (measured; not byte-cited)
    uint8_t  marker_frame;       // +0xBE: map-marker frame byte (marker painter
                                 //        func_004314 at 0x004385)
    uint8_t  _padBF[3];          // +0xBF..+0xC1 unmapped
    int32_t  sol_numerator;      // +0xC2: rebel bell pool (accumulated + clamped to
                                 //        the cap at 0x02DAC6..0x02DAD4)
    int32_t  sol_denominator;    // +0xC6: bell cap = decay + population·2
                                 //        (0x02DA1C..0x02DA6F); founding init
                                 //        +0xC6=100, +0xC2=0 at 0x02EC26
} ColonyRecord;                  // sizeof = 0xCA (202)
```

Sons of Liberty percent = `sol_numerator·100 / sol_denominator` (32-bit multiply
0x008557 + divide 0x00855E in `func_008524`; 0 if the denominator ≤ 0 at
0x008542), then +20 for a human-controlled colony (latch `add ax,0x14` at
0x00859F, gated on `owner<4`), clamped to 100 (0x0085A8..0x0085AD).

### 8.2 Building construction state and upgrade chains

The 42 building definitions of NAMES.TXT `@BUILDING` load into a stride-12
record table at `DS:0x8F82` (name pointer +0, prerequisite/predecessor +3,
chain successor +4, category byte at `0x8F87+id·12`, loaded at 0x74D2F). A
constructed building sets its bit in `ColonyRecord +0x84` (`func_092E0`,
`or [bx],al` at 0x9308) **without clearing the predecessor's bit** — upgrade
tiers coexist as bits and the highest tier present wins for render and
production (build-complete handler at 0x02D19A confirms: set only, no clear).
Two definitions have no bit at all: **Warehouse Expansion (id 0x10)** increments
the counter `+0x95` and **Capitol Expansion (id 0x1F)** increments `+0x96`.
School ids: Schoolhouse 0x0C, College 0x0D, University 0x0E.

Chain walking uses the `0x8F82` fields: prerequisite line shown when
`byte 0x8F82[id]+3 ≥ 0`; the upgrade-chain loop steps `next = byte 0x8F82[b]+4`
while ≥ 0 (Colonizopedia building/skill pages, 0x06A89C..0x06A947 and
0x06AD3C..0x06AD9F).

### 8.3 Worker/building byte tables

Two static DGROUP byte tables bind buildings to professions:

- **Building → job**: `DS:0x2CA` (file 0x1DC6A), 42 signed bytes, read through
  `func_009786` (`0x181F:0xACE`). Byte-verified entries: ids 3–5 → 0x0F Gunsmith,
  9–11 → 0x11 Statesman, 21–23 → 0x0B Weaver, 27–29 → 0x09 Distiller, 35–36 →
  0x0D Carpenter, 37–38 → 0x10 Preacher, 39–41 → 0x0E Blacksmith. Jobs 0x12
  (Teacher) and 0x15 are skipped by the pedia header renderer.
- **Job → building**: `DS:0x2F4` (file 0x1DC94), 19 signed bytes, read through
  `func_008D9C` (`0x181F:0xB00`). Jobs 0–8 (the nine outdoor field jobs) → −1
  (no workplace building); job 0x0D → 35 Carpenter's Shop, 0x0F → 3 Armory,
  0x11 → 9 Town Hall, etc.

### 8.4 Colony-screen building placement — the RNG layout algorithm

The colony view has **15 fixed plots** in the upper-left town area. Which
building occupies which plot is computed on every colony-screen paint by
`func_025D34`, a deterministic random shuffle. The whole chain is byte-verified
and was validated by exact replay: re-implementing the algorithm below
reproduces the live game's Jamestown layout with every sprite pixel-exact
(pixel-verified against the running game, 1994 binary under DOSBox).

**Plot position table** — static at `DS:0x266` (file 0x1DC06), 15 × (word x,
word y); the renderer draws at `(x, y+8)` (the +8 applied once, at 0x02708B —
applying it twice is a documented replay bug):

| plot | x | y (table) | y on screen | plot | x | y (table) | y on screen |
|-----:|----:|----:|----:|-----:|----:|----:|----:|
| 0 | 56 | 5 | 13 | 8 | 128 | 45 | 53 |
| 1 | 145 | 7 | 15 | 9 | 10 | 68 | 76 |
| 2 | 173 | 10 | 18 | 10 | 15 | 94 | 102 |
| 3 | 8 | 33 | 41 | 11 | 87 | 3 | 11 |
| 4 | 37 | 37 | 45 | 12 | 66 | 79 | 87 |
| 5 | 67 | 46 | 54 | 13 | 123 | 98 | 106 |
| 6 | 96 | 45 | 53 | 14 | 123 | 47 | 55 |

**Plot categories** — static counts `byte[0x224] = [7,4,2,1,1]` and bases
`byte[0x22A] = [0,7,11,13,14]` (file 0x1DBC4/0x1DBCA): category 0 = plots 0–6,
1 = plots 7–10, 2 = plots 11–12, 3 = plot 13, 4 = plot 14. The per-plot category
table `0x8D62` is rebuilt each open as `[0,0,0,0,0,0,0,1,1,1,1,2,2,3,4]`
(0x025D7B..0x025DB8).

**The RNG.** Three byte-verified pieces:

```text
seed:   func_009726 (0x181F:0xD62; sole caller func_025D34 @0x025D3A)
        seed32 = (colony_map_y << 8) + colony_map_x + dword[0x8D80]   @0x009736
        srand @0x103C2 keeps only the LOW 16 BITS of the seed:
        mov [0x28EE],ax ; mov word [0x28F0],0   -- effective seed space is 16-bit

rand:   @0x103D4 (MSC 6.0 LCG; bytes B8 FD 43 BA 03 00 ... 05 C3 9E / 83 D2 26)
        state = state·0x000343FD + 0x00269EC3    (32-bit, state at [0x28EE]/[0x28F0])
        return (state >> 16) & 0x7FFF

random_int(lo,hi):  func_00C322 (0x181F:0x4D4)
        r = rand(); return lo + ((r · (hi−lo+1)) >> 15)   @0x00C334
```

`[0x8D80]` is a **per-session dword** set at boot init: it read 0x2C55 in one
live session and 0x5B7C in a fresh boot (its writer is unlocated — runtime-open).
It is constant within a session, so a given colony always lays out the same way
during play; the pure map-position seed alone does *not* reproduce a layout
(exactly 2 of 65536 16-bit seeds reproduced the validated capture).

**Registration groups.** The building-definition registration block at 0x0746BC
issues 42 calls (one per id) through the far trampoline at 0x76384 →
`func_07464C`, assigning each id to one of **15 groups** — one screen slot per
group:

| group | ids | buildings | cat |
|---:|---|---|---:|
| 0 | 0–2 | Stockade / Fort / Fortress | 3 |
| 1 | 3–5 | Armory / Magazine / Arsenal | 1 |
| 2 | 6–8 | Docks / Drydock / Shipyard | 4 |
| 3 | 9–11, **30–31** | Town Hall ×3 + **Capitol / Capitol Expansion** | 2 |
| 4 | 12–14 | Schoolhouse / College / University | 1 |
| 5 | 15–17 | Warehouse / Warehouse Expansion / **Stable** | 1 |
| 6 | 18 | Custom House (alone) | 0 |
| 7 | 19–20 | Printing Press / Newspaper | 0 |
| 8 | 21–23 | Weaver's House / Weaver's Shop / Textile Mill | 0 |
| 9 | 24–26 | Tobacconist's House / Shop / Cigar Factory | 0 |
| 10 | 27–29 | Rum Distiller's House / Rum Distillery / Rum Factory | 0 |
| 11 | 32–34 | Fur Trader's House / Fur Trading Post / Fur Factory | 0 |
| 12 | 35–36 | Carpenter's Shop / Lumber Mill | 1 |
| 13 | 37–38 | Church / Cathedral | 2 |
| 14 | 39–41 | Blacksmith's House / Shop / Iron Works | 0 |

The **category** of a group is NAMES `@BUILDING` numeric **column 3** of its
first (representative) id, loaded to `0x8F87+id·12` at 0x74D2F. Over the 15
representatives the category histogram is exactly `[7,4,2,1,1]` — matching the
plot counts. (The histogram over all 42 defs is 19/10/7/3/3 and does NOT match;
an early decode tripped over that.) The group table is *not* `floor(id/3)`:
Capitol 30/31 shares group 3 with Town Hall, Stable 17 sits with Warehouse in
group 5, Custom House 18 is alone, and Fur Trader's House 32 opens group 11.

**Placement loop** (0x025DDB / 0x025DBF..0x025E07): after seeding, each of the
15 work-list slots (flattened category order: 7 cat-0 slots, 4 cat-1, 2 cat-2,
1 cat-3, 1 cat-4) picks a plot within its category block:

```text
plot = base[cat] + random_int(0, count[cat]−1)
if plot already taken (0x8E92[plot] ≥ 0): retry     -- draw again, same range
0x8E92[plot] = slot                                 -- plot → slot map
```

i.e. a random permutation within each static category block. Then the 42
building defs are each mapped to their group's slot (0x025E0E..0x025E5A), and
for every building the colony actually **has** — the present-gate query
`0x181F:0x9FC` per id at 0x025E64 — the plot's def table gets
`0x8E82[plot] = building id` (0x025E9F); unbuilt plots stay `0xFF`.
**Id 0 (Stockade) is force-included** regardless of the query (0x25E70), so
every colony renders something on the cat-3 plot. A later pass at 0x025E1A uses
the `0x8F88` chain/produced-good column to assign goods — it plays no part in
plot selection.

**Frame selection** (`func_026DD4`, 0x026DD4..0x026FF1): for an occupied plot
the BUILDING.SS frame is `def_id + 1` in EXE-sheet space (`mov ax,[bp+6]; inc ax`
at 0x026DE5..0x026DE9), blitted via `0x181F:0x254` at 0x026E4E. Overrides, all
byte-read: `def_id==0` with build-query(0)==0 ⇒ frame **0x11** (0x026DEC);
`def_id==0x0F` / `0x11` with garrison queries ⇒ frames **0x2F / 0x30**
(0x026E05..0x026E34). The Colonizopedia building page applies the same
`id 0x11 → frame 0x2F` override (0x06AB62). Empty plots (`def < 0`) are drawn by
`func_026FF2` with the terrain-decoration frame `byte[DS:0x260 + category]`
(table `[45,44,43,0,46]` — category 3 draws nothing), skipped when the byte is 0.
Live verification (Jamestown): 8 buildings at plots {2,3,4,5,6,10,12,13} with
def-ids {0x20,0x1B,0x27,0x18,0x15,0x23,0x09,0x00}, every frame pixel-exact.

## 9. Market and trade

The European market is per-power state inside the PowerRecord (stride 0x13C,
European powers at `DS:0x8808` + power·0x13C; active-power pointer `[0x84FC]`).
Prices are not a fixed table: the per-good base is random-seeded at game start
and then driven by a per-turn decay plus per-transaction updates, with the four
manufactured luxuries coupled through a shared supply pool.

### 9.1 Per-power money and market state

| field | type | meaning |
|---|---|---|
| `+0x01` | u8 | **tax rate** (0..100) — read at 0x031043 for the Europe banner; raised by King events |
| `+0x1E` | u16 | artillery-bought counter (Europe artillery price escalation: `cost = base + count·100`, read ×100 at 0x035124/0x03527B, `inc` at 0x035282, zeroed at new game 0x03662F) |
| `+0x20` | u16 | **boycott bitmask**, bit = good index. Test `func_030B38` (`(1<<good) & [bx+0x20]`); set at 0x34717 (Tea Party); back-tax lift at 0x3340C (`&= ~bit` after paying price×500 into the King fund `+0x22`); **Jakob Fugger** (Founding Father id 1) clears the whole word to 0 at 0x3BD45 |
| `+0x22` | s32 | King's REF fund (receives sale tax) |
| `+0x26` | s32 | sales tally (net proceeds accumulator) |
| `+0x2A` | u32 | **gold (treasury)** — every credit goes through the clamp helper at 0x8806: add s32, clamp to [0, 999999] |
| `+0x4C` | u8[16] | per-good **price level** (indexed by good; step-up `+=1` at 0x32272, step-down `−=1` clamp ≥0 at 0x3228D) |
| `+0x5C` | s16[16] | market pool (drift-only; never touched by the transaction path) |
| `+0x7C` | s32[16] | traded volume (cumulative value) |
| `+0xBC` | s32[16] | European supply per good |
| `+0xFC` | s32[16] | per-good trade accumulator (`@0x8904` in DGROUP terms) — summed by the drift function |

**Displayed bid/ask pair** (Europe price strip, 16-good loop 0x38D40..0x38E3B):
`sell = price_level[good] − 1` (accessor `func_030590`, clamp ≥ 0) and
`buy = CARGO_row[good].col1 + price_level[good]` (accessor `func_030566`,
`mov al,[bx-0x6900]` with bx=good·9 at 0x30575, `add ax,cx` at 0x30587). The
on-screen spread is therefore the per-good constant `@CARGO` column 1 + 1:
Food 1, Sugar 4, Tobacco 3, Cotton 2, Furs 4, Lumber 2, Ore 3, Silver 20,
Horses 2, Rum/Cigars/Cloth/Coats 11, Trade Goods 2, Tools 2, Muskets 3.

### 9.2 Goods — `@CARGO`

Good ids 0..15, in NAMES `@CARGO` order (all market arrays use this index):
0 Food, 1 Sugar, 2 Tobacco, 3 Cotton, 4 Furs, 5 Lumber, 6 Ore, 7 Silver,
8 Horses, 9 Rum, 10 Cigars, 11 Cloth, 12 Coats, 13 Trade Goods, 14 Tools,
15 Muskets. Four **extended ids 16..19** are name-only production tokens:
16 Hammers, 17 Crosses, 18 Liberty Bells, 19 Flags — never traded, used for
production display (icon remaps 0x0D→0x37, 0x10→0x39, 0x11→0x3F in the
Colonizopedia product strips). Commodity icons are ICONS frames `good + 0x17`
in EXE-sheet numbering.

### 9.3 Price drift

**Per-turn driver**: the end-of-turn processor `func_0755CC` invokes
`func_036574` at 0x0757B0; it zeroes the per-power accumulators (`+0x5C/+0x7C/
+0xBC/+0xFC` loop at 0x03670E) and runs a **4-power loop** calling the drift
function `func_0305A8` (via the JMP-FAR trampoline at 0x368BD) once per power.
**Per-transaction**: the SELL handler (`func_032914` at 0x32D99) and BUY handler
(`func_0324F2` at 0x32902) each call `drift(good, 0)` — a single-good re-drift
immediately after the trade.

The drift itself (`func_0305A8`, 0x0305A8..0x03064C):

```text
for good in 0..15:                        # @0x305B3
    acc = price_seed[good]                # word table DS:0x53EA (good·2)  @0x305B8
    for power in 0..3:                    # @0x305CE
        v = PowerRecord[power].accum_FC[good]   # @0x305D8
        if v < 0: v = 0                   # @0x305E0
        acc += v                          # 32-bit @0x305F0
    if driver-mode:                       # @0x305FF/0x30605
        price_seed[good] -= acc >> 8      # proportional decay @0x30618..0x30639
```

`price_seed[16]` at `DS:0x53EA` is **randomized at new-game init**:
`func_07561C` fills each entry with `random_int(600, 1000)` (0x75645, loop ×16)
— there is no fixed base-price table. Later phases of `func_0305A8` couple the
luxuries: `S_pair = supply[9]+supply[10]+supply[11]+supply[12]` (Rum, Cigars,
Cloth, Coats; 32-bit adds, clamp ≥ 1, at 0x030649), then for each finished good
`target[i] = (S_pair·3)/supply[i]` (×3 at 0x03074F, 32-bit divide at 0x030759);
the raw inputs 1..4 (Sugar/Tobacco/Cotton/Furs) use the same formula against
their own supply (Furs halved, +1 if year<1700 and +1 if year<1600, at
0x0307C9). Dumping one luxury lowers its own price and nudges the other three
up.

### 9.4 Buy/sell transactions

**SELL** (`func_032914`; args good, screen-idx, confirm):
`gross = price·qty` (0x3249F); tax split at 0x32A4A..0x32A78:
`tax = gross·tax_rate(+0x01)/100`, `net = gross − tax`; gold credit `+net`
through the [0,999999] clamp helper (0x32A82); King fund `+0x22 += tax`
(0x32A92); tally `+0x26 += net` (0x32A9C). **BUY** (six inline sites in the
purchase pages, e.g. Muskets qty 0x32 at 0x526A2, Horses at 0x52790, Tools qty
0x64 at 0x52866): affordability check then inline debit
`sub [bx+0x2A],ax; sbb [bx+0x2C],dx` — **buys are untaxed**.

Both paths call a mirror pair of accumulator updaters (good, qty):

| field | BUY `func_0322D0` | SELL `func_03234A` |
|---|---|---|
| EU supply `+0xBC` | `−= qty` @0x3231C | `+= qty` @0x323B4 |
| accumulator `+0xFC` | `−= qty` @0x32324 | `+= qty` @0x323BC |
| traded volume `+0x7C` | `−= price·qty` @0x32340 | `+= price·qty·(100−tax%)/100` @0x32402 |
| DGROUP pool `[bx−0x779C]` (4 × stride 0x9E) | `−= scaled_qty` ×4 @0x322FF | `+= scaled_qty` ×4 @0x32383 (4th power ×2/3) |

`scaled_qty = ((price_level−2)·16·qty)/100` (helper 0x32294); the `@CARGO`
"spread" column (field 4, `[bx-0x68FC]`) is a per-good left-shift exponent on
qty inside these updaters (`shl dx,cl` at 0x322EA/0x32360), not the display
spread.

On the Europe screen the market bar (0,179,320,21; 16 cells, pitch 0x13, icons
`good+0x17`, bid price centred at y=194) routes clicks to the sell handler,
which first tests the boycott bit and blocks with a message if set. Recruit
gold cost comes from the recruit-pool slot word at `DS:0x978C + slot·6 + 4`
(read 0x051E52/0x035114) — for Artillery (colonist type 0x0B) it escalates
`base + artillery_bought·100`.

## 10. The native economy

Each Indian settlement prices its trade through a single routine,
`func_048F34` (file 0x048F34..0x0495FF), which fills two 16-word DGROUP arrays
— `0x9E58[16]` per-good **demand** and `0x9E78[16]` per-good **supply**, in
`@CARGO` order — for the active settlement. It runs in three phases and its
outputs feed the village trade dialog, the food beg/gift events, and the haggle
price. The routine also contains the cheat-menu "Supply and Demand (Indians)"
debug dump, gated on debug bit `[0x894] & 4`.

Inputs: the active NativeSettlement record (pointer `[0x8D4A]` family; `+0x03`
flags bit 4 = capital, `+0x04` population) and the active TribeData record
(pointer `[0x8D4E]`; `+0x02` = tribe tier). `N = population + 1` (0x049242),
`tier = tribe[+2]`.

### 10.1 Phase A — colony-claimed-tile mask (0x048F3C..0x049049)

A 25-byte mask marks which tiles of the settlement's 5×5 neighbourhood are
worked by a European colony (those tiles contribute nothing). For each colony
0..`[0x539E]` (selected via `0x181F:0x9E6` → `[0x8542]` at 0x04903A), each
settlement-relative cell (a,b) is mapped to colony-relative coordinates
(0x048F92..0x048FBA); if within the colony's 5×5 (0x048FCC..0x048FE2) the
centre (2,2) is special-cased (0x048FE4) and otherwise the worked-slot test
`func_008956` (`0x181F:0xCE0`, reading `ColonyRecord+0x70+slot`) decides;
matches set `mask[a·5+b] = 1` (0x049002). **Original bug (byte fact)**: the
in-bounds call at 0x048FC0 passes *relative* coordinates (x′−2, y′−2) to
`func_005BFA`, which tests **absolute** bounds `1 ≤ x < map_w−1` — Phase B
passes absolute coordinates correctly (0x04913D).

### 10.2 Phase B — 5×5 terrain point scan (0x04904A..0x049241)

Terrain id per tile via `0x181F:0x78C`. Contributions accumulated per tile:

| terrain | contribution | site |
|---|---|---|
| Mountains (27) | mountains counter +1 | 0x049190 |
| Hills (28) | hills counter +1 | 0x049199 |
| Arctic (24) | cold +4 | 0x0491A2 |
| Forested 8..23 | food/game point; base = t−8 (or t−16); base<3 ⇒ cold-forest counter, else warm-forest: sugar/tobacco/cotton +2 | 0x0491AB..0x04921F |
| Savannah | sugar +4 | 0x04909F |
| Swamp | sugar +2 | 0x0490A5 |
| Grassland | tobacco +4 | 0x0490AF |
| Marsh | tobacco +2 | 0x0490B9 |
| Prairie | cotton +4 | 0x0490C3 |
| Tundra | ore +2 | 0x0490CD |
| Plains | cotton +1, food +2 | 0x0490D7 |
| Ocean (25) / Sea Lane (26) | fish rate points; every 3 pts ⇒ food +2 | 0x049066..0x049090 |

### 10.3 Phase C — supply/demand arrays (0x049242..0x0495DC)

Both arrays zeroed at 0x049259..0x04926F, then per good (formulas exactly as
decoded; where the manual gives only a site, the term exists but its algebra
was not transcribed):

| good | supply | demand |
|---|---|---|
| Food | `+= (tier+N)·food_pts/(7−tier)` @0x049271 | `4·N²`, halved if tier ≥ 2 @0x04928F..0x0492A7 |
| Silver | `tribe[+0xC]/K + 4·mountains` (K = per-tribe byte `[0x962A+idx]`) @0x0492B8..0x0492F0 | — |
| Ore | `2·hills + mountains + tundra` (tier ≥ 1) @0x0492F4..0x04930B | — |
| Furs | `(2·coldforest + otherforest/2)/(tier+1)` @0x04930F..0x049328 | — |
| Coats/Tobacco/Sugar/Cotton/Cloth | supply terms @0x04932C..0x049386 | — |
| Tobacco | — | `(6−tier)·N + 2·cold + 5` @0x04938F |
| Cigars | — | term @0x0493A5 |
| Coats | — | `8·cold + furs` @0x0493B5 |
| Rum | — | term @0x0493C2 |
| Trade Goods | — | `(tier+2)·(N+3) + 8` @0x0493D5 |
| Tools | — | `(tier·N) << (cold/2 + 1)` @0x0493EA |
| Muskets | supply = 0 @0x049434 | `4·(7 − tribe[+7] − tier)` @0x0493FC |
| Horses | `tribe[+0xA] / ([0x962A+idx]/2 + 1)` @0x04940D | `4·(9 − tribe[+8] − tier)` @0x049423 |

Then, in order:

1. **Demand clamp to [0, 50]** (0x32) via the clamp helper `0x181F:0x35C`
   (0x04943E..0x049460).
2. **Capital boost** (settlement flags `+0x03 & 4`, 0x049462..0x0494B5):
   demand[0..7] ×2, demand[13..15] ×1.5, supply[7..15] ×2.
3. **Tribe stock adjustment**: per-good tribe stock `tribe[+0xE+2g]` folded into
   both arrays (0x0494C0..0x0494D6 / 0x0495B9..0x0495D6).
4. **Mutual discount**: `supply −= demand/2; demand −= supply/2`, each floored
   at ≥ 1 (0x049537..0x049591). The debug dump sits between the two halves.

### 10.4 Consumers

- **Village trade** (`func_04A7CA`): zeroes last-bought goods
  (0x04A8C1..0x04A8F0), index-sorts the arrays (`0x191F:0xED0` at 0x04A8F7) and
  names the top goods in the "especially interested in …" line
  (0x04A91D/0x04A932).
- **Food events** (`func_056C3E`, the mission-village event handler and the sole
  caller of `func_048F34`, at 0x057093): a food *deficit*
  `demand[0]−supply[0]` gates the **INDIANBEGFOOD** popup (key pushed at
  0x05716F); a surplus `supply[0]>demand[0]` gates **INDIANGIVEFOOD** (0x0573EB).
- **Haggle price** (`func_049600`): subtracts `supply[idx]·4` in the price
  computation (0x04A07A).

## 11. Trade routes

Trade routes are a small fixed array of 12 records, each holding a name, a
sea/land type and up to four stops; each stop packs its destination and up to
six load and six unload cargo types into nibbles. Units are attached to a route
through two nibbles of their class byte, and the per-turn executor walks the
stops under order code 2.

```c
typedef struct {                 // stride 0x0A
    uint16_t dest;               // +0x00: colony index; 0x3E7 (999) = Europe
    uint8_t  counts;             // +0x02: lo nibble = unload count, hi nibble = load
                                 //        count (max 6 each)
    uint8_t  load_nib[3];        // +0x03..+0x05: load cargo ids, nibble-packed
    uint8_t  unload_nib[3];      // +0x06..+0x08: unload cargo ids, nibble-packed
    uint8_t  pad;                // +0x09: unmapped (save-file diff pending)
} StopRecord;                    // nibble get/set func_0603DA / func_06040A

typedef struct {                 // stride 0x4A; max 12 routes; count word [0x53A0]
    char       name[0x20];       // +0x00
    uint8_t    type;             // +0x20: 1 = sea, 0 = land
    uint8_t    stop_count;       // +0x21: max 4
    StopRecord stops[4];         // +0x22..+0x49
} RouteRecord;                   // selected route: [0x9E14] = route·0x4A, seg [0x9E16]
                                 //   (func_05FE60)
```

- **Commands**: menu ids 0x50 Edit / 0x51 Create / 0x52 Delete (MENU.TXT
  `@TRADE` row order) → `func_060FBC` / `func_0610B0` / `func_0612E6`
  (0x0238F2/0x0238EA/0x0238FC). Creating past 12 routes posts `@TRADEMANY`
  (cap check 0x0610B5).
- **Unit linkage**: unit byte `+0x17` (absolute 0x315B) — **low nibble = route
  id, high nibble = stop index** (accessors `0x181F:0x858/0x862/0x876/0x8B2`);
  the unit's order code is 2 ("Trade Route").
- **Assign** ("Begin Trade Route", `func_022D46`): `@TRADENONE` if no routes
  exist; the route menu is filtered sea-only for ships / land-only otherwise
  (`@TRADENONE2` if the filter empties); sets order 2 and steps immediately.
- **Create flow**: cap check → pick destination 1 → coastal test
  (`0x181F:0xD12`) → `@TRADETYPE` sea/land choice (or forced land) → default
  name = colony name + random `@TRADENAMES` word (collision appends " A") →
  `@TRADENAME` entry (max 0x1F chars) → stop count preset 2 → pick destination
  2 (cancel aborts before `inc [0x53A0]`) → editor. The editor creates a
  phantom probe unit at (0xFF,0xFF) to filter reachable destinations, deleted
  on exit (0x0610A0). Delete compacts the array (`rep movsw` 0x25 words) and
  decrements higher route ids on all linked units.
- **Execution**: the per-turn executor for order 2 is `func_041080` (dispatcher
  jump table at file 0x24A38). A route with only one stop posts **@ROUTELOOP**
  (0x0413F7), verbatim:

```text
Your Excellency, our "{%STRING0}" trade route
has only one port on its itinerary!
```

## 12. Units

Up to 300 units live in a single 28-byte-stride array. A unit is its type (a
row of the NAMES `@UNIT` table), an owner nibble, a position, an order code,
cargo nibbles and a handful of per-turn scratch fields; the type indexes a
14-byte runtime stat table loaded from `@UNIT` at boot.

### 12.1 UnitRecord

Base `DS:0x3144`, stride 0x1C. (Field addresses below are absolute DGROUP; the
record-relative offset is the low nibble progression from +0x00.)

```c
typedef struct {                 // array DS:0x3144, stride 0x1C, 300 max
    uint8_t map_x;               // +0x00 (0x3144): renderer @0x03A63, placer @0x06958
    uint8_t map_y;               // +0x01 (0x3145)
    uint8_t unit_type;           // +0x02 (0x3146): @UNIT row 0..22; 694 refs
    uint8_t owner;               // +0x03 (0x3147): low nibble = power 0..11
                                 //        (set_unit_owner @0x738E); high nibble state
    uint8_t flags;               // +0x04 (0x3148): transient bit register — 0x80
                                 //        draw-active / "Damaged" display pair
                                 //        (set @0x069923, cleared @0x069942; combat
                                 //        @ARTILLERY sets it @0x05B6F6); 0x40 ship-
                                 //        carrying-cargo (@0x02F37A); 0x20 Merchantman
                                 //        tag; 0x10 long-path; 0x08 tile-dirty;
                                 //        0x04 ship-cargo; 0x02 was-fortifying
    uint8_t moves_spent;         // +0x05 (0x3149): move credits spent this turn
                                 //        (reset @0x005872; +3/step @0x05CAE2)
    uint8_t timer;               // +0x06 (0x314A): countdown (init 0xFF, dec)
    uint8_t ai_state;            // +0x07 (0x314B): persistent AI state letter
                                 //        ('X','-','0','1','G','E','R',...)
    uint8_t order;               // +0x08 (0x314C): order code 0..0x0C (dispatchers
                                 //        @0x249CB / @0x51DCE)
    uint8_t goto_x;              // +0x09 (0x314D): Go-To target / route next stop
    uint8_t goto_y;              // +0x0A (0x314E): (writer @0x22D38)
    uint8_t heading;             // +0x0B (0x314F): 8-way facing 0..7, 8 = none
                                 //        (reverse test xor al,4 @0x047AA8)
    uint8_t cargo_count;         // +0x0C (0x3150): goods in hold (@0x0B2AB)
    uint8_t cargo_ids[3];        // +0x0D..+0x0F (0x3151..0x3153): nibble-packed
                                 //        good ids, 2 per byte, up to 6 (@0x0B2CB)
    uint8_t cargo_qty[2];        // +0x10..+0x11 (0x3154..0x3155): per-slot
                                 //        quantities (@0x0B2FB)
    uint16_t timer_16;           // +0x12 (0x3156): overloaded — natives: snapshot of
                                 //        progress counter [0x538E] (@0x06DB3);
                                 //        player units: byte 0xFF sentinel → random
                                 //        0..0x13 on first use (@0x50C75)
    uint8_t turn_flag;           // +0x14 (0x3158): per-turn land-unit boolean
                                 //        (cleared @0x04968D; read for Wagon Trains
                                 //        @0x0507E1; exact label runtime-open)
    uint8_t tools;               // +0x15 (0x3159): pioneer tools 0..100
                                 //        (−20 per action @0x4060F)
    uint8_t work_counter;        // +0x16 (0x315A): turns-in-activity
                                 //        (clear/plow/road/fortify @0x04071D)
    uint8_t profession;          // +0x17 (0x315B): colonist profession 0x13..0x1C;
                                 //        for routed units: lo nibble = route id,
                                 //        hi nibble = stop index
    uint16_t occ_back;           // +0x18 (0x315C): per-tile occupancy back link
    uint16_t occ_next;           // +0x1A (0x315E): next link (placer @0x06968/@0x06976)
} UnitRecord;                    // sizeof = 0x1C (28)
```

### 12.2 The `@UNIT` stat table

The loader at 0x074EC3 parses the 23 `@UNIT` rows into a runtime table at
`DS:0x5230`, stride 14: +0 name ptr, +2 icon, **+4 moves stored ×3**
(`shl al,1 / add al,cl` at 0x074F04; road cost = 1/3), **+5 combat (defense)**,
**+6 attack**, +7 cargo holds, +8 move class (99 = naval), +9 hull, +0x0A size,
**+0x0B guns**, **+0x0C ai-value** (the ship-combat pair), +0x0D flags. Values
verbatim from NAMES.TXT:

| id | unit | icon | mv | atk | cmb | crg | cls | hull | size | guns | ai | flags |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | Colonists | 101 | 1 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 01000000 |
| 1 | Soldiers | 103 | 1 | 2 | 2 | 0 | 1 | 2 | 0 | 0 | 0 | 00011100 |
| 2 | Pioneers | 102 | 1 | 0 | 1 | 0 | 1 | 2 | 0 | 0 | 0 | 01000000 |
| 3 | Missionaries | 106 | 2 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 00100000 |
| 4 | Dragoons | 105 | 4 | 3 | 3 | 0 | 1 | 3 | 0 | 0 | 0 | 00111100 |
| 5 | Scouts | 104 | 4 | 1 | 1 | 0 | 1 | 2 | 0 | 0 | 0 | 01100100 |
| 6 | Regulars | 126 | 1 | 5 | 5 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 7 | Cont. Cav. | 130 | 4 | 5 | 5 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 8 | Cavalry | 127 | 4 | 6 | 6 | 0 | 1 | 4 | 0 | 0 | 0 | 00011100 |
| 9 | Cont. Army | 129 | 1 | 4 | 4 | 0 | 1 | 3 | 0 | 0 | 0 | 00011100 |
| 10 | Treasure | 17 | 1 | 0 | 0 | 0 | 6 | 4 | 0 | 0 | 0 | 00000000 |
| 11 | Artillery | 10 | 1 | 7 | 5 | 0 | 1 | 6 | 4 | 0 | 0 | 00011000 |
| 12 | Wagon Train | 9 | 2 | 0 | 1 | 2 | 99 | 1 | 0 | 0 | 0 | 00000000 |
| 13 | Caravel | 6 | 4 | 0 | 2 | 2 | 99 | 4 | 4 | 0 | 4 | 10100010 |
| 14 | Merchantman | 7 | 5 | 0 | 6 | 4 | 99 | 6 | 8 | 1 | 8 | 10000010 |
| 15 | Galleon | 8 | 6 | 0 | 10 | 6 | 99 | 10 | 10 | 4 | 20 | 10000010 |
| 16 | Privateer | 15 | 8 | 8 | 8 | 2 | 99 | 8 | 12 | 4 | 12 | 00000001 |
| 17 | Frigate | 16 | 6 | 16 | 16 | 4 | 99 | 16 | 20 | 12 | 32 | 10000001 |
| 18 | Man-O-War | 128 | 5 | 24 | 24 | 6 | 99 | 32 | 90 | 32 | 64 | 10000001 |
| 19 | Braves | 110 | 1 | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 00111000 |
| 20 | Armed Braves | 111 | 1 | 2 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 00111000 |
| 21 | Mtd. Braves | 112 | 4 | 2 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 00111000 |
| 22 | Mtd. Warriors | 113 | 4 | 3 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 00111000 |

**Ship types are 0x0D..0x12** (13 Caravel .. 18 Man-O-War) — this range gates
ship logic everywhere (pathfinder, combat, docks). The Artillery "Damaged"
display pair is attack +2 / damaged −2 (delta = col atk − col cmb, 0x069B39).

### 12.3 Professions — `@JOB`

28 rows (id, base name, expert form, tier = minimum school level 1=Schoolhouse /
2=College / 3=University / 4=not school-taught, and the expert's gold value):
0 Farmer (Expert Farmers, 1, 1100), 1–3 Sugar/Tobacco/Cotton Planter (Master
…, 2, −1), 4 Fur Trapper (1, −1), 5 Lumberjack (1, 700), 6 Ore Miner (1, 600),
7 Silver Miner (1, 900), 8 Fisherman (1, 1000), 9 Distiller (2, 1100),
10 Tobacconist (2, 1200), 11 Weaver (2, 1300), 12 Fur Trader (2, 950),
13 Carpenter (1, 1000), 14 Blacksmith (2, 1050), 15 Gunsmith (2, 850),
16 Preacher (Firebrand, 3, 1500), 17 Statesman (Elder, 3, 1900), 0x12 Teacher
(4, −1), 0x13 Colonist (Free Colonists, 4, −1), 0x14 Pioneer (Hardy, 1, 1200),
0x15 Soldier (Veteran, 2, 2000), 0x16 Scout (Seasoned, 1, −1), 0x17 Dragoon
(Veteran, 2, −1), 0x18 Missionary (Jesuit, 3, 1400), and the specials
**0x19 Ind. Servant, 0x1A Criminal, 0x1B Convert** (all tier 4, −1) plus the
pseudo-profession **0x1C** used as a display variant and remapped to 0x13 by
the context-help dispatcher (0x02BD83). The runtime job table is `DS:0x8EA2`,
stride 8 (+0 name, +2 expert plural).

**Unit-type → expert-job table** at `DS:0x30E` (file 0x1DCAE), bytes
`13 15 14 18 17 16` (hex): type 0 Colonists → 0x13 Colonist, 1 Soldiers →
0x15 (Veteran Soldiers), 2 Pioneers → 0x14 (Hardy Pioneers), 3 Missionaries →
0x18 (Jesuit Missionaries), 4 Dragoons → 0x17 (Veteran Dragoons), 5 Scouts →
0x16 (Seasoned Scouts).

### 12.4 Orders

Order codes live at `UnitRecord +0x08` (0x314C); the per-turn dispatcher at
0x249CB jump-tables codes 2..9 (table at file 0x24A38). The `@ORDERS` section
carries 13 rows of `name, key-letter`; the accelerator/status-letter array is
built into `DS:0x54DE` (writer 0x074F96) and read as the on-map status glyph
indexed by the order code (0x0391D) — the letters are exactly
`- S T G L F F B P R - - -`:

| code | order | key | init write | per-turn executor |
|---:|---|:-:|---|---|
| 0 | No Orders | `-` | @0x21ED7 | — (auto-activate) |
| 1 | Sentry | `S` | @0x21FEB | — (skip) |
| 2 | Trade Route | `T` | @0x22E05 | func_041080 |
| 3 | Go To | `G` | @0x22D2D | func_040E22 |
| 4 | Live In Village | `L` | no store site exists (menu row only) | passive |
| 5 | Fortify | `F` | @0x22105 | func_04101C → writes code 6 @0x41024 |
| 6 | Fortified | `F` | @0x41024 | passive (+50% defense) |
| 7 | Build Colony | `B` | @0x2279E | func_040C1E |
| 8 | Clear/Plow | `P` | @0x22324 | func_040656 |
| 9 | Build Road | `R` | @0x2250E | func_0409D6 |
| 0xA–0xC | No Orders (AI reserved) | `-` | AI-only | AI |

Status-glyph overrides (renderer at 0x0386A): ships not owned by the viewer
show their cargo count as an ASCII digit (`+0x30` at 0x0393F); 'X' when hidden;
the AI state letter `+0x07` for AI units, replaced by 'E' when ≥ 0x80.

## 13. Movement and pathfinding

Terrain movement cost is data-driven: the `@TERRAIN` `Movement` column is
loaded to `terrain·16 + 0x2F76` and charged as `Movement·3` against a budget
stored ×3, so a road (cost 1/3) costs exactly one stored point. Short-range
pathfinding is a bounded 16×16-window BFS with a cost cache, decoded in full
below together with its three debug overlays.

### 13.1 The short-range path-step finder — `func_061F02` (file 0x061F02)

Register args: `ax` = target_x, `dx` = target_y, `bx` = cost bound; returns
`ax` = best direction 0..7 *at the target toward the path start*, −1 on failure
(init at 0x06205A).

- **Window**: start tile = (`[0xA14E]`,`[0xA14C]`); window origin = start − 8
  (0x061F2F/0x061F38); 16×16 tiles.
- **Cost cache**: 256 bytes at `DS:0xA270`, memset at 0x061FBA..0x061FC7; BFS
  queues x at `DS:0xA372` / y at `DS:0xA472`, write/read indices
  `[0x2D16]/[0x2D18]`, capacity 0xE1 (0x062055). The cache is reused when the
  origin (`[0x2D1A]/[0x2D1C]`) is unchanged (0x061F83..0x061FA9).
- **Neighbour tables** (file 0x1DA54/0x1DA5E): `DS:0xB4` dx =
  {0,1,1,1,0,−1,−1,−1}, `DS:0xBE` dy = {−1,−1,0,1,1,1,0,−1} — directions 0..7 =
  N, NE, E, SE, S, SW, W, NW (applied 0x06210D/0x06211B).
- **Ship gating**: moving unit type `[0x1DD2]` in 13..18 (0x061F41/0x061F48) =
  the ship range; tile is water iff terrain id == 0x19 (25 Ocean) or 0x1A
  (26 Sea Lane) (0x062174..0x06217C); land/water mismatch allowed only at the
  endpoints (0x0621BE..0x0621E5); water-water extra checks via the helpers at
  0x06219D/0x0621AF.
- **One-move units**: if the type's stored moves ≤ 3 (`byte[0x5234+type·14] ≤ 3`
  at 0x061F6B) every step costs a flat 3 (0x0622F4).
- **Step costs** (in priority order): road/plow layer mask 0x0A at both ends →
  **+1** (0x0622A7..0x0622C0); river bit 0x40 on a cardinal step → **+1**
  (0x0622CC..0x0622EC); otherwise **terrain Movement ×3** —
  `byte[terrain·16+0x2F76]·3` (0x062300..0x06230C). NAMES values: open land 1,
  forests 2, Hills 2, Arctic 2, Mountains 3, Ocean/Sea Lane 1.
- **Occupancy/power rules**: occupying power at the tile must be −1 or the
  moving power `[0x1DD6]` (0x062217); a second ownership probe rejects
  power ≥ 4 (0x062245) and AI-controlled powers, else adds +8 (0x06225E);
  native units (type ≥ 19, 0x0621E8) reject rumor tiles (0x0621F5).
- **Phase 2**: picks the minimum-cost neighbour of the target (cost init 99 =
  0x63 at 0x06206B), **tie-break by distance** (`func_00493C` at 0x06259F),
  pruned against the bound `[0xA370]` (0x06202C/0x062062).

### 13.2 The movement debug overlays

Three of the seven DEBUG.TXT `@OPTIONS` bits in the cheat bitfield `[0x894]`
(builder `func_02356C`, exactly 7 checkbox items) are movement overlays:
**bit 0x10 "Close Moves"** (gate at 0x061F14), **bit 0x20 "Far Moves"**
(sibling `func_06295E`, 0x062975, format `"Far: %d(%d,%d)…"`), **bit 0x40
"All Movement"** (`func_062D84`, 0x062D94, sets the latch `[0x1DF2]` that
Close Moves honours). The Close-Moves overlay draws over the live map view
(full redraw via `0x181F:0xE1C(1)`):

- **Per-tile cost numbers**: for each nonzero cache cell, `func_078068`
  prints the cost in white (0x0F): px = `(x+[0x832A]−[0x8328])·[0x5AD4]`,
  py = `(y+[0x832C]−[0x832E])·[0x8326]+8`, nudged `+7>>zoom, +6>>zoom` with
  zoom = `[0x184]` (0x078081..0x0780E3); at zoom 0 a backing rectangle is drawn
  behind the digits (0x07810C).
- **Summary line**: format `"(%d,%d)-(%d,%d) %d == %d"` (DS:0x1DD8, file
  0x1F778) filled with start x/y, target x/y, bound, best direction; colour 12
  (red); drawn at **(5,190)** directly to the 320×200 VGA surface
  (0x062683..0x0626B1).
- **Keys**: 'Z' zoom in (`[0x184]−−`, clamp ≥0), 'X' zoom out (clamp ≤3), each
  redraws; ESC clears the latches and exits; any other key exits
  (0x0626D0..0x062705).

### 13.3 Go-To orders

Order code 3 with the destination at `UnitRecord +0x09/+0x0A` (writer
0x22D38/0x22D2D); per-turn executor `func_040E22`. The destination is chosen
with the shared picker (`func_060026` / `func_022CDC`): headers `@SAILPORT`
(ship) / `@TRAVELPLACE` (land unit); rows are eligible own colonies filtered by
water/land region match, plus a Europe row for ships only (choosing Europe
issues set-sail); pages of 10 with "(More)".

## 14. Combat

Combat resolves one attack with a single roll over modified strengths. The base
strength comes from the unit stat table; a chain of byte-cited multipliers
(veterancy, terrain, colony, fatigue, difficulty, Sons of Liberty) modifies it;
the optional Combat Analysis dialog itemizes exactly those modifiers before the
result is applied.

### 14.1 Base strength — `func_007C2A`

The root strength calculator writes the per-side base at `[col·2+0x8D06]`
(0x007CA5): `base = stat_table[type·14 + 0x5235]` (the +5 combat column);
**carriers add the +6 attack column** (`+0x5236`); a **damaged ship**
(flag bit) takes **−2**. Modifier-flag words per side: primary
`F = [col·2+0x8D00]`, secondary `S = [col·2+0xA156]` (cleared at 0x05CB3A);
producers include Veteran at 0x007CD6, Drake at 0x007CF0/0x007D09, Fatigue
(`[0x8D01]|=1`) at 0x05CB9B, Bombard (`[0x8D01]|=0x80`) at 0x05CF7D.

### 14.2 The Combat Analysis modifier table

The dialog (see §14.4) renders one row per set flag bit; the same bits drive
the strength math. Complete row table (labels are LABELS.TXT `@MISC` lines):

| flag | row label | effect |
|---|---|---|
| F&0x200 | unit shown under its veteran-profession name | base strength |
| F&0x400 | Muskets (good 15 name + icon 0x26) | "+1" (value semantics unresolved, @0x05EBDA) |
| F&2 | Veteran (types 1/4, profession 0x15) | +50% |
| F&4 | Cargo | −12.5% per used hold (cargo·100/8, @0x05ED65) |
| F&0x100 / S&8 | Fatigue | −33% / −66% |
| F&1 | Attack Bonus | +50% |
| F&0x8000 | Bombard | +50% |
| S&2 | Tory Unrest | −(100 − SoL%) |
| S&4 | Rebel Unrest | +SoL% (SoL from `func_008524`, `0x181F:0xC86`) |
| F&0x80 | Ambush (attacker) / Terrain (defender) — draws the target tile | +terrain_defense·25% (row skipped if 0) |
| F&0x40 | Colony | +(fort_level+1)·50% (`0x181F:0x9D2`) |
| F&8 (+0x10/+0x20) | colony-structure row (building name, table DS:0x9634) | +n·50%, n = 1/2, doubled by F&0x20 |
| F&0x800 (S-side) | Artillery In Open | −75% |
| S&1 | Artillery Vs. Raid | +100% |
| F&0x2000 | Fortified | +50% |
| F&0x1000 | Spain Bonus | +50% |
| F&0x4000 | Drake (privateers, Founding Father 13 owned) | +50% |
| `[0x5383]&0x20` (cheat) | extra rows: final strengths + the raw roll vs att+def | — |

Terrain defense values are the `$TERRAIN` "Defensive" column (byte-verified):
open land 0, Marsh/Swamp 1, forests 2 (Rain 3), Hills 4, Mountains 6. The
defense-bonus filler `func_007D3E` accumulates into `[0x8D04]`: colony +2
(0x7D8D), fortified building (level ≥ 2) +4 with a doubling condition
(0x7DBC/0x7DD1), river/road +(n+1)·2 (0x7E12), open terrain + the per-terrain
byte at `terrain·16+0x2F77` (0x7E63).

### 14.3 The strength chain and the roll — `func_05CA7E`

Attacker strength `[bp-0x90]` (defender `[bp-0xA6]`) is built from the stat
columns and modified, in order:

1. terrain/fort bonus: `strength·([0x8D04]+4)/4 · 3/2` (0x05CE05, `·3/2` chain
   at 0x05CE16);
2. **difficulty handicap**: a human-controlled combatant gets
   `strength += (4 − difficulty)` on **both** sides (attacker 0x5CE35, defender
   0x5CE54; +4 at Discoverer down to +0 at Viceroy);
3. generic terrain multiplier `·[bp-0x96]/3` (0x05CE69);
4. colony present on the defending tile → +50%, flag `[0x8D01]|0x10`
   (0x05CF43);
5. War-of-Independence bombardment (endgame flag `[0x5382]&1`, REF defender) →
   +50%, flag `[0x8D01]|0x80` (0x05CF7D);
6. Sons-of-Liberty scaling `strength·SoL%/100` (0x05CF98);
7. difficulty scaling `strength·difficulty/20` (0x05CFFC);
8. a further strength **doubling at 0x05D0D9 gated on the difficulty byte
   `[0x53A6]`** — its exact condition is an open item (runtime).

Fatigue is offered *before* the roll via GAME.TXT `@HALF` — attacking with
tired troops fights at reduced strength (the −33%/−66% rows above); text
verbatim:

```text
Your Excellency, these men are tired.  If we force
them to attack this turn, they will fight at {%NUMBER0/3
strength}.

"Charge!"
"Then let them rest."
```

**The roll** (act mode): `roll = random_int(1, ATK+DEF)` via `func_00C322`
(`0x181F:0x4D4`) at 0x05D188; **the attacker wins iff `roll ≤ ATK`**
(`cmp roll,[bp-0x90]; jg` ⇒ loss). Evaluate mode instead returns the odds score
`(ATK·8)/(DEF+1)` (0x05D032) for AI ranking. The naval unit-vs-unit roll in the
consequence applier `func_05B2C2` uses the **raw** ship stat pair `+0x0B/+0x0C`
(`0x523B/0x523C`, no modifier scaling): `roll = random_int(1, A+D)` at
0x05B844, with independence-war special cases (0x05B87D/0x05BA2D).

### 14.4 When the Combat Analysis dialog shows

Gate at 0x05D221 inside `func_05CA7E`, *after* the roll is computed but before
resolution renders: Game Options bit **`[0x5383]&2`** ("Combat Analysis"
checkbox) AND (attacker human OR defender human OR full-view `[0x53A2]≠0`).
Sole call site 0x05D291, 13 arguments (both unit indices, both positions, both
owners, both strengths, and the roll). The dialog itself (`func_05E9B0`, page
0x11) is a two-pass measure/draw modal: frame x=53, w=214, h=rows·20+6,
vertically centred; title "COMBAT ANALYSIS" (`@MISC` 75); attacker column
x=56, defender +80; row pitch 20; values right-aligned at column+0x50; each
cell dual-drawn dark/light for a drop shadow; modal-wait terminator.

### 14.5 Naval prompts

- `@HALF` — the pre-attack fatigue prompt above (also flags the −33% row).
- `@EVASIVE` — posted at 0x05D469 when a ship evades; text verbatim:

```text
{%STRING0 %STRING1} evades {%STRING2 %STRING3}.
```
