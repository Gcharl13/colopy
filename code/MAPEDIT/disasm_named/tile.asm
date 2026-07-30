; MAPEDIT.EXE named disasm — module tile.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _tile_allocate  file 0x0046B6..0x0046CE  seg 0x30B:0x6  (tile.obj) ----
  0046B6  c8080000         enter 8, 0
  0046BA  8b4606           mov ax, word ptr [bp + 6]
  0046BD  99               cdq
  0046BE  8af2             mov dh, dl
  0046C0  8ad4             mov dl, ah
  0046C2  8ae0             mov ah, al
  0046C4  2ac0             sub al, al
  0046C6  9ae202c90c       lcall 0xcc9, 0x2e2
  0046CB  c9               leave
  0046CC  cb               retf
  0046CD  90               nop

; ---- _tile_id  file 0x0046CE..0x0046F8  seg 0x30B:0x1e  (tile.obj) ----
  0046CE  55               push bp
  0046CF  8bec             mov bp, sp
  0046D1  837e0611         cmp word ptr [bp + 6], 0x11
  0046D5  7406             je 0x46dd
  0046D7  837e0609         cmp word ptr [bp + 6], 9
  0046DB  750b             jne 0x46e8
  0046DD  c746060800       mov word ptr [bp + 6], 8
  0046E2  8b4606           mov ax, word ptr [bp + 6]
  0046E5  c9               leave
  0046E6  cb               retf
  0046E7  90               nop
  0046E8  837e0608         cmp word ptr [bp + 6], 8
  0046EC  7c04             jl 0x46f2
  0046EE  836e060f         sub word ptr [bp + 6], 0xf
  0046F2  8b4606           mov ax, word ptr [bp + 6]
  0046F5  c9               leave
  0046F6  cb               retf
  0046F7  90               nop

; ---- _tile_draw  file 0x0046F8..0x00475C  seg 0x30B:0x48  (tile.obj) ----
  0046F8  c80c0000         enter 0xc, 0
  0046FC  57               push di
  0046FD  56               push si
  0046FE  ff760a           push word ptr [bp + 0xa]
  004701  0e               push cs
  004702  e8c9ff           call 0x46ce
  004705  83c402           add sp, 2
  004708  89460a           mov word ptr [bp + 0xa], ax
  00470B  8b5e0c           mov bx, word ptr [bp + 0xc]
  00470E  8b460e           mov ax, word ptr [bp + 0xe]
  004711  8b5610           mov dx, word ptr [bp + 0x10]
  004714  9a0000910c       lcall 0xc91, 0
  004719  8946fc           mov word ptr [bp - 4], ax
  00471C  8956fe           mov word ptr [bp - 2], dx
  00471F  8b5e0c           mov bx, word ptr [bp + 0xc]
  004722  8b4702           mov ax, word ptr [bx + 2]
  004725  8946f8           mov word ptr [bp - 8], ax
  004728  2d1000           sub ax, 0x10
  00472B  8946fa           mov word ptr [bp - 6], ax
  00472E  8a660a           mov ah, byte ptr [bp + 0xa]
  004731  2ac0             sub al, al
  004733  034606           add ax, word ptr [bp + 6]
  004736  8b5608           mov dx, word ptr [bp + 8]
  004739  8946f4           mov word ptr [bp - 0xc], ax
  00473C  8956f6           mov word ptr [bp - 0xa], dx
  00473F  1e               push ds
  004740  c47efc           les di, ptr [bp - 4]
  004743  c576f4           lds si, ptr [bp - 0xc]
  004746  bb1000           mov bx, 0x10
  004749  8b56fa           mov dx, word ptr [bp - 6]
  00474C  b91000           mov cx, 0x10
  00474F  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  004751  03fa             add di, dx
  004753  4b               dec bx
  004754  75f6             jne 0x474c
  004756  1f               pop ds
  004757  5e               pop si
  004758  5f               pop di
  004759  c9               leave
  00475A  cb               retf
  00475B  90               nop

