; MAPEDIT.EXE named disasm — module sprite_2.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sprite_draw_scaled  file 0x00F0EA..0x00F3B8  seg 0xDAE:0xa  (sprite_2.c.obj) ----
  00F0EA  c86e0100         enter 0x16e, 0
  00F0EE  52               push dx
  00F0EF  53               push bx
  00F0F0  50               push ax
  00F0F1  57               push di
  00F0F2  56               push si
  00F0F3  8b4702           mov ax, word ptr [bx + 2]
  00F0F6  48               dec ax
  00F0F7  89869efe         mov word ptr [bp - 0x162], ax
  00F0FB  8b07             mov ax, word ptr [bx]
  00F0FD  48               dec ax
  00F0FE  898694fe         mov word ptr [bp - 0x16c], ax
  00F102  ba0100           mov dx, 1
  00F105  8b868cfe         mov ax, word ptr [bp - 0x174]
  00F109  0bc0             or ax, ax
  00F10B  7903             jns 0xf110
  00F10D  baffff           mov dx, 0xffff
  00F110  8956f0           mov word ptr [bp - 0x10], dx
  00F113  25ff7f           and ax, 0x7fff
  00F116  89868cfe         mov word ptr [bp - 0x174], ax
  00F11A  8b9e8cfe         mov bx, word ptr [bp - 0x174]
  00F11E  8bc3             mov ax, bx
  00F120  d1e3             shl bx, 1
  00F122  03d8             add bx, ax
  00F124  c1e302           shl bx, 2
  00F127  035e0a           add bx, word ptr [bp + 0xa]
  00F12A  8e460c           mov es, word ptr [bp + 0xc]
  00F12D  83c336           add bx, 0x36
  00F130  895ef2           mov word ptr [bp - 0xe], bx
  00F133  8c46f4           mov word ptr [bp - 0xc], es
  00F136  268b07           mov ax, word ptr es:[bx]
  00F139  268b5702         mov dx, word ptr es:[bx + 2]
  00F13D  8986a4fe         mov word ptr [bp - 0x15c], ax
  00F141  8996a6fe         mov word ptr [bp - 0x15a], dx
  00F145  8bb68efe         mov si, word ptr [bp - 0x172]
  00F149  8b4404           mov ax, word ptr [si + 4]
  00F14C  8b5406           mov dx, word ptr [si + 6]
  00F14F  8986a8fe         mov word ptr [bp - 0x158], ax
  00F153  8996aafe         mov word ptr [bp - 0x156], dx
  00F157  8b4402           mov ax, word ptr [si + 2]
  00F15A  8946fe           mov word ptr [bp - 2], ax
  00F15D  268b4708         mov ax, word ptr es:[bx + 8]
  00F161  8986a2fe         mov word ptr [bp - 0x15e], ax
  00F165  268b4f0a         mov cx, word ptr es:[bx + 0xa]
  00F169  898e9cfe         mov word ptr [bp - 0x164], cx
  00F16D  3bc1             cmp ax, cx
  00F16F  7d02             jge 0xf173
  00F171  8bc1             mov ax, cx
  00F173  89869afe         mov word ptr [bp - 0x166], ax
  00F177  1e               push ds
  00F178  33ff             xor di, di
  00F17A  8b7606           mov si, word ptr [bp + 6]
  00F17D  33c0             xor ax, ax
  00F17F  8946ee           mov word ptr [bp - 0x12], ax
  00F182  8986acfe         mov word ptr [bp - 0x154], ax
  00F186  b83200           mov ax, 0x32
  00F189  8b9ea2fe         mov bx, word ptr [bp - 0x15e]
  00F18D  8b969cfe         mov dx, word ptr [bp - 0x164]
  00F191  03c6             add ax, si
  00F193  3d6400           cmp ax, 0x64
  00F196  7c1a             jl 0xf1b2
  00F198  c683aefeff       mov byte ptr [bp + di - 0x152], 0xff
  00F19D  2d6400           sub ax, 0x64
  00F1A0  3bfb             cmp di, bx
  00F1A2  7d03             jge 0xf1a7
  00F1A4  ff46ee           inc word ptr [bp - 0x12]
  00F1A7  3bfa             cmp di, dx
  00F1A9  7d0c             jge 0xf1b7
  00F1AB  ff86acfe         inc word ptr [bp - 0x154]
  00F1AF  eb06             jmp 0xf1b7
  00F1B1  90               nop
  00F1B2  c683aefe00       mov byte ptr [bp + di - 0x152], 0
  00F1B7  47               inc di
  00F1B8  3bbe9afe         cmp di, word ptr [bp - 0x166]
  00F1BC  7cd3             jl 0xf191
  00F1BE  8b46ee           mov ax, word ptr [bp - 0x12]
  00F1C1  d1e8             shr ax, 1
  00F1C3  298690fe         sub word ptr [bp - 0x170], ax
  00F1C7  8b86acfe         mov ax, word ptr [bp - 0x154]
  00F1CB  294608           sub word ptr [bp + 8], ax
  00F1CE  ff4608           inc word ptr [bp + 8]
  00F1D1  8b5eee           mov bx, word ptr [bp - 0x12]
  00F1D4  33c9             xor cx, cx
  00F1D6  8b8690fe         mov ax, word ptr [bp - 0x170]
  00F1DA  8bd0             mov dx, ax
  00F1DC  03d3             add dx, bx
  00F1DE  4a               dec dx
  00F1DF  0bc0             or ax, ax
  00F1E1  7d04             jge 0xf1e7
  00F1E3  03d8             add bx, ax
  00F1E5  2bc8             sub cx, ax
  00F1E7  2b969efe         sub dx, word ptr [bp - 0x162]
  00F1EB  7e02             jle 0xf1ef
  00F1ED  2bda             sub bx, dx
  00F1EF  898e98fe         mov word ptr [bp - 0x168], cx
  00F1F3  895efa           mov word ptr [bp - 6], bx
  00F1F6  03cb             add cx, bx
  00F1F8  898ea0fe         mov word ptr [bp - 0x160], cx
  00F1FC  0bdb             or bx, bx
  00F1FE  7f04             jg 0xf204
  00F200  e9ad01           jmp 0xf3b0
  00F203  90               nop
  00F204  837ef001         cmp word ptr [bp - 0x10], 1
  00F208  741b             je 0xf225
  00F20A  8b7eee           mov di, word ptr [bp - 0x12]
  00F20D  03c7             add ax, di
  00F20F  48               dec ax
  00F210  898690fe         mov word ptr [bp - 0x170], ax
  00F214  2bf9             sub di, cx
  00F216  f7df             neg di
  00F218  89be98fe         mov word ptr [bp - 0x168], di
  00F21C  f7df             neg di
  00F21E  037efa           add di, word ptr [bp - 6]
  00F221  89bea0fe         mov word ptr [bp - 0x160], di
  00F225  8b9eacfe         mov bx, word ptr [bp - 0x154]
  00F229  33c9             xor cx, cx
  00F22B  8b4608           mov ax, word ptr [bp + 8]
  00F22E  8bd0             mov dx, ax
  00F230  03d3             add dx, bx
  00F232  4a               dec dx
  00F233  0bc0             or ax, ax
  00F235  7d04             jge 0xf23b
  00F237  03d8             add bx, ax
  00F239  2bc8             sub cx, ax
  00F23B  2b9694fe         sub dx, word ptr [bp - 0x16c]
  00F23F  7e02             jle 0xf243
  00F241  2bda             sub bx, dx
  00F243  898e92fe         mov word ptr [bp - 0x16e], cx
  00F247  895ef6           mov word ptr [bp - 0xa], bx
  00F24A  51               push cx
  00F24B  03cb             add cx, bx
  00F24D  898e96fe         mov word ptr [bp - 0x16a], cx
  00F251  59               pop cx
  00F252  0bdb             or bx, bx
  00F254  7f04             jg 0xf25a
  00F256  e95701           jmp 0xf3b0
  00F259  90               nop
  00F25A  c49ea8fe         les bx, ptr [bp - 0x158]
  00F25E  8cc2             mov dx, es
  00F260  8b7efe           mov di, word ptr [bp - 2]
  00F263  03c8             add cx, ax
  00F265  740e             je 0xf275
  00F267  03df             add bx, di
  00F269  7908             jns 0xf273
  00F26B  81eb0070         sub bx, 0x7000
  00F26F  81c20007         add dx, 0x700
  00F273  e2f2             loop 0xf267
  00F275  039e90fe         add bx, word ptr [bp - 0x170]
  00F279  039e98fe         add bx, word ptr [bp - 0x168]
  00F27D  8ec2             mov es, dx
  00F27F  c5b6a4fe         lds si, ptr [bp - 0x15c]
  00F283  8b8698fe         mov ax, word ptr [bp - 0x168]
  00F287  f76ef0           imul word ptr [bp - 0x10]
  00F28A  898698fe         mov word ptr [bp - 0x168], ax
  00F28E  bfffff           mov di, 0xffff
  00F291  baffff           mov dx, 0xffff
  00F294  c746fc0000       mov word ptr [bp - 4], 0
  00F299  47               inc di
  00F29A  3bbe9cfe         cmp di, word ptr [bp - 0x164]
  00F29E  7c04             jl 0xf2a4
  00F2A0  e90d01           jmp 0xf3b0
  00F2A3  90               nop
  00F2A4  8a83aefe         mov al, byte ptr [bp + di - 0x152]
  00F2A8  0ac0             or al, al
  00F2AA  7504             jne 0xf2b0
  00F2AC  e9f200           jmp 0xf3a1
  00F2AF  90               nop
  00F2B0  42               inc dx
  00F2B1  3b9696fe         cmp dx, word ptr [bp - 0x16a]
  00F2B5  7c03             jl 0xf2ba
  00F2B7  e9f600           jmp 0xf3b0
  00F2BA  3b9692fe         cmp dx, word ptr [bp - 0x16e]
  00F2BE  7d04             jge 0xf2c4
  00F2C0  e9de00           jmp 0xf3a1
  00F2C3  90               nop
  00F2C4  57               push di
  00F2C5  33ff             xor di, di
  00F2C7  53               push bx
  00F2C8  52               push dx
  00F2C9  33d2             xor dx, dx
  00F2CB  ac               lodsb al, byte ptr [si]
  00F2CC  3cff             cmp al, 0xff
  00F2CE  7406             je 0xf2d6
  00F2D0  3cfd             cmp al, 0xfd
  00F2D2  740a             je 0xf2de
  00F2D4  eb4e             jmp 0xf324
  00F2D6  c746fcffff       mov word ptr [bp - 4], 0xffff
  00F2DB  e9b000           jmp 0xf38e
  00F2DE  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  00F2E2  7c04             jl 0xf2e8
  00F2E4  e9a700           jmp 0xf38e
  00F2E7  90               nop
  00F2E8  ac               lodsb al, byte ptr [si]
  00F2E9  3cff             cmp al, 0xff
  00F2EB  7509             jne 0xf2f6
  00F2ED  c746fcffff       mov word ptr [bp - 4], 0xffff
  00F2F2  e99900           jmp 0xf38e
  00F2F5  90               nop
  00F2F6  8ae0             mov ah, al
  00F2F8  ac               lodsb al, byte ptr [si]
  00F2F9  8a8baefe         mov cl, byte ptr [bp + di - 0x152]
  00F2FD  0ac9             or cl, cl
  00F2FF  7503             jne 0xf304
  00F301  eb18             jmp 0xf31b
  00F303  90               nop
  00F304  3b9698fe         cmp dx, word ptr [bp - 0x168]
  00F308  7c10             jl 0xf31a
  00F30A  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  00F30E  7d0a             jge 0xf31a
  00F310  3cfd             cmp al, 0xfd
  00F312  7403             je 0xf317
  00F314  268807           mov byte ptr es:[bx], al
  00F317  035ef0           add bx, word ptr [bp - 0x10]
  00F31A  42               inc dx
  00F31B  47               inc di
  00F31C  fecc             dec ah
  00F31E  7402             je 0xf322
  00F320  ebd7             jmp 0xf2f9
  00F322  ebba             jmp 0xf2de
  00F324  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  00F328  7c02             jl 0xf32c
  00F32A  eb62             jmp 0xf38e
  00F32C  ac               lodsb al, byte ptr [si]
  00F32D  3cff             cmp al, 0xff
  00F32F  7407             je 0xf338
  00F331  3cfe             cmp al, 0xfe
  00F333  7405             je 0xf33a
  00F335  eb33             jmp 0xf36a
  00F337  90               nop
  00F338  ebb3             jmp 0xf2ed
  00F33A  ac               lodsb al, byte ptr [si]
  00F33B  8ae0             mov ah, al
  00F33D  ac               lodsb al, byte ptr [si]
  00F33E  8a8baefe         mov cl, byte ptr [bp + di - 0x152]
  00F342  0ac9             or cl, cl
  00F344  7502             jne 0xf348
  00F346  eb17             jmp 0xf35f
  00F348  3b9698fe         cmp dx, word ptr [bp - 0x168]
  00F34C  7c10             jl 0xf35e
  00F34E  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  00F352  7d0a             jge 0xf35e
  00F354  3cfd             cmp al, 0xfd
  00F356  7403             je 0xf35b
  00F358  268807           mov byte ptr es:[bx], al
  00F35B  035ef0           add bx, word ptr [bp - 0x10]
  00F35E  42               inc dx
  00F35F  47               inc di
  00F360  fecc             dec ah
  00F362  7402             je 0xf366
  00F364  ebd8             jmp 0xf33e
  00F366  ebbc             jmp 0xf324
  00F368  eb20             jmp 0xf38a
  00F36A  8a8baefe         mov cl, byte ptr [bp + di - 0x152]
  00F36E  0ac9             or cl, cl
  00F370  7502             jne 0xf374
  00F372  eb17             jmp 0xf38b
  00F374  3b9698fe         cmp dx, word ptr [bp - 0x168]
  00F378  7c10             jl 0xf38a
  00F37A  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  00F37E  7d0a             jge 0xf38a
  00F380  3cfd             cmp al, 0xfd
  00F382  7403             je 0xf387
  00F384  268807           mov byte ptr es:[bx], al
  00F387  035ef0           add bx, word ptr [bp - 0x10]
  00F38A  42               inc dx
  00F38B  47               inc di
  00F38C  eb96             jmp 0xf324
  00F38E  5a               pop dx
  00F38F  5b               pop bx
  00F390  5f               pop di
  00F391  035efe           add bx, word ptr [bp - 2]
  00F394  790b             jns 0xf3a1
  00F396  81eb0070         sub bx, 0x7000
  00F39A  8cc0             mov ax, es
  00F39C  050007           add ax, 0x700
  00F39F  8ec0             mov es, ax
  00F3A1  837efcff         cmp word ptr [bp - 4], -1
  00F3A5  7405             je 0xf3ac
  00F3A7  ac               lodsb al, byte ptr [si]
  00F3A8  3cff             cmp al, 0xff
  00F3AA  75fb             jne 0xf3a7
  00F3AC  e9e5fe           jmp 0xf294
  00F3AF  90               nop
  00F3B0  1f               pop ds
  00F3B1  5e               pop si
  00F3B2  5f               pop di
  00F3B3  c9               leave
  00F3B4  ca0800           retf 8
  00F3B7  90               nop
