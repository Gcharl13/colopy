; MAPEDIT.EXE named disasm — module FILEIO_I.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @fileio_add_ext  file 0x00D64E..0x00D69C  seg 0xC04:0xe  (FILEIO_I.C.obj) ----
  00D64E  55               push bp
  00D64F  8bec             mov bp, sp
  00D651  56               push si
  00D652  8b760a           mov si, word ptr [bp + 0xa]
  00D655  6a2e             push 0x2e
  00D657  ff760c           push word ptr [bp + 0xc]
  00D65A  56               push si
  00D65B  9a820d8813       lcall 0x1388, 0xd82
  00D660  83c406           add sp, 6
  00D663  0bd0             or dx, ax
  00D665  7522             jne 0xd689
  00D667  1e               push ds
  00D668  681a07           push 0x71a
  00D66B  ff760c           push word ptr [bp + 0xc]
  00D66E  56               push si
  00D66F  9a220e8813       lcall 0x1388, 0xe22
  00D674  83c408           add sp, 8
  00D677  ff7608           push word ptr [bp + 8]
  00D67A  ff7606           push word ptr [bp + 6]
  00D67D  ff760c           push word ptr [bp + 0xc]
  00D680  56               push si
  00D681  9a220e8813       lcall 0x1388, 0xe22
  00D686  83c408           add sp, 8
  00D689  8b460c           mov ax, word ptr [bp + 0xc]
  00D68C  50               push ax
  00D68D  56               push si
  00D68E  9ab00d8813       lcall 0x1388, 0xdb0
  00D693  83c404           add sp, 4
  00D696  5e               pop si
  00D697  c9               leave
  00D698  ca0800           retf 8
  00D69B  90               nop

; ---- @fileio_new_ext  file 0x00D69C..0x00D714  seg 0xC04:0x5c  (FILEIO_I.C.obj) ----
  00D69C  c8040000         enter 4, 0
  00D6A0  57               push di
  00D6A1  56               push si
  00D6A2  8b4e0a           mov cx, word ptr [bp + 0xa]
  00D6A5  8b760e           mov si, word ptr [bp + 0xe]
  00D6A8  8b460c           mov ax, word ptr [bp + 0xc]
  00D6AB  8b5610           mov dx, word ptr [bp + 0x10]
  00D6AE  3bce             cmp cx, si
  00D6B0  7504             jne 0xd6b6
  00D6B2  3bc2             cmp ax, dx
  00D6B4  740c             je 0xd6c2
  00D6B6  50               push ax
  00D6B7  51               push cx
  00D6B8  52               push dx
  00D6B9  56               push si
  00D6BA  9aec0d8813       lcall 0x1388, 0xdec
  00D6BF  83c408           add sp, 8
  00D6C2  6a2e             push 0x2e
  00D6C4  ff7610           push word ptr [bp + 0x10]
  00D6C7  56               push si
  00D6C8  9a820d8813       lcall 0x1388, 0xd82
  00D6CD  83c406           add sp, 6
  00D6D0  8bf8             mov di, ax
  00D6D2  8956fe           mov word ptr [bp - 2], dx
  00D6D5  0bd0             or dx, ax
  00D6D7  7407             je 0xd6e0
  00D6D9  8e46fe           mov es, word ptr [bp - 2]
  00D6DC  26c60500         mov byte ptr es:[di], 0
  00D6E0  1e               push ds
  00D6E1  681c07           push 0x71c
  00D6E4  8b4610           mov ax, word ptr [bp + 0x10]
  00D6E7  50               push ax
  00D6E8  56               push si
  00D6E9  8bf8             mov di, ax
  00D6EB  9a220e8813       lcall 0x1388, 0xe22
  00D6F0  83c408           add sp, 8
  00D6F3  ff7608           push word ptr [bp + 8]
  00D6F6  ff7606           push word ptr [bp + 6]
  00D6F9  57               push di
  00D6FA  56               push si
  00D6FB  9a220e8813       lcall 0x1388, 0xe22
  00D700  83c408           add sp, 8
  00D703  57               push di
  00D704  56               push si
  00D705  9ab00d8813       lcall 0x1388, 0xdb0
  00D70A  83c404           add sp, 4
  00D70D  5e               pop si
  00D70E  5f               pop di
  00D70F  c9               leave
  00D710  ca0c00           retf 0xc
  00D713  90               nop
