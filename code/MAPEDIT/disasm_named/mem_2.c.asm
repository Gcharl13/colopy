; MAPEDIT.EXE named disasm — module mem_2.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mem_get_name  file 0x00E3C6..0x00E572  seg 0xCC9:0x136  (mem_2.c.obj) ----
  00E3C6  c8140000         enter 0x14, 0
  00E3CA  52               push dx
  00E3CB  50               push ax
  00E3CC  2bc9             sub cx, cx
  00E3CE  894efa           mov word ptr [bp - 6], cx
  00E3D1  894ef8           mov word ptr [bp - 8], cx
  00E3D4  0bd2             or dx, dx
  00E3D6  7f0c             jg 0xe3e4
  00E3D8  7d03             jge 0xe3dd
  00E3DA  e95601           jmp 0xe533
  00E3DD  0bc0             or ax, ax
  00E3DF  7503             jne 0xe3e4
  00E3E1  e94f01           jmp 0xe533
  00E3E4  9a6800080d       lcall 0xd08, 0x68
  00E3E9  8946ec           mov word ptr [bp - 0x14], ax
  00E3EC  8956ee           mov word ptr [bp - 0x12], dx
  00E3EF  9a0c007e12       lcall 0x127e, 0xc
  00E3F4  8946fc           mov word ptr [bp - 4], ax
  00E3F7  8956fe           mov word ptr [bp - 2], dx
  00E3FA  8b46e8           mov ax, word ptr [bp - 0x18]
  00E3FD  8b56ea           mov dx, word ptr [bp - 0x16]
  00E400  a34e07           mov word ptr [0x74e], ax
  00E403  89165007         mov word ptr [0x750], dx
  00E407  8b46ec           mov ax, word ptr [bp - 0x14]
  00E40A  8b56ee           mov dx, word ptr [bp - 0x12]
  00E40D  a35207           mov word ptr [0x752], ax
  00E410  89165407         mov word ptr [0x754], dx
  00E414  8b4efc           mov cx, word ptr [bp - 4]
  00E417  8b5efe           mov bx, word ptr [bp - 2]
  00E41A  890e5607         mov word ptr [0x756], cx
  00E41E  891e5807         mov word ptr [0x758], bx
  00E422  803e490700       cmp byte ptr [0x749], 0
  00E427  7513             jne 0xe43c
  00E429  a35a07           mov word ptr [0x75a], ax
  00E42C  89165c07         mov word ptr [0x75c], dx
  00E430  a35e07           mov word ptr [0x75e], ax
  00E433  89166007         mov word ptr [0x760], dx
  00E437  c6064907ff       mov byte ptr [0x749], 0xff
  00E43C  803e4a0700       cmp byte ptr [0x74a], 0
  00E441  7517             jne 0xe45a
  00E443  8bc1             mov ax, cx
  00E445  8bd3             mov dx, bx
  00E447  a36207           mov word ptr [0x762], ax
  00E44A  89166407         mov word ptr [0x764], dx
  00E44E  a36607           mov word ptr [0x766], ax
  00E451  89166807         mov word ptr [0x768], dx
  00E455  c6064a07ff       mov byte ptr [0x74a], 0xff
  00E45A  8bc1             mov ax, cx
  00E45C  8bd3             mov dx, bx
  00E45E  3956ea           cmp word ptr [bp - 0x16], dx
  00E461  7f0d             jg 0xe470
  00E463  7c05             jl 0xe46a
  00E465  3946e8           cmp word ptr [bp - 0x18], ax
  00E468  7706             ja 0xe470
  00E46A  b80100           mov ax, 1
  00E46D  eb03             jmp 0xe472
  00E46F  90               nop
  00E470  2bc0             sub ax, ax
  00E472  8946f6           mov word ptr [bp - 0xa], ax
  00E475  8bc1             mov ax, cx
  00E477  3956ea           cmp word ptr [bp - 0x16], dx
  00E47A  7f07             jg 0xe483
  00E47C  7c0b             jl 0xe489
  00E47E  3946e8           cmp word ptr [bp - 0x18], ax
  00E481  7606             jbe 0xe489
  00E483  8b46ec           mov ax, word ptr [bp - 0x14]
  00E486  8b56ee           mov dx, word ptr [bp - 0x12]
  00E489  8946f0           mov word ptr [bp - 0x10], ax
  00E48C  8956f2           mov word ptr [bp - 0xe], dx
  00E48F  8b46e8           mov ax, word ptr [bp - 0x18]
  00E492  8b56ea           mov dx, word ptr [bp - 0x16]
  00E495  d1fa             sar dx, 1
  00E497  d1d8             rcr ax, 1
  00E499  d1fa             sar dx, 1
  00E49B  d1d8             rcr ax, 1
  00E49D  d1fa             sar dx, 1
  00E49F  d1d8             rcr ax, 1
  00E4A1  d1fa             sar dx, 1
  00E4A3  d1d8             rcr ax, 1
  00E4A5  40               inc ax
  00E4A6  8946f4           mov word ptr [bp - 0xc], ax
  00E4A9  8bc1             mov ax, cx
  00E4AB  8bd3             mov dx, bx
  00E4AD  3956ea           cmp word ptr [bp - 0x16], dx
  00E4B0  7f48             jg 0xe4fa
  00E4B2  7c05             jl 0xe4b9
  00E4B4  3946e8           cmp word ptr [bp - 0x18], ax
  00E4B7  7741             ja 0xe4fa
  00E4B9  ff76ea           push word ptr [bp - 0x16]
  00E4BC  ff76e8           push word ptr [bp - 0x18]
  00E4BF  9a08008112       lcall 0x1281, 8
  00E4C4  83c404           add sp, 4
  00E4C7  8946f8           mov word ptr [bp - 8], ax
  00E4CA  8956fa           mov word ptr [bp - 6], dx
  00E4CD  0bd0             or dx, ax
  00E4CF  7429             je 0xe4fa
  00E4D1  9a0c007e12       lcall 0x127e, 0xc
  00E4D6  8946fc           mov word ptr [bp - 4], ax
  00E4D9  8956fe           mov word ptr [bp - 2], dx
  00E4DC  8946f0           mov word ptr [bp - 0x10], ax
  00E4DF  8956f2           mov word ptr [bp - 0xe], dx
  00E4E2  3b166807         cmp dx, word ptr [0x768]
  00E4E6  7f4b             jg 0xe533
  00E4E8  7c06             jl 0xe4f0
  00E4EA  3b066607         cmp ax, word ptr [0x766]
  00E4EE  7343             jae 0xe533
  00E4F0  a36607           mov word ptr [0x766], ax
  00E4F3  89166807         mov word ptr [0x768], dx
  00E4F7  eb3a             jmp 0xe533
  00E4F9  90               nop
  00E4FA  ff76f4           push word ptr [bp - 0xc]
  00E4FD  9a0400c90c       lcall 0xcc9, 4
  00E502  83c402           add sp, 2
  00E505  0bc0             or ax, ax
  00E507  740b             je 0xe514
  00E509  c746f80000       mov word ptr [bp - 8], 0
  00E50E  8946fa           mov word ptr [bp - 6], ax
  00E511  eb06             jmp 0xe519
  00E513  90               nop
  00E514  9a9c00c90c       lcall 0xcc9, 0x9c
  00E519  9a6800080d       lcall 0xd08, 0x68
  00E51E  3b166007         cmp dx, word ptr [0x760]
  00E522  7f0f             jg 0xe533
  00E524  7c06             jl 0xe52c
  00E526  3b065e07         cmp ax, word ptr [0x75e]
  00E52A  7307             jae 0xe533
  00E52C  a35e07           mov word ptr [0x75e], ax
  00E52F  89166007         mov word ptr [0x760], dx
  00E533  8b46fa           mov ax, word ptr [bp - 6]
  00E536  0b46f8           or ax, word ptr [bp - 8]
  00E539  7505             jne 0xe540
  00E53B  b001             mov al, 1
  00E53D  eb03             jmp 0xe542
  00E53F  90               nop
  00E540  2ac0             sub al, al
  00E542  a24b07           mov byte ptr [0x74b], al
  00E545  0ac0             or al, al
  00E547  7513             jne 0xe55c
  00E549  ff7608           push word ptr [bp + 8]
  00E54C  ff7606           push word ptr [bp + 6]
  00E54F  ff76fa           push word ptr [bp - 6]
  00E552  ff76f8           push word ptr [bp - 8]
  00E555  0e               push cs
  00E556  e843fe           call 0xe39c
  00E559  83c408           add sp, 8
  00E55C  ff366c07         push word ptr [0x76c]
  00E560  ff366a07         push word ptr [0x76a]
  00E564  0e               push cs
  00E565  e818fe           call 0xe380
  00E568  8b46f8           mov ax, word ptr [bp - 8]
  00E56B  8b56fa           mov dx, word ptr [bp - 6]
  00E56E  c9               leave
  00E56F  ca0400           retf 4

