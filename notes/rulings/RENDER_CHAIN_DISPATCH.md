# Render-chain sprite-dispatch catalogue
**Source: capstone disassembly of VICEROY.EXE, 2026-04-25**
**Scope: func_O513 (0x681A8) + start of func_O512 (0x67F50)**

## Memory layout (verified)
- `[0xa89f]` — layer 1 raw byte (terrain w/ feature flags). Set at 0x681BA.
- `[0xa8a0]` — layer 3 raw byte (resource/visibility). Set at 0x681CE (out-of-order).
- `[0xa8a1]` — layer 2 raw byte (feature/secondary). Set at 0x681C4.
- `[0xa8a2]` — base terrain (= layer1 & 0x1F). Set at 0x681DD via lcall 0x181f:0x6aa.
- `[0xa89e]` — single-bit mask `1 << (arg+4)` for parameterized layer-3 test. Set at 0x685F9 (func_O514).

## Multi-pass render structure (KEY FINDING)
`func_O513` is called multiple times per tile, parameterized by `bp+6` arg.
The arg picks WHICH bit of layer 3 to test. Each pass draws different overlays:
- arg = 0 → test bit 0x10
- arg = 1 → test bit 0x20
- arg = 2 → test bit 0x40
- arg = 3 → test bit 0x80
- arg < 0 → bypass test (always draw 0x95 if [bp-0x26] != 0)

This means the DOS renderer is MULTI-PASS, not single-pass like our Python.
Our renderer needs to be re-architected to support this.

## Sprite-blit dispatch sites (15 found)

| # | Addr | AX-source | Sprite range | Gate | Citation |
|---|------|-----------|--------------|------|----------|
| 1 | 0x6818F | `add ax, 0x69` | 105 + var | `[bp-0xe] != 0` | 105/106/107 are diffuse-blend sprites — confirmed by SPRITE_CATALOG |
| 2 | 0x68215 | `mov ax, 0x95` | 149 (PHYS0.149) | `[bp-8] != 0` (= layer3 bit set) | PHYS0.149 is brown/earth, NOT dune. Pixel-verified: dominant RGB(117,97,68); 44% opacity |
| 3 | 0x682B5 | `add ax, 0x5a` | 90 + variant | per-terrain center | Per-terrain table at 0x1DB32 |
| 4 | 0x6834C | `add ax, 0x41` | 65 + mask | forest gate | Forest = 0x41 + topology_mask. Note: 0x41 = 65, NOT 64. Off by one vs our renderer |
| 5 | 0x68359 | `mov ax, 0x96` | 150 (NW beach) | `test [0xa89f], 0x40` | **OVERTURNS ruling (h): bit 0x40 = NW beach corner, NOT river** |
| 6 | 0x68387 | `add ax, 0x21 or 0x31` | 33+m or 49+m | `test [0xa8a1], 0x80` | Mountain (clear bit) vs Hills (set bit). Bit 0x80 of LAYER 2 selects |
| 7 | 0x683C6 | `add ax, [bp-0x14]` | variable | computed mask | Topology-based, defaulted to 0xf if zero |
| 8 | 0x683FA | `add ax, 0x5a` | 90 + variant | secondary center variant | |
| 9 | 0x68414 | `mov ax, 0x68` | 104 | lcall returns nonzero | Diffuse blend N |
| 10 | 0x6843E | `mov ax, 0x51` | 81 | road-helper returned 0 | Road row sprite |
| 11 | 0x6845C | `add ax, 0x52` | 82 + mask | road bit-test | Road topology |
| 12 | 0x684EB | `add ax, 0x6d` | 109 + var | indexed lookup at [bx+0x2d24] | Sub-tile coast-related (?) |
| 13 | 0x68510 | `add ax, 0x97` | 151 + idx | (NE/SW/SE beach corner) | `[bp-6]` selects 0/1/2 → sprites 151/152/153 |
| 14 | 0x68592 | `add ax, [bp-0xc]` | variable | base != 0x19 and base != 0x1a | Land-only branch |
| 15 | 0x685D6 | `add ax, 0x5a` | 90 + variant | center fallback | |

## Confidence-graded findings

### HIGH confidence
- **Bit 0x40 of layer 1 = NW beach corner overlay**, NOT river. (overturns ruling h)
- **Forest = sprite 0x41 + 4-bit topology mask** (sprites 65-80, NOT 64-79).
- **Mountain vs Hills = bit 0x80 of layer 2** picks between row 0x21 and row 0x31.
- **Beach corners 150 (NW), 151 (NE), 152 (SW), 153 (SE)** ARE used by DOS in-game render. (overturns 2026-04-22 (r) which removed them based on cc94)
- **Per-terrain center variants at 0x5A + var** ARE drawn by DOS but our renderer doesn't draw them.
- **Roads ARE drawn by DOS at scenario start** (sprite 0x51 at 0x6843E + 0x52+mask at 0x6845C). (overturns 2026-04-22 (d) "no roads at start")
- **Renderer is multi-pass** (called multiple times with different args).

### MEDIUM confidence
- **Sprite 0x95 (PHYS0.149) is some kind of layer-3-bit-conditional overlay** — not sand, not dune. Possibly "depleted mine" or similar.
- **Sub-tile coast sprites at 109-127** (range 0x6D + something) — the long-rumored sub-tile coast system per SPRITE-D.

### LOW confidence
- **Where rivers actually live in the .MP**. Not bit 0x40 (now ruled out). Could be:
  - In a layer/bit we haven't decoded yet
  - Encoded via per-terrain center variants (sprite 0x5A + var with specific variant numbers)
  - Stored in a different sprite range (perhaps the sub-tile sprites at 109-127)
  - Need additional dos-disassembler pass to pin down
- **Resource sprite mapping** — table not yet found in this trace; need deeper dispatch tracing.

## Ruling impact

This trace OVERTURNS:
- **Ruling (h)** 2026-04-22: "bit 0x40 = river"
  → Bit 0x40 of layer 1 = NW beach corner overlay flag.
- **Ruling (r)** 2026-04-22: "remove beach corner sprites 150-153, cc94 doesn't use them"
  → DOS in-game DOES use them, gated on layer-1 bit-flags.
- **Ruling (d)** 2026-04-22: "no roads at scenario start"
  → DOS DOES draw roads at scenario start (sprites 0x51, 0x52+mask).
- **SPRITE_CATALOG entry for PHYS0.149** "sandy vertical dune pattern, desert texture"
  → Pixel inspection: brown/earth tones, 44% opacity. Some kind of overlay, not dune.

## Renderer changes implied

1. **Remove the "river" block at colonize_sdl/main.py:3066-3112** — bit 0x40 isn't river.
   In its place: re-enable beach-corner-150 rendering on tiles with layer-1 bit 0x40 set.
2. **Re-enable beach corners 150-153** at land tiles with appropriate layer-flag bits.
3. **Re-enable road rendering** from .MP scenario data (sprite 0x51 + 0x52+mask).
4. **Add per-terrain center variant blit** (sprite 0x5A + variant from table 0x1DB32).
5. **Architect for multi-pass** — currently the Python does single-pass. DOS does multi-pass.
6. **Update SPRITE_CATALOG entry for PHYS0.149** to reflect actual pixel content.

