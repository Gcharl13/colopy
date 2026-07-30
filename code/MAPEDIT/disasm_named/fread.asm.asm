; MAPEDIT.EXE named disasm — module fread.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fread  file 0x01523E..0x015322  seg 0x1388:0x3be  (fread.asm.obj) ----
  01523E  55               push bp
  01523F  8bec             mov bp, sp
  015241  83ec04           sub sp, 4
  015244  56               push si
  015245  57               push di
  015246  8b4608           mov ax, word ptr [bp + 8]
  015249  f7660a           mul word ptr [bp + 0xa]
  01524C  8bc8             mov cx, ax
  01524E  e35d             jcxz 0x152ad
  015250  8946fe           mov word ptr [bp - 2], ax
  015253  8b5e06           mov bx, word ptr [bp + 6]
  015256  8b760c           mov si, word ptr [bp + 0xc]
  015259  bf6647           mov di, 0x4766
  01525C  8bc6             mov ax, si
  01525E  2dc646           sub ax, 0x46c6
  015261  03f8             add di, ax
  015263  f644060c         test byte ptr [si + 6], 0xc
  015267  7505             jne 0x1526e
  015269  f60501           test byte ptr [di], 1
  01526C  7405             je 0x15273
  01526E  8b4502           mov ax, word ptr [di + 2]
  015271  eb03             jmp 0x15276
  015273  b80002           mov ax, 0x200
  015276  8946fc           mov word ptr [bp - 4], ax
  015279  f644060c         test byte ptr [si + 6], 0xc
  01527D  7505             jne 0x15284
  01527F  f60501           test byte ptr [di], 1
  015282  742f             je 0x152b3
  015284  8b4402           mov ax, word ptr [si + 2]
  015287  0bc0             or ax, ax
  015289  7428             je 0x152b3
  01528B  3bc1             cmp ax, cx
  01528D  7602             jbe 0x15291
  01528F  8bc1             mov ax, cx
  015291  50               push ax
  015292  53               push bx
  015293  51               push cx
  015294  50               push ax
  015295  ff34             push word ptr [si]
  015297  53               push bx
  015298  0e               push cs
  015299  e8101d           call 0x16fac
  01529C  83c406           add sp, 6
  01529F  59               pop cx
  0152A0  5b               pop bx
  0152A1  58               pop ax
  0152A2  2bc8             sub cx, ax
  0152A4  294402           sub word ptr [si + 2], ax
  0152A7  03d8             add bx, ax
  0152A9  0104             add word ptr [si], ax
  0152AB  eb02             jmp 0x152af
  0152AD  eb6c             jmp 0x1531b
  0152AF  e359             jcxz 0x1530a
  0152B1  ebc6             jmp 0x15279
  0152B3  3b4efc           cmp cx, word ptr [bp - 4]
  0152B6  722d             jb 0x152e5
  0152B8  33d2             xor dx, dx
  0152BA  8bc1             mov ax, cx
  0152BC  f776fc           div word ptr [bp - 4]
  0152BF  8bc1             mov ax, cx
  0152C1  2bc2             sub ax, dx
  0152C3  53               push bx
  0152C4  51               push cx
  0152C5  50               push ax
  0152C6  53               push bx
  0152C7  33c0             xor ax, ax
  0152C9  8a4407           mov al, byte ptr [si + 7]
  0152CC  50               push ax
  0152CD  0e               push cs
  0152CE  e8fb17           call 0x16acc
  0152D1  83c406           add sp, 6
  0152D4  59               pop cx
  0152D5  5b               pop bx
  0152D6  0bc0             or ax, ax
  0152D8  7426             je 0x15300
  0152DA  3dffff           cmp ax, 0xffff
  0152DD  7427             je 0x15306
  0152DF  2bc8             sub cx, ax
  0152E1  03d8             add bx, ax
  0152E3  ebca             jmp 0x152af
  0152E5  53               push bx
  0152E6  51               push cx
  0152E7  56               push si
  0152E8  0e               push cs
  0152E9  e8220e           call 0x1610e
  0152EC  59               pop cx
  0152ED  59               pop cx
  0152EE  5b               pop bx
  0152EF  3dffff           cmp ax, 0xffff
  0152F2  7416             je 0x1530a
  0152F4  8807             mov byte ptr [bx], al
  0152F6  43               inc bx
  0152F7  49               dec cx
  0152F8  8b4502           mov ax, word ptr [di + 2]
  0152FB  8946fc           mov word ptr [bp - 4], ax
  0152FE  ebaf             jmp 0x152af
  015300  804c0610         or byte ptr [si + 6], 0x10
  015304  eb04             jmp 0x1530a
  015306  804c0620         or byte ptr [si + 6], 0x20
  01530A  e30c             jcxz 0x15318
  01530C  8b46fe           mov ax, word ptr [bp - 2]
  01530F  2bc1             sub ax, cx
  015311  33d2             xor dx, dx
  015313  f77608           div word ptr [bp + 8]
  015316  eb03             jmp 0x1531b
  015318  8b460a           mov ax, word ptr [bp + 0xa]
  01531B  5f               pop di
  01531C  5e               pop si
  01531D  8be5             mov sp, bp
  01531F  5d               pop bp
  015320  cb               retf
  015321  00               .byte 0x00
