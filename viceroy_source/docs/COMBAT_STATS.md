# Combat Stats — @UNIT column → stat-offset mapping (BYTE_VERIFIED)

> **Status: BYTE_VERIFIED.** Every column→offset pair is proven from the
> @UNIT loader bytes (`COLONIZE/VICEROY.EXE`, reseg `page_1A.asm`); every
> numeric value is a `COLONIZE/NAMES.TXT` `@UNIT` line. This RESOLVES the
> `[TBD-data]` flagged in `src/combat/combat.c`, `combat_modifiers.c`, and
> `src/ai/unit_ai_leaf.c`, and the open item in `docs/RULINGS.md` wave-6 §3.

Binary: `COLONIZE/VICEROY.EXE`
sha256 `a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3`
Data:  `COLONIZE/NAMES.TXT` `@UNIT` section (handle `0x2258` → file `0x1FBF8` = `"UNIT"`,
string rule `file_offset = handle + 0x1D9A0`).

---

## 1. The @UNIT loader (file 0x74EC3..0x74F66) — byte trace

The loader lives in overlay page `0x1A`
(`code/VICEROY/disasm_overlay_reseg/page_1A.asm`,
lines 4163–4208). It is the `@UNIT` table builder — NOT `func_0749E0`
(that one ends at 0x74C39 and loads SEASONS/FORESTED/RESOURCE/COUNTRY/…;
the `@UNIT` loop is a separate loop further down the same page).

```
074EC3  push 0x2258                 ; "UNIT"  (handle 0x2258 -> file 0x1FBF8)
074EC8  lcall 0x191f:0x928          ; locate section "UNIT"
074ED0  mov  word [bp-8], 0         ; row index i = 0
; ---- loop body (label 0x3A45) ----
074ED5  lcall 0x191f:0x91c          ; advance-record / start a fresh line buffer
074EDA  lcall 0x1a1f:0xb22          ; FIELD READ #1 (string copy)   -> AX
074EDF..074EEC                      ; bx = i*14  (cx=i; bx=2i; +i=3i; <<1=6i; +i=7i; <<1=14i)
074EEE  mov  word [bx+0x5230], ax   ; STORE #1 -> 0x5230 (word)
074EF2  mov  si, bx
074EF4  lcall 0x1a1f:0x88a          ; FIELD READ #2 (atoi)          -> AL
074EF9  mov  byte [si+0x5232], al   ; STORE #2 -> 0x5232
074EFD  lcall 0x1a1f:0x88a          ; FIELD READ #3
074F02  mov cx,ax; shl al,1; add al,cl  ; AL = 3 * field#3
074F08  mov  byte [si+0x5234], al   ; STORE #3 -> 0x5234  ( = 3 x field#3 )
074F0C  lcall 0x1a1f:0x88a          ; FIELD READ #4
074F11  mov  byte [si+0x5236], al   ; STORE #4 -> 0x5236
074F15  lcall 0x1a1f:0x88a          ; FIELD READ #5
074F1A  mov  byte [si+0x5235], al   ; STORE #5 -> 0x5235        (NOTE: 0x5235 < 0x5236 in addr, but read AFTER)
074F1E  lcall 0x1a1f:0x88a          ; FIELD READ #6  -> 0x5237
074F27  lcall 0x1a1f:0x88a          ; FIELD READ #7  -> 0x5238
074F30  lcall 0x1a1f:0x88a          ; FIELD READ #8  -> 0x5239
074F39  lcall 0x1a1f:0x88a          ; FIELD READ #9  -> 0x523a
074F42  lcall 0x1a1f:0x88a          ; FIELD READ #10 -> 0x523b   <-- SHIP-roll DEF
074F4B  lcall 0x1a1f:0x88a          ; FIELD READ #11 -> 0x523c   <-- SHIP-roll ATK
074F54  lcall 0x1a1f:0xb2e          ; FIELD READ #12 (binary-flag string) -> 0x523d
074F5D  inc  word [bp-8]
074F60  cmp  word [bp-8], 0x17      ; 23 rows (0..22)
074F64/66  jge done / jmp 0x3A45
```

### The three field-readers (decoded from page 0x18, the C-runtime parser)

