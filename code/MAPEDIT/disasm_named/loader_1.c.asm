; MAPEDIT.EXE named disasm — module loader_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @loader_open  file 0x0137A0..0x013ADC  seg 0x121A:0x0  (loader_1.c.obj) ----
  0137A0  c81c0000         enter 0x1c, 0
  0137A4  50               push ax
  0137A5  53               push bx
  0137A6  57               push di
  0137A7  56               push si
  0137A8  8b7e0a           mov di, word ptr [bp + 0xa]
  0137AB  b8ffff           mov ax, 0xffff
  0137AE  8946fc           mov word ptr [bp - 4], ax
  0137B1  8946ec           mov word ptr [bp - 0x14], ax
  0137B4  6a0d             push 0xd
  0137B6  ff7608           push word ptr [bp + 8]
  0137B9  ff7606           push word ptr [bp + 6]
  0137BC  1e               push ds
  0137BD  68e844           push 0x44e8
  0137C0  9a580d8813       lcall 0x1388, 0xd58
  0137C5  83c40a           add sp, 0xa
  0137C8  8b76e2           mov si, word ptr [bp - 0x1e]
  0137CB  8e460c           mov es, word ptr [bp + 0xc]
  0137CE  26c7050000       mov word ptr es:[di], 0
  0137D3  6a72             push 0x72
  0137D5  ff76e0           push word ptr [bp - 0x20]
  0137D8  9a6a0a8813       lcall 0x1388, 0xa6a
  0137DD  83c402           add sp, 2
  0137E0  50               push ax
  0137E1  9ae8098813       lcall 0x1388, 0x9e8
  0137E6  83c404           add sp, 4
  0137E9  3d0100           cmp ax, 1
  0137EC  1bc0             sbb ax, ax
  0137EE  40               inc ax
  0137EF  8946fe           mov word ptr [bp - 2], ax
  0137F2  0bc0             or ax, ax
  0137F4  741c             je 0x13812
  0137F6  0bf6             or si, si
  0137F8  7418             je 0x13812
  0137FA  833ee64400       cmp word ptr [0x44e6], 0
  0137FF  7511             jne 0x13812
  013801  ff7608           push word ptr [bp + 8]
  013804  ff7606           push word ptr [bp + 6]
  013807  9a0a004513       lcall 0x1345, 0xa
  01380C  83c404           add sp, 4
  01380F  8946ec           mov word ptr [bp - 0x14], ax
  013812  837eec00         cmp word ptr [bp - 0x14], 0
  013816  7d03             jge 0x1381b
  013818  e90101           jmp 0x1391c
  01381B  8b36564b         mov si, word ptr [0x4b56]
  01381F  8e06584b         mov es, word ptr [0x4b58]
  013823  26803c03         cmp byte ptr es:[si], 3
  013827  7505             jne 0x1382e
  013829  b001             mov al, 1
  01382B  eb03             jmp 0x13830
  01382D  90               nop
  01382E  b002             mov al, 2
  013830  8cc1             mov cx, es
  013832  8e460c           mov es, word ptr [bp + 0xc]
  013835  26884504         mov byte ptr es:[di + 4], al
  013839  8cc0             mov ax, es
  01383B  8ec1             mov es, cx
  01383D  268b4c12         mov cx, word ptr es:[si + 0x12]
  013841  8cc2             mov dx, es
  013843  8ec0             mov es, ax
  013845  26894d0a         mov word ptr es:[di + 0xa], cx
  013849  2bc9             sub cx, cx
  01384B  26894d0e         mov word ptr es:[di + 0xe], cx
  01384F  26894d0c         mov word ptr es:[di + 0xc], cx
  013853  8b4eec           mov cx, word ptr [bp - 0x14]
  013856  26894d08         mov word ptr es:[di + 8], cx
  01385A  26c745120040     mov word ptr es:[di + 0x12], 0x4000
  013860  8ec2             mov es, dx
  013862  268b4c14         mov cx, word ptr es:[si + 0x14]
  013866  268b5c16         mov bx, word ptr es:[si + 0x16]
  01386A  8ec0             mov es, ax
  01386C  26894d14         mov word ptr es:[di + 0x14], cx
  013870  26895d16         mov word ptr es:[di + 0x16], bx
  013874  8bc8             mov cx, ax
  013876  8ec2             mov es, dx
  013878  268b5418         mov dx, word ptr es:[si + 0x18]
  01387C  8ec1             mov es, cx
  01387E  26895528         mov word ptr es:[di + 0x28], dx
  013882  bbffff           mov bx, 0xffff
  013885  26895d10         mov word ptr es:[di + 0x10], bx
  013889  26895d02         mov word ptr es:[di + 2], bx
  01388D  2bc0             sub ax, ax
  01388F  26894518         mov word ptr es:[di + 0x18], ax
  013893  8946ee           mov word ptr [bp - 0x12], ax
  013896  0bd2             or dx, dx
  013898  7e5d             jle 0x138f7
  01389A  8d452a           lea ax, [di + 0x2a]
  01389D  8b4e0c           mov cx, word ptr [bp + 0xc]
  0138A0  8946f8           mov word ptr [bp - 8], ax
  0138A3  894efa           mov word ptr [bp - 6], cx
  0138A6  8d441a           lea ax, [si + 0x1a]
  0138A9  8b0e584b         mov cx, word ptr [0x4b58]
  0138AD  8946f0           mov word ptr [bp - 0x10], ax
  0138B0  894ef2           mov word ptr [bp - 0xe], cx
  0138B3  8b5ef8           mov bx, word ptr [bp - 8]
  0138B6  8bf8             mov di, ax
  0138B8  8b4eee           mov cx, word ptr [bp - 0x12]
  0138BB  8e46fa           mov es, word ptr [bp - 6]
  0138BE  26c60700         mov byte ptr es:[bx], 0
  0138C2  8e46f2           mov es, word ptr [bp - 0xe]
  0138C5  268b05           mov ax, word ptr es:[di]
  0138C8  268b5502         mov dx, word ptr es:[di + 2]
  0138CC  8e46fa           mov es, word ptr [bp - 6]
  0138CF  26894702         mov word ptr es:[bx + 2], ax
  0138D3  26895704         mov word ptr es:[bx + 4], dx
  0138D7  8e46fa           mov es, word ptr [bp - 6]
  0138DA  26894706         mov word ptr es:[bx + 6], ax
  0138DE  26895708         mov word ptr es:[bx + 8], dx
  0138E2  83c30a           add bx, 0xa
  0138E5  83c704           add di, 4
  0138E8  8b46f2           mov ax, word ptr [bp - 0xe]
  0138EB  41               inc cx
  0138EC  c4760a           les si, ptr [bp + 0xa]
  0138EF  26394c28         cmp word ptr es:[si + 0x28], cx
  0138F3  7fc6             jg 0x138bb
  0138F5  8bfe             mov di, si
  0138F7  c41e564b         les bx, ptr [0x4b56]
  0138FB  26803f03         cmp byte ptr es:[bx], 3
  0138FF  750d             jne 0x1390e
  013901  8306c24401       add word ptr [0x44c2], 1
  013906  8316c44400       adc word ptr [0x44c4], 0
  01390B  e99501           jmp 0x13aa3
  01390E  8306c64401       add word ptr [0x44c6], 1
  013913  8316c84400       adc word ptr [0x44c8], 0
  013918  e98801           jmp 0x13aa3
  01391B  90               nop
  01391C  8e460c           mov es, word ptr [bp + 0xc]
  01391F  26c6450400       mov byte ptr es:[di + 4], 0
  013924  26c74508ffff     mov word ptr es:[di + 8], 0xffff
  01392A  ff7608           push word ptr [bp + 8]
  01392D  ff7606           push word ptr [bp + 6]
  013930  8b5ee0           mov bx, word ptr [bp - 0x20]
  013933  8cc6             mov si, es
  013935  9a04019702       lcall 0x297, 0x104
  01393A  8ec6             mov es, si
  01393C  26894506         mov word ptr es:[di + 6], ax
  013940  0bc0             or ax, ax
  013942  7503             jne 0x13947
  013944  e96901           jmp 0x13ab0
  013947  8b5efe           mov bx, word ptr [bp - 2]
  01394A  8e460c           mov es, word ptr [bp + 0xc]
  01394D  26895d02         mov word ptr es:[di + 2], bx
  013951  26c745180000     mov word ptr es:[di + 0x18], 0
  013957  0bdb             or bx, bx
  013959  7503             jne 0x1395e
  01395B  e9e600           jmp 0x13a44
  01395E  8d46e8           lea ax, [bp - 0x18]
  013961  50               push ax
  013962  8e460c           mov es, word ptr [bp + 0xc]
  013965  26ff7506         push word ptr es:[di + 6]
  013969  8cc6             mov si, es
  01396B  9a62078813       lcall 0x1388, 0x762
  013970  83c404           add sp, 4
  013973  8d451a           lea ax, [di + 0x1a]
  013976  56               push si
  013977  50               push ax
  013978  6a00             push 0
  01397A  6a01             push 1
  01397C  8ec6             mov es, si
  01397E  268b5d06         mov bx, word ptr es:[di + 6]
  013982  b81000           mov ax, 0x10
  013985  99               cdq
  013986  9a0000ca0b       lcall 0xbca, 0
  01398B  0bd0             or dx, ax
  01398D  7503             jne 0x13992
  01398F  e91e01           jmp 0x13ab0
  013992  6a0c             push 0xc
  013994  1e               push ds
  013995  68a644           push 0x44a6
  013998  8bc7             mov ax, di
  01399A  8b560c           mov dx, word ptr [bp + 0xc]
  01399D  051a00           add ax, 0x1a
  0139A0  52               push dx
  0139A1  50               push ax
  0139A2  9a1c0d8813       lcall 0x1388, 0xd1c
  0139A7  83c40a           add sp, 0xa
  0139AA  0bc0             or ax, ax
  0139AC  7403             je 0x139b1
  0139AE  e9ff00           jmp 0x13ab0
  0139B1  8bc7             mov ax, di
  0139B3  8b560c           mov dx, word ptr [bp + 0xc]
  0139B6  052a00           add ax, 0x2a
  0139B9  52               push dx
  0139BA  50               push ax
  0139BB  6a00             push 0
  0139BD  6a01             push 1
  0139BF  8ec2             mov es, dx
  0139C1  8bf7             mov si, di
  0139C3  268b4428         mov ax, word ptr es:[si + 0x28]
  0139C7  8bd0             mov dx, ax
  0139C9  c1e002           shl ax, 2
  0139CC  03c2             add ax, dx
  0139CE  d1e0             shl ax, 1
  0139D0  2bd2             sub dx, dx
  0139D2  268b5c06         mov bx, word ptr es:[si + 6]
  0139D6  9a0000ca0b       lcall 0xbca, 0
  0139DB  0bd0             or dx, ax
  0139DD  7503             jne 0x139e2
  0139DF  e9ce00           jmp 0x13ab0
  0139E2  8146e8b000       add word ptr [bp - 0x18], 0xb0
  0139E7  8356ea00         adc word ptr [bp - 0x16], 0
  0139EB  8d46e8           lea ax, [bp - 0x18]
  0139EE  50               push ax
  0139EF  8e460c           mov es, word ptr [bp + 0xc]
  0139F2  26ff7506         push word ptr es:[di + 6]
  0139F6  8cc6             mov si, es
  0139F8  9a7e088813       lcall 0x1388, 0x87e
  0139FD  83c404           add sp, 4
  013A00  8ec6             mov es, si
  013A02  2bc0             sub ax, ax
  013A04  26894516         mov word ptr es:[di + 0x16], ax
  013A08  26894514         mov word ptr es:[di + 0x14], ax
  013A0C  8946ee           mov word ptr [bp - 0x12], ax
  013A0F  26394528         cmp word ptr es:[di + 0x28], ax
  013A13  7f03             jg 0x13a18
  013A15  e98100           jmp 0x13a99
  013A18  8e5e0c           mov ds, word ptr [bp + 0xc]
  013A1B  8bc7             mov ax, di
  013A1D  8cda             mov dx, ds
  013A1F  052c00           add ax, 0x2c
  013A22  8bd8             mov bx, ax
  013A24  8ec2             mov es, dx
  013A26  8b4d28           mov cx, word ptr [di + 0x28]
  013A29  8bf3             mov si, bx
  013A2B  83c30a           add bx, 0xa
  013A2E  268b04           mov ax, word ptr es:[si]
  013A31  268b5402         mov dx, word ptr es:[si + 2]
  013A35  014514           add word ptr [di + 0x14], ax
  013A38  115516           adc word ptr [di + 0x16], dx
  013A3B  e2ec             loop 0x13a29
  013A3D  b8e715           mov ax, 0x15e7
  013A40  8ed8             mov ds, ax
  013A42  eb55             jmp 0x13a99
  013A44  8e460c           mov es, word ptr [bp + 0xc]
  013A47  26c745280000     mov word ptr es:[di + 0x28], 0
  013A4D  8a46e2           mov al, byte ptr [bp - 0x1e]
  013A50  2688452a         mov byte ptr es:[di + 0x2a], al
  013A54  1e               push ds
  013A55  68b444           push 0x44b4
  013A58  8d451a           lea ax, [di + 0x1a]
  013A5B  06               push es
  013A5C  50               push ax
  013A5D  8bf0             mov si, ax
  013A5F  8976e4           mov word ptr [bp - 0x1c], si
  013A62  8c46e6           mov word ptr [bp - 0x1a], es
  013A65  8cc6             mov si, es
  013A67  9aec0d8813       lcall 0x1388, 0xdec
  013A6C  83c408           add sp, 8
  013A6F  ff76e6           push word ptr [bp - 0x1a]
  013A72  ff76e4           push word ptr [bp - 0x1c]
  013A75  6a00             push 0
  013A77  6a01             push 1
  013A79  8ec6             mov es, si
  013A7B  268b5d06         mov bx, word ptr es:[di + 6]
  013A7F  b8b000           mov ax, 0xb0
  013A82  99               cdq
  013A83  9a0800ea0b       lcall 0xbea, 8
  013A88  0bd0             or dx, ax
  013A8A  7424             je 0x13ab0
  013A8C  8e460c           mov es, word ptr [bp + 0xc]
  013A8F  2bc0             sub ax, ax
  013A91  26894516         mov word ptr es:[di + 0x16], ax
  013A95  26894514         mov word ptr es:[di + 0x14], ax
  013A99  8306ca4401       add word ptr [0x44ca], 1
  013A9E  8316cc4400       adc word ptr [0x44cc], 0
  013AA3  8e460c           mov es, word ptr [bp + 0xc]
  013AA6  26c705ffff       mov word ptr es:[di], 0xffff
  013AAB  c746fc0000       mov word ptr [bp - 4], 0
  013AB0  837efc00         cmp word ptr [bp - 4], 0
  013AB4  741c             je 0x13ad2
  013AB6  837eec00         cmp word ptr [bp - 0x14], 0
  013ABA  7516             jne 0x13ad2
  013ABC  8e460c           mov es, word ptr [bp + 0xc]
  013ABF  26837d0600       cmp word ptr es:[di + 6], 0
  013AC4  740c             je 0x13ad2
  013AC6  26ff7506         push word ptr es:[di + 6]
  013ACA  9ac2028813       lcall 0x1388, 0x2c2
  013ACF  83c402           add sp, 2
  013AD2  8b46fc           mov ax, word ptr [bp - 4]
  013AD5  5e               pop si
  013AD6  5f               pop di
  013AD7  c9               leave
  013AD8  ca0800           retf 8
  013ADB  90               nop

