# VICEROY.EXE — Architecture

End-to-end map of how Sid Meier's Colonization (DOS, 1994) is built.
Every section cites the BYTE_VERIFIED function that implements it.

---

## Build / runtime stack

| Layer | Component |
|-------|-----------|
| Compiler | Microsoft C 6.0 medium-model (DOS) — confirmed by `__aFlmul`/`__aFldiv` byte-pattern match (BYTE_VERIFIED) |
| RTLink Plus overlay system | 1,020 thunks at file 0x1A5F0..0x1D5E6 (BYTE_VERIFIED). Type B thunks JMP-FAR into the load image; Type A thunks dispatch overlays via `LCALL 0x110D:0x0DAB` (the dispatcher) |
| MicroProse MADS engine | Asset library (madspack 2.0 + FAB compression). Powers SS/PIK/FF formats |
| MSC 6.0 C runtime | strcpy, strcat, strlen, fopen, fread, rand/srand, long math (`__aFlmul`/`__aFldiv`) — all BYTE_VERIFIED |
| Hardware target | 16-bit DOS, VGA mode 13h (320×200×256), Adlib/SB/Roland audio |

---

## Boot sequence

1. **MZ entry** at file 0x013BED (CS:IP = 210d:071d). BYTE_VERIFIED.
2. **`entry_point`** sets `DAT_2b5a_e944 = 0x210d`, `DAT_2b5a_e942 = 0x17f2`,
   then calls **startup helper** `func_210d_0727` at file 0x012CF7.
3. Startup helper sets up DGROUP, then calls **`cstart`** `func_1d1d_0150`
   at file 0x01072A (BYTE_VERIFIED via Ghidra).
4. `cstart` does DOS-version check, heap init, `setargv`, then calls
   **`_main()`** which is `func_281f_0000` at file 0x01A5F0 — the FIRST
   RTLink overlay thunk.
5. `_main()` is the first overlay function — it dispatches to the
   game-init code in the overlay region. Loads VICEROY.PAL,
   PHYS0/ICONS/etc.SS, NAMES.TXT, the startup .PIK, etc.
6. **`func_0749E0`** (the **scenario loader**) reads NAMES.TXT and
   parses 40+ data sections into DGROUP tables. BYTE_VERIFIED via
   string analysis.

---

## Per-turn loop

Each turn the game:
1. Iterates active powers (0..3 European players + 4..11 native tribes).
2. For each power, processes pending events (combat, market, king,
   diplomacy, etc.) via the function dispatchers cataloged in
   [`viceroy_source/FUNCTION_INVENTORY.md`](../viceroy_source/FUNCTION_INVENTORY.md).
3. Updates UI: redraws the visible viewport (render chain
   `func_O514 → O513 → O512`), updates HUD.
4. Writes save (HALLFAME.DAT etc.) at appropriate intervals.

Turn counter: `[DGROUP:0x538E]` (16-bit, BYTE_VERIFIED via king tax
formula).

---

## Game systems (BYTE_VERIFIED entry-points)

