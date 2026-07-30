; MAPEDIT.EXE named disasm — module popup.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _popup_say_string  file 0x004DAE..0x004DCA  seg 0x33D:0x3de  (popup.obj) ----
  004DAE  55               push bp
  004DAF  8bec             mov bp, sp
  004DB1  ff760a           push word ptr [bp + 0xa]
  004DB4  ff7608           push word ptr [bp + 8]
  004DB7  8b4606           mov ax, word ptr [bp + 6]
  004DBA  c1e006           shl ax, 6
  004DBD  054e63           add ax, 0x634e
  004DC0  1e               push ds
  004DC1  50               push ax
  004DC2  9aec0d8813       lcall 0x1388, 0xdec
  004DC7  c9               leave
  004DC8  cb               retf
  004DC9  90               nop

; ---- _popup_say  file 0x004DCA..0x004DE2  seg 0x33D:0x3fa  (popup.obj) ----
  004DCA  55               push bp
  004DCB  8bec             mov bp, sp
  004DCD  ff7608           push word ptr [bp + 8]
  004DD0  9a6c003403       lcall 0x334, 0x6c
  004DD5  8be5             mov sp, bp
  004DD7  52               push dx
  004DD8  50               push ax
  004DD9  ff7606           push word ptr [bp + 6]
  004DDC  0e               push cs
  004DDD  e8ceff           call 0x4dae
  004DE0  c9               leave
  004DE1  cb               retf

; ---- _popup_country  file 0x004DE2..0x004E0A  seg 0x33D:0x412  (popup.obj) ----
  004DE2  c8500000         enter 0x50, 0
  004DE6  c646b000         mov byte ptr [bp - 0x50], 0
  004DEA  8d46b0           lea ax, [bp - 0x50]
  004DED  50               push ax
  004DEE  ff7608           push word ptr [bp + 8]
  004DF1  ff760a           push word ptr [bp + 0xa]
  004DF4  9a14000000       lcall 0, 0x14
  004DF9  83c406           add sp, 6
  004DFC  8d46b0           lea ax, [bp - 0x50]
  004DFF  16               push ss
  004E00  50               push ax
  004E01  ff7606           push word ptr [bp + 6]
  004E04  0e               push cs
  004E05  e8a6ff           call 0x4dae
  004E08  c9               leave
  004E09  cb               retf

; ---- _popup_num  file 0x004E0A..0x004E24  seg 0x33D:0x43a  (popup.obj) ----
  004E0A  55               push bp
  004E0B  8bec             mov bp, sp
  004E0D  8b4608           mov ax, word ptr [bp + 8]
  004E10  8b560a           mov dx, word ptr [bp + 0xa]
  004E13  8b5e06           mov bx, word ptr [bp + 6]
  004E16  c1e302           shl bx, 2
  004E19  89878a69         mov word ptr [bx + 0x698a], ax
  004E1D  89978c69         mov word ptr [bx + 0x698c], dx
  004E21  c9               leave
  004E22  cb               retf
  004E23  90               nop

; ---- _popup_set_font  file 0x004E24..0x0050AE  seg 0x33D:0x454  (popup.obj) ----
  004E24  55               push bp
  004E25  8bec             mov bp, sp
  004E27  8b460e           mov ax, word ptr [bp + 0xe]
  004E2A  c45e06           les bx, ptr [bp + 6]
  004E2D  268907           mov word ptr es:[bx], ax
  004E30  8b4610           mov ax, word ptr [bp + 0x10]
  004E33  26894702         mov word ptr es:[bx + 2], ax
  004E37  8b4612           mov ax, word ptr [bp + 0x12]
  004E3A  26894704         mov word ptr es:[bx + 4], ax
  004E3E  8b4614           mov ax, word ptr [bp + 0x14]
  004E41  26894706         mov word ptr es:[bx + 6], ax
  004E45  8b4616           mov ax, word ptr [bp + 0x16]
  004E48  26894708         mov word ptr es:[bx + 8], ax
  004E4C  8b4618           mov ax, word ptr [bp + 0x18]
  004E4F  2689470a         mov word ptr es:[bx + 0xa], ax
  004E53  8b460a           mov ax, word ptr [bp + 0xa]
  004E56  8b560c           mov dx, word ptr [bp + 0xc]
  004E59  2689470c         mov word ptr es:[bx + 0xc], ax
  004E5D  2689570e         mov word ptr es:[bx + 0xe], dx
  004E61  c9               leave
  004E62  cb               retf
  004E63  90               nop
  004E64  c8540000         enter 0x54, 0
  004E68  ff7606           push word ptr [bp + 6]
  004E6B  ff7604           push word ptr [bp + 4]
  004E6E  8d46b0           lea ax, [bp - 0x50]
  004E71  16               push ss
  004E72  50               push ax
  004E73  9aec0d8813       lcall 0x1388, 0xdec
  004E78  83c408           add sp, 8
  004E7B  8d46b0           lea ax, [bp - 0x50]
  004E7E  8946ae           mov word ptr [bp - 0x52], ax
  004E81  eb2a             jmp 0x4ead
  004E83  90               nop
  004E84  8a07             mov al, byte ptr [bx]
  004E86  2ae4             sub ah, ah
  004E88  50               push ax
  004E89  688c05           push 0x58c
  004E8C  9ae8098813       lcall 0x1388, 0x9e8
  004E91  83c404           add sp, 4
  004E94  0bc0             or ax, ax
  004E96  7412             je 0x4eaa
  004E98  8b46ae           mov ax, word ptr [bp - 0x52]
  004E9B  40               inc ax
  004E9C  50               push ax
  004E9D  ff76ae           push word ptr [bp - 0x52]
  004EA0  9a26068813       lcall 0x1388, 0x626
  004EA5  83c404           add sp, 4
  004EA8  eb03             jmp 0x4ead
  004EAA  ff46ae           inc word ptr [bp - 0x52]
  004EAD  8b5eae           mov bx, word ptr [bp - 0x52]
  004EB0  803f00           cmp byte ptr [bx], 0
  004EB3  75cf             jne 0x4e84
  004EB5  c45e08           les bx, ptr [bp + 8]
  004EB8  26ff770e         push word ptr es:[bx + 0xe]
  004EBC  26ff770c         push word ptr es:[bx + 0xc]
  004EC0  8d46b0           lea ax, [bp - 0x50]
  004EC3  16               push ss
  004EC4  50               push ax
  004EC5  268b07           mov ax, word ptr es:[bx]
  004EC8  9a02006c0d       lcall 0xd6c, 2
  004ECD  8946ac           mov word ptr [bp - 0x54], ax
  004ED0  c9               leave
  004ED1  c20800           ret 8
  004ED4  55               push bp
  004ED5  8bec             mov bp, sp
  004ED7  0bc0             or ax, ax
  004ED9  740d             je 0x4ee8
  004EDB  c45e04           les bx, ptr [bp + 4]
  004EDE  26ff770a         push word ptr es:[bx + 0xa]
  004EE2  268b5704         mov dx, word ptr es:[bx + 4]
  004EE6  eb1d             jmp 0x4f05
  004EE8  0bd2             or dx, dx
  004EEA  740e             je 0x4efa
  004EEC  c45e04           les bx, ptr [bp + 4]
  004EEF  26ff770a         push word ptr es:[bx + 0xa]
  004EF3  268b5706         mov dx, word ptr es:[bx + 6]
  004EF7  eb0c             jmp 0x4f05
  004EF9  90               nop
  004EFA  c45e04           les bx, ptr [bp + 4]
  004EFD  26ff770a         push word ptr es:[bx + 0xa]
  004F01  268b5702         mov dx, word ptr es:[bx + 2]
  004F05  268b5f08         mov bx, word ptr es:[bx + 8]
  004F09  b8ffff           mov ax, 0xffff
  004F0C  9a06006a0d       lcall 0xd6a, 6
  004F11  c9               leave
  004F12  c20400           ret 4
  004F15  90               nop
  004F16  c8080000         enter 8, 0
  004F1A  53               push bx
  004F1B  52               push dx
  004F1C  50               push ax
  004F1D  c646ff00         mov byte ptr [bp - 1], 0
  004F21  ff760a           push word ptr [bp + 0xa]
  004F24  ff7608           push word ptr [bp + 8]
  004F27  8bc3             mov ax, bx
  004F29  250100           and ax, 1
  004F2C  8946fc           mov word ptr [bp - 4], ax
  004F2F  8b166205         mov dx, word ptr [0x562]
  004F33  e89eff           call 0x4ed4
  004F36  8b4604           mov ax, word ptr [bp + 4]
  004F39  8b5606           mov dx, word ptr [bp + 6]
  004F3C  8946f8           mov word ptr [bp - 8], ax
  004F3F  8956fa           mov word ptr [bp - 6], dx
  004F42  c45ef8           les bx, ptr [bp - 8]
  004F45  26803f00         cmp byte ptr es:[bx], 0
  004F49  7503             jne 0x4f4e
  004F4B  e9ca00           jmp 0x5018
  004F4E  268a07           mov al, byte ptr es:[bx]
  004F51  98               cwde
  004F52  2d7b00           sub ax, 0x7b
  004F55  7503             jne 0x4f5a
  004F57  e9a000           jmp 0x4ffa
  004F5A  48               dec ax
  004F5B  7503             jne 0x4f60
  004F5D  e9b800           jmp 0x5018
  004F60  48               dec ax
  004F61  7503             jne 0x4f66
  004F63  e9a000           jmp 0x5006
  004F66  48               dec ax
  004F67  7433             je 0x4f9c
  004F69  268a07           mov al, byte ptr es:[bx]
  004F6C  8846fe           mov byte ptr [bp - 2], al
  004F6F  c45e08           les bx, ptr [bp + 8]
  004F72  26ff770e         push word ptr es:[bx + 0xe]
  004F76  26ff770c         push word ptr es:[bx + 0xc]
  004F7A  8d46fe           lea ax, [bp - 2]
  004F7D  16               push ss
  004F7E  50               push ax
  004F7F  26ff37           push word ptr es:[bx]
  004F82  8d1ef43a         lea bx, [0x3af4]
  004F86  8b46f2           mov ax, word ptr [bp - 0xe]
  004F89  8b56f4           mov dx, word ptr [bp - 0xc]
  004F8C  9a0800530d       lcall 0xd53, 8
  004F91  c45e08           les bx, ptr [bp + 8]
  004F94  260307           add ax, word ptr es:[bx]
  004F97  8946f2           mov word ptr [bp - 0xe], ax
  004F9A  eb58             jmp 0x4ff4
  004F9C  ff760a           push word ptr [bp + 0xa]
  004F9F  ff7608           push word ptr [bp + 8]
  004FA2  833e620501       cmp word ptr [0x562], 1
  004FA7  1bd2             sbb dx, dx
  004FA9  f7da             neg dx
  004FAB  8b46fc           mov ax, word ptr [bp - 4]
  004FAE  e823ff           call 0x4ed4
  004FB1  ff46f8           inc word ptr [bp - 8]
  004FB4  c45ef8           les bx, ptr [bp - 8]
  004FB7  268a07           mov al, byte ptr es:[bx]
  004FBA  8846fe           mov byte ptr [bp - 2], al
  004FBD  c45e08           les bx, ptr [bp + 8]
  004FC0  26ff770e         push word ptr es:[bx + 0xe]
  004FC4  26ff770c         push word ptr es:[bx + 0xc]
  004FC8  8d46fe           lea ax, [bp - 2]
  004FCB  16               push ss
  004FCC  50               push ax
  004FCD  26ff37           push word ptr es:[bx]
  004FD0  8d1ef43a         lea bx, [0x3af4]
  004FD4  8b46f2           mov ax, word ptr [bp - 0xe]
  004FD7  8b56f4           mov dx, word ptr [bp - 0xc]
  004FDA  9a0800530d       lcall 0xd53, 8
  004FDF  c45e08           les bx, ptr [bp + 8]
  004FE2  260307           add ax, word ptr es:[bx]
  004FE5  8946f2           mov word ptr [bp - 0xe], ax
  004FE8  06               push es
  004FE9  53               push bx
  004FEA  8b46fc           mov ax, word ptr [bp - 4]
  004FED  8b166205         mov dx, word ptr [0x562]
  004FF1  e8e0fe           call 0x4ed4
  004FF4  ff46f8           inc word ptr [bp - 8]
  004FF7  e948ff           jmp 0x4f42
  004FFA  ff760a           push word ptr [bp + 0xa]
  004FFD  ff7608           push word ptr [bp + 8]
  005000  ba0100           mov dx, 1
  005003  eb09             jmp 0x500e
  005005  90               nop
  005006  ff760a           push word ptr [bp + 0xa]
  005009  ff7608           push word ptr [bp + 8]
  00500C  2bd2             sub dx, dx
  00500E  89166205         mov word ptr [0x562], dx
  005012  8b46fc           mov ax, word ptr [bp - 4]
  005015  ebda             jmp 0x4ff1
  005017  90               nop
  005018  8b46f2           mov ax, word ptr [bp - 0xe]
  00501B  c9               leave
  00501C  c20800           ret 8
  00501F  90               nop
  005020  c80c0000         enter 0xc, 0
  005024  c746fe0000       mov word ptr [bp - 2], 0
  005029  6a7e             push 0x7e
  00502B  ff7606           push word ptr [bp + 6]
  00502E  ff7604           push word ptr [bp + 4]
  005031  9a820d8813       lcall 0x1388, 0xd82
  005036  83c406           add sp, 6
  005039  8946fa           mov word ptr [bp - 6], ax
  00503C  8956fc           mov word ptr [bp - 4], dx
  00503F  6a7e             push 0x7e
  005041  ff7606           push word ptr [bp + 6]
  005044  ff7604           push word ptr [bp + 4]
  005047  9aa80c8813       lcall 0x1388, 0xca8
  00504C  83c406           add sp, 6
  00504F  3b46fa           cmp ax, word ptr [bp - 6]
  005052  7505             jne 0x5059
  005054  3b56fc           cmp dx, word ptr [bp - 4]
  005057  7421             je 0x507a
  005059  8ec2             mov es, dx
  00505B  8bd8             mov bx, ax
  00505D  26807f0146       cmp byte ptr es:[bx + 1], 0x46
  005062  7516             jne 0x507a
  005064  c45efa           les bx, ptr [bp - 6]
  005067  268a5f01         mov bl, byte ptr es:[bx + 1]
  00506B  2aff             sub bh, bh
  00506D  f687a94504       test byte ptr [bx + 0x45a9], 4
  005072  7406             je 0x507a
  005074  8d870a01         lea ax, [bx + 0x10a]
  005078  eb29             jmp 0x50a3
  00507A  8b46fc           mov ax, word ptr [bp - 4]
  00507D  0b46fa           or ax, word ptr [bp - 6]
  005080  7424             je 0x50a6
  005082  c45efa           les bx, ptr [bp - 6]
  005085  268a5f01         mov bl, byte ptr es:[bx + 1]
  005089  2aff             sub bh, bh
  00508B  f687a94502       test byte ptr [bx + 0x45a9], 2
  005090  7408             je 0x509a
  005092  8bc3             mov ax, bx
  005094  2d2000           sub ax, 0x20
  005097  eb0a             jmp 0x50a3
  005099  90               nop
  00509A  8b5efa           mov bx, word ptr [bp - 6]
  00509D  268a4701         mov al, byte ptr es:[bx + 1]
  0050A1  2ae4             sub ah, ah
  0050A3  8946fe           mov word ptr [bp - 2], ax
  0050A6  8b46fe           mov ax, word ptr [bp - 2]
  0050A9  c9               leave
  0050AA  c20400           ret 4
  0050AD  90               nop

; ---- _popup_create  file 0x0050AE..0x0052D8  seg 0x33D:0x6de  (popup.obj) ----
  0050AE  c8140000         enter 0x14, 0
  0050B2  2bc0             sub ax, ax
  0050B4  8946ee           mov word ptr [bp - 0x12], ax
  0050B7  8946ec           mov word ptr [bp - 0x14], ax
  0050BA  a36e05           mov word ptr [0x56e], ax
  0050BD  a37005           mov word ptr [0x570], ax
  0050C0  8b4606           mov ax, word ptr [bp + 6]
  0050C3  059600           add ax, 0x96
  0050C6  2bd2             sub dx, dx
  0050C8  9ae202c90c       lcall 0xcc9, 0x2e2
  0050CD  8946f0           mov word ptr [bp - 0x10], ax
  0050D0  8956f2           mov word ptr [bp - 0xe], dx
  0050D3  0bd0             or dx, ax
  0050D5  7503             jne 0x50da
  0050D7  e97301           jmp 0x524d
  0050DA  8b56f2           mov dx, word ptr [bp - 0xe]
  0050DD  8946f8           mov word ptr [bp - 8], ax
  0050E0  8956fa           mov word ptr [bp - 6], dx
  0050E3  059600           add ax, 0x96
  0050E6  8b4ef8           mov cx, word ptr [bp - 8]
  0050E9  8bda             mov bx, dx
  0050EB  81c18400         add cx, 0x84
  0050EF  53               push bx
  0050F0  51               push cx
  0050F1  52               push dx
  0050F2  50               push ax
  0050F3  8b4606           mov ax, word ptr [bp + 6]
  0050F6  99               cdq
  0050F7  52               push dx
  0050F8  50               push ax
  0050F9  b82900           mov ax, 0x29
  0050FC  9a9000450f       lcall 0xf45, 0x90
  005101  c45ef8           les bx, ptr [bp - 8]
  005104  2bc0             sub ax, ax
  005106  2689474e         mov word ptr es:[bx + 0x4e], ax
  00510A  2689474c         mov word ptr es:[bx + 0x4c], ax
  00510E  26894752         mov word ptr es:[bx + 0x52], ax
  005112  26894750         mov word ptr es:[bx + 0x50], ax
  005116  a15605           mov ax, word ptr [0x556]
  005119  2689470a         mov word ptr es:[bx + 0xa], ax
  00511D  a15805           mov ax, word ptr [0x558]
  005120  2689470c         mov word ptr es:[bx + 0xc], ax
  005124  a15a05           mov ax, word ptr [0x55a]
  005127  2689470e         mov word ptr es:[bx + 0xe], ax
  00512B  b8ffff           mov ax, 0xffff
  00512E  a35805           mov word ptr [0x558], ax
  005131  a35a05           mov word ptr [0x55a], ax
  005134  26c747285000     mov word ptr es:[bx + 0x28], 0x50
  00513A  b80400           mov ax, 4
  00513D  26894722         mov word ptr es:[bx + 0x22], ax
  005141  26894732         mov word ptr es:[bx + 0x32], ax
  005145  a13c05           mov ax, word ptr [0x53c]
  005148  2689473c         mov word ptr es:[bx + 0x3c], ax
  00514C  a13e05           mov ax, word ptr [0x53e]
  00514F  2689473e         mov word ptr es:[bx + 0x3e], ax
  005153  a14005           mov ax, word ptr [0x540]
  005156  26894740         mov word ptr es:[bx + 0x40], ax
  00515A  a14205           mov ax, word ptr [0x542]
  00515D  26894742         mov word ptr es:[bx + 0x42], ax
  005161  a14405           mov ax, word ptr [0x544]
  005164  26894744         mov word ptr es:[bx + 0x44], ax
  005168  268a470a         mov al, byte ptr es:[bx + 0xa]
  00516C  251000           and ax, 0x10
  00516F  3d0100           cmp ax, 1
  005172  1bc9             sbb cx, cx
  005174  83e103           and cx, 3
  005177  26894f46         mov word ptr es:[bx + 0x46], cx
  00517B  3d0100           cmp ax, 1
  00517E  1bc0             sbb ax, ax
  005180  250200           and ax, 2
  005183  26894748         mov word ptr es:[bx + 0x48], ax
  005187  2bc0             sub ax, ax
  005189  26894756         mov word ptr es:[bx + 0x56], ax
  00518D  26894754         mov word ptr es:[bx + 0x54], ax
  005191  2689475a         mov word ptr es:[bx + 0x5a], ax
  005195  26894758         mov word ptr es:[bx + 0x58], ax
  005199  2689475e         mov word ptr es:[bx + 0x5e], ax
  00519D  2689475c         mov word ptr es:[bx + 0x5c], ax
  0051A1  26894762         mov word ptr es:[bx + 0x62], ax
  0051A5  26894760         mov word ptr es:[bx + 0x60], ax
  0051A9  26894772         mov word ptr es:[bx + 0x72], ax
  0051AD  26894770         mov word ptr es:[bx + 0x70], ax
  0051B1  26894766         mov word ptr es:[bx + 0x66], ax
  0051B5  26894764         mov word ptr es:[bx + 0x64], ax
  0051B9  2689476a         mov word ptr es:[bx + 0x6a], ax
  0051BD  26894768         mov word ptr es:[bx + 0x68], ax
  0051C1  2689476e         mov word ptr es:[bx + 0x6e], ax
  0051C5  2689476c         mov word ptr es:[bx + 0x6c], ax
  0051C9  ff365205         push word ptr [0x552]
  0051CD  ff365005         push word ptr [0x550]
  0051D1  ff364e05         push word ptr [0x54e]
  0051D5  ff364c05         push word ptr [0x54c]
  0051D9  ff364a05         push word ptr [0x54a]
  0051DD  268907           mov word ptr es:[bx], ax
  0051E0  26894702         mov word ptr es:[bx + 2], ax
  0051E4  26894704         mov word ptr es:[bx + 4], ax
  0051E8  26894706         mov word ptr es:[bx + 6], ax
  0051EC  26894708         mov word ptr es:[bx + 8], ax
  0051F0  a35605           mov word ptr [0x556], ax
  0051F3  26894720         mov word ptr es:[bx + 0x20], ax
  0051F7  26894724         mov word ptr es:[bx + 0x24], ax
  0051FB  26894726         mov word ptr es:[bx + 0x26], ax
  0051FF  2689472a         mov word ptr es:[bx + 0x2a], ax
  005203  2689472c         mov word ptr es:[bx + 0x2c], ax
  005207  2689472e         mov word ptr es:[bx + 0x2e], ax
  00520B  26894730         mov word ptr es:[bx + 0x30], ax
  00520F  26894734         mov word ptr es:[bx + 0x34], ax
  005213  26894736         mov word ptr es:[bx + 0x36], ax
  005217  26894738         mov word ptr es:[bx + 0x38], ax
  00521B  2689474a         mov word ptr es:[bx + 0x4a], ax
  00521F  50               push ax
  005220  ff760a           push word ptr [bp + 0xa]
  005223  ff7608           push word ptr [bp + 8]
  005226  8d4774           lea ax, [bx + 0x74]
  005229  06               push es
  00522A  50               push ax
  00522B  0e               push cs
  00522C  e8f5fb           call 0x4e24
  00522F  83c414           add sp, 0x14
  005232  833ec04900       cmp word ptr [0x49c0], 0
  005237  7508             jne 0x5241
  005239  c45ef8           les bx, ptr [bp - 8]
  00523C  26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  005241  8b46f8           mov ax, word ptr [bp - 8]
  005244  8b56fa           mov dx, word ptr [bp - 6]
  005247  8946ec           mov word ptr [bp - 0x14], ax
  00524A  8956ee           mov word ptr [bp - 0x12], dx
  00524D  8b46f2           mov ax, word ptr [bp - 0xe]
  005250  0b46f0           or ax, word ptr [bp - 0x10]
  005253  741b             je 0x5270
  005255  8b46ec           mov ax, word ptr [bp - 0x14]
  005258  8b56ee           mov dx, word ptr [bp - 0x12]
  00525B  3946f0           cmp word ptr [bp - 0x10], ax
  00525E  7505             jne 0x5265
  005260  3956f2           cmp word ptr [bp - 0xe], dx
  005263  740b             je 0x5270
  005265  ff76f2           push word ptr [bp - 0xe]
  005268  ff76f0           push word ptr [bp - 0x10]
  00526B  9a1003c90c       lcall 0xcc9, 0x310
  005270  8b46ec           mov ax, word ptr [bp - 0x14]
  005273  8b56ee           mov dx, word ptr [bp - 0x12]
  005276  c9               leave
  005277  cb               retf
  005278  c80a0000         enter 0xa, 0
  00527C  50               push ax
  00527D  c746fe0000       mov word ptr [bp - 2], 0
  005282  2bc0             sub ax, ax
  005284  8946f8           mov word ptr [bp - 8], ax
  005287  8946f6           mov word ptr [bp - 0xa], ax
  00528A  c45e06           les bx, ptr [bp + 6]
  00528D  268b4754         mov ax, word ptr es:[bx + 0x54]
  005291  268b5756         mov dx, word ptr es:[bx + 0x56]
  005295  eb2b             jmp 0x52c2
  005297  90               nop
  005298  8b46fc           mov ax, word ptr [bp - 4]
  00529B  0b46fa           or ax, word ptr [bp - 6]
  00529E  742e             je 0x52ce
  0052A0  8b46f4           mov ax, word ptr [bp - 0xc]
  0052A3  c45efa           les bx, ptr [bp - 6]
  0052A6  26394704         cmp word ptr es:[bx + 4], ax
  0052AA  750e             jne 0x52ba
  0052AC  c746fe0100       mov word ptr [bp - 2], 1
  0052B1  895ef6           mov word ptr [bp - 0xa], bx
  0052B4  8c46f8           mov word ptr [bp - 8], es
  0052B7  eb0f             jmp 0x52c8
  0052B9  90               nop
  0052BA  268b4710         mov ax, word ptr es:[bx + 0x10]
  0052BE  268b5712         mov dx, word ptr es:[bx + 0x12]
  0052C2  8946fa           mov word ptr [bp - 6], ax
  0052C5  8956fc           mov word ptr [bp - 4], dx
  0052C8  837efe00         cmp word ptr [bp - 2], 0
  0052CC  74ca             je 0x5298
  0052CE  8b46f6           mov ax, word ptr [bp - 0xa]
  0052D1  8b56f8           mov dx, word ptr [bp - 8]
  0052D4  c9               leave
  0052D5  ca0400           retf 4

; ---- _popup_grey  file 0x0052D8..0x005308  seg 0x33D:0x908  (popup.obj) ----
  0052D8  c8040000         enter 4, 0
  0052DC  ff7608           push word ptr [bp + 8]
  0052DF  ff7606           push word ptr [bp + 6]
  0052E2  8b460a           mov ax, word ptr [bp + 0xa]
  0052E5  0e               push cs
  0052E6  e88fff           call 0x5278
  0052E9  8946fc           mov word ptr [bp - 4], ax
  0052EC  8956fe           mov word ptr [bp - 2], dx
  0052EF  837e0c00         cmp word ptr [bp + 0xc], 0
  0052F3  7409             je 0x52fe
  0052F5  c45efc           les bx, ptr [bp - 4]
  0052F8  26800f01         or byte ptr es:[bx], 1
  0052FC  c9               leave
  0052FD  cb               retf
  0052FE  c45efc           les bx, ptr [bp - 4]
  005301  268027fe         and byte ptr es:[bx], 0xfe
  005305  c9               leave
  005306  cb               retf
  005307  90               nop

; ---- _popup_hilite  file 0x005308..0x005338  seg 0x33D:0x938  (popup.obj) ----
  005308  c8040000         enter 4, 0
  00530C  ff7608           push word ptr [bp + 8]
  00530F  ff7606           push word ptr [bp + 6]
  005312  8b460a           mov ax, word ptr [bp + 0xa]
  005315  0e               push cs
  005316  e85fff           call 0x5278
  005319  8946fc           mov word ptr [bp - 4], ax
  00531C  8956fe           mov word ptr [bp - 2], dx
  00531F  837e0c00         cmp word ptr [bp + 0xc], 0
  005323  7409             je 0x532e
  005325  c45efc           les bx, ptr [bp - 4]
  005328  26800f02         or byte ptr es:[bx], 2
  00532C  c9               leave
  00532D  cb               retf
  00532E  c45efc           les bx, ptr [bp - 4]
  005331  268027fd         and byte ptr es:[bx], 0xfd
  005335  c9               leave
  005336  cb               retf
  005337  90               nop

; ---- _popup_release_all_grey  file 0x005338..0x005368  seg 0x33D:0x968  (popup.obj) ----
  005338  c8040000         enter 4, 0
  00533C  c45e06           les bx, ptr [bp + 6]
  00533F  268b4754         mov ax, word ptr es:[bx + 0x54]
  005343  268b5756         mov dx, word ptr es:[bx + 0x56]
  005347  8946fc           mov word ptr [bp - 4], ax
  00534A  8956fe           mov word ptr [bp - 2], dx
  00534D  8bc2             mov ax, dx
  00534F  0b46fc           or ax, word ptr [bp - 4]
  005352  7412             je 0x5366
  005354  c45efc           les bx, ptr [bp - 4]
  005357  268027fe         and byte ptr es:[bx], 0xfe
  00535B  268b4710         mov ax, word ptr es:[bx + 0x10]
  00535F  268b5712         mov dx, word ptr es:[bx + 0x12]
  005363  ebe2             jmp 0x5347
  005365  90               nop
  005366  c9               leave
  005367  cb               retf

; ---- _popup_read_check  file 0x005368..0x005398  seg 0x33D:0x998  (popup.obj) ----
  005368  c8060000         enter 6, 0
  00536C  c746fe0000       mov word ptr [bp - 2], 0
  005371  ff7608           push word ptr [bp + 8]
  005374  ff7606           push word ptr [bp + 6]
  005377  8b460a           mov ax, word ptr [bp + 0xa]
  00537A  0e               push cs
  00537B  e8fafe           call 0x5278
  00537E  8946fa           mov word ptr [bp - 6], ax
  005381  8956fc           mov word ptr [bp - 4], dx
  005384  0bd0             or dx, ax
  005386  740a             je 0x5392
  005388  c45efa           les bx, ptr [bp - 6]
  00538B  268b4706         mov ax, word ptr es:[bx + 6]
  00538F  8946fe           mov word ptr [bp - 2], ax
  005392  8b46fe           mov ax, word ptr [bp - 2]
  005395  c9               leave
  005396  cb               retf
  005397  90               nop

; ---- _popup_write_check  file 0x005398..0x0053C0  seg 0x33D:0x9c8  (popup.obj) ----
  005398  c8040000         enter 4, 0
  00539C  ff7608           push word ptr [bp + 8]
  00539F  ff7606           push word ptr [bp + 6]
  0053A2  8b460a           mov ax, word ptr [bp + 0xa]
  0053A5  0e               push cs
  0053A6  e8cffe           call 0x5278
  0053A9  8946fc           mov word ptr [bp - 4], ax
  0053AC  8956fe           mov word ptr [bp - 2], dx
  0053AF  0bd0             or dx, ax
  0053B1  740a             je 0x53bd
  0053B3  8b460c           mov ax, word ptr [bp + 0xc]
  0053B6  c45efc           les bx, ptr [bp - 4]
  0053B9  26894706         mov word ptr es:[bx + 6], ax
  0053BD  c9               leave
  0053BE  cb               retf
  0053BF  90               nop

; ---- _popup_set_active_item  file 0x0053C0..0x0053DE  seg 0x33D:0x9f0  (popup.obj) ----
  0053C0  55               push bp
  0053C1  8bec             mov bp, sp
  0053C3  ff7608           push word ptr [bp + 8]
  0053C6  ff7606           push word ptr [bp + 6]
  0053C9  8b460a           mov ax, word ptr [bp + 0xa]
  0053CC  0e               push cs
  0053CD  e8a8fe           call 0x5278
  0053D0  c45e06           les bx, ptr [bp + 6]
  0053D3  2689474c         mov word ptr es:[bx + 0x4c], ax
  0053D7  2689574e         mov word ptr es:[bx + 0x4e], dx
  0053DB  c9               leave
  0053DC  cb               retf
  0053DD  90               nop

