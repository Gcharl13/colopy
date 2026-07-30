; MAPEDIT.EXE named disasm — module xms_6.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @xms_get  file 0x013EB4..0x013EF0  seg 0x128B:0x4  (xms_6.c.obj) ----
  013EB4  55               push bp
  013EB5  8bec             mov bp, sp
  013EB7  52               push dx
  013EB8  50               push ax
  013EB9  eb2f             jmp 0x13eea
  013EBB  a1683c           mov ax, word ptr [0x3c68]
  013EBE  0bc0             or ax, ax
  013EC0  7428             je 0x13eea
  013EC2  8b46fc           mov ax, word ptr [bp - 4]
  013EC5  8b56fe           mov dx, word ptr [bp - 2]
  013EC8  2d0100           sub ax, 1
  013ECB  83da00           sbb dx, 0
  013ECE  b90004           mov cx, 0x400
  013ED1  f7f1             div cx
  013ED3  050100           add ax, 1
  013ED6  83d200           adc dx, 0
  013ED9  8bd0             mov dx, ax
  013EDB  b409             mov ah, 9
  013EDD  ff1e6c3c         lcall [0x3c6c]
  013EE1  0bc0             or ax, ax
  013EE3  7405             je 0x13eea
  013EE5  8bc2             mov ax, dx
  013EE7  c9               leave
  013EE8  cb               retf
  013EE9  90               nop
  013EEA  b8ffff           mov ax, 0xffff
  013EED  c9               leave
  013EEE  cb               retf
  013EEF  90               nop

; ---- @xms_free  file 0x013EF0..0x013F06  seg 0x128B:0x40  (xms_6.c.obj) ----
  013EF0  55               push bp
  013EF1  8bec             mov bp, sp
  013EF3  50               push ax
  013EF4  a1683c           mov ax, word ptr [0x3c68]
  013EF7  0bc0             or ax, ax
  013EF9  7409             je 0x13f04
  013EFB  8b56fe           mov dx, word ptr [bp - 2]
  013EFE  b40a             mov ah, 0xa
  013F00  ff1e6c3c         lcall [0x3c6c]
  013F04  c9               leave
  013F05  cb               retf
