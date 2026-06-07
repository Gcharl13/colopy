# AMERICA.MOV — format identification

Source: `COLONIZE/AMERICA.MOV`, 572 bytes.

## Conclusion: NOT a video file.

The size alone disqualifies it (572 bytes can't hold a video). The
extension `.MOV` here means *movement data*, not *movie*. The actual
"loading sequence" the user expects is built from these separate
pieces, none of which is `.MOV`:

| Asset                | Type     | Where                                     |
|----------------------|----------|-------------------------------------------|
| MicroProse logo anim | 33 frames| `extracted/assets/sprites/MPSLOGO/`       |
| MicroProse name anim | 59 frames| `extracted/assets/sprites/MPSNAME/`       |
| Title panorama       | 960×132  | `extracted/assets/backgrounds/OPENING.PIK`|
| Title border         | 320×200  | `OPENBORD.PIK`                            |
| Main menu BG         | 320×200  | `OPENMENU.PIK`                            |
| Difficulty woodcuts  | 10×320×200 | `LEVN0001.PIK..LEVN0010.PIK`            |

## What AMERICA.MOV actually contains (hypothesis)

572 bytes of mostly-zero data with a band of 0xFF-rich rows in the
middle and a tail of 16-bit LE pairs at offset 0x220:

```
0220: f5 01 08 00 00 00 03 00 09 00 03 00 03 00 02 00
0230: 02 00 02 00 03 00 02 00 00 00 00 00
```

The `(0x01F5, 0x0008, 0x0000, 0x0003, 0x0009, …)` pattern looks like
coordinate / delta-pair data — most likely the **discovery-route
animation deltas** that get drawn over `OPENING.PIK` (the panoramic
world map) to show European exploration routes as animated trails.

The 0x00..0x21F bytes look like 1-bpp glyph or trail rendering buffer.

## Status

Identified as **not-a-video**. No decoder needed for `.MOV`.
Task #64 ("AMERICA.MOV intro video playback") needs to be reframed
as "Wire intro sequence: MPSLOGO/MPSNAME → OPENING.PIK → OPENMENU.PIK"
where AMERICA.MOV is consumed as overlay-data, not as a movie stream.
A future session can take a focused disassembly pass on whatever
function loads `AMERICA.MOV` to confirm the route-deltas hypothesis.
