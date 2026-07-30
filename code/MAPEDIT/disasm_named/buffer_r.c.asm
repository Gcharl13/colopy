; MAPEDIT.EXE named disasm — module buffer_r.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_to_disk  file 0x01185C..0x01193A  seg 0x1025:0xc  (buffer_r.c.obj) ----
  01185C  c82c0000         enter 0x2c, 0
  011860  52               push dx
  011861  50               push ax
  011862  53               push bx
  011863  57               push di
  011864  56               push si
  011865  c746fcffff       mov word ptr [bp - 4], 0xffff
  01186A  c746fe0000       mov word ptr [bp - 2], 0
  01186F  2bf6             sub si, si
  011871  8bfe             mov di, si
  011873  a0f443           mov al, byte ptr [0x43f4]
  011876  2ae4             sub ah, ah
  011878  40               inc ax
  011879  b90a00           mov cx, 0xa
  01187C  99               cdq
  01187D  f7f9             idiv cx
  01187F  8816f443         mov byte ptr [0x43f4], dl
  011883  68ec43           push 0x43ec
  011886  8d46d4           lea ax, [bp - 0x2c]
  011889  50               push ax
  01188A  9a26068813       lcall 0x1388, 0x626
  01188F  83c404           add sp, 4
  011892  8d46d4           lea ax, [bp - 0x2c]
  011895  16               push ss
  011896  50               push ax
  011897  a0f443           mov al, byte ptr [0x43f4]
  01189A  2ae4             sub ah, ah
  01189C  ba0100           mov dx, 1
  01189F  9a0c009702       lcall 0x297, 0xc
  0118A4  8a1ef443         mov bl, byte ptr [0x43f4]
  0118A8  2aff             sub bh, bh
  0118AA  38bff643         cmp byte ptr [bx + 0x43f6], bh
  0118AE  7506             jne 0x118b6
  0118B0  beffff           mov si, 0xffff
  0118B3  eb0d             jmp 0x118c2
  0118B5  90               nop
  0118B6  47               inc di
  0118B7  83ff0a           cmp di, 0xa
  0118BA  7e06             jle 0x118c2
  0118BC  8b7efe           mov di, word ptr [bp - 2]
  0118BF  eb62             jmp 0x11923
  0118C1  90               nop
  0118C2  0bf6             or si, si
  0118C4  74ad             je 0x11873
  0118C6  8a1ef443         mov bl, byte ptr [0x43f4]
  0118CA  2aff             sub bh, bh
  0118CC  c687f643ff       mov byte ptr [bx + 0x43f6], 0xff
  0118D1  68e843           push 0x43e8
  0118D4  8d46d4           lea ax, [bp - 0x2c]
  0118D7  50               push ax
  0118D8  9aa8038813       lcall 0x1388, 0x3a8
  0118DD  83c404           add sp, 4
  0118E0  8bf8             mov di, ax
  0118E2  0bff             or di, di
  0118E4  743d             je 0x11923
  0118E6  2bf6             sub si, si
  0118E8  397606           cmp word ptr [bp + 6], si
  0118EB  7e2e             jle 0x1191b
  0118ED  897efe           mov word ptr [bp - 2], di
  0118F0  8b56d2           mov dx, word ptr [bp - 0x2e]
  0118F3  03d6             add dx, si
  0118F5  8b5ece           mov bx, word ptr [bp - 0x32]
  0118F8  8b46d0           mov ax, word ptr [bp - 0x30]
  0118FB  9a0000910c       lcall 0xc91, 0
  011900  52               push dx
  011901  50               push ax
  011902  6a00             push 0
  011904  6a01             push 1
  011906  8b4608           mov ax, word ptr [bp + 8]
  011909  99               cdq
  01190A  8bdf             mov bx, di
  01190C  9a0800ea0b       lcall 0xbea, 8
  011911  0bd0             or dx, ax
  011913  740e             je 0x11923
  011915  46               inc si
  011916  397606           cmp word ptr [bp + 6], si
  011919  7fd5             jg 0x118f0
  01191B  a0f443           mov al, byte ptr [0x43f4]
  01191E  2ae4             sub ah, ah
  011920  8946fc           mov word ptr [bp - 4], ax
  011923  0bff             or di, di
  011925  7409             je 0x11930
  011927  57               push di
  011928  9ac2028813       lcall 0x1388, 0x2c2
  01192D  83c402           add sp, 2
  011930  8b46fc           mov ax, word ptr [bp - 4]
  011933  5e               pop si
  011934  5f               pop di
  011935  c9               leave
  011936  ca0400           retf 4
  011939  90               nop