; ---- _popup_add_item  file 0x0053DE..0x0055C6  seg 0x33D:0xa0e  (popup.obj) ----
  0053DE  c8200000         enter 0x20, 0
  0053E2  56               push si
  0053E3  c45e06           les bx, ptr [bp + 6]
  0053E6  268b4754         mov ax, word ptr es:[bx + 0x54]
  0053EA  268b5756         mov dx, word ptr es:[bx + 0x56]
  0053EE  8946e0           mov word ptr [bp - 0x20], ax
  0053F1  8956e2           mov word ptr [bp - 0x1e], dx
  0053F4  2bc0             sub ax, ax
  0053F6  8946e6           mov word ptr [bp - 0x1a], ax
  0053F9  8946e4           mov word ptr [bp - 0x1c], ax
  0053FC  8bc2             mov ax, dx
  0053FE  0b46e0           or ax, word ptr [bp - 0x20]
  005401  741d             je 0x5420
  005403  8b46e0           mov ax, word ptr [bp - 0x20]
  005406  8946e4           mov word ptr [bp - 0x1c], ax
  005409  8956e6           mov word ptr [bp - 0x1a], dx
  00540C  8ec2             mov es, dx
  00540E  8bd8             mov bx, ax
  005410  268b4710         mov ax, word ptr es:[bx + 0x10]
  005414  268b5712         mov dx, word ptr es:[bx + 0x12]
  005418  8946e0           mov word ptr [bp - 0x20], ax
  00541B  8956e2           mov word ptr [bp - 0x1e], dx
  00541E  ebdc             jmp 0x53fc
  005420  8b4606           mov ax, word ptr [bp + 6]
  005423  8b5608           mov dx, word ptr [bp + 8]
  005426  058400           add ax, 0x84
  005429  52               push dx
  00542A  50               push ax
  00542B  b81800           mov ax, 0x18
  00542E  99               cdq
  00542F  9a0a01450f       lcall 0xf45, 0x10a
  005434  8946e0           mov word ptr [bp - 0x20], ax
  005437  8956e2           mov word ptr [bp - 0x1e], dx
  00543A  8b46e6           mov ax, word ptr [bp - 0x1a]
  00543D  0b46e4           or ax, word ptr [bp - 0x1c]
  005440  7422             je 0x5464
  005442  c45ee0           les bx, ptr [bp - 0x20]
  005445  8cc0             mov ax, es
  005447  c476e4           les si, ptr [bp - 0x1c]
  00544A  26895c10         mov word ptr es:[si + 0x10], bx
  00544E  26894412         mov word ptr es:[si + 0x12], ax
  005452  8ec0             mov es, ax
  005454  8b46e4           mov ax, word ptr [bp - 0x1c]
  005457  8b56e6           mov dx, word ptr [bp - 0x1a]
  00545A  26894714         mov word ptr es:[bx + 0x14], ax
  00545E  26895716         mov word ptr es:[bx + 0x16], dx
  005462  eb24             jmp 0x5488
  005464  8b46e0           mov ax, word ptr [bp - 0x20]
  005467  c45e06           les bx, ptr [bp + 6]
  00546A  26894754         mov word ptr es:[bx + 0x54], ax
  00546E  26895756         mov word ptr es:[bx + 0x56], dx
  005472  2689474c         mov word ptr es:[bx + 0x4c], ax
  005476  2689574e         mov word ptr es:[bx + 0x4e], dx
  00547A  8ec2             mov es, dx
  00547C  8bd8             mov bx, ax
  00547E  2bc0             sub ax, ax
  005480  26894716         mov word ptr es:[bx + 0x16], ax
  005484  26894714         mov word ptr es:[bx + 0x14], ax
  005488  8b46e0           mov ax, word ptr [bp - 0x20]
  00548B  8b56e2           mov dx, word ptr [bp - 0x1e]
  00548E  c45e06           les bx, ptr [bp + 6]
  005491  26894770         mov word ptr es:[bx + 0x70], ax
  005495  26895772         mov word ptr es:[bx + 0x72], dx
  005499  26f6470a04       test byte ptr es:[bx + 0xa], 4
  00549E  7416             je 0x54b6
  0054A0  c746e80300       mov word ptr [bp - 0x18], 3
  0054A5  689105           push 0x591
  0054A8  8d46ea           lea ax, [bp - 0x16]
  0054AB  50               push ax
  0054AC  9a26068813       lcall 0x1388, 0x626
  0054B1  83c404           add sp, 4
  0054B4  eb09             jmp 0x54bf
  0054B6  c746e80000       mov word ptr [bp - 0x18], 0
  0054BB  c646ea00         mov byte ptr [bp - 0x16], 0
  0054BF  c45ee0           les bx, ptr [bp - 0x20]
  0054C2  2bc0             sub ax, ax
  0054C4  26894712         mov word ptr es:[bx + 0x12], ax
  0054C8  26894710         mov word ptr es:[bx + 0x10], ax
  0054CC  268907           mov word ptr es:[bx], ax
  0054CF  26894706         mov word ptr es:[bx + 6], ax
  0054D3  8b4606           mov ax, word ptr [bp + 6]
  0054D6  8b5608           mov dx, word ptr [bp + 8]
  0054D9  058400           add ax, 0x84
  0054DC  52               push dx
  0054DD  50               push ax
  0054DE  ff760c           push word ptr [bp + 0xc]
  0054E1  ff760a           push word ptr [bp + 0xa]
  0054E4  9ad40d8813       lcall 0x1388, 0xdd4
  0054E9  83c404           add sp, 4
  0054EC  0346e8           add ax, word ptr [bp - 0x18]
  0054EF  40               inc ax
  0054F0  2bd2             sub dx, dx
  0054F2  9a0a01450f       lcall 0xf45, 0x10a
  0054F7  c45ee0           les bx, ptr [bp - 0x20]
  0054FA  26894708         mov word ptr es:[bx + 8], ax
  0054FE  2689570a         mov word ptr es:[bx + 0xa], dx
  005502  8d46ea           lea ax, [bp - 0x16]
  005505  16               push ss
  005506  50               push ax
  005507  26ff770a         push word ptr es:[bx + 0xa]
  00550B  26ff7708         push word ptr es:[bx + 8]
  00550F  9aec0d8813       lcall 0x1388, 0xdec
  005514  83c408           add sp, 8
  005517  ff760c           push word ptr [bp + 0xc]
  00551A  ff760a           push word ptr [bp + 0xa]
  00551D  c45ee0           les bx, ptr [bp - 0x20]
  005520  26ff770a         push word ptr es:[bx + 0xa]
  005524  26ff7708         push word ptr es:[bx + 8]
  005528  9a220e8813       lcall 0x1388, 0xe22
  00552D  83c408           add sp, 8
  005530  c45e0a           les bx, ptr [bp + 0xa]
  005533  26803f00         cmp byte ptr es:[bx], 0
  005537  7507             jne 0x5540
  005539  c45ee0           les bx, ptr [bp - 0x20]
  00553C  26800f01         or byte ptr es:[bx], 1
  005540  8b460e           mov ax, word ptr [bp + 0xe]
  005543  c45ee0           les bx, ptr [bp - 0x20]
  005546  26894704         mov word ptr es:[bx + 4], ax
  00554A  ff760c           push word ptr [bp + 0xc]
  00554D  ff760a           push word ptr [bp + 0xa]
  005550  e8cdfa           call 0x5020
  005553  c45ee0           les bx, ptr [bp - 0x20]
  005556  26894702         mov word ptr es:[bx + 2], ax
  00555A  8b4606           mov ax, word ptr [bp + 6]
  00555D  8b5608           mov dx, word ptr [bp + 8]
  005560  057400           add ax, 0x74
  005563  52               push dx
  005564  50               push ax
  005565  26ff770a         push word ptr es:[bx + 0xa]
  005569  26ff7708         push word ptr es:[bx + 8]
  00556D  e8f4f8           call 0x4e64
  005570  8946fe           mov word ptr [bp - 2], ax
  005573  c45e06           les bx, ptr [bp + 6]
  005576  268b4748         mov ax, word ptr es:[bx + 0x48]
  00557A  d1e0             shl ax, 1
  00557C  26034722         add ax, word ptr es:[bx + 0x22]
  005580  0146fe           add word ptr [bp - 2], ax
  005583  6a7c             push 0x7c
  005585  c476e0           les si, ptr [bp - 0x20]
  005588  26ff740a         push word ptr es:[si + 0xa]
  00558C  26ff7408         push word ptr es:[si + 8]
  005590  9aa80c8813       lcall 0x1388, 0xca8
  005595  83c406           add sp, 6
  005598  0bd0             or dx, ax
  00559A  740a             je 0x55a6
  00559C  c45e06           les bx, ptr [bp + 6]
  00559F  268b4722         mov ax, word ptr es:[bx + 0x22]
  0055A3  0146fe           add word ptr [bp - 2], ax
  0055A6  c45e06           les bx, ptr [bp + 6]
  0055A9  268b4720         mov ax, word ptr es:[bx + 0x20]
  0055AD  3b46fe           cmp ax, word ptr [bp - 2]
  0055B0  7d03             jge 0x55b5
  0055B2  8b46fe           mov ax, word ptr [bp - 2]
  0055B5  26894720         mov word ptr es:[bx + 0x20], ax
  0055B9  26ff4702         inc word ptr es:[bx + 2]
  0055BD  8b46e0           mov ax, word ptr [bp - 0x20]
  0055C0  8b56e2           mov dx, word ptr [bp - 0x1e]
  0055C3  5e               pop si
  0055C4  c9               leave
  0055C5  cb               retf

; ---- _popup_add_check  file 0x0055C6..0x005600  seg 0x33D:0xbf6  (popup.obj) ----
  0055C6  c8040000         enter 4, 0
  0055CA  c45e06           les bx, ptr [bp + 6]
  0055CD  26804f0a05       or byte ptr es:[bx + 0xa], 5
  0055D2  ff760e           push word ptr [bp + 0xe]
  0055D5  ff760c           push word ptr [bp + 0xc]
  0055D8  ff760a           push word ptr [bp + 0xa]
  0055DB  06               push es
  0055DC  53               push bx
  0055DD  0e               push cs
  0055DE  e8fdfd           call 0x53de
  0055E1  83c40a           add sp, 0xa
  0055E4  8946fc           mov word ptr [bp - 4], ax
  0055E7  8956fe           mov word ptr [bp - 2], dx
  0055EA  0bd0             or dx, ax
  0055EC  740a             je 0x55f8
  0055EE  8b4610           mov ax, word ptr [bp + 0x10]
  0055F1  c45efc           les bx, ptr [bp - 4]
  0055F4  26894706         mov word ptr es:[bx + 6], ax
  0055F8  8b46fc           mov ax, word ptr [bp - 4]
  0055FB  8b56fe           mov dx, word ptr [bp - 2]
  0055FE  c9               leave
  0055FF  cb               retf

; ---- _popup_set_width  file 0x005600..0x005610  seg 0x33D:0xc30  (popup.obj) ----
  005600  55               push bp
  005601  8bec             mov bp, sp
  005603  8b460a           mov ax, word ptr [bp + 0xa]
  005606  c45e06           les bx, ptr [bp + 6]
  005609  26894728         mov word ptr es:[bx + 0x28], ax
  00560D  c9               leave
  00560E  cb               retf
  00560F  90               nop

; ---- _popup_add_string  file 0x005610..0x005722  seg 0x33D:0xc40  (popup.obj) ----
  005610  c8080000         enter 8, 0
  005614  56               push si
  005615  c45e06           les bx, ptr [bp + 6]
  005618  268b4758         mov ax, word ptr es:[bx + 0x58]
  00561C  268b575a         mov dx, word ptr es:[bx + 0x5a]
  005620  8946f8           mov word ptr [bp - 8], ax
  005623  8956fa           mov word ptr [bp - 6], dx
  005626  2bc0             sub ax, ax
  005628  8946fe           mov word ptr [bp - 2], ax
  00562B  8946fc           mov word ptr [bp - 4], ax
  00562E  8bc2             mov ax, dx
  005630  0b46f8           or ax, word ptr [bp - 8]
  005633  741d             je 0x5652
  005635  8b46f8           mov ax, word ptr [bp - 8]
  005638  8946fc           mov word ptr [bp - 4], ax
  00563B  8956fe           mov word ptr [bp - 2], dx
  00563E  8ec2             mov es, dx
  005640  8bd8             mov bx, ax
  005642  268b4706         mov ax, word ptr es:[bx + 6]
  005646  268b5708         mov dx, word ptr es:[bx + 8]
  00564A  8946f8           mov word ptr [bp - 8], ax
  00564D  8956fa           mov word ptr [bp - 6], dx
  005650  ebdc             jmp 0x562e
  005652  8b4606           mov ax, word ptr [bp + 6]
  005655  8b5608           mov dx, word ptr [bp + 8]
  005658  058400           add ax, 0x84
  00565B  52               push dx
  00565C  50               push ax
  00565D  b80a00           mov ax, 0xa
  005660  99               cdq
  005661  9a0a01450f       lcall 0xf45, 0x10a
  005666  8946f8           mov word ptr [bp - 8], ax
  005669  8956fa           mov word ptr [bp - 6], dx
  00566C  8b46fe           mov ax, word ptr [bp - 2]
  00566F  0b46fc           or ax, word ptr [bp - 4]
  005672  7410             je 0x5684
  005674  8b46f8           mov ax, word ptr [bp - 8]
  005677  c45efc           les bx, ptr [bp - 4]
  00567A  26894706         mov word ptr es:[bx + 6], ax
  00567E  26895708         mov word ptr es:[bx + 8], dx
  005682  eb0e             jmp 0x5692
  005684  8b46f8           mov ax, word ptr [bp - 8]
  005687  c45e06           les bx, ptr [bp + 6]
  00568A  26894758         mov word ptr es:[bx + 0x58], ax
  00568E  2689575a         mov word ptr es:[bx + 0x5a], dx
  005692  c45ef8           les bx, ptr [bp - 8]
  005695  2bc0             sub ax, ax
  005697  26894708         mov word ptr es:[bx + 8], ax
  00569B  26894706         mov word ptr es:[bx + 6], ax
  00569F  268907           mov word ptr es:[bx], ax
  0056A2  c4760a           les si, ptr [bp + 0xa]
  0056A5  26803c5e         cmp byte ptr es:[si], 0x5e
  0056A9  7528             jne 0x56d3
  0056AB  ff460a           inc word ptr [bp + 0xa]
  0056AE  8b5e0a           mov bx, word ptr [bp + 0xa]
  0056B1  26803f5e         cmp byte ptr es:[bx], 0x5e
  0056B5  7515             jne 0x56cc
  0056B7  c476f8           les si, ptr [bp - 8]
  0056BA  26c7040100       mov word ptr es:[si], 1
  0056BF  8b460a           mov ax, word ptr [bp + 0xa]
  0056C2  8b560c           mov dx, word ptr [bp + 0xc]
  0056C5  40               inc ax
  0056C6  89460a           mov word ptr [bp + 0xa], ax
  0056C9  eb08             jmp 0x56d3
  0056CB  90               nop
  0056CC  c45ef8           les bx, ptr [bp - 8]
  0056CF  26800f02         or byte ptr es:[bx], 2
  0056D3  8b4606           mov ax, word ptr [bp + 6]
  0056D6  8b5608           mov dx, word ptr [bp + 8]
  0056D9  058400           add ax, 0x84
  0056DC  52               push dx
  0056DD  50               push ax
  0056DE  ff760c           push word ptr [bp + 0xc]
  0056E1  ff760a           push word ptr [bp + 0xa]
  0056E4  9ad40d8813       lcall 0x1388, 0xdd4
  0056E9  83c404           add sp, 4
  0056EC  40               inc ax
  0056ED  2bd2             sub dx, dx
  0056EF  9a0a01450f       lcall 0xf45, 0x10a
  0056F4  c45ef8           les bx, ptr [bp - 8]
  0056F7  26894702         mov word ptr es:[bx + 2], ax
  0056FB  26895704         mov word ptr es:[bx + 4], dx
  0056FF  ff760c           push word ptr [bp + 0xc]
  005702  ff760a           push word ptr [bp + 0xa]
  005705  52               push dx
  005706  26ff7702         push word ptr es:[bx + 2]
  00570A  9aec0d8813       lcall 0x1388, 0xdec
  00570F  83c408           add sp, 8
  005712  c45e06           les bx, ptr [bp + 6]
  005715  26ff4704         inc word ptr es:[bx + 4]
  005719  8b46f8           mov ax, word ptr [bp - 8]
  00571C  8b56fa           mov dx, word ptr [bp - 6]
  00571F  5e               pop si
  005720  c9               leave
  005721  cb               retf

; ---- _popup_add_entry  file 0x005722..0x00591A  seg 0x33D:0xd52  (popup.obj) ----
  005722  c80e0000         enter 0xe, 0
  005726  57               push di
  005727  56               push si
  005728  c45e06           les bx, ptr [bp + 6]
  00572B  268b4760         mov ax, word ptr es:[bx + 0x60]
  00572F  268b5762         mov dx, word ptr es:[bx + 0x62]
  005733  8946fa           mov word ptr [bp - 6], ax
  005736  8956fc           mov word ptr [bp - 4], dx
  005739  2bc0             sub ax, ax
  00573B  8946f8           mov word ptr [bp - 8], ax
  00573E  8946f6           mov word ptr [bp - 0xa], ax
  005741  8bc2             mov ax, dx
  005743  0b46fa           or ax, word ptr [bp - 6]
  005746  741e             je 0x5766
  005748  8b46fa           mov ax, word ptr [bp - 6]
  00574B  8946f6           mov word ptr [bp - 0xa], ax
  00574E  8956f8           mov word ptr [bp - 8], dx
  005751  8ec2             mov es, dx
  005753  8bd8             mov bx, ax
  005755  268b4710         mov ax, word ptr es:[bx + 0x10]
  005759  268b5712         mov dx, word ptr es:[bx + 0x12]
  00575D  8946fa           mov word ptr [bp - 6], ax
  005760  8956fc           mov word ptr [bp - 4], dx
  005763  ebdc             jmp 0x5741
  005765  90               nop
  005766  8b4606           mov ax, word ptr [bp + 6]
  005769  8b5608           mov dx, word ptr [bp + 8]
  00576C  058400           add ax, 0x84
  00576F  52               push dx
  005770  50               push ax
  005771  b81400           mov ax, 0x14
  005774  99               cdq
  005775  9a0a01450f       lcall 0xf45, 0x10a
  00577A  8946fa           mov word ptr [bp - 6], ax
  00577D  8956fc           mov word ptr [bp - 4], dx
  005780  8b46f8           mov ax, word ptr [bp - 8]
  005783  0b46f6           or ax, word ptr [bp - 0xa]
  005786  7410             je 0x5798
  005788  8b46fa           mov ax, word ptr [bp - 6]
  00578B  c45ef6           les bx, ptr [bp - 0xa]
  00578E  26894710         mov word ptr es:[bx + 0x10], ax
  005792  26895712         mov word ptr es:[bx + 0x12], dx
  005796  eb0e             jmp 0x57a6
  005798  8b46fa           mov ax, word ptr [bp - 6]
  00579B  c45e06           les bx, ptr [bp + 6]
  00579E  26894760         mov word ptr es:[bx + 0x60], ax
  0057A2  26895762         mov word ptr es:[bx + 0x62], dx
  0057A6  c45efa           les bx, ptr [bp - 6]
  0057A9  2bc0             sub ax, ax
  0057AB  26894712         mov word ptr es:[bx + 0x12], ax
  0057AF  26894710         mov word ptr es:[bx + 0x10], ax
  0057B3  268907           mov word ptr es:[bx], ax
  0057B6  8b4606           mov ax, word ptr [bp + 6]
  0057B9  8b5608           mov dx, word ptr [bp + 8]
  0057BC  058400           add ax, 0x84
  0057BF  52               push dx
  0057C0  50               push ax
  0057C1  ff760c           push word ptr [bp + 0xc]
  0057C4  ff760a           push word ptr [bp + 0xa]
  0057C7  8bf0             mov si, ax
  0057C9  8bfa             mov di, dx
  0057CB  9ad40d8813       lcall 0x1388, 0xdd4
  0057D0  83c404           add sp, 4
  0057D3  40               inc ax
  0057D4  40               inc ax
  0057D5  2bd2             sub dx, dx
  0057D7  9a0a01450f       lcall 0xf45, 0x10a
  0057DC  c45efa           les bx, ptr [bp - 6]
  0057DF  26894708         mov word ptr es:[bx + 8], ax
  0057E3  2689570a         mov word ptr es:[bx + 0xa], dx
  0057E7  ff760c           push word ptr [bp + 0xc]
  0057EA  ff760a           push word ptr [bp + 0xa]
  0057ED  52               push dx
  0057EE  26ff7708         push word ptr es:[bx + 8]
  0057F2  9aec0d8813       lcall 0x1388, 0xdec
  0057F7  83c408           add sp, 8
  0057FA  1e               push ds
  0057FB  689505           push 0x595
  0057FE  c45efa           les bx, ptr [bp - 6]
  005801  26ff770a         push word ptr es:[bx + 0xa]
  005805  26ff7708         push word ptr es:[bx + 8]
  005809  9a220e8813       lcall 0x1388, 0xe22
  00580E  83c408           add sp, 8
  005811  8b4606           mov ax, word ptr [bp + 6]
  005814  8b5608           mov dx, word ptr [bp + 8]
  005817  057400           add ax, 0x74
  00581A  52               push dx
  00581B  50               push ax
  00581C  c45efa           les bx, ptr [bp - 6]
  00581F  26ff770a         push word ptr es:[bx + 0xa]
  005823  26ff7708         push word ptr es:[bx + 8]
  005827  8946f2           mov word ptr [bp - 0xe], ax
  00582A  8956f4           mov word ptr [bp - 0xc], dx
  00582D  e834f6           call 0x4e64
  005830  c45efa           les bx, ptr [bp - 6]
  005833  26894702         mov word ptr es:[bx + 2], ax
  005837  8b4612           mov ax, word ptr [bp + 0x12]
  00583A  26894706         mov word ptr es:[bx + 6], ax
  00583E  57               push di
  00583F  56               push si
  005840  40               inc ax
  005841  99               cdq
  005842  9a0a01450f       lcall 0xf45, 0x10a
  005847  c45efa           les bx, ptr [bp - 6]
  00584A  2689470c         mov word ptr es:[bx + 0xc], ax
  00584E  2689570e         mov word ptr es:[bx + 0xe], dx
  005852  ff76f4           push word ptr [bp - 0xc]
  005855  ff76f2           push word ptr [bp - 0xe]
  005858  1e               push ds
  005859  689705           push 0x597
  00585C  e805f6           call 0x4e64
  00585F  f76e12           imul word ptr [bp + 0x12]
  005862  c45efa           les bx, ptr [bp - 6]
  005865  26894704         mov word ptr es:[bx + 4], ax
  005869  268b4702         mov ax, word ptr es:[bx + 2]
  00586D  26034704         add ax, word ptr es:[bx + 4]
  005871  050a00           add ax, 0xa
  005874  c47606           les si, ptr [bp + 6]
  005877  263b4434         cmp ax, word ptr es:[si + 0x34]
  00587B  7d04             jge 0x5881
  00587D  268b4434         mov ax, word ptr es:[si + 0x34]
  005881  26894434         mov word ptr es:[si + 0x34], ax
  005885  8b4610           mov ax, word ptr [bp + 0x10]
  005888  0b460e           or ax, word ptr [bp + 0xe]
  00588B  750d             jne 0x589a
  00588D  c45efa           les bx, ptr [bp - 6]
  005890  26c45f0c         les bx, ptr es:[bx + 0xc]
  005894  26c60700         mov byte ptr es:[bx], 0
  005898  eb48             jmp 0x58e2
  00589A  ff7612           push word ptr [bp + 0x12]
  00589D  ff7610           push word ptr [bp + 0x10]
  0058A0  ff760e           push word ptr [bp + 0xe]
  0058A3  c45efa           les bx, ptr [bp - 6]
  0058A6  26ff770e         push word ptr es:[bx + 0xe]
  0058AA  26ff770c         push word ptr es:[bx + 0xc]
  0058AE  9a580d8813       lcall 0x1388, 0xd58
  0058B3  83c40a           add sp, 0xa
  0058B6  c45efa           les bx, ptr [bp - 6]
  0058B9  26c45f0c         les bx, ptr es:[bx + 0xc]
  0058BD  8b7612           mov si, word ptr [bp + 0x12]
  0058C0  26c60000         mov byte ptr es:[bx + si], 0
  0058C4  c45efa           les bx, ptr [bp - 6]
  0058C7  26ff770e         push word ptr es:[bx + 0xe]
  0058CB  26ff770c         push word ptr es:[bx + 0xc]
  0058CF  9ad40d8813       lcall 0x1388, 0xdd4
  0058D4  83c404           add sp, 4
  0058D7  0bc0             or ax, ax
  0058D9  7407             je 0x58e2
  0058DB  c45efa           les bx, ptr [bp - 6]
  0058DE  26800f80         or byte ptr es:[bx], 0x80
  0058E2  c45e06           les bx, ptr [bp + 6]
  0058E5  26ff4708         inc word ptr es:[bx + 8]
  0058E9  8b46fa           mov ax, word ptr [bp - 6]
  0058EC  8b56fc           mov dx, word ptr [bp - 4]
  0058EF  5e               pop si
  0058F0  5f               pop di
  0058F1  c9               leave
  0058F2  cb               retf
  0058F3  90               nop
  0058F4  c8020000         enter 2, 0
  0058F8  c45e04           les bx, ptr [bp + 4]
  0058FB  268a07           mov al, byte ptr es:[bx]
  0058FE  2ae4             sub ah, ah
  005900  8946fe           mov word ptr [bp - 2], ax
  005903  3d0600           cmp ax, 6
  005906  750c             jne 0x5914
  005908  833e8a0500       cmp word ptr [0x58a], 0
  00590D  7505             jne 0x5914
  00590F  c746fe0500       mov word ptr [bp - 2], 5
  005914  8b46fe           mov ax, word ptr [bp - 2]
  005917  c9               leave
  005918  c3               ret
  005919  90               nop

; ---- _popup_add_sprite  file 0x00591A..0x005B08  seg 0x33D:0xf4a  (popup.obj) ----
  00591A  c8120000         enter 0x12, 0
  00591E  56               push si
  00591F  c45e06           les bx, ptr [bp + 6]
  005922  268b475c         mov ax, word ptr es:[bx + 0x5c]
  005926  268b575e         mov dx, word ptr es:[bx + 0x5e]
  00592A  8946f6           mov word ptr [bp - 0xa], ax
  00592D  8956f8           mov word ptr [bp - 8], dx
  005930  2bc0             sub ax, ax
  005932  8946fc           mov word ptr [bp - 4], ax
  005935  8946fa           mov word ptr [bp - 6], ax
  005938  8bc2             mov ax, dx
  00593A  0b46f6           or ax, word ptr [bp - 0xa]
  00593D  741d             je 0x595c
  00593F  8b46f6           mov ax, word ptr [bp - 0xa]
  005942  8946fa           mov word ptr [bp - 6], ax
  005945  8956fc           mov word ptr [bp - 4], dx
  005948  8ec2             mov es, dx
  00594A  8bd8             mov bx, ax
  00594C  268b4710         mov ax, word ptr es:[bx + 0x10]
  005950  268b5712         mov dx, word ptr es:[bx + 0x12]
  005954  8946f6           mov word ptr [bp - 0xa], ax
  005957  8956f8           mov word ptr [bp - 8], dx
  00595A  ebdc             jmp 0x5938
  00595C  8b4606           mov ax, word ptr [bp + 6]
  00595F  8b5608           mov dx, word ptr [bp + 8]
  005962  058400           add ax, 0x84
  005965  52               push dx
  005966  50               push ax
  005967  b81400           mov ax, 0x14
  00596A  99               cdq
  00596B  9a0a01450f       lcall 0xf45, 0x10a
  005970  8946f6           mov word ptr [bp - 0xa], ax
  005973  8956f8           mov word ptr [bp - 8], dx
  005976  8b46fc           mov ax, word ptr [bp - 4]
  005979  0b46fa           or ax, word ptr [bp - 6]
  00597C  741e             je 0x599c
  00597E  c45efa           les bx, ptr [bp - 6]
  005981  268b4702         mov ax, word ptr es:[bx + 2]
  005985  c476f6           les si, ptr [bp - 0xa]
  005988  8cc1             mov cx, es
  00598A  8e46fc           mov es, word ptr [bp - 4]
  00598D  26897710         mov word ptr es:[bx + 0x10], si
  005991  26894f12         mov word ptr es:[bx + 0x12], cx
  005995  8ec1             mov es, cx
  005997  268904           mov word ptr es:[si], ax
  00599A  eb25             jmp 0x59c1
  00599C  8b46f6           mov ax, word ptr [bp - 0xa]
  00599F  c45e06           les bx, ptr [bp + 6]
  0059A2  2689475c         mov word ptr es:[bx + 0x5c], ax
  0059A6  2689575e         mov word ptr es:[bx + 0x5e], dx
  0059AA  26894750         mov word ptr es:[bx + 0x50], ax
  0059AE  26895752         mov word ptr es:[bx + 0x52], dx
  0059B2  268b4f46         mov cx, word ptr es:[bx + 0x46]
  0059B6  26034f4a         add cx, word ptr es:[bx + 0x4a]
  0059BA  8ec2             mov es, dx
  0059BC  8bd8             mov bx, ax
  0059BE  26890f           mov word ptr es:[bx], cx
  0059C1  c45ef6           les bx, ptr [bp - 0xa]
  0059C4  2bc0             sub ax, ax
  0059C6  26894712         mov word ptr es:[bx + 0x12], ax
  0059CA  26894710         mov word ptr es:[bx + 0x10], ax
  0059CE  8b460a           mov ax, word ptr [bp + 0xa]
  0059D1  8b560c           mov dx, word ptr [bp + 0xc]
  0059D4  2689470c         mov word ptr es:[bx + 0xc], ax
  0059D8  2689570e         mov word ptr es:[bx + 0xe], dx
  0059DC  8b460e           mov ax, word ptr [bp + 0xe]
  0059DF  26894704         mov word ptr es:[bx + 4], ax
  0059E3  8b4614           mov ax, word ptr [bp + 0x14]
  0059E6  26894706         mov word ptr es:[bx + 6], ax
  0059EA  8b4612           mov ax, word ptr [bp + 0x12]
  0059ED  0b4610           or ax, word ptr [bp + 0x10]
  0059F0  7503             jne 0x59f5
  0059F2  e98700           jmp 0x5a7c
  0059F5  c45e06           les bx, ptr [bp + 6]
  0059F8  268b4756         mov ax, word ptr es:[bx + 0x56]
  0059FC  260b4754         or ax, word ptr es:[bx + 0x54]
  005A00  7506             jne 0x5a08
  005A02  26c747280000     mov word ptr es:[bx + 0x28], 0
  005A08  8b4606           mov ax, word ptr [bp + 6]
  005A0B  8b5608           mov dx, word ptr [bp + 8]
  005A0E  058400           add ax, 0x84
  005A11  52               push dx
  005A12  50               push ax
  005A13  ff7612           push word ptr [bp + 0x12]
  005A16  ff7610           push word ptr [bp + 0x10]
  005A19  9ad40d8813       lcall 0x1388, 0xdd4
  005A1E  83c404           add sp, 4
  005A21  40               inc ax
  005A22  2bd2             sub dx, dx
  005A24  9a0a01450f       lcall 0xf45, 0x10a
  005A29  c45ef6           les bx, ptr [bp - 0xa]
  005A2C  26894708         mov word ptr es:[bx + 8], ax
  005A30  2689570a         mov word ptr es:[bx + 0xa], dx
  005A34  ff7612           push word ptr [bp + 0x12]
  005A37  ff7610           push word ptr [bp + 0x10]
  005A3A  52               push dx
  005A3B  26ff7708         push word ptr es:[bx + 8]
  005A3F  9aec0d8813       lcall 0x1388, 0xdec
  005A44  83c408           add sp, 8
  005A47  8b4606           mov ax, word ptr [bp + 6]
  005A4A  8b5608           mov dx, word ptr [bp + 8]
  005A4D  057400           add ax, 0x74
  005A50  52               push dx
  005A51  50               push ax
  005A52  ff7612           push word ptr [bp + 0x12]
  005A55  ff7610           push word ptr [bp + 0x10]
  005A58  e809f4           call 0x4e64
  005A5B  c45e06           les bx, ptr [bp + 6]
  005A5E  26034746         add ax, word ptr es:[bx + 0x46]
  005A62  26034732         add ax, word ptr es:[bx + 0x32]
  005A66  8946ee           mov word ptr [bp - 0x12], ax
  005A69  26ffb78200       push word ptr es:[bx + 0x82]
  005A6E  26ffb78000       push word ptr es:[bx + 0x80]
  005A73  e87efe           call 0x58f4
  005A76  83c404           add sp, 4
  005A79  eb11             jmp 0x5a8c
  005A7B  90               nop
  005A7C  c45ef6           les bx, ptr [bp - 0xa]
  005A7F  2bc0             sub ax, ax
  005A81  2689470a         mov word ptr es:[bx + 0xa], ax
  005A85  26894708         mov word ptr es:[bx + 8], ax
  005A89  8946ee           mov word ptr [bp - 0x12], ax
  005A8C  8946f4           mov word ptr [bp - 0xc], ax
  005A8F  c45e06           les bx, ptr [bp + 6]
  005A92  26f6470a02       test byte ptr es:[bx + 0xa], 2
  005A97  7409             je 0x5aa2
  005A99  b81000           mov ax, 0x10
  005A9C  8946fe           mov word ptr [bp - 2], ax
  005A9F  eb1e             jmp 0x5abf
  005AA1  90               nop
  005AA2  8b5e0e           mov bx, word ptr [bp + 0xe]
  005AA5  8bc3             mov ax, bx
  005AA7  d1e3             shl bx, 1
  005AA9  03d8             add bx, ax
  005AAB  c1e302           shl bx, 2
  005AAE  035e0a           add bx, word ptr [bp + 0xa]
  005AB1  8e460c           mov es, word ptr [bp + 0xc]
  005AB4  268b473e         mov ax, word ptr es:[bx + 0x3e]
  005AB8  8946fe           mov word ptr [bp - 2], ax
  005ABB  268b4740         mov ax, word ptr es:[bx + 0x40]
  005ABF  3b46f4           cmp ax, word ptr [bp - 0xc]
  005AC2  7d03             jge 0x5ac7
  005AC4  8b46f4           mov ax, word ptr [bp - 0xc]
  005AC7  c45e06           les bx, ptr [bp + 6]
  005ACA  26034746         add ax, word ptr es:[bx + 0x46]
  005ACE  c476f6           les si, ptr [bp - 0xa]
  005AD1  260304           add ax, word ptr es:[si]
  005AD4  26894402         mov word ptr es:[si + 2], ax
  005AD8  c45e06           les bx, ptr [bp + 6]
  005ADB  268b472e         mov ax, word ptr es:[bx + 0x2e]
  005ADF  3b46fe           cmp ax, word ptr [bp - 2]
  005AE2  7d03             jge 0x5ae7
  005AE4  8b46fe           mov ax, word ptr [bp - 2]
  005AE7  2689472e         mov word ptr es:[bx + 0x2e], ax
  005AEB  268b4730         mov ax, word ptr es:[bx + 0x30]
  005AEF  3b46ee           cmp ax, word ptr [bp - 0x12]
  005AF2  7d03             jge 0x5af7
  005AF4  8b46ee           mov ax, word ptr [bp - 0x12]
  005AF7  26894730         mov word ptr es:[bx + 0x30], ax
  005AFB  26ff4706         inc word ptr es:[bx + 6]
  005AFF  8b46f6           mov ax, word ptr [bp - 0xa]
  005B02  8b56f8           mov dx, word ptr [bp - 8]
  005B05  5e               pop si
  005B06  c9               leave
  005B07  cb               retf

