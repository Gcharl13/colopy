; MAPEDIT.EXE named disasm — module text.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _text_close  file 0x009A20..0x009A3A  seg 0x842:0x0  (text.obj) ----
  009A20  833e400600       cmp word ptr [0x640], 0
  009A25  7412             je 0x9a39
  009A27  ff364006         push word ptr [0x640]
  009A2B  9ac2028813       lcall 0x1388, 0x2c2
  009A30  83c402           add sp, 2
  009A33  c70640060000     mov word ptr [0x640], 0
  009A39  cb               retf

; ---- _text_open  file 0x009A3A..0x009B26  seg 0x842:0x1a  (text.obj) ----
  009A3A  c8a20000         enter 0xa2, 0
  009A3E  57               push di
  009A3F  56               push si
  009A40  8b7606           mov si, word ptr [bp + 6]
  009A43  c746fe0100       mov word ptr [bp - 2], 1
  009A48  2bff             sub di, di
  009A4A  c646ae40         mov byte ptr [bp - 0x52], 0x40
  009A4E  c646af00         mov byte ptr [bp - 0x51], 0
  009A52  ff7608           push word ptr [bp + 8]
  009A55  8d46ae           lea ax, [bp - 0x52]
  009A58  50               push ax
  009A59  9ae6058813       lcall 0x1388, 0x5e6
  009A5E  83c404           add sp, 4
  009A61  8d46ae           lea ax, [bp - 0x52]
  009A64  50               push ax
  009A65  9a880a8813       lcall 0x1388, 0xa88
  009A6A  83c402           add sp, 2
  009A6D  0bf6             or si, si
  009A6F  743d             je 0x9aae
  009A71  0e               push cs
  009A72  e8abff           call 0x9a20
  009A75  56               push si
  009A76  8d865eff         lea ax, [bp - 0xa2]
  009A7A  50               push ax
  009A7B  9a26068813       lcall 0x1388, 0x626
  009A80  83c404           add sp, 4
  009A83  8d865eff         lea ax, [bp - 0xa2]
  009A87  16               push ss
  009A88  50               push ax
  009A89  1e               push ds
  009A8A  684206           push 0x642
  009A8D  9a0e00040c       lcall 0xc04, 0xe
  009A92  8d865eff         lea ax, [bp - 0xa2]
  009A96  16               push ss
  009A97  50               push ax
  009A98  8d1e4606         lea bx, [0x646]
  009A9C  9a04019702       lcall 0x297, 0x104
  009AA1  a34006           mov word ptr [0x640], ax
  009AA4  0bc0             or ax, ax
  009AA6  7509             jne 0x9ab1
  009AA8  8b76fe           mov si, word ptr [bp - 2]
  009AAB  eb6b             jmp 0x9b18
  009AAD  90               nop
  009AAE  bf0100           mov di, 1
  009AB1  837e0800         cmp word ptr [bp + 8], 0
  009AB5  745f             je 0x9b16
  009AB7  2bf6             sub si, si
  009AB9  ff364006         push word ptr [0x640]
  009ABD  6a50             push 0x50
  009ABF  68c65e           push 0x5ec6
  009AC2  9a8a078813       lcall 0x1388, 0x78a
  009AC7  83c406           add sp, 6
  009ACA  0bc0             or ax, ax
  009ACC  750b             jne 0x9ad9
  009ACE  0bff             or di, di
  009AD0  74d6             je 0x9aa8
  009AD2  2bff             sub di, di
  009AD4  c606c65e00       mov byte ptr [0x5ec6], 0
  009AD9  1e               push ds
  009ADA  68c65e           push 0x5ec6
  009ADD  9a0000c40b       lcall 0xbc4, 0
  009AE2  1e               push ds
  009AE3  68c65e           push 0x5ec6
  009AE6  9a02001a0c       lcall 0xc1a, 2
  009AEB  8d46ae           lea ax, [bp - 0x52]
  009AEE  50               push ax
  009AEF  68c65e           push 0x5ec6
  009AF2  9a58068813       lcall 0x1388, 0x658
  009AF7  83c404           add sp, 4
  009AFA  0bc0             or ax, ax
  009AFC  7503             jne 0x9b01
  009AFE  be0100           mov si, 1
  009B01  0bf6             or si, si
  009B03  74b4             je 0x9ab9
  009B05  68c65e           push 0x5ec6
  009B08  9a84068813       lcall 0x1388, 0x684
  009B0D  83c402           add sp, 2
  009B10  05c65e           add ax, 0x5ec6
  009B13  a3d65a           mov word ptr [0x5ad6], ax
  009B16  2bf6             sub si, si
  009B18  0bf6             or si, si
  009B1A  7404             je 0x9b20
  009B1C  0e               push cs
  009B1D  e800ff           call 0x9a20
  009B20  8bc6             mov ax, si
  009B22  5e               pop si
  009B23  5f               pop di
  009B24  c9               leave
  009B25  cb               retf

