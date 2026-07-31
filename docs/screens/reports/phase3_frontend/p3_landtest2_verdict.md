# Phase-3 live test 2 (2026-07-31): crafted-map compositor verdict

Method: crafted 58x72 AMER2.MP (testmap.mp + testmap_layout.json), booted VICEROY
("Start a Game in AMERICA" -> Original Americas), WIN cheat -> Reveal Map ->
Complete Map, View-mode navigation, 5 viewport captures (p3_cap{A,B,C3,D,E}) each
with a same-moment RAM dump (dosmem_cap{A,B,C3,D,E}.bin). Renderer:
hillsrivers_render.py (compositor 1:1 from disasm; live planes from the dumps as
ground truth). Diff vs RGB565'd captures with per-capture water-sparkle phase fit.

## Headline
ALL FIVE captures: **100.0000% non-overlay pixel-exact** (overlay mask = village/
unit tiles + <=2px east sprite overhang + view-cursor box +-2px; masked tiles are
engine OBJECT sprites, not tile compositor output).
raw incl. overlays: A 95.62 / B 95.44 / C 96.94 / D 95.15 / E 98.00 %.

## Verdict per rule class (spec/systems/map_system.md S3 under test)
| rule class | result | live evidence |
|---|---|---|
| hills 0x31+mask (4-card, weights N8/S4/W2/E1) | CONFIRMED | isolated 0x31, pairs 0x32/0x33/0x35/0x39, plus-centre mask15 0x40, 2x2 0x36/0x37/0x3A/0x3B - all pixel-exact (capA) |
| relief adjacency = equal (byte&0xA0) | CONFIRMED | hill-next-to-mountain shows NO connection both ways: hills 0x31 isolated, mtn 0x21 isolated (capA (4..6,11)) |
| mountains 0x21+mask | CONFIRMED | L-blob 0x26/0x23/0x29 (capA) |
| minor river 0x11+mask | CONFIRMED | runs 0x14, corners 0x19/0x1D, T-junction mask11 0x1C, cross 0x15/0x17 (capB) |
| isolated river -> mask 0xF | CONFIRMED | minor 0x20 and major 0x10 both pixel-exact (capB) |
| major river 0x01+mask; major/minor cross-connect via bit 0x40 | CONFIRMED | major run 0x04/0x0B; minor joins major (0x15 at (8,23)) (capE) |
| river mouths: WATER tile with terr&0xC0; base 0x8D (bit7) / 0x91; +d for each cardinal land nb with bit 0x40, non-water | CONFIRMED | minor mouth 0x92+0x93 at (3,20); multi-dir 0x91+0x92 at (3,22); MAJOR mouth 0x8E at (3,24); control ocean+bit-no-land-river draws nothing (2,18); control plain ocean next to land river draws NO mouth (3,26) |
| land river next to plain ocean | CONFIRMED | mask counts only bit-0x40 nbs: (4,26) renders ISOLATED 0x20 despite ocean W |
| coast clean-edge 0x97..0x9A | CONFIRMED | 2x2 lake = all four patterns incl. 0x9A (1-based frame ruling re-proven) |
| coast quadrant fallback 0x6D+code*4+q (8x8 at TL/TR/BR/BL) | CONFIRMED | single-tile lake codes 7,7,7,7 -> 0x89/0x8A/0x8B/0x8C; L-lake mixed codes 0x74..0x8C set (capD) |
| beach-halo ground substitution (last cardinal land, W wins) + water backfill through 0-holes; 0xFD frame px transparent | CONFIRMED | capA/B/D/E coasts pixel-exact incl. FD-transparent px showing substituted ground |
| O512 dither blend (stencils engine 0x69..0x6C; skip when classes equal & nb visible) | CONFIRMED | all biome boundaries + terrain strips pixel-exact |
| forest 0x41+mask; scrub (id&7==1) never connects | CONFIRMED | boreal|scrub pair: boreal 0x41 isolated-mask, scrub no overlay at all (capC (32..33,6)); scrub ground = frame 8 via id 0x11 |
| forest alias ids 16..23 | CONFIRMED (with load-fold) | VICEROY's LOADER folds 16..23 -> 8..15 in the live plane (dump diff); rows y=6 and y=9 render identically |
| terrain-detail 0x5A+v (hash + salt [0x190], DTAB DG:0x192) | CONFIRMED + EXTENDED | v=(x&3)*4+(y&3), h=(3*(y>>2)+(x>>2)-forest+salt)&0xF, ^0xA alt; class for DTAB = **full id decode incl. relief bits -> 27/28** (func_0624E semantics; NEW - old &0x1F reading falsified by mountains showing ore 0x66 / hills rock 0x67). Village-owner gate (func_005F82) and feature-bit2 suppress-unless-12 gate implemented per disasm |
| surf/rumor 0x68 (func_006188) | CONFIRMED + EXTENDED | hash reproduced; NEW gate: continent-plane owner nibble != 0xF suppresses (func_005DF0) - live-verified around villages; 0x68 = the rumor circle sprite, drawn on land path after detail |
| roads 0x51/0x52+d | BYTE-DECODED, pixels blocked | draw @0x68417: gate = FEATURE byte & 0x0A, [0x18E]==0, non-water; mask = 8-dir feature&0x0A (func_067D54); mask==0 -> single 0x51, else ONE FRAME PER SET DIRECTION 0x52+d (NOT 0x51+mask). Not pixel-testable via .MP: loader discards layer-2 (below); in-game only village tiles carry bit 1 (0x02 -> &0x0A != 0) and village sprites cover them |
| shore-hatch 0x96 (feature bit 0x40) | NOT TESTABLE VIA .MP | loader discards layer 2; live feature plane never contains 0x40. Draw sites @0x6834F (land) / @0x68354 (water) remain byte-cited but unexercised |
| feature 0x04 resource via .MP | NOT TESTABLE VIA .MP (same reason); note in-engine semantics INVERTED vs expectation: bit2 SUPPRESSES the hash detail unless tv==12 (-> 0x5A+0) |

