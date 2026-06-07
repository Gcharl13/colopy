# VICEROY.EXE Architecture

## High-level structure

VICEROY.EXE is a 494,910-byte 16-bit DOS executable using:

- **Memory model:** real-mode 16-bit, large code / small data
- **Compiler:** Microsoft C 6.0 + Microsoft Macro Assembler 6.x
- **Linker:** RTLink Plus (Pocket Soft, ~1992)
- **Runtime library:** MLIBCE.lib (medium model C runtime)
- **Engine library:** madsdev.lib (MicroProse MADS engine — sprites,
  buffers, memory, sound, palette, PFAB compression)
- **Build date:** 7-Feb-95 (from MZ header)
- **Codename:** "Viceroy" (per the EXE name and internal references)

## Memory layout

```
+-------------------------+ ← 0xA000:0000  VGA video memory (mode 13h)
| VGA framebuffer         |
+-------------------------+
| (gap)                   |
+-------------------------+
| Far heap                |
+-------------------------+
| EMS window (16 KB)      |   if EMS available; allocated in system_init
+-------------------------+
| Near heap (DGROUP heap) |   for malloc/free
+-------------------------+
| BSS                     |   uninitialised globals
+-------------------------+
| DATA (DGROUP)           |   initialised globals (incl. all the structs)
+-------------------------+
| CODE (load image)       |   132,709 bytes; the always-resident code
+-------------------------+
| Stack segment           |   4,096 bytes; relocated by cstart
+-------------------------+ ← PSP segment
| PSP                     |   DOS Program Segment Prefix
+-------------------------+
```

The 362,201-byte overlay region holds 250 RTLink "Virtual Pages" (VPs),
swapped into a fixed buffer in conventional memory (or paged through
EMS/XMS if available) on demand.

## Boot sequence

1. **DOS loader** loads the 132 KB load image at the PSP+10h.
2. **Entry point** at MZ header's `e_cs:e_ip = 110D:071D` (file 0x13BED).
3. **`entry_point`** (10 bytes) immediately:
   - LCALL `system_init` (file 0x13BF7)
   - LJMP `dos_version_check_stub` (file 0x0F720)
4. **`system_init`** (1,368 bytes): probes EMS/XMS, allocates heap,
   shrinks the program block via `INT 21h AH=4Ah`, hooks env-var INT 21h.
5. **`dos_version_check_stub`** (13 bytes): if DOS < 2.0, terminate.
   Otherwise fall through to `cstart`.
6. **`cstart`** (182 bytes): C runtime startup. Relocates stack, zeros
   BSS, runs precompiled-init chain (atexit / FPU / setargv), pushes
   argc/argv/envp, calls `_main()` via the overlay thunk at file 0x1A5F0.
7. **`_main()`** is the FIRST overlay-resident function. It loads
   VICEROY.PAL, ICONS.SS, and the other always-needed assets, then
   enters the title-screen state machine.

@ref `../src/boot/entry.c`, `../src/runtime/cstart.c`

## RTLink Plus overlay system

The 250 virtual pages are addressable through 1,020 thunks at file
0x1A5F0..0x1D5E6 (12,278 bytes; 82 distinct overlay segments). Each
thunk has the format documented in `../formats/RTLINK.md`.

When a thunk is called for the first time:
1. The runtime entry stub (0x1427B for type-A, 0x14261 for type-B) is
   reached via the LCALL embedded in the thunk.
2. The runtime checks if the requested segment is currently resident.
3. If not, it pages in from VICEROY.EXE on disk (or EMS/XMS if cached).
4. The thunk's LJMP placeholder is patched to jump straight to the now-
   resident segment.
5. Subsequent calls bypass the runtime and jump straight through the
   patched LJMP.

This mechanism is what allows VICEROY.EXE to ship 362 KB of overlay code
in a 640 KB DOS environment.

@ref `../src/overlay/rtlink.c`, `../formats/RTLINK.md`

## Game loop (top level)

```
main():
    load_palette("VICEROY.PAL")
    load_sprite_sheet("ICONS.SS")
    load_sprite_sheet("PHYS0.SS")
    load_sprite_sheet("BUILDING.SS")
    load_sprite_sheet("TERRAIN.SS")
    load_sprite_sheet("WOODFRAM.SS")
    load_sprite_sheet("WOODTILE.SS")
    load_text_resource("NAMES.TXT")
    load_text_resource("GAME.TXT")
    load_text_resource("MENU.TXT")
    load_text_resource("LABELS.TXT")
    init_player_state()
    
    show_title_screen()          // see src/ui/title_screen.c
    
    while game_running:
        if difficulty_chosen:
            load_map("AMER2.MP") // or generate if random
            place_starting_units()
            
            while not game_over:
                process_player_input()
                if turn_ended:
                    end_of_turn_processing()
                    increment_year()
                    european_market_tick()
                    ai_dispatch_per_power()
                    random_events_tick()
                    
        if revolution_won or king_won:
            show_endgame_screen()
            update_high_scores()
            chain_to_CLOSING_EXE()
```

## Game systems documented separately

Each major subsystem has its own document under `viceroy_source/docs/`:

- [`DATA_MODEL.md`](DATA_MODEL.md) — every struct + its byte layout
- [`MAP_SYSTEM.md`](MAP_SYSTEM.md) — terrain, features, resources
- [`COLONY_SYSTEM.md`](COLONY_SYSTEM.md) — colonies, production, buildings
- [`UNIT_SYSTEM.md`](UNIT_SYSTEM.md) — units, types, movement, cargo
- [`COMBAT.md`](COMBAT.md) — combat resolution, REF, militia
- [`AI_SYSTEM.md`](AI_SYSTEM.md) — AI driver, personality, strategy
- [`NATIVE_RELATIONS.md`](NATIVE_RELATIONS.md) — tribes, missions, attacks
- [`EUROPEAN_DIPLOMACY.md`](EUROPEAN_DIPLOMACY.md) — treaties, war/peace
- [`KING_TAX.md`](KING_TAX.md) — king's demands, tea-party, REF buildup
- [`REVOLUTION.md`](REVOLUTION.md) — declaration, war of independence
- [`FOUNDING_FATHERS.md`](FOUNDING_FATHERS.md) — recruitment + effects
- [`RANDOM_EVENTS.md`](RANDOM_EVENTS.md) — Lost City Rumors, weather, etc.
- [`MAP_GENERATION.md`](MAP_GENERATION.md) — procedural map algorithm
- [`SCORING.md`](SCORING.md) — final score formula
- [`RENDER_CHAIN.md`](RENDER_CHAIN.md) — pixel pipeline + tile draw chain
- [`ASSET_ROLES.md`](ASSET_ROLES.md) — every asset cross-referenced
- [`RTLINK_OVERLAYS.md`](RTLINK_OVERLAYS.md) — full RTLink format spec
- [`ENGINE.md`](ENGINE.md) — madsdev.lib API surface

@ref `../../COLONIZATION_TECHNICAL_REFERENCE.md` for the cross-validated
     accumulated knowledge document this is summarised from.
