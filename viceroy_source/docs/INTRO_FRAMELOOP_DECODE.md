# OPENING.EXE frame-loop decode (ROUTE_B Phase 6.4)

Byte-level decode of the `OPENING.EXE` MADS media player's animation loop,
recovered with Ghidra (`x86:LE:16`, MZ loader; 324 functions). This pins the
intro's composition + scheduling so `src/platform/intro_render_glue.c` is a
faithful, data-driven port rather than a guess. All addresses are DGROUP (DS)
offsets in the player.

## Asset facts (decoded via `pik_load`/`ss_load` against the user's files)

| File         | kind  | dims / frames        | role                                   |
|--------------|-------|----------------------|----------------------------------------|
| OPENING.PIK  | PIK   | **960 x 132**        | the wide **voyage-scene panorama**     |
| OPENBORD.PIK | PIK   | 320 x 200            | the border frame around the play window|
| OPENLOGO.SS  | SS    | 1 frame, 276x50      | "Sid Meier's COLONIZATION" title card  |
| OPENSHIP.SS  | SS    | 8 frames, 47x25      | the ship (fixed on screen, scene pans) |
| OPENSUN.SS   | SS    | 7 frames             | sun on the horizon                     |
| OPENWND1/2   | SS    | 10 / ...             | wind gusts                             |
| OPENMON1/2/3 | SS    | 15 / ...             | sea monsters                           |
| OPENFISH.SS  | SS    | 13                   | fish                                   |
| OPENGUY.SS   | SS    | 54                   | the colonist disembarking              |
| OPENBONK.SS  | SS    | 18                   | ship bonking into land                 |
| OPENCRD1/2/3 | SS    | 7 / 7 / 5            | credit-line text strips                |

The earlier assumption "OPENING.PIK = the logo" was wrong: OPENING.PIK is the
**960-wide scrolling sea/sky panorama**; the logo is `OPENLOGO.SS` (series 8),
drawn at the very end (frame 767).

## Call graph

```
FUN_1000_0eac   intro setup: VGA mode 0x13, blank palette (fade-from-black),
  |             preload all series via the loader, then run the player
  |-- FUN_13b1_000a   sprite-series LOADER (one call per series; builds a
  |                   playback struct, frame table from baseX + sheet hints)
  |     handles stored at DGROUP: 0xca,0xce (scene+?), 0x92 (scroll scene),
  |     0x96/0x9a/0x9e (3 credit sheets), 0xa2..0xc8 (10 anim series)
  |-- FUN_1000_0aac   THE FRAME LOOP  (see below)
```

## The frame loop -- `FUN_1000_0aac`

```c
*(u16*)0x4aca = 0x280;          // 640 = scroll range (960 scene - 320 window)
FUN_1000_02e4();                // clear play area (0,0,320,132)
*(u16*)0x5cbe = 7;
do {
    *(u16*)0x4ade = FUN_131b_0006();   // read BIOS tick (far ptr @0x596 = 0040:006C)
    FUN_1000_05f6();                   // credit-line scheduler (window 0x5d14 table)
    if (*(int*)0x82 < 0x1fb) {         // frame 0x82 < 507 ?
        FUN_1000_059a();  FUN_1000_0724();   // scene-then-sprites
    } else {
        FUN_1000_0724();  FUN_1000_059a();   // sprites-then-scene  (Z swap @ 507)
    }
    FUN_1000_053e();                   // scroll-step + scene compose
    FUN_1000_02f6();                   // palette fade / dirty-rect present
    FUN_1000_0922();                   // keyboard + cadence (0x48 ticks/frame)
} while (*(int*)0x8c != 0);            // run-flag; cleared by END marker / key
```

* **Frame counter** `0x82`; **run-flag** `0x8c`.
* **Cadence**: `0x48` = ticks-per-frame against the 18.2 Hz BIOS timer; `+`/`-`
  (and `=`/`_`) adjust it live (`FUN_1000_0922`). ENTER/ESC/SPACE clear `0x8c`.
* **Play area = 320 x 132** (`FUN_1000_02e4` -> `FUN_1000_0260(0,0,0x140,0x84)`),
  drawn at the top-left; `OPENBORD.PIK` frames it.