; ---- _popup_add_cursor  file 0x005B08..0x006456  seg 0x33D:0x1138  (popup.obj) ----
  005B08  55               push bp
  005B09  8bec             mov bp, sp
  005B0B  8b4606           mov ax, word ptr [bp + 6]
  005B0E  8b5608           mov dx, word ptr [bp + 8]
  005B11  058400           add ax, 0x84
  005B14  52               push dx
  005B15  50               push ax
  005B16  b81400           mov ax, 0x14
  005B19  99               cdq
  005B1A  9a0a01450f       lcall 0xf45, 0x10a
  005B1F  c45e06           les bx, ptr [bp + 6]
  005B22  26894764         mov word ptr es:[bx + 0x64], ax
  005B26  26895766         mov word ptr es:[bx + 0x66], dx
  005B2A  8b460a           mov ax, word ptr [bp + 0xa]
  005B2D  8b560c           mov dx, word ptr [bp + 0xc]
  005B30  26c45f64         les bx, ptr es:[bx + 0x64]
  005B34  2689470c         mov word ptr es:[bx + 0xc], ax
  005B38  2689570e         mov word ptr es:[bx + 0xe], dx
  005B3C  8b460e           mov ax, word ptr [bp + 0xe]
  005B3F  26894704         mov word ptr es:[bx + 4], ax
  005B43  8bc3             mov ax, bx
  005B45  8cc2             mov dx, es
  005B47  c9               leave
  005B48  cb               retf
  005B49  90               nop
  005B4A  c8020000         enter 2, 0
  005B4E  8b4e08           mov cx, word ptr [bp + 8]
  005B51  8b5e0a           mov bx, word ptr [bp + 0xa]
  005B54  83c174           add cx, 0x74
  005B57  53               push bx
  005B58  51               push cx
  005B59  ff7606           push word ptr [bp + 6]
  005B5C  ff7604           push word ptr [bp + 4]
  005B5F  c45e08           les bx, ptr [bp + 8]
  005B62  268b4f48         mov cx, word ptr es:[bx + 0x48]
  005B66  26034f2a         add cx, word ptr es:[bx + 0x2a]
  005B6A  03c1             add ax, cx
  005B6C  2bdb             sub bx, bx
  005B6E  e8a5f3           call 0x4f16
  005B71  c9               leave
  005B72  c20800           ret 8
  005B75  90               nop
  005B76  c86a0100         enter 0x16a, 0
  005B7A  50               push ax
  005B7B  57               push di
  005B7C  56               push si
  005B7D  c45e04           les bx, ptr [bp + 4]
  005B80  268b4758         mov ax, word ptr es:[bx + 0x58]
  005B84  268b575a         mov dx, word ptr es:[bx + 0x5a]
  005B88  8986f4fe         mov word ptr [bp - 0x10c], ax
  005B8C  8996f6fe         mov word ptr [bp - 0x10a], dx
  005B90  268b4748         mov ax, word ptr es:[bx + 0x48]
  005B94  d1e0             shl ax, 1
  005B96  262b4728         sub ax, word ptr es:[bx + 0x28]
  005B9A  f7d8             neg ax
  005B9C  8986f8fe         mov word ptr [bp - 0x108], ax
  005BA0  268b472c         mov ax, word ptr es:[bx + 0x2c]
  005BA4  8986f2fe         mov word ptr [bp - 0x10e], ax
  005BA8  c686fafe00       mov byte ptr [bp - 0x106], 0
  005BAD  2bc0             sub ax, ax
  005BAF  89869afe         mov word ptr [bp - 0x166], ax
  005BB3  8946fa           mov word ptr [bp - 6], ax
  005BB6  8bc2             mov ax, dx
  005BB8  0b86f4fe         or ax, word ptr [bp - 0x10c]
  005BBC  7503             jne 0x5bc1
  005BBE  e98102           jmp 0x5e42
  005BC1  c49ef4fe         les bx, ptr [bp - 0x10c]
  005BC5  268b4702         mov ax, word ptr es:[bx + 2]
  005BC9  268b5704         mov dx, word ptr es:[bx + 4]
  005BCD  8946fc           mov word ptr [bp - 4], ax
  005BD0  8956fe           mov word ptr [bp - 2], dx
  005BD3  26f60703         test byte ptr es:[bx], 3
  005BD7  7503             jne 0x5bdc
  005BD9  e93a02           jmp 0x5e16
  005BDC  80befafe00       cmp byte ptr [bp - 0x106], 0
  005BE1  7456             je 0x5c39
  005BE3  83be94fe00       cmp word ptr [bp - 0x16c], 0
  005BE8  7415             je 0x5bff
  005BEA  ff7606           push word ptr [bp + 6]
  005BED  ff7604           push word ptr [bp + 4]
  005BF0  8d86fafe         lea ax, [bp - 0x106]
  005BF4  16               push ss
  005BF5  50               push ax
  005BF6  2bc0             sub ax, ax
  005BF8  8b96f2fe         mov dx, word ptr [bp - 0x10e]
  005BFC  e84bff           call 0x5b4a
  005BFF  c45e04           les bx, ptr [bp + 4]
  005C02  26ffb78200       push word ptr es:[bx + 0x82]
  005C07  26ffb78000       push word ptr es:[bx + 0x80]
  005C0C  e8e5fc           call 0x58f4
  005C0F  83c404           add sp, 4
  005C12  40               inc ax
  005C13  01869afe         add word ptr [bp - 0x166], ax
  005C17  c45e04           les bx, ptr [bp + 4]
  005C1A  26ffb78200       push word ptr es:[bx + 0x82]
  005C1F  26ffb78000       push word ptr es:[bx + 0x80]
  005C24  e8cdfc           call 0x58f4
  005C27  83c404           add sp, 4
  005C2A  40               inc ax
  005C2B  0186f2fe         add word ptr [bp - 0x10e], ax
  005C2F  c686fafe00       mov byte ptr [bp - 0x106], 0
  005C34  c746fa0000       mov word ptr [bp - 6], 0
  005C39  83be94fe00       cmp word ptr [bp - 0x16c], 0
  005C3E  7451             je 0x5c91
  005C40  c49ef4fe         les bx, ptr [bp - 0x10c]
  005C44  26f60701         test byte ptr es:[bx], 1
  005C48  7424             je 0x5c6e
  005C4A  8b4604           mov ax, word ptr [bp + 4]
  005C4D  8b5606           mov dx, word ptr [bp + 6]
  005C50  057400           add ax, 0x74
  005C53  52               push dx
  005C54  50               push ax
  005C55  ff76fe           push word ptr [bp - 2]
  005C58  ff76fc           push word ptr [bp - 4]
  005C5B  e806f2           call 0x4e64
  005C5E  d1f8             sar ax, 1
  005C60  8b8ef8fe         mov cx, word ptr [bp - 0x108]
  005C64  d1f9             sar cx, 1
  005C66  2bc8             sub cx, ax
  005C68  898e98fe         mov word ptr [bp - 0x168], cx
  005C6C  eb06             jmp 0x5c74
  005C6E  c78698fe0000     mov word ptr [bp - 0x168], 0
  005C74  ff7606           push word ptr [bp + 6]
  005C77  ff7604           push word ptr [bp + 4]
  005C7A  ff76fe           push word ptr [bp - 2]
  005C7D  ff76fc           push word ptr [bp - 4]
  005C80  8b8698fe         mov ax, word ptr [bp - 0x168]
  005C84  8b96f2fe         mov dx, word ptr [bp - 0x10e]
  005C88  e8bffe           call 0x5b4a
  005C8B  eb04             jmp 0x5c91
  005C8D  90               nop
  005C8E  ff46fc           inc word ptr [bp - 4]
  005C91  c45efc           les bx, ptr [bp - 4]
  005C94  26803f00         cmp byte ptr es:[bx], 0
  005C98  75f4             jne 0x5c8e
  005C9A  c45e04           les bx, ptr [bp + 4]
  005C9D  26ffb78200       push word ptr es:[bx + 0x82]
  005CA2  26ffb78000       push word ptr es:[bx + 0x80]
  005CA7  e84afc           call 0x58f4
  005CAA  83c404           add sp, 4
  005CAD  40               inc ax
  005CAE  01869afe         add word ptr [bp - 0x166], ax
  005CB2  c45e04           les bx, ptr [bp + 4]
  005CB5  26ffb78200       push word ptr es:[bx + 0x82]
  005CBA  26ffb78000       push word ptr es:[bx + 0x80]
  005CBF  e832fc           call 0x58f4
  005CC2  83c404           add sp, 4
  005CC5  40               inc ax
  005CC6  0186f2fe         add word ptr [bp - 0x10e], ax
  005CCA  e94901           jmp 0x5e16
  005CCD  90               nop
  005CCE  ff46fc           inc word ptr [bp - 4]
  005CD1  c45efc           les bx, ptr [bp - 4]
  005CD4  26803f20         cmp byte ptr es:[bx], 0x20
  005CD8  74f4             je 0x5cce
  005CDA  6a20             push 0x20
  005CDC  06               push es
  005CDD  53               push bx
  005CDE  9aa80c8813       lcall 0x1388, 0xca8
  005CE3  83c406           add sp, 6
  005CE6  89869efe         mov word ptr [bp - 0x162], ax
  005CEA  8996a0fe         mov word ptr [bp - 0x160], dx
  005CEE  0bd0             or dx, ax
  005CF0  7408             je 0x5cfa
  005CF2  c49e9efe         les bx, ptr [bp - 0x162]
  005CF6  26c60700         mov byte ptr es:[bx], 0
  005CFA  ff76fe           push word ptr [bp - 2]
  005CFD  ff76fc           push word ptr [bp - 4]
  005D00  9ad40d8813       lcall 0x1388, 0xdd4
  005D05  83c404           add sp, 4
  005D08  898696fe         mov word ptr [bp - 0x16a], ax
  005D0C  c686a2fe00       mov byte ptr [bp - 0x15e], 0
  005D11  80befafe00       cmp byte ptr [bp - 0x106], 0
  005D16  7410             je 0x5d28
  005D18  689905           push 0x599
  005D1B  8d86a2fe         lea ax, [bp - 0x15e]
  005D1F  50               push ax
  005D20  9ae6058813       lcall 0x1388, 0x5e6
  005D25  83c404           add sp, 4
  005D28  ff76fe           push word ptr [bp - 2]
  005D2B  ff76fc           push word ptr [bp - 4]
  005D2E  8d86a2fe         lea ax, [bp - 0x15e]
  005D32  16               push ss
  005D33  50               push ax
  005D34  9a220e8813       lcall 0x1388, 0xe22
  005D39  83c408           add sp, 8
  005D3C  8b4604           mov ax, word ptr [bp + 4]
  005D3F  8b5606           mov dx, word ptr [bp + 6]
  005D42  057400           add ax, 0x74
  005D45  52               push dx
  005D46  50               push ax
  005D47  8d8ea2fe         lea cx, [bp - 0x15e]
  005D4B  16               push ss
  005D4C  51               push cx
  005D4D  8bf0             mov si, ax
  005D4F  8bfa             mov di, dx
  005D51  e810f1           call 0x4e64
  005D54  89869cfe         mov word ptr [bp - 0x164], ax
  005D58  8ec7             mov es, di
  005D5A  268b04           mov ax, word ptr es:[si]
  005D5D  03869cfe         add ax, word ptr [bp - 0x164]
  005D61  0346fa           add ax, word ptr [bp - 6]
  005D64  3b86f8fe         cmp ax, word ptr [bp - 0x108]
  005D68  7e71             jle 0x5ddb
  005D6A  83be94fe00       cmp word ptr [bp - 0x16c], 0
  005D6F  7415             je 0x5d86
  005D71  ff7606           push word ptr [bp + 6]
  005D74  ff7604           push word ptr [bp + 4]
  005D77  8d86fafe         lea ax, [bp - 0x106]
  005D7B  16               push ss
  005D7C  50               push ax
  005D7D  2bc0             sub ax, ax
  005D7F  8b96f2fe         mov dx, word ptr [bp - 0x10e]
  005D83  e8c4fd           call 0x5b4a
  005D86  c45e04           les bx, ptr [bp + 4]
  005D89  26ffb78200       push word ptr es:[bx + 0x82]
  005D8E  26ffb78000       push word ptr es:[bx + 0x80]
  005D93  e85efb           call 0x58f4
  005D96  83c404           add sp, 4
  005D99  40               inc ax
  005D9A  01869afe         add word ptr [bp - 0x166], ax
  005D9E  c45e04           les bx, ptr [bp + 4]
  005DA1  26ffb78200       push word ptr es:[bx + 0x82]
  005DA6  26ffb78000       push word ptr es:[bx + 0x80]
  005DAB  e846fb           call 0x58f4
  005DAE  83c404           add sp, 4
  005DB1  40               inc ax
  005DB2  0186f2fe         add word ptr [bp - 0x10e], ax
  005DB6  eb12             jmp 0x5dca
  005DB8  8d86a3fe         lea ax, [bp - 0x15d]
  005DBC  50               push ax
  005DBD  8d86a2fe         lea ax, [bp - 0x15e]
  005DC1  50               push ax
  005DC2  9a26068813       lcall 0x1388, 0x626
  005DC7  83c404           add sp, 4
  005DCA  80bea2fe20       cmp byte ptr [bp - 0x15e], 0x20
  005DCF  74e7             je 0x5db8
  005DD1  c686fafe00       mov byte ptr [bp - 0x106], 0
  005DD6  c746fa0000       mov word ptr [bp - 6], 0
  005DDB  8d86a2fe         lea ax, [bp - 0x15e]
  005DDF  16               push ss
  005DE0  50               push ax
  005DE1  8d86fafe         lea ax, [bp - 0x106]
  005DE5  16               push ss
  005DE6  50               push ax
  005DE7  9a220e8813       lcall 0x1388, 0xe22
  005DEC  83c408           add sp, 8
  005DEF  c45e04           les bx, ptr [bp + 4]
  005DF2  268b4774         mov ax, word ptr es:[bx + 0x74]
  005DF6  03869cfe         add ax, word ptr [bp - 0x164]
  005DFA  0146fa           add word ptr [bp - 6], ax
  005DFD  8b86a0fe         mov ax, word ptr [bp - 0x160]
  005E01  0b869efe         or ax, word ptr [bp - 0x162]
  005E05  7408             je 0x5e0f
  005E07  c49e9efe         les bx, ptr [bp - 0x162]
  005E0B  26c60720         mov byte ptr es:[bx], 0x20
  005E0F  8b8696fe         mov ax, word ptr [bp - 0x16a]
  005E13  0146fc           add word ptr [bp - 4], ax
  005E16  ff76fe           push word ptr [bp - 2]
  005E19  ff76fc           push word ptr [bp - 4]
  005E1C  9ad40d8813       lcall 0x1388, 0xdd4
  005E21  83c404           add sp, 4
  005E24  0bc0             or ax, ax
  005E26  7403             je 0x5e2b
  005E28  e9a6fe           jmp 0x5cd1
  005E2B  c49ef4fe         les bx, ptr [bp - 0x10c]
  005E2F  268b4706         mov ax, word ptr es:[bx + 6]
  005E33  268b5708         mov dx, word ptr es:[bx + 8]
  005E37  8986f4fe         mov word ptr [bp - 0x10c], ax
  005E3B  8996f6fe         mov word ptr [bp - 0x10a], dx
  005E3F  e974fd           jmp 0x5bb6
  005E42  80befafe00       cmp byte ptr [bp - 0x106], 0
  005E47  7451             je 0x5e9a
  005E49  83be94fe00       cmp word ptr [bp - 0x16c], 0
  005E4E  7415             je 0x5e65
  005E50  ff7606           push word ptr [bp + 6]
  005E53  ff7604           push word ptr [bp + 4]
  005E56  8d86fafe         lea ax, [bp - 0x106]
  005E5A  16               push ss
  005E5B  50               push ax
  005E5C  2bc0             sub ax, ax
  005E5E  8b96f2fe         mov dx, word ptr [bp - 0x10e]
  005E62  e8e5fc           call 0x5b4a
  005E65  c45e04           les bx, ptr [bp + 4]
  005E68  26ffb78200       push word ptr es:[bx + 0x82]
  005E6D  26ffb78000       push word ptr es:[bx + 0x80]
  005E72  e87ffa           call 0x58f4
  005E75  83c404           add sp, 4
  005E78  40               inc ax
  005E79  01869afe         add word ptr [bp - 0x166], ax
  005E7D  c45e04           les bx, ptr [bp + 4]
  005E80  26ffb78200       push word ptr es:[bx + 0x82]
  005E85  26ffb78000       push word ptr es:[bx + 0x80]
  005E8A  e867fa           call 0x58f4
  005E8D  83c404           add sp, 4
  005E90  40               inc ax
  005E91  0186f2fe         add word ptr [bp - 0x10e], ax
  005E95  c686fafe00       mov byte ptr [bp - 0x106], 0
  005E9A  8b869afe         mov ax, word ptr [bp - 0x166]
  005E9E  5e               pop si
  005E9F  5f               pop di
  005EA0  c9               leave
  005EA1  c20400           ret 4
  005EA4  c82c0000         enter 0x2c, 0
  005EA8  56               push si
  005EA9  c746f80100       mov word ptr [bp - 8], 1
  005EAE  2bc0             sub ax, ax
  005EB0  8946d4           mov word ptr [bp - 0x2c], ax
  005EB3  8946ec           mov word ptr [bp - 0x14], ax
  005EB6  8946e2           mov word ptr [bp - 0x1e], ax
  005EB9  c45e04           les bx, ptr [bp + 4]
  005EBC  26394708         cmp word ptr es:[bx + 8], ax
  005EC0  7412             je 0x5ed4
  005EC2  26394702         cmp word ptr es:[bx + 2], ax
  005EC6  740c             je 0x5ed4
  005EC8  26894708         mov word ptr es:[bx + 8], ax
  005ECC  26894762         mov word ptr es:[bx + 0x62], ax
  005ED0  26894760         mov word ptr es:[bx + 0x60], ax
  005ED4  c45e04           les bx, ptr [bp + 4]
  005ED7  268b470c         mov ax, word ptr es:[bx + 0xc]
  005EDB  26894710         mov word ptr es:[bx + 0x10], ax
  005EDF  268b470e         mov ax, word ptr es:[bx + 0xe]
  005EE3  26894712         mov word ptr es:[bx + 0x12], ax
  005EE7  26c747140000     mov word ptr es:[bx + 0x14], 0
  005EED  268b474a         mov ax, word ptr es:[bx + 0x4a]
  005EF1  d1e0             shl ax, 1
  005EF3  26034746         add ax, word ptr es:[bx + 0x46]
  005EF7  26894716         mov word ptr es:[bx + 0x16], ax
  005EFB  268a470a         mov al, byte ptr es:[bx + 0xa]
  005EFF  251000           and ax, 0x10
  005F02  3d0100           cmp ax, 1
  005F05  1bc0             sbb ax, ax
  005F07  250300           and ax, 3
  005F0A  2689472a         mov word ptr es:[bx + 0x2a], ax
  005F0E  8bc8             mov cx, ax
  005F10  26034746         add ax, word ptr es:[bx + 0x46]
  005F14  2689472c         mov word ptr es:[bx + 0x2c], ax
  005F18  26894f24         mov word ptr es:[bx + 0x24], cx
  005F1C  26894726         mov word ptr es:[bx + 0x26], ax
  005F20  268b4728         mov ax, word ptr es:[bx + 0x28]
  005F24  263b4720         cmp ax, word ptr es:[bx + 0x20]
  005F28  7d04             jge 0x5f2e
  005F2A  268b4720         mov ax, word ptr es:[bx + 0x20]
  005F2E  263b4734         cmp ax, word ptr es:[bx + 0x34]
  005F32  7d04             jge 0x5f38
  005F34  268b4734         mov ax, word ptr es:[bx + 0x34]
  005F38  26894728         mov word ptr es:[bx + 0x28], ax
  005F3C  26894734         mov word ptr es:[bx + 0x34], ax
  005F40  26894720         mov word ptr es:[bx + 0x20], ax
  005F44  268b4702         mov ax, word ptr es:[bx + 2]
  005F48  26034704         add ax, word ptr es:[bx + 4]
  005F4C  26034706         add ax, word ptr es:[bx + 6]
  005F50  26034708         add ax, word ptr es:[bx + 8]
  005F54  7503             jne 0x5f59
  005F56  e9b904           jmp 0x6412
  005F59  c746fa0000       mov word ptr [bp - 6], 0
  005F5E  c45e04           les bx, ptr [bp + 4]
  005F61  268b475e         mov ax, word ptr es:[bx + 0x5e]
  005F65  260b475c         or ax, word ptr es:[bx + 0x5c]
  005F69  7449             je 0x5fb4
  005F6B  268b4748         mov ax, word ptr es:[bx + 0x48]
  005F6F  2603472e         add ax, word ptr es:[bx + 0x2e]
  005F73  26034730         add ax, word ptr es:[bx + 0x30]
  005F77  26034732         add ax, word ptr es:[bx + 0x32]
  005F7B  26014714         add word ptr es:[bx + 0x14], ax
  005F7F  2601472a         add word ptr es:[bx + 0x2a], ax
  005F83  26014724         add word ptr es:[bx + 0x24], ax
  005F87  26014736         add word ptr es:[bx + 0x36], ax
  005F8B  268b475c         mov ax, word ptr es:[bx + 0x5c]
  005F8F  268b575e         mov dx, word ptr es:[bx + 0x5e]
  005F93  8946ee           mov word ptr [bp - 0x12], ax
  005F96  8956f0           mov word ptr [bp - 0x10], dx
  005F99  8bc2             mov ax, dx
  005F9B  0b46ee           or ax, word ptr [bp - 0x12]
  005F9E  7414             je 0x5fb4
  005FA0  c45eee           les bx, ptr [bp - 0x12]
  005FA3  268b4702         mov ax, word ptr es:[bx + 2]
  005FA7  8946fa           mov word ptr [bp - 6], ax
  005FAA  268b4710         mov ax, word ptr es:[bx + 0x10]
  005FAE  268b5712         mov dx, word ptr es:[bx + 0x12]
  005FB2  ebdf             jmp 0x5f93
  005FB4  c45e04           les bx, ptr [bp + 4]
  005FB7  268b475a         mov ax, word ptr es:[bx + 0x5a]
  005FBB  260b4758         or ax, word ptr es:[bx + 0x58]
  005FBF  7421             je 0x5fe2
  005FC1  06               push es
  005FC2  53               push bx
  005FC3  2bc0             sub ax, ax
  005FC5  e8aefb           call 0x5b76
  005FC8  8946d4           mov word ptr [bp - 0x2c], ax
  005FCB  c45e04           les bx, ptr [bp + 4]
  005FCE  268b4746         mov ax, word ptr es:[bx + 0x46]
  005FD2  8bc8             mov cx, ax
  005FD4  0346d4           add ax, word ptr [bp - 0x2c]
  005FD7  26014726         add word ptr es:[bx + 0x26], ax
  005FDB  034ed4           add cx, word ptr [bp - 0x2c]
  005FDE  26014f38         add word ptr es:[bx + 0x38], cx
  005FE2  c45e04           les bx, ptr [bp + 4]
  005FE5  268b4756         mov ax, word ptr es:[bx + 0x56]
  005FE9  260b4754         or ax, word ptr es:[bx + 0x54]
  005FED  741e             je 0x600d
  005FEF  26ffb78200       push word ptr es:[bx + 0x82]
  005FF4  26ffb78000       push word ptr es:[bx + 0x80]
  005FF9  e8f8f8           call 0x58f4
  005FFC  83c404           add sp, 4
  005FFF  c45e04           les bx, ptr [bp + 4]
  006002  26034746         add ax, word ptr es:[bx + 0x46]
  006006  26f76f02         imul word ptr es:[bx + 2]
  00600A  8946ec           mov word ptr [bp - 0x14], ax
  00600D  268b4762         mov ax, word ptr es:[bx + 0x62]
  006011  260b4760         or ax, word ptr es:[bx + 0x60]
  006015  7421             je 0x6038
  006017  26ffb78200       push word ptr es:[bx + 0x82]
  00601C  26ffb78000       push word ptr es:[bx + 0x80]
  006021  e8d0f8           call 0x58f4
  006024  83c404           add sp, 4
  006027  c45e04           les bx, ptr [bp + 4]
  00602A  26034746         add ax, word ptr es:[bx + 0x46]
  00602E  050500           add ax, 5
  006031  26f76f08         imul word ptr es:[bx + 8]
  006035  8946e2           mov word ptr [bp - 0x1e], ax
  006038  8b46e2           mov ax, word ptr [bp - 0x1e]
  00603B  0346ec           add ax, word ptr [bp - 0x14]
  00603E  0346d4           add ax, word ptr [bp - 0x2c]
  006041  8946f2           mov word ptr [bp - 0xe], ax
  006044  0bc0             or ax, ax
  006046  7407             je 0x604f
  006048  26034746         add ax, word ptr es:[bx + 0x46]
  00604C  8946f2           mov word ptr [bp - 0xe], ax
  00604F  268a470a         mov al, byte ptr es:[bx + 0xa]
  006053  251000           and ax, 0x10
  006056  3d0100           cmp ax, 1
  006059  1bc0             sbb ax, ax
  00605B  250300           and ax, 3
  00605E  d1e0             shl ax, 1
  006060  8b4efa           mov cx, word ptr [bp - 6]
  006063  3b4ef2           cmp cx, word ptr [bp - 0xe]
  006066  7d03             jge 0x606b
  006068  8b4ef2           mov cx, word ptr [bp - 0xe]
  00606B  8bd0             mov dx, ax
  00606D  03c1             add ax, cx
  00606F  26014716         add word ptr es:[bx + 0x16], ax
  006073  26035720         add dx, word ptr es:[bx + 0x20]
  006077  26015714         add word ptr es:[bx + 0x14], dx
  00607B  833e660500       cmp word ptr [0x566], 0
  006080  7424             je 0x60a6
  006082  a18000           mov ax, word ptr [0x80]
  006085  8b168200         mov dx, word ptr [0x82]
  006089  2639878000       cmp word ptr es:[bx + 0x80], ax
  00608E  750e             jne 0x609e
  006090  2639978200       cmp word ptr es:[bx + 0x82], dx
  006095  7507             jne 0x609e
  006097  2683471606       add word ptr es:[bx + 0x16], 6
  00609C  eb08             jmp 0x60a6
  00609E  c45e04           les bx, ptr [bp + 4]
  0060A1  2683471603       add word ptr es:[bx + 0x16], 3
  0060A6  c45e04           les bx, ptr [bp + 4]
  0060A9  26837f10ff       cmp word ptr es:[bx + 0x10], -1
  0060AE  750f             jne 0x60bf
  0060B0  268b4714         mov ax, word ptr es:[bx + 0x14]
  0060B4  d1f8             sar ax, 1
  0060B6  2da000           sub ax, 0xa0
  0060B9  f7d8             neg ax
  0060BB  26894710         mov word ptr es:[bx + 0x10], ax
  0060BF  c45e04           les bx, ptr [bp + 4]
  0060C2  26837f12ff       cmp word ptr es:[bx + 0x12], -1
  0060C7  750f             jne 0x60d8
  0060C9  268b4716         mov ax, word ptr es:[bx + 0x16]
  0060CD  d1f8             sar ax, 1
  0060CF  2d6400           sub ax, 0x64
  0060D2  f7d8             neg ax
  0060D4  26894712         mov word ptr es:[bx + 0x12], ax
  0060D8  c45e04           les bx, ptr [bp + 4]
  0060DB  268b4716         mov ax, word ptr es:[bx + 0x16]
  0060DF  26034712         add ax, word ptr es:[bx + 0x12]
  0060E3  8946de           mov word ptr [bp - 0x22], ax
  0060E6  268b4714         mov ax, word ptr es:[bx + 0x14]
  0060EA  26034710         add ax, word ptr es:[bx + 0x10]
  0060EE  8946e4           mov word ptr [bp - 0x1c], ax
  0060F1  3d4001           cmp ax, 0x140
  0060F4  7e09             jle 0x60ff
  0060F6  2d4001           sub ax, 0x140
  0060F9  f7d8             neg ax
  0060FB  26014710         add word ptr es:[bx + 0x10], ax
  0060FF  817edec800       cmp word ptr [bp - 0x22], 0xc8
  006104  7e0d             jle 0x6113
  006106  b8c800           mov ax, 0xc8
  006109  2b46de           sub ax, word ptr [bp - 0x22]
  00610C  c45e04           les bx, ptr [bp + 4]
  00610F  26014712         add word ptr es:[bx + 0x12], ax
  006113  c45e04           les bx, ptr [bp + 4]
  006116  26837f1000       cmp word ptr es:[bx + 0x10], 0
  00611B  7c07             jl 0x6124
  00611D  26837f1200       cmp word ptr es:[bx + 0x12], 0
  006122  7d1c             jge 0x6140
  006124  268b4710         mov ax, word ptr es:[bx + 0x10]
  006128  99               cdq
  006129  52               push dx
  00612A  50               push ax
  00612B  268b4712         mov ax, word ptr es:[bx + 0x12]
  00612F  99               cdq
  006130  52               push dx
  006131  50               push ax
  006132  b8afff           mov ax, 0xffaf
  006135  ba0200           mov dx, 2
  006138  bb2900           mov bx, 0x29
  00613B  9ad603d00e       lcall 0xed0, 0x3d6
  006140  c45e04           les bx, ptr [bp + 4]
  006143  268b4710         mov ax, word ptr es:[bx + 0x10]
  006147  26894718         mov word ptr es:[bx + 0x18], ax
  00614B  268b4712         mov ax, word ptr es:[bx + 0x12]
  00614F  2689471a         mov word ptr es:[bx + 0x1a], ax
  006153  268b4714         mov ax, word ptr es:[bx + 0x14]
  006157  2689471c         mov word ptr es:[bx + 0x1c], ax
  00615B  268b4f16         mov cx, word ptr es:[bx + 0x16]
  00615F  26894f1e         mov word ptr es:[bx + 0x1e], cx
  006163  268b4f6a         mov cx, word ptr es:[bx + 0x6a]
  006167  260b4f68         or cx, word ptr es:[bx + 0x68]
  00616B  7503             jne 0x6170
  00616D  e97a02           jmp 0x63ea
  006170  268b4f68         mov cx, word ptr es:[bx + 0x68]
  006174  268b576a         mov dx, word ptr es:[bx + 0x6a]
  006178  894eee           mov word ptr [bp - 0x12], cx
  00617B  8956f0           mov word ptr [bp - 0x10], dx
  00617E  833e5c0500       cmp word ptr [0x55c], 0
  006183  7d03             jge 0x6188
  006185  e9f300           jmp 0x627b
  006188  8ec2             mov es, dx
  00618A  8bd9             mov bx, cx
  00618C  26c45f0c         les bx, ptr es:[bx + 0xc]
  006190  268b4f4c         mov cx, word ptr es:[bx + 0x4c]
  006194  83c103           add cx, 3
  006197  894eda           mov word ptr [bp - 0x26], cx
  00619A  c746e8fdff       mov word ptr [bp - 0x18], 0xfffd
  00619F  268b4f4a         mov cx, word ptr es:[bx + 0x4a]
  0061A3  83c103           add cx, 3
  0061A6  894ee0           mov word ptr [bp - 0x20], cx
  0061A9  03c1             add ax, cx
  0061AB  050300           add ax, 3
  0061AE  8946d8           mov word ptr [bp - 0x28], ax
  0061B1  3d4001           cmp ax, 0x140
  0061B4  7e0b             jle 0x61c1
  0061B6  2d4301           sub ax, 0x143
  0061B9  8946e8           mov word ptr [bp - 0x18], ax
  0061BC  c746d84001       mov word ptr [bp - 0x28], 0x140
  0061C1  833e5c0500       cmp word ptr [0x55c], 0
  0061C6  741c             je 0x61e4
  0061C8  833e5c0503       cmp word ptr [0x55c], 3
  0061CD  7415             je 0x61e4
  0061CF  833e5c0505       cmp word ptr [0x55c], 5
  0061D4  740e             je 0x61e4
  0061D6  833e5c0507       cmp word ptr [0x55c], 7
  0061DB  7407             je 0x61e4
  0061DD  833e5c0508       cmp word ptr [0x55c], 8
  0061E2  7508             jne 0x61ec
  0061E4  c746dc0100       mov word ptr [bp - 0x24], 1
  0061E9  eb06             jmp 0x61f1
  0061EB  90               nop
  0061EC  c746dc0000       mov word ptr [bp - 0x24], 0
  0061F1  8b46d8           mov ax, word ptr [bp - 0x28]
  0061F4  c45e04           les bx, ptr [bp + 4]
  0061F7  2689471c         mov word ptr es:[bx + 0x1c], ax
  0061FB  837edc00         cmp word ptr [bp - 0x24], 0
  0061FF  7421             je 0x6222
  006201  d1f8             sar ax, 1
  006203  2da000           sub ax, 0xa0
  006206  f7d8             neg ax
  006208  26894718         mov word ptr es:[bx + 0x18], ax
  00620C  c476ee           les si, ptr [bp - 0x12]
  00620F  26894404         mov word ptr es:[si + 4], ax
  006213  2b46e8           sub ax, word ptr [bp - 0x18]
  006216  0346e0           add ax, word ptr [bp - 0x20]
  006219  c45e04           les bx, ptr [bp + 4]
  00621C  26894710         mov word ptr es:[bx + 0x10], ax
  006220  eb23             jmp 0x6245
  006222  8b46d8           mov ax, word ptr [bp - 0x28]
  006225  d1f8             sar ax, 1
  006227  2da000           sub ax, 0xa0
  00622A  f7d8             neg ax
  00622C  c45e04           les bx, ptr [bp + 4]
  00622F  26894718         mov word ptr es:[bx + 0x18], ax
  006233  26894710         mov word ptr es:[bx + 0x10], ax
  006237  26034714         add ax, word ptr es:[bx + 0x14]
  00623B  2b46e8           sub ax, word ptr [bp - 0x18]
  00623E  c45eee           les bx, ptr [bp - 0x12]
  006241  26894704         mov word ptr es:[bx + 4], ax
  006245  8b46da           mov ax, word ptr [bp - 0x26]
  006248  d1f8             sar ax, 1
  00624A  2d6400           sub ax, 0x64
  00624D  f7d8             neg ax
  00624F  c45eee           les bx, ptr [bp - 0x12]
  006252  268907           mov word ptr es:[bx], ax
  006255  c45e04           les bx, ptr [bp + 4]
  006258  8bc8             mov cx, ax
  00625A  263b4712         cmp ax, word ptr es:[bx + 0x12]
  00625E  7e04             jle 0x6264
  006260  268b4712         mov ax, word ptr es:[bx + 0x12]
  006264  2689471a         mov word ptr es:[bx + 0x1a], ax
  006268  034eda           add cx, word ptr [bp - 0x26]
  00626B  49               dec cx
  00626C  3b4ede           cmp cx, word ptr [bp - 0x22]
  00626F  7d03             jge 0x6274
  006271  8b4ede           mov cx, word ptr [bp - 0x22]
  006274  2bc8             sub cx, ax
  006276  41               inc cx
  006277  26894f1e         mov word ptr es:[bx + 0x1e], cx
  00627B  833e5e0500       cmp word ptr [0x55e], 0
  006280  7d0a             jge 0x628c
  006282  833e600500       cmp word ptr [0x560], 0
  006287  7d03             jge 0x628c
  006289  e95e01           jmp 0x63ea
  00628C  c45eee           les bx, ptr [bp - 0x12]
  00628F  26c45f0c         les bx, ptr es:[bx + 0xc]
  006293  268b474a         mov ax, word ptr es:[bx + 0x4a]
  006297  8946e0           mov word ptr [bp - 0x20], ax
  00629A  268b474c         mov ax, word ptr es:[bx + 0x4c]
  00629E  8946da           mov word ptr [bp - 0x26], ax
  0062A1  268b4f10         mov cx, word ptr es:[bx + 0x10]
  0062A5  894ef6           mov word ptr [bp - 0xa], cx
  0062A8  268b5712         mov dx, word ptr es:[bx + 0x12]
  0062AC  8956f4           mov word ptr [bp - 0xc], dx
  0062AF  268b5714         mov dx, word ptr es:[bx + 0x14]
  0062B3  8956fc           mov word ptr [bp - 4], dx
  0062B6  3bc8             cmp cx, ax
  0062B8  7e02             jle 0x62bc
  0062BA  8bc8             mov cx, ax
  0062BC  2bc1             sub ax, cx
  0062BE  c45e04           les bx, ptr [bp + 4]
  0062C1  26034716         add ax, word ptr es:[bx + 0x16]
  0062C5  8946d6           mov word ptr [bp - 0x2a], ax
  0062C8  3dc800           cmp ax, 0xc8
  0062CB  7c09             jl 0x62d6
  0062CD  26804f0a40       or byte ptr es:[bx + 0xa], 0x40
  0062D2  e91501           jmp 0x63ea
  0062D5  90               nop
  0062D6  d1f8             sar ax, 1
  0062D8  2d6400           sub ax, 0x64
  0062DB  f7d8             neg ax
  0062DD  c45eee           les bx, ptr [bp - 0x12]
  0062E0  268907           mov word ptr es:[bx], ax
  0062E3  c45e04           les bx, ptr [bp + 4]
  0062E6  2689471a         mov word ptr es:[bx + 0x1a], ax
  0062EA  8b4ed6           mov cx, word ptr [bp - 0x2a]
  0062ED  3b4eda           cmp cx, word ptr [bp - 0x26]
  0062F0  7d03             jge 0x62f5
  0062F2  8b4eda           mov cx, word ptr [bp - 0x26]
  0062F5  26894f1e         mov word ptr es:[bx + 0x1e], cx
  0062F9  2b46f6           sub ax, word ptr [bp - 0xa]
  0062FC  0346da           add ax, word ptr [bp - 0x26]
  0062FF  26894712         mov word ptr es:[bx + 0x12], ax
  006303  8b46f4           mov ax, word ptr [bp - 0xc]
  006306  e9d100           jmp 0x63da
  006309  90               nop
  00630A  c45e04           les bx, ptr [bp + 4]
  00630D  268b4714         mov ax, word ptr es:[bx + 0x14]
  006311  2b46fc           sub ax, word ptr [bp - 4]
  006314  0346e0           add ax, word ptr [bp - 0x20]
  006317  8946d8           mov word ptr [bp - 0x28], ax
  00631A  3d4001           cmp ax, 0x140
  00631D  7e0b             jle 0x632a
  00631F  2d4001           sub ax, 0x140
  006322  0146fc           add word ptr [bp - 4], ax
  006325  c746d84001       mov word ptr [bp - 0x28], 0x140
  00632A  8b46d8           mov ax, word ptr [bp - 0x28]
  00632D  d1f8             sar ax, 1
  00632F  2da000           sub ax, 0xa0
  006332  f7d8             neg ax
  006334  c45eee           les bx, ptr [bp - 0x12]
  006337  26894704         mov word ptr es:[bx + 4], ax
  00633B  c45e04           les bx, ptr [bp + 4]
  00633E  26894718         mov word ptr es:[bx + 0x18], ax
  006342  8b4ed8           mov cx, word ptr [bp - 0x28]
  006345  26894f1c         mov word ptr es:[bx + 0x1c], cx
  006349  2b46fc           sub ax, word ptr [bp - 4]
  00634C  0346e0           add ax, word ptr [bp - 0x20]
  00634F  26894710         mov word ptr es:[bx + 0x10], ax
  006353  e99400           jmp 0x63ea
  006356  8b46e0           mov ax, word ptr [bp - 0x20]
  006359  d1f8             sar ax, 1
  00635B  2da000           sub ax, 0xa0
  00635E  f7d8             neg ax
  006360  c45eee           les bx, ptr [bp - 0x12]
  006363  26894704         mov word ptr es:[bx + 4], ax
  006367  c45e04           les bx, ptr [bp + 4]
  00636A  268b4f10         mov cx, word ptr es:[bx + 0x10]
  00636E  3bc8             cmp cx, ax
  006370  7e02             jle 0x6374
  006372  8bc8             mov cx, ax
  006374  26894f18         mov word ptr es:[bx + 0x18], cx
  006378  0346e0           add ax, word ptr [bp - 0x20]
  00637B  48               dec ax
  00637C  3b46e4           cmp ax, word ptr [bp - 0x1c]
  00637F  7d03             jge 0x6384
  006381  8b46e4           mov ax, word ptr [bp - 0x1c]
  006384  8946e4           mov word ptr [bp - 0x1c], ax
  006387  2bc1             sub ax, cx
  006389  40               inc ax
  00638A  2689471c         mov word ptr es:[bx + 0x1c], ax
  00638E  eb5a             jmp 0x63ea
  006390  c45e04           les bx, ptr [bp + 4]
  006393  268b4714         mov ax, word ptr es:[bx + 0x14]
  006397  2b46fc           sub ax, word ptr [bp - 4]
  00639A  0346e0           add ax, word ptr [bp - 0x20]
  00639D  8946d8           mov word ptr [bp - 0x28], ax
  0063A0  3d4001           cmp ax, 0x140
  0063A3  7e0b             jle 0x63b0
  0063A5  2d4001           sub ax, 0x140
  0063A8  0146fc           add word ptr [bp - 4], ax
  0063AB  c746d84001       mov word ptr [bp - 0x28], 0x140
  0063B0  8b46d8           mov ax, word ptr [bp - 0x28]
  0063B3  d1f8             sar ax, 1
  0063B5  2da000           sub ax, 0xa0
  0063B8  f7d8             neg ax
  0063BA  26894710         mov word ptr es:[bx + 0x10], ax
  0063BE  26894718         mov word ptr es:[bx + 0x18], ax
  0063C2  8b4ed8           mov cx, word ptr [bp - 0x28]
  0063C5  26894f1c         mov word ptr es:[bx + 0x1c], cx
  0063C9  26034714         add ax, word ptr es:[bx + 0x14]
  0063CD  2b46fc           sub ax, word ptr [bp - 4]
  0063D0  c45eee           les bx, ptr [bp - 0x12]
  0063D3  26894704         mov word ptr es:[bx + 4], ax
  0063D7  eb11             jmp 0x63ea
  0063D9  90               nop
  0063DA  0bc0             or ax, ax
  0063DC  7503             jne 0x63e1
  0063DE  e929ff           jmp 0x630a
  0063E1  48               dec ax
  0063E2  7503             jne 0x63e7
  0063E4  e96fff           jmp 0x6356
  0063E7  48               dec ax
  0063E8  74a6             je 0x6390
  0063EA  c45e04           les bx, ptr [bp + 4]
  0063ED  268b4710         mov ax, word ptr es:[bx + 0x10]
  0063F1  26014724         add word ptr es:[bx + 0x24], ax
  0063F5  268b4f12         mov cx, word ptr es:[bx + 0x12]
  0063F9  26014f26         add word ptr es:[bx + 0x26], cx
  0063FD  2601472a         add word ptr es:[bx + 0x2a], ax
  006401  26014f2c         add word ptr es:[bx + 0x2c], cx
  006405  26014736         add word ptr es:[bx + 0x36], ax
  006409  26014f38         add word ptr es:[bx + 0x38], cx
  00640D  c746f80000       mov word ptr [bp - 8], 0
  006412  8b46f8           mov ax, word ptr [bp - 8]
  006415  5e               pop si
  006416  c9               leave
  006417  c20400           ret 4
  00641A  55               push bp
  00641B  8bec             mov bp, sp
  00641D  56               push si
  00641E  833e6a0500       cmp word ptr [0x56a], 0
  006423  740a             je 0x642f
  006425  c45e04           les bx, ptr [bp + 4]
  006428  26f6470a20       test byte ptr es:[bx + 0xa], 0x20
  00642D  7521             jne 0x6450
  00642F  c45e04           les bx, ptr [bp + 4]
  006432  26ff771a         push word ptr es:[bx + 0x1a]
  006436  26ff771c         push word ptr es:[bx + 0x1c]
  00643A  26ff771e         push word ptr es:[bx + 0x1e]
  00643E  268b4718         mov ax, word ptr es:[bx + 0x18]
  006442  8bd8             mov bx, ax
  006444  8b7604           mov si, word ptr [bp + 4]
  006447  268b541a         mov dx, word ptr es:[si + 0x1a]
  00644B  9a4400340c       lcall 0xc34, 0x44
  006450  5e               pop si
  006451  c9               leave
  006452  c20400           ret 4
  006455  90               nop