; ---- _text_get  file 0x009B26..0x009B7E  seg 0x842:0x106  (text.obj) ----
  009B26  56               push si
  009B27  2bf6             sub si, si
  009B29  ff364006         push word ptr [0x640]
  009B2D  6a50             push 0x50
  009B2F  68c65e           push 0x5ec6
  009B32  9a8a078813       lcall 0x1388, 0x78a
  009B37  83c406           add sp, 6
  009B3A  0bc0             or ax, ax
  009B3C  7433             je 0x9b71
  009B3E  1e               push ds
  009B3F  68c65e           push 0x5ec6
  009B42  9a0000c40b       lcall 0xbc4, 0
  009B47  1e               push ds
  009B48  68c65e           push 0x5ec6
  009B4B  9a02001a0c       lcall 0xc1a, 2
  009B50  6a5f             push 0x5f
  009B52  68c65e           push 0x5ec6
  009B55  9ae8098813       lcall 0x1388, 0x9e8
  009B5A  83c404           add sp, 4
  009B5D  8bf0             mov si, ax
  009B5F  0bf6             or si, si
  009B61  7403             je 0x9b66
  009B63  c60420           mov byte ptr [si], 0x20
  009B66  0bf6             or si, si
  009B68  75e6             jne 0x9b50
  009B6A  bec65e           mov si, 0x5ec6
  009B6D  8936d65a         mov word ptr [0x5ad6], si
  009B71  0bf6             or si, si
  009B73  7504             jne 0x9b79
  009B75  0e               push cs
  009B76  e8a7fe           call 0x9a20
  009B79  8bc6             mov ax, si
  009B7B  5e               pop si
  009B7C  cb               retf
  009B7D  90               nop

; ---- _text_item_get  file 0x009B7E..0x009BB8  seg 0x842:0x15e  (text.obj) ----
  009B7E  57               push di
  009B7F  56               push si
  009B80  8b36d65a         mov si, word ptr [0x5ad6]
  009B84  bfcc51           mov di, 0x51cc
  009B87  803c00           cmp byte ptr [si], 0
  009B8A  7410             je 0x9b9c
  009B8C  803c2c           cmp byte ptr [si], 0x2c
  009B8F  740b             je 0x9b9c
  009B91  8a04             mov al, byte ptr [si]
  009B93  8805             mov byte ptr [di], al
  009B95  47               inc di
  009B96  46               inc si
  009B97  803c00           cmp byte ptr [si], 0
  009B9A  75f0             jne 0x9b8c
  009B9C  803c00           cmp byte ptr [si], 0
  009B9F  7401             je 0x9ba2
  009BA1  46               inc si
  009BA2  8936d65a         mov word ptr [0x5ad6], si
  009BA6  c60500           mov byte ptr [di], 0
  009BA9  1e               push ds
  009BAA  68cc51           push 0x51cc
  009BAD  9a02001a0c       lcall 0xc1a, 2
  009BB2  b8cc51           mov ax, 0x51cc
  009BB5  5e               pop si
  009BB6  5f               pop di
  009BB7  cb               retf