* **Z-order swaps at frame 507** (`0x1fb`): the scene draws over the sprites in
  the late phase (ship/monsters pass behind the foreground).

## Animation scheduler -- `FUN_1000_0724`

`*(int*)0x46` entries, a **12-byte struct array at `0x4de8`**:

| off | field          | source (OPENING.TXT @OPENING col) |
|-----|----------------|-----------------------------------|
| +0  | series         | series  (-1 = END marker)         |
| +2  | trigger_frame  | frame                             |
| +4  | repeats        | repeats                           |
| +8  | active flag    | (runtime)                         |
| +10 | cur_frame      | (runtime; index into the sheet)   |

Per gated tick (frame++):

```c
if (!active && trigger_frame == frame) {
    if (series < 0)        run_flag(0x8c) = 0;   // END OF DEMO  (frame 891)
    else { active = 1;
           if (series==8) palette_fade_bit(0x5cbe |= 8);  // logo
           if (series==9) flag 0x7c = 1;                  // bonk -> stop scroll
           if (series==7) FUN_177b_0000();                // guy
    }
}
if (active) {
    cur_frame++;
    nframes = handle[+4];                 // handle = *(dword*)(series*4 + 0xa2)
    if (cur_frame > nframes) {
        if (repeats == 0) { cur_frame = nframes;
                            if (series==7) cur_frame = nframes-5; }  // guy holds
        else { repeats--; cur_frame = 1; if (repeats==0) active = 0; }
    }
}
```

## Sprite compositor -- `FUN_1000_042c`

For each active entry, pick the frame index (`cur_frame`), **except series 1
(Sun)** whose frame is hand-keyed to the global frame counter:

```c
idx = 1;
if (frame > 0x86) idx = 2;   if (frame > 0x98) idx = 3;   if (frame > 0xac) idx = 4;
if (frame > 0xc2) idx = 5;   if (frame > 0xdb) idx = 6;   if (frame > 0xeb) idx = 7;
if (frame > 0xfb) idx = 6;   // (1-based; -1 for our 0-based sheets)
```

Then blit `handle + idx*0xc` via `FUN_1392_0000(x, handle)`.

## Scene scroll -- `FUN_1000_036e` / `FUN_1000_059a` / `FUN_1000_053e`

```c
// 036e: draw the 960-wide scene through the 320 window, scrolled
if (flag 0x7c == 0)                                   // until the bonk
    FUN_1392_0000(-(scene.width/2 - scroll_table[0x78]), scene_handle 0x92);
```

`0x78` is the scene's scroll-step index into a per-step X table at `0x4f0e`;
`059a` advances it on its own timer, `053e` decrements the `0x4aca` scroll
budget (640 -> 0). The ship (`OPENSHIP`, all frames at screen x=176) is fixed;
the **scene pans behind it**.

## What this means for the modern renderer

Solidly decoded (now implemented in `intro_render_glue.c`):

* backdrop = **OPENING.PIK 960x132**, viewed through a 320-wide window that
  pans (the scene scrolls, sprites are screen-fixed);
* **event-triggered** scheduling: each series activates at its `trigger_frame`,
  advances its own sheet frame, holds the last frame when `repeats==0` (the guy
  holds `nframes-5`), loops `repeats` times otherwise; series 8 = logo @767,
  series -1 = END @891; the **Sun frame-ladder** is reproduced exactly;
* sprites drawn at their **`.SS` per-frame (x,y)** screen anchors (bottom-center
  registration), clipped to the 320x132 play window; `OPENBORD.PIK` frames it.

Residual (needs a DOSBox runtime trace, not a static decode):

* the exact **scroll-position table** (`0x4f0e`) and the **default cadence**
  (`0x48` ticks/frame) -- the modern pan is a documented linear reconstruction;
* the late-phase **Z-order swap at frame 507** (subtle; the modern renderer
  keeps scene-behind-sprites throughout to avoid hiding sprites);
* the **palette cross-fade** on the logo (`FUN_1373_000a` DAC upload) -- the
  modern renderer sets the scene palette directly.
