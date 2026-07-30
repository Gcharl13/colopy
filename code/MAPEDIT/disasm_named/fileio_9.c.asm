; MAPEDIT.EXE named disasm — module fileio_9.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @fileio_fwrite_f  file 0x00D4A8..0x00D5B6  seg 0xBEA:0x8  (fileio_9.c.obj) ----
  00D4A8  c80e0000         enter 0xe, 0
  00D4AC  53               push bx
  00D4AD  52               push dx
  00D4AE  50               push ax
  00D4AF  57               push di
  00D4B0  56               push si
  00D4B1  8bfb             mov di, bx
  00D4B3  2bc0             sub ax, ax
  00D4B5  8946f6           mov word ptr [bp - 0xa], ax
  00D4B8  8946f4           mov word ptr [bp - 0xc], ax
  00D4BB  8946fa           mov word ptr [bp - 6], ax
  00D4BE  8946f8           mov word ptr [bp - 8], ax
  00D4C1  8bc2             mov ax, dx
  00D4C3  0b46ec           or ax, word ptr [bp - 0x14]
  00D4C6  7503             jne 0xd4cb
  00D4C8  e9de00           jmp 0xd5a9
  00D4CB  f6450604         test byte ptr [di + 6], 4
  00D4CF  750b             jne 0xd4dc
  00D4D1  6a00             push 0
  00D4D3  57               push di
  00D4D4  9adc088813       lcall 0x1388, 0x8dc
  00D4D9  83c404           add sp, 4
  00D4DC  837e0601         cmp word ptr [bp + 6], 1
  00D4E0  750e             jne 0xd4f0
  00D4E2  837e0800         cmp word ptr [bp + 8], 0
  00D4E6  7508             jne 0xd4f0
  00D4E8  8b46ec           mov ax, word ptr [bp - 0x14]
  00D4EB  8b56ee           mov dx, word ptr [bp - 0x12]
  00D4EE  eb11             jmp 0xd501
  00D4F0  ff7608           push word ptr [bp + 8]
  00D4F3  ff7606           push word ptr [bp + 6]
  00D4F6  ff76ee           push word ptr [bp - 0x12]
  00D4F9  ff76ec           push word ptr [bp - 0x14]
  00D4FC  9abc0b8813       lcall 0x1388, 0xbbc
  00D501  8946fc           mov word ptr [bp - 4], ax
  00D504  8956fe           mov word ptr [bp - 2], dx
  00D507  0bd2             or dx, dx
  00D509  7c77             jl 0xd582
  00D50B  7f04             jg 0xd511
  00D50D  0bc0             or ax, ax
  00D50F  7471             je 0xd582
  00D511  897ef0           mov word ptr [bp - 0x10], di
  00D514  8d46f2           lea ax, [bp - 0xe]
  00D517  50               push ax
  00D518  8b46fc           mov ax, word ptr [bp - 4]
  00D51B  8b56fe           mov dx, word ptr [bp - 2]
  00D51E  2b46f4           sub ax, word ptr [bp - 0xc]
  00D521  1b56f6           sbb dx, word ptr [bp - 0xa]
  00D524  0bd2             or dx, dx
  00D526  7c0a             jl 0xd532
  00D528  7f05             jg 0xd52f
  00D52A  3d00f0           cmp ax, 0xf000
  00D52D  7603             jbe 0xd532
  00D52F  b800f0           mov ax, 0xf000
  00D532  8bf0             mov si, ax
  00D534  56               push si
  00D535  ff760c           push word ptr [bp + 0xc]
  00D538  ff760a           push word ptr [bp + 0xa]
  00D53B  8a4507           mov al, byte ptr [di + 7]
  00D53E  98               cwde
  00D53F  50               push ax
  00D540  9af90a8813       lcall 0x1388, 0xaf9
  00D545  83c40a           add sp, 0xa
  00D548  0bc0             or ax, ax
  00D54A  7536             jne 0xd582
  00D54C  8b46f2           mov ax, word ptr [bp - 0xe]
  00D54F  2bd2             sub dx, dx
  00D551  0146f4           add word ptr [bp - 0xc], ax
  00D554  1156f6           adc word ptr [bp - 0xa], dx
  00D557  2bdb             sub bx, bx
  00D559  8bc8             mov cx, ax
  00D55B  014e0a           add word ptr [bp + 0xa], cx
  00D55E  13da             adc bx, dx
  00D560  b90c00           mov cx, 0xc
  00D563  d3e3             shl bx, cl
  00D565  015e0c           add word ptr [bp + 0xc], bx
  00D568  8b46fc           mov ax, word ptr [bp - 4]
  00D56B  8b56fe           mov dx, word ptr [bp - 2]
  00D56E  2bc9             sub cx, cx
  00D570  0176f8           add word ptr [bp - 8], si
  00D573  114efa           adc word ptr [bp - 6], cx
  00D576  3956fa           cmp word ptr [bp - 6], dx
  00D579  7c99             jl 0xd514
  00D57B  7f05             jg 0xd582
  00D57D  3946f8           cmp word ptr [bp - 8], ax
  00D580  7292             jb 0xd514
  00D582  8b46ec           mov ax, word ptr [bp - 0x14]
  00D585  8b56ee           mov dx, word ptr [bp - 0x12]
  00D588  3946f4           cmp word ptr [bp - 0xc], ax
  00D58B  750f             jne 0xd59c
  00D58D  3956f6           cmp word ptr [bp - 0xa], dx
  00D590  750a             jne 0xd59c
  00D592  b80100           mov ax, 1
  00D595  99               cdq
  00D596  5e               pop si
  00D597  5f               pop di
  00D598  c9               leave
  00D599  ca0800           retf 8
  00D59C  52               push dx
  00D59D  50               push ax
  00D59E  ff76f6           push word ptr [bp - 0xa]
  00D5A1  ff76f4           push word ptr [bp - 0xc]
  00D5A4  9a220b8813       lcall 0x1388, 0xb22
  00D5A9  5e               pop si
  00D5AA  5f               pop di
  00D5AB  c9               leave
  00D5AC  ca0800           retf 8
  00D5AF  90               nop
  00D5B0  0000             add byte ptr [bx + si], al
  00D5B2  0000             add byte ptr [bx + si], al
  00D5B4  0000             add byte ptr [bx + si], al