; ---- @mem_get  file 0x00E572..0x00E57C  seg 0xCC9:0x2e2  (mem_2.c.obj) ----
  00E572  1e               push ds
  00E573  687007           push 0x770
  00E576  0e               push cs
  00E577  e84cfe           call 0xe3c6
  00E57A  cb               retf
  00E57B  90               nop

; ---- @mem_get_block_name  file 0x00E57C..0x00E5A0  seg 0xCC9:0x2ec  (mem_2.c.obj) ----
  00E57C  55               push bp
  00E57D  8bec             mov bp, sp
  00E57F  57               push di
  00E580  56               push si
  00E581  1e               push ds
  00E582  c47e06           les di, ptr [bp + 6]
  00E585  8b460c           mov ax, word ptr [bp + 0xc]
  00E588  48               dec ax
  00E589  8ed8             mov ds, ax
  00E58B  33f6             xor si, si
  00E58D  b90800           mov cx, 8
  00E590  ac               lodsb al, byte ptr [si]
  00E591  0ac0             or al, al
  00E593  aa               stosb byte ptr es:[di], al
  00E594  e0fa             loopne 0xe590
  00E596  32c0             xor al, al
  00E598  aa               stosb byte ptr es:[di], al
  00E599  1f               pop ds
  00E59A  5e               pop si
  00E59B  5f               pop di
  00E59C  c9               leave
  00E59D  ca0800           retf 8