; ---- _popup_help_draw  file 0x006456..0x0064C6  seg 0x33D:0x1a86  (popup.obj) ----
  006456  c8540000         enter 0x54, 0
  00645A  833e660500       cmp word ptr [0x566], 0
  00645F  7463             je 0x64c4
  006461  c45e06           les bx, ptr [bp + 6]
  006464  268b4714         mov ax, word ptr es:[bx + 0x14]
  006468  26034710         add ax, word ptr es:[bx + 0x10]
  00646C  48               dec ax
  00646D  48               dec ax
  00646E  8946fe           mov word ptr [bp - 2], ax
  006471  268b4716         mov ax, word ptr es:[bx + 0x16]
  006475  26034712         add ax, word ptr es:[bx + 0x12]
  006479  2d0700           sub ax, 7
  00647C  8946ac           mov word ptr [bp - 0x54], ax
  00647F  8b0e8000         mov cx, word ptr [0x80]
  006483  8b168200         mov dx, word ptr [0x82]
  006487  26398f8000       cmp word ptr es:[bx + 0x80], cx
  00648C  750c             jne 0x649a
  00648E  2639978200       cmp word ptr es:[bx + 0x82], dx
  006493  7505             jne 0x649a
  006495  48               dec ax
  006496  48               dec ax
  006497  8946ac           mov word ptr [bp - 0x54], ax
  00649A  c646ae00         mov byte ptr [bp - 0x52], 0
  00649E  ff36b453         push word ptr [0x53b4]
  0064A2  8d46ae           lea ax, [bp - 0x52]
  0064A5  50               push ax
  0064A6  9ae200ad08       lcall 0x8ad, 0xe2
  0064AB  83c404           add sp, 4
  0064AE  a09300           mov al, byte ptr [0x93]
  0064B1  2ae4             sub ah, ah
  0064B3  50               push ax
  0064B4  ff76ac           push word ptr [bp - 0x54]
  0064B7  ff76fe           push word ptr [bp - 2]
  0064BA  8d46ae           lea ax, [bp - 0x52]
  0064BD  16               push ss
  0064BE  50               push ax
  0064BF  9ac202ad08       lcall 0x8ad, 0x2c2
  0064C4  c9               leave
  0064C5  cb               retf

