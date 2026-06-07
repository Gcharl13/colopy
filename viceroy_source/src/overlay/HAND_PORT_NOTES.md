# Overlay hand-port notes

Per-function interpretation notes for the largest and most-important
overlay functions. These complement the auto-generated SKELETON bodies
in `overlay_*.c` with semantic understanding.

When a function in this catalog is hand-ported, its entry here should
be promoted from "INFERRED" to "VERIFIED" and the SKELETON in the .c
file should be replaced with structured C reflecting the interpretation.

---

## Top 30 LARGE_LOGIC functions (by size)

### Hand-annotated (Round 1, 2026-05-02)

The following functions have inferred-role annotations in their .c file
citation blocks, with the function rename applied (no longer
`_unknown`):

| Offset | Bytes | Renamed to | File |
|--------|------:|------------|------|
| 0x064A10 | 1792 | `func_064A10_map_or_turn_setup`              | overlay_0612E6_066EB3.c |
| 0x051EF4 | 1093 | `func_051EF4_score_tick_for_power`           | overlay_04C306_053BC1.c |
| 0x03D510 | 1080 | `func_03D510_pick_random_colony_weighted`    | overlay_03C5A8_040C11.c |
| 0x02D658 | 1061 | `func_02D658_open_colony_view`               | overlay_02AAEC_02F0C7.c |
| 0x039EE2 |  746 | `func_039EE2_continental_or_revolution_dispatch` | overlay_038A50_03C5A8.c |
| 0x038418 |  703 | `func_038418_open_colonies_list`             | overlay_0341D6_0388DE.c |
| 0x02C5D4 |  592 | `func_02C5D4_draw_one_colony_report_row`     | overlay_02AAEC_02F0C7.c |
| 0x04E2D6 |  584 | `func_04E2D6_draw_unit_on_map`               | overlay_04C306_053BC1.c |
| 0x0409D6 |  571 | `func_0409D6_render_unit_info`               | overlay_03C5A8_040C11.c |

### `func_064A10_map_or_turn_setup` @ 0x064A10  (1792 bytes)

- **File:** `overlay_0612E6_066EB3.c`
- **Inferred role:** MAP_GENERATION_OR_AI_TURN_SETUP
- **Evidence:**
  - Reads map_width (0x853A) and map_height (0x853C)
  - Two 64-bit RNG seeds at DGROUP:0x85A8..AE and 0x85B0..B6
  - 33 LCALLs total: 13 to 0x181F:0x4D4 (rand modulo), 7 each to map-cell-test and map-cell-mark
  - 16-entry word array at DGROUP:0x85C8 (game powers/tribes?)
  - Uses 0x140=320 multiplier (screen-stride or 64-tile region)
- **Likely semantics:** New-game / map-init function that places initial
  Lost-City rumours, villages, and resources across the map.

### `func_0759E8` @ 0x0759E8  (1438 bytes)

- **File:** `overlay_0745F0_077A6A.c`
- **Inferred role:** EUROPE_SCREEN or MENU_DRAW (TBD)

### `func_03ADA6` @ 0x03ADA6  (1362 bytes)

- **File:** `overlay_038A50_03C5A8.c`
- **Inferred role:** TBD — large self-contained function with many branches

### `func_076642` @ 0x076642  (1194 bytes)

- **File:** `overlay_0745F0_077A6A.c`

### `func_069D8C` @ 0x069D8C  (1153 bytes)

- **File:** `overlay_068A14_06C1CC.c`

### `func_051EF4` @ 0x051EF4  (1093 bytes)  -- TOUCHES_COLONY

- **File:** `overlay_04C306_053BC1.c`
- **Inferred role:** COLONY_SCREEN_DRAW or COLONY_TICK_LOGIC. Touches *(0x8542),
  so it's working with the current-colony struct.
- **Approach:** Cross-reference against `colony_turn_update` to see whether this
  is an alternate dispatch path for colony updates.