; ---- _tile_draw_mask  file 0x00475C..0x0047CE  seg 0x30B:0xac  (tile.obj) ----
  00475C  c80c0000         enter 0xc, 0
  004760  57               push di
  004761  56               push si
  004762  ff760a           push word ptr [bp + 0xa]
  004765  0e               push cs
  004766  e865ff           call 0x46ce
  004769  83c402           add sp, 2
  00476C  89460a           mov word ptr [bp + 0xa], ax
  00476F  8b5e0c           mov bx, word ptr [bp + 0xc]
  004772  8b460e           mov ax, word ptr [bp + 0xe]
  004775  8b5610           mov dx, word ptr [bp + 0x10]
  004778  9a0000910c       lcall 0xc91, 0
  00477D  8946fc           mov word ptr [bp - 4], ax
  004780  8956fe           mov word ptr [bp - 2], dx
  004783  8b5e0c           mov bx, word ptr [bp + 0xc]
  004786  8b4702           mov ax, word ptr [bx + 2]
  004789  8946f8           mov word ptr [bp - 8], ax
  00478C  2d1000           sub ax, 0x10
  00478F  8946fa           mov word ptr [bp - 6], ax
  004792  8a660a           mov ah, byte ptr [bp + 0xa]
  004795  2ac0             sub al, al
  004797  034606           add ax, word ptr [bp + 6]
  00479A  8b5608           mov dx, word ptr [bp + 8]
  00479D  8946f4           mov word ptr [bp - 0xc], ax
  0047A0  8956f6           mov word ptr [bp - 0xa], dx
  0047A3  1e               push ds
  0047A4  c47efc           les di, ptr [bp - 4]
  0047A7  c576f4           lds si, ptr [bp - 0xc]
  0047AA  bb1000           mov bx, 0x10
  0047AD  8b56fa           mov dx, word ptr [bp - 6]
  0047B0  b91000           mov cx, 0x10
  0047B3  268a05           mov al, byte ptr es:[di]
  0047B6  0ac0             or al, al
  0047B8  7506             jne 0x47c0
  0047BA  a4               movsb byte ptr es:[di], byte ptr [si]
  0047BB  e2f6             loop 0x47b3
  0047BD  eb05             jmp 0x47c4
  0047BF  90               nop
  0047C0  47               inc di
  0047C1  46               inc si
  0047C2  e2ef             loop 0x47b3
  0047C4  03fa             add di, dx
  0047C6  4b               dec bx
  0047C7  75e7             jne 0x47b0
  0047C9  1f               pop ds
  0047CA  5e               pop si
  0047CB  5f               pop di
  0047CC  c9               leave
  0047CD  cb               retf

; ---- _tile_draw_scale  file 0x0047CE..0x004884  seg 0x30B:0x11e  (tile.obj) ----
  0047CE  c81a0000         enter 0x1a, 0
  0047D2  57               push di
  0047D3  56               push si
  0047D4  ff760a           push word ptr [bp + 0xa]
  0047D7  0e               push cs
  0047D8  e8f3fe           call 0x46ce
  0047DB  83c402           add sp, 2
  0047DE  89460a           mov word ptr [bp + 0xa], ax
  0047E1  8a4e12           mov cl, byte ptr [bp + 0x12]
  0047E4  b81000           mov ax, 0x10
  0047E7  d3f8             sar ax, cl
  0047E9  8946ee           mov word ptr [bp - 0x12], ax
  0047EC  8946ec           mov word ptr [bp - 0x14], ax
  0047EF  ba0100           mov dx, 1
  0047F2  d3e2             shl dx, cl
  0047F4  8956f6           mov word ptr [bp - 0xa], dx
  0047F7  8bd8             mov bx, ax
  0047F9  48               dec ax
  0047FA  f7d8             neg ax
  0047FC  014610           add word ptr [bp + 0x10], ax
  0047FF  8bc2             mov ax, dx
  004801  8bd3             mov dx, bx
  004803  d1fb             sar bx, 1
  004805  295e0e           sub word ptr [bp + 0xe], bx
  004808  8bf0             mov si, ax
  00480A  8b5e0c           mov bx, word ptr [bp + 0xc]
  00480D  8b460e           mov ax, word ptr [bp + 0xe]
  004810  8bfa             mov di, dx
  004812  8b5610           mov dx, word ptr [bp + 0x10]
  004815  9a0000910c       lcall 0xc91, 0
  00481A  8946fa           mov word ptr [bp - 6], ax
  00481D  8956fc           mov word ptr [bp - 4], dx
  004820  8b5e0c           mov bx, word ptr [bp + 0xc]
  004823  8b4702           mov ax, word ptr [bx + 2]
  004826  8946f2           mov word ptr [bp - 0xe], ax
  004829  2bc7             sub ax, di
  00482B  8946f4           mov word ptr [bp - 0xc], ax
  00482E  8a4e12           mov cl, byte ptr [bp + 0x12]
  004831  b81000           mov ax, 0x10
  004834  d3e0             shl ax, cl
  004836  8946fe           mov word ptr [bp - 2], ax
  004839  d1fe             sar si, 1
  00483B  8976f8           mov word ptr [bp - 8], si
  00483E  c1e604           shl si, 4
  004841  8976ea           mov word ptr [bp - 0x16], si
  004844  8a660a           mov ah, byte ptr [bp + 0xa]
  004847  2ac0             sub al, al
  004849  034606           add ax, word ptr [bp + 6]
  00484C  8b5608           mov dx, word ptr [bp + 8]
  00484F  8946e6           mov word ptr [bp - 0x1a], ax
  004852  8956e8           mov word ptr [bp - 0x18], dx
  004855  1e               push ds
  004856  c47efa           les di, ptr [bp - 6]
  004859  c576e6           lds si, ptr [bp - 0x1a]
  00485C  0376f8           add si, word ptr [bp - 8]
  00485F  0376ea           add si, word ptr [bp - 0x16]
  004862  8b5eec           mov bx, word ptr [bp - 0x14]
  004865  8976f0           mov word ptr [bp - 0x10], si
  004868  8b4eee           mov cx, word ptr [bp - 0x12]
  00486B  8a04             mov al, byte ptr [si]
  00486D  aa               stosb byte ptr es:[di], al
  00486E  0376f6           add si, word ptr [bp - 0xa]
  004871  e2f8             loop 0x486b
  004873  8b76f0           mov si, word ptr [bp - 0x10]
  004876  0376fe           add si, word ptr [bp - 2]
  004879  037ef4           add di, word ptr [bp - 0xc]
  00487C  4b               dec bx
  00487D  75e6             jne 0x4865
  00487F  1f               pop ds
  004880  5e               pop si
  004881  5f               pop di
  004882  c9               leave
  004883  cb               retf