; ---- _text_item_number  file 0x009BB8..0x009BC4  seg 0x842:0x198  (text.obj) ----
  009BB8  0e               push cs
  009BB9  e8c2ff           call 0x9b7e
  009BBC  8bd8             mov bx, ax
  009BBE  9a0c00120d       lcall 0xd12, 0xc
  009BC3  cb               retf

; ---- _text_next_line  file 0x009BC4..0x009BD6  seg 0x842:0x1a4  (text.obj) ----
  009BC4  68c65e           push 0x5ec6
  009BC7  9a84068813       lcall 0x1388, 0x684
  009BCC  83c402           add sp, 2
  009BCF  05c65e           add ax, 0x5ec6
  009BD2  a3d65a           mov word ptr [0x5ad6], ax
  009BD5  cb               retf

; ---- _text_string  file 0x009BD6..0x009BE8  seg 0x842:0x1b6  (text.obj) ----
  009BD6  0e               push cs
  009BD7  e84cff           call 0x9b26
  009BDA  1e               push ds
  009BDB  68c65e           push 0x5ec6
  009BDE  9a36003403       lcall 0x334, 0x36
  009BE3  83c404           add sp, 4
  009BE6  cb               retf
  009BE7  90               nop

; ---- _text_item_string  file 0x009BE8..0x009BFA  seg 0x842:0x1c8  (text.obj) ----
  009BE8  0e               push cs
  009BE9  e892ff           call 0x9b7e
  009BEC  1e               push ds
  009BED  68cc51           push 0x51cc
  009BF0  9a36003403       lcall 0x334, 0x36
  009BF5  83c404           add sp, 4
  009BF8  cb               retf
  009BF9  90               nop

; ---- _text_item_binary  file 0x009BFA..0x009C28  seg 0x842:0x1da  (text.obj) ----
  009BFA  c8020000         enter 2, 0
  009BFE  56               push si
  009BFF  c646ff00         mov byte ptr [bp - 1], 0
  009C03  0e               push cs
  009C04  e877ff           call 0x9b7e
  009C07  becc51           mov si, 0x51cc
  009C0A  803c30           cmp byte ptr [si], 0x30
  009C0D  7405             je 0x9c14
  009C0F  803c31           cmp byte ptr [si], 0x31
  009C12  750e             jne 0x9c22
  009C14  d066ff           shl byte ptr [bp - 1], 1
  009C17  803c31           cmp byte ptr [si], 0x31
  009C1A  7503             jne 0x9c1f
  009C1C  fe46ff           inc byte ptr [bp - 1]
  009C1F  46               inc si
  009C20  ebe8             jmp 0x9c0a
  009C22  8a46ff           mov al, byte ptr [bp - 1]
  009C25  5e               pop si
  009C26  c9               leave
  009C27  cb               retf

; ---- _text_search  file 0x009C28..0x009C5E  seg 0x842:0x208  (text.obj) ----
  009C28  c8020000         enter 2, 0
  009C2C  56               push si
  009C2D  be0100           mov si, 1
  009C30  ff7608           push word ptr [bp + 8]
  009C33  ff7606           push word ptr [bp + 6]
  009C36  0e               push cs
  009C37  e800fe           call 0x9a3a
  009C3A  83c404           add sp, 4
  009C3D  0bc0             or ax, ax
  009C3F  7513             jne 0x9c54
  009C41  8b5e0a           mov bx, word ptr [bp + 0xa]
  009C44  0bdb             or bx, bx
  009C46  7c0a             jl 0x9c52
  009C48  8d7701           lea si, [bx + 1]
  009C4B  0e               push cs
  009C4C  e8d7fe           call 0x9b26
  009C4F  4e               dec si
  009C50  75f9             jne 0x9c4b
  009C52  2bf6             sub si, si
  009C54  0e               push cs
  009C55  e8c8fd           call 0x9a20
  009C58  8bc6             mov ax, si
  009C5A  5e               pop si
  009C5B  c9               leave
  009C5C  cb               retf
  009C5D  90               nop
