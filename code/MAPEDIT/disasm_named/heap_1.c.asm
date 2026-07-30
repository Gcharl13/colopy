; MAPEDIT.EXE named disasm — module heap_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @heap_create  file 0x010A50..0x010AE0  seg 0xF45:0x0  (heap_1.c.obj) ----
  010A50  c8020000         enter 2, 0
  010A54  56               push si
  010A55  c746fe0100       mov word ptr [bp - 2], 1
  010A5A  8bc8             mov cx, ax
  010A5C  c45e0e           les bx, ptr [bp + 0xe]
  010A5F  268807           mov byte ptr es:[bx], al
  010A62  ff7608           push word ptr [bp + 8]
  010A65  ff7606           push word ptr [bp + 6]
  010A68  8b460a           mov ax, word ptr [bp + 0xa]
  010A6B  8b560c           mov dx, word ptr [bp + 0xc]
  010A6E  8bf1             mov si, cx
  010A70  9a3601c90c       lcall 0xcc9, 0x136
  010A75  c45e0e           les bx, ptr [bp + 0xe]
  010A78  26894702         mov word ptr es:[bx + 2], ax
  010A7C  26895704         mov word ptr es:[bx + 4], dx
  010A80  8bc2             mov ax, dx
  010A82  260b4702         or ax, word ptr es:[bx + 2]
  010A86  751c             jne 0x10aa4
  010A88  ff760c           push word ptr [bp + 0xc]
  010A8B  ff760a           push word ptr [bp + 0xa]
  010A8E  9a8200080d       lcall 0xd08, 0x82
  010A93  52               push dx
  010A94  50               push ax
  010A95  8bde             mov bx, si
  010A97  b8c4ff           mov ax, 0xffc4
  010A9A  ba0200           mov dx, 2
  010A9D  9ad603d00e       lcall 0xed0, 0x3d6
  010AA2  eb33             jmp 0x10ad7
  010AA4  c45e0e           les bx, ptr [bp + 0xe]
  010AA7  26c6470101       mov byte ptr es:[bx + 1], 1
  010AAC  268b4702         mov ax, word ptr es:[bx + 2]
  010AB0  268b5704         mov dx, word ptr es:[bx + 4]
  010AB4  26894706         mov word ptr es:[bx + 6], ax
  010AB8  26895708         mov word ptr es:[bx + 8], dx
  010ABC  8b460a           mov ax, word ptr [bp + 0xa]
  010ABF  8b560c           mov dx, word ptr [bp + 0xc]
  010AC2  2689470e         mov word ptr es:[bx + 0xe], ax
  010AC6  26895710         mov word ptr es:[bx + 0x10], dx
  010ACA  2689470a         mov word ptr es:[bx + 0xa], ax
  010ACE  2689570c         mov word ptr es:[bx + 0xc], dx
  010AD2  c746fe0000       mov word ptr [bp - 2], 0
  010AD7  8b46fe           mov ax, word ptr [bp - 2]
  010ADA  5e               pop si
  010ADB  c9               leave
  010ADC  ca0c00           retf 0xc
  010ADF  90               nop

; ---- @heap_declare  file 0x010AE0..0x010B1E  seg 0xF45:0x90  (heap_1.c.obj) ----
  010AE0  55               push bp
  010AE1  8bec             mov bp, sp
  010AE3  c45e0e           les bx, ptr [bp + 0xe]
  010AE6  26c6470100       mov byte ptr es:[bx + 1], 0
  010AEB  268807           mov byte ptr es:[bx], al
  010AEE  8b460a           mov ax, word ptr [bp + 0xa]
  010AF1  8b560c           mov dx, word ptr [bp + 0xc]
  010AF4  26894706         mov word ptr es:[bx + 6], ax
  010AF8  26895708         mov word ptr es:[bx + 8], dx
  010AFC  26894702         mov word ptr es:[bx + 2], ax
  010B00  26895704         mov word ptr es:[bx + 4], dx
  010B04  8b4606           mov ax, word ptr [bp + 6]
  010B07  8b5608           mov dx, word ptr [bp + 8]
  010B0A  2689470e         mov word ptr es:[bx + 0xe], ax
  010B0E  26895710         mov word ptr es:[bx + 0x10], dx
  010B12  2689470a         mov word ptr es:[bx + 0xa], ax
  010B16  2689570c         mov word ptr es:[bx + 0xc], dx
  010B1A  c9               leave
  010B1B  ca0c00           retf 0xc

; ---- @heap_destroy  file 0x010B1E..0x010B5A  seg 0xF45:0xce  (heap_1.c.obj) ----
  010B1E  55               push bp
  010B1F  8bec             mov bp, sp
  010B21  c45e06           les bx, ptr [bp + 6]
  010B24  26807f0100       cmp byte ptr es:[bx + 1], 0
  010B29  740d             je 0x10b38
  010B2B  26ff7704         push word ptr es:[bx + 4]
  010B2F  26ff7702         push word ptr es:[bx + 2]
  010B33  9a1003c90c       lcall 0xcc9, 0x310
  010B38  c45e06           les bx, ptr [bp + 6]
  010B3B  2bc0             sub ax, ax
  010B3D  26894704         mov word ptr es:[bx + 4], ax
  010B41  26894702         mov word ptr es:[bx + 2], ax
  010B45  26894710         mov word ptr es:[bx + 0x10], ax
  010B49  2689470e         mov word ptr es:[bx + 0xe], ax
  010B4D  2689470c         mov word ptr es:[bx + 0xc], ax
  010B51  2689470a         mov word ptr es:[bx + 0xa], ax
  010B55  c9               leave
  010B56  ca0400           retf 4
  010B59  90               nop