| System | Entry function | File offset |
|--------|----------------|------------:|
| Native village raze | `func_04A7CA` (CHIEFKILL) | 0x04A7CA |
| Diplomacy / SMITE | `func_057F4E` | 0x057F4E |
| Colony burn / capture | `func_05CA7E` | 0x05CA7E |
| Native raid (6 outcomes) | `func_05BE84` | 0x05BE84 |
| King tax raise/lower | `func_034AE0` | 0x034AE0 |
| King tax cap (=75) | `func_034318` | 0x034318 |
| Combat demotion ladder | `func_05B2C2` | 0x05B2C2 |
| Treasure transport | `func_05C878` | 0x05C878 |
| Colony production | `func_02D658` | 0x02D658 |
| Town hall services | `func_02883E` | 0x02883E |
| Market price drift | `func_0305A8` | 0x0305A8 |
| AI dispatcher | `func_04E2D6` | 0x04E2D6 |
| Score formula | `func_03A9C0` | 0x03A9C0 |
| Hall-of-Fame writer | `func_03ADA6` | 0x03ADA6 |
| Win/lose check | `func_02F3A2` | 0x02F3A2 |
| Tutorial dispatcher | `func_020F50` | 0x020F50 |
| Top menu bar | `func_072090` | 0x072090 |
| Dialog framework | `func_06F0F4` | 0x06F0F4 |
| Text template parser | `func_06EEEC` | 0x06EEEC |
| Independence guard | `func_03E984` | 0x03E984 |
| Diplomatic actions | `func_03ECF0` | 0x03ECF0 |
| Native extortion | `func_04AC00` | 0x04AC00 |
| Native trade haggling | `func_049600` | 0x049600 |
| Tribe attitude display | `func_04B308` | 0x04B308 |
| Native learning | `func_04A426` | 0x04A426 |
| Scout interactions | `func_05A20E` | 0x05A20E |
| SOL display | `func_03E844` | 0x03E844 |
| Intervention | `func_03D948` | 0x03D948 |
| Ship combat | `func_03FDDE` | 0x03FDDE |

Plus 30+ helper-tier BYTE_VERIFIED functions (rand, random_int,
__aFlmul, __aFldiv, strcpy, strcat, clamp, power_attribute_bit, etc.)
documented in [`viceroy_source/D1D_181F_RUNTIME.md`](../viceroy_source/D1D_181F_RUNTIME.md).

---

## Memory layout

| Region | File offset | Description |
|--------|-------------|-------------|
| MZ header | 0x000000 | DOS executable header |
| Relocation table | 0x000040 | Address fixups |
| Load image | 0x002400..0x00DDDD | Resident code (C runtime, RTLink loader, math, message API) |
| DGROUP | 0x010000..0x01FFFF | Initialized data + BSS (game state, tables, RNG seed) |
| RTLink thunk table | 0x01A5F0..0x01D5E6 | 1,020 dispatch thunks |
| String segment | 0x01D9A0..0x020665 | Game message keys (BURNED, KINGTAX, etc.) |
| Overlay region | 0x020665+ | All game-logic functions (combat, raze, market, etc.) |

DGROUP anchors (BYTE_VERIFIED):
- `0x53A6` — current player / difficulty
- `0x538E` — turn counter
- `0x5382` — game flags
- `0x84FC` — king/payer record pointer
- `0x8542` — colony_t pointer
- `0x8809+N×0x13C` — PowerRecord[N]
- `0x3146+N×0x1C` — UnitRecord[N]
- `0x540E+N×0x34` — AIPersonality[N]
- `0x5AD6+N×78` — TRIBE_DATA[N]
- `0x28EE/0x28F0` — RNG seed (32-bit)

---

## Engines / subsystems

### RTLink Plus overlay system

VICEROY.EXE's overlay system manages 250 overlay "pages." Each page can
be loaded/unloaded on demand from disk. The thunk table is the central
dispatch surface — every cross-overlay call goes through a thunk.

**Key functions** (BYTE_VERIFIED via Ghidra import):
- `func_210d_0d91` (file 0x011D91) — the overlay dispatcher (353
  callers — most-called function in load image).
- `func_210d_0dab` (file 0x011DAB) — partner dispatcher.

**Two thunk types**:
- **Type B (10 bytes)**: `LCALL dispatcher; JMP FAR fixed_target`. The
  target is in the load image — directly decodable today.
- **Type A (12-14 bytes)**: `LCALL dispatcher; trailer_word_1=page;
  trailer_word_2=offset_in_page`. Page-based dispatch.

See [`docs/RTLINK_OVERLAYS.md`](RTLINK_OVERLAYS.md) for the full
overlay system trace.

### Render chain

See [`docs/RENDER_CHAIN.md`](RENDER_CHAIN.md).

### Data model (records)

See [`docs/DATA_MODEL.md`](DATA_MODEL.md).