; ---- _tile_draw_scale_mask  file 0x004884..0x00494A  seg 0x30B:0x1d4  (tile.obj) ----
  004884  c81a0000         enter 0x1a, 0
  004888  57               push di
  004889  56               push si
  00488A  ff760a           push word ptr [bp + 0xa]
  00488D  0e               push cs
  00488E  e83dfe           call 0x46ce
  004891  83c402           add sp, 2
  004894  89460a           mov word ptr [bp + 0xa], ax
  004897  8a4e12           mov cl, byte ptr [bp + 0x12]
  00489A  b81000           mov ax, 0x10
  00489D  d3f8             sar ax, cl
  00489F  8946ee           mov word ptr [bp - 0x12], ax
  0048A2  8946ec           mov word ptr [bp - 0x14], ax
  0048A5  ba0100           mov dx, 1
  0048A8  d3e2             shl dx, cl
  0048AA  8956f6           mov word ptr [bp - 0xa], dx
  0048AD  8bd8             mov bx, ax
  0048AF  48               dec ax
  0048B0  f7d8             neg ax
  0048B2  014610           add word ptr [bp + 0x10], ax
  0048B5  8bc2             mov ax, dx
  0048B7  8bd3             mov dx, bx
  0048B9  d1fb             sar bx, 1
  0048BB  295e0e           sub word ptr [bp + 0xe], bx
  0048BE  8bf0             mov si, ax
  0048C0  8b5e0c           mov bx, word ptr [bp + 0xc]
  0048C3  8b460e           mov ax, word ptr [bp + 0xe]
  0048C6  8bfa             mov di, dx
  0048C8  8b5610           mov dx, word ptr [bp + 0x10]
  0048CB  9a0000910c       lcall 0xc91, 0
  0048D0  8946fa           mov word ptr [bp - 6], ax
  0048D3  8956fc           mov word ptr [bp - 4], dx
  0048D6  8b5e0c           mov bx, word ptr [bp + 0xc]
  0048D9  8b4702           mov ax, word ptr [bx + 2]
  0048DC  8946f2           mov word ptr [bp - 0xe], ax
  0048DF  2bc7             sub ax, di
  0048E1  8946f4           mov word ptr [bp - 0xc], ax
  0048E4  8a4e12           mov cl, byte ptr [bp + 0x12]
  0048E7  b81000           mov ax, 0x10
  0048EA  d3e0             shl ax, cl
  0048EC  8946fe           mov word ptr [bp - 2], ax
  0048EF  d1fe             sar si, 1
  0048F1  8976f8           mov word ptr [bp - 8], si
  0048F4  c1e604           shl si, 4
  0048F7  8976ea           mov word ptr [bp - 0x16], si
  0048FA  8a660a           mov ah, byte ptr [bp + 0xa]
  0048FD  2ac0             sub al, al
  0048FF  034606           add ax, word ptr [bp + 6]
  004902  8b5608           mov dx, word ptr [bp + 8]
  004905  8946e6           mov word ptr [bp - 0x1a], ax
  004908  8956e8           mov word ptr [bp - 0x18], dx
  00490B  1e               push ds
  00490C  c47efa           les di, ptr [bp - 6]
  00490F  c576e6           lds si, ptr [bp - 0x1a]
  004912  0376f8           add si, word ptr [bp - 8]
  004915  0376ea           add si, word ptr [bp - 0x16]
  004918  8b5eec           mov bx, word ptr [bp - 0x14]
  00491B  8976f0           mov word ptr [bp - 0x10], si
  00491E  8b4eee           mov cx, word ptr [bp - 0x12]
  004921  268a05           mov al, byte ptr es:[di]
  004924  0ac0             or al, al
  004926  750a             jne 0x4932
  004928  8a04             mov al, byte ptr [si]
  00492A  aa               stosb byte ptr es:[di], al
  00492B  0376f6           add si, word ptr [bp - 0xa]
  00492E  e2f1             loop 0x4921
  004930  eb06             jmp 0x4938
  004932  46               inc si
  004933  0376f6           add si, word ptr [bp - 0xa]
  004936  e2e9             loop 0x4921
  004938  8b76f0           mov si, word ptr [bp - 0x10]
  00493B  0376fe           add si, word ptr [bp - 2]
  00493E  037ef4           add di, word ptr [bp - 0xc]
  004941  4b               dec bx
  004942  75d7             jne 0x491b
  004944  1f               pop ds
  004945  5e               pop si
  004946  5f               pop di
  004947  c9               leave
  004948  cb               retf
  004949  90               nop