; ---- _popup_big_sprite  file 0x0064C6..0x006C56  seg 0x33D:0x1af6  (popup.obj) ----
  0064C6  c80c0000         enter 0xc, 0
  0064CA  56               push si
  0064CB  833e5c0507       cmp word ptr [0x55c], 7
  0064D0  7e06             jle 0x64d8
  0064D2  b80100           mov ax, 1
  0064D5  eb03             jmp 0x64da
  0064D7  90               nop
  0064D8  2bc0             sub ax, ax
  0064DA  8946fa           mov word ptr [bp - 6], ax
  0064DD  c45e06           les bx, ptr [bp + 6]
  0064E0  268b476a         mov ax, word ptr es:[bx + 0x6a]
  0064E4  260b4768         or ax, word ptr es:[bx + 0x68]
  0064E8  746d             je 0x6557
  0064EA  26f6470a40       test byte ptr es:[bx + 0xa], 0x40
  0064EF  7566             jne 0x6557
  0064F1  268b4768         mov ax, word ptr es:[bx + 0x68]
  0064F5  268b576a         mov dx, word ptr es:[bx + 0x6a]
  0064F9  8946fc           mov word ptr [bp - 4], ax
  0064FC  8956fe           mov word ptr [bp - 2], dx
  0064FF  8ec2             mov es, dx
  006501  8bd8             mov bx, ax
  006503  26ff770e         push word ptr es:[bx + 0xe]
  006507  26ff770c         push word ptr es:[bx + 0xc]
  00650B  26ff37           push word ptr es:[bx]
  00650E  b80100           mov ax, 1
  006511  268b5704         mov dx, word ptr es:[bx + 4]
  006515  8d1ef43a         lea bx, [0x3af4]
  006519  9a00008f0d       lcall 0xd8f, 0
  00651E  837efa00         cmp word ptr [bp - 6], 0
  006522  7433             je 0x6557
  006524  833e6e0500       cmp word ptr [0x56e], 0
  006529  742c             je 0x6557
  00652B  833e7e4e00       cmp word ptr [0x4e7e], 0
  006530  7e25             jle 0x6557
  006532  a17e4e           mov ax, word ptr [0x4e7e]
  006535  c45efc           les bx, ptr [bp - 4]
  006538  26c47710         les si, ptr es:[bx + 0x10]
  00653C  26ff740e         push word ptr es:[si + 0xe]
  006540  26ff740c         push word ptr es:[si + 0xc]
  006544  8e46fe           mov es, word ptr [bp - 2]
  006547  26ff37           push word ptr es:[bx]
  00654A  268b5704         mov dx, word ptr es:[bx + 4]
  00654E  8d1ef43a         lea bx, [0x3af4]
  006552  9a00008f0d       lcall 0xd8f, 0
  006557  5e               pop si
  006558  c9               leave
  006559  cb               retf
  00655A  c8120000         enter 0x12, 0
  00655E  50               push ax
  00655F  57               push di
  006560  56               push si
  006561  c45e04           les bx, ptr [bp + 4]
  006564  268b4f24         mov cx, word ptr es:[bx + 0x24]
  006568  26034f48         add cx, word ptr es:[bx + 0x48]
  00656C  26034f22         add cx, word ptr es:[bx + 0x22]
  006570  894ef8           mov word ptr [bp - 8], cx
  006573  268b5726         mov dx, word ptr es:[bx + 0x26]
  006577  8956f6           mov word ptr [bp - 0xa], dx
  00657A  268b7754         mov si, word ptr es:[bx + 0x54]
  00657E  268b7f56         mov di, word ptr es:[bx + 0x56]
  006582  8976f0           mov word ptr [bp - 0x10], si
  006585  897ef2           mov word ptr [bp - 0xe], di
  006588  0bc0             or ax, ax
  00658A  7468             je 0x65f4
  00658C  ff36fa3a         push word ptr [0x3afa]
  006590  ff36f83a         push word ptr [0x3af8]
  006594  ff36f63a         push word ptr [0x3af6]
  006598  ff36f43a         push word ptr [0x3af4]
  00659C  26ffb78200       push word ptr es:[bx + 0x82]
  0065A1  26ffb78000       push word ptr es:[bx + 0x80]
  0065A6  e84bf3           call 0x58f4
  0065A9  83c404           add sp, 4
  0065AC  c45e04           les bx, ptr [bp + 4]
  0065AF  26034746         add ax, word ptr es:[bx + 0x46]
  0065B3  26f76f02         imul word ptr es:[bx + 2]
  0065B7  50               push ax
  0065B8  26ff7710         push word ptr es:[bx + 0x10]
  0065BC  26ff7712         push word ptr es:[bx + 0x12]
  0065C0  26ff7714         push word ptr es:[bx + 0x14]
  0065C4  268a473c         mov al, byte ptr es:[bx + 0x3c]
  0065C8  50               push ax
  0065C9  268a473e         mov al, byte ptr es:[bx + 0x3e]
  0065CD  50               push ax
  0065CE  6a00             push 0
  0065D0  6a00             push 0
  0065D2  268b4748         mov ax, word ptr es:[bx + 0x48]
  0065D6  268b4f20         mov cx, word ptr es:[bx + 0x20]
  0065DA  bb0100           mov bx, 1
  0065DD  2bd8             sub bx, ax
  0065DF  8b7604           mov si, word ptr [bp + 4]
  0065E2  8b46f8           mov ax, word ptr [bp - 8]
  0065E5  262b4422         sub ax, word ptr es:[si + 0x22]
  0065E9  48               dec ax
  0065EA  d1e3             shl bx, 1
  0065EC  03d9             add bx, cx
  0065EE  8b56f6           mov dx, word ptr [bp - 0xa]
  0065F1  e826e7           call 0x4d1a
  0065F4  8b46f2           mov ax, word ptr [bp - 0xe]
  0065F7  0b46f0           or ax, word ptr [bp - 0x10]
  0065FA  7503             jne 0x65ff
  0065FC  e9bd01           jmp 0x67bc
  0065FF  c45ef0           les bx, ptr [bp - 0x10]
  006602  268a07           mov al, byte ptr es:[bx]
  006605  250200           and ax, 2
  006608  a36205           mov word ptr [0x562], ax
  00660B  c47604           les si, ptr [bp + 4]
  00660E  8bc3             mov ax, bx
  006610  8b56f2           mov dx, word ptr [bp - 0xe]
  006613  2639444c         cmp word ptr es:[si + 0x4c], ax
  006617  7568             jne 0x6681
  006619  2639544e         cmp word ptr es:[si + 0x4e], dx
  00661D  7562             jne 0x6681
  00661F  ff36fa3a         push word ptr [0x3afa]
  006623  ff36f83a         push word ptr [0x3af8]
  006627  ff36f63a         push word ptr [0x3af6]
  00662B  ff36f43a         push word ptr [0x3af4]
  00662F  26ffb48200       push word ptr es:[si + 0x82]
  006634  26ffb48000       push word ptr es:[si + 0x80]
  006639  e8b8f2           call 0x58f4
  00663C  83c404           add sp, 4
  00663F  40               inc ax
  006640  40               inc ax
  006641  50               push ax
  006642  c45e04           les bx, ptr [bp + 4]
  006645  26ff7710         push word ptr es:[bx + 0x10]
  006649  26ff7712         push word ptr es:[bx + 0x12]
  00664D  26ff7714         push word ptr es:[bx + 0x14]
  006651  268a4740         mov al, byte ptr es:[bx + 0x40]
  006655  50               push ax
  006656  268a4742         mov al, byte ptr es:[bx + 0x42]
  00665A  50               push ax
  00665B  6a00             push 0
  00665D  6a00             push 0
  00665F  268b4748         mov ax, word ptr es:[bx + 0x48]
  006663  268b4f20         mov cx, word ptr es:[bx + 0x20]
  006667  bb0100           mov bx, 1
  00666A  2bd8             sub bx, ax
  00666C  8b46f8           mov ax, word ptr [bp - 8]
  00666F  8b7604           mov si, word ptr [bp + 4]
  006672  262b4422         sub ax, word ptr es:[si + 0x22]
  006676  48               dec ax
  006677  d1e3             shl bx, 1
  006679  03d9             add bx, cx
  00667B  8b56f6           mov dx, word ptr [bp - 0xa]
  00667E  e899e6           call 0x4d1a
  006681  c45ef0           les bx, ptr [bp - 0x10]
  006684  26c45f08         les bx, ptr es:[bx + 8]
  006688  26803f00         cmp byte ptr es:[bx], 0
  00668C  7554             jne 0x66e2
  00668E  c45e04           les bx, ptr [bp + 4]
  006691  26ffb78200       push word ptr es:[bx + 0x82]
  006696  26ffb78000       push word ptr es:[bx + 0x80]
  00669B  e856f2           call 0x58f4
  00669E  83c404           add sp, 4
  0066A1  d1f8             sar ax, 1
  0066A3  0346f6           add ax, word ptr [bp - 0xa]
  0066A6  8946f4           mov word ptr [bp - 0xc], ax
  0066A9  ff36fa3a         push word ptr [0x3afa]
  0066AD  ff36f83a         push word ptr [0x3af8]
  0066B1  ff36f63a         push word ptr [0x3af6]
  0066B5  ff36f43a         push word ptr [0x3af4]
  0066B9  6a01             push 1
  0066BB  c45e04           les bx, ptr [bp + 4]
  0066BE  268a4776         mov al, byte ptr es:[bx + 0x76]
  0066C2  50               push ax
  0066C3  8b46f8           mov ax, word ptr [bp - 8]
  0066C6  262b4722         sub ax, word ptr es:[bx + 0x22]
  0066CA  268b4f48         mov cx, word ptr es:[bx + 0x48]
  0066CE  268b5f20         mov bx, word ptr es:[bx + 0x20]
  0066D2  d1e1             shl cx, 1
  0066D4  2bd9             sub bx, cx
  0066D6  8b56f4           mov dx, word ptr [bp - 0xc]
  0066D9  9a04005b0c       lcall 0xc5b, 4
  0066DE  e9aa00           jmp 0x678b
  0066E1  90               nop
  0066E2  c45e04           les bx, ptr [bp + 4]
  0066E5  26f6470a04       test byte ptr es:[bx + 0xa], 4
  0066EA  7416             je 0x6702
  0066EC  c45ef0           les bx, ptr [bp - 0x10]
  0066EF  26837f0601       cmp word ptr es:[bx + 6], 1
  0066F4  1ac0             sbb al, al
  0066F6  24fe             and al, 0xfe
  0066F8  045d             add al, 0x5d
  0066FA  26c45f08         les bx, ptr es:[bx + 8]
  0066FE  26884701         mov byte ptr es:[bx + 1], al
  006702  8b4604           mov ax, word ptr [bp + 4]
  006705  8b5606           mov dx, word ptr [bp + 6]
  006708  057400           add ax, 0x74
  00670B  52               push dx
  00670C  50               push ax
  00670D  c45ef0           les bx, ptr [bp - 0x10]
  006710  26ff770a         push word ptr es:[bx + 0xa]
  006714  26ff7708         push word ptr es:[bx + 8]
  006718  8bca             mov cx, dx
  00671A  8b56f6           mov dx, word ptr [bp - 0xa]
  00671D  42               inc dx
  00671E  268b1f           mov bx, word ptr es:[bx]
  006721  8bf0             mov si, ax
  006723  8b46f8           mov ax, word ptr [bp - 8]
  006726  8bf9             mov di, cx
  006728  8956ee           mov word ptr [bp - 0x12], dx
  00672B  e8e8e7           call 0x4f16
  00672E  6a7c             push 0x7c
  006730  c45ef0           les bx, ptr [bp - 0x10]
  006733  26ff770a         push word ptr es:[bx + 0xa]
  006737  26ff7708         push word ptr es:[bx + 8]
  00673B  9aa80c8813       lcall 0x1388, 0xca8
  006740  83c406           add sp, 6
  006743  8946fa           mov word ptr [bp - 6], ax
  006746  8956fc           mov word ptr [bp - 4], dx
  006749  0bd0             or dx, ax
  00674B  743e             je 0x678b
  00674D  57               push di
  00674E  56               push si
  00674F  8b56fc           mov dx, word ptr [bp - 4]
  006752  40               inc ax
  006753  8946fa           mov word ptr [bp - 6], ax
  006756  52               push dx
  006757  50               push ax
  006758  e809e7           call 0x4e64
  00675B  8946fe           mov word ptr [bp - 2], ax
  00675E  57               push di
  00675F  56               push si
  006760  ff76fc           push word ptr [bp - 4]
  006763  ff76fa           push word ptr [bp - 6]
  006766  c45e04           les bx, ptr [bp + 4]
  006769  268b4720         mov ax, word ptr es:[bx + 0x20]
  00676D  268b4f48         mov cx, word ptr es:[bx + 0x48]
  006771  26034f22         add cx, word ptr es:[bx + 0x22]
  006775  d1e1             shl cx, 1
  006777  2bc1             sub ax, cx
  006779  2b46fe           sub ax, word ptr [bp - 2]
  00677C  0346f8           add ax, word ptr [bp - 8]
  00677F  c45ef0           les bx, ptr [bp - 0x10]
  006782  268b1f           mov bx, word ptr es:[bx]
  006785  8b56ee           mov dx, word ptr [bp - 0x12]
  006788  e88be7           call 0x4f16
  00678B  c45e04           les bx, ptr [bp + 4]
  00678E  26ffb78200       push word ptr es:[bx + 0x82]
  006793  26ffb78000       push word ptr es:[bx + 0x80]
  006798  e859f1           call 0x58f4
  00679B  83c404           add sp, 4
  00679E  c45e04           les bx, ptr [bp + 4]
  0067A1  26034746         add ax, word ptr es:[bx + 0x46]
  0067A5  0146f6           add word ptr [bp - 0xa], ax
  0067A8  c45ef0           les bx, ptr [bp - 0x10]
  0067AB  268b4710         mov ax, word ptr es:[bx + 0x10]
  0067AF  268b5712         mov dx, word ptr es:[bx + 0x12]
  0067B3  8946f0           mov word ptr [bp - 0x10], ax
  0067B6  8956f2           mov word ptr [bp - 0xe], dx
  0067B9  e938fe           jmp 0x65f4
  0067BC  837eec00         cmp word ptr [bp - 0x14], 0
  0067C0  742a             je 0x67ec
  0067C2  833e5c0500       cmp word ptr [0x55c], 0
  0067C7  7d0d             jge 0x67d6
  0067C9  ff7606           push word ptr [bp + 6]
  0067CC  ff7604           push word ptr [bp + 4]
  0067CF  0e               push cs
  0067D0  e8f3fc           call 0x64c6
  0067D3  83c404           add sp, 4
  0067D6  ff7606           push word ptr [bp + 6]
  0067D9  ff7604           push word ptr [bp + 4]
  0067DC  0e               push cs
  0067DD  e876fc           call 0x6456
  0067E0  83c404           add sp, 4
  0067E3  ff7606           push word ptr [bp + 6]
  0067E6  ff7604           push word ptr [bp + 4]
  0067E9  e82efc           call 0x641a
  0067EC  5e               pop si
  0067ED  5f               pop di
  0067EE  c9               leave
  0067EF  c20400           ret 4
  0067F2  c86a0000         enter 0x6a, 0
  0067F6  50               push ax
  0067F7  57               push di
  0067F8  56               push si
  0067F9  c70662050000     mov word ptr [0x562], 0
  0067FF  c45e04           les bx, ptr [bp + 4]
  006802  268b4724         mov ax, word ptr es:[bx + 0x24]
  006806  26034748         add ax, word ptr es:[bx + 0x48]
  00680A  89469a           mov word ptr [bp - 0x66], ax
  00680D  268b4726         mov ax, word ptr es:[bx + 0x26]
  006811  894698           mov word ptr [bp - 0x68], ax
  006814  268b4760         mov ax, word ptr es:[bx + 0x60]
  006818  268b5762         mov dx, word ptr es:[bx + 0x62]
  00681C  8946f4           mov word ptr [bp - 0xc], ax
  00681F  8956f6           mov word ptr [bp - 0xa], dx
  006822  8bc2             mov ax, dx
  006824  0b46f4           or ax, word ptr [bp - 0xc]
  006827  7503             jne 0x682c
  006829  e9ae01           jmp 0x69da
  00682C  c45ef4           les bx, ptr [bp - 0xc]
  00682F  26ff770e         push word ptr es:[bx + 0xe]
  006833  26ff770c         push word ptr es:[bx + 0xc]
  006837  8d46a4           lea ax, [bp - 0x5c]
  00683A  16               push ss
  00683B  50               push ax
  00683C  9aec0d8813       lcall 0x1388, 0xdec
  006841  83c408           add sp, 8
  006844  8d46a4           lea ax, [bp - 0x5c]
  006847  50               push ax
  006848  9a84068813       lcall 0x1388, 0x684
  00684D  83c402           add sp, 2
  006850  c45ef4           les bx, ptr [bp - 0xc]
  006853  263b4706         cmp ax, word ptr es:[bx + 6]
  006857  7d0f             jge 0x6868
  006859  689b05           push 0x59b
  00685C  8d46a4           lea ax, [bp - 0x5c]
  00685F  50               push ax
  006860  9ae6058813       lcall 0x1388, 0x5e6
  006865  83c404           add sp, 4
  006868  8b4604           mov ax, word ptr [bp + 4]
  00686B  8b5606           mov dx, word ptr [bp + 6]
  00686E  057400           add ax, 0x74
  006871  52               push dx
  006872  50               push ax
  006873  c45ef4           les bx, ptr [bp - 0xc]
  006876  26ff770a         push word ptr es:[bx + 0xa]
  00687A  26ff7708         push word ptr es:[bx + 8]
  00687E  8bca             mov cx, dx
  006880  8b5698           mov dx, word ptr [bp - 0x68]
  006883  83c203           add dx, 3
  006886  895696           mov word ptr [bp - 0x6a], dx
  006889  8bf0             mov si, ax
  00688B  8b469a           mov ax, word ptr [bp - 0x66]
  00688E  2bdb             sub bx, bx
  006890  8bf9             mov di, cx
  006892  e881e6           call 0x4f16
  006895  c45ef4           les bx, ptr [bp - 0xc]
  006898  268b4702         mov ax, word ptr es:[bx + 2]
  00689C  03469a           add ax, word ptr [bp - 0x66]
  00689F  8946fc           mov word ptr [bp - 4], ax
  0068A2  8b4698           mov ax, word ptr [bp - 0x68]
  0068A5  8946f8           mov word ptr [bp - 8], ax
  0068A8  268b4f04         mov cx, word ptr es:[bx + 4]
  0068AC  83c106           add cx, 6
  0068AF  894ea0           mov word ptr [bp - 0x60], cx
  0068B2  c45e04           les bx, ptr [bp + 4]
  0068B5  26ffb78200       push word ptr es:[bx + 0x82]
  0068BA  26ffb78000       push word ptr es:[bx + 0x80]
  0068BF  e832f0           call 0x58f4
  0068C2  83c404           add sp, 4
  0068C5  050500           add ax, 5
  0068C8  89469c           mov word ptr [bp - 0x64], ax
  0068CB  ff36fa3a         push word ptr [0x3afa]
  0068CF  ff36f83a         push word ptr [0x3af8]
  0068D3  ff36f63a         push word ptr [0x3af6]
  0068D7  ff36f43a         push word ptr [0x3af4]
  0068DB  034698           add ax, word ptr [bp - 0x68]
  0068DE  48               dec ax
  0068DF  50               push ax
  0068E0  c45e04           les bx, ptr [bp + 4]
  0068E3  268a4776         mov al, byte ptr es:[bx + 0x76]
  0068E7  50               push ax
  0068E8  8b46fc           mov ax, word ptr [bp - 4]
  0068EB  8b5ea0           mov bx, word ptr [bp - 0x60]
  0068EE  03d8             add bx, ax
  0068F0  8d5fff           lea bx, [bx - 1]
  0068F3  8b5698           mov dx, word ptr [bp - 0x68]
  0068F6  9a0c00860c       lcall 0xc86, 0xc
  0068FB  8b46fc           mov ax, word ptr [bp - 4]
  0068FE  40               inc ax
  0068FF  40               inc ax
  006900  8946fe           mov word ptr [bp - 2], ax
  006903  8b4ea0           mov cx, word ptr [bp - 0x60]
  006906  83e904           sub cx, 4
  006909  894ea2           mov word ptr [bp - 0x5e], cx
  00690C  8b5698           mov dx, word ptr [bp - 0x68]
  00690F  42               inc dx
  006910  42               inc dx
  006911  8956fa           mov word ptr [bp - 6], dx
  006914  8b5e9c           mov bx, word ptr [bp - 0x64]
  006917  83eb04           sub bx, 4
  00691A  895e9e           mov word ptr [bp - 0x62], bx
  00691D  ff36fa3a         push word ptr [0x3afa]
  006921  ff36f83a         push word ptr [0x3af8]
  006925  ff36f63a         push word ptr [0x3af6]
  006929  ff36f43a         push word ptr [0x3af4]
  00692D  53               push bx
  00692E  c45e04           les bx, ptr [bp + 4]
  006931  26ff7710         push word ptr es:[bx + 0x10]
  006935  26ff7712         push word ptr es:[bx + 0x12]
  006939  26ff7714         push word ptr es:[bx + 0x14]
  00693D  268a473c         mov al, byte ptr es:[bx + 0x3c]
  006941  50               push ax
  006942  268a473e         mov al, byte ptr es:[bx + 0x3e]
  006946  50               push ax
  006947  6a00             push 0
  006949  6a00             push 0
  00694B  8bd9             mov bx, cx
  00694D  8b46fe           mov ax, word ptr [bp - 2]
  006950  e8c7e3           call 0x4d1a
  006953  c45ef4           les bx, ptr [bp - 0xc]
  006956  26f60780         test byte ptr es:[bx], 0x80
  00695A  744e             je 0x69aa
  00695C  57               push di
  00695D  56               push si
  00695E  26ff770e         push word ptr es:[bx + 0xe]
  006962  26ff770c         push word ptr es:[bx + 0xc]
  006966  e8fbe4           call 0x4e64
  006969  40               inc ax
  00696A  40               inc ax
  00696B  8946a2           mov word ptr [bp - 0x5e], ax
  00696E  ff36fa3a         push word ptr [0x3afa]
  006972  ff36f83a         push word ptr [0x3af8]
  006976  ff36f63a         push word ptr [0x3af6]
  00697A  ff36f43a         push word ptr [0x3af4]
  00697E  ff769e           push word ptr [bp - 0x62]
  006981  c45e04           les bx, ptr [bp + 4]
  006984  26ff7710         push word ptr es:[bx + 0x10]
  006988  26ff7712         push word ptr es:[bx + 0x12]
  00698C  26ff7714         push word ptr es:[bx + 0x14]
  006990  268a4740         mov al, byte ptr es:[bx + 0x40]
  006994  50               push ax
  006995  268a4742         mov al, byte ptr es:[bx + 0x42]
  006999  50               push ax
  00699A  6a00             push 0
  00699C  6a00             push 0
  00699E  8b46fe           mov ax, word ptr [bp - 2]
  0069A1  8b56fa           mov dx, word ptr [bp - 6]
  0069A4  8b5ea2           mov bx, word ptr [bp - 0x5e]
  0069A7  e870e3           call 0x4d1a
  0069AA  8b4604           mov ax, word ptr [bp + 4]
  0069AD  8b5606           mov dx, word ptr [bp + 6]
  0069B0  057400           add ax, 0x74
  0069B3  52               push dx
  0069B4  50               push ax
  0069B5  8d46a4           lea ax, [bp - 0x5c]
  0069B8  16               push ss
  0069B9  50               push ax
  0069BA  8b46fc           mov ax, word ptr [bp - 4]
  0069BD  050300           add ax, 3
  0069C0  8b56f8           mov dx, word ptr [bp - 8]
  0069C3  83c203           add dx, 3
  0069C6  2bdb             sub bx, bx
  0069C8  e84be5           call 0x4f16
  0069CB  c45ef4           les bx, ptr [bp - 0xc]
  0069CE  268b4710         mov ax, word ptr es:[bx + 0x10]
  0069D2  268b5712         mov dx, word ptr es:[bx + 0x12]
  0069D6  e943fe           jmp 0x681c
  0069D9  90               nop
  0069DA  837e9400         cmp word ptr [bp - 0x6c], 0
  0069DE  7416             je 0x69f6
  0069E0  ff7606           push word ptr [bp + 6]
  0069E3  ff7604           push word ptr [bp + 4]
  0069E6  0e               push cs
  0069E7  e86cfa           call 0x6456
  0069EA  83c404           add sp, 4
  0069ED  ff7606           push word ptr [bp + 6]
  0069F0  ff7604           push word ptr [bp + 4]
  0069F3  e824fa           call 0x641a
  0069F6  5e               pop si
  0069F7  5f               pop di
  0069F8  c9               leave
  0069F9  c20400           ret 4
  0069FC  c8160000         enter 0x16, 0
  006A00  53               push bx
  006A01  52               push dx
  006A02  50               push ax
  006A03  56               push si
  006A04  c70662050000     mov word ptr [0x562], 0
  006A0A  c45e04           les bx, ptr [bp + 4]
  006A0D  268b475e         mov ax, word ptr es:[bx + 0x5e]
  006A11  260b475c         or ax, word ptr es:[bx + 0x5c]
  006A15  7503             jne 0x6a1a
  006A17  e93602           jmp 0x6c50
  006A1A  268b475c         mov ax, word ptr es:[bx + 0x5c]
  006A1E  268b575e         mov dx, word ptr es:[bx + 0x5e]
  006A22  8946f4           mov word ptr [bp - 0xc], ax
  006A25  8956f6           mov word ptr [bp - 0xa], dx
  006A28  c45ef4           les bx, ptr [bp - 0xc]
  006A2B  268b4712         mov ax, word ptr es:[bx + 0x12]
  006A2F  260b4710         or ax, word ptr es:[bx + 0x10]
  006A33  740b             je 0x6a40
  006A35  268b4710         mov ax, word ptr es:[bx + 0x10]
  006A39  268b5712         mov dx, word ptr es:[bx + 0x12]
  006A3D  ebe3             jmp 0x6a22
  006A3F  90               nop
  006A40  268b4702         mov ax, word ptr es:[bx + 2]
  006A44  8946ea           mov word ptr [bp - 0x16], ax
  006A47  c45e04           les bx, ptr [bp + 4]
  006A4A  268b475c         mov ax, word ptr es:[bx + 0x5c]
  006A4E  268b575e         mov dx, word ptr es:[bx + 0x5e]
  006A52  8946f4           mov word ptr [bp - 0xc], ax
  006A55  8956f6           mov word ptr [bp - 0xa], dx
  006A58  268b470a         mov ax, word ptr es:[bx + 0xa]
  006A5C  8bc8             mov cx, ax
  006A5E  251000           and ax, 0x10
  006A61  3d0100           cmp ax, 1
  006A64  1bc0             sbb ax, ax
  006A66  250300           and ax, 3
  006A69  8bd0             mov dx, ax
  006A6B  26034710         add ax, word ptr es:[bx + 0x10]
  006A6F  26035712         add dx, word ptr es:[bx + 0x12]
  006A73  8956fc           mov word ptr [bp - 4], dx
  006A76  26034748         add ax, word ptr es:[bx + 0x48]
  006A7A  8946fa           mov word ptr [bp - 6], ax
  006A7D  26035746         add dx, word ptr es:[bx + 0x46]
  006A81  f6c102           test cl, 2
  006A84  7408             je 0x6a8e
  006A86  c746ee1000       mov word ptr [bp - 0x12], 0x10
  006A8B  eb1c             jmp 0x6aa9
  006A8D  90               nop
  006A8E  c45ef4           les bx, ptr [bp - 0xc]
  006A91  268b7704         mov si, word ptr es:[bx + 4]
  006A95  8bc6             mov ax, si
  006A97  d1e6             shl si, 1
  006A99  03f0             add si, ax
  006A9B  c1e602           shl si, 2
  006A9E  26c45f0c         les bx, ptr es:[bx + 0xc]
  006AA2  268b403e         mov ax, word ptr es:[bx + si + 0x3e]
  006AA6  8946ee           mov word ptr [bp - 0x12], ax
  006AA9  8b46ea           mov ax, word ptr [bp - 0x16]
  006AAC  c45ef4           les bx, ptr [bp - 0xc]
  006AAF  262b07           sub ax, word ptr es:[bx]
  006AB2  40               inc ax
  006AB3  837ee600         cmp word ptr [bp - 0x1a], 0
  006AB7  7447             je 0x6b00
  006AB9  ff36fa3a         push word ptr [0x3afa]
  006ABD  ff36f83a         push word ptr [0x3af8]
  006AC1  ff36f63a         push word ptr [0x3af6]
  006AC5  ff36f43a         push word ptr [0x3af4]
  006AC9  40               inc ax
  006ACA  40               inc ax
  006ACB  50               push ax
  006ACC  8cc0             mov ax, es
  006ACE  c47604           les si, ptr [bp + 4]
  006AD1  26ff7410         push word ptr es:[si + 0x10]
  006AD5  26ff7412         push word ptr es:[si + 0x12]
  006AD9  26ff7414         push word ptr es:[si + 0x14]
  006ADD  268a4c3c         mov cl, byte ptr es:[si + 0x3c]
  006AE1  51               push cx
  006AE2  268a4c3e         mov cl, byte ptr es:[si + 0x3e]
  006AE6  51               push cx
  006AE7  6a00             push 0
  006AE9  6a00             push 0
  006AEB  8ec0             mov es, ax
  006AED  268b17           mov dx, word ptr es:[bx]
  006AF0  0356fc           add dx, word ptr [bp - 4]
  006AF3  4a               dec dx
  006AF4  8b46fa           mov ax, word ptr [bp - 6]
  006AF7  48               dec ax
  006AF8  8b5eee           mov bx, word ptr [bp - 0x12]
  006AFB  43               inc bx
  006AFC  43               inc bx
  006AFD  e81ae2           call 0x4d1a
  006B00  8b46f6           mov ax, word ptr [bp - 0xa]
  006B03  0b46f4           or ax, word ptr [bp - 0xc]
  006B06  7503             jne 0x6b0b
  006B08  e92901           jmp 0x6c34
  006B0B  c45e04           les bx, ptr [bp + 4]
  006B0E  26f6470a02       test byte ptr es:[bx + 0xa], 2
  006B13  741f             je 0x6b34
  006B15  c45ef4           les bx, ptr [bp - 0xc]
  006B18  268b07           mov ax, word ptr es:[bx]
  006B1B  0346fc           add ax, word ptr [bp - 4]
  006B1E  50               push ax
  006B1F  6a10             push 0x10
  006B21  6a64             push 0x64
  006B23  268b4704         mov ax, word ptr es:[bx + 4]
  006B27  2bd2             sub dx, dx
  006B29  8b5efa           mov bx, word ptr [bp - 6]
  006B2C  9a08000000       lcall 0, 8
  006B31  eb23             jmp 0x6b56
  006B33  90               nop
  006B34  c45ef4           les bx, ptr [bp - 0xc]
  006B37  26ff770e         push word ptr es:[bx + 0xe]
  006B3B  26ff770c         push word ptr es:[bx + 0xc]
  006B3F  268b07           mov ax, word ptr es:[bx]
  006B42  0346fc           add ax, word ptr [bp - 4]
  006B45  50               push ax
  006B46  268b4704         mov ax, word ptr es:[bx + 4]
  006B4A  8d1ef43a         lea bx, [0x3af4]
  006B4E  8b56fa           mov dx, word ptr [bp - 6]
  006B51  9a00008f0d       lcall 0xd8f, 0
  006B56  8b46f4           mov ax, word ptr [bp - 0xc]
  006B59  8b56f6           mov dx, word ptr [bp - 0xa]
  006B5C  c45e04           les bx, ptr [bp + 4]
  006B5F  26394750         cmp word ptr es:[bx + 0x50], ax
  006B63  7550             jne 0x6bb5
  006B65  26395752         cmp word ptr es:[bx + 0x52], dx
  006B69  754a             jne 0x6bb5
  006B6B  837ee800         cmp word ptr [bp - 0x18], 0
  006B6F  7444             je 0x6bb5
  006B71  26f6470a80       test byte ptr es:[bx + 0xa], 0x80
  006B76  743d             je 0x6bb5
  006B78  268b4f66         mov cx, word ptr es:[bx + 0x66]
  006B7C  260b4f64         or cx, word ptr es:[bx + 0x64]
  006B80  7433             je 0x6bb5
  006B82  ff36fa3a         push word ptr [0x3afa]
  006B86  ff36f83a         push word ptr [0x3af8]
  006B8A  ff36f63a         push word ptr [0x3af6]
  006B8E  ff36f43a         push word ptr [0x3af4]
  006B92  8ec2             mov es, dx
  006B94  8bd8             mov bx, ax
  006B96  268b07           mov ax, word ptr es:[bx]
  006B99  0346fc           add ax, word ptr [bp - 4]
  006B9C  8bc8             mov cx, ax
  006B9E  051000           add ax, 0x10
  006BA1  50               push ax
  006BA2  6a0f             push 0xf
  006BA4  8b46fa           mov ax, word ptr [bp - 6]
  006BA7  8bd8             mov bx, ax
  006BA9  83c310           add bx, 0x10
  006BAC  48               dec ax
  006BAD  8bd1             mov dx, cx
  006BAF  4a               dec dx
  006BB0  9a0c00860c       lcall 0xc86, 0xc
  006BB5  837ee400         cmp word ptr [bp - 0x1c], 0
  006BB9  7465             je 0x6c20
  006BBB  c45ef4           les bx, ptr [bp - 0xc]
  006BBE  268b470a         mov ax, word ptr es:[bx + 0xa]
  006BC2  260b4708         or ax, word ptr es:[bx + 8]
  006BC6  7458             je 0x6c20
  006BC8  c47604           les si, ptr [bp + 4]
  006BCB  268b4446         mov ax, word ptr es:[si + 0x46]
  006BCF  2603442e         add ax, word ptr es:[si + 0x2e]
  006BD3  26034432         add ax, word ptr es:[si + 0x32]
  006BD7  0346fa           add ax, word ptr [bp - 6]
  006BDA  8946f2           mov word ptr [bp - 0xe], ax
  006BDD  26ffb48200       push word ptr es:[si + 0x82]
  006BE2  26ffb48000       push word ptr es:[si + 0x80]
  006BE7  e80aed           call 0x58f4
  006BEA  83c404           add sp, 4
  006BED  d1f8             sar ax, 1
  006BEF  c45ef4           les bx, ptr [bp - 0xc]
  006BF2  268b4f02         mov cx, word ptr es:[bx + 2]
  006BF6  262b0f           sub cx, word ptr es:[bx]
  006BF9  d1f9             sar cx, 1
  006BFB  2bc8             sub cx, ax
  006BFD  26030f           add cx, word ptr es:[bx]
  006C00  034efc           add cx, word ptr [bp - 4]
  006C03  8b4604           mov ax, word ptr [bp + 4]
  006C06  8b5606           mov dx, word ptr [bp + 6]
  006C09  057400           add ax, 0x74
  006C0C  52               push dx
  006C0D  50               push ax
  006C0E  26ff770a         push word ptr es:[bx + 0xa]
  006C12  26ff7708         push word ptr es:[bx + 8]
  006C16  8b46f2           mov ax, word ptr [bp - 0xe]
  006C19  8bd1             mov dx, cx
  006C1B  2bdb             sub bx, bx
  006C1D  e8f6e2           call 0x4f16
  006C20  c45ef4           les bx, ptr [bp - 0xc]
  006C23  268b4710         mov ax, word ptr es:[bx + 0x10]
  006C27  268b5712         mov dx, word ptr es:[bx + 0x12]
  006C2B  8946f4           mov word ptr [bp - 0xc], ax
  006C2E  8956f6           mov word ptr [bp - 0xa], dx
  006C31  e9ccfe           jmp 0x6b00
  006C34  837ee600         cmp word ptr [bp - 0x1a], 0
  006C38  7416             je 0x6c50
  006C3A  ff7606           push word ptr [bp + 6]
  006C3D  ff7604           push word ptr [bp + 4]
  006C40  0e               push cs
  006C41  e812f8           call 0x6456
  006C44  83c404           add sp, 4
  006C47  ff7606           push word ptr [bp + 6]
  006C4A  ff7604           push word ptr [bp + 4]
  006C4D  e8caf7           call 0x641a
  006C50  5e               pop si
  006C51  c9               leave
  006C52  c20400           ret 4
  006C55  90               nop

; ---- _popup_box_draw  file 0x006C56..0x006E6C  seg 0x33D:0x2286  (popup.obj) ----
  006C56  c8180000         enter 0x18, 0
  006C5A  57               push di
  006C5B  56               push si
  006C5C  c746f00000       mov word ptr [bp - 0x10], 0
  006C61  8b4608           mov ax, word ptr [bp + 8]
  006C64  0b4606           or ax, word ptr [bp + 6]
  006C67  7405             je 0x6c6e
  006C69  c746f00100       mov word ptr [bp - 0x10], 1
  006C6E  837ef000         cmp word ptr [bp - 0x10], 0
  006C72  7418             je 0x6c8c
  006C74  c45e06           les bx, ptr [bp + 6]
  006C77  268b4710         mov ax, word ptr es:[bx + 0x10]
  006C7B  8946f6           mov word ptr [bp - 0xa], ax
  006C7E  268b4712         mov ax, word ptr es:[bx + 0x12]
  006C82  8946f2           mov word ptr [bp - 0xe], ax
  006C85  268b4714         mov ax, word ptr es:[bx + 0x14]
  006C89  eb10             jmp 0x6c9b
  006C8B  90               nop
  006C8C  8b460a           mov ax, word ptr [bp + 0xa]
  006C8F  8946f6           mov word ptr [bp - 0xa], ax
  006C92  8b460c           mov ax, word ptr [bp + 0xc]
  006C95  8946f2           mov word ptr [bp - 0xe], ax
  006C98  8b460e           mov ax, word ptr [bp + 0xe]
  006C9B  8946f4           mov word ptr [bp - 0xc], ax
  006C9E  8b4608           mov ax, word ptr [bp + 8]
  006CA1  0b4606           or ax, word ptr [bp + 6]
  006CA4  740d             je 0x6cb3
  006CA6  c45e06           les bx, ptr [bp + 6]
  006CA9  26f6470a10       test byte ptr es:[bx + 0xa], 0x10
  006CAE  7403             je 0x6cb3
  006CB0  e9ef00           jmp 0x6da2
  006CB3  ff36fa3a         push word ptr [0x3afa]
  006CB7  ff36f83a         push word ptr [0x3af8]
  006CBB  ff36f63a         push word ptr [0x3af6]
  006CBF  ff36f43a         push word ptr [0x3af4]
  006CC3  8b4610           mov ax, word ptr [bp + 0x10]
  006CC6  03460c           add ax, word ptr [bp + 0xc]
  006CC9  8bc8             mov cx, ax
  006CCB  48               dec ax
  006CCC  50               push ax
  006CCD  6a00             push 0
  006CCF  8b460a           mov ax, word ptr [bp + 0xa]
  006CD2  8b5e0e           mov bx, word ptr [bp + 0xe]
  006CD5  03d8             add bx, ax
  006CD7  8bd3             mov dx, bx
  006CD9  8d5fff           lea bx, [bx - 1]
  006CDC  8bf2             mov si, dx
  006CDE  8b560c           mov dx, word ptr [bp + 0xc]
  006CE1  8bf9             mov di, cx
  006CE3  9a0c00860c       lcall 0xc86, 0xc
  006CE8  ff36fa3a         push word ptr [0x3afa]
  006CEC  ff36f83a         push word ptr [0x3af8]
  006CF0  ff36f63a         push word ptr [0x3af6]
  006CF4  ff36f43a         push word ptr [0x3af4]
  006CF8  8d45fe           lea ax, [di - 2]
  006CFB  50               push ax
  006CFC  a04405           mov al, byte ptr [0x544]
  006CFF  50               push ax
  006D00  8d5cfe           lea bx, [si - 2]
  006D03  8b460a           mov ax, word ptr [bp + 0xa]
  006D06  40               inc ax
  006D07  8b560c           mov dx, word ptr [bp + 0xc]
  006D0A  42               inc dx
  006D0B  9a0c00860c       lcall 0xc86, 0xc
  006D10  ff36fa3a         push word ptr [0x3afa]
  006D14  ff36f83a         push word ptr [0x3af8]
  006D18  ff36f63a         push word ptr [0x3af6]
  006D1C  ff36f43a         push word ptr [0x3af4]
  006D20  a04805           mov al, byte ptr [0x548]
  006D23  50               push ax
  006D24  8b460a           mov ax, word ptr [bp + 0xa]
  006D27  40               inc ax
  006D28  40               inc ax
  006D29  8d5dfd           lea bx, [di - 3]
  006D2C  8b560c           mov dx, word ptr [bp + 0xc]
  006D2F  42               inc dx
  006D30  42               inc dx
  006D31  8bf8             mov di, ax
  006D33  8956ee           mov word ptr [bp - 0x12], dx
  006D36  895eec           mov word ptr [bp - 0x14], bx
  006D39  9a0000800c       lcall 0xc80, 0
  006D3E  ff36fa3a         push word ptr [0x3afa]
  006D42  ff36f83a         push word ptr [0x3af8]
  006D46  ff36f63a         push word ptr [0x3af6]
  006D4A  ff36f43a         push word ptr [0x3af4]
  006D4E  a04605           mov al, byte ptr [0x546]
  006D51  50               push ax
  006D52  8d44fd           lea ax, [si - 3]
  006D55  8b56ee           mov dx, word ptr [bp - 0x12]
  006D58  8b5eec           mov bx, word ptr [bp - 0x14]
  006D5B  8bf0             mov si, ax
  006D5D  9a0000800c       lcall 0xc80, 0
  006D62  ff36fa3a         push word ptr [0x3afa]
  006D66  ff36f83a         push word ptr [0x3af8]
  006D6A  ff36f63a         push word ptr [0x3af6]
  006D6E  ff36f43a         push word ptr [0x3af4]
  006D72  a04605           mov al, byte ptr [0x546]
  006D75  50               push ax
  006D76  8bd6             mov dx, si
  006D78  8bc7             mov ax, di
  006D7A  8b5eee           mov bx, word ptr [bp - 0x12]
  006D7D  9a0600790c       lcall 0xc79, 6
  006D82  ff36fa3a         push word ptr [0x3afa]
  006D86  ff36f83a         push word ptr [0x3af8]
  006D8A  ff36f63a         push word ptr [0x3af6]
  006D8E  ff36f43a         push word ptr [0x3af4]
  006D92  a04805           mov al, byte ptr [0x548]
  006D95  50               push ax
  006D96  8bc7             mov ax, di
  006D98  8bd6             mov dx, si
  006D9A  8b5eec           mov bx, word ptr [bp - 0x14]
  006D9D  9a0600790c       lcall 0xc79, 6
  006DA2  837ef000         cmp word ptr [bp - 0x10], 0
  006DA6  7414             je 0x6dbc
  006DA8  c45e06           les bx, ptr [bp + 6]
  006DAB  268a470a         mov al, byte ptr es:[bx + 0xa]
  006DAF  251000           and ax, 0x10
  006DB2  3d0100           cmp ax, 1
  006DB5  1bc0             sbb ax, ax
  006DB7  250300           and ax, 3
  006DBA  eb03             jmp 0x6dbf
  006DBC  b80300           mov ax, 3
  006DBF  03460a           add ax, word ptr [bp + 0xa]
  006DC2  8946fe           mov word ptr [bp - 2], ax
  006DC5  837ef000         cmp word ptr [bp - 0x10], 0
  006DC9  7415             je 0x6de0
  006DCB  c45e06           les bx, ptr [bp + 6]
  006DCE  268a470a         mov al, byte ptr es:[bx + 0xa]
  006DD2  251000           and ax, 0x10
  006DD5  3d0100           cmp ax, 1
  006DD8  1bc0             sbb ax, ax
  006DDA  250300           and ax, 3
  006DDD  eb04             jmp 0x6de3
  006DDF  90               nop
  006DE0  b80300           mov ax, 3
  006DE3  03460c           add ax, word ptr [bp + 0xc]
  006DE6  8946fc           mov word ptr [bp - 4], ax
  006DE9  837ef000         cmp word ptr [bp - 0x10], 0
  006DED  7415             je 0x6e04
  006DEF  c45e06           les bx, ptr [bp + 6]
  006DF2  268a470a         mov al, byte ptr es:[bx + 0xa]
  006DF6  251000           and ax, 0x10
  006DF9  3d0100           cmp ax, 1
  006DFC  1bc0             sbb ax, ax
  006DFE  250300           and ax, 3
  006E01  eb04             jmp 0x6e07
  006E03  90               nop
  006E04  b80300           mov ax, 3
  006E07  d1e0             shl ax, 1
  006E09  2b460e           sub ax, word ptr [bp + 0xe]
  006E0C  f7d8             neg ax
  006E0E  8946fa           mov word ptr [bp - 6], ax
  006E11  837ef000         cmp word ptr [bp - 0x10], 0
  006E15  7415             je 0x6e2c
  006E17  c45e06           les bx, ptr [bp + 6]
  006E1A  268a470a         mov al, byte ptr es:[bx + 0xa]
  006E1E  251000           and ax, 0x10
  006E21  3d0100           cmp ax, 1
  006E24  1bc0             sbb ax, ax
  006E26  250300           and ax, 3
  006E29  eb04             jmp 0x6e2f
  006E2B  90               nop
  006E2C  b80300           mov ax, 3
  006E2F  d1e0             shl ax, 1
  006E31  2b4610           sub ax, word ptr [bp + 0x10]
  006E34  f7d8             neg ax
  006E36  ff36fa3a         push word ptr [0x3afa]
  006E3A  ff36f83a         push word ptr [0x3af8]
  006E3E  ff36f63a         push word ptr [0x3af6]
  006E42  ff36f43a         push word ptr [0x3af4]
  006E46  50               push ax
  006E47  ff76f6           push word ptr [bp - 0xa]
  006E4A  ff76f2           push word ptr [bp - 0xe]
  006E4D  ff76f4           push word ptr [bp - 0xc]
  006E50  a03c05           mov al, byte ptr [0x53c]
  006E53  50               push ax
  006E54  a03e05           mov al, byte ptr [0x53e]
  006E57  50               push ax
  006E58  6a00             push 0
  006E5A  6a00             push 0
  006E5C  8b46fe           mov ax, word ptr [bp - 2]
  006E5F  8b56fc           mov dx, word ptr [bp - 4]
  006E62  8b5efa           mov bx, word ptr [bp - 6]
  006E65  e8b2de           call 0x4d1a
  006E68  5e               pop si
  006E69  5f               pop di
  006E6A  c9               leave
  006E6B  cb               retf

; ---- _popup_draw  file 0x006E6C..0x006F3C  seg 0x33D:0x249c  (popup.obj) ----
  006E6C  c85e0000         enter 0x5e, 0
  006E70  c746aa0100       mov word ptr [bp - 0x56], 1
  006E75  ff7608           push word ptr [bp + 8]
  006E78  ff7606           push word ptr [bp + 6]
  006E7B  e826f0           call 0x5ea4
  006E7E  0bc0             or ax, ax
  006E80  7403             je 0x6e85
  006E82  e9b100           jmp 0x6f36
  006E85  a36205           mov word ptr [0x562], ax
  006E88  c45e06           les bx, ptr [bp + 6]
  006E8B  268b4710         mov ax, word ptr es:[bx + 0x10]
  006E8F  8946a8           mov word ptr [bp - 0x58], ax
  006E92  268b4712         mov ax, word ptr es:[bx + 0x12]
  006E96  8946a6           mov word ptr [bp - 0x5a], ax
  006E99  268b4714         mov ax, word ptr es:[bx + 0x14]
  006E9D  8946a4           mov word ptr [bp - 0x5c], ax
  006EA0  268b4716         mov ax, word ptr es:[bx + 0x16]
  006EA4  8946a2           mov word ptr [bp - 0x5e], ax
  006EA7  833e5c0500       cmp word ptr [0x55c], 0
  006EAC  7c09             jl 0x6eb7
  006EAE  06               push es
  006EAF  53               push bx
  006EB0  0e               push cs
  006EB1  e812f6           call 0x64c6
  006EB4  83c404           add sp, 4
  006EB7  ff76a2           push word ptr [bp - 0x5e]
  006EBA  ff76a4           push word ptr [bp - 0x5c]
  006EBD  ff76a6           push word ptr [bp - 0x5a]
  006EC0  ff76a8           push word ptr [bp - 0x58]
  006EC3  ff7608           push word ptr [bp + 8]
  006EC6  ff7606           push word ptr [bp + 6]
  006EC9  0e               push cs
  006ECA  e889fd           call 0x6c56
  006ECD  83c40c           add sp, 0xc
  006ED0  ff7608           push word ptr [bp + 8]
  006ED3  ff7606           push word ptr [bp + 6]
  006ED6  b80100           mov ax, 1
  006ED9  99               cdq
  006EDA  8bd8             mov bx, ax
  006EDC  e81dfb           call 0x69fc
  006EDF  c70662050000     mov word ptr [0x562], 0
  006EE5  ff7608           push word ptr [bp + 8]
  006EE8  ff7606           push word ptr [bp + 6]
  006EEB  b80100           mov ax, 1
  006EEE  e885ec           call 0x5b76
  006EF1  ff7608           push word ptr [bp + 8]
  006EF4  ff7606           push word ptr [bp + 6]
  006EF7  2bc0             sub ax, ax
  006EF9  e85ef6           call 0x655a
  006EFC  ff7608           push word ptr [bp + 8]
  006EFF  ff7606           push word ptr [bp + 6]
  006F02  2bc0             sub ax, ax
  006F04  e8ebf8           call 0x67f2
  006F07  833e5c0500       cmp word ptr [0x55c], 0
  006F0C  7d0d             jge 0x6f1b
  006F0E  ff7608           push word ptr [bp + 8]
  006F11  ff7606           push word ptr [bp + 6]
  006F14  0e               push cs
  006F15  e8aef5           call 0x64c6
  006F18  83c404           add sp, 4
  006F1B  ff7608           push word ptr [bp + 8]
  006F1E  ff7606           push word ptr [bp + 6]
  006F21  0e               push cs
  006F22  e831f5           call 0x6456
  006F25  83c404           add sp, 4
  006F28  ff7608           push word ptr [bp + 8]
  006F2B  ff7606           push word ptr [bp + 6]
  006F2E  e8e9f4           call 0x641a
  006F31  c746aa0000       mov word ptr [bp - 0x56], 0
  006F36  8b46aa           mov ax, word ptr [bp - 0x56]
  006F39  c9               leave
  006F3A  cb               retf
  006F3B  90               nop

