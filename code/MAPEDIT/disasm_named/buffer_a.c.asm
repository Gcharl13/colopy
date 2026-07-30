; MAPEDIT.EXE named disasm — module buffer_a.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_vline  file 0x00DE00..0x00DE6C  seg 0xC80:0x0  (buffer_a.c.obj) ----
  00DE00  c8060000         enter 6, 0
  00DE04  53               push bx
  00DE05  52               push dx
  00DE06  50               push ax
  00DE07  57               push di
  00DE08  0bc0             or ax, ax
  00DE0A  7c5a             jl 0xde66
  00DE0C  8b460a           mov ax, word ptr [bp + 0xa]
  00DE0F  3946f4           cmp word ptr [bp - 0xc], ax
  00DE12  7d52             jge 0xde66
  00DE14  8bc2             mov ax, dx
  00DE16  0bc0             or ax, ax
  00DE18  7d02             jge 0xde1c
  00DE1A  2bc0             sub ax, ax
  00DE1C  8946f6           mov word ptr [bp - 0xa], ax
  00DE1F  8b4608           mov ax, word ptr [bp + 8]
  00DE22  48               dec ax
  00DE23  3bc3             cmp ax, bx
  00DE25  7e02             jle 0xde29
  00DE27  8bc3             mov ax, bx
  00DE29  8946f8           mov word ptr [bp - 8], ax
  00DE2C  8b460e           mov ax, word ptr [bp + 0xe]
  00DE2F  8946fa           mov word ptr [bp - 6], ax
  00DE32  8b460c           mov ax, word ptr [bp + 0xc]
  00DE35  8946fc           mov word ptr [bp - 4], ax
  00DE38  8b460a           mov ax, word ptr [bp + 0xa]
  00DE3B  8946fe           mov word ptr [bp - 2], ax
  00DE3E  06               push es
  00DE3F  8b46fa           mov ax, word ptr [bp - 6]
  00DE42  8ec0             mov es, ax
  00DE44  8b46fe           mov ax, word ptr [bp - 2]
  00DE47  8b5ef6           mov bx, word ptr [bp - 0xa]
  00DE4A  f7e3             mul bx
  00DE4C  0346f4           add ax, word ptr [bp - 0xc]
  00DE4F  8bf8             mov di, ax
  00DE51  8b4ef8           mov cx, word ptr [bp - 8]
  00DE54  2b4ef6           sub cx, word ptr [bp - 0xa]
  00DE57  41               inc cx
  00DE58  8b5efe           mov bx, word ptr [bp - 2]
  00DE5B  8a4606           mov al, byte ptr [bp + 6]
  00DE5E  268805           mov byte ptr es:[di], al
  00DE61  03fb             add di, bx
  00DE63  e0f9             loopne 0xde5e
  00DE65  07               pop es
  00DE66  5f               pop di
  00DE67  c9               leave
  00DE68  ca0a00           retf 0xa
  00DE6B  90               nop
