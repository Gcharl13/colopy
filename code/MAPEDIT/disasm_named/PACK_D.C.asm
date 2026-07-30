; MAPEDIT.EXE named disasm — module PACK_D.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PACK_WRITE_EMS  file 0x014D84..0x014E9E  seg 0x1378:0x4  (PACK_D.C.obj) ----
  014D84  c80e0000         enter 0xe, 0
  014D88  833e864a00       cmp word ptr [0x4a86], 0
  014D8D  7c1f             jl 0x14dae
  014D8F  c45e06           les bx, ptr [bp + 6]
  014D92  268b07           mov ax, word ptr es:[bx]
  014D95  2bd2             sub dx, dx
  014D97  3b16864a         cmp dx, word ptr [0x4a86]
  014D9B  7c17             jl 0x14db4
  014D9D  7f06             jg 0x14da5
  014D9F  3b06844a         cmp ax, word ptr [0x4a84]
  014DA3  760f             jbe 0x14db4
  014DA5  8b16864a         mov dx, word ptr [0x4a86]
  014DA9  a1844a           mov ax, word ptr [0x4a84]
  014DAC  eb06             jmp 0x14db4
  014DAE  c45e06           les bx, ptr [bp + 6]
  014DB1  268b07           mov ax, word ptr es:[bx]
  014DB4  8946fe           mov word ptr [bp - 2], ax
  014DB7  0bc0             or ax, ax
  014DB9  7503             jne 0x14dbe
  014DBB  e9c900           jmp 0x14e87
  014DBE  8946f8           mov word ptr [bp - 8], ax
  014DC1  8b460a           mov ax, word ptr [bp + 0xa]
  014DC4  8b560c           mov dx, word ptr [bp + 0xc]
  014DC7  8946fa           mov word ptr [bp - 6], ax
  014DCA  8956fc           mov word ptr [bp - 4], dx
  014DCD  a15c44           mov ax, word ptr [0x445c]
  014DD0  8b165e44         mov dx, word ptr [0x445e]
  014DD4  8946f4           mov word ptr [bp - 0xc], ax
  014DD7  8956f6           mov word ptr [bp - 0xa], dx
  014DDA  813e824e0040     cmp word ptr [0x4e82], 0x4000
  014DE0  7c1c             jl 0x14dfe
  014DE2  a17869           mov ax, word ptr [0x6978]
  014DE5  8b16b44b         mov dx, word ptr [0x4bb4]
  014DE9  9ac4014511       lcall 0x1145, 0x1c4
  014DEE  a3b44b           mov word ptr [0x4bb4], ax
  014DF1  c706824e0000     mov word ptr [0x4e82], 0
  014DF7  0bc0             or ax, ax
  014DF9  7d03             jge 0x14dfe
  014DFB  e98900           jmp 0x14e87
  014DFE  b80040           mov ax, 0x4000
  014E01  2b06824e         sub ax, word ptr [0x4e82]
  014E05  3b46f8           cmp ax, word ptr [bp - 8]
  014E08  7e03             jle 0x14e0d
  014E0A  8b46f8           mov ax, word ptr [bp - 8]
  014E0D  8946f2           mov word ptr [bp - 0xe], ax
  014E10  ff36b44b         push word ptr [0x4bb4]
  014E14  6a00             push 0
  014E16  9ad4002d11       lcall 0x112d, 0xd4
  014E1B  83c404           add sp, 4
  014E1E  ff76f2           push word ptr [bp - 0xe]
  014E21  ff76fc           push word ptr [bp - 4]
  014E24  ff76fa           push word ptr [bp - 6]
  014E27  8b46f4           mov ax, word ptr [bp - 0xc]
  014E2A  8b56f6           mov dx, word ptr [bp - 0xa]
  014E2D  0306824e         add ax, word ptr [0x4e82]
  014E31  52               push dx
  014E32  50               push ax
  014E33  9a4a0c8813       lcall 0x1388, 0xc4a
  014E38  83c40a           add sp, 0xa
  014E3B  8b46fa           mov ax, word ptr [bp - 6]
  014E3E  8b56fc           mov dx, word ptr [bp - 4]
  014E41  0346f2           add ax, word ptr [bp - 0xe]
  014E44  52               push dx
  014E45  50               push ax
  014E46  9a02004f10       lcall 0x104f, 2
  014E4B  8946fa           mov word ptr [bp - 6], ax
  014E4E  8956fc           mov word ptr [bp - 4], dx
  014E51  8b46f2           mov ax, word ptr [bp - 0xe]
  014E54  2946f8           sub word ptr [bp - 8], ax
  014E57  0106824e         add word ptr [0x4e82], ax
  014E5B  833e864a00       cmp word ptr [0x4a86], 0
  014E60  7c13             jl 0x14e75
  014E62  7f07             jg 0x14e6b
  014E64  833e844a00       cmp word ptr [0x4a84], 0
  014E69  740a             je 0x14e75
  014E6B  2bd2             sub dx, dx
  014E6D  2906844a         sub word ptr [0x4a84], ax
  014E71  1916864a         sbb word ptr [0x4a86], dx
  014E75  2bd2             sub dx, dx
  014E77  01068469         add word ptr [0x6984], ax
  014E7B  11168669         adc word ptr [0x6986], dx
  014E7F  3956f8           cmp word ptr [bp - 8], dx
  014E82  7403             je 0x14e87
  014E84  e953ff           jmp 0x14dda
  014E87  8b46fe           mov ax, word ptr [bp - 2]
  014E8A  c9               leave
  014E8B  ca0800           retf 8
  014E8E  0000             add byte ptr [bx + si], al
  014E90  0000             add byte ptr [bx + si], al
  014E92  0000             add byte ptr [bx + si], al
  014E94  0000             add byte ptr [bx + si], al
  014E96  0000             add byte ptr [bx + si], al
  014E98  0000             add byte ptr [bx + si], al
  014E9A  0000             add byte ptr [bx + si], al
  014E9C  0000             add byte ptr [bx + si], al