; ---- @mem_free  file 0x00E5A0..0x00E5F0  seg 0xCC9:0x310  (mem_2.c.obj) ----
  00E5A0  c8060000         enter 6, 0
  00E5A4  8b4608           mov ax, word ptr [bp + 8]
  00E5A7  8946fc           mov word ptr [bp - 4], ax
  00E5AA  817efc00a0       cmp word ptr [bp - 4], 0xa000
  00E5AF  7205             jb 0xe5b6
  00E5B1  b80100           mov ax, 1
  00E5B4  eb02             jmp 0xe5b8
  00E5B6  2bc0             sub ax, ax
  00E5B8  8946fe           mov word ptr [bp - 2], ax
  00E5BB  48               dec ax
  00E5BC  7510             jne 0xe5ce
  00E5BE  ff7608           push word ptr [bp + 8]
  00E5C1  ff7606           push word ptr [bp + 6]
  00E5C4  9a4a008112       lcall 0x1281, 0x4a
  00E5C9  83c404           add sp, 4
  00E5CC  eb0c             jmp 0xe5da
  00E5CE  c44606           les ax, ptr [bp + 6]
  00E5D1  b449             mov ah, 0x49
  00E5D3  cd21             int 0x21
  00E5D5  d0d8             rcr al, 1
  00E5D7  98               cwde
  00E5D8  8ac4             mov al, ah
  00E5DA  8946fa           mov word ptr [bp - 6], ax
  00E5DD  ff366c07         push word ptr [0x76c]
  00E5E1  ff366a07         push word ptr [0x76a]
  00E5E5  0e               push cs
  00E5E6  e897fd           call 0xe380
  00E5E9  8b46fa           mov ax, word ptr [bp - 6]
  00E5EC  c9               leave
  00E5ED  ca0400           retf 4

; ---- @mem_adjust  file 0x00E5F0..0x00E61E  seg 0xCC9:0x360  (mem_2.c.obj) ----
  00E5F0  c8020000         enter 2, 0
  00E5F4  52               push dx
  00E5F5  50               push ax
  00E5F6  d1fa             sar dx, 1
  00E5F8  d1d8             rcr ax, 1
  00E5FA  d1fa             sar dx, 1
  00E5FC  d1d8             rcr ax, 1
  00E5FE  d1fa             sar dx, 1
  00E600  d1d8             rcr ax, 1
  00E602  d1fa             sar dx, 1
  00E604  d1d8             rcr ax, 1
  00E606  40               inc ax
  00E607  8946fe           mov word ptr [bp - 2], ax
  00E60A  c45e06           les bx, ptr [bp + 6]
  00E60D  8b5efe           mov bx, word ptr [bp - 2]
  00E610  b44a             mov ah, 0x4a
  00E612  cd21             int 0x21
  00E614  d0d8             rcr al, 1
  00E616  98               cwde
  00E617  8ac4             mov al, ah
  00E619  c9               leave
  00E61A  ca0400           retf 4
  00E61D  90               nop