; ---- @heap_get  file 0x010B5A..0x010BC4  seg 0xF45:0x10a  (heap_1.c.obj) ----
  010B5A  c8040000         enter 4, 0
  010B5E  52               push dx
  010B5F  50               push ax
  010B60  2bc9             sub cx, cx
  010B62  894efe           mov word ptr [bp - 2], cx
  010B65  894efc           mov word ptr [bp - 4], cx
  010B68  c45e06           les bx, ptr [bp + 6]
  010B6B  26395710         cmp word ptr es:[bx + 0x10], dx
  010B6F  7f25             jg 0x10b96
  010B71  7c06             jl 0x10b79
  010B73  2639470e         cmp word ptr es:[bx + 0xe], ax
  010B77  731d             jae 0x10b96
  010B79  52               push dx
  010B7A  50               push ax
  010B7B  26ff7710         push word ptr es:[bx + 0x10]
  010B7F  26ff770e         push word ptr es:[bx + 0xe]
  010B83  268a1f           mov bl, byte ptr es:[bx]
  010B86  2aff             sub bh, bh
  010B88  b8c3ff           mov ax, 0xffc3
  010B8B  ba0200           mov dx, 2
  010B8E  9ad603d00e       lcall 0xed0, 0x3d6
  010B93  eb24             jmp 0x10bb9
  010B95  90               nop
  010B96  268b4706         mov ax, word ptr es:[bx + 6]
  010B9A  268b5708         mov dx, word ptr es:[bx + 8]
  010B9E  8946fc           mov word ptr [bp - 4], ax
  010BA1  8956fe           mov word ptr [bp - 2], dx
  010BA4  8b46f8           mov ax, word ptr [bp - 8]
  010BA7  26014706         add word ptr es:[bx + 6], ax
  010BAB  8b46f8           mov ax, word ptr [bp - 8]
  010BAE  8b56fa           mov dx, word ptr [bp - 6]
  010BB1  2629470e         sub word ptr es:[bx + 0xe], ax
  010BB5  26195710         sbb word ptr es:[bx + 0x10], dx
  010BB9  8b46fc           mov ax, word ptr [bp - 4]
  010BBC  8b56fe           mov dx, word ptr [bp - 2]
  010BBF  c9               leave
  010BC0  ca0400           retf 4
  010BC3  90               nop

; ---- @heap_shrink  file 0x010BC4..0x010C50  seg 0xF45:0x174  (heap_1.c.obj) ----
  010BC4  c80a0000         enter 0xa, 0
  010BC8  57               push di
  010BC9  56               push si
  010BCA  c45e06           les bx, ptr [bp + 6]
  010BCD  26837f1000       cmp word ptr es:[bx + 0x10], 0
  010BD2  7f09             jg 0x10bdd
  010BD4  7c69             jl 0x10c3f
  010BD6  26837f0e10       cmp word ptr es:[bx + 0xe], 0x10
  010BDB  7262             jb 0x10c3f
  010BDD  268b470a         mov ax, word ptr es:[bx + 0xa]
  010BE1  268b570c         mov dx, word ptr es:[bx + 0xc]
  010BE5  262b470e         sub ax, word ptr es:[bx + 0xe]
  010BE9  261b5710         sbb dx, word ptr es:[bx + 0x10]
  010BED  8946fc           mov word ptr [bp - 4], ax
  010BF0  8956fe           mov word ptr [bp - 2], dx
  010BF3  268b4f02         mov cx, word ptr es:[bx + 2]
  010BF7  268b7704         mov si, word ptr es:[bx + 4]
  010BFB  894ef8           mov word ptr [bp - 8], cx
  010BFE  8976fa           mov word ptr [bp - 6], si
  010C01  050f00           add ax, 0xf
  010C04  83d200           adc dx, 0
  010C07  d1fa             sar dx, 1
  010C09  d1d8             rcr ax, 1
  010C0B  d1fa             sar dx, 1
  010C0D  d1d8             rcr ax, 1
  010C0F  d1fa             sar dx, 1
  010C11  d1d8             rcr ax, 1
  010C13  d1fa             sar dx, 1
  010C15  d1d8             rcr ax, 1
  010C17  8946f6           mov word ptr [bp - 0xa], ax
  010C1A  b44a             mov ah, 0x4a
  010C1C  c47ef8           les di, ptr [bp - 8]
  010C1F  8b5ef6           mov bx, word ptr [bp - 0xa]
  010C22  cd21             int 0x21
  010C24  8b46fc           mov ax, word ptr [bp - 4]
  010C27  8b56fe           mov dx, word ptr [bp - 2]
  010C2A  c45e06           les bx, ptr [bp + 6]
  010C2D  2689470a         mov word ptr es:[bx + 0xa], ax
  010C31  2689570c         mov word ptr es:[bx + 0xc], dx
  010C35  2bc0             sub ax, ax
  010C37  26894710         mov word ptr es:[bx + 0x10], ax
  010C3B  2689470e         mov word ptr es:[bx + 0xe], ax
  010C3F  c45e06           les bx, ptr [bp + 6]
  010C42  268b470a         mov ax, word ptr es:[bx + 0xa]
  010C46  268b570c         mov dx, word ptr es:[bx + 0xc]
  010C4A  5e               pop si
  010C4B  5f               pop di
  010C4C  c9               leave
  010C4D  ca0400           retf 4