## NEW byte/runtime facts (for spec folding)
1. **VICEROY's .MP loader normalizes the map** (live-plane diff vs crafted file):
   rows y=0 and y=H-1 -> Arctic 0x18; columns x=0, x=1 and x=W-1 -> Sea Lane 0x1A
   for y=1..H-2 (overwrites even land!); forest alias ids 16..23 -> id-8.
   Plus 2 singleton mutations ((21,1) grass->0xA4 mtn, (43,68) ocean->0xB9) -
   unexplained, likely a post-load seeding pass; count too small to characterize.
2. **VICEROY discards .MP layer 2 (feature)**: crafted bytes 0x40/0x0A/0x04/0x08/
   0x02/0x01 all read back 0 from the live feature plane [0x160]; the game rebuilds
   it (bit0 unit, bit1 settlement; on water: 0x20/0x04-pattern flags, game-built).
   Layer 3 loads into [0x164] (low nibble continent, high nibble owner; 0xF=none;
   village-owned land gets owner 5..0xA).
3. **Live plane far-ptrs**: [0x15C] terrain / [0x160] feature / [0x164] continent+
   owner / [0x168] flags (low nibble = colony-site value), plane (0,0) at seg
   base+0x10, stride 58. O513's [0xA594]=feature, [0xA598]=terrain, [0xA59C]=fog ptrs.
4. **O512 bounds (thunk 0x181F:0x302)**: engine coord 0 (plane 1) IS in bounds -
   the landtest's lower bound "engine >= 1" is falsified (pixel-proven via the lane
   column: no spurious N/S blends). Upper bound engine W-2 stands.
5. **Detail-band class = full id decode incl. relief** (thunk 0x3E4:0x3A ==
   func_0624E semantics): mountains -> DTAB[27]=12 (ore/gold sprite 0x66), hills ->
   DTAB[28]=13 (rock 0x67); DTAB duplicates entries for raw ids 16..23. DTAB live:
   [0,1,2,3,4,5,6,6, 9,1,8,9,10,10,6,6, (dup), -1(arctic),7(ocean),-1(lane),12,13].
6. **detail/surf full gates** (re-disassembled, detail_helpers.asm):
   func_005F82 = village-owner(-if->=4); func_005DF0 = continent high nibble
   (0xF -> -1); func_006188 suppressed when owner nibble != 0xF; func_0060A0
   suppressed on villages, and feature bit2 -> return (tv==12 ? 0 : none).
7. **Roads**: isolated frame 0x51; connected = per-direction frames 0x52+d
   (d = 8-dir index N,NE,E,SE,S,SW,W,NW), NOT a combined-mask frame. Road band
   is 0x51..0x59 only (0x5A.. is the detail band).
8. **Mouth base select** @0x68524: base = 0x8D if (own terr & 0x80) else 0x91
   ((and 0x80; cmp 1; sbb; and 4; add 0x8D)); loop d=0..3 N,E,S,W; neighbor read
   from terrain plane, must have bit 0x40 AND classify not in {0x19,0x1A}.
9. **Cheat flow live-proven**: Alt-W/I/N enables menu 6; Reveal Map = @SETVIEW row 5
   -> [0x53A2]=1, fog mask [0xA89E] becomes 0 and O513's mask==0 path uses the
   caller arg (=0) -> everything visible; per-tile fog bytes unchanged.
10. Sidebar corroboration: grassland detail-hash hit shows "(Prime Tobacco)" in the
   terrain info - the 0x5A-band hash IS the prime-resource mechanism (procedural,
   not stored).

## Assumption list (residual, all non-load-bearing for the verdict)
- Overlay masks: village/unit/cursor sprites masked from the diff (tile + <=2px
  east overhang; cursor box +-2px). Masked tiles: A15/B16/C10/D16/E7 of 180 each.
- Thunk identities 0x181F:0x718 -> func_0060A0 and 0x75E -> func_006188 taken from
  project rulings (runtime thunk table not statically resolvable); behaviorally
  re-proven by the pixel match.
- func_005BFA bounds inside village_owner: plane 1..W-2/1..H-2 assumed; never
  exercised at borders in view.
- Water-sparkle palette phase fitted per capture (7/5/7/3/6); RGB565 quantization
  (v<<2|v>>4 then 5/6/5 floor) as per prior ruling.
- The two singleton load-time terrain mutations and the exact loader offsets for
  the normalization passes are unlocated in the EXE (runtime diff evidence only).
- Not reached: .MP-driven shore-0x96 / roads / resource-bit pixels (loader
  discards layer 2 - a finding, not a miss); diagonal-lake pair and a few
  south/west test tiles never scrolled into view (equivalent cases covered).

Outputs: testmap.mp, testmap_layout.json, p3_cap*.png, dosmem_cap*.bin,
p3_render_[A-E].png, p3_sidebyside_[A-E].png, hillsrivers_render.png,
hillsrivers_sidebyside.png, p3_tiletrace.json, p3_fit_results.json,
hillsrivers_render.py, o513/o512/analyse/masks/detail_helpers disasm .txt/.asm.
AMER2.MP restored (md5 d21008d2...) in colzip/ and raw/COLONIZE/.
