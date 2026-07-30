; MAPEDIT.EXE named disasm — module loader_2.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @loader_read  file 0x013B82..0x013DB0  seg 0x1258:0x2  (loader_2.c.obj) ----
  013B82  c81c0000         enter 0x1c, 0
  013B86  52               push dx
  013B87  50               push ax
  013B88  57               push di
  013B89  56               push si
  013B8A  2bc0             sub ax, ax
  013B8C  8946e6           mov word ptr [bp - 0x1a], ax
  013B8F  8946e4           mov word ptr [bp - 0x1c], ax
  013B92  8946ec           mov word ptr [bp - 0x14], ax
  013B95  8bc2             mov ax, dx
  013B97  0b46e0           or ax, word ptr [bp - 0x20]
  013B9A  750a             jne 0x13ba6
  013B9C  2bc0             sub ax, ax
  013B9E  2bd2             sub dx, dx
  013BA0  5e               pop si
  013BA1  5f               pop di
  013BA2  c9               leave
  013BA3  ca0c00           retf 0xc
  013BA6  837e0a01         cmp word ptr [bp + 0xa], 1
  013BAA  750c             jne 0x13bb8
  013BAC  837e0c00         cmp word ptr [bp + 0xc], 0
  013BB0  7506             jne 0x13bb8
  013BB2  8b46e0           mov ax, word ptr [bp - 0x20]
  013BB5  eb10             jmp 0x13bc7
  013BB7  90               nop
  013BB8  52               push dx
  013BB9  ff76e0           push word ptr [bp - 0x20]
  013BBC  ff760c           push word ptr [bp + 0xc]
  013BBF  ff760a           push word ptr [bp + 0xa]
  013BC2  9abc0b8813       lcall 0x1388, 0xbbc
  013BC7  8946fc           mov word ptr [bp - 4], ax
  013BCA  8956fe           mov word ptr [bp - 2], dx
  013BCD  c47606           les si, ptr [bp + 6]
  013BD0  268b7c18         mov di, word ptr es:[si + 0x18]
  013BD4  26ff4418         inc word ptr es:[si + 0x18]
  013BD8  26807c0401       cmp byte ptr es:[si + 4], 1
  013BDD  7543             jne 0x13c22
  013BDF  2bc0             sub ax, ax
  013BE1  8946f4           mov word ptr [bp - 0xc], ax
  013BE4  8946f2           mov word ptr [bp - 0xe], ax
  013BE7  8b4e08           mov cx, word ptr [bp + 8]
  013BEA  8d4410           lea ax, [si + 0x10]
  013BED  51               push cx
  013BEE  50               push ax
  013BEF  8d4412           lea ax, [si + 0x12]
  013BF2  51               push cx
  013BF3  50               push ax
  013BF4  ff7610           push word ptr [bp + 0x10]
  013BF7  ff760e           push word ptr [bp + 0xe]
  013BFA  ff76fe           push word ptr [bp - 2]
  013BFD  ff76fc           push word ptr [bp - 4]
  013C00  8ec1             mov es, cx
  013C02  268b4408         mov ax, word ptr es:[si + 8]
  013C06  9a0800ec12       lcall 0x12ec, 8
  013C0B  0bc0             or ax, ax
  013C0D  7403             je 0x13c12
  013C0F  e96001           jmp 0x13d72
  013C12  8b46fc           mov ax, word ptr [bp - 4]
  013C15  8b56fe           mov dx, word ptr [bp - 2]
  013C18  8946f2           mov word ptr [bp - 0xe], ax
  013C1B  8956f4           mov word ptr [bp - 0xc], dx
  013C1E  e95101           jmp 0x13d72
  013C21  90               nop
  013C22  26807c0402       cmp byte ptr es:[si + 4], 2
  013C27  754d             jne 0x13c76
  013C29  2bc0             sub ax, ax
  013C2B  8946f4           mov word ptr [bp - 0xc], ax
  013C2E  8946f2           mov word ptr [bp - 0xe], ax
  013C31  ff7610           push word ptr [bp + 0x10]
  013C34  ff760e           push word ptr [bp + 0xe]
  013C37  50               push ax
  013C38  8e4608           mov es, word ptr [bp + 8]
  013C3B  26ff740e         push word ptr es:[si + 0xe]
  013C3F  26ff740c         push word ptr es:[si + 0xc]
  013C43  26ff740a         push word ptr es:[si + 0xa]
  013C47  ff76fe           push word ptr [bp - 2]
  013C4A  ff76fc           push word ptr [bp - 4]
  013C4D  9a04004313       lcall 0x1343, 4
  013C52  83c410           add sp, 0x10
  013C55  0bc0             or ax, ax
  013C57  7403             je 0x13c5c
  013C59  e91601           jmp 0x13d72
  013C5C  8b46fc           mov ax, word ptr [bp - 4]
  013C5F  8b56fe           mov dx, word ptr [bp - 2]
  013C62  8946f2           mov word ptr [bp - 0xe], ax
  013C65  8956f4           mov word ptr [bp - 0xc], dx
  013C68  8e4608           mov es, word ptr [bp + 8]
  013C6B  2601440c         add word ptr es:[si + 0xc], ax
  013C6F  2611540e         adc word ptr es:[si + 0xe], dx
  013C73  e9fc00           jmp 0x13d72
  013C76  2bc0             sub ax, ax
  013C78  8946f4           mov word ptr [bp - 0xc], ax
  013C7B  8946f2           mov word ptr [bp - 0xe], ax
  013C7E  8bde             mov bx, si
  013C80  8bc7             mov ax, di
  013C82  c1e002           shl ax, 2
  013C85  03c7             add ax, di
  013C87  d1e0             shl ax, 1
  013C89  03d8             add bx, ax
  013C8B  268a472a         mov al, byte ptr es:[bx + 0x2a]
  013C8F  2ae4             sub ah, ah
  013C91  a38c44           mov word ptr [0x448c], ax
  013C94  268b4f30         mov cx, word ptr es:[bx + 0x30]
  013C98  268b5732         mov dx, word ptr es:[bx + 0x32]
  013C9C  894ef8           mov word ptr [bp - 8], cx
  013C9F  8956fa           mov word ptr [bp - 6], dx
  013CA2  3d0100           cmp ax, 1
  013CA5  1bc0             sbb ax, ax
  013CA7  250100           and ax, 1
  013CAA  40               inc ax
  013CAB  8946f6           mov word ptr [bp - 0xa], ax
  013CAE  48               dec ax
  013CAF  755b             jne 0x13d0c
  013CB1  8bc1             mov ax, cx
  013CB3  9ae202c90c       lcall 0xcc9, 0x2e2
  013CB8  8946e4           mov word ptr [bp - 0x1c], ax
  013CBB  8956e6           mov word ptr [bp - 0x1a], dx
  013CBE  0bd0             or dx, ax
  013CC0  744a             je 0x13d0c
  013CC2  ff76e6           push word ptr [bp - 0x1a]
  013CC5  50               push ax
  013CC6  6a00             push 0
  013CC8  6a01             push 1
  013CCA  8e4608           mov es, word ptr [bp + 8]
  013CCD  268b5c06         mov bx, word ptr es:[si + 6]
  013CD1  8b46f8           mov ax, word ptr [bp - 8]
  013CD4  8b56fa           mov dx, word ptr [bp - 6]
  013CD7  9a0000ca0b       lcall 0xbca, 0
  013CDC  0bd0             or dx, ax
  013CDE  7503             jne 0x13ce3
  013CE0  e98f00           jmp 0x13d72
  013CE3  ff76fe           push word ptr [bp - 2]
  013CE6  ff76fc           push word ptr [bp - 4]
  013CE9  ff76e6           push word ptr [bp - 0x1a]
  013CEC  ff76e4           push word ptr [bp - 0x1c]
  013CEF  ff7610           push word ptr [bp + 0x10]
  013CF2  ff760e           push word ptr [bp + 0xe]
  013CF5  8b46f6           mov ax, word ptr [bp - 0xa]
  013CF8  2bd2             sub dx, dx
  013CFA  2bdb             sub bx, bx
  013CFC  9a4a000913       lcall 0x1309, 0x4a
  013D01  8946f2           mov word ptr [bp - 0xe], ax
  013D04  8956f4           mov word ptr [bp - 0xc], dx
  013D07  c746ecffff       mov word ptr [bp - 0x14], 0xffff
  013D0C  837eec00         cmp word ptr [bp - 0x14], 0
  013D10  7560             jne 0x13d72
  013D12  8d46e8           lea ax, [bp - 0x18]
  013D15  50               push ax
  013D16  8e4608           mov es, word ptr [bp + 8]
  013D19  26ff7406         push word ptr es:[si + 6]
  013D1D  8cc7             mov di, es
  013D1F  9a62078813       lcall 0x1388, 0x762
  013D24  83c404           add sp, 4
  013D27  ff76fe           push word ptr [bp - 2]
  013D2A  ff76fc           push word ptr [bp - 4]
  013D2D  8ec7             mov es, di
  013D2F  1e               push ds
  013D30  26ff7406         push word ptr es:[si + 6]
  013D34  ff7610           push word ptr [bp + 0x10]
  013D37  ff760e           push word ptr [bp + 0xe]
  013D3A  8b46f6           mov ax, word ptr [bp - 0xa]
  013D3D  ba0100           mov dx, 1
  013D40  2bdb             sub bx, bx
  013D42  9a4a000913       lcall 0x1309, 0x4a
  013D47  8946f2           mov word ptr [bp - 0xe], ax
  013D4A  8956f4           mov word ptr [bp - 0xc], dx
  013D4D  837ef601         cmp word ptr [bp - 0xa], 1
  013D51  751f             jne 0x13d72
  013D53  6a00             push 0
  013D55  8b46f8           mov ax, word ptr [bp - 8]
  013D58  8b56fa           mov dx, word ptr [bp - 6]
  013D5B  0346e8           add ax, word ptr [bp - 0x18]
  013D5E  1356ea           adc dx, word ptr [bp - 0x16]
  013D61  52               push dx
  013D62  50               push ax
  013D63  8e4608           mov es, word ptr [bp + 8]
  013D66  26ff7406         push word ptr es:[si + 6]
  013D6A  9afe078813       lcall 0x1388, 0x7fe
  013D6F  83c408           add sp, 8
  013D72  8b46e6           mov ax, word ptr [bp - 0x1a]
  013D75  0b46e4           or ax, word ptr [bp - 0x1c]
  013D78  740b             je 0x13d85
  013D7A  ff76e6           push word ptr [bp - 0x1a]
  013D7D  ff76e4           push word ptr [bp - 0x1c]
  013D80  9a1003c90c       lcall 0xcc9, 0x310
  013D85  8b46f2           mov ax, word ptr [bp - 0xe]
  013D88  8b56f4           mov dx, word ptr [bp - 0xc]
  013D8B  3946e0           cmp word ptr [bp - 0x20], ax
  013D8E  750c             jne 0x13d9c
  013D90  3956e2           cmp word ptr [bp - 0x1e], dx
  013D93  7507             jne 0x13d9c
  013D95  b80100           mov ax, 1
  013D98  e903fe           jmp 0x13b9e
  013D9B  90               nop
  013D9C  ff76e2           push word ptr [bp - 0x1e]
  013D9F  ff76e0           push word ptr [bp - 0x20]
  013DA2  52               push dx
  013DA3  50               push ax
  013DA4  9a220b8813       lcall 0x1388, 0xb22
  013DA9  5e               pop si
  013DAA  5f               pop di
  013DAB  c9               leave
  013DAC  ca0c00           retf 0xc
  013DAF  90               nop