; ---- @buffer_from_disk  file 0x01193A..0x0119DA  seg 0x1025:0xea  (buffer_r.c.obj) ----
  01193A  c82a0000         enter 0x2a, 0
  01193E  52               push dx
  01193F  50               push ax
  011940  53               push bx
  011941  57               push di
  011942  56               push si
  011943  68ec43           push 0x43ec
  011946  8d46d6           lea ax, [bp - 0x2a]
  011949  50               push ax
  01194A  9a26068813       lcall 0x1388, 0x626
  01194F  83c404           add sp, 4
  011952  8d46d6           lea ax, [bp - 0x2a]
  011955  16               push ss
  011956  50               push ax
  011957  8b46d2           mov ax, word ptr [bp - 0x2e]
  01195A  ba0100           mov dx, 1
  01195D  9a0c009702       lcall 0x297, 0xc
  011962  680044           push 0x4400
  011965  8d46d6           lea ax, [bp - 0x2a]
  011968  50               push ax
  011969  9aa8038813       lcall 0x1388, 0x3a8
  01196E  83c404           add sp, 4
  011971  8bf8             mov di, ax
  011973  0bff             or di, di
  011975  7435             je 0x119ac
  011977  2bf6             sub si, si
  011979  397606           cmp word ptr [bp + 6], si
  01197C  7e2e             jle 0x119ac
  01197E  897efe           mov word ptr [bp - 2], di
  011981  8b560a           mov dx, word ptr [bp + 0xa]
  011984  03d6             add dx, si
  011986  8b5ed0           mov bx, word ptr [bp - 0x30]
  011989  8b460c           mov ax, word ptr [bp + 0xc]
  01198C  9a0000910c       lcall 0xc91, 0
  011991  52               push dx
  011992  50               push ax
  011993  6a00             push 0
  011995  6a01             push 1
  011997  8b4608           mov ax, word ptr [bp + 8]
  01199A  99               cdq
  01199B  8bdf             mov bx, di
  01199D  9a0000ca0b       lcall 0xbca, 0
  0119A2  0bd0             or dx, ax
  0119A4  7406             je 0x119ac
  0119A6  46               inc si
  0119A7  397606           cmp word ptr [bp + 6], si
  0119AA  7fd5             jg 0x11981
  0119AC  0bff             or di, di
  0119AE  7423             je 0x119d3
  0119B0  57               push di
  0119B1  9ac2028813       lcall 0x1388, 0x2c2
  0119B6  83c402           add sp, 2
  0119B9  837ed400         cmp word ptr [bp - 0x2c], 0
  0119BD  7514             jne 0x119d3
  0119BF  8b5ed2           mov bx, word ptr [bp - 0x2e]
  0119C2  c687f64300       mov byte ptr [bx + 0x43f6], 0
  0119C7  8d46d6           lea ax, [bp - 0x2a]
  0119CA  50               push ax
  0119CB  9aa60a8813       lcall 0x1388, 0xaa6
  0119D0  83c402           add sp, 2
  0119D3  5e               pop si
  0119D4  5f               pop di
  0119D5  c9               leave
  0119D6  ca0800           retf 8
  0119D9  90               nop