; ---- @mem_save_free  file 0x00E61E..0x00E63C  seg 0xCC9:0x38e  (mem_2.c.obj) ----
  00E61E  a15e07           mov ax, word ptr [0x75e]
  00E621  8b166007         mov dx, word ptr [0x760]
  00E625  a3e84a           mov word ptr [0x4ae8], ax
  00E628  8916ea4a         mov word ptr [0x4aea], dx
  00E62C  a16607           mov ax, word ptr [0x766]
  00E62F  8b166807         mov dx, word ptr [0x768]
  00E633  a3c851           mov word ptr [0x51c8], ax
  00E636  8916ca51         mov word ptr [0x51ca], dx
  00E63A  cb               retf
  00E63B  90               nop

; ---- @mem_restore_free  file 0x00E63C..0x00E6E8  seg 0xCC9:0x3ac  (mem_2.c.obj) ----
  00E63C  9a6800080d       lcall 0xd08, 0x68
  00E641  3b16ea4a         cmp dx, word ptr [0x4aea]
  00E645  7f0f             jg 0xe656
  00E647  7c06             jl 0xe64f
  00E649  3b06e84a         cmp ax, word ptr [0x4ae8]
  00E64D  7707             ja 0xe656
  00E64F  9a6800080d       lcall 0xd08, 0x68
  00E654  eb07             jmp 0xe65d
  00E656  a1e84a           mov ax, word ptr [0x4ae8]
  00E659  8b16ea4a         mov dx, word ptr [0x4aea]
  00E65D  a35e07           mov word ptr [0x75e], ax
  00E660  89166007         mov word ptr [0x760], dx
  00E664  9a0c007e12       lcall 0x127e, 0xc
  00E669  3b16ca51         cmp dx, word ptr [0x51ca]
  00E66D  7f0f             jg 0xe67e
  00E66F  7c06             jl 0xe677
  00E671  3b06c851         cmp ax, word ptr [0x51c8]
  00E675  7707             ja 0xe67e
  00E677  9a0c007e12       lcall 0x127e, 0xc
  00E67C  eb07             jmp 0xe685
  00E67E  a1c851           mov ax, word ptr [0x51c8]
  00E681  8b16ca51         mov dx, word ptr [0x51ca]
  00E685  a36607           mov word ptr [0x766], ax
  00E688  89166807         mov word ptr [0x768], dx
  00E68C  cb               retf
  00E68D  90               nop
  00E68E  55               push bp
  00E68F  8bec             mov bp, sp
  00E691  57               push di
  00E692  56               push si
  00E693  b452             mov ah, 0x52
  00E695  cd21             int 0x21
  00E697  268b5ffe         mov bx, word ptr es:[bx - 2]
  00E69B  33ff             xor di, di
  00E69D  33f6             xor si, si
  00E69F  33c0             xor ax, ax
  00E6A1  8ec3             mov es, bx
  00E6A3  26837d0100       cmp word ptr es:[di + 1], 0
  00E6A8  752a             jne 0xe6d4
  00E6AA  0bf6             or si, si
  00E6AC  7417             je 0xe6c5
  00E6AE  268a15           mov dl, byte ptr es:[di]
  00E6B1  268b4d03         mov cx, word ptr es:[di + 3]
  00E6B5  8ec6             mov es, si
  00E6B7  8bde             mov bx, si
  00E6B9  268815           mov byte ptr es:[di], dl
  00E6BC  26014d03         add word ptr es:[di + 3], cx
  00E6C0  2683450301       add word ptr es:[di + 3], 1
  00E6C5  268b4d03         mov cx, word ptr es:[di + 3]
  00E6C9  3bc8             cmp cx, ax
  00E6CB  7602             jbe 0xe6cf
  00E6CD  8bc1             mov ax, cx
  00E6CF  8cc6             mov si, es
  00E6D1  eb03             jmp 0xe6d6
  00E6D3  90               nop
  00E6D4  33f6             xor si, si
  00E6D6  26803d5a         cmp byte ptr es:[di], 0x5a
  00E6DA  7408             je 0xe6e4
  00E6DC  26035d03         add bx, word ptr es:[di + 3]
  00E6E0  43               inc bx
  00E6E1  ebbe             jmp 0xe6a1
  00E6E3  90               nop
  00E6E4  5e               pop si
  00E6E5  5f               pop di
  00E6E6  c9               leave
  00E6E7  c3               ret
