; MAPEDIT.EXE named disasm — module himem_5.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _himem_directory_setup  file 0x013F7E..0x0140A0  seg 0x1297:0xe  (himem_5.c.obj) ----
  013F7E  c8140000         enter 0x14, 0
  013F82  57               push di
  013F83  56               push si
  013F84  c746f0ffff       mov word ptr [bp - 0x10], 0xffff
  013F89  2bc0             sub ax, ax
  013F8B  8946f8           mov word ptr [bp - 8], ax
  013F8E  8946f6           mov word ptr [bp - 0xa], ax
  013F91  99               cdq
  013F92  8bf8             mov di, ax
  013F94  8956ee           mov word ptr [bp - 0x12], dx
  013F97  39067a44         cmp word ptr [0x447a], ax
  013F9B  7429             je 0x13fc6
  013F9D  c606fa4403       mov byte ptr [0x44fa], 3
  013FA2  a16044           mov ax, word ptr [0x4460]
  013FA5  8b166244         mov dx, word ptr [0x4462]
  013FA9  80c408           add ah, 8
  013FAC  a3fc44           mov word ptr [0x44fc], ax
  013FAF  8916fe44         mov word ptr [0x44fe], dx
  013FB3  a3c849           mov word ptr [0x49c8], ax
  013FB6  8916ca49         mov word ptr [0x49ca], dx
  013FBA  9a06009012       lcall 0x1290, 6
  013FBF  0bc0             or ax, ax
  013FC1  744f             je 0x14012
  013FC3  e9a000           jmp 0x14066
  013FC6  803ef94400       cmp byte ptr [0x44f9], 0
  013FCB  7403             je 0x13fd0
  013FCD  e99600           jmp 0x14066
  013FD0  c606fa4404       mov byte ptr [0x44fa], 4
  013FD5  b8bc34           mov ax, 0x34bc
  013FD8  99               cdq
  013FD9  8946f6           mov word ptr [bp - 0xa], ax
  013FDC  8956f8           mov word ptr [bp - 8], dx
  013FDF  9a04008b12       lcall 0x128b, 4
  013FE4  a30045           mov word ptr [0x4500], ax
  013FE7  0bc0             or ax, ax
  013FE9  7e7b             jle 0x14066
  013FEB  1e               push ds
  013FEC  680645           push 0x4506
  013FEF  b8bc34           mov ax, 0x34bc
  013FF2  99               cdq
  013FF3  9a3601c90c       lcall 0xcc9, 0x136
  013FF8  8bf8             mov di, ax
  013FFA  8956ee           mov word ptr [bp - 0x12], dx
  013FFD  a3c849           mov word ptr [0x49c8], ax
  014000  8916ca49         mov word ptr [0x49ca], dx
  014004  0bd0             or dx, ax
  014006  745e             je 0x14066
  014008  c706564b8e64     mov word ptr [0x4b56], 0x648e
  01400E  8c1e584b         mov word ptr [0x4b58], ds
  014012  a1c849           mov ax, word ptr [0x49c8]
  014015  8b16ca49         mov dx, word ptr [0x49ca]
  014019  8bd8             mov bx, ax
  01401B  8956fc           mov word ptr [bp - 4], dx
  01401E  c746fe9600       mov word ptr [bp - 2], 0x96
  014023  8b4efe           mov cx, word ptr [bp - 2]
  014026  8e46fc           mov es, word ptr [bp - 4]
  014029  8bf3             mov si, bx
  01402B  83c35a           add bx, 0x5a
  01402E  26c604ff         mov byte ptr es:[si], 0xff
  014032  e2f5             loop 0x14029
  014034  803efa4404       cmp byte ptr [0x44fa], 4
  014039  7520             jne 0x1405b
  01403B  6a00             push 0
  01403D  6a00             push 0
  01403F  ff360045         push word ptr [0x4500]
  014043  ff76ee           push word ptr [bp - 0x12]
  014046  57               push di
  014047  6a00             push 0
  014049  ff76f8           push word ptr [bp - 8]
  01404C  ff76f6           push word ptr [bp - 0xa]
  01404F  9a04004313       lcall 0x1343, 4
  014054  83c410           add sp, 0x10
  014057  0bc0             or ax, ax
  014059  750b             jne 0x14066
  01405B  c7060445ffff     mov word ptr [0x4504], 0xffff
  014061  c746f00000       mov word ptr [bp - 0x10], 0
  014066  8b46ee           mov ax, word ptr [bp - 0x12]
  014069  0bc7             or ax, di
  01406B  740a             je 0x14077
  01406D  8b46ee           mov ax, word ptr [bp - 0x12]
  014070  50               push ax
  014071  57               push di
  014072  9a1003c90c       lcall 0xcc9, 0x310
  014077  837ef000         cmp word ptr [bp - 0x10], 0
  01407B  741a             je 0x14097
  01407D  c606fa44ff       mov byte ptr [0x44fa], 0xff
  014082  833e004500       cmp word ptr [0x4500], 0
  014087  7e0e             jle 0x14097
  014089  a10045           mov ax, word ptr [0x4500]
  01408C  9a40008b12       lcall 0x128b, 0x40
  014091  c7060045ffff     mov word ptr [0x4500], 0xffff
  014097  8b46f0           mov ax, word ptr [bp - 0x10]
  01409A  5e               pop si
  01409B  5f               pop di
  01409C  c9               leave
  01409D  cb               retf
  01409E  90               nop
  01409F  90               nop
