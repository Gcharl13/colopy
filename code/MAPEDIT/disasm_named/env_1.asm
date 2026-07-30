; MAPEDIT.EXE named disasm — module env_1.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @env_catint  file 0x003F7C..0x00402A  seg 0x297:0xc  (env_1.obj) ----
  003F7C  c8060000         enter 6, 0
  003F80  52               push dx
  003F81  50               push ax
  003F82  57               push di
  003F83  56               push si
  003F84  bf0100           mov di, 1
  003F87  2bf6             sub si, si
  003F89  3bd6             cmp dx, si
  003F8B  7e23             jle 0x3fb0
  003F8D  0bf6             or si, si
  003F8F  7e07             jle 0x3f98
  003F91  b80a00           mov ax, 0xa
  003F94  f7ef             imul di
  003F96  8bf8             mov di, ax
  003F98  1e               push ds
  003F99  689804           push 0x498
  003F9C  ff7608           push word ptr [bp + 8]
  003F9F  ff7606           push word ptr [bp + 6]
  003FA2  9a220e8813       lcall 0x1388, 0xe22
  003FA7  83c408           add sp, 8
  003FAA  46               inc si
  003FAB  3b76f8           cmp si, word ptr [bp - 8]
  003FAE  7cdd             jl 0x3f8d
  003FB0  897efa           mov word ptr [bp - 6], di
  003FB3  ff7608           push word ptr [bp + 8]
  003FB6  ff7606           push word ptr [bp + 6]
  003FB9  9ad40d8813       lcall 0x1388, 0xdd4
  003FBE  83c404           add sp, 4
  003FC1  8bf0             mov si, ax
  003FC3  2b76f8           sub si, word ptr [bp - 8]
  003FC6  ff7608           push word ptr [bp + 8]
  003FC9  ff7606           push word ptr [bp + 6]
  003FCC  9ad40d8813       lcall 0x1388, 0xdd4
  003FD1  83c404           add sp, 4
  003FD4  3bc6             cmp ax, si
  003FD6  7645             jbe 0x401d
  003FD8  8976fc           mov word ptr [bp - 4], si
  003FDB  8b76fa           mov si, word ptr [bp - 6]
  003FDE  8b7ef6           mov di, word ptr [bp - 0xa]
  003FE1  3bf7             cmp si, di
  003FE3  7f18             jg 0x3ffd
  003FE5  8bc7             mov ax, di
  003FE7  99               cdq
  003FE8  f7fe             idiv si
  003FEA  8946fe           mov word ptr [bp - 2], ax
  003FED  f7ee             imul si
  003FEF  2bf8             sub di, ax
  003FF1  8a46fe           mov al, byte ptr [bp - 2]
  003FF4  c45e06           les bx, ptr [bp + 6]
  003FF7  035efc           add bx, word ptr [bp - 4]
  003FFA  260007           add byte ptr es:[bx], al
  003FFD  b90a00           mov cx, 0xa
  004000  8bc6             mov ax, si
  004002  99               cdq
  004003  f7f9             idiv cx
  004005  8bf0             mov si, ax
  004007  ff7608           push word ptr [bp + 8]
  00400A  ff7606           push word ptr [bp + 6]
  00400D  9ad40d8813       lcall 0x1388, 0xdd4
  004012  83c404           add sp, 4
  004015  ff46fc           inc word ptr [bp - 4]
  004018  3b46fc           cmp ax, word ptr [bp - 4]
  00401B  77c4             ja 0x3fe1
  00401D  8b4606           mov ax, word ptr [bp + 6]
  004020  8b5608           mov dx, word ptr [bp + 8]
  004023  5e               pop si
  004024  5f               pop di
  004025  c9               leave
  004026  ca0400           retf 4
  004029  90               nop

; ---- _env_get_path  file 0x00402A..0x004074  seg 0x297:0xba  (env_1.obj) ----
  00402A  55               push bp
  00402B  8bec             mov bp, sp
  00402D  57               push di
  00402E  56               push si
  00402F  8b760a           mov si, word ptr [bp + 0xa]
  004032  8e460c           mov es, word ptr [bp + 0xc]
  004035  26803c2a         cmp byte ptr es:[si], 0x2a
  004039  7503             jne 0x403e
  00403B  46               inc si
  00403C  8cc0             mov ax, es
  00403E  833e9c0400       cmp word ptr [0x49c], 0
  004043  7513             jne 0x4058
  004045  8b7e06           mov di, word ptr [bp + 6]
  004048  06               push es
  004049  56               push si
  00404A  ff7608           push word ptr [bp + 8]
  00404D  57               push di
  00404E  9aec0d8813       lcall 0x1388, 0xdec
  004053  83c408           add sp, 8
  004056  eb12             jmp 0x406a
  004058  8b7e06           mov di, word ptr [bp + 6]
  00405B  ff7608           push word ptr [bp + 8]
  00405E  57               push di
  00405F  1e               push ds
  004060  68aa4e           push 0x4eaa
  004063  06               push es
  004064  56               push si
  004065  9a0400110c       lcall 0xc11, 4
  00406A  8bc7             mov ax, di
  00406C  8b5608           mov dx, word ptr [bp + 8]
  00406F  5e               pop si
  004070  5f               pop di
  004071  c9               leave
  004072  cb               retf
  004073  90               nop

; ---- @env_open  file 0x004074..0x0040A0  seg 0x297:0x104  (env_1.obj) ----
  004074  c8500000         enter 0x50, 0
  004078  53               push bx
  004079  56               push si
  00407A  8bf3             mov si, bx
  00407C  ff7608           push word ptr [bp + 8]
  00407F  ff7606           push word ptr [bp + 6]
  004082  8d46b0           lea ax, [bp - 0x50]
  004085  16               push ss
  004086  50               push ax
  004087  0e               push cs
  004088  e89fff           call 0x402a
  00408B  83c408           add sp, 8
  00408E  56               push si
  00408F  8d46b0           lea ax, [bp - 0x50]
  004092  50               push ax
  004093  9aa8038813       lcall 0x1388, 0x3a8
  004098  83c404           add sp, 4
  00409B  5e               pop si
  00409C  c9               leave
  00409D  ca0400           retf 4

; ---- @env_get_file_size  file 0x0040A0..0x0040B2  seg 0x297:0x130  (env_1.obj) ----
  0040A0  56               push si
  0040A1  8bf3             mov si, bx
  0040A3  8a4407           mov al, byte ptr [si + 7]
  0040A6  98               cwde
  0040A7  50               push ax
  0040A8  9a62098813       lcall 0x1388, 0x962
  0040AD  83c402           add sp, 2
  0040B0  5e               pop si
  0040B1  cb               retf

; ---- @env_exist  file 0x0040B2..0x0040BE  seg 0x297:0x142  (env_1.obj) ----
  0040B2  55               push bp
  0040B3  8bec             mov bp, sp
  0040B5  53               push bx
  0040B6  9a1c00fb0b       lcall 0xbfb, 0x1c
  0040BB  c9               leave
  0040BC  cb               retf
  0040BD  90               nop