All three call the SAME shared field-advance trampoline `0x6FB2D`
(`ljmp 0x191f:0xfc4`) **exactly once** per call, so **each reader consumes one
comma-separated field and advances the cursor** — they read in strict
left-to-right order. (Page-0x18 reader bodies disassembled from the raw EXE:
`0x88a`@file 0x6FA78, `0xb22`@file 0x6FAA8, `0xb2e`@file 0x6FAB9.)

| thunk            | page-0x18 body | behaviour                                                            |
|------------------|----------------|----------------------------------------------------------------------|
| `0x1a1f:0xb22`   | file 0x6FAA8   | advance 1 field, **strcpy** into buffer 0xA5B8, return buffer (word). The **NAME** reader. |
| `0x1a1f:0x88a`   | file 0x6FA78   | advance 1 field, **atoi** (`lcall 0x1a1f:0xb3a`), return int in AL.   |
| `0x1a1f:0xb2e`   | file 0x6FAB9   | advance 1 field, parse the **8-char binary string** (`'0'/'1'` → byte), return AL. e.g. `"01000000"`→0x40. |

Cross-check that readers consume sequentially (not re-read): the `@RESOURCE`
loop in `func_0749E0` (file 0x74AF0) does `0x91c` → `0xb22`(word) →
`0x88a`(byte) per row, and `@RESOURCE` rows are exactly `Name, Number`
(2 fields). 2 readers ↔ 2 fields ⇒ `0xb22` reads field[0] (the name),
`0x88a` reads field[1]. Same in `@COUNTRY` (`England, 12`). This pins the
field cursor: **read #1 = field[0] = NAME.**

---

## 2. Column → offset map (VERIFIED)

`@UNIT` row = 12 comma fields. Loader legend (matches `data/unit_classes.c`):
`Name, icon, movement, attack, combat, cargo, size, cost, tools, guns, hull, role`.

| read | reader        | NAMES.TXT field (0-based) | column name | DGROUP offset | stored value      |
|------|---------------|---------------------------|-------------|---------------|-------------------|
| #1   | `0xb22` word  | field[0]                  | Name        | **0x5230** (word) | string-buffer ptr |
| #2   | `0x88a` byte  | field[1]                  | icon        | **0x5232**    | icon (1-based ICONS) |
| #3   | `0x88a` byte  | field[2]                  | movement    | **0x5234**    | **3 × movement**  |
| #4   | `0x88a` byte  | field[3]                  | **attack**  | **0x5236**    | attack            |
| #5   | `0x88a` byte  | field[4]                  | **combat**  | **0x5235**    | defense           |
| #6   | `0x88a` byte  | field[5]                  | cargo       | 0x5237        | cargo slots       |
| #7   | `0x88a` byte  | field[6]                  | size        | 0x5238        | hold-space cost (99=ship) |
| #8   | `0x88a` byte  | field[7]                  | cost        | 0x5239        | economic-size     |
| #9   | `0x88a` byte  | field[8]                  | tools       | 0x523a        | tools             |
| #10  | `0x88a` byte  | field[9]                  | **guns**    | **0x523b**    | **ship-roll DEF** |
| #11  | `0x88a` byte  | field[10]                 | **hull**    | **0x523c**    | **ship-roll ATK** |
| #12  | `0xb2e` flag  | field[11]                 | role        | 0x523d        | 8-bit AI role mask |

Stride = **14 (0xE)**; base **0x5230**; **23 rows** (`cmp 0x17`), row index = the
canonical `UnitRecord.type` (`+0x02`).

### Which column is ATK / which is DEF — and for ship vs land

There are **TWO** combat-stat pairs, and they map to DIFFERENT @UNIT columns:

- **LAND combat** (the `func_05CA7E` decider, via accessors `0x07C2A`/`0x07D3E`):
  - **ATTACK = 0x5236 = `attack` (field[3])**
  - **DEFENSE = 0x5235 = `combat` (field[4])**
  - Proven at the accessor `get_unit_strength` @0x07C2A:
    `cmp [bp+8],0; je 0x7C68` — flag≠0 (attack) ⇒ `mov al,[bx+0x5236]` @0x7C62;
    flag==0 (defense) ⇒ `mov al,[bx+0x5235]` @0x7C7E. Then `shl ax,3` (×8 base) @0x7CA9.
