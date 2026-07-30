; MAPEDIT.EXE named disasm — module MEM_3.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mem_check_overflow  file 0x014B7E..0x014B96  seg 0x1357:0xe  (MEM_3.C.obj) ----
  014B7E  55               push bp
  014B7F  8bec             mov bp, sp
  014B81  c44606           les ax, ptr [bp + 6]
  014B84  8cc2             mov dx, es
  014B86  0bc0             or ax, ax
  014B88  7907             jns 0x14b91
  014B8A  2d0080           sub ax, 0x8000
  014B8D  81c20008         add dx, 0x800
  014B91  c9               leave
  014B92  ca0400           retf 4
  014B95  90               nop
