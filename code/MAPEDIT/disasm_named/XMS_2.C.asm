; MAPEDIT.EXE named disasm — module XMS_2.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _xms_umb_get_avail  file 0x013DEC..0x013E18  seg 0x127E:0xc  (XMS_2.C.obj) ----
  013DEC  55               push bp
  013DED  8bec             mov bp, sp
  013DEF  a1683c           mov ax, word ptr [0x3c68]
  013DF2  0bc0             or ax, ax
  013DF4  741c             je 0x13e12
  013DF6  b410             mov ah, 0x10
  013DF8  baffff           mov dx, 0xffff
  013DFB  ff1e6c3c         lcall [0x3c6c]
  013DFF  0ac0             or al, al
  013E01  750f             jne 0x13e12
  013E03  80fbb0           cmp bl, 0xb0
  013E06  750a             jne 0x13e12
  013E08  8bc2             mov ax, dx
  013E0A  c1e004           shl ax, 4
  013E0D  c1ea0c           shr dx, 0xc
  013E10  c9               leave
  013E11  cb               retf
  013E12  33c0             xor ax, ax
  013E14  33d2             xor dx, dx
  013E16  c9               leave
  013E17  cb               retf
