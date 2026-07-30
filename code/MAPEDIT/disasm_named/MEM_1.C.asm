; MAPEDIT.EXE named disasm — module MEM_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mem_normalize  file 0x011AF2..0x011B0A  seg 0x104F:0x2  (MEM_1.C.obj) ----
  011AF2  55               push bp
  011AF3  8bec             mov bp, sp
  011AF5  8b4606           mov ax, word ptr [bp + 6]
  011AF8  8b5608           mov dx, word ptr [bp + 8]
  011AFB  8bd8             mov bx, ax
  011AFD  c1eb04           shr bx, 4
  011B00  03d3             add dx, bx
  011B02  250f00           and ax, 0xf
  011B05  c9               leave
  011B06  ca0400           retf 4
  011B09  90               nop