; ---- _popup_set_active_sprite  file 0x006F3C..0x006F5E  seg 0x33D:0x256c  (popup.obj) ----
  006F3C  55               push bp
  006F3D  8bec             mov bp, sp
  006F3F  8b460a           mov ax, word ptr [bp + 0xa]
  006F42  8b560c           mov dx, word ptr [bp + 0xc]
  006F45  c45e06           les bx, ptr [bp + 6]
  006F48  26894750         mov word ptr es:[bx + 0x50], ax
  006F4C  26895752         mov word ptr es:[bx + 0x52], dx
  006F50  06               push es
  006F51  53               push bx
  006F52  2bc0             sub ax, ax
  006F54  ba0100           mov dx, 1
  006F57  8bda             mov bx, dx
  006F59  e8a0fa           call 0x69fc
  006F5C  c9               leave
  006F5D  cb               retf

; ---- @popup_exec  file 0x006F5E..0x007A62  seg 0x33D:0x258e  (popup.obj) ----
  006F5E  c8380000         enter 0x38, 0
  006F62  56               push si
  006F63  c746f40100       mov word ptr [bp - 0xc], 1
  006F68  833e5c0507       cmp word ptr [0x55c], 7
  006F6D  7e05             jle 0x6f74
  006F6F  b80100           mov ax, 1
  006F72  eb02             jmp 0x6f76
  006F74  2bc0             sub ax, ax
  006F76  8946e0           mov word ptr [bp - 0x20], ax
  006F79  2bc0             sub ax, ax
  006F7B  8946fe           mov word ptr [bp - 2], ax
  006F7E  a36805           mov word ptr [0x568], ax
  006F81  c45e06           les bx, ptr [bp + 6]
  006F84  26f6470a10       test byte ptr es:[bx + 0xa], 0x10
  006F89  7409             je 0x6f94
  006F8B  c7068a050100     mov word ptr [0x58a], 1
  006F91  eb04             jmp 0x6f97
  006F93  90               nop
  006F94  a38a05           mov word ptr [0x58a], ax
  006F97  a36205           mov word ptr [0x562], ax
  006F9A  9a00004208       lcall 0x842, 0
  006F9F  eb06             jmp 0x6fa7
  006FA1  90               nop
  006FA2  9a1800af0b       lcall 0xbaf, 0x18
  006FA7  9a0400af0b       lcall 0xbaf, 4
  006FAC  0bc0             or ax, ax
  006FAE  75f2             jne 0x6fa2
  006FB0  c45e06           les bx, ptr [bp + 6]
  006FB3  26f6470a04       test byte ptr es:[bx + 0xa], 4
  006FB8  742e             je 0x6fe8
  006FBA  8946de           mov word ptr [bp - 0x22], ax
  006FBD  eb1d             jmp 0x6fdc
  006FBF  90               nop
  006FC0  8bc8             mov cx, ax
  006FC2  2aed             sub ch, ch
  006FC4  ba0100           mov dx, 1
  006FC7  d3e2             shl dx, cl
  006FC9  23165405         and dx, word ptr [0x554]
  006FCD  52               push dx
  006FCE  40               inc ax
  006FCF  50               push ax
  006FD0  06               push es
  006FD1  53               push bx
  006FD2  0e               push cs
  006FD3  e8c2e3           call 0x5398
  006FD6  83c408           add sp, 8
  006FD9  ff46de           inc word ptr [bp - 0x22]
  006FDC  8b46de           mov ax, word ptr [bp - 0x22]
  006FDF  c45e06           les bx, ptr [bp + 6]
  006FE2  26394702         cmp word ptr es:[bx + 2], ax
  006FE6  7fd8             jg 0x6fc0
  006FE8  26c7070000       mov word ptr es:[bx], 0
  006FED  26ffb78200       push word ptr es:[bx + 0x82]
  006FF2  26ffb78000       push word ptr es:[bx + 0x80]
  006FF7  e8fae8           call 0x58f4
  006FFA  83c404           add sp, 4
  006FFD  c45e06           les bx, ptr [bp + 6]
  007000  26034746         add ax, word ptr es:[bx + 0x46]
  007004  8946f8           mov word ptr [bp - 8], ax
  007007  833e5c0500       cmp word ptr [0x55c], 0
  00700C  7c05             jl 0x7013
  00700E  06               push es
  00700F  53               push bx
  007010  e80dda           call 0x4a20
  007013  833e5e0500       cmp word ptr [0x55e], 0
  007018  7c09             jl 0x7023
  00701A  ff7608           push word ptr [bp + 8]
  00701D  ff7606           push word ptr [bp + 6]
  007020  e87dda           call 0x4aa0
  007023  833e600500       cmp word ptr [0x560], 0
  007028  7c09             jl 0x7033
  00702A  ff7608           push word ptr [bp + 8]
  00702D  ff7606           push word ptr [bp + 6]
  007030  e897da           call 0x4aca
  007033  ff7608           push word ptr [bp + 8]
  007036  ff7606           push word ptr [bp + 6]
  007039  e8b8da           call 0x4af4
  00703C  c45e06           les bx, ptr [bp + 6]
  00703F  268b476a         mov ax, word ptr es:[bx + 0x6a]
  007043  260b4768         or ax, word ptr es:[bx + 0x68]
  007047  7420             je 0x7069
  007049  268b4768         mov ax, word ptr es:[bx + 0x68]
  00704D  268b576a         mov dx, word ptr es:[bx + 0x6a]
  007051  8946ea           mov word ptr [bp - 0x16], ax
  007054  8956ec           mov word ptr [bp - 0x14], dx
  007057  8ec2             mov es, dx
  007059  8bd8             mov bx, ax
  00705B  268b4710         mov ax, word ptr es:[bx + 0x10]
  00705F  268b5712         mov dx, word ptr es:[bx + 0x12]
  007063  8946e2           mov word ptr [bp - 0x1e], ax
  007066  8956e4           mov word ptr [bp - 0x1c], dx
  007069  ff7608           push word ptr [bp + 8]
  00706C  ff7606           push word ptr [bp + 6]
  00706F  e832ee           call 0x5ea4
  007072  0bc0             or ax, ax
  007074  7403             je 0x7079
  007076  e97d09           jmp 0x79f6
  007079  39066e05         cmp word ptr [0x56e], ax
  00707D  742c             je 0x70ab
  00707F  ff36fa3a         push word ptr [0x3afa]
  007083  ff36f83a         push word ptr [0x3af8]
  007087  ff36f63a         push word ptr [0x3af6]
  00708B  ff36f43a         push word ptr [0x3af4]
  00708F  ff36023b         push word ptr [0x3b02]
  007093  ff36003b         push word ptr [0x3b00]
  007097  ff36fe3a         push word ptr [0x3afe]
  00709B  ff36fc3a         push word ptr [0x3afc]
  00709F  68c800           push 0xc8
  0070A2  99               cdq
  0070A3  bb4001           mov bx, 0x140
  0070A6  9a00004c0c       lcall 0xc4c, 0
  0070AB  c45e06           les bx, ptr [bp + 6]
  0070AE  26f6470a08       test byte ptr es:[bx + 0xa], 8
  0070B3  7520             jne 0x70d5
  0070B5  26ff7718         push word ptr es:[bx + 0x18]
  0070B9  26ff771a         push word ptr es:[bx + 0x1a]
  0070BD  26ff771c         push word ptr es:[bx + 0x1c]
  0070C1  26ff771e         push word ptr es:[bx + 0x1e]
  0070C5  8d1ef43a         lea bx, [0x3af4]
  0070C9  b8f8ff           mov ax, 0xfff8
  0070CC  99               cdq
  0070CD  9a0e009d0c       lcall 0xc9d, 0xe
  0070D2  8946e8           mov word ptr [bp - 0x18], ax
  0070D5  c746f60100       mov word ptr [bp - 0xa], 1
  0070DA  9a0600180d       lcall 0xd18, 6
  0070DF  8946f0           mov word ptr [bp - 0x10], ax
  0070E2  8956f2           mov word ptr [bp - 0xe], dx
  0070E5  9a2a00210c       lcall 0xc21, 0x2a
  0070EA  833e640500       cmp word ptr [0x564], 0
  0070EF  741d             je 0x710e
  0070F1  a1643c           mov ax, word ptr [0x3c64]
  0070F4  8946dc           mov word ptr [bp - 0x24], ax
  0070F7  c706643c0000     mov word ptr [0x3c64], 0
  0070FD  6800a0           push 0xa000
  007100  6800fc           push 0xfc00
  007103  9a0a00700d       lcall 0xd70, 0xa
  007108  8b46dc           mov ax, word ptr [bp - 0x24]
  00710B  a3643c           mov word ptr [0x3c64], ax
  00710E  c45e06           les bx, ptr [bp + 6]
  007111  26f6470a20       test byte ptr es:[bx + 0xa], 0x20
  007116  740c             je 0x7124
  007118  06               push es
  007119  53               push bx
  00711A  0e               push cs
  00711B  e84efd           call 0x6e6c
  00711E  83c404           add sp, 4
  007121  e9d208           jmp 0x79f6
  007124  9a04000000       lcall 0, 4
  007129  2bc0             sub ax, ax
  00712B  9a4200210c       lcall 0xc21, 0x42
  007130  c746d40000       mov word ptr [bp - 0x2c], 0
  007135  833e320700       cmp word ptr [0x732], 0
  00713A  7503             jne 0x713f
  00713C  e96901           jmp 0x72a8
  00713F  833e2c0700       cmp word ptr [0x72c], 0
  007144  7503             jne 0x7149
  007146  e95f01           jmp 0x72a8
  007149  a12407           mov ax, word ptr [0x724]
  00714C  c45e06           les bx, ptr [bp + 6]
  00714F  26394710         cmp word ptr es:[bx + 0x10], ax
  007153  7f22             jg 0x7177
  007155  8b0e2607         mov cx, word ptr [0x726]
  007159  26394f12         cmp word ptr es:[bx + 0x12], cx
  00715D  7f18             jg 0x7177
  00715F  268b5714         mov dx, word ptr es:[bx + 0x14]
  007163  26035710         add dx, word ptr es:[bx + 0x10]
  007167  3bd0             cmp dx, ax
  007169  7e0c             jle 0x7177
  00716B  268b4716         mov ax, word ptr es:[bx + 0x16]
  00716F  26034712         add ax, word ptr es:[bx + 0x12]
  007173  3bc1             cmp ax, cx
  007175  7f1d             jg 0x7194
  007177  c746fe0100       mov word ptr [bp - 2], 1
  00717C  2bc0             sub ax, ax
  00717E  2689474e         mov word ptr es:[bx + 0x4e], ax
  007182  2689474c         mov word ptr es:[bx + 0x4c], ax
  007186  50               push ax
  007187  50               push ax
  007188  06               push es
  007189  53               push bx
  00718A  0e               push cs
  00718B  e8aefd           call 0x6f3c
  00718E  83c408           add sp, 8
  007191  e91401           jmp 0x72a8
  007194  268b4756         mov ax, word ptr es:[bx + 0x56]
  007198  260b4754         or ax, word ptr es:[bx + 0x54]
  00719C  747c             je 0x721a
  00719E  268b4754         mov ax, word ptr es:[bx + 0x54]
  0071A2  268b5756         mov dx, word ptr es:[bx + 0x56]
  0071A6  8946d0           mov word ptr [bp - 0x30], ax
  0071A9  8956d2           mov word ptr [bp - 0x2e], dx
  0071AC  268b4726         mov ax, word ptr es:[bx + 0x26]
  0071B0  8946ee           mov word ptr [bp - 0x12], ax
  0071B3  c746da0000       mov word ptr [bp - 0x26], 0
  0071B8  8bc2             mov ax, dx
  0071BA  0b46d0           or ax, word ptr [bp - 0x30]
  0071BD  7503             jne 0x71c2
  0071BF  e9db00           jmp 0x729d
  0071C2  8b46ee           mov ax, word ptr [bp - 0x12]
  0071C5  48               dec ax
  0071C6  3b062607         cmp ax, word ptr [0x726]
  0071CA  7f2c             jg 0x71f8
  0071CC  8b46f8           mov ax, word ptr [bp - 8]
  0071CF  0346ee           add ax, word ptr [bp - 0x12]
  0071D2  48               dec ax
  0071D3  3b062607         cmp ax, word ptr [0x726]
  0071D7  7e1f             jle 0x71f8
  0071D9  c45ed0           les bx, ptr [bp - 0x30]
  0071DC  26f60701         test byte ptr es:[bx], 1
  0071E0  7516             jne 0x71f8
  0071E2  c47606           les si, ptr [bp + 6]
  0071E5  8bc3             mov ax, bx
  0071E7  2689444c         mov word ptr es:[si + 0x4c], ax
  0071EB  2689544e         mov word ptr es:[si + 0x4e], dx
  0071EF  b80100           mov ax, 1
  0071F2  8946da           mov word ptr [bp - 0x26], ax
  0071F5  8946fe           mov word ptr [bp - 2], ax
  0071F8  8b46f8           mov ax, word ptr [bp - 8]
  0071FB  0146ee           add word ptr [bp - 0x12], ax
  0071FE  c45ed0           les bx, ptr [bp - 0x30]
  007201  268b4710         mov ax, word ptr es:[bx + 0x10]
  007205  268b5712         mov dx, word ptr es:[bx + 0x12]
  007209  8946d0           mov word ptr [bp - 0x30], ax
  00720C  8956d2           mov word ptr [bp - 0x2e], dx
  00720F  837eda00         cmp word ptr [bp - 0x26], 0
  007213  74a3             je 0x71b8
  007215  e98500           jmp 0x729d
  007218  90               nop
  007219  90               nop
  00721A  268b475e         mov ax, word ptr es:[bx + 0x5e]
  00721E  260b475c         or ax, word ptr es:[bx + 0x5c]
  007222  7503             jne 0x7227
  007224  e98100           jmp 0x72a8
  007227  268b475c         mov ax, word ptr es:[bx + 0x5c]
  00722B  268b575e         mov dx, word ptr es:[bx + 0x5e]
  00722F  8946ea           mov word ptr [bp - 0x16], ax
  007232  8956ec           mov word ptr [bp - 0x14], dx
  007235  c746da0000       mov word ptr [bp - 0x26], 0
  00723A  8bc2             mov ax, dx
  00723C  0b46ea           or ax, word ptr [bp - 0x16]
  00723F  745c             je 0x729d
  007241  c45e06           les bx, ptr [bp + 6]
  007244  268a470a         mov al, byte ptr es:[bx + 0xa]
  007248  251000           and ax, 0x10
  00724B  3d0100           cmp ax, 1
  00724E  1bc0             sbb ax, ax
  007250  250300           and ax, 3
  007253  8bc8             mov cx, ax
  007255  26034712         add ax, word ptr es:[bx + 0x12]
  007259  c476ea           les si, ptr [bp - 0x16]
  00725C  260304           add ax, word ptr es:[si]
  00725F  3b062607         cmp ax, word ptr [0x726]
  007263  7f21             jg 0x7286
  007265  26034c02         add cx, word ptr es:[si + 2]
  007269  8e4608           mov es, word ptr [bp + 8]
  00726C  26034f12         add cx, word ptr es:[bx + 0x12]
  007270  3b0e2607         cmp cx, word ptr [0x726]
  007274  7e10             jle 0x7286
  007276  c746da0100       mov word ptr [bp - 0x26], 1
  00727B  52               push dx
  00727C  56               push si
  00727D  06               push es
  00727E  53               push bx
  00727F  0e               push cs
  007280  e8b9fc           call 0x6f3c
  007283  83c408           add sp, 8
  007286  c45eea           les bx, ptr [bp - 0x16]
  007289  268b4710         mov ax, word ptr es:[bx + 0x10]
  00728D  268b5712         mov dx, word ptr es:[bx + 0x12]
  007291  8946ea           mov word ptr [bp - 0x16], ax
  007294  8956ec           mov word ptr [bp - 0x14], dx
  007297  837eda00         cmp word ptr [bp - 0x26], 0
  00729B  749d             je 0x723a
  00729D  837eda00         cmp word ptr [bp - 0x26], 0
  0072A1  7505             jne 0x72a8
  0072A3  c746d40100       mov word ptr [bp - 0x2c], 1
  0072A8  837ef600         cmp word ptr [bp - 0xa], 0
  0072AC  7503             jne 0x72b1
  0072AE  e9d102           jmp 0x7582
  0072B1  9a0400af0b       lcall 0xbaf, 4
  0072B6  0bc0             or ax, ax
  0072B8  7503             jne 0x72bd
  0072BA  e9c502           jmp 0x7582
  0072BD  9a1800af0b       lcall 0xbaf, 0x18
  0072C2  8946ca           mov word ptr [bp - 0x36], ax
  0072C5  c45e06           les bx, ptr [bp + 6]
  0072C8  268b4762         mov ax, word ptr es:[bx + 0x62]
  0072CC  260b4760         or ax, word ptr es:[bx + 0x60]
  0072D0  7503             jne 0x72d5
  0072D2  e92301           jmp 0x73f8
  0072D5  268b4760         mov ax, word ptr es:[bx + 0x60]
  0072D9  268b5762         mov dx, word ptr es:[bx + 0x62]
  0072DD  8946fa           mov word ptr [bp - 6], ax
  0072E0  8956fc           mov word ptr [bp - 4], dx
  0072E3  8b46ca           mov ax, word ptr [bp - 0x36]
  0072E6  2d0800           sub ax, 8
  0072E9  7503             jne 0x72ee
  0072EB  e9a200           jmp 0x7390
  0072EE  2d0500           sub ax, 5
  0072F1  7503             jne 0x72f6
  0072F3  e98702           jmp 0x757d
  0072F6  2d0e00           sub ax, 0xe
  0072F9  7503             jne 0x72fe
  0072FB  e97a02           jmp 0x7578
  0072FE  2d2001           sub ax, 0x120
  007301  7475             je 0x7378
  007303  2d1800           sub ax, 0x18
  007306  7503             jne 0x730b
  007308  e9d700           jmp 0x73e2
  00730B  817eca0001       cmp word ptr [bp - 0x36], 0x100
  007310  7c03             jl 0x7315
  007312  e96d02           jmp 0x7582
  007315  8b5eca           mov bx, word ptr [bp - 0x36]
  007318  f687a94557       test byte ptr [bx + 0x45a9], 0x57
  00731D  7503             jne 0x7322
  00731F  e96002           jmp 0x7582
  007322  c45efa           les bx, ptr [bp - 6]
  007325  26f60780         test byte ptr es:[bx], 0x80
  007329  740f             je 0x733a
  00732B  26c4770c         les si, ptr es:[bx + 0xc]
  00732F  26c60400         mov byte ptr es:[si], 0
  007333  c45efa           les bx, ptr [bp - 6]
  007336  2680277f         and byte ptr es:[bx], 0x7f
  00733A  8a46ca           mov al, byte ptr [bp - 0x36]
  00733D  8846e6           mov byte ptr [bp - 0x1a], al
  007340  c646e700         mov byte ptr [bp - 0x19], 0
  007344  c45efa           les bx, ptr [bp - 6]
  007347  26ff770e         push word ptr es:[bx + 0xe]
  00734B  26ff770c         push word ptr es:[bx + 0xc]
  00734F  9ad40d8813       lcall 0x1388, 0xdd4
  007354  83c404           add sp, 4
  007357  c45efa           les bx, ptr [bp - 6]
  00735A  263b4706         cmp ax, word ptr es:[bx + 6]
  00735E  7372             jae 0x73d2
  007360  8d46e6           lea ax, [bp - 0x1a]
  007363  16               push ss
  007364  50               push ax
  007365  26ff770e         push word ptr es:[bx + 0xe]
  007369  26ff770c         push word ptr es:[bx + 0xc]
  00736D  9a220e8813       lcall 0x1388, 0xe22
  007372  83c408           add sp, 8
  007375  eb5b             jmp 0x73d2
  007377  90               nop
  007378  833e660500       cmp word ptr [0x566], 0
  00737D  7503             jne 0x7382
  00737F  e90002           jmp 0x7582
  007382  c746f60000       mov word ptr [bp - 0xa], 0
  007387  c70668050100     mov word ptr [0x568], 1
  00738D  e9f201           jmp 0x7582
  007390  c45efa           les bx, ptr [bp - 6]
  007393  26ff770e         push word ptr es:[bx + 0xe]
  007397  26ff770c         push word ptr es:[bx + 0xc]
  00739B  9ad40d8813       lcall 0x1388, 0xdd4
  0073A0  83c404           add sp, 4
  0073A3  0bc0             or ax, ax
  0073A5  7424             je 0x73cb
  0073A7  c45efa           les bx, ptr [bp - 6]
  0073AA  26ff770e         push word ptr es:[bx + 0xe]
  0073AE  26ff770c         push word ptr es:[bx + 0xc]
  0073B2  9ad40d8813       lcall 0x1388, 0xdd4
  0073B7  83c404           add sp, 4
  0073BA  8946c8           mov word ptr [bp - 0x38], ax
  0073BD  c45efa           les bx, ptr [bp - 6]
  0073C0  26c45f0c         les bx, ptr es:[bx + 0xc]
  0073C4  8bf0             mov si, ax
  0073C6  26c640ff00       mov byte ptr es:[bx + si - 1], 0
  0073CB  c45efa           les bx, ptr [bp - 6]
  0073CE  2680277f         and byte ptr es:[bx], 0x7f
  0073D2  ff7608           push word ptr [bp + 8]
  0073D5  ff7606           push word ptr [bp + 6]
  0073D8  b80100           mov ax, 1
  0073DB  e814f4           call 0x67f2
  0073DE  e9a101           jmp 0x7582
  0073E1  90               nop
  0073E2  c45efa           les bx, ptr [bp - 6]
  0073E5  26f60780         test byte ptr es:[bx], 0x80
  0073E9  7503             jne 0x73ee
  0073EB  e99401           jmp 0x7582
  0073EE  26c4770c         les si, ptr es:[bx + 0xc]
  0073F2  26c60400         mov byte ptr es:[si], 0
  0073F6  ebd3             jmp 0x73cb
  0073F8  817eca0001       cmp word ptr [bp - 0x36], 0x100
  0073FD  7d0e             jge 0x740d
  0073FF  8b5eca           mov bx, word ptr [bp - 0x36]
  007402  f687a94502       test byte ptr [bx + 0x45a9], 2
  007407  7404             je 0x740d
  007409  836eca20         sub word ptr [bp - 0x36], 0x20
  00740D  8b5e06           mov bx, word ptr [bp + 6]
  007410  268b4756         mov ax, word ptr es:[bx + 0x56]
  007414  260b4754         or ax, word ptr es:[bx + 0x54]
  007418  7403             je 0x741d
  00741A  e93b01           jmp 0x7558
  00741D  8b46ca           mov ax, word ptr [bp - 0x36]
  007420  2d1b00           sub ax, 0x1b
  007423  7503             jne 0x7428
  007425  e95001           jmp 0x7578
  007428  2d2d01           sub ax, 0x12d
  00742B  7503             jne 0x7430
  00742D  e99c00           jmp 0x74cc
  007430  2d0800           sub ax, 8
  007433  743d             je 0x7472
  007435  26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  00743A  268b4752         mov ax, word ptr es:[bx + 0x52]
  00743E  260b4750         or ax, word ptr es:[bx + 0x50]
  007442  7503             jne 0x7447
  007444  e93601           jmp 0x757d
  007447  26f6470a02       test byte ptr es:[bx + 0xa], 2
  00744C  7503             jne 0x7451
  00744E  e92c01           jmp 0x757d
  007451  26c47750         les si, ptr es:[bx + 0x50]
  007455  268b4404         mov ax, word ptr es:[si + 4]
  007459  8946d8           mov word ptr [bp - 0x28], ax
  00745C  6bd81c           imul bx, ax, 0x1c
  00745F  80bf265200       cmp byte ptr [bx + 0x5226], 0
  007464  7503             jne 0x7469
  007466  e91401           jmp 0x757d
  007469  c687265200       mov byte ptr [bx + 0x5226], 0
  00746E  06               push es
  00746F  56               push si
  007470  eb4a             jmp 0x74bc
  007472  26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  007477  268b475e         mov ax, word ptr es:[bx + 0x5e]
  00747B  260b475c         or ax, word ptr es:[bx + 0x5c]
  00747F  7503             jne 0x7484
  007481  e9fe00           jmp 0x7582
  007484  268b4752         mov ax, word ptr es:[bx + 0x52]
  007488  260b4750         or ax, word ptr es:[bx + 0x50]
  00748C  741c             je 0x74aa
  00748E  c45e06           les bx, ptr [bp + 6]
  007491  26c47750         les si, ptr es:[bx + 0x50]
  007495  268b4410         mov ax, word ptr es:[si + 0x10]
  007499  268b5412         mov dx, word ptr es:[si + 0x12]
  00749D  8946ea           mov word ptr [bp - 0x16], ax
  0074A0  8956ec           mov word ptr [bp - 0x14], dx
  0074A3  0bd0             or dx, ax
  0074A5  7511             jne 0x74b8
  0074A7  8e4608           mov es, word ptr [bp + 8]
  0074AA  268b475c         mov ax, word ptr es:[bx + 0x5c]
  0074AE  268b575e         mov dx, word ptr es:[bx + 0x5e]
  0074B2  8946ea           mov word ptr [bp - 0x16], ax
  0074B5  8956ec           mov word ptr [bp - 0x14], dx
  0074B8  ff76ec           push word ptr [bp - 0x14]
  0074BB  50               push ax
  0074BC  ff7608           push word ptr [bp + 8]
  0074BF  ff7606           push word ptr [bp + 6]
  0074C2  0e               push cs
  0074C3  e876fa           call 0x6f3c
  0074C6  83c408           add sp, 8
  0074C9  e9b600           jmp 0x7582
  0074CC  26804f0a80       or byte ptr es:[bx + 0xa], 0x80
  0074D1  268b475e         mov ax, word ptr es:[bx + 0x5e]
  0074D5  260b475c         or ax, word ptr es:[bx + 0x5c]
  0074D9  7503             jne 0x74de
  0074DB  e9a400           jmp 0x7582
  0074DE  268b4752         mov ax, word ptr es:[bx + 0x52]
  0074E2  260b4750         or ax, word ptr es:[bx + 0x50]
  0074E6  7414             je 0x74fc
  0074E8  268b4750         mov ax, word ptr es:[bx + 0x50]
  0074EC  268b5752         mov dx, word ptr es:[bx + 0x52]
  0074F0  2639475c         cmp word ptr es:[bx + 0x5c], ax
  0074F4  752e             jne 0x7524
  0074F6  2639575e         cmp word ptr es:[bx + 0x5e], dx
  0074FA  7528             jne 0x7524
  0074FC  c45e06           les bx, ptr [bp + 6]
  0074FF  268b475c         mov ax, word ptr es:[bx + 0x5c]
  007503  268b575e         mov dx, word ptr es:[bx + 0x5e]
  007507  8946ea           mov word ptr [bp - 0x16], ax
  00750A  8956ec           mov word ptr [bp - 0x14], dx
  00750D  c45eea           les bx, ptr [bp - 0x16]
  007510  268b4712         mov ax, word ptr es:[bx + 0x12]
  007514  260b4710         or ax, word ptr es:[bx + 0x10]
  007518  7435             je 0x754f
  00751A  268b4710         mov ax, word ptr es:[bx + 0x10]
  00751E  268b5712         mov dx, word ptr es:[bx + 0x12]
  007522  ebe3             jmp 0x7507
  007524  c45e06           les bx, ptr [bp + 6]
  007527  268b475c         mov ax, word ptr es:[bx + 0x5c]
  00752B  268b575e         mov dx, word ptr es:[bx + 0x5e]
  00752F  8946ea           mov word ptr [bp - 0x16], ax
  007532  8956ec           mov word ptr [bp - 0x14], dx
  007535  c45eea           les bx, ptr [bp - 0x16]
  007538  268b4710         mov ax, word ptr es:[bx + 0x10]
  00753C  268b5712         mov dx, word ptr es:[bx + 0x12]
  007540  c45e06           les bx, ptr [bp + 6]
  007543  26394750         cmp word ptr es:[bx + 0x50], ax
  007547  75e6             jne 0x752f
  007549  26395752         cmp word ptr es:[bx + 0x52], dx
  00754D  75e0             jne 0x752f
  00754F  ff76ec           push word ptr [bp - 0x14]
  007552  ff76ea           push word ptr [bp - 0x16]
  007555  e964ff           jmp 0x74bc
  007558  8b46ca           mov ax, word ptr [bp - 0x36]
  00755B  3d2000           cmp ax, 0x20
  00755E  7503             jne 0x7563
  007560  e97701           jmp 0x76da
  007563  7e03             jle 0x7568
  007565  e95402           jmp 0x77bc
  007568  2d0d00           sub ax, 0xd
  00756B  7503             jne 0x7570
  00756D  e96a01           jmp 0x76da
  007570  2d0e00           sub ax, 0xe
  007573  7403             je 0x7578
  007575  e95c02           jmp 0x77d4
  007578  26c707ffff       mov word ptr es:[bx], 0xffff
  00757D  c746f60000       mov word ptr [bp - 0xa], 0
  007582  833e6e0500       cmp word ptr [0x56e], 0
  007587  7474             je 0x75fd
  007589  8b46e4           mov ax, word ptr [bp - 0x1c]
  00758C  0b46e2           or ax, word ptr [bp - 0x1e]
  00758F  746c             je 0x75fd
  007591  9a0600180d       lcall 0xd18, 6
  007596  3b16884e         cmp dx, word ptr [0x4e88]
  00759A  7c61             jl 0x75fd
  00759C  7f06             jg 0x75a4
  00759E  3b06864e         cmp ax, word ptr [0x4e86]
  0075A2  7259             jb 0x75fd
  0075A4  a17e4e           mov ax, word ptr [0x4e7e]
  0075A7  c45ee2           les bx, ptr [bp - 0x1e]
  0075AA  26c45f0c         les bx, ptr es:[bx + 0xc]
  0075AE  26394704         cmp word ptr es:[bx + 4], ax
  0075B2  7e49             jle 0x75fd
  0075B4  ff067e4e         inc word ptr [0x4e7e]
  0075B8  ff36023b         push word ptr [0x3b02]
  0075BC  ff36003b         push word ptr [0x3b00]
  0075C0  ff36fe3a         push word ptr [0x3afe]
  0075C4  ff36fc3a         push word ptr [0x3afc]
  0075C8  ff36fa3a         push word ptr [0x3afa]
  0075CC  ff36f83a         push word ptr [0x3af8]
  0075D0  ff36f63a         push word ptr [0x3af6]
  0075D4  ff36f43a         push word ptr [0x3af4]
  0075D8  68c800           push 0xc8
  0075DB  2bc0             sub ax, ax
  0075DD  99               cdq
  0075DE  bb4001           mov bx, 0x140
  0075E1  9a00004c0c       lcall 0xc4c, 0
  0075E6  c746f40100       mov word ptr [bp - 0xc], 1
  0075EB  9a0600180d       lcall 0xd18, 6
  0075F0  050a00           add ax, 0xa
  0075F3  83d200           adc dx, 0
  0075F6  a3864e           mov word ptr [0x4e86], ax
  0075F9  8916884e         mov word ptr [0x4e88], dx
  0075FD  837ef400         cmp word ptr [bp - 0xc], 0
  007601  7503             jne 0x7606
  007603  e9de01           jmp 0x77e4
  007606  ff7608           push word ptr [bp + 8]
  007609  ff7606           push word ptr [bp + 6]
  00760C  0e               push cs
  00760D  e85cf8           call 0x6e6c
  007610  83c404           add sp, 4
  007613  e9e001           jmp 0x77f6
  007616  c746d60000       mov word ptr [bp - 0x2a], 0
  00761B  c45e06           les bx, ptr [bp + 6]
  00761E  268b474e         mov ax, word ptr es:[bx + 0x4e]
  007622  260b474c         or ax, word ptr es:[bx + 0x4c]
  007626  7418             je 0x7640
  007628  8cc0             mov ax, es
  00762A  26c4774c         les si, ptr es:[bx + 0x4c]
  00762E  268b4c10         mov cx, word ptr es:[si + 0x10]
  007632  268b5412         mov dx, word ptr es:[si + 0x12]
  007636  8ec0             mov es, ax
  007638  26894f4c         mov word ptr es:[bx + 0x4c], cx
  00763C  2689574e         mov word ptr es:[bx + 0x4e], dx
  007640  c45e06           les bx, ptr [bp + 6]
  007643  268b474e         mov ax, word ptr es:[bx + 0x4e]
  007647  260b474c         or ax, word ptr es:[bx + 0x4c]
  00764B  7513             jne 0x7660
  00764D  268b4754         mov ax, word ptr es:[bx + 0x54]
  007651  268b5756         mov dx, word ptr es:[bx + 0x56]
  007655  2689474c         mov word ptr es:[bx + 0x4c], ax
  007659  2689574e         mov word ptr es:[bx + 0x4e], dx
  00765D  ff46d6           inc word ptr [bp - 0x2a]
  007660  c45e06           les bx, ptr [bp + 6]
  007663  26c45f4c         les bx, ptr es:[bx + 0x4c]
  007667  26f60701         test byte ptr es:[bx], 1
  00766B  7503             jne 0x7670
  00766D  e9a300           jmp 0x7713
  007670  837ed602         cmp word ptr [bp - 0x2a], 2
  007674  7ca5             jl 0x761b
  007676  e99a00           jmp 0x7713
  007679  90               nop
  00767A  c746d60000       mov word ptr [bp - 0x2a], 0
  00767F  c45e06           les bx, ptr [bp + 6]
  007682  268b474e         mov ax, word ptr es:[bx + 0x4e]
  007686  260b474c         or ax, word ptr es:[bx + 0x4c]
  00768A  7418             je 0x76a4
  00768C  8cc0             mov ax, es
  00768E  26c4774c         les si, ptr es:[bx + 0x4c]
  007692  268b4c14         mov cx, word ptr es:[si + 0x14]
  007696  268b5416         mov dx, word ptr es:[si + 0x16]
  00769A  8ec0             mov es, ax
  00769C  26894f4c         mov word ptr es:[bx + 0x4c], cx
  0076A0  2689574e         mov word ptr es:[bx + 0x4e], dx
  0076A4  c45e06           les bx, ptr [bp + 6]
  0076A7  268b474e         mov ax, word ptr es:[bx + 0x4e]
  0076AB  260b474c         or ax, word ptr es:[bx + 0x4c]
  0076AF  7513             jne 0x76c4
  0076B1  268b4770         mov ax, word ptr es:[bx + 0x70]
  0076B5  268b5772         mov dx, word ptr es:[bx + 0x72]
  0076B9  2689474c         mov word ptr es:[bx + 0x4c], ax
  0076BD  2689574e         mov word ptr es:[bx + 0x4e], dx
  0076C1  ff46d6           inc word ptr [bp - 0x2a]
  0076C4  c45e06           les bx, ptr [bp + 6]
  0076C7  26c45f4c         les bx, ptr es:[bx + 0x4c]
  0076CB  26f60701         test byte ptr es:[bx], 1
  0076CF  7442             je 0x7713
  0076D1  837ed602         cmp word ptr [bp - 0x2a], 2
  0076D5  7ca8             jl 0x767f
  0076D7  eb3a             jmp 0x7713
  0076D9  90               nop
  0076DA  c45e06           les bx, ptr [bp + 6]
  0076DD  268b474e         mov ax, word ptr es:[bx + 0x4e]
  0076E1  260b474c         or ax, word ptr es:[bx + 0x4c]
  0076E5  7503             jne 0x76ea
  0076E7  e998fe           jmp 0x7582
  0076EA  26f6470a04       test byte ptr es:[bx + 0xa], 4
  0076EF  742b             je 0x771c
  0076F1  837eca0d         cmp word ptr [bp - 0x36], 0xd
  0076F5  7411             je 0x7708
  0076F7  26c45f4c         les bx, ptr es:[bx + 0x4c]
  0076FB  26837f0601       cmp word ptr es:[bx + 6], 1
  007700  1bc0             sbb ax, ax
  007702  f7d8             neg ax
  007704  26894706         mov word ptr es:[bx + 6], ax
  007708  837eca0d         cmp word ptr [bp - 0x36], 0xd
  00770C  7505             jne 0x7713
  00770E  c746f60000       mov word ptr [bp - 0xa], 0
  007713  c746fe0100       mov word ptr [bp - 2], 1
  007718  e967fe           jmp 0x7582
  00771B  90               nop
  00771C  817eca3b01       cmp word ptr [bp - 0x36], 0x13b
  007721  750a             jne 0x772d
  007723  833e660500       cmp word ptr [0x566], 0
  007728  7503             jne 0x772d
  00772A  e955fe           jmp 0x7582
  00772D  26c4774c         les si, ptr es:[bx + 0x4c]
  007731  268b4404         mov ax, word ptr es:[si + 4]
  007735  8e4608           mov es, word ptr [bp + 8]
  007738  268907           mov word ptr es:[bx], ax
  00773B  c746f60000       mov word ptr [bp - 0xa], 0
  007740  817eca3b01       cmp word ptr [bp - 0x36], 0x13b
  007745  7403             je 0x774a
  007747  e938fe           jmp 0x7582
  00774A  e93afc           jmp 0x7387
  00774D  90               nop
  00774E  8b46d2           mov ax, word ptr [bp - 0x2e]
  007751  0b46d0           or ax, word ptr [bp - 0x30]
  007754  7428             je 0x777e
  007756  8b46ca           mov ax, word ptr [bp - 0x36]
  007759  c45ed0           les bx, ptr [bp - 0x30]
  00775C  26394702         cmp word ptr es:[bx + 2], ax
  007760  7508             jne 0x776a
  007762  c746da0100       mov word ptr [bp - 0x26], 1
  007767  eb0f             jmp 0x7778
  007769  90               nop
  00776A  268b4710         mov ax, word ptr es:[bx + 0x10]
  00776E  268b5712         mov dx, word ptr es:[bx + 0x12]
  007772  8946d0           mov word ptr [bp - 0x30], ax
  007775  8956d2           mov word ptr [bp - 0x2e], dx
  007778  837eda00         cmp word ptr [bp - 0x26], 0
  00777C  74d0             je 0x774e
  00777E  837eda00         cmp word ptr [bp - 0x26], 0
  007782  7503             jne 0x7787
  007784  e9fbfd           jmp 0x7582
  007787  8b46d0           mov ax, word ptr [bp - 0x30]
  00778A  8b56d2           mov dx, word ptr [bp - 0x2e]
  00778D  c45e06           les bx, ptr [bp + 6]
  007790  2689474c         mov word ptr es:[bx + 0x4c], ax
  007794  2689574e         mov word ptr es:[bx + 0x4e], dx
  007798  c746fe0100       mov word ptr [bp - 2], 1
  00779D  26f6470a04       test byte ptr es:[bx + 0xa], 4
  0077A2  7503             jne 0x77a7
  0077A4  e9d6fd           jmp 0x757d
  0077A7  8ec2             mov es, dx
  0077A9  8bd8             mov bx, ax
  0077AB  26837f0601       cmp word ptr es:[bx + 6], 1
  0077B0  1bc0             sbb ax, ax
  0077B2  f7d8             neg ax
  0077B4  26894706         mov word ptr es:[bx + 6], ax
  0077B8  e9c7fd           jmp 0x7582
  0077BB  90               nop
  0077BC  2d3b01           sub ax, 0x13b
  0077BF  7503             jne 0x77c4
  0077C1  e916ff           jmp 0x76da
  0077C4  2d0d00           sub ax, 0xd
  0077C7  7503             jne 0x77cc
  0077C9  e9aefe           jmp 0x767a
  0077CC  2d0800           sub ax, 8
  0077CF  7503             jne 0x77d4
  0077D1  e942fe           jmp 0x7616
  0077D4  c746da0000       mov word ptr [bp - 0x26], 0
  0077D9  268b4754         mov ax, word ptr es:[bx + 0x54]
  0077DD  268b5756         mov dx, word ptr es:[bx + 0x56]
  0077E1  eb8f             jmp 0x7772
  0077E3  90               nop
  0077E4  837efe00         cmp word ptr [bp - 2], 0
  0077E8  740c             je 0x77f6
  0077EA  ff7608           push word ptr [bp + 8]
  0077ED  ff7606           push word ptr [bp + 6]
  0077F0  b80100           mov ax, 1
  0077F3  e864ed           call 0x655a
  0077F6  2bc0             sub ax, ax
  0077F8  8946f4           mov word ptr [bp - 0xc], ax
  0077FB  8946fe           mov word ptr [bp - 2], ax
  0077FE  39063007         cmp word ptr [0x730], ax
  007802  7432             je 0x7836
  007804  3946d4           cmp word ptr [bp - 0x2c], ax
  007807  752d             jne 0x7836
  007809  c45e06           les bx, ptr [bp + 6]
  00780C  268b4756         mov ax, word ptr es:[bx + 0x56]
  007810  260b4754         or ax, word ptr es:[bx + 0x54]
  007814  7476             je 0x788c
  007816  268b474e         mov ax, word ptr es:[bx + 0x4e]
  00781A  260b474c         or ax, word ptr es:[bx + 0x4c]
  00781E  7507             jne 0x7827
  007820  26f6470a01       test byte ptr es:[bx + 0xa], 1
  007825  740f             je 0x7836
  007827  268b474e         mov ax, word ptr es:[bx + 0x4e]
  00782B  260b474c         or ax, word ptr es:[bx + 0x4c]
  00782F  753b             jne 0x786c
  007831  c746f60000       mov word ptr [bp - 0xa], 0
  007836  833e300700       cmp word ptr [0x730], 0
  00783B  741a             je 0x7857
  00783D  837ef600         cmp word ptr [bp - 0xa], 0
  007841  7514             jne 0x7857
  007843  833e660500       cmp word ptr [0x566], 0
  007848  740d             je 0x7857
  00784A  833e200700       cmp word ptr [0x720], 0
  00784F  7406             je 0x7857
  007851  c70668050100     mov word ptr [0x568], 1
  007857  837ef600         cmp word ptr [bp - 0xa], 0
  00785B  7479             je 0x78d6
  00785D  833e2a0700       cmp word ptr [0x72a], 0
  007862  7472             je 0x78d6
  007864  c746c80100       mov word ptr [bp - 0x38], 1
  007869  eb70             jmp 0x78db
  00786B  90               nop
  00786C  26f6470a04       test byte ptr es:[bx + 0xa], 4
  007871  74be             je 0x7831
  007873  26c45f4c         les bx, ptr es:[bx + 0x4c]
  007877  26837f0601       cmp word ptr es:[bx + 6], 1
  00787C  1bc0             sbb ax, ax
  00787E  f7d8             neg ax
  007880  26894706         mov word ptr es:[bx + 6], ax
  007884  c746fe0100       mov word ptr [bp - 2], 1
  007889  ebab             jmp 0x7836
  00788B  90               nop
  00788C  268b475e         mov ax, word ptr es:[bx + 0x5e]
  007890  260b475c         or ax, word ptr es:[bx + 0x5c]
  007894  749b             je 0x7831
  007896  268b4752         mov ax, word ptr es:[bx + 0x52]
  00789A  260b4750         or ax, word ptr es:[bx + 0x50]
  00789E  7491             je 0x7831
  0078A0  26f6470a02       test byte ptr es:[bx + 0xa], 2
  0078A5  748a             je 0x7831
  0078A7  26c47750         les si, ptr es:[bx + 0x50]
  0078AB  268b4404         mov ax, word ptr es:[si + 4]
  0078AF  8946d8           mov word ptr [bp - 0x28], ax
  0078B2  6bd81c           imul bx, ax, 0x1c
  0078B5  80bf265200       cmp byte ptr [bx + 0x5226], 0
  0078BA  7503             jne 0x78bf
  0078BC  e972ff           jmp 0x7831
  0078BF  c687265200       mov byte ptr [bx + 0x5226], 0
  0078C4  06               push es
  0078C5  56               push si
  0078C6  ff7608           push word ptr [bp + 8]
  0078C9  ff7606           push word ptr [bp + 6]
  0078CC  0e               push cs
  0078CD  e86cf6           call 0x6f3c
  0078D0  83c408           add sp, 8
  0078D3  e960ff           jmp 0x7836
  0078D6  c746c80000       mov word ptr [bp - 0x38], 0
  0078DB  2bc0             sub ax, ax
  0078DD  8b56c8           mov dx, word ptr [bp - 0x38]
  0078E0  9a1001210c       lcall 0xc21, 0x110
  0078E5  833e8a0000       cmp word ptr [0x8a], 0
  0078EA  7426             je 0x7912
  0078EC  9a0600180d       lcall 0xd18, 6
  0078F1  8946cc           mov word ptr [bp - 0x34], ax
  0078F4  8956ce           mov word ptr [bp - 0x32], dx
  0078F7  8b4ef0           mov cx, word ptr [bp - 0x10]
  0078FA  8b5ef2           mov bx, word ptr [bp - 0xe]
  0078FD  83c178           add cx, 0x78
  007900  83d300           adc bx, 0
  007903  3bd3             cmp dx, bx
  007905  7c0b             jl 0x7912
  007907  7f04             jg 0x790d
  007909  3bc1             cmp ax, cx
  00790B  7205             jb 0x7912
  00790D  c746f60000       mov word ptr [bp - 0xa], 0
  007912  837ef600         cmp word ptr [bp - 0xa], 0
  007916  7403             je 0x791b
  007918  e909f8           jmp 0x7124
  00791B  c45e06           les bx, ptr [bp + 6]
  00791E  268b4762         mov ax, word ptr es:[bx + 0x62]
  007922  260b4760         or ax, word ptr es:[bx + 0x60]
  007926  741a             je 0x7942
  007928  26c45f60         les bx, ptr es:[bx + 0x60]
  00792C  26ff770e         push word ptr es:[bx + 0xe]
  007930  26ff770c         push word ptr es:[bx + 0xc]
  007934  1e               push ds
  007935  68644b           push 0x4b64
  007938  9aec0d8813       lcall 0x1388, 0xdec
  00793D  83c408           add sp, 8
  007940  eb32             jmp 0x7974
  007942  26833f00         cmp word ptr es:[bx], 0
  007946  752c             jne 0x7974
  007948  268b474e         mov ax, word ptr es:[bx + 0x4e]
  00794C  260b474c         or ax, word ptr es:[bx + 0x4c]
  007950  740a             je 0x795c
  007952  26c4774c         les si, ptr es:[bx + 0x4c]
  007956  268b4404         mov ax, word ptr es:[si + 4]
  00795A  eb12             jmp 0x796e
  00795C  268b4752         mov ax, word ptr es:[bx + 0x52]
  007960  260b4750         or ax, word ptr es:[bx + 0x50]
  007964  740e             je 0x7974
  007966  26c47750         les si, ptr es:[bx + 0x50]
  00796A  268b4406         mov ax, word ptr es:[si + 6]
  00796E  8e4608           mov es, word ptr [bp + 8]
  007971  268907           mov word ptr es:[bx], ax
  007974  c45e06           les bx, ptr [bp + 6]
  007977  26f6470a08       test byte ptr es:[bx + 0xa], 8
  00797C  751f             jne 0x799d
  00797E  26ff7718         push word ptr es:[bx + 0x18]
  007982  26ff771a         push word ptr es:[bx + 0x1a]
  007986  26ff771c         push word ptr es:[bx + 0x1c]
  00798A  26ff771e         push word ptr es:[bx + 0x1e]
  00798E  8d1ef43a         lea bx, [0x3af4]
  007992  8b46e8           mov ax, word ptr [bp - 0x18]
  007995  baffff           mov dx, 0xffff
  007998  9aec009d0c       lcall 0xc9d, 0xec
  00799D  c45e06           les bx, ptr [bp + 6]
  0079A0  268b476a         mov ax, word ptr es:[bx + 0x6a]
  0079A4  260b4768         or ax, word ptr es:[bx + 0x68]
  0079A8  7443             je 0x79ed
  0079AA  833e700501       cmp word ptr [0x570], 1
  0079AF  7411             je 0x79c2
  0079B1  26c45f68         les bx, ptr es:[bx + 0x68]
  0079B5  26ff770e         push word ptr es:[bx + 0xe]
  0079B9  26ff770c         push word ptr es:[bx + 0xc]
  0079BD  9a1003c90c       lcall 0xcc9, 0x310
  0079C2  837ee000         cmp word ptr [bp - 0x20], 0
  0079C6  7425             je 0x79ed
  0079C8  833e700500       cmp word ptr [0x570], 0
  0079CD  751e             jne 0x79ed
  0079CF  c45e06           les bx, ptr [bp + 6]
  0079D2  26c45f68         les bx, ptr es:[bx + 0x68]
  0079D6  26c45f10         les bx, ptr es:[bx + 0x10]
  0079DA  895eea           mov word ptr [bp - 0x16], bx
  0079DD  8c46ec           mov word ptr [bp - 0x14], es
  0079E0  26ff770e         push word ptr es:[bx + 0xe]
  0079E4  26ff770c         push word ptr es:[bx + 0xc]
  0079E8  9a1003c90c       lcall 0xcc9, 0x310
  0079ED  ff7608           push word ptr [bp + 8]
  0079F0  ff7606           push word ptr [bp + 6]
  0079F3  e824ea           call 0x641a
  0079F6  b8ffff           mov ax, 0xffff
  0079F9  a35c05           mov word ptr [0x55c], ax
  0079FC  a35e05           mov word ptr [0x55e], ax
  0079FF  a36005           mov word ptr [0x560], ax
  007A02  2bc0             sub ax, ax
  007A04  a38a05           mov word ptr [0x58a], ax
  007A07  a36605           mov word ptr [0x566], ax
  007A0A  c45e06           les bx, ptr [bp + 6]
  007A0D  26f6470a04       test byte ptr es:[bx + 0xa], 4
  007A12  7432             je 0x7a46
  007A14  a35405           mov word ptr [0x554], ax
  007A17  8946de           mov word ptr [bp - 0x22], ax
  007A1A  eb1e             jmp 0x7a3a
  007A1C  40               inc ax
  007A1D  50               push ax
  007A1E  06               push es
  007A1F  53               push bx
  007A20  0e               push cs
  007A21  e844d9           call 0x5368
  007A24  83c406           add sp, 6
  007A27  0bc0             or ax, ax
  007A29  740c             je 0x7a37
  007A2B  8a4ede           mov cl, byte ptr [bp - 0x22]
  007A2E  b80100           mov ax, 1
  007A31  d3e0             shl ax, cl
  007A33  09065405         or word ptr [0x554], ax
  007A37  ff46de           inc word ptr [bp - 0x22]
  007A3A  8b46de           mov ax, word ptr [bp - 0x22]
  007A3D  c45e06           les bx, ptr [bp + 6]
  007A40  26394702         cmp word ptr es:[bx + 2], ax
  007A44  7fd6             jg 0x7a1c
  007A46  9a2a00210c       lcall 0xc21, 0x2a
  007A4B  833e700500       cmp word ptr [0x570], 0
  007A50  7405             je 0x7a57
  007A52  9a02000000       lcall 0, 2
  007A57  c45e06           les bx, ptr [bp + 6]
  007A5A  268b07           mov ax, word ptr es:[bx]
  007A5D  5e               pop si
  007A5E  c9               leave
  007A5F  ca0400           retf 4

