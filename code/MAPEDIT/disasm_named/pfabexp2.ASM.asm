; MAPEDIT.EXE named disasm — module pfabexp2.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PFABEXP2  file 0x0134CA..0x013628  seg 0x11A7:0x45a  (pfabexp2.ASM.obj) ----
  0134CA  c8000000         enter 0, 0
  0134CE  56               push si
  0134CF  57               push di
  0134D0  1e               push ds
  0134D1  c47e06           les di, ptr [bp + 6]
  0134D4  8cc0             mov ax, es
  0134D6  0bc7             or ax, di
  0134D8  750a             jne 0x134e4
  0134DA  b80400           mov ax, 4
  0134DD  1f               pop ds
  0134DE  5f               pop di
  0134DF  5e               pop si
  0134E0  c9               leave
  0134E1  ca0c00           retf 0xc
  0134E4  55               push bp
  0134E5  c5760e           lds si, ptr [bp + 0xe]
  0134E8  c47e0a           les di, ptr [bp + 0xa]
  0134EB  ad               lodsw ax, word ptr [si]
  0134EC  3d4641           cmp ax, 0x4146
  0134EF  754d             jne 0x1353e
  0134F1  ad               lodsw ax, word ptr [si]
  0134F2  3c42             cmp al, 0x42
  0134F4  7548             jne 0x1353e
  0134F6  80fc0a           cmp ah, 0xa
  0134F9  7243             jb 0x1353e
  0134FB  80fc0d           cmp ah, 0xd
  0134FE  773e             ja 0x1353e
  013500  b110             mov cl, 0x10
  013502  2acc             sub cl, ah
  013504  2e880e5204       mov byte ptr cs:[0x452], cl
  013509  b001             mov al, 1
  01350B  d2e0             shl al, cl
  01350D  fec8             dec al
  01350F  2ea25304         mov byte ptr cs:[0x453], al
  013513  8acc             mov cl, ah
  013515  b80100           mov ax, 1
  013518  d3e0             shl ax, cl
  01351A  2ea35604         mov word ptr cs:[0x456], ax
  01351E  80e904           sub cl, 4
  013521  b80100           mov ax, 1
  013524  d3e0             shl ax, cl
  013526  2ea35804         mov word ptr cs:[0x458], ax
  01352A  80e904           sub cl, 4
  01352D  b0ff             mov al, 0xff
  01352F  d2e0             shl al, cl
  013531  2ea25404         mov byte ptr cs:[0x454], al
  013535  ad               lodsw ax, word ptr [si]
  013536  8be8             mov bp, ax
  013538  ba1000           mov dx, 0x10
  01353B  eb0b             jmp 0x13548
  01353D  90               nop
  01353E  b81600           mov ax, 0x16
  013541  1f               pop ds
  013542  5f               pop di
  013543  5e               pop si
  013544  c9               leave
  013545  ca0c00           retf 0xc
  013548  4a               dec dx
  013549  7509             jne 0x13554
  01354B  ad               lodsw ax, word ptr [si]
  01354C  b210             mov dl, 0x10
  01354E  d1ed             shr bp, 1
  013550  8be8             mov bp, ax
  013552  d1d5             rcl bp, 1
  013554  d1dd             rcr bp, 1
  013556  7303             jae 0x1355b
  013558  a4               movsb byte ptr es:[di], byte ptr [si]
  013559  ebed             jmp 0x13548
  01355B  33c9             xor cx, cx
  01355D  4a               dec dx
  01355E  7509             jne 0x13569
  013560  ad               lodsw ax, word ptr [si]
  013561  b210             mov dl, 0x10
  013563  d1ed             shr bp, 1
  013565  8be8             mov bp, ax
  013567  d1d5             rcl bp, 1
  013569  d1dd             rcr bp, 1
  01356B  722a             jb 0x13597
  01356D  4a               dec dx
  01356E  7509             jne 0x13579
  013570  ad               lodsw ax, word ptr [si]
  013571  b210             mov dl, 0x10
  013573  d1ed             shr bp, 1
  013575  8be8             mov bp, ax
  013577  d1d5             rcl bp, 1
  013579  d1dd             rcr bp, 1
  01357B  d1d1             rcl cx, 1
  01357D  4a               dec dx
  01357E  7509             jne 0x13589
  013580  ad               lodsw ax, word ptr [si]
  013581  b210             mov dl, 0x10
  013583  d1ed             shr bp, 1
  013585  8be8             mov bp, ax
  013587  d1d5             rcl bp, 1
  013589  d1dd             rcr bp, 1
  01358B  d1d1             rcl cx, 1
  01358D  41               inc cx
  01358E  41               inc cx
  01358F  ac               lodsb al, byte ptr [si]
  013590  b7ff             mov bh, 0xff
  013592  8ad8             mov bl, al
  013594  eb1b             jmp 0x135b1
  013596  90               nop
  013597  ad               lodsw ax, word ptr [si]
  013598  8bd8             mov bx, ax
  01359A  2e8a0e5204       mov cl, byte ptr cs:[0x452]
  01359F  d2ef             shr bh, cl
  0135A1  2e0a3e5404       or bh, byte ptr cs:[0x454]
  0135A6  2e22265304       and ah, byte ptr cs:[0x453]
  0135AB  740c             je 0x135b9
  0135AD  8acc             mov cl, ah
  0135AF  41               inc cx
  0135B0  41               inc cx
  0135B1  268a01           mov al, byte ptr es:[bx + di]
  0135B4  aa               stosb byte ptr es:[di], al
  0135B5  e2fa             loop 0x135b1
  0135B7  eb8f             jmp 0x13548
  0135B9  ac               lodsb al, byte ptr [si]
  0135BA  0ac0             or al, al
  0135BC  7432             je 0x135f0
  0135BE  3c01             cmp al, 1
  0135C0  7405             je 0x135c7
  0135C2  8ac8             mov cl, al
  0135C4  41               inc cx
  0135C5  ebea             jmp 0x135b1
  0135C7  8bdf             mov bx, di
  0135C9  83e70f           and di, 0xf
  0135CC  2e033e5604       add di, word ptr cs:[0x456]
  0135D1  b104             mov cl, 4
  0135D3  d3eb             shr bx, cl
  0135D5  8cc0             mov ax, es
  0135D7  03c3             add ax, bx
  0135D9  2e2b065804       sub ax, word ptr cs:[0x458]
  0135DE  8ec0             mov es, ax
  0135E0  8bde             mov bx, si
  0135E2  83e60f           and si, 0xf
  0135E5  d3eb             shr bx, cl
  0135E7  8cd8             mov ax, ds
  0135E9  03c3             add ax, bx
  0135EB  8ed8             mov ds, ax
  0135ED  e958ff           jmp 0x13548
  0135F0  8cc2             mov dx, es
  0135F2  c1ea0c           shr dx, 0xc
  0135F5  8cc0             mov ax, es
  0135F7  c1e004           shl ax, 4
  0135FA  03c7             add ax, di
  0135FC  83d200           adc dx, 0
  0135FF  5d               pop bp
  013600  c5760a           lds si, ptr [bp + 0xa]
  013603  8cdb             mov bx, ds
  013605  c1eb0c           shr bx, 0xc
  013608  8cd9             mov cx, ds
  01360A  c1e104           shl cx, 4
  01360D  03ce             add cx, si
  01360F  83d300           adc bx, 0
  013612  2bc1             sub ax, cx
  013614  1bd3             sbb dx, bx
  013616  c57606           lds si, ptr [bp + 6]
  013619  8904             mov word ptr [si], ax
  01361B  895402           mov word ptr [si + 2], dx
  01361E  33c0             xor ax, ax
  013620  1f               pop ds
  013621  5f               pop di
  013622  5e               pop si
  013623  c9               leave
  013624  ca0c00           retf 0xc
  013627  00               .byte 0x00
