; MAPEDIT.EXE named disasm — module buffer_z.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _buffer_tile  file 0x00E190..0x00E3C6  seg 0xCB9:0x0  (buffer_z.c.obj) ----
  00E190  c8160000         enter 0x16, 0
  00E194  56               push si
  00E195  8b460e           mov ax, word ptr [bp + 0xe]
  00E198  8946f2           mov word ptr [bp - 0xe], ax
  00E19B  8b4610           mov ax, word ptr [bp + 0x10]
  00E19E  8946f0           mov word ptr [bp - 0x10], ax
  00E1A1  0bc0             or ax, ax
  00E1A3  7503             jne 0xe1a8
  00E1A5  e9e800           jmp 0xe290
  00E1A8  837ef200         cmp word ptr [bp - 0xe], 0
  00E1AC  7503             jne 0xe1b1
  00E1AE  e9df00           jmp 0xe290
  00E1B1  8b561e           mov dx, word ptr [bp + 0x1e]
  00E1B4  8b4616           mov ax, word ptr [bp + 0x16]
  00E1B7  2bc2             sub ax, dx
  00E1B9  0bc0             or ax, ax
  00E1BB  7f03             jg 0xe1c0
  00E1BD  f7d0             not ax
  00E1BF  40               inc ax
  00E1C0  8946fe           mov word ptr [bp - 2], ax
  00E1C3  99               cdq
  00E1C4  f77ef0           idiv word ptr [bp - 0x10]
  00E1C7  8956ee           mov word ptr [bp - 0x12], dx
  00E1CA  8b5e18           mov bx, word ptr [bp + 0x18]
  00E1CD  8b7620           mov si, word ptr [bp + 0x20]
  00E1D0  8bc3             mov ax, bx
  00E1D2  2bc6             sub ax, si
  00E1D4  0bc0             or ax, ax
  00E1D6  7f03             jg 0xe1db
  00E1D8  f7d0             not ax
  00E1DA  40               inc ax
  00E1DB  8946fe           mov word ptr [bp - 2], ax
  00E1DE  99               cdq
  00E1DF  f77ef2           idiv word ptr [bp - 0xe]
  00E1E2  8956f8           mov word ptr [bp - 8], dx
  00E1E5  8b7616           mov si, word ptr [bp + 0x16]
  00E1E8  03761a           add si, word ptr [bp + 0x1a]
  00E1EB  8bc3             mov ax, bx
  00E1ED  035e1c           add bx, word ptr [bp + 0x1c]
  00E1F0  895ef4           mov word ptr [bp - 0xc], bx
  00E1F3  8946fa           mov word ptr [bp - 6], ax
  00E1F6  3bd8             cmp bx, ax
  00E1F8  7f03             jg 0xe1fd
  00E1FA  e99300           jmp 0xe290
  00E1FD  8976f6           mov word ptr [bp - 0xa], si
  00E200  8b46ee           mov ax, word ptr [bp - 0x12]
  00E203  8946fc           mov word ptr [bp - 4], ax
  00E206  8b4616           mov ax, word ptr [bp + 0x16]
  00E209  8946fe           mov word ptr [bp - 2], ax
  00E20C  3b46f6           cmp ax, word ptr [bp - 0xa]
  00E20F  7d66             jge 0xe277
  00E211  ff7614           push word ptr [bp + 0x14]
  00E214  ff7612           push word ptr [bp + 0x12]
  00E217  ff7610           push word ptr [bp + 0x10]
  00E21A  ff760e           push word ptr [bp + 0xe]
  00E21D  ff760c           push word ptr [bp + 0xc]
  00E220  ff760a           push word ptr [bp + 0xa]
  00E223  ff7608           push word ptr [bp + 8]
  00E226  ff7606           push word ptr [bp + 6]
  00E229  ff76fa           push word ptr [bp - 6]
  00E22C  8b46fe           mov ax, word ptr [bp - 2]
  00E22F  2b46fc           sub ax, word ptr [bp - 4]
  00E232  0346f0           add ax, word ptr [bp - 0x10]
  00E235  8bc8             mov cx, ax
  00E237  3b46f6           cmp ax, word ptr [bp - 0xa]
  00E23A  7e03             jle 0xe23f
  00E23C  8b46f6           mov ax, word ptr [bp - 0xa]
  00E23F  2b46fe           sub ax, word ptr [bp - 2]
  00E242  50               push ax
  00E243  8b46fa           mov ax, word ptr [bp - 6]
  00E246  2b46f8           sub ax, word ptr [bp - 8]
  00E249  0346f2           add ax, word ptr [bp - 0xe]
  00E24C  3b46f4           cmp ax, word ptr [bp - 0xc]
  00E24F  7e03             jle 0xe254
  00E251  8b46f4           mov ax, word ptr [bp - 0xc]
  00E254  2b46fa           sub ax, word ptr [bp - 6]
  00E257  50               push ax
  00E258  8b46fc           mov ax, word ptr [bp - 4]
  00E25B  8b56f8           mov dx, word ptr [bp - 8]
  00E25E  8b5efe           mov bx, word ptr [bp - 2]
  00E261  8bf1             mov si, cx
  00E263  9a0000670c       lcall 0xc67, 0
  00E268  8976fe           mov word ptr [bp - 2], si
  00E26B  c746fc0000       mov word ptr [bp - 4], 0
  00E270  8b46f6           mov ax, word ptr [bp - 0xa]
  00E273  3bf0             cmp si, ax
  00E275  7c9a             jl 0xe211
  00E277  8b46f2           mov ax, word ptr [bp - 0xe]
  00E27A  2b46f8           sub ax, word ptr [bp - 8]
  00E27D  0146fa           add word ptr [bp - 6], ax
  00E280  c746f80000       mov word ptr [bp - 8], 0
  00E285  8b46f4           mov ax, word ptr [bp - 0xc]
  00E288  3946fa           cmp word ptr [bp - 6], ax
  00E28B  7d03             jge 0xe290
  00E28D  e970ff           jmp 0xe200
  00E290  5e               pop si
  00E291  c9               leave
  00E292  cb               retf
  00E293  90               nop
  00E294  c8020000         enter 2, 0
  00E298  57               push di
  00E299  56               push si
  00E29A  b462             mov ah, 0x62
  00E29C  cd21             int 0x21
  00E29E  895efe           mov word ptr [bp - 2], bx
  00E2A1  b452             mov ah, 0x52
  00E2A3  cd21             int 0x21
  00E2A5  268b5ffe         mov bx, word ptr es:[bx - 2]
  00E2A9  33ff             xor di, di
  00E2AB  8b5606           mov dx, word ptr [bp + 6]
  00E2AE  8ec3             mov es, bx
  00E2B0  26837d0100       cmp word ptr es:[di + 1], 0
  00E2B5  755f             jne 0xe316
  00E2B7  0bf6             or si, si
  00E2B9  7417             je 0xe2d2
  00E2BB  268a05           mov al, byte ptr es:[di]
  00E2BE  268b4d03         mov cx, word ptr es:[di + 3]
  00E2C2  8ec6             mov es, si
  00E2C4  8bde             mov bx, si
  00E2C6  268805           mov byte ptr es:[di], al
  00E2C9  26014d03         add word ptr es:[di + 3], cx
  00E2CD  2683450301       add word ptr es:[di + 3], 1
  00E2D2  268b4d03         mov cx, word ptr es:[di + 3]
  00E2D6  3bca             cmp cx, dx
  00E2D8  7238             jb 0xe312
  00E2DA  7428             je 0xe304
  00E2DC  1e               push ds
  00E2DD  8cc0             mov ax, es
  00E2DF  03c2             add ax, dx
  00E2E1  050100           add ax, 1
  00E2E4  8ed8             mov ds, ax
  00E2E6  2bca             sub cx, dx
  00E2E8  83e901           sub cx, 1
  00E2EB  3e894d03         mov word ptr ds:[di + 3], cx
  00E2EF  3ec745010000     mov word ptr ds:[di + 1], 0
  00E2F5  268a05           mov al, byte ptr es:[di]
  00E2F8  3e8805           mov byte ptr ds:[di], al
  00E2FB  26c6054d         mov byte ptr es:[di], 0x4d
  00E2FF  26895503         mov word ptr es:[di + 3], dx
  00E303  1f               pop ds
  00E304  8b46fe           mov ax, word ptr [bp - 2]
  00E307  26894501         mov word ptr es:[di + 1], ax
  00E30B  8cc0             mov ax, es
  00E30D  40               inc ax
  00E30E  5e               pop si
  00E30F  5f               pop di
  00E310  c9               leave
  00E311  cb               retf
  00E312  8cc6             mov si, es
  00E314  eb02             jmp 0xe318
  00E316  33f6             xor si, si
  00E318  26803d5a         cmp byte ptr es:[di], 0x5a
  00E31C  7408             je 0xe326
  00E31E  26035d03         add bx, word ptr es:[di + 3]
  00E322  43               inc bx
  00E323  eb89             jmp 0xe2ae
  00E325  90               nop
  00E326  33c0             xor ax, ax
  00E328  5e               pop si
  00E329  5f               pop di
  00E32A  c9               leave
  00E32B  cb               retf
  00E32C  c8020000         enter 2, 0
  00E330  c746fe0000       mov word ptr [bp - 2], 0
  00E335  c6064b0700       mov byte ptr [0x74b], 0
  00E33A  b452             mov ah, 0x52
  00E33C  cd21             int 0x21
  00E33E  268b47fe         mov ax, word ptr es:[bx - 2]
  00E342  8ec0             mov es, ax
  00E344  33db             xor bx, bx
  00E346  268a07           mov al, byte ptr es:[bx]
  00E349  3c5a             cmp al, 0x5a
  00E34B  7414             je 0xe361
  00E34D  3c4d             cmp al, 0x4d
  00E34F  750d             jne 0xe35e
  00E351  268b4f03         mov cx, word ptr es:[bx + 3]
  00E355  8cc2             mov dx, es
  00E357  03d1             add dx, cx
  00E359  42               inc dx
  00E35A  8ec2             mov es, dx
  00E35C  ebe8             jmp 0xe346
  00E35E  8c46fe           mov word ptr [bp - 2], es
  00E361  837efe00         cmp word ptr [bp - 2], 0
  00E365  7417             je 0xe37e
  00E367  6a00             push 0
  00E369  ff76fe           push word ptr [bp - 2]
  00E36C  6a00             push 0
  00E36E  6a00             push 0
  00E370  b8beff           mov ax, 0xffbe
  00E373  ba0300           mov dx, 3
  00E376  bb0b00           mov bx, 0xb
  00E379  9ad603d00e       lcall 0xed0, 0x3d6
  00E37E  c9               leave
  00E37F  cb               retf
  00E380  55               push bp
  00E381  8bec             mov bp, sp
  00E383  8b4606           mov ax, word ptr [bp + 6]
  00E386  0b4608           or ax, word ptr [bp + 8]
  00E389  740f             je 0xe39a
  00E38B  c7066e07ffff     mov word ptr [0x76e], 0xffff
  00E391  ff5e06           lcall [bp + 6]
  00E394  c7066e070000     mov word ptr [0x76e], 0
  00E39A  c9               leave
  00E39B  cb               retf
  00E39C  55               push bp
  00E39D  8bec             mov bp, sp
  00E39F  57               push di
  00E3A0  56               push si
  00E3A1  1e               push ds
  00E3A2  c5760a           lds si, ptr [bp + 0xa]
  00E3A5  8b4608           mov ax, word ptr [bp + 8]
  00E3A8  48               dec ax
  00E3A9  8ec0             mov es, ax
  00E3AB  bf0800           mov di, 8
  00E3AE  33c0             xor ax, ax
  00E3B0  b90400           mov cx, 4
  00E3B3  f3ab             rep stosw word ptr es:[di], ax
  00E3B5  bf0800           mov di, 8
  00E3B8  b90800           mov cx, 8
  00E3BB  ac               lodsb al, byte ptr [si]
  00E3BC  0ac0             or al, al
  00E3BE  aa               stosb byte ptr es:[di], al
  00E3BF  e0fa             loopne 0xe3bb
  00E3C1  1f               pop ds
  00E3C2  5e               pop si
  00E3C3  5f               pop di
  00E3C4  c9               leave
  00E3C5  cb               retf