; ---- _popup_init  file 0x007A62..0x007A7A  seg 0x33D:0x3092  (popup.obj) ----
  007A62  55               push bp
  007A63  8bec             mov bp, sp
  007A65  8b4606           mov ax, word ptr [bp + 6]
  007A68  8b5608           mov dx, word ptr [bp + 8]
  007A6B  a39e05           mov word ptr [0x59e], ax
  007A6E  8916a005         mov word ptr [0x5a0], dx
  007A72  8b460a           mov ax, word ptr [bp + 0xa]
  007A75  a3a205           mov word ptr [0x5a2], ax
  007A78  c9               leave
  007A79  cb               retf

; ---- _popup_parse_string  file 0x007A7A..0x007C82  seg 0x33D:0x30aa  (popup.obj) ----
  007A7A  c82e0000         enter 0x2e, 0
  007A7E  8b5e08           mov bx, word ptr [bp + 8]
  007A81  c60700           mov byte ptr [bx], 0
  007A84  6a25             push 0x25
  007A86  ff7606           push word ptr [bp + 6]
  007A89  9ae8098813       lcall 0x1388, 0x9e8
  007A8E  83c404           add sp, 4
  007A91  8946d4           mov word ptr [bp - 0x2c], ax
  007A94  0bc0             or ax, ax
  007A96  7405             je 0x7a9d
  007A98  8bd8             mov bx, ax
  007A9A  c60700           mov byte ptr [bx], 0
  007A9D  8b5e06           mov bx, word ptr [bp + 6]
  007AA0  803f00           cmp byte ptr [bx], 0
  007AA3  740c             je 0x7ab1
  007AA5  53               push bx
  007AA6  ff7608           push word ptr [bp + 8]
  007AA9  9ae6058813       lcall 0x1388, 0x5e6
  007AAE  83c404           add sp, 4
  007AB1  837ed400         cmp word ptr [bp - 0x2c], 0
  007AB5  7503             jne 0x7aba
  007AB7  e9bd01           jmp 0x7c77
  007ABA  ff46d4           inc word ptr [bp - 0x2c]
  007ABD  8b46d4           mov ax, word ptr [bp - 0x2c]
  007AC0  894606           mov word ptr [bp + 6], ax
  007AC3  6a06             push 6
  007AC5  68a405           push 0x5a4
  007AC8  50               push ax
  007AC9  9a120a8813       lcall 0x1388, 0xa12
  007ACE  83c406           add sp, 6
  007AD1  0bc0             or ax, ax
  007AD3  7531             jne 0x7b06
  007AD5  8b4606           mov ax, word ptr [bp + 6]
  007AD8  050600           add ax, 6
  007ADB  50               push ax
  007ADC  9a38078813       lcall 0x1388, 0x738
  007AE1  83c402           add sp, 2
  007AE4  8946d2           mov word ptr [bp - 0x2e], ax
  007AE7  c1e006           shl ax, 6
  007AEA  054e63           add ax, 0x634e
  007AED  50               push ax
  007AEE  ff7608           push word ptr [bp + 8]
  007AF1  9ae6058813       lcall 0x1388, 0x5e6
  007AF6  83c404           add sp, 4
  007AF9  8b4606           mov ax, word ptr [bp + 6]
  007AFC  050700           add ax, 7
  007AFF  894606           mov word ptr [bp + 6], ax
  007B02  e97201           jmp 0x7c77
  007B05  90               nop
  007B06  6a06             push 6
  007B08  68ab05           push 0x5ab
  007B0B  ff76d4           push word ptr [bp - 0x2c]
  007B0E  9afe068813       lcall 0x1388, 0x6fe
  007B13  83c406           add sp, 6
  007B16  0bc0             or ax, ax
  007B18  7544             jne 0x7b5e
  007B1A  6a0a             push 0xa
  007B1C  8d46d8           lea ax, [bp - 0x28]
  007B1F  50               push ax
  007B20  8b4ed4           mov cx, word ptr [bp - 0x2c]
  007B23  83c106           add cx, 6
  007B26  51               push cx
  007B27  9a38078813       lcall 0x1388, 0x738
  007B2C  83c402           add sp, 2
  007B2F  8946d2           mov word ptr [bp - 0x2e], ax
  007B32  8bd8             mov bx, ax
  007B34  c1e302           shl bx, 2
  007B37  ffb78c69         push word ptr [bx + 0x698c]
  007B3B  ffb78a69         push word ptr [bx + 0x698a]
  007B3F  9a58078813       lcall 0x1388, 0x758
  007B44  83c408           add sp, 8
  007B47  8d46d8           lea ax, [bp - 0x28]
  007B4A  50               push ax
  007B4B  ff7608           push word ptr [bp + 8]
  007B4E  9ae6058813       lcall 0x1388, 0x5e6
  007B53  83c404           add sp, 4
  007B56  83460607         add word ptr [bp + 6], 7
  007B5A  e91a01           jmp 0x7c77
  007B5D  90               nop
  007B5E  6a03             push 3
  007B60  68b205           push 0x5b2
  007B63  ff76d4           push word ptr [bp - 0x2c]
  007B66  9afe068813       lcall 0x1388, 0x6fe
  007B6B  83c406           add sp, 6
  007B6E  0bc0             or ax, ax
  007B70  7572             jne 0x7be4
  007B72  6a10             push 0x10
  007B74  8d46d8           lea ax, [bp - 0x28]
  007B77  50               push ax
  007B78  8b46d4           mov ax, word ptr [bp - 0x2c]
  007B7B  050300           add ax, 3
  007B7E  50               push ax
  007B7F  9a38078813       lcall 0x1388, 0x738
  007B84  83c402           add sp, 2
  007B87  8bd8             mov bx, ax
  007B89  895ed2           mov word ptr [bp - 0x2e], bx
  007B8C  c1e302           shl bx, 2
  007B8F  ffb78c69         push word ptr [bx + 0x698c]
  007B93  ffb78a69         push word ptr [bx + 0x698a]
  007B97  9a58078813       lcall 0x1388, 0x758
  007B9C  83c408           add sp, 8
  007B9F  c746d60000       mov word ptr [bp - 0x2a], 0
  007BA4  eb11             jmp 0x7bb7
  007BA6  68b605           push 0x5b6
  007BA9  ff7608           push word ptr [bp + 8]
  007BAC  9ae6058813       lcall 0x1388, 0x5e6
  007BB1  83c404           add sp, 4
  007BB4  ff46d6           inc word ptr [bp - 0x2a]
  007BB7  8d46d8           lea ax, [bp - 0x28]
  007BBA  50               push ax
  007BBB  9a84068813       lcall 0x1388, 0x684
  007BC0  83c402           add sp, 2
  007BC3  2d0400           sub ax, 4
  007BC6  f7d8             neg ax
  007BC8  3b46d6           cmp ax, word ptr [bp - 0x2a]
  007BCB  77d9             ja 0x7ba6
  007BCD  8d46d8           lea ax, [bp - 0x28]
  007BD0  50               push ax
  007BD1  ff7608           push word ptr [bp + 8]
  007BD4  9ae6058813       lcall 0x1388, 0x5e6
  007BD9  83c404           add sp, 4
  007BDC  83460604         add word ptr [bp + 6], 4
  007BE0  e99400           jmp 0x7c77
  007BE3  90               nop
  007BE4  6a07             push 7
  007BE6  68b805           push 0x5b8
  007BE9  ff76d4           push word ptr [bp - 0x2c]
  007BEC  9afe068813       lcall 0x1388, 0x6fe
  007BF1  83c406           add sp, 6
  007BF4  0bc0             or ax, ax
  007BF6  752a             jne 0x7c22
  007BF8  c646d800         mov byte ptr [bp - 0x28], 0
  007BFC  8d46d8           lea ax, [bp - 0x28]
  007BFF  50               push ax
  007C00  6a00             push 0
  007C02  ff36445e         push word ptr [0x5e44]
  007C06  9a14000000       lcall 0, 0x14
  007C0B  83c406           add sp, 6
  007C0E  8d46d8           lea ax, [bp - 0x28]
  007C11  16               push ss
  007C12  50               push ax
  007C13  1e               push ds
  007C14  ff7608           push word ptr [bp + 8]
  007C17  9a220e8813       lcall 0x1388, 0xe22
  007C1C  83c408           add sp, 8
  007C1F  e934ff           jmp 0x7b56
  007C22  6a04             push 4
  007C24  68c005           push 0x5c0
  007C27  ff76d4           push word ptr [bp - 0x2c]
  007C2A  9afe068813       lcall 0x1388, 0x6fe
  007C2F  83c406           add sp, 6
  007C32  0bc0             or ax, ax
  007C34  7526             jne 0x7c5c
  007C36  6a0a             push 0xa
  007C38  8d46d8           lea ax, [bp - 0x28]
  007C3B  50               push ax
  007C3C  ff36365e         push word ptr [0x5e36]
  007C40  9a3c078813       lcall 0x1388, 0x73c
  007C45  83c406           add sp, 6
  007C48  8d46d8           lea ax, [bp - 0x28]
  007C4B  16               push ss
  007C4C  50               push ax
  007C4D  1e               push ds
  007C4E  ff7608           push word ptr [bp + 8]
  007C51  9a220e8813       lcall 0x1388, 0xe22
  007C56  83c408           add sp, 8
  007C59  eb81             jmp 0x7bdc
  007C5B  90               nop
  007C5C  8b5ed4           mov bx, word ptr [bp - 0x2c]
  007C5F  803f25           cmp byte ptr [bx], 0x25
  007C62  7513             jne 0x7c77
  007C64  1e               push ds
  007C65  68c505           push 0x5c5
  007C68  1e               push ds
  007C69  ff7608           push word ptr [bp + 8]
  007C6C  9a220e8813       lcall 0x1388, 0xe22
  007C71  83c408           add sp, 8
  007C74  ff4606           inc word ptr [bp + 6]
  007C77  837ed400         cmp word ptr [bp - 0x2c], 0
  007C7B  7403             je 0x7c80
  007C7D  e904fe           jmp 0x7a84
  007C80  c9               leave
  007C81  cb               retf

