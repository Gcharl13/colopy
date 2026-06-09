# func_06083A trade_route_edit_screen — full port spec (disasm transcription)

> ROLE CORRECTED 2026-06-10: the @ROUTE label block [0x93DE..] proves this is
> the TRADE ROUTE EDIT screen, not the map chrome. Spec below stands as the
> port reference; the real map chrome composer is still to be located.

From `re_work/disasm/func_06083A.asm` (file 0x06083A..0x060C33, 1017 B).
Local frame: `buf[bp-0x50]` text buffer; locals x/y in bp-0x52..bp-0x60.

## Leaf signatures (MSC hybrid reg+stack, from the push sequences)
| thunk | target | signature (as called here) |
|---|---|---|
| 0x181F:0x484 | func_00DCD4 | region_select(AL=mode, rect4 = [0x2DA8..0x2DAE]) |
| 0x181F:0x022 | (string svc) | str_from_id(id) -> DX:AX far char* |
| 0x181F:0x114 | (text svc) | text_width(DS:lit) -> AX |
| 0x181F:0x178 | func_002D74? | text_reset(&buf) |
| 0x181F:0x16E | func_002992 | text_append_str_id(&buf, id) |
| 0x181F:0x182 | — | text_append_int(ss:&buf, val) |
| 0x181F:0x1DC | — | text_append_char?(&buf) |
| 0x181F:0x13C | func_002B38 | text_row(farstr/ss:&buf, x, y, color) -> end_x |
| 0x181F:0x100 | func_002BC8 | text_centered(farstr/ss:&buf, x, w, y, color) |
| 0x191F:0x8BC | — | hline(0, rect4, AX=x0, DX=x1, BX=y) |
| 0x191F:0x8B2 | — | vline(0, rect4, AX=x, DX=y0, BX=y1) |
| 0x181F:0x254 | file 0xE76A | marker blit: sheet=[0x83E]/[0x840] (UNIT-ICON sheet!), AX=sprite, DX=y, [bp-0x5E]=x, BX=&0x2DA8 |
| 0x181F:0xCE | file 0xE0A2 | box(0, rect4, stk=y1, AX=x0, DX=y0, BX=x1) |
| 0x181F:0xE2 | file 0xDB3A | fill(0, stk={h=0xC8,w=0x140,0}, AX=0,DX=0,BX=0) |
| 0xD1D:0x117E / 0x11B4 | C rt | sprintf(ss:&buf, fmt/str DX:AX) |

## Body, call by call (all coords literal)
1. region_select(0x22, rect[0x2DA8]) @0x06083F
2. s=str_from_id([0x93DE]); sprintf(buf, s); text_reset(buf);
   tile_row = [0x9E14]/0x4A + 1; text_append_int(buf, tile_row) @0x060856..95
3. text_centered(buf, x=0, w=0x140, y=5, color=0xF) @0x060898  (menu strip title)
4. buf=""; append_str_id(buf,[0x93E0]); text_reset;
   endx=text_row(buf, x=0xA, y=0x19, 0xF);
   text_row(farstr=[0x9E14/16] (tile text), x=endx, y=0x19, 0xF) @0x0608AE..FB
5. y2=ctxbyte([0x89E])+0x1B; buf=""; append_str_id(buf,[0x93E2]); reset;
   text_row(buf, 0xA, y2, 0xF) @0x0608FE..3E
6. idx = (tile[0x20]<1) ? [0x93E6] : [0x93E4]  (sbb trick, [bx-0x6C22] table);
   append_str_id(buf, idx); text_row(buf, x=endx(step4), y2, 0xF) @0x060945..7A
7. y3 = 0x37 - ctxbyte; w=text_width(DS:0x1D38)+0xA;
   text_row(str_from_id([0x93E8]), x=w,    y3, 0xF)  @0x06098E..B9   (date)
   text_row(str_from_id([0x93EA]), x=0x7D, y3, 0xF)  @0x0609BC..D6   (turn)
   text_row(str_from_id([0x93EC]), x=0xD0, y3, 0xF)  @0x0609D9..F4   (gold)
8. STACK TABLE: ybase=0x3D; for r=0..4: hline(rect, x0=0, x1=0x13F, y=r*0x14+ybase) @0x060A01..2E;
   vline(rect, x=0x73, y0=0x3D, y1=0x8D); vline(rect, x=0xC6, ...) @0x060A30..72
9. TWO-PASS unit-stack icon columns (pass=[bp-0x58]):
   n=func_061413(pass? 1:0); for r: id=func_06140E(r(+6 right));
   if id>=0: marker-blit sheet [0x83E] sprite id+0x17 at (x=[bp-0x5E]=pass*0x14+0x3D?, y=[bp-0x5C]);
   y += unit_sheet_entry_h(es:[bx+si*12+0x152]) + 2  @0x060A7C..0x060B33
   between passes when tile[0x21]>pass: func_061409(pass); buf="";
   append_int(buf, pass+1); 0x1DC(buf); sprintf_11B4(buf, func_06142C(pass));
   text_row(buf, 0xA, [bp-0x56]+8, 0xF); right col y=0x7D / 0xD0 @0x060B49..C2
10. message box: box(rect, y1=0xBD, x0=0x118, y0=0xAA, x1=0x135) @0x060BC6..E4
11. y4=0xB4-(ctxbyte>>1); text_centered(str_from_id([0x2E16]), x=0x118, w=0x1E, y4, 0xF) @0x060BE9..1B
12. fill(h=0xC8, w=0x140, 0, ax/dx/bx=0) @0x060C1E..2B  (present/finalize region)
RETF

## Data dependencies to light it
- [0x93DE..0x93EC]: label-string IDS (set by the LABELS.TXT loader — port next;
  same section-read pattern as NAMES)
- [0x2DA8..0x2DAE]: chrome clip rect (screen init)
- [0x89E]: text-context byte (font cell height); [0x9E14/16]: current-tile far ptr
- [0x83E/0x840]: UNIT-ICON sheet far ptr (ICONS.SS handle slot — register in glue
  like [0x16C]/[0x174])
- str_from_id (0x181F:0x22) = string-handle service: back it with the GAME.TXT/
  LABELS.TXT loader's interned strings