### `func_03D510` @ 0x03D510  (1080 bytes)  -- TOUCHES_COLONY

- **File:** `overlay_03C5A8_040C11.c`
- **Inferred role:** COLONY_RELATED LARGE_LOGIC. Same colony-touching evidence
  as 0x051EF4. Likely the colony-screen renderer or one of the report screens.

### `func_02D658` @ 0x02D658  (1061 bytes)  -- TOUCHES_COLONY

- **File:** `overlay_02AAEC_02F0C7.c`
- **Inferred role:** COLONY_RELATED LARGE_LOGIC. Possibly the founding-father
  effect handler that iterates per-colony when an FF is signed.

### `func_06B722` @ 0x06B722  (970 bytes)
### `func_03B3B8` @ 0x03B3B8  (959 bytes)
### `func_048F34` @ 0x048F34  (922 bytes)  -- TOUCHES_COLONY
### `func_056694` @ 0x056694  (811 bytes)
### `func_039EE2` @ 0x039EE2  (746 bytes)  -- TOUCHES_COLONY
### `func_04830E` @ 0x04830E  (743 bytes)  -- has 1 caller
### `func_03471E` @ 0x03471E  (725 bytes)
### `func_06B398` @ 0x06B398  (711 bytes)
### `func_038418` @ 0x038418  (703 bytes)  -- TOUCHES_COLONY
### `func_072CC2` @ 0x072CC2  (696 bytes)
### `func_038F2C` @ 0x038F2C  (659 bytes)  -- TOUCHES_COLONY
### `func_04B308` @ 0x04B308  (631 bytes)
### `func_021A14` @ 0x021A14  (602 bytes)
### `func_0749E0` @ 0x0749E0  (601 bytes)
### `func_02C5D4` @ 0x02C5D4  (592 bytes)  -- TOUCHES_COLONY
### `func_04E2D6` @ 0x04E2D6  (584 bytes)  -- TOUCHES_COLONY
### `func_075352` @ 0x075352  (578 bytes)
### `func_048CF8` @ 0x048CF8  (572 bytes)
### `func_0409D6` @ 0x0409D6  (571 bytes)  -- TOUCHES_COLONY
### `func_06A700` @ 0x06A700  (562 bytes)
### `func_023344` @ 0x023344  (551 bytes)
### `func_041EEA` @ 0x041EEA  (545 bytes)

---

## Hand-port priority ordering

Recommended next-session order:

1. **Colony-touching large functions first** (these benefit from existing
   colony.h knowledge):
   - 0x051EF4, 0x03D510, 0x02D658, 0x048F34, 0x039EE2, 0x038418,
     0x038F2C, 0x02C5D4, 0x04E2D6, 0x0409D6
2. **Functions with non-zero callers** (we have anchors):
   - 0x04830E (1 caller), 0x044540 (3 callers), 0x06BE50 (3 callers),
     0x06C18C (3 callers), 0x020F50 (2 callers), 0x032294 (2 callers),
     0x04458A (2 callers), 0x06CD66 (2 callers), 0x06DE6E (2 callers)
3. **Distinct LCALL target clusters** (the 432 distinct overlay LCALL
   targets — each is a function we should identify in turn)
4. **Large remaining LARGE_LOGIC** (the rest of the 1000-byte+ cluster)

---

## Tool support

- `tools/overlay_body_gen.py` regenerates auto-traced bodies (run after
  any disassembler refresh).
- `tools/overlay_pattern_fillers.py` re-runs the pattern fill-in for
  TINY_ACCESSORs that newly became identifiable.
- `tools/overlay_segment_inferrer.py` identifies segment boundaries.

When a function gets hand-ported:
1. Edit the corresponding `overlay_*.c` file in place
2. Update this catalog entry from "INFERRED" to "VERIFIED"
3. Optionally rename the function from `func_NNNNNN_unknown` to
   `func_NNNNNN_<descriptive_name>`
4. Update `viceroy_source/COMPLETION.md` SKELETON → DONE counts