; ---- @popup_start_box  file 0x007C82..0x0080A8  seg 0x33D:0x32b2  (popup.obj) ----
  007C82  c8680100         enter 0x168, 0
  007C86  52               push dx
  007C87  50               push ax
  007C88  53               push bx
  007C89  57               push di
  007C8A  56               push si
  007C8B  b90100           mov cx, 1
  007C8E  894efc           mov word ptr [bp - 4], cx
  007C91  898e9efe         mov word ptr [bp - 0x162], cx
  007C95  c746f00000       mov word ptr [bp - 0x10], 0
  007C9A  2bc9             sub cx, cx
  007C9C  894ef6           mov word ptr [bp - 0xa], cx
  007C9F  894ef4           mov word ptr [bp - 0xc], cx
  007CA2  50               push ax
  007CA3  68323b           push 0x3b32
  007CA6  8bf0             mov si, ax
  007CA8  8bfb             mov di, bx
  007CAA  9a26068813       lcall 0x1388, 0x626
  007CAF  83c404           add sp, 4
  007CB2  56               push si
  007CB3  57               push di
  007CB4  9a1a004208       lcall 0x842, 0x1a
  007CB9  83c404           add sp, 4
  007CBC  0bc0             or ax, ax
  007CBE  7403             je 0x7cc3
  007CC0  e9c003           jmp 0x8083
  007CC3  ff36a005         push word ptr [0x5a0]
  007CC7  ff369e05         push word ptr [0x59e]
  007CCB  ff36a205         push word ptr [0x5a2]
  007CCF  0e               push cs
  007CD0  e8dbd3           call 0x50ae
  007CD3  83c406           add sp, 6
  007CD6  8946f4           mov word ptr [bp - 0xc], ax
  007CD9  8956f6           mov word ptr [bp - 0xa], dx
  007CDC  0bd0             or dx, ax
  007CDE  7503             jne 0x7ce3
  007CE0  e9a003           jmp 0x8083
  007CE3  833e080600       cmp word ptr [0x608], 0
  007CE8  7418             je 0x7d02
  007CEA  833e2a5e00       cmp word ptr [0x5e2a], 0
  007CEF  7411             je 0x7d02
  007CF1  ff362a5e         push word ptr [0x5e2a]
  007CF5  8d86a0fe         lea ax, [bp - 0x160]
  007CF9  50               push ax
  007CFA  9a26068813       lcall 0x1388, 0x626
  007CFF  83c404           add sp, 4
  007D02  9a06014208       lcall 0x842, 0x106
  007D07  8946f2           mov word ptr [bp - 0xe], ax
  007D0A  50               push ax
  007D0B  9a84068813       lcall 0x1388, 0x684
  007D10  83c402           add sp, 2
  007D13  0bc0             or ax, ax
  007D15  7507             jne 0x7d1e
  007D17  ff46fc           inc word ptr [bp - 4]
  007D1A  e95d03           jmp 0x807a
  007D1D  90               nop
  007D1E  8b5ef2           mov bx, word ptr [bp - 0xe]
  007D21  803f40           cmp byte ptr [bx], 0x40
  007D24  7403             je 0x7d29
  007D26  e96f02           jmp 0x7f98
  007D29  53               push bx
  007D2A  9a880a8813       lcall 0x1388, 0xa88
  007D2F  83c402           add sp, 2
  007D32  68c705           push 0x5c7
  007D35  8b46f2           mov ax, word ptr [bp - 0xe]
  007D38  40               inc ax
  007D39  898698fe         mov word ptr [bp - 0x168], ax
  007D3D  50               push ax
  007D3E  9a58068813       lcall 0x1388, 0x658
  007D43  83c404           add sp, 4
  007D46  0bc0             or ax, ax
  007D48  7413             je 0x7d5d
  007D4A  68cf05           push 0x5cf
  007D4D  ffb698fe         push word ptr [bp - 0x168]
  007D51  9a58068813       lcall 0x1388, 0x658
  007D56  83c404           add sp, 4
  007D59  0bc0             or ax, ax
  007D5B  7509             jne 0x7d66
  007D5D  c746fc0200       mov word ptr [bp - 4], 2
  007D62  e91503           jmp 0x807a
  007D65  90               nop
  007D66  68d605           push 0x5d6
  007D69  ffb698fe         push word ptr [bp - 0x168]
  007D6D  9a58068813       lcall 0x1388, 0x658
  007D72  83c404           add sp, 4
  007D75  0bc0             or ax, ax
  007D77  7509             jne 0x7d82
  007D79  c746fc0100       mov word ptr [bp - 4], 1
  007D7E  e9f902           jmp 0x807a
  007D81  90               nop
  007D82  68db05           push 0x5db
  007D85  ffb698fe         push word ptr [bp - 0x168]
  007D89  9a58068813       lcall 0x1388, 0x658
  007D8E  83c404           add sp, 4
  007D91  0bc0             or ax, ax
  007D93  7517             jne 0x7dac
  007D95  a18000           mov ax, word ptr [0x80]
  007D98  8b168200         mov dx, word ptr [0x82]
  007D9C  c45ef4           les bx, ptr [bp - 0xc]
  007D9F  2689878000       mov word ptr es:[bx + 0x80], ax
  007DA4  2689978200       mov word ptr es:[bx + 0x82], dx
  007DA9  e9ce02           jmp 0x807a
  007DAC  6a01             push 1
  007DAE  68e505           push 0x5e5
  007DB1  ffb698fe         push word ptr [bp - 0x168]
  007DB5  9afe068813       lcall 0x1388, 0x6fe
  007DBA  83c406           add sp, 6
  007DBD  0bc0             or ax, ax
  007DBF  7533             jne 0x7df4
  007DC1  eb11             jmp 0x7dd4
  007DC3  90               nop
  007DC4  8a07             mov al, byte ptr [bx]
  007DC6  98               cwde
  007DC7  8bd8             mov bx, ax
  007DC9  f687a94504       test byte ptr [bx + 0x45a9], 4
  007DCE  750d             jne 0x7ddd
  007DD0  ff8698fe         inc word ptr [bp - 0x168]
  007DD4  8b9e98fe         mov bx, word ptr [bp - 0x168]
  007DD8  803f00           cmp byte ptr [bx], 0
  007DDB  75e7             jne 0x7dc4
  007DDD  ffb698fe         push word ptr [bp - 0x168]
  007DE1  9a38078813       lcall 0x1388, 0x738
  007DE6  83c402           add sp, 2
  007DE9  c45ef4           les bx, ptr [bp - 0xc]
  007DEC  2689470e         mov word ptr es:[bx + 0xe], ax
  007DF0  e98702           jmp 0x807a
  007DF3  90               nop
  007DF4  6a01             push 1
  007DF6  68e705           push 0x5e7
  007DF9  ffb698fe         push word ptr [bp - 0x168]
  007DFD  9afe068813       lcall 0x1388, 0x6fe
  007E02  83c406           add sp, 6
  007E05  0bc0             or ax, ax
  007E07  7533             jne 0x7e3c
  007E09  eb11             jmp 0x7e1c
  007E0B  90               nop
  007E0C  8a07             mov al, byte ptr [bx]
  007E0E  98               cwde
  007E0F  8bd8             mov bx, ax
  007E11  f687a94504       test byte ptr [bx + 0x45a9], 4
  007E16  750d             jne 0x7e25
  007E18  ff8698fe         inc word ptr [bp - 0x168]
  007E1C  8b9e98fe         mov bx, word ptr [bp - 0x168]
  007E20  803f00           cmp byte ptr [bx], 0
  007E23  75e7             jne 0x7e0c
  007E25  ffb698fe         push word ptr [bp - 0x168]
  007E29  9a38078813       lcall 0x1388, 0x738
  007E2E  83c402           add sp, 2
  007E31  c45ef4           les bx, ptr [bp - 0xc]
  007E34  2689470c         mov word ptr es:[bx + 0xc], ax
  007E38  e93f02           jmp 0x807a
  007E3B  90               nop
  007E3C  6a05             push 5
  007E3E  68e905           push 0x5e9
  007E41  ffb698fe         push word ptr [bp - 0x168]
  007E45  9afe068813       lcall 0x1388, 0x6fe
  007E4A  83c406           add sp, 6
  007E4D  0bc0             or ax, ax
  007E4F  753d             jne 0x7e8e
  007E51  eb11             jmp 0x7e64
  007E53  90               nop
  007E54  8a07             mov al, byte ptr [bx]
  007E56  98               cwde
  007E57  8bd8             mov bx, ax
  007E59  f687a94504       test byte ptr [bx + 0x45a9], 4
  007E5E  750d             jne 0x7e6d
  007E60  ff8698fe         inc word ptr [bp - 0x168]
  007E64  8b9e98fe         mov bx, word ptr [bp - 0x168]
  007E68  803f00           cmp byte ptr [bx], 0
  007E6B  75e7             jne 0x7e54
  007E6D  ffb698fe         push word ptr [bp - 0x168]
  007E71  9a38078813       lcall 0x1388, 0x738
  007E76  83c402           add sp, 2
  007E79  8946fe           mov word ptr [bp - 2], ax
  007E7C  50               push ax
  007E7D  ff76f6           push word ptr [bp - 0xa]
  007E80  ff76f4           push word ptr [bp - 0xc]
  007E83  0e               push cs
  007E84  e879d7           call 0x5600
  007E87  83c406           add sp, 6
  007E8A  e9ed01           jmp 0x807a
  007E8D  90               nop
  007E8E  6a06             push 6
  007E90  68ef05           push 0x5ef
  007E93  ffb698fe         push word ptr [bp - 0x168]
  007E97  9a120a8813       lcall 0x1388, 0xa12
  007E9C  83c406           add sp, 6
  007E9F  0bc0             or ax, ax
  007EA1  7539             jne 0x7edc
  007EA3  eb11             jmp 0x7eb6
  007EA5  90               nop
  007EA6  8a07             mov al, byte ptr [bx]
  007EA8  98               cwde
  007EA9  8bd8             mov bx, ax
  007EAB  f687a94504       test byte ptr [bx + 0x45a9], 4
  007EB0  750d             jne 0x7ebf
  007EB2  ff8698fe         inc word ptr [bp - 0x168]
  007EB6  8b9e98fe         mov bx, word ptr [bp - 0x168]
  007EBA  803f00           cmp byte ptr [bx], 0
  007EBD  75e7             jne 0x7ea6
  007EBF  833ed05a00       cmp word ptr [0x5ad0], 0
  007EC4  7403             je 0x7ec9
  007EC6  e9b101           jmp 0x807a
  007EC9  ffb698fe         push word ptr [bp - 0x168]
  007ECD  9a38078813       lcall 0x1388, 0x738
  007ED2  83c402           add sp, 2
  007ED5  a3d05a           mov word ptr [0x5ad0], ax
  007ED8  e99f01           jmp 0x807a
  007EDB  90               nop
  007EDC  6a07             push 7
  007EDE  68f605           push 0x5f6
  007EE1  ffb698fe         push word ptr [bp - 0x168]
  007EE5  9afe068813       lcall 0x1388, 0x6fe
  007EEA  83c406           add sp, 6
  007EED  0bc0             or ax, ax
  007EEF  7511             jne 0x7f02
  007EF1  c746f00100       mov word ptr [bp - 0x10], 1
  007EF6  c45ef4           les bx, ptr [bp - 0xc]
  007EF9  26804f0a05       or byte ptr es:[bx + 0xa], 5
  007EFE  e97901           jmp 0x807a
  007F01  90               nop
  007F02  6a07             push 7
  007F04  68ff05           push 0x5ff
  007F07  ffb698fe         push word ptr [bp - 0x168]
  007F0B  9afe068813       lcall 0x1388, 0x6fe
  007F10  83c406           add sp, 6
  007F13  0bc0             or ax, ax
  007F15  7579             jne 0x7f90
  007F17  39060806         cmp word ptr [0x608], ax
  007F1B  744d             je 0x7f6a
  007F1D  eb0a             jmp 0x7f29
  007F1F  90               nop
  007F20  803f3d           cmp byte ptr [bx], 0x3d
  007F23  740d             je 0x7f32
  007F25  ff8698fe         inc word ptr [bp - 0x168]
  007F29  8b9e98fe         mov bx, word ptr [bp - 0x168]
  007F2D  803f00           cmp byte ptr [bx], 0
  007F30  75ee             jne 0x7f20
  007F32  833e2a5e00       cmp word ptr [0x5e2a], 0
  007F37  7403             je 0x7f3c
  007F39  e93e01           jmp 0x807a
  007F3C  803f00           cmp byte ptr [bx], 0
  007F3F  7404             je 0x7f45
  007F41  ff8698fe         inc word ptr [bp - 0x168]
  007F45  ffb698fe         push word ptr [bp - 0x168]
  007F49  8d86a0fe         lea ax, [bp - 0x160]
  007F4D  50               push ax
  007F4E  9a26068813       lcall 0x1388, 0x626
  007F53  83c404           add sp, 4
  007F56  e92101           jmp 0x807a
  007F59  90               nop
  007F5A  8a07             mov al, byte ptr [bx]
  007F5C  98               cwde
  007F5D  8bd8             mov bx, ax
  007F5F  f687a94504       test byte ptr [bx + 0x45a9], 4
  007F64  750d             jne 0x7f73
  007F66  ff8698fe         inc word ptr [bp - 0x168]
  007F6A  8b9e98fe         mov bx, word ptr [bp - 0x168]
  007F6E  803f00           cmp byte ptr [bx], 0
  007F71  75e7             jne 0x7f5a
  007F73  83be96fe00       cmp word ptr [bp - 0x16a], 0
  007F78  7403             je 0x7f7d
  007F7A  e9fd00           jmp 0x807a
  007F7D  ffb698fe         push word ptr [bp - 0x168]
  007F81  9a38078813       lcall 0x1388, 0x738
  007F86  83c402           add sp, 2
  007F89  898696fe         mov word ptr [bp - 0x16a], ax
  007F8D  e9ea00           jmp 0x807a
  007F90  c746fc0300       mov word ptr [bp - 4], 3
  007F95  e9e200           jmp 0x807a
  007F98  8b46fc           mov ax, word ptr [bp - 4]
  007F9B  e9d000           jmp 0x806e
  007F9E  8d86f0fe         lea ax, [bp - 0x110]
  007FA2  50               push ax
  007FA3  ff76f2           push word ptr [bp - 0xe]
  007FA6  0e               push cs
  007FA7  e8d0fa           call 0x7a7a
  007FAA  83c404           add sp, 4
  007FAD  8d86f0fe         lea ax, [bp - 0x110]
  007FB1  16               push ss
  007FB2  50               push ax
  007FB3  ff76f6           push word ptr [bp - 0xa]
  007FB6  ff76f4           push word ptr [bp - 0xc]
  007FB9  0e               push cs
  007FBA  e853d6           call 0x5610
  007FBD  83c408           add sp, 8
  007FC0  e9b700           jmp 0x807a
  007FC3  90               nop
  007FC4  833e080600       cmp word ptr [0x608], 0
  007FC9  7441             je 0x800c
  007FCB  833ed05a00       cmp word ptr [0x5ad0], 0
  007FD0  7506             jne 0x7fd8
  007FD2  c706d05a0500     mov word ptr [0x5ad0], 5
  007FD8  8d86f0fe         lea ax, [bp - 0x110]
  007FDC  50               push ax
  007FDD  ff76f2           push word ptr [bp - 0xe]
  007FE0  0e               push cs
  007FE1  e896fa           call 0x7a7a
  007FE4  83c404           add sp, 4
  007FE7  ff36d05a         push word ptr [0x5ad0]
  007FEB  8d86a0fe         lea ax, [bp - 0x160]
  007FEF  16               push ss
  007FF0  50               push ax
  007FF1  8d86f0fe         lea ax, [bp - 0x110]
  007FF5  16               push ss
  007FF6  50               push ax
  007FF7  ff76f6           push word ptr [bp - 0xa]
  007FFA  ff76f4           push word ptr [bp - 0xc]
  007FFD  0e               push cs
  007FFE  e821d7           call 0x5722
  008001  83c40e           add sp, 0xe
  008004  8946f8           mov word ptr [bp - 8], ax
  008007  8956fa           mov word ptr [bp - 6], dx
  00800A  eb6e             jmp 0x807a
  00800C  8d86f0fe         lea ax, [bp - 0x110]
  008010  50               push ax
  008011  ff76f2           push word ptr [bp - 0xe]
  008014  0e               push cs
  008015  e862fa           call 0x7a7a
  008018  83c404           add sp, 4
  00801B  ffb69efe         push word ptr [bp - 0x162]
  00801F  8d86f0fe         lea ax, [bp - 0x110]
  008023  16               push ss
  008024  50               push ax
  008025  ff76f6           push word ptr [bp - 0xa]
  008028  ff76f4           push word ptr [bp - 0xc]
  00802B  0e               push cs
  00802C  e8afd3           call 0x53de
  00802F  83c40a           add sp, 0xa
  008032  89869afe         mov word ptr [bp - 0x166], ax
  008036  89969cfe         mov word ptr [bp - 0x164], dx
  00803A  837ef000         cmp word ptr [bp - 0x10], 0
  00803E  740a             je 0x804a
  008040  c49e9afe         les bx, ptr [bp - 0x166]
  008044  26c747060000     mov word ptr es:[bx + 6], 0
  00804A  8b8696fe         mov ax, word ptr [bp - 0x16a]
  00804E  39869efe         cmp word ptr [bp - 0x162], ax
  008052  7513             jne 0x8067
  008054  8b869afe         mov ax, word ptr [bp - 0x166]
  008058  8b969cfe         mov dx, word ptr [bp - 0x164]
  00805C  c45ef4           les bx, ptr [bp - 0xc]
  00805F  2689474c         mov word ptr es:[bx + 0x4c], ax
  008063  2689574e         mov word ptr es:[bx + 0x4e], dx
  008067  ff869efe         inc word ptr [bp - 0x162]
  00806B  eb0d             jmp 0x807a
  00806D  90               nop
  00806E  48               dec ax
  00806F  7503             jne 0x8074
  008071  e92aff           jmp 0x7f9e
  008074  48               dec ax
  008075  7503             jne 0x807a
  008077  e94aff           jmp 0x7fc4
  00807A  837efc03         cmp word ptr [bp - 4], 3
  00807E  7d03             jge 0x8083
  008080  e97ffc           jmp 0x7d02
  008083  8b46f6           mov ax, word ptr [bp - 0xa]
  008086  0b46f4           or ax, word ptr [bp - 0xc]
  008089  7512             jne 0x809d
  00808B  b8ffff           mov ax, 0xffff
  00808E  a35e05           mov word ptr [0x55e], ax
  008091  a35c05           mov word ptr [0x55c], ax
  008094  a36005           mov word ptr [0x560], ax
  008097  c70666050000     mov word ptr [0x566], 0
  00809D  8b46f4           mov ax, word ptr [bp - 0xc]
  0080A0  8b56f6           mov dx, word ptr [bp - 0xa]
  0080A3  5e               pop si
  0080A4  5f               pop di
  0080A5  c9               leave
  0080A6  cb               retf
  0080A7  90               nop

; ---- @popup_box  file 0x0080A8..0x0080DA  seg 0x33D:0x36d8  (popup.obj) ----
  0080A8  c8060000         enter 6, 0
  0080AC  c746fe0000       mov word ptr [bp - 2], 0
  0080B1  0e               push cs
  0080B2  e8cdfb           call 0x7c82
  0080B5  8946fa           mov word ptr [bp - 6], ax
  0080B8  8956fc           mov word ptr [bp - 4], dx
  0080BB  0bd0             or dx, ax
  0080BD  7416             je 0x80d5
  0080BF  ff76fc           push word ptr [bp - 4]
  0080C2  50               push ax
  0080C3  0e               push cs
  0080C4  e897ee           call 0x6f5e
  0080C7  8946fe           mov word ptr [bp - 2], ax
  0080CA  ff76fc           push word ptr [bp - 4]
  0080CD  ff76fa           push word ptr [bp - 6]
  0080D0  9a1003c90c       lcall 0xcc9, 0x310
  0080D5  8b46fe           mov ax, word ptr [bp - 2]
  0080D8  c9               leave
  0080D9  cb               retf

; ---- @pop_clear  file 0x0080DA..0x0080E2  seg 0x33D:0x370a  (popup.obj) ----
  0080DA  c70654050000     mov word ptr [0x554], 0
  0080E0  cb               retf
  0080E1  90               nop

; ---- @pop_set  file 0x0080E2..0x00810C  seg 0x33D:0x3712  (popup.obj) ----
  0080E2  55               push bp
  0080E3  8bec             mov bp, sp
  0080E5  50               push ax
  0080E6  ff4efe           dec word ptr [bp - 2]
  0080E9  0bd2             or dx, dx
  0080EB  740f             je 0x80fc
  0080ED  8a4efe           mov cl, byte ptr [bp - 2]
  0080F0  b80100           mov ax, 1
  0080F3  d3e0             shl ax, cl
  0080F5  09065405         or word ptr [0x554], ax
  0080F9  c9               leave
  0080FA  cb               retf
  0080FB  90               nop
  0080FC  8a4efe           mov cl, byte ptr [bp - 2]
  0080FF  b80100           mov ax, 1
  008102  d3e0             shl ax, cl
  008104  f7d0             not ax
  008106  21065405         and word ptr [0x554], ax
  00810A  c9               leave
  00810B  cb               retf

; ---- @pop_get  file 0x00810C..0x008122  seg 0x33D:0x373c  (popup.obj) ----
  00810C  55               push bp
  00810D  8bec             mov bp, sp
  00810F  50               push ax
  008110  b80100           mov ax, 1
  008113  2946fe           sub word ptr [bp - 2], ax
  008116  8a4efe           mov cl, byte ptr [bp - 2]
  008119  d3e0             shl ax, cl
  00811B  23065405         and ax, word ptr [0x554]
  00811F  c9               leave
  008120  cb               retf
  008121  90               nop

; ---- @pop  file 0x008122..0x008130  seg 0x33D:0x3752  (popup.obj) ----
  008122  8bc3             mov ax, bx
  008124  8d1e8400         lea bx, [0x84]
  008128  2bd2             sub dx, dx
  00812A  0e               push cs
  00812B  e87aff           call 0x80a8
  00812E  cb               retf
  00812F  90               nop

; ---- @pop2  file 0x008130..0x00813E  seg 0x33D:0x3760  (popup.obj) ----
  008130  8bd0             mov dx, ax
  008132  8bc3             mov ax, bx
  008134  8d1e8400         lea bx, [0x84]
  008138  0e               push cs
  008139  e86cff           call 0x80a8
  00813C  cb               retf
  00813D  90               nop

; ---- _popi  file 0x00813E..0x008156  seg 0x33D:0x376e  (popup.obj) ----
  00813E  55               push bp
  00813F  8bec             mov bp, sp
  008141  8b4608           mov ax, word ptr [bp + 8]
  008144  a35c05           mov word ptr [0x55c], ax
  008147  8d1e8400         lea bx, [0x84]
  00814B  8b4606           mov ax, word ptr [bp + 6]
  00814E  2bd2             sub dx, dx
  008150  0e               push cs
  008151  e854ff           call 0x80a8
  008154  c9               leave
  008155  cb               retf

; ---- @pop2i  file 0x008156..0x008168  seg 0x33D:0x3786  (popup.obj) ----
  008156  89165c05         mov word ptr [0x55c], dx
  00815A  8bd0             mov dx, ax
  00815C  8bc3             mov ax, bx
  00815E  8d1e8400         lea bx, [0x84]
  008162  0e               push cs
  008163  e842ff           call 0x80a8
  008166  cb               retf
  008167  90               nop

; ---- _popk  file 0x008168..0x008180  seg 0x33D:0x3798  (popup.obj) ----
  008168  55               push bp
  008169  8bec             mov bp, sp
  00816B  c7065c050800     mov word ptr [0x55c], 8
  008171  8d1e8400         lea bx, [0x84]
  008175  8b4606           mov ax, word ptr [bp + 6]
  008178  2bd2             sub dx, dx
  00817A  0e               push cs
  00817B  e82aff           call 0x80a8
  00817E  c9               leave
  00817F  cb               retf

; ---- _popm  file 0x008180..0x008198  seg 0x33D:0x37b0  (popup.obj) ----
  008180  55               push bp
  008181  8bec             mov bp, sp
  008183  8b4608           mov ax, word ptr [bp + 8]
  008186  a35e05           mov word ptr [0x55e], ax
  008189  8d1e8400         lea bx, [0x84]
  00818D  8b4606           mov ax, word ptr [bp + 6]
  008190  2bd2             sub dx, dx
  008192  0e               push cs
  008193  e812ff           call 0x80a8
  008196  c9               leave
  008197  cb               retf

; ---- @pop2m  file 0x008198..0x0081AA  seg 0x33D:0x37c8  (popup.obj) ----
  008198  89165e05         mov word ptr [0x55e], dx
  00819C  8bd0             mov dx, ax
  00819E  8bc3             mov ax, bx
  0081A0  8d1e8400         lea bx, [0x84]
  0081A4  0e               push cs
  0081A5  e800ff           call 0x80a8
  0081A8  cb               retf
  0081A9  90               nop

; ---- _popf  file 0x0081AA..0x0081C2  seg 0x33D:0x37da  (popup.obj) ----
  0081AA  55               push bp
  0081AB  8bec             mov bp, sp
  0081AD  8b4608           mov ax, word ptr [bp + 8]
  0081B0  a36005           mov word ptr [0x560], ax
  0081B3  8d1e8400         lea bx, [0x84]
  0081B7  8b4606           mov ax, word ptr [bp + 6]
  0081BA  2bd2             sub dx, dx
  0081BC  0e               push cs
  0081BD  e8e8fe           call 0x80a8
  0081C0  c9               leave
  0081C1  cb               retf

; ---- @pop2f  file 0x0081C2..0x0081D4  seg 0x33D:0x37f2  (popup.obj) ----
  0081C2  89166005         mov word ptr [0x560], dx
  0081C6  8bd0             mov dx, ax
  0081C8  8bc3             mov ax, bx
  0081CA  8d1e8400         lea bx, [0x84]
  0081CE  0e               push cs
  0081CF  e8d6fe           call 0x80a8
  0081D2  cb               retf
  0081D3  90               nop

; ---- _popup_off  file 0x0081D4..0x0081DA  seg 0x33D:0x3804  (popup.obj) ----
  0081D4  800e560518       or byte ptr [0x556], 0x18
  0081D9  cb               retf

; ---- @popup_ask  file 0x0081DA..0x008226  seg 0x33D:0x380a  (popup.obj) ----
  0081DA  c8060000         enter 6, 0
  0081DE  c70608060100     mov word ptr [0x608], 1
  0081E4  8b4e06           mov cx, word ptr [bp + 6]
  0081E7  890ed05a         mov word ptr [0x5ad0], cx
  0081EB  89162a5e         mov word ptr [0x5e2a], dx
  0081EF  2bd2             sub dx, dx
  0081F1  8956fe           mov word ptr [bp - 2], dx
  0081F4  0e               push cs
  0081F5  e88afa           call 0x7c82
  0081F8  8946fa           mov word ptr [bp - 6], ax
  0081FB  8956fc           mov word ptr [bp - 4], dx
  0081FE  0bd0             or dx, ax
  008200  7416             je 0x8218
  008202  ff76fc           push word ptr [bp - 4]
  008205  50               push ax
  008206  0e               push cs
  008207  e854ed           call 0x6f5e
  00820A  8946fe           mov word ptr [bp - 2], ax
  00820D  ff76fc           push word ptr [bp - 4]
  008210  ff76fa           push word ptr [bp - 6]
  008213  9a1003c90c       lcall 0xcc9, 0x310
  008218  c70608060000     mov word ptr [0x608], 0
  00821E  8b46fe           mov ax, word ptr [bp - 2]
  008221  c9               leave
  008222  ca0200           retf 2
  008225  90               nop

; ---- @popup_ask_number  file 0x008226..0x008268  seg 0x33D:0x3856  (popup.obj) ----
  008226  c8160000         enter 0x16, 0
  00822A  52               push dx
  00822B  50               push ax
  00822C  53               push bx
  00822D  57               push di
  00822E  56               push si
  00822F  6a0a             push 0xa
  008231  8d4eec           lea cx, [bp - 0x14]
  008234  51               push cx
  008235  52               push dx
  008236  8bf0             mov si, ax
  008238  8bfb             mov di, bx
  00823A  9a3c078813       lcall 0x1388, 0x73c
  00823F  83c406           add sp, 6
  008242  6a05             push 5
  008244  8bc6             mov ax, si
  008246  8bdf             mov bx, di
  008248  8d56ec           lea dx, [bp - 0x14]
  00824B  0e               push cs
  00824C  e88bff           call 0x81da
  00824F  8946ea           mov word ptr [bp - 0x16], ax
  008252  68644b           push 0x4b64
  008255  9a38078813       lcall 0x1388, 0x738
  00825A  83c402           add sp, 2
  00825D  a3d45a           mov word ptr [0x5ad4], ax
  008260  8b46ea           mov ax, word ptr [bp - 0x16]
  008263  5e               pop si
  008264  5f               pop di
  008265  c9               leave
  008266  cb               retf
  008267  90               nop

; ---- _popup_read_colors  file 0x008268..0x00838E  seg 0x33D:0x3898  (popup.obj) ----
  008268  c80e0000         enter 0xe, 0
  00826C  b80100           mov ax, 1
  00826F  8946f4           mov word ptr [bp - 0xc], ax
  008272  8946f2           mov word ptr [bp - 0xe], ax
  008275  8d46fa           lea ax, [bp - 6]
  008278  8946f6           mov word ptr [bp - 0xa], ax
  00827B  8c56f8           mov word ptr [bp - 8], ss
  00827E  8d1e0a06         lea bx, [0x60a]
  008282  2bc0             sub ax, ax
  008284  9a0800db0d       lcall 0xddb, 8
  008289  8946fc           mov word ptr [bp - 4], ax
  00828C  8956fe           mov word ptr [bp - 2], dx
  00828F  0bd0             or dx, ax
  008291  7503             jne 0x8296
  008293  e9df00           jmp 0x8375
  008296  ff76fe           push word ptr [bp - 2]
  008299  50               push ax
  00829A  6a00             push 0
  00829C  b80100           mov ax, 1
  00829F  8d5ef2           lea bx, [bp - 0xe]
  0082A2  2bd2             sub dx, dx
  0082A4  9a00008f0d       lcall 0xd8f, 0
  0082A9  8a46fa           mov al, byte ptr [bp - 6]
  0082AC  2ae4             sub ah, ah
  0082AE  a33c05           mov word ptr [0x53c], ax
  0082B1  ff76fe           push word ptr [bp - 2]
  0082B4  ff76fc           push word ptr [bp - 4]
  0082B7  6a00             push 0
  0082B9  b80200           mov ax, 2
  0082BC  8d5ef2           lea bx, [bp - 0xe]
  0082BF  2bd2             sub dx, dx
  0082C1  9a00008f0d       lcall 0xd8f, 0
  0082C6  8a46fa           mov al, byte ptr [bp - 6]
  0082C9  2ae4             sub ah, ah
  0082CB  a33e05           mov word ptr [0x53e], ax
  0082CE  ff76fe           push word ptr [bp - 2]
  0082D1  ff76fc           push word ptr [bp - 4]
  0082D4  6a00             push 0
  0082D6  b80300           mov ax, 3
  0082D9  8d5ef2           lea bx, [bp - 0xe]
  0082DC  2bd2             sub dx, dx
  0082DE  9a00008f0d       lcall 0xd8f, 0
  0082E3  8a46fa           mov al, byte ptr [bp - 6]
  0082E6  2ae4             sub ah, ah
  0082E8  a34005           mov word ptr [0x540], ax
  0082EB  ff76fe           push word ptr [bp - 2]
  0082EE  ff76fc           push word ptr [bp - 4]
  0082F1  6a00             push 0
  0082F3  b80400           mov ax, 4
  0082F6  8d5ef2           lea bx, [bp - 0xe]
  0082F9  2bd2             sub dx, dx
  0082FB  9a00008f0d       lcall 0xd8f, 0
  008300  8a46fa           mov al, byte ptr [bp - 6]
  008303  2ae4             sub ah, ah
  008305  a34205           mov word ptr [0x542], ax
  008308  ff76fe           push word ptr [bp - 2]
  00830B  ff76fc           push word ptr [bp - 4]
  00830E  6a00             push 0
  008310  b80500           mov ax, 5
  008313  8d5ef2           lea bx, [bp - 0xe]
  008316  2bd2             sub dx, dx
  008318  9a00008f0d       lcall 0xd8f, 0
  00831D  8a46fa           mov al, byte ptr [bp - 6]
  008320  2ae4             sub ah, ah
  008322  a34a05           mov word ptr [0x54a], ax
  008325  ff76fe           push word ptr [bp - 2]
  008328  ff76fc           push word ptr [bp - 4]
  00832B  6a00             push 0
  00832D  b80600           mov ax, 6
  008330  8d5ef2           lea bx, [bp - 0xe]
  008333  2bd2             sub dx, dx
  008335  9a00008f0d       lcall 0xd8f, 0
  00833A  8a46fa           mov al, byte ptr [bp - 6]
  00833D  2ae4             sub ah, ah
  00833F  a34e05           mov word ptr [0x54e], ax
  008342  ff76fe           push word ptr [bp - 2]
  008345  ff76fc           push word ptr [bp - 4]
  008348  6a00             push 0
  00834A  b80700           mov ax, 7
  00834D  8d5ef2           lea bx, [bp - 0xe]
  008350  2bd2             sub dx, dx
  008352  9a00008f0d       lcall 0xd8f, 0
  008357  8a46fa           mov al, byte ptr [bp - 6]
  00835A  2ae4             sub ah, ah
  00835C  a34c05           mov word ptr [0x54c], ax
  00835F  6800a0           push 0xa000
  008362  6800fc           push 0xfc00
  008365  9a0a00700d       lcall 0xd70, 0xa
  00836A  ff76fe           push word ptr [bp - 2]
  00836D  ff76fc           push word ptr [bp - 4]
  008370  9a1003c90c       lcall 0xcc9, 0x310
  008375  c9               leave
  008376  cb               retf
  008377  90               nop
  008378  55               push bp
  008379  8bec             mov bp, sp
  00837B  c45e04           les bx, ptr [bp + 4]
  00837E  268a1f           mov bl, byte ptr es:[bx]
  008381  2aff             sub bh, bh
  008383  83fb06           cmp bx, 6
  008386  7501             jne 0x8389
  008388  4b               dec bx
  008389  8bc3             mov ax, bx
  00838B  c9               leave
  00838C  c3               ret
  00838D  90               nop
