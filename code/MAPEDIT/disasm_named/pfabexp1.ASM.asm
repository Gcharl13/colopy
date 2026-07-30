; MAPEDIT.EXE named disasm — module pfabexp1.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PFABEXP1  file 0x0132BE..0x01348E  seg 0x11A7:0x24e  (pfabexp1.ASM.obj) ----
  0132BE  c8000000         enter 0, 0
  0132C2  56               push si
  0132C3  57               push di
  0132C4  1e               push ds
  0132C5  c44606           les ax, ptr [bp + 6]
  0132C8  050f00           add ax, 0xf
  0132CB  c1e804           shr ax, 4
  0132CE  8cc2             mov dx, es
  0132D0  03d0             add dx, ax
  0132D2  750a             jne 0x132de
  0132D4  b82008           mov ax, 0x820
  0132D7  1f               pop ds
  0132D8  5f               pop di
  0132D9  5e               pop si
  0132DA  c9               leave
  0132DB  ca0c00           retf 0xc
  0132DE  55               push bp
  0132DF  1e               push ds
  0132E0  8eda             mov ds, dx
  0132E2  8f060200         pop word ptr [2]
  0132E6  8f060000         pop word ptr [0]
  0132EA  c4460e           les ax, ptr [bp + 0xe]
  0132ED  2ea34a02         mov word ptr cs:[0x24a], ax
  0132F1  2e8c064c02       mov word ptr cs:[0x24c], es
  0132F6  8d361000         lea si, [0x10]
  0132FA  81c60008         add si, 0x800
  0132FE  c47e0a           les di, ptr [bp + 0xa]
  013301  81fe0f08         cmp si, 0x80f
  013305  7203             jb 0x1330a
  013307  e88401           call 0x1348e
  01330A  ad               lodsw ax, word ptr [si]
  01330B  3d4641           cmp ax, 0x4146
  01330E  755a             jne 0x1336a
  013310  81fe0f08         cmp si, 0x80f
  013314  7203             jb 0x13319
  013316  e87501           call 0x1348e
  013319  ad               lodsw ax, word ptr [si]
  01331A  3c42             cmp al, 0x42
  01331C  754c             jne 0x1336a
  01331E  80fc0a           cmp ah, 0xa
  013321  7247             jb 0x1336a
  013323  80fc0d           cmp ah, 0xd
  013326  7742             ja 0x1336a
  013328  b110             mov cl, 0x10
  01332A  2acc             sub cl, ah
  01332C  880e0400         mov byte ptr [4], cl
  013330  b001             mov al, 1
  013332  d2e0             shl al, cl
  013334  fec8             dec al
  013336  a20500           mov byte ptr [5], al
  013339  8acc             mov cl, ah
  01333B  b80100           mov ax, 1
  01333E  d3e0             shl ax, cl
  013340  a30800           mov word ptr [8], ax
  013343  80e904           sub cl, 4
  013346  b80100           mov ax, 1
  013349  d3e0             shl ax, cl
  01334B  a30a00           mov word ptr [0xa], ax
  01334E  80e904           sub cl, 4
  013351  b0ff             mov al, 0xff
  013353  d2e0             shl al, cl
  013355  a20600           mov byte ptr [6], al
  013358  81fe0f08         cmp si, 0x80f
  01335C  7203             jb 0x13361
  01335E  e82d01           call 0x1348e
  013361  ad               lodsw ax, word ptr [si]
  013362  8be8             mov bp, ax
  013364  ba1000           mov dx, 0x10
  013367  eb0b             jmp 0x13374
  013369  90               nop
  01336A  b81600           mov ax, 0x16
  01336D  1f               pop ds
  01336E  5f               pop di
  01336F  5e               pop si
  013370  c9               leave
  013371  ca0c00           retf 0xc
  013374  4a               dec dx
  013375  7512             jne 0x13389
  013377  81fe0f08         cmp si, 0x80f
  01337B  7203             jb 0x13380
  01337D  e80e01           call 0x1348e
  013380  ad               lodsw ax, word ptr [si]
  013381  b210             mov dl, 0x10
  013383  d1ed             shr bp, 1
  013385  8be8             mov bp, ax
  013387  d1d5             rcl bp, 1
  013389  d1dd             rcr bp, 1
  01338B  730d             jae 0x1339a
  01338D  81fe0f08         cmp si, 0x80f
  013391  7603             jbe 0x13396
  013393  e8f800           call 0x1348e
  013396  ac               lodsb al, byte ptr [si]
  013397  aa               stosb byte ptr es:[di], al
  013398  ebda             jmp 0x13374
  01339A  33c9             xor cx, cx
  01339C  4a               dec dx
  01339D  7512             jne 0x133b1
  01339F  81fe0f08         cmp si, 0x80f
  0133A3  7203             jb 0x133a8
  0133A5  e8e600           call 0x1348e
  0133A8  ad               lodsw ax, word ptr [si]
  0133A9  b210             mov dl, 0x10
  0133AB  d1ed             shr bp, 1
  0133AD  8be8             mov bp, ax
  0133AF  d1d5             rcl bp, 1
  0133B1  d1dd             rcr bp, 1
  0133B3  7245             jb 0x133fa
  0133B5  4a               dec dx
  0133B6  7512             jne 0x133ca
  0133B8  81fe0f08         cmp si, 0x80f
  0133BC  7203             jb 0x133c1
  0133BE  e8cd00           call 0x1348e
  0133C1  ad               lodsw ax, word ptr [si]
  0133C2  b210             mov dl, 0x10
  0133C4  d1ed             shr bp, 1
  0133C6  8be8             mov bp, ax
  0133C8  d1d5             rcl bp, 1
  0133CA  d1dd             rcr bp, 1
  0133CC  d1d1             rcl cx, 1
  0133CE  4a               dec dx
  0133CF  7512             jne 0x133e3
  0133D1  81fe0f08         cmp si, 0x80f
  0133D5  7203             jb 0x133da
  0133D7  e8b400           call 0x1348e
  0133DA  ad               lodsw ax, word ptr [si]
  0133DB  b210             mov dl, 0x10
  0133DD  d1ed             shr bp, 1
  0133DF  8be8             mov bp, ax
  0133E1  d1d5             rcl bp, 1
  0133E3  d1dd             rcr bp, 1
  0133E5  d1d1             rcl cx, 1
  0133E7  41               inc cx
  0133E8  41               inc cx
  0133E9  81fe0f08         cmp si, 0x80f
  0133ED  7603             jbe 0x133f2
  0133EF  e89c00           call 0x1348e
  0133F2  ac               lodsb al, byte ptr [si]
  0133F3  b7ff             mov bh, 0xff
  0133F5  8ad8             mov bl, al
  0133F7  eb21             jmp 0x1341a
  0133F9  90               nop
  0133FA  81fe0f08         cmp si, 0x80f
  0133FE  7203             jb 0x13403
  013400  e88b00           call 0x1348e
  013403  ad               lodsw ax, word ptr [si]
  013404  8bd8             mov bx, ax
  013406  8a0e0400         mov cl, byte ptr [4]
  01340A  d2ef             shr bh, cl
  01340C  0a3e0600         or bh, byte ptr [6]
  013410  22260500         and ah, byte ptr [5]
  013414  740d             je 0x13423
  013416  8acc             mov cl, ah
  013418  41               inc cx
  013419  41               inc cx
  01341A  268a01           mov al, byte ptr es:[bx + di]
  01341D  aa               stosb byte ptr es:[di], al
  01341E  e2fa             loop 0x1341a
  013420  e951ff           jmp 0x13374
  013423  81fe0f08         cmp si, 0x80f
  013427  7603             jbe 0x1342c
  013429  e86200           call 0x1348e
  01342C  ac               lodsb al, byte ptr [si]
  01342D  0ac0             or al, al
  01342F  7423             je 0x13454
  013431  3c01             cmp al, 1
  013433  7405             je 0x1343a
  013435  8ac8             mov cl, al
  013437  41               inc cx
  013438  ebe0             jmp 0x1341a
  01343A  8bdf             mov bx, di
  01343C  83e70f           and di, 0xf
  01343F  033e0800         add di, word ptr [8]
  013443  b104             mov cl, 4
  013445  d3eb             shr bx, cl
  013447  8cc0             mov ax, es
  013449  03c3             add ax, bx
  01344B  2b060a00         sub ax, word ptr [0xa]
  01344F  8ec0             mov es, ax
  013451  e920ff           jmp 0x13374
  013454  8cc2             mov dx, es
  013456  c1ea0c           shr dx, 0xc
  013459  8cc0             mov ax, es
  01345B  c1e004           shl ax, 4
  01345E  03c7             add ax, di
  013460  83d200           adc dx, 0
  013463  8b2e0000         mov bp, word ptr [0]
  013467  c47e0a           les di, ptr [bp + 0xa]
  01346A  8cc3             mov bx, es
  01346C  c1eb0c           shr bx, 0xc
  01346F  8cc1             mov cx, es
  013471  c1e104           shl cx, 4
  013474  03cf             add cx, di
  013476  83d300           adc bx, 0
  013479  2bc1             sub ax, cx
  01347B  1bd3             sbb dx, bx
  01347D  c57606           lds si, ptr [bp + 6]
  013480  8904             mov word ptr [si], ax
  013482  895402           mov word ptr [si + 2], dx
  013485  33c0             xor ax, ax
  013487  1f               pop ds
  013488  5f               pop di
  013489  5e               pop si
  01348A  c9               leave
  01348B  ca0c00           retf 0xc

