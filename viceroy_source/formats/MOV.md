# MOV Format — Animation / Cinematic

## File inventory
1 .MOV file in COLONIZE/:
- `AMERICA.MOV` (572 bytes) — opening animation played by OPENING.EXE

## Format

The 572-byte size suggests this is NOT a frame-by-frame video. It's
more likely a sequence of:
- Palette-cycle commands (use existing AMERICA.PIK or similar)
- Sprite-blit commands (move existing sprites around)
- Timing markers
- Sound triggers

This makes AMERICA.MOV more akin to a Sierra-style scripted sequence
than a Smacker/AVI video.

## Suspected format

```
+---------------------------------------------------------------+
| Header (signature not yet decoded)                              |
+---------------------------------------------------------------+
| Sequence of timed commands:                                     |
|   byte cmd                                                       |
|   byte length                                                    |
|   byte[length] params                                            |
| Commands:                                                         |
|   0x00 = end                                                      |
|   0x01 = wait_ticks(N)                                           |
|   0x02 = blit_sprite(sheet_id, sprite_id, x, y)                  |
|   0x03 = palette_set(start, count, rgb_data)                     |
|   0x04 = palette_cycle(start, end, ticks)                        |
|   0x05 = sound_trigger(sample_id)                                |
|   0x06 = text_show(string_id, x, y, color)                       |
|   ... (not yet decoded)                                           |
+---------------------------------------------------------------+
```

## Loader

OPENING.EXE plays AMERICA.MOV and then chains to VICEROY.EXE. The
playback engine is in OPENING.EXE's main code.

OPENING.EXE is a 89,178-byte DOS EXE built with the same Microsoft C
toolchain. It's not yet hand-decoded but the Python port at
`docs/MOV_FORMAT.md` has notes on the format.

## Citations

- @asm_file  not yet decoded (OPENING.EXE's MOV-player main loop)
- @ref       ../../../docs/MOV_FORMAT.md  (existing format notes)
- @ref       ../../../COLONIZE/AMERICA.MOV (the file itself, 572 bytes)