- **SHIP combat** (the ship-only roll `func_05B2C2` @0x5B819):
  - **DEFENDER DEF = 0x523b = `guns` (field[9])**
  - **ATTACKER ATK = 0x523c = `hull` (field[10])**
  - Proven at the roll: `cmp [bx+0x523b],0; jne` (defender DEF, skip if 0) @0x5B819;
    `al=[bx+0x523b]` @0x5B823; `cl=[bx+0x523c]` (attacker, si×14) @0x5B83B;
    `add ax,cx` (DEF+ATK, no scaler) @0x5B844; `random_int(1,DEF+ATK)` @0x5B849;
    `cmp ax,[bp-0x1c]`(=ATK)/`jle` ⇒ attacker wins iff roll≤ATK @0x5B851.

---

## 3. Per-unit-type value table (from NAMES.TXT @UNIT, mapped to verified offsets)

`type` = row index = `UnitRecord.type`. All values are the literal `@UNIT`
line fields. `0x5234` shown as the STORED value (3 × movement).

| ty | name          | 0x5232 icon | 0x5234 (=3·mv) | **0x5236 ATK** | **0x5235 DEF** | 0x5237 cargo | 0x5238 size | 0x5239 cost | 0x523a tools | **0x523b shipDEF** | **0x523c shipATK** | 0x523d role |
|----|---------------|-----:|-----:|----:|----:|----:|----:|----:|----:|----:|----:|--------:|
| 0  | Colonists     | 101 |  3 |  0 |  1 |  0 |  1 |  1 |  0 |  0 |  0 | 01000000 |
| 1  | Soldiers      | 103 |  3 |  2 |  2 |  0 |  1 |  2 |  0 |  0 |  0 | 00011100 |
| 2  | Pioneers      | 102 |  3 |  0 |  1 |  0 |  1 |  2 |  0 |  0 |  0 | 01000000 |
| 3  | Missionaries  | 106 |  6 |  0 |  1 |  0 |  1 |  1 |  0 |  0 |  0 | 00100000 |
| 4  | Dragoons      | 105 | 12 |  3 |  3 |  0 |  1 |  3 |  0 |  0 |  0 | 00111100 |
| 5  | Scouts        | 104 | 12 |  1 |  1 |  0 |  1 |  2 |  0 |  0 |  0 | 01100100 |
| 6  | Regulars      | 126 |  3 |  5 |  5 |  0 |  1 |  3 |  0 |  0 |  0 | 00011100 |
| 7  | Cont. Cav.    | 130 | 12 |  5 |  5 |  0 |  1 |  3 |  0 |  0 |  0 | 00011100 |
| 8  | Cavalry       | 127 | 12 |  6 |  6 |  0 |  1 |  4 |  0 |  0 |  0 | 00011100 |
| 9  | Cont. Army    | 129 |  3 |  4 |  4 |  0 |  1 |  3 |  0 |  0 |  0 | 00011100 |
| 10 | Treasure      |  17 |  3 |  0 |  0 |  0 |  6 |  4 |  0 |  0 |  0 | 00000000 |
| 11 | Artillery     |  10 |  3 |  **7** |  **5** |  0 |  1 |  6 |  4 |  0 |  0 | 00011000 |
| 12 | Wagon Train   |   9 |  6 |  0 |  1 |  2 | 99 |  1 |  0 |  0 |  0 | 00000000 |
| 13 | Caravel       |   6 | 12 |  0 |  2 |  2 | 99 |  4 |  4 |  0 |  4 | 10100010 |
| 14 | Merchantman   |   7 | 15 |  0 |  6 |  4 | 99 |  6 |  8 |  1 |  8 | 10000010 |
| 15 | Galleon       |   8 | 18 |  0 | 10 |  6 | 99 | 10 | 10 |  4 | 20 | 10000010 |
| 16 | Privateer     |  15 | 24 |  8 |  8 |  2 | 99 |  8 | 12 |  4 | 12 | 00000001 |
| 17 | Frigate       |  16 | 18 | 16 | 16 |  4 | 99 | 16 | 20 | 12 | 32 | 10000001 |
| 18 | Man-O-War     | 128 | 15 | 24 | 24 |  6 | 99 | 32 | 90 | 32 | 64 | 10000001 |
| 19 | Braves        | 110 |  3 |  1 |  1 |  0 |  0 |  1 |  0 |  0 |  0 | 00111000 |
| 20 | Armed Braves  | 111 |  3 |  2 |  2 |  0 |  0 |  2 |  0 |  0 |  0 | 00111000 |
| 21 | Mtd. Braves   | 112 | 12 |  2 |  2 |  0 |  0 |  2 |  0 |  0 |  0 | 00111000 |
| 22 | Mtd. Warriors | 113 | 12 |  3 |  3 |  0 |  0 |  3 |  0 |  0 |  0 | 00111000 |