; ---- @loader_set_priority  file 0x013ADC..0x013AEE  seg 0x121A:0x33c  (loader_1.c.obj) ----
  013ADC  55               push bp
  013ADD  8bec             mov bp, sp
  013ADF  56               push si
  013AE0  8bd8             mov bx, ax
  013AE2  c47606           les si, ptr [bp + 6]
  013AE5  26885c2b         mov byte ptr es:[si + 0x2b], bl
  013AE9  5e               pop si
  013AEA  c9               leave
  013AEB  ca0400           retf 4

; ---- @loader_close  file 0x013AEE..0x013B82  seg 0x121A:0x34e  (loader_1.c.obj) ----
  013AEE  55               push bp
  013AEF  8bec             mov bp, sp
  013AF1  57               push di
  013AF2  56               push si
  013AF3  c47606           les si, ptr [bp + 6]
  013AF6  2bff             sub di, di
  013AF8  26393c           cmp word ptr es:[si], di
  013AFB  7475             je 0x13b72
  013AFD  26807c0401       cmp byte ptr es:[si + 4], 1
  013B02  7458             je 0x13b5c
  013B04  26807c0402       cmp byte ptr es:[si + 4], 2
  013B09  7451             je 0x13b5c
  013B0B  26397c02         cmp word ptr es:[si + 2], di
  013B0F  7539             jne 0x13b4a
  013B11  26ff7406         push word ptr es:[si + 6]
  013B15  8cc7             mov di, es
  013B17  9a98088813       lcall 0x1388, 0x898
  013B1C  83c402           add sp, 2
  013B1F  8bc6             mov ax, si
  013B21  8bd7             mov dx, di
  013B23  051a00           add ax, 0x1a
  013B26  52               push dx
  013B27  50               push ax
  013B28  6a00             push 0
  013B2A  6a01             push 1
  013B2C  8ec7             mov es, di
  013B2E  8bde             mov bx, si
  013B30  268b5f06         mov bx, word ptr es:[bx + 6]
  013B34  b8b000           mov ax, 0xb0
  013B37  99               cdq
  013B38  9a0800ea0b       lcall 0xbea, 8
  013B3D  0bd0             or dx, ax
  013B3F  7507             jne 0x13b48
  013B41  bf0100           mov di, 1
  013B44  eb04             jmp 0x13b4a
  013B46  90               nop
  013B47  90               nop
  013B48  2bff             sub di, di
  013B4A  8e4608           mov es, word ptr [bp + 8]
  013B4D  26ff7406         push word ptr es:[si + 6]
  013B51  9ac2028813       lcall 0x1388, 0x2c2
  013B56  83c402           add sp, 2
  013B59  eb17             jmp 0x13b72
  013B5B  90               nop
  013B5C  26c74410ffff     mov word ptr es:[si + 0x10], 0xffff
  013B62  26c744120040     mov word ptr es:[si + 0x12], 0x4000
  013B68  2bc0             sub ax, ax
  013B6A  2689440e         mov word ptr es:[si + 0xe], ax
  013B6E  2689440c         mov word ptr es:[si + 0xc], ax
  013B72  8e4608           mov es, word ptr [bp + 8]
  013B75  26c7040000       mov word ptr es:[si], 0
  013B7A  8bc7             mov ax, di
  013B7C  5e               pop si
  013B7D  5f               pop di
  013B7E  c9               leave
  013B7F  ca0400           retf 4
