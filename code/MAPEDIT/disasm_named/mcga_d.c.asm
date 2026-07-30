; MAPEDIT.EXE named disasm — module mcga_d.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _MCGA_SHAKE  file 0x0140DC..0x014100  seg 0x12AD:0xc  (mcga_d.c.obj) ----
  0140DC  55               push bp
  0140DD  8bec             mov bp, sp
  0140DF  a11045           mov ax, word ptr [0x4510]
  0140E2  c1e002           shl ax, 2
  0140E5  03061045         add ax, word ptr [0x4510]
  0140E9  40               inc ax
  0140EA  a31045           mov word ptr [0x4510], ax
  0140ED  80e403           and ah, 3
  0140F0  ff0e0e45         dec word ptr [0x450e]
  0140F4  7502             jne 0x140f8
  0140F6  32e4             xor ah, ah
  0140F8  bad403           mov dx, 0x3d4
  0140FB  b00d             mov al, 0xd
  0140FD  ef               out dx, ax
  0140FE  c9               leave
  0140FF  cb               retf
