# Overlay LCALL target reference

Each overlay function calls into other overlay functions via 16:16 LCALLs.
The most-frequently-called targets are documented here. Each entry shows:
- Target seg:off
- How many call-sites we found
- Inferred role (best-effort based on usage patterns and arg counts)
- Confidence (HIGH = corroborated by multiple distinct call patterns;
  MEDIUM = single strong signal; LOW = guess based on call-frequency)

This document is the reverse-engineered "API" of the overlay-resident
runtime library. As more functions are hand-ported, entries here get
upgraded from LOW to HIGH confidence.

## Top 50 most-called overlay LCALL targets

| Target          | Sites | Inferred role                            | Confidence |
|-----------------|------:|------------------------------------------|------------|
| 0x181F:0x016E   |    73 | dialog/menu primitive A                  | LOW        |
| 0x181F:0x0022   |    61 | dialog/menu primitive B                  | LOW        |
| 0x181F:0x0254   |    48 | screen/text drawing primitive            | LOW        |
| 0x181F:0x04D4   |    46 | rand_modulo(min, max) -- random in range | MEDIUM (called with bound args many times) |
| 0x181F:0x0178   |    45 | dialog primitive C                       | LOW        |
| 0x181F:0x0100   |    45 | dialog primitive D                       | LOW        |
| 0x0D1D:0x07E4   |    43 | C runtime helper (segment 0x0D1D = compiler-emitted) | LOW |
| 0x181F:0x0438   |    39 | string/event dispatch                    | LOW        |
| 0x181F:0x07E0   |    33 | sound/music                              | LOW        |
| 0x181F:0x00E2   |    32 | dialog primitive E                       | LOW        |
| 0x191F:0x01A8   |    29 | secondary-overlay primitive              | LOW        |
| 0x181F:0x013C   |    29 | dialog primitive F                       | LOW        |
| 0x181F:0x0182   |    28 | dialog primitive G                       | LOW        |
| 0x181F:0x0652   |    27 | screen-clear                              | LOW        |
| 0x181F:0x02E4   |    26 | input poll / event dispatch              | LOW        |
| 0x181F:0x09E6   |    24 | **get_colony_by_slot(slot)** -- sets *(0x8542) | HIGH (multiple uses with explicit colony deref after) |
| 0x0D1D:0x07A4   |    21 | **dispatch_overlay_op(opcode, arg)** -- the major dispatcher | HIGH (12 wrapper thunks at 0x28B0..0x2982 confirm) |
| 0x191F:0x0176   |    20 | secondary draw                           | LOW        |
| 0x181F:0x0302   |    19 | predicate (returns 0/1)                  | LOW        |
| 0x181F:0x078C   |    19 | unit/cargo helper                        | LOW        |
| 0x181F:0x0A38   |    19 | save/load helper                         | LOW        |
| 0x181F:0x0444   |    19 | text formatting                          | LOW        |
| 0x181F:0x0722   |    18 | dialog/menu                              | LOW        |
| 0x181F:0x0582   |    18 | per-power state setup                    | MEDIUM (called immediately before per-power processing) |
| 0x181F:0x09A4   |    18 | colony state primitive                   | LOW        |
| 0x191F:0x0928   |    18 | secondary helper                         | LOW        |
| 0x0D1D:0x0528   |    18 | C runtime helper                         | LOW        |
| 0x191F:0x0182   |    17 | secondary draw                           | LOW        |
| 0x181F:0x09FC   |    17 | colony helper                            | LOW        |
| 0x181F:0x011E   |    17 | dialog primitive H                       | LOW        |
| 0x181F:0x0416   |    16 | text/string                              | LOW        |
| 0x181F:0x07B4   |    16 | sound/music                              | LOW        |
| 0x181F:0x030C   |    16 | predicate                                | LOW        |
| 0x181F:0x0074   |    15 | dialog primitive I                       | LOW        |
| 0x181F:0x0056   |    15 | dialog primitive J                       | LOW        |
| 0x181F:0x09AE   |    15 | colony helper                            | LOW        |
| 0x181F:0x03FE   |    14 | text/event                               | LOW        |
| 0x0D1D:0x117E   |    14 | C runtime numeric helper                 | LOW        |
| 0x181F:0x0998   |    14 | colony helper                            | LOW        |
| 0x181F:0x03F4   |    14 | text/event                               | LOW        |
| 0x191F:0x016A   |    13 | secondary draw                           | LOW        |
| 0x181F:0x0768   |    13 | unit helper                              | LOW        |
| 0x181F:0x0128   |    13 | dialog primitive K                       | LOW        |
| 0x181F:0x035C   |    13 | dialog cleanup                           | LOW        |
| 0x181F:0x00CE   |    13 | dialog primitive L                       | LOW        |
| 0x181F:0x0BE6   |    12 | game-state helper                        | LOW        |
| 0x181F:0x0A4C   |    12 | save/load                                | LOW        |
| 0x181F:0x03C0   |    11 | menu                                     | LOW        |
| 0x191F:0x013A   |    11 | secondary                                | LOW        |
| 0x181F:0x01BE   |    11 | dialog primitive M                       | LOW        |

## Identified high-confidence targets

### `get_colony_by_slot(slot)` @ 0x181F:0x09E6 (24 callers)

Sets `*(0x8542)` to colony[slot] and returns its address.  Used at the
start of nearly every "operate on colony X" function.  Confirmed by:
- Always called with a single arg (slot index, range 0..g_progress_539E)
- Always followed within 5 instructions by `MOV BX, [0x8542]` and a
  field-deref of *(BX+offset).
- Found at: func_02D658 (open colony view), func_03D510 (random colony pick),
  many others.

### `dispatch_overlay_op(opcode, arg)` @ 0x0D1D:0x07A4 (21 callers + 12 dedicated thunks)

The major dispatch function.  Takes (opcode, arg) and routes to one of
many handlers.  Confirmed by:
- 12 wrapper thunks at 0x28B0..0x2982 in the load image, each forwarding
  a fixed opcode (0x50, 0x52, 0x55, 0x58, 0x5C, 0x5E, 0x60, 0x62, 0x64,
  0x66, 0x68, 0x6A).
- Called with first arg always a constant ≤ 0x80.

### `rand_modulo(low, high)` @ 0x181F:0x04D4 (46 callers — MEDIUM)

Returns a random integer in the half-open range `[low, high)`.  Heavily
used in map generation, AI decisions, random events.  Confirmed by:
- Always two args
- Result is often used as an index into a per-something array
- The 64-bit RNG seed at DGROUP:0x85A8..0x85AE is updated by 0x181F:0x484
  which is presumably the seed-feeder.

### `per_power_setup(power_idx)` @ 0x181F:0x0582 (18 callers — MEDIUM)

Loads per-power state into the working area before processing.
- Always called with single power index arg (0..7)
- Often paired with later reads of g_power_records[power_idx*0x34]

## How to add an entry

When you hand-port a function and identify what an LCALL target does,
update this file:

```
| 0x181F:0xNNNN | <count> | <inferred role>                | HIGH/MEDIUM/LOW |
```

Then update any function in `overlay_*.c` that calls this target to
reference its new name in comments. Over time, the auto-traced bodies
in `overlay_*.c` become readable as more LCALLs get identified here.
