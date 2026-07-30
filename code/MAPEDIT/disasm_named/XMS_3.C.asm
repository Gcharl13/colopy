; MAPEDIT.EXE named disasm — module XMS_3.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _xms_umb_get  file 0x013E18..0x013E5A  seg 0x1281:0x8  (XMS_3.C.obj) ----
  013E18  55               push bp
  013E19  8bec             mov bp, sp
  013E1B  33c0             xor ax, ax
  013E1D  33d2             xor dx, dx
  013E1F  8b1ef644         mov bx, word ptr [0x44f6]
  013E23  83fb10           cmp bx, 0x10
  013E26  7d2f             jge 0x13e57
  013E28  8b4606           mov ax, word ptr [bp + 6]
  013E2B  48               dec ax
  013E2C  c1e804           shr ax, 4
  013E2F  40               inc ax
  013E30  8b5608           mov dx, word ptr [bp + 8]
  013E33  c1e20c           shl dx, 0xc
  013E36  03d0             add dx, ax
  013E38  b410             mov ah, 0x10
  013E3A  ff1e6c3c         lcall [0x3c6c]
  013E3E  33d2             xor dx, dx
  013E40  0ac0             or al, al
  013E42  7413             je 0x13e57
  013E44  8bd3             mov dx, bx
  013E46  33c0             xor ax, ax
  013E48  8b1ef644         mov bx, word ptr [0x44f6]
  013E4C  ff06f644         inc word ptr [0x44f6]
  013E50  c1e302           shl bx, 2
  013E53  8997ac5a         mov word ptr [bx + 0x5aac], dx
  013E57  c9               leave
  013E58  cb               retf
  013E59  90               nop

; ---- _xms_umb_free  file 0x013E5A..0x013E90  seg 0x1281:0x4a  (XMS_3.C.obj) ----
  013E5A  55               push bp
  013E5B  8bec             mov bp, sp
  013E5D  8b5608           mov dx, word ptr [bp + 8]
  013E60  bbac5a           mov bx, 0x5aac
  013E63  8b0ef644         mov cx, word ptr [0x44f6]
  013E67  e31e             jcxz 0x13e87
  013E69  8b07             mov ax, word ptr [bx]
  013E6B  3bc2             cmp ax, dx
  013E6D  7407             je 0x13e76
  013E6F  83c302           add bx, 2
  013E72  e2f5             loop 0x13e69
  013E74  eb11             jmp 0x13e87
  013E76  49               dec cx
  013E77  e30a             jcxz 0x13e83
  013E79  8b4702           mov ax, word ptr [bx + 2]
  013E7C  8907             mov word ptr [bx], ax
  013E7E  83c302           add bx, 2
  013E81  e2f6             loop 0x13e79
  013E83  ff0ef644         dec word ptr [0x44f6]
  013E87  b411             mov ah, 0x11
  013E89  ff1e6c3c         lcall [0x3c6c]
  013E8D  c9               leave
  013E8E  cb               retf
  013E8F  90               nop
