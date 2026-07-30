; MAPEDIT.EXE named disasm — module buffer_b.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_draw_box  file 0x00DE6C..0x00DF10  seg 0xC86:0xc  (buffer_b.c.obj) ----
  00DE6C  55               push bp
  00DE6D  8bec             mov bp, sp
  00DE6F  53               push bx
  00DE70  52               push dx
  00DE71  50               push ax
  00DE72  3bd8             cmp bx, ax
  00DE74  7d0a             jge 0xde80
  00DE76  8bd0             mov dx, ax
  00DE78  8bc3             mov ax, bx
  00DE7A  8946fa           mov word ptr [bp - 6], ax
  00DE7D  8956fe           mov word ptr [bp - 2], dx
  00DE80  8b46fc           mov ax, word ptr [bp - 4]
  00DE83  394608           cmp word ptr [bp + 8], ax
  00DE86  7d0b             jge 0xde93
  00DE88  8bd0             mov dx, ax
  00DE8A  8b4608           mov ax, word ptr [bp + 8]
  00DE8D  8946fc           mov word ptr [bp - 4], ax
  00DE90  895608           mov word ptr [bp + 8], dx
  00DE93  ff7610           push word ptr [bp + 0x10]
  00DE96  ff760e           push word ptr [bp + 0xe]
  00DE99  ff760c           push word ptr [bp + 0xc]
  00DE9C  ff760a           push word ptr [bp + 0xa]
  00DE9F  8a4606           mov al, byte ptr [bp + 6]
  00DEA2  50               push ax
  00DEA3  8b46fa           mov ax, word ptr [bp - 6]
  00DEA6  8b56fe           mov dx, word ptr [bp - 2]
  00DEA9  8b5efc           mov bx, word ptr [bp - 4]
  00DEAC  9a0600790c       lcall 0xc79, 6
  00DEB1  ff7610           push word ptr [bp + 0x10]
  00DEB4  ff760e           push word ptr [bp + 0xe]
  00DEB7  ff760c           push word ptr [bp + 0xc]
  00DEBA  ff760a           push word ptr [bp + 0xa]
  00DEBD  8a4606           mov al, byte ptr [bp + 6]
  00DEC0  50               push ax
  00DEC1  8b46fa           mov ax, word ptr [bp - 6]
  00DEC4  8b56fe           mov dx, word ptr [bp - 2]
  00DEC7  8b5e08           mov bx, word ptr [bp + 8]
  00DECA  9a0600790c       lcall 0xc79, 6
  00DECF  ff7610           push word ptr [bp + 0x10]
  00DED2  ff760e           push word ptr [bp + 0xe]
  00DED5  ff760c           push word ptr [bp + 0xc]
  00DED8  ff760a           push word ptr [bp + 0xa]
  00DEDB  8a4606           mov al, byte ptr [bp + 6]
  00DEDE  50               push ax
  00DEDF  8b46fa           mov ax, word ptr [bp - 6]
  00DEE2  8b56fc           mov dx, word ptr [bp - 4]
  00DEE5  8b5e08           mov bx, word ptr [bp + 8]
  00DEE8  9a0000800c       lcall 0xc80, 0
  00DEED  ff7610           push word ptr [bp + 0x10]
  00DEF0  ff760e           push word ptr [bp + 0xe]
  00DEF3  ff760c           push word ptr [bp + 0xc]
  00DEF6  ff760a           push word ptr [bp + 0xa]
  00DEF9  8a4606           mov al, byte ptr [bp + 6]
  00DEFC  50               push ax
  00DEFD  8b46fe           mov ax, word ptr [bp - 2]
  00DF00  8b56fc           mov dx, word ptr [bp - 4]
  00DF03  8b5e08           mov bx, word ptr [bp + 8]
  00DF06  9a0000800c       lcall 0xc80, 0
  00DF0B  c9               leave
  00DF0C  ca0c00           retf 0xc
  00DF0F  90               nop
