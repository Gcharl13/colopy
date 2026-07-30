; MAPEDIT.EXE named disasm — module himem_4.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _himem_resident  file 0x014A5A..0x014B7E  seg 0x1345:0xa  (himem_4.c.obj) ----
  014A5A  c8160000         enter 0x16, 0
  014A5E  57               push di
  014A5F  56               push si
  014A60  c746faffff       mov word ptr [bp - 6], 0xffff
  014A65  2bc0             sub ax, ax
  014A67  8946ec           mov word ptr [bp - 0x14], ax
  014A6A  8946ea           mov word ptr [bp - 0x16], ax
  014A6D  39060445         cmp word ptr [0x4504], ax
  014A71  7503             jne 0x14a76
  014A73  e9e000           jmp 0x14b56
  014A76  8b7606           mov si, word ptr [bp + 6]
  014A79  6a5c             push 0x5c
  014A7B  ff7608           push word ptr [bp + 8]
  014A7E  56               push si
  014A7F  9a820d8813       lcall 0x1388, 0xd82
  014A84  83c406           add sp, 6
  014A87  8bf8             mov di, ax
  014A89  8956f0           mov word ptr [bp - 0x10], dx
  014A8C  0bd0             or dx, ax
  014A8E  7513             jne 0x14aa3
  014A90  6a2a             push 0x2a
  014A92  ff7608           push word ptr [bp + 8]
  014A95  56               push si
  014A96  9aa80c8813       lcall 0x1388, 0xca8
  014A9B  83c406           add sp, 6
  014A9E  8bf8             mov di, ax
  014AA0  8956f0           mov word ptr [bp - 0x10], dx
  014AA3  8b46f0           mov ax, word ptr [bp - 0x10]
  014AA6  0bc7             or ax, di
  014AA8  750a             jne 0x14ab4
  014AAA  8b4608           mov ax, word ptr [bp + 8]
  014AAD  8bfe             mov di, si
  014AAF  8946f0           mov word ptr [bp - 0x10], ax
  014AB2  eb04             jmp 0x14ab8
  014AB4  47               inc di
  014AB5  8b46f0           mov ax, word ptr [bp - 0x10]
  014AB8  803efa4403       cmp byte ptr [0x44fa], 3
  014ABD  750f             jne 0x14ace
  014ABF  897eee           mov word ptr [bp - 0x12], di
  014AC2  9a06009012       lcall 0x1290, 6
  014AC7  0bc0             or ax, ax
  014AC9  7443             je 0x14b0e
  014ACB  e98800           jmp 0x14b56
  014ACE  897eee           mov word ptr [bp - 0x12], di
  014AD1  1e               push ds
  014AD2  682245           push 0x4522
  014AD5  b8bc34           mov ax, 0x34bc
  014AD8  99               cdq
  014AD9  9a3601c90c       lcall 0xcc9, 0x136
  014ADE  8946ea           mov word ptr [bp - 0x16], ax
  014AE1  8956ec           mov word ptr [bp - 0x14], dx
  014AE4  a3c849           mov word ptr [0x49c8], ax
  014AE7  8916ca49         mov word ptr [0x49ca], dx
  014AEB  0bd0             or dx, ax
  014AED  7467             je 0x14b56
  014AEF  ff76ec           push word ptr [bp - 0x14]
  014AF2  50               push ax
  014AF3  6a00             push 0
  014AF5  6a00             push 0
  014AF7  6a00             push 0
  014AF9  ff360045         push word ptr [0x4500]
  014AFD  6a00             push 0
  014AFF  68bc34           push 0x34bc
  014B02  9a04004313       lcall 0x1343, 4
  014B07  83c410           add sp, 0x10
  014B0A  0bc0             or ax, ax
  014B0C  7548             jne 0x14b56
  014B0E  2bd2             sub dx, dx
  014B10  8bf2             mov si, dx
  014B12  8bfa             mov di, dx
  014B14  837efa00         cmp word ptr [bp - 6], 0
  014B18  7d3c             jge 0x14b56
  014B1A  c41ec849         les bx, ptr [0x49c8]
  014B1E  268039ff         cmp byte ptr es:[bx + di], 0xff
  014B22  7508             jne 0x14b2c
  014B24  8b4608           mov ax, word ptr [bp + 8]
  014B27  0b4606           or ax, word ptr [bp + 6]
  014B2A  eb1b             jmp 0x14b47
  014B2C  8bc3             mov ax, bx
  014B2E  8cc2             mov dx, es
  014B30  03c7             add ax, di
  014B32  050300           add ax, 3
  014B35  52               push dx
  014B36  50               push ax
  014B37  ff76f0           push word ptr [bp - 0x10]
  014B3A  ff76ee           push word ptr [bp - 0x12]
  014B3D  9ad60c8813       lcall 0x1388, 0xcd6
  014B42  83c408           add sp, 8
  014B45  0bc0             or ax, ax
  014B47  7503             jne 0x14b4c
  014B49  8976fa           mov word ptr [bp - 6], si
  014B4C  46               inc si
  014B4D  83c75a           add di, 0x5a
  014B50  81ffbc34         cmp di, 0x34bc
  014B54  7cbe             jl 0x14b14
  014B56  837efa00         cmp word ptr [bp - 6], 0
  014B5A  7c08             jl 0x14b64
  014B5C  8b46fa           mov ax, word ptr [bp - 6]
  014B5F  9a0a009212       lcall 0x1292, 0xa
  014B64  8b46ec           mov ax, word ptr [bp - 0x14]
  014B67  0b46ea           or ax, word ptr [bp - 0x16]
  014B6A  740b             je 0x14b77
  014B6C  ff76ec           push word ptr [bp - 0x14]
  014B6F  ff76ea           push word ptr [bp - 0x16]
  014B72  9a1003c90c       lcall 0xcc9, 0x310
  014B77  8b46fa           mov ax, word ptr [bp - 6]
  014B7A  5e               pop si
  014B7B  5f               pop di
  014B7C  c9               leave
  014B7D  cb               retf