Notes:
- For all LAND units, `0x523b`/`0x523c` (ship roll) are **0** → the ship-roll
  `DEF==0 → skip` guard @0x5B819 always fires, i.e. the ship roll never resolves
  land combat. This is exactly the wave-6/wave-9 "ship-attacker-only" finding,
  now explained by the data: only ships have nonzero `guns`/`hull`.
- Ships (Caravel..Galleon) have `0x5236`(attack)=0 → they make no LAND attack;
  their naval combat uses `0x523b`/`0x523c`.

---

## 4. Cross-checks (re-verifiable)

1. **Section name.** `python`: `exe[0x2258+0x1D9A0 : ...]` → `"UNIT"` at file `0x1FBF8`.
   Next section handle `0x225D` → `"ORDERS"` (the loop's terminator at 0x74F69).
2. **Artillery 7/5 distinguishes ATK vs DEF.** NAMES.TXT row 11
   `Artillery, 10, 1, 7, 5, …` ⇒ field[3]=7, field[4]=5. Loader stores field[3]→0x5236,
   field[4]→0x5235. Accessor @0x7C62 reads 0x5236 for attack, @0x7C7E reads 0x5235 for
   defense. Canonical Colonization Artillery = **attack 7, defense 5** ⇒ **0x5236=ATK,
   0x5235=DEF.** (No other row disambiguates as cleanly; almost all land units have
   attack==defense.)
3. **Ship roll bytes.** Disasm `VICEROY.EXE` @0x5B819: `80 bf 3b 52 00`
   (`cmp [bx+0x523b],0`), @0x5B823 `8a 87 3b 52` (`mov al,[bx+0x523b]` = DEF), @0x5B83B
   `8a 8f 3c 52` (`mov cl,[bx+0x523c]` = ATK), @0x5B844 `03 c1` (`add ax,cx`, no scaler),
   @0x5B851 `3b 46 e4` / `7e` (`cmp ax,[bp-0x1c]`/`jle`).
4. **Reader = single-field-advance.** Page-0x18 `0x88a`@0x6FA78 = `0e e8 b1 00`
   (`push cs; call 0x6FB2D`) then `9a 3a 0b 1f 1a` (`lcall 0x1a1f:0xb3a` = atoi).
   `0xb2e`@0x6FAB9 loops over `'0'/'1'` bytes building a flag byte (parses
   `"01000000"`→0x40). `0x6FB2D` = `ea c4 0f 1f 19` (`ljmp 0x191f:0xfc4`, the
   field-advance) — the same target both call once.
5. **Stride / row-count.** Loader index math @0x74EDF..0x74EEC = ×14;
   `cmp [bp-8],0x17` @0x74F60 = 23 rows. NAMES.TXT `@UNIT` has exactly 23 unit rows.

---

## 5. Was combat.c's "@UNIT col3/col4 → 0x523b/0x523c" claim right? — **WRONG.**

- `src/combat/combat.c` header (lines 44–46) claims *"col 3 = attack, col 4 =
  defense"* load into `0x523B`/`0x523C`. **Incorrect.** The loader writes
  **col3 (attack) → 0x5236** and **col4 (combat/defense) → 0x5235**.
- `0x523b`/`0x523c` are filled from the LATER columns **col9 `guns`** and
  **col10 `hull`** — they are the SHIP-roll DEF/ATK, not the land attack/defense.
- The wave-6 `RULINGS.md` note ("loader writes cols 3/4 to 0x5234/0x5236") was
  **close but imprecise**: col3→**0x5236** (✓), but col4→**0x5235** (not 0x5236),
  and **0x5234 = 3 × col2 (movement)**, not col3. The precise map is §2 above.
- What IS correct in combat.c / combat_modifiers.c: the OFFSET *roles* at the
  use-sites — `0x523b`=DEF and `0x523c`=ATK in the SHIP roll (byte-certain), and
  `0x5236`=attack / `0x5235`=defense in the LAND accessors (byte-certain). Only the
  English label "@UNIT col3/col4 → 0x523b/0x523c" was wrong; it should read
  "@UNIT col3 (attack) → 0x5236, col4 (combat) → 0x5235; the ship-roll
  0x523b/0x523c come from col9 (guns) / col10 (hull)."

`data/unit_classes.c` carries the SAME mislabel (its `attack` field comment says
"mirrors 0x5230 +0x0C" = 0x523c, and `defense` says "+0x0B" = 0x523b). Per §2
those should be **+0x06 (0x5236)** and **+0x05 (0x5235)** respectively. The DATA
VALUES in `unit_classes.c` are correct and match this trace exactly; only the two
offset comments need fixing. (See §6 proposed rows / comment fix.)

---

## 6. Proposed central application (report-only; not applied here)

`data/unit_classes.c` **already contains the correct 23-row value table**
(verified field-for-field against this trace). The only changes needed are
**comment corrections** to the `attack`/`defense` mirror-offsets, plus an
optional addition of the ship-combat (`guns`/`hull`) offset roles. Proposed:

```c
    uint8_t  attack;      /* col3  -> DGROUP 0x5236 (stat row +0x06); LAND attack
                           *         (accessor get_unit_strength @0x07C62, flag!=0). */
    uint8_t  defense;     /* col4 "combat" -> DGROUP 0x5235 (+0x05); LAND defense
                           *         (accessor @0x07C7E, flag==0). */
    ...
    uint8_t  guns;        /* col9  -> DGROUP 0x523b (+0x0B); SHIP-roll DEFENSE
                           *         (func_05B2C2 @0x5B823). */
    uint8_t  hull;        /* col10 -> DGROUP 0x523c (+0x0C); SHIP-roll ATTACK
                           *         (func_05B2C2 @0x5B83B). */
```

And the file header `@xref` line should change from
`"+0x0C attack, +0x0B defense"` to
`"+0x06 attack (0x5236), +0x05 defense (0x5235); ship 0x523b/0x523c = guns/hull"`.

For `src/combat/combat.c` (do not edit per scope), the same correction applies to
its `UNIT_ATTACK`/`UNIT_DEFENSE` macros: those macros index `+0x0C`/`+0x0B`
which is correct **for the SHIP roll** (0x523c/0x523b), but the header comment
claiming those come from "@UNIT col 3/col 4" is wrong — they come from col10/col9
(hull/guns). The LAND attack/defense are `+0x06`/`+0x05` (0x5236/0x5235), accessed
only through `res_get_unit_strength_7C2A` (see `src/ai/unit_ai_leaf.c`).

---

## 7. Honest limits

- The numeric values are **not** present as a static array in the EXE image;
  the `0x5230`-stride-14 table is **filled at runtime** by the loader from
  NAMES.TXT (the bytes at the DGROUP file image for 0x5230 are not the loaded
  table — they are zero-init / unrelated). So a "loaded DGROUP image" cross-check
  is only possible from a runtime memory dump, not the static EXE. The values
  here are therefore cited to NAMES.TXT lines + the byte-verified loader path,
  which is the canonical source (the EXE itself reads them from NAMES.TXT).
- The semantic NAMES of cols 5–10 (`cargo/size/cost/tools/guns/hull`) follow
  `data/unit_classes.c`'s legend; only `guns`(0x523b)/`hull`(0x523c) are
  combat-load-bearing here and are byte-confirmed as the ship-roll DEF/ATK by
  their use-site. The remaining mid-columns (0x5237 cargo … 0x523a tools) are
  byte-confirmed as STORED at those offsets; their gameplay meanings are taken
  from the existing legend and are out of this sub-task's combat scope.
