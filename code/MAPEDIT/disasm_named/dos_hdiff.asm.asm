; MAPEDIT.EXE named disasm — module dos_hdiff.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __aFahdiff  file 0x016D4A..0x016D76  seg 0x1388:0x1eca  (dos_hdiff.asm.obj) ----
  016D4A  55               push bp
  016D4B  8bec             mov bp, sp
  016D4D  8b4608           mov ax, word ptr [bp + 8]
  016D50  2b460c           sub ax, word ptr [bp + 0xc]
  016D53  1bd2             sbb dx, dx
  016D55  03c0             add ax, ax
  016D57  13d2             adc dx, dx
  016D59  03c0             add ax, ax
  016D5B  13d2             adc dx, dx
  016D5D  03c0             add ax, ax
  016D5F  13d2             adc dx, dx
  016D61  03c0             add ax, ax
  016D63  13d2             adc dx, dx
  016D65  034606           add ax, word ptr [bp + 6]
  016D68  83d200           adc dx, 0
  016D6B  2b460a           sub ax, word ptr [bp + 0xa]
  016D6E  83da00           sbb dx, 0
  016D71  5d               pop bp
  016D72  ca0800           retf 8
  016D75  00               .byte 0x00
