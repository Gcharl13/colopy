; MAPEDIT.EXE named disasm — module magic_e.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _magic_hash_color  file 0x0149EA..0x014A34  seg 0x133E:0xa  (magic_e.c.obj) ----
  0149EA  55               push bp
  0149EB  8bec             mov bp, sp
  0149ED  57               push di
  0149EE  56               push si
  0149EF  c47e06           les di, ptr [bp + 6]
  0149F2  33c0             xor ax, ax
  0149F4  268a0d           mov cl, byte ptr es:[di]
  0149F7  32ed             xor ch, ch
  0149F9  8bf1             mov si, cx
  0149FB  c1e105           shl cx, 5
  0149FE  d1e6             shl si, 1
  014A00  03ce             add cx, si
  014A02  d1e6             shl si, 1
  014A04  03ce             add cx, si
  014A06  03c1             add ax, cx
  014A08  268a4d01         mov cl, byte ptr es:[di + 1]
  014A0C  32ed             xor ch, ch
  014A0E  8bf1             mov si, cx
  014A10  c1e106           shl cx, 6
  014A13  c1e602           shl si, 2
  014A16  03ce             add cx, si
  014A18  d1e6             shl si, 1
  014A1A  03ce             add cx, si
  014A1C  03c1             add ax, cx
  014A1E  268a4d02         mov cl, byte ptr es:[di + 2]
  014A22  32ed             xor ch, ch
  014A24  8bf1             mov si, cx
  014A26  c1e104           shl cx, 4
  014A29  d1e6             shl si, 1
  014A2B  2bce             sub cx, si
  014A2D  03c1             add ax, cx
  014A2F  5e               pop si
  014A30  5f               pop di
  014A31  c9               leave
  014A32  cb               retf
  014A33  90               nop
