; MAPEDIT.EXE named disasm — module BUFFER_3.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_fill  file 0x00DA9E..0x00DAC0  seg 0xC49:0xe  (BUFFER_3.C.obj) ----
  00DA9E  55               push bp
  00DA9F  8bec             mov bp, sp
  00DAA1  ff760c           push word ptr [bp + 0xc]
  00DAA4  ff760a           push word ptr [bp + 0xa]
  00DAA7  ff7608           push word ptr [bp + 8]
  00DAAA  ff7606           push word ptr [bp + 6]
  00DAAD  ff7606           push word ptr [bp + 6]
  00DAB0  50               push ax
  00DAB1  2bc0             sub ax, ax
  00DAB3  99               cdq
  00DAB4  8b5e08           mov bx, word ptr [bp + 8]
  00DAB7  9a04005b0c       lcall 0xc5b, 4
  00DABC  c9               leave
  00DABD  ca0800           retf 8
