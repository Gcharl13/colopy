; MAPEDIT.EXE named disasm — module mouse_2.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mouse_in_box  file 0x00D810..0x00D83A  seg 0xC21:0x0  (mouse_2.c.obj) ----
  00D810  55               push bp
  00D811  8bec             mov bp, sp
  00D813  8b0e2407         mov cx, word ptr [0x724]
  00D817  3bc1             cmp ax, cx
  00D819  7f19             jg 0xd834
  00D81B  3bd9             cmp bx, cx
  00D81D  7c15             jl 0xd834
  00D81F  8b1e2607         mov bx, word ptr [0x726]
  00D823  3bd3             cmp dx, bx
  00D825  7f0d             jg 0xd834
  00D827  395e06           cmp word ptr [bp + 6], bx
  00D82A  7c08             jl 0xd834
  00D82C  b80100           mov ax, 1
  00D82F  c9               leave
  00D830  ca0200           retf 2
  00D833  90               nop
  00D834  2bc0             sub ax, ax
  00D836  c9               leave
  00D837  ca0200           retf 2

; ---- @mouse_init_cycle  file 0x00D83A..0x00D852  seg 0xC21:0x2a  (mouse_2.c.obj) ----
  00D83A  b8ffff           mov ax, 0xffff
  00D83D  a33407           mov word ptr [0x734], ax
  00D840  a33607           mov word ptr [0x736], ax
  00D843  a12207           mov ax, word ptr [0x722]
  00D846  a32a07           mov word ptr [0x72a], ax
  00D849  2bc0             sub ax, ax
  00D84B  a32e07           mov word ptr [0x72e], ax
  00D84E  a32807           mov word ptr [0x728], ax
  00D851  cb               retf

; ---- @mouse_begin_cycle  file 0x00D852..0x00D920  seg 0xC21:0x42  (mouse_2.c.obj) ----
  00D852  55               push bp
  00D853  8bec             mov bp, sp
  00D855  0bc0             or ax, ax
  00D857  7405             je 0xd85e
  00D859  9a8a03650f       lcall 0xf65, 0x38a
  00D85E  a12407           mov ax, word ptr [0x724]
  00D861  a33407           mov word ptr [0x734], ax
  00D864  a12607           mov ax, word ptr [0x726]
  00D867  a33607           mov word ptr [0x736], ax
  00D86A  682607           push 0x726
  00D86D  682407           push 0x724
  00D870  9a7c05650f       lcall 0xf65, 0x57c
  00D875  8be5             mov sp, bp
  00D877  a32207           mov word ptr [0x722], ax
  00D87A  9a0600180d       lcall 0xd18, 6
  00D87F  a33807           mov word ptr [0x738], ax
  00D882  89163a07         mov word ptr [0x73a], dx
  00D886  8b1e2207         mov bx, word ptr [0x722]
  00D88A  833e2e0700       cmp word ptr [0x72e], 0
  00D88F  740d             je 0xd89e
  00D891  0bdb             or bx, bx
  00D893  7509             jne 0xd89e
  00D895  c70630070100     mov word ptr [0x730], 1
  00D89B  eb07             jmp 0xd8a4
  00D89D  90               nop
  00D89E  c70630070000     mov word ptr [0x730], 0
  00D8A4  0bdb             or bx, bx
  00D8A6  740c             je 0xd8b4
  00D8A8  833e2a0700       cmp word ptr [0x72a], 0
  00D8AD  7505             jne 0xd8b4
  00D8AF  ba0100           mov dx, 1
  00D8B2  eb02             jmp 0xd8b6
  00D8B4  2bd2             sub dx, dx
  00D8B6  891e2a07         mov word ptr [0x72a], bx
  00D8BA  0bdb             or bx, bx
  00D8BC  7504             jne 0xd8c2
  00D8BE  891e2e07         mov word ptr [0x72e], bx
  00D8C2  a12407           mov ax, word ptr [0x724]
  00D8C5  39063407         cmp word ptr [0x734], ax
  00D8C9  7519             jne 0xd8e4
  00D8CB  a12607           mov ax, word ptr [0x726]
  00D8CE  39063607         cmp word ptr [0x736], ax
  00D8D2  7510             jne 0xd8e4
  00D8D4  0bd2             or dx, dx
  00D8D6  750c             jne 0xd8e4
  00D8D8  39163007         cmp word ptr [0x730], dx
  00D8DC  7506             jne 0xd8e4
  00D8DE  89162c07         mov word ptr [0x72c], dx
  00D8E2  eb06             jmp 0xd8ea
  00D8E4  c7062c070100     mov word ptr [0x72c], 1
  00D8EA  89162807         mov word ptr [0x728], dx
  00D8EE  0bd2             or dx, dx
  00D8F0  7415             je 0xd907
  00D8F2  c7062e07ffff     mov word ptr [0x72e], 0xffff
  00D8F8  8ac3             mov al, bl
  00D8FA  250100           and ax, 1
  00D8FD  3d0100           cmp ax, 1
  00D900  1bc0             sbb ax, ax
  00D902  f7d8             neg ax
  00D904  a32007           mov word ptr [0x720], ax
  00D907  0bdb             or bx, bx
  00D909  750d             jne 0xd918
  00D90B  391e3007         cmp word ptr [0x730], bx
  00D90F  7507             jne 0xd918
  00D911  891e3207         mov word ptr [0x732], bx
  00D915  c9               leave
  00D916  cb               retf
  00D917  90               nop
  00D918  c70632070100     mov word ptr [0x732], 1
  00D91E  c9               leave
  00D91F  cb               retf

; ---- @mouse_end_cycle  file 0x00D920..0x00D94C  seg 0xC21:0x110  (mouse_2.c.obj) ----
  00D920  55               push bp
  00D921  8bec             mov bp, sp
  00D923  56               push si
  00D924  8bf2             mov si, dx
  00D926  0bc0             or ax, ax
  00D928  740a             je 0xd934
  00D92A  6aff             push -1
  00D92C  9ac302650f       lcall 0xf65, 0x2c3
  00D931  83c402           add sp, 2
  00D934  0bf6             or si, si
  00D936  7411             je 0xd949
  00D938  9a0600180d       lcall 0xd18, 6
  00D93D  3b063807         cmp ax, word ptr [0x738]
  00D941  7506             jne 0xd949
  00D943  3b163a07         cmp dx, word ptr [0x73a]
  00D947  74ef             je 0xd938
  00D949  5e               pop si
  00D94A  c9               leave
  00D94B  cb               retf