; ---- RBin_x1  file 0x01348E..0x0134CA  seg 0x11A7:0x41e  (pfabexp1.ASM.obj) ----
  01348E  8a04             mov al, byte ptr [si]
  013490  81ee0008         sub si, 0x800
  013494  8804             mov byte ptr [si], al
  013496  c7060c000008     mov word ptr [0xc], 0x800
  01349C  53               push bx
  01349D  51               push cx
  01349E  52               push dx
  01349F  56               push si
  0134A0  57               push di
  0134A1  1e               push ds
  0134A2  06               push es
  0134A3  55               push bp
  0134A4  1e               push ds
  0134A5  681000           push 0x10
  0134A8  1e               push ds
  0134A9  680c00           push 0xc
  0134AC  8b2e0000         mov bp, word ptr [0]
  0134B0  8e1e0200         mov ds, word ptr [2]
  0134B4  2eff1e4a02       lcall cs:[0x24a]
  0134B9  5d               pop bp
  0134BA  07               pop es
  0134BB  1f               pop ds
  0134BC  5f               pop di
  0134BD  5e               pop si
  0134BE  5a               pop dx
  0134BF  59               pop cx
  0134C0  5b               pop bx
  0134C1  c3               ret
  0134C2  0000             add byte ptr [bx + si], al
  0134C4  0000             add byte ptr [bx + si], al
  0134C6  0000             add byte ptr [bx + si], al
  0134C8  0000             add byte ptr [bx + si], al
