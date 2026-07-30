; MAPEDIT.EXE named disasm — module fileio_8.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @fileio_fread_f  file 0x00D2A0..0x00D4A8  seg 0xBCA:0x0  (fileio_8.c.obj) ----
  00D2A0  c80e0100         enter 0x10e, 0
  00D2A4  53               push bx
  00D2A5  52               push dx
  00D2A6  50               push ax
  00D2A7  57               push di
  00D2A8  56               push si
  00D2A9  8bfb             mov di, bx
  00D2AB  2bc0             sub ax, ax
  00D2AD  8946f6           mov word ptr [bp - 0xa], ax
  00D2B0  8946f4           mov word ptr [bp - 0xc], ax
  00D2B3  8946fa           mov word ptr [bp - 6], ax
  00D2B6  8946f8           mov word ptr [bp - 8], ax
  00D2B9  8bc2             mov ax, dx
  00D2BB  0b86ecfe         or ax, word ptr [bp - 0x114]
  00D2BF  7503             jne 0xd2c4
  00D2C1  e9dd01           jmp 0xd4a1
  00D2C4  837e0601         cmp word ptr [bp + 6], 1
  00D2C8  750c             jne 0xd2d6
  00D2CA  837e0800         cmp word ptr [bp + 8], 0
  00D2CE  7506             jne 0xd2d6
  00D2D0  8b86ecfe         mov ax, word ptr [bp - 0x114]
  00D2D4  eb10             jmp 0xd2e6
  00D2D6  52               push dx
  00D2D7  ffb6ecfe         push word ptr [bp - 0x114]
  00D2DB  ff7608           push word ptr [bp + 8]
  00D2DE  ff7606           push word ptr [bp + 6]
  00D2E1  9abc0b8813       lcall 0x1388, 0xbbc
  00D2E6  8946fc           mov word ptr [bp - 4], ax
  00D2E9  8956fe           mov word ptr [bp - 2], dx
  00D2EC  833e180700       cmp word ptr [0x718], 0
  00D2F1  7403             je 0xd2f6
  00D2F3  e9fe00           jmp 0xd3f4
  00D2F6  837d0200         cmp word ptr [di + 2], 0
  00D2FA  7e4d             jle 0xd349
  00D2FC  8b4502           mov ax, word ptr [di + 2]
  00D2FF  99               cdq
  00D300  3b56fe           cmp dx, word ptr [bp - 2]
  00D303  7c0a             jl 0xd30f
  00D305  7f05             jg 0xd30c
  00D307  3b46fc           cmp ax, word ptr [bp - 4]
  00D30A  7603             jbe 0xd30f
  00D30C  8b46fc           mov ax, word ptr [bp - 4]
  00D30F  8bf0             mov si, ax
  00D311  56               push si
  00D312  1e               push ds
  00D313  ff35             push word ptr [di]
  00D315  ff760c           push word ptr [bp + 0xc]
  00D318  ff760a           push word ptr [bp + 0xa]
  00D31B  9a4a0c8813       lcall 0x1388, 0xc4a
  00D320  83c40a           add sp, 0xa
  00D323  0135             add word ptr [di], si
  00D325  297502           sub word ptr [di + 2], si
  00D328  2bc9             sub cx, cx
  00D32A  8976f4           mov word ptr [bp - 0xc], si
  00D32D  894ef6           mov word ptr [bp - 0xa], cx
  00D330  8976f8           mov word ptr [bp - 8], si
  00D333  894efa           mov word ptr [bp - 6], cx
  00D336  8bc1             mov ax, cx
  00D338  2bd2             sub dx, dx
  00D33A  8bce             mov cx, si
  00D33C  014e0a           add word ptr [bp + 0xa], cx
  00D33F  13d0             adc dx, ax
  00D341  b90c00           mov cx, 0xc
  00D344  d3e2             shl dx, cl
  00D346  01560c           add word ptr [bp + 0xc], dx
  00D349  837d0200         cmp word ptr [di + 2], 0
  00D34D  7511             jne 0xd360
  00D34F  f6450604         test byte ptr [di + 6], 4
  00D353  750b             jne 0xd360
  00D355  6a00             push 0
  00D357  57               push di
  00D358  9adc088813       lcall 0x1388, 0x8dc
  00D35D  83c404           add sp, 4
  00D360  8b46fc           mov ax, word ptr [bp - 4]
  00D363  8b56fe           mov dx, word ptr [bp - 2]
  00D366  3956fa           cmp word ptr [bp - 6], dx
  00D369  7e03             jle 0xd36e
  00D36B  e90701           jmp 0xd475
  00D36E  7c08             jl 0xd378
  00D370  3946f8           cmp word ptr [bp - 8], ax
  00D373  7203             jb 0xd378
  00D375  e9fd00           jmp 0xd475
  00D378  89bef0fe         mov word ptr [bp - 0x110], di
  00D37C  8d46f2           lea ax, [bp - 0xe]
  00D37F  50               push ax
  00D380  8b46fc           mov ax, word ptr [bp - 4]
  00D383  8b56fe           mov dx, word ptr [bp - 2]
  00D386  2b46f4           sub ax, word ptr [bp - 0xc]
  00D389  1b56f6           sbb dx, word ptr [bp - 0xa]
  00D38C  0bd2             or dx, dx
  00D38E  7c0a             jl 0xd39a
  00D390  7f05             jg 0xd397
  00D392  3d00f0           cmp ax, 0xf000
  00D395  7603             jbe 0xd39a
  00D397  b800f0           mov ax, 0xf000
  00D39A  8bf0             mov si, ax
  00D39C  56               push si
  00D39D  ff760c           push word ptr [bp + 0xc]
  00D3A0  ff760a           push word ptr [bp + 0xa]
  00D3A3  8a4507           mov al, byte ptr [di + 7]
  00D3A6  98               cwde
  00D3A7  50               push ax
  00D3A8  9af20a8813       lcall 0x1388, 0xaf2
  00D3AD  83c40a           add sp, 0xa
  00D3B0  0bc0             or ax, ax
  00D3B2  7403             je 0xd3b7
  00D3B4  e9be00           jmp 0xd475
  00D3B7  8b46f2           mov ax, word ptr [bp - 0xe]
  00D3BA  2bd2             sub dx, dx
  00D3BC  0146f4           add word ptr [bp - 0xc], ax
  00D3BF  1156f6           adc word ptr [bp - 0xa], dx
  00D3C2  2bdb             sub bx, bx
  00D3C4  8bc8             mov cx, ax
  00D3C6  014e0a           add word ptr [bp + 0xa], cx
  00D3C9  13da             adc bx, dx
  00D3CB  b90c00           mov cx, 0xc
  00D3CE  d3e3             shl bx, cl
  00D3D0  015e0c           add word ptr [bp + 0xc], bx
  00D3D3  8b46fc           mov ax, word ptr [bp - 4]
  00D3D6  8b56fe           mov dx, word ptr [bp - 2]
  00D3D9  2bc9             sub cx, cx
  00D3DB  0176f8           add word ptr [bp - 8], si
  00D3DE  114efa           adc word ptr [bp - 6], cx
  00D3E1  3956fa           cmp word ptr [bp - 6], dx
  00D3E4  7c96             jl 0xd37c
  00D3E6  7e03             jle 0xd3eb
  00D3E8  e98a00           jmp 0xd475
  00D3EB  3946f8           cmp word ptr [bp - 8], ax
  00D3EE  728c             jb 0xd37c
  00D3F0  e98200           jmp 0xd475
  00D3F3  90               nop
  00D3F4  0bd2             or dx, dx
  00D3F6  7c7d             jl 0xd475
  00D3F8  7f04             jg 0xd3fe
  00D3FA  0bc0             or ax, ax
  00D3FC  7477             je 0xd475
  00D3FE  89bef0fe         mov word ptr [bp - 0x110], di
  00D402  57               push di
  00D403  6a01             push 1
  00D405  2b46f4           sub ax, word ptr [bp - 0xc]
  00D408  1b56f6           sbb dx, word ptr [bp - 0xa]
  00D40B  0bd2             or dx, dx
  00D40D  7c0a             jl 0xd419
  00D40F  7f05             jg 0xd416
  00D411  3d0001           cmp ax, 0x100
  00D414  7603             jbe 0xd419
  00D416  b80001           mov ax, 0x100
  00D419  8bf0             mov si, ax
  00D41B  56               push si
  00D41C  8d86f2fe         lea ax, [bp - 0x10e]
  00D420  50               push ax
  00D421  9abe038813       lcall 0x1388, 0x3be
  00D426  83c408           add sp, 8
  00D429  0bc0             or ax, ax
  00D42B  7448             je 0xd475
  00D42D  56               push si
  00D42E  8d86f2fe         lea ax, [bp - 0x10e]
  00D432  16               push ss
  00D433  50               push ax
  00D434  ff760c           push word ptr [bp + 0xc]
  00D437  ff760a           push word ptr [bp + 0xa]
  00D43A  9a4a0c8813       lcall 0x1388, 0xc4a
  00D43F  83c40a           add sp, 0xa
  00D442  2bc9             sub cx, cx
  00D444  0176f4           add word ptr [bp - 0xc], si
  00D447  114ef6           adc word ptr [bp - 0xa], cx
  00D44A  8bc1             mov ax, cx
  00D44C  2bd2             sub dx, dx
  00D44E  8bce             mov cx, si
  00D450  014e0a           add word ptr [bp + 0xa], cx
  00D453  13d0             adc dx, ax
  00D455  b90c00           mov cx, 0xc
  00D458  d3e2             shl dx, cl
  00D45A  01560c           add word ptr [bp + 0xc], dx
  00D45D  0176f8           add word ptr [bp - 8], si
  00D460  1146fa           adc word ptr [bp - 6], ax
  00D463  8b46fc           mov ax, word ptr [bp - 4]
  00D466  8b56fe           mov dx, word ptr [bp - 2]
  00D469  3956fa           cmp word ptr [bp - 6], dx
  00D46C  7c94             jl 0xd402
  00D46E  7f05             jg 0xd475
  00D470  3946f8           cmp word ptr [bp - 8], ax
  00D473  728d             jb 0xd402
  00D475  8b86ecfe         mov ax, word ptr [bp - 0x114]
  00D479  8b96eefe         mov dx, word ptr [bp - 0x112]
  00D47D  3946f4           cmp word ptr [bp - 0xc], ax
  00D480  7512             jne 0xd494
  00D482  3956f6           cmp word ptr [bp - 0xa], dx
  00D485  750d             jne 0xd494
  00D487  b80100           mov ax, 1
  00D48A  99               cdq
  00D48B  5e               pop si
  00D48C  5f               pop di
  00D48D  c9               leave
  00D48E  ca0800           retf 8
  00D491  90               nop
  00D492  90               nop
  00D493  90               nop
  00D494  52               push dx
  00D495  50               push ax
  00D496  ff76f6           push word ptr [bp - 0xa]
  00D499  ff76f4           push word ptr [bp - 0xc]
  00D49C  9a220b8813       lcall 0x1388, 0xb22
  00D4A1  5e               pop si
  00D4A2  5f               pop di
  00D4A3  c9               leave
  00D4A4  ca0800           retf 8
  00D4A7  90               nop
