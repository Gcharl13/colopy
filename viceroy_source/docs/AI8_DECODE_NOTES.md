# AI8 delivery body (0x4F883..0x50583) — decode notes (ROUTE_B 1.2, in progress)

Working notes from the decode sheet `re_work/sheets/func_04E2D6_0x4F883_0x50583.txt`
(regenerable: `tools/decode_sheet.py 0x4F883 0x50583 --locals tools/locals/func_04E2D6.json`).
Addresses only — no original bytes here.

## Decoded so far (sheet lines 1..470, file 0x4F883..0x4FD2D)

### Prologue (0x4F883..0x4F952)
- `func_006A7C_logic_sz_50(unit, map_x, map_y)`  (0x181F:0x948, PORTED)
- `ai8_target_64 = func_04C306_ai_queue_a_lookup_max(owner, x, y, 7)`  (tramp 0x53534)
- `hunt_EA      = func_04C306_ai_queue_a_lookup_max(owner, x, y, 1)`  (slot reuse!)
- `ai8_66 = func_04C846_ai_find_unit_of_type(unit)`  (tramp 0x534BC, PORTED)
- if `ai8_66 >= 0`:
  - `si = func_04C71C_ai_unit_task_priority(owner, ai8_66, -1)` (tramp 0x53516)
        `+ func_04C5C0_ai_power_budget(owner)` (tramp 0x534D0)
  - `si > 0`: `ai8_7E = ai8_80; qty3 += ai8_80; ai8_80 = 0`
  - else if `hunt_EA == 0`: `ai8_80 += qty3; qty3 = 0`
- **setup tail still missing from the port** (0x4F856..0x4F86C):
  `ai8_80 = deliv_A6 - qty5 - qty4 - qty3`; `ai8_B2 = qty3` snapshot.

### deliv != 0 path: flag-word build over neighbour dirs (0x4F95C..0x4FCC4)
- `flags_9A = 0`; if `qty3|qty4|qty5 == 0` → exit loop region (0x4FCC4).
- **Direction loop d = 0..7** (cond at 0x4FC20, body entered via 0x4FCBD):
  neighbour (tx,ty) = map + dir_tab[d]; require in-bounds, `0x768`(water
  probe) == 0, tile owner (`0x6D2`) < 0 or == owner; then **flags_9A := 0
  (reset per qualifying dir)**, `reg2_5E = continent(tx,ty)`, require
  mission byte `0x9870[owner*16+r] != 0` and `2 <= ty <= mapH-3`; then the
  FLAG BUILD below runs for this region (so the LAST qualifying dir wins).
- **FLAG BUILD (L_4F998, per region r):**
  - unit.orders == 0x0B && continent(dest) == r → `flags = 0xFFFF`.
  - qty5 != 0 && mission[o][r] != 0:
    - `0x94E6[o*16+r] < 1` and `DGS16(0x85C8 + r*2) > 10` → `|= 0x20`
    - else (`>= 1`): `DG8(0x94A6 + o*16 + r) < (DGS16(0x85C8+r*2) >> 3)` → `|= 0x20`
  - qty3 != 0:
    - `func_04C682_ai_power_strength_delta(owner, r) > 0` → `|= 0x40` (tramp 0x534E9)
    - `0x94A6[o*16+r] == 0` → `|= 0x40`
    - colony-near veto: `keep_96 = 1`; if col_own >= 0 && reg_own_col == r:
      `(8 - 0x94E6[o][r]) > col_own_dist` → `&= ~0x40`; `col_own_dist >= 0xC`
      → `keep_96 = 0`
    - if keep_96: `t = turn>>4`; if `DG16(0x9650) != 0` and
      `0x94E6[o][r]*4 + 0x94A6[o][r] > t` and `DG16(0x1734+o*2) < 0x14`
      → `&= ~0x40`
    - `ai8_7E != 0 && DG8(0xA13C + r) > 1` → `&= ~0x40`
    - `ai8_target_64 != 0` → `|= 0x40`;  `hunt_EA != 0` → `|= 0x40`
    - `DG16(0x173E) & (1 << r)` → `|= 0x40`
  - qty4 != 0:
    - revolution && `0x94E6[nation*16+r] != 0` → `|= 0x10`
    - !revolution:
      - mission[o][r] == 4 → `|= 0x10`
      - qty6 == 0: same `0x9650`/`turn>>4`/`0x1734 < 0x14` veto shape → `&= ~0x10`
      - `0x94E6[o][r]==0 && (0x95F2[r] & 4) && col_any_dist < 7` → `|= 0x10`
      - `0x95F2[r] & 8` → `|= 0x10`
    - `queue_a(owner,x,y,7) != 0` → `|= 0x10`;  `queue_a(owner,x,y,1) != 0` → `|= 0x10`
    - `DG16(0x173C) & (1 << r)` → `|= 0x10`
- **Post-loop (L_4FCC4):** `DG16(0x1740) != 0` → `flags_9A = 0`;
  `flags_9A == 0` → jmp **0x4FE37**;
  `hunt_EA != 0 || ai8_target_64 != 0` → `special([bp-4]) = 0`;
  `saved_A4 = unit; [bp-0x76] = 0;` → per-unit loop at **L_4FD15**.

## New DGROUP addresses encountered (added to tools/dgroup_names.json)
| addr | name (working) |
|---|---|
| 0x85C8 | region_value_word_stride2 |
| 0x94A6 | power_region_count2_stride16 |
| 0x9650 | word_9650_ai_pacing_gate |
| 0x1734 | per-power boarding budget (already named) |
| 0x173C | region_bitmask_173C |
| 0x173E | region_bitmask_173E |
| 0x1740 | flag_word_1740 |

## Still to decode (sheet lines ~470..1100)
1. **L_4FD15 per-unit loop** (0x4FD15..0x4FE37): walks units; ends 0x4FE1E
   loop-back; then
2. **0x4FE37 phase** (flags==0 target) .. 0x50140: the enroute commit —
   expect: pick target region/colony, `jmp 0x4E9E5(dx='4')` or explore
   path 0x50196 (push unit; lcall 0x191F:0x2EA; jmp 0x4F225).
3. **0x50140 continuation** (deliv == 0 entry): the "no cargo enroute"
   branch — boarding-wait / sail-home logic, falls to AI9 at 0x50583.

## Port plan (next session)
- Extend the AI8 setup port with the 0x4F856 tail (ai8_80 / ai8_B2 / qty5
  into locals).
- Port prologue + flag build + the two remaining phases as one block
  inside the existing `ai8:` brace; new externs already PORTED:
  func_04C846_ai_find_unit_of_type, func_04C71C_ai_unit_task_priority,
  func_04C5C0_ai_power_budget, func_006A7C_logic_sz_50.
- flags_9A is function-scope already (AI17 reads it).
- Verify with cite_check + both smokes; the smoke fixture has no AI
  colonies so the body should stay cold there (assert end-state pins
  unchanged).
