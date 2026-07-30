; MAPEDIT.EXE named disasm — module XMS_7.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _xms_copy  file 0x014A34..0x014A5A  seg 0x1343:0x4  (XMS_7.C.obj) ----
  014A34  55               push bp
  014A35  8bec             mov bp, sp
  014A37  56               push si
  014A38  a1683c           mov ax, word ptr [0x3c68]
  014A3B  0bc0             or ax, ax
  014A3D  7415             je 0x14a54
  014A3F  be0600           mov si, 6
  014A42  03f5             add si, bp
  014A44  b40b             mov ah, 0xb
  014A46  ff1e6c3c         lcall [0x3c6c]
  014A4A  0bc0             or ax, ax
  014A4C  7406             je 0x14a54
  014A4E  33c0             xor ax, ax
  014A50  5e               pop si
  014A51  c9               leave
  014A52  cb               retf
  014A53  90               nop
  014A54  b8ffff           mov ax, 0xffff
  014A57  5e               pop si
  014A58  c9               leave
  014A59  cb               retf
