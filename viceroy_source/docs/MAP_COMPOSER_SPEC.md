# Map-screen composer chain — decode spec (2026-06-10)

Callers found by scanning all thunk records + lcall sites: `map_view_render`
(O514) is reached ONLY via 0x1A1F:0x968 from func_067644; `minimap_panel`
ONLY via 0x1A1F:0x8A4.

## func_067644 — compose_tile_overlays (PORTED; body verified against disasm)
The full viewport composite, in order (args (x0,y0,w,h) = view rect from
0x1A1F:0x914 = func_066E52_clip_window_to_view):
1. `0x1A1F:0x968` map_view_render(rect, layer = [0x53A2]? -1 : [0x5396])
2. `0x191F:0x888` -> file 0x6716A: COLONY pass wrapper (below)
3. `0x191F:0x896` -> file 0x672C8: SETTLEMENT pass (NativeSettlement walk,
   stride 0x12, count [0x539A]; body seen @0x670E6 region: on-screen test,
   fog 0x181F:0x74A, emit 0x181F:0x2B2 = func_003E40)
4. `0x181F:0x32C` -> 0x66EC8 func_066EC8_draw_grid_box_pair (PORTED)
5. `0x181F:0x344` -> 0x6753C func_06753C_draw_own_units_pass (PORTED) = THE
   UNIT-SPRITE PASS
6. `0x181F:0xE38` -> 0x66BB0 func_066BB0_minimap_update (PORTED)
7. optional `0x1A1F:0x8F8` -> 0x6703C func_06703C_draw_grid_box (PORTED)

## func_067700 — compose_active_tile / strategic view (PORTED)
Box 0xCE at ([0x8550],7)-(?, [0x8552]+8); 0x191F:0x2A4 (-> 0x68898
draw_minimap_or_cursor_box, PORTED); the 0x888/0x896 passes; 0x191F:0x296
(-> 0x66F32, NOT ported); 0x1A1F:0x93E (-> 0x6760E, NOT ported); at zoom 3
prints COLONYNAME[player] from [0x5426+player*0x34] via sprintf 0xD1D:0x7E4,
centered with ctx-byte ([0x89E]) metrics.

## func_067182 — colony draw pass body (NOT ported; full transcription)
`(x0@bp6, y0@bp8, w@bpA, h@bpC)`; wrapper 0x6716A pushes view rect
([0x8328],[0x832E],[0x8544],[0x8546]) and near-calls 0x6763A (shared
rect-forwarder).
```
fogmask = 1 << ([0x5396]+4)                       @0x67188
x1 = x0+w-1; y1 = y0+h-1                          @0x67196..0x671A7
0x1A1F:0x906(&x0,&y0,&x1,&y1)                     @0x671BA  (clip to map)
for i=0; i<[0x539E]; i++, rec+=0xCA:              rec base 0x5D46
    x=rec[0], y=rec[1]                            @0x671D9/0x671DF
    if x<x0 || x>x1 || y<y0 || y>y1: continue
    if !0x191F:0x996(i, [0x5396]): continue       (colony known to player?)
    if !(0x181F:0x74A(x,y) & fogmask) && ![0x53A2]: continue   (fog)
    sx = (x-[0x8328]+[0x832A])*[0x5AD4]           @0x67232..0x67240
    sy = (y-[0x832E]+[0x832C])*[0x8326]           @0x67243..0x67251
    f1 = (zoom[0x184]==0 && [0x890]==0)           @0x67254 (two flags, same)
    f2 = same                                     @0x6726F
    0x181F:0x2A8(AX=i, DX=sx, BX=sy, stk: f2,f1,[0x186], clip[0x839E..])
                                                  @0x672AC  (colony blit)
RETF                                              @0x672C7
```

## Leaf blits still to decode (resident; resolve via thunk records)
- 0x181F:0x2A8  colony sprite blit (selects COLONY.SS/BUILDING.SS cell by
  colony size/stockade flags -- the interior decides the sprite)
- 0x181F:0x2B2  settlement blip blit -> file 0x3E40 (func_003E40 PORTED --
  check body for the sprite-index rule)
- 0x191F:0x996  colony-known-to-player test (likely ported load_image)
- 0x1A1F:0x906  rect clip-to-map helper
- 0x6763A       shared rect forwarder; 0x66F32 / 0x6760E strat helpers

## Wiring order (next session)
1. Port func_067182 (+0x6763A wrapper) into src/render/units.c as the colony
   pass; same pattern for the settlement pass body at 0x672C8.
2. Decode 0x181F:0x2A8's interior -> implement its cell selection in glue
   over the registered COLONY/BUILDING sheet (the same flat-cell model as
   TERRAIN was, or directory model like PHYS -- the body will say).
3. Replace the shell's manual ship blit by calling the PORTED
   func_067644_compose_tile_overlays as the frame entry (it already chains
   everything); implement its remaining thunk externs in glue.
4. func_067700 for the strategic zoom + colony name labels.
