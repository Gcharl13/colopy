; MAPEDIT.EXE named disasm — module strings.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strings_init  file 0x00494A..0x00496C  seg 0x334:0xa  (strings.obj) ----
  00494A  55               push bp
  00494B  8bec             mov bp, sp
  00494D  1e               push ds
  00494E  68024a           push 0x4a02
  004951  ff7608           push word ptr [bp + 8]
  004954  ff7606           push word ptr [bp + 6]
  004957  1e               push ds
  004958  683405           push 0x534
  00495B  b80900           mov ax, 9
  00495E  9a0000450f       lcall 0xf45, 0
  004963  c70640600000     mov word ptr [0x6040], 0
  004969  c9               leave
  00496A  cb               retf
  00496B  90               nop

; ---- _strings_shrink  file 0x00496C..0x004976  seg 0x334:0x2c  (strings.obj) ----
  00496C  1e               push ds
  00496D  68024a           push 0x4a02
  004970  9a7401450f       lcall 0xf45, 0x174
  004975  cb               retf

; ---- _strings_store  file 0x004976..0x0049AC  seg 0x334:0x36  (strings.obj) ----
  004976  55               push bp
  004977  8bec             mov bp, sp
  004979  56               push si
  00497A  8b7606           mov si, word ptr [bp + 6]
  00497D  8b4608           mov ax, word ptr [bp + 8]
  004980  50               push ax
  004981  56               push si
  004982  1e               push ds
  004983  68024a           push 0x4a02
  004986  50               push ax
  004987  56               push si
  004988  9ad40d8813       lcall 0x1388, 0xdd4
  00498D  83c404           add sp, 4
  004990  40               inc ax
  004991  99               cdq
  004992  9a0a01450f       lcall 0xf45, 0x10a
  004997  52               push dx
  004998  50               push ax
  004999  9aec0d8813       lcall 0x1388, 0xdec
  00499E  83c408           add sp, 8
  0049A1  a14060           mov ax, word ptr [0x6040]
  0049A4  ff064060         inc word ptr [0x6040]
  0049A8  5e               pop si
  0049A9  c9               leave
  0049AA  cb               retf
  0049AB  90               nop

; ---- _strings  file 0x0049AC..0x004DAE  seg 0x334:0x6c  (strings.obj) ----
  0049AC  c8040000         enter 4, 0
  0049B0  57               push di
  0049B1  56               push si
  0049B2  a1044a           mov ax, word ptr [0x4a04]
  0049B5  8b16064a         mov dx, word ptr [0x4a06]
  0049B9  8946fc           mov word ptr [bp - 4], ax
  0049BC  8956fe           mov word ptr [bp - 2], dx
  0049BF  c47efc           les di, ptr [bp - 4]
  0049C2  8b5606           mov dx, word ptr [bp + 6]
  0049C5  0bd2             or dx, dx
  0049C7  740c             je 0x49d5
  0049C9  32c0             xor al, al
  0049CB  b9ffff           mov cx, 0xffff
  0049CE  f2ae             repne scasb al, byte ptr es:[di]
  0049D0  7503             jne 0x49d5
  0049D2  4a               dec dx
  0049D3  75f6             jne 0x49cb
  0049D5  8cc2             mov dx, es
  0049D7  8bc7             mov ax, di
  0049D9  5e               pop si
  0049DA  5f               pop di
  0049DB  c9               leave
  0049DC  cb               retf
  0049DD  90               nop
  0049DE  55               push bp
  0049DF  8bec             mov bp, sp
  0049E1  56               push si
  0049E2  8b4604           mov ax, word ptr [bp + 4]
  0049E5  8b5606           mov dx, word ptr [bp + 6]
  0049E8  058400           add ax, 0x84
  0049EB  52               push dx
  0049EC  50               push ax
  0049ED  53               push bx
  0049EE  8bf3             mov si, bx
  0049F0  9a84068813       lcall 0x1388, 0x684
  0049F5  83c402           add sp, 2
  0049F8  40               inc ax
  0049F9  2bd2             sub dx, dx
  0049FB  9a0a01450f       lcall 0xf45, 0x10a
  004A00  c45e04           les bx, ptr [bp + 4]
  004A03  2689476c         mov word ptr es:[bx + 0x6c], ax
  004A07  2689576e         mov word ptr es:[bx + 0x6e], dx
  004A0B  1e               push ds
  004A0C  56               push si
  004A0D  52               push dx
  004A0E  26ff776c         push word ptr es:[bx + 0x6c]
  004A12  9aec0d8813       lcall 0x1388, 0xdec
  004A17  83c408           add sp, 8
  004A1A  5e               pop si
  004A1B  c9               leave
  004A1C  c20400           ret 4
  004A1F  90               nop
  004A20  c8160000         enter 0x16, 0
  004A24  833e5c0507       cmp word ptr [0x55c], 7
  004A29  7e2d             jle 0x4a58
  004A2B  687205           push 0x572
  004A2E  8d46ec           lea ax, [bp - 0x14]
  004A31  50               push ax
  004A32  9a26068813       lcall 0x1388, 0x626
  004A37  83c404           add sp, 4
  004A3A  b80100           mov ax, 1
  004A3D  a36e05           mov word ptr [0x56e], ax
  004A40  a37e4e           mov word ptr [0x4e7e], ax
  004A43  9a0600180d       lcall 0xd18, 6
  004A48  05f000           add ax, 0xf0
  004A4B  83d200           adc dx, 0
  004A4E  a3864e           mov word ptr [0x4e86], ax
  004A51  8916884e         mov word ptr [0x4e88], dx
  004A55  eb38             jmp 0x4a8f
  004A57  90               nop
  004A58  ff36445e         push word ptr [0x5e44]
  004A5C  ff365c05         push word ptr [0x55c]
  004A60  9a12000000       lcall 0, 0x12
  004A65  83c404           add sp, 4
  004A68  50               push ax
  004A69  9a10000000       lcall 0, 0x10
  004A6E  83c402           add sp, 2
  004A71  8946ea           mov word ptr [bp - 0x16], ax
  004A74  687705           push 0x577
  004A77  8d46ec           lea ax, [bp - 0x14]
  004A7A  50               push ax
  004A7B  9a26068813       lcall 0x1388, 0x626
  004A80  83c404           add sp, 4
  004A83  a05c05           mov al, byte ptr [0x55c]
  004A86  0046ef           add byte ptr [bp - 0x11], al
  004A89  8a46ea           mov al, byte ptr [bp - 0x16]
  004A8C  0046f1           add byte ptr [bp - 0xf], al
  004A8F  ff7606           push word ptr [bp + 6]
  004A92  ff7604           push word ptr [bp + 4]
  004A95  8d5eec           lea bx, [bp - 0x14]
  004A98  e843ff           call 0x49de
  004A9B  c9               leave
  004A9C  c20400           ret 4
  004A9F  90               nop
  004AA0  c8140000         enter 0x14, 0
  004AA4  687e05           push 0x57e
  004AA7  8d46ec           lea ax, [bp - 0x14]
  004AAA  50               push ax
  004AAB  9a26068813       lcall 0x1388, 0x626
  004AB0  83c404           add sp, 4
  004AB3  a05e05           mov al, byte ptr [0x55e]
  004AB6  0046ef           add byte ptr [bp - 0x11], al
  004AB9  ff7606           push word ptr [bp + 6]
  004ABC  ff7604           push word ptr [bp + 4]
  004ABF  8d5eec           lea bx, [bp - 0x14]
  004AC2  e819ff           call 0x49de
  004AC5  c9               leave
  004AC6  c20400           ret 4
  004AC9  90               nop
  004ACA  c8140000         enter 0x14, 0
  004ACE  688305           push 0x583
  004AD1  8d46ec           lea ax, [bp - 0x14]
  004AD4  50               push ax
  004AD5  9a26068813       lcall 0x1388, 0x626
  004ADA  83c404           add sp, 4
  004ADD  a06005           mov al, byte ptr [0x560]
  004AE0  0046ef           add byte ptr [bp - 0x11], al
  004AE3  ff7606           push word ptr [bp + 6]
  004AE6  ff7604           push word ptr [bp + 4]
  004AE9  8d5eec           lea bx, [bp - 0x14]
  004AEC  e8effe           call 0x49de
  004AEF  c9               leave
  004AF0  c20400           ret 4
  004AF3  90               nop
  004AF4  c88c0000         enter 0x8c, 0
  004AF8  57               push di
  004AF9  56               push si
  004AFA  c45e04           les bx, ptr [bp + 4]
  004AFD  268b476e         mov ax, word ptr es:[bx + 0x6e]
  004B01  260b476c         or ax, word ptr es:[bx + 0x6c]
  004B05  7503             jne 0x4b0a
  004B07  e90a02           jmp 0x4d14
  004B0A  833e5c0507       cmp word ptr [0x55c], 7
  004B0F  7e05             jle 0x4b16
  004B11  b80100           mov ax, 1
  004B14  eb02             jmp 0x4b18
  004B16  2bc0             sub ax, ax
  004B18  89867aff         mov word ptr [bp - 0x86], ax
  004B1C  8bc3             mov ax, bx
  004B1E  8cc2             mov dx, es
  004B20  058400           add ax, 0x84
  004B23  52               push dx
  004B24  50               push ax
  004B25  8bf0             mov si, ax
  004B27  8cc7             mov di, es
  004B29  b81400           mov ax, 0x14
  004B2C  99               cdq
  004B2D  9a0a01450f       lcall 0xf45, 0x10a
  004B32  c45e04           les bx, ptr [bp + 4]
  004B35  26894768         mov word ptr es:[bx + 0x68], ax
  004B39  2689576a         mov word ptr es:[bx + 0x6a], dx
  004B3D  268b4768         mov ax, word ptr es:[bx + 0x68]
  004B41  89867cff         mov word ptr [bp - 0x84], ax
  004B45  89967eff         mov word ptr [bp - 0x82], dx
  004B49  8ec2             mov es, dx
  004B4B  8bd8             mov bx, ax
  004B4D  2bc0             sub ax, ax
  004B4F  26894712         mov word ptr es:[bx + 0x12], ax
  004B53  26894710         mov word ptr es:[bx + 0x10], ax
  004B57  39867aff         cmp word ptr [bp - 0x86], ax
  004B5B  741f             je 0x4b7c
  004B5D  57               push di
  004B5E  56               push si
  004B5F  b81400           mov ax, 0x14
  004B62  99               cdq
  004B63  9a0a01450f       lcall 0xf45, 0x10a
  004B68  898676ff         mov word ptr [bp - 0x8a], ax
  004B6C  899678ff         mov word ptr [bp - 0x88], dx
  004B70  c49e7cff         les bx, ptr [bp - 0x84]
  004B74  26894710         mov word ptr es:[bx + 0x10], ax
  004B78  26895712         mov word ptr es:[bx + 0x12], dx
  004B7C  c45e04           les bx, ptr [bp + 4]
  004B7F  26ff776e         push word ptr es:[bx + 0x6e]
  004B83  26ff776c         push word ptr es:[bx + 0x6c]
  004B87  8d4680           lea ax, [bp - 0x80]
  004B8A  16               push ss
  004B8B  50               push ax
  004B8C  9aec0d8813       lcall 0x1388, 0xdec
  004B91  83c408           add sp, 8
  004B94  a1643c           mov ax, word ptr [0x3c64]
  004B97  898674ff         mov word ptr [bp - 0x8c], ax
  004B9B  c706643c0000     mov word ptr [0x3c64], 0
  004BA1  6a01             push 1
  004BA3  9a16000000       lcall 0, 0x16
  004BA8  83c402           add sp, 2
  004BAB  6a30             push 0x30
  004BAD  6800a0           push 0xa000
  004BB0  6800fc           push 0xfc00
  004BB3  8d46d0           lea ax, [bp - 0x30]
  004BB6  16               push ss
  004BB7  50               push ax
  004BB8  9a4a0c8813       lcall 0x1388, 0xc4a
  004BBD  83c40a           add sp, 0xa
  004BC0  c706e03a00fc     mov word ptr [0x3ae0], 0xfc00
  004BC6  c706e23a00a0     mov word ptr [0x3ae2], 0xa000
  004BCC  8d5e80           lea bx, [bp - 0x80]
  004BCF  2bc0             sub ax, ax
  004BD1  9a0800db0d       lcall 0xddb, 8
  004BD6  c49e7cff         les bx, ptr [bp - 0x84]
  004BDA  2689470c         mov word ptr es:[bx + 0xc], ax
  004BDE  2689570e         mov word ptr es:[bx + 0xe], dx
  004BE2  8bc2             mov ax, dx
  004BE4  260b470c         or ax, word ptr es:[bx + 0xc]
  004BE8  7521             jne 0x4c0b
  004BEA  9a00000000       lcall 0, 0
  004BEF  c70670050100     mov word ptr [0x570], 1
  004BF5  8d5e80           lea bx, [bp - 0x80]
  004BF8  2bc0             sub ax, ax
  004BFA  9a0a000000       lcall 0, 0xa
  004BFF  c49e7cff         les bx, ptr [bp - 0x84]
  004C03  2689470c         mov word ptr es:[bx + 0xc], ax
  004C07  2689570e         mov word ptr es:[bx + 0xe], dx
  004C0B  6a30             push 0x30
  004C0D  8d46d0           lea ax, [bp - 0x30]
  004C10  16               push ss
  004C11  50               push ax
  004C12  6800a0           push 0xa000
  004C15  6800fc           push 0xfc00
  004C18  9a4a0c8813       lcall 0x1388, 0xc4a
  004C1D  83c40a           add sp, 0xa
  004C20  2bc0             sub ax, ax
  004C22  a3e23a           mov word ptr [0x3ae2], ax
  004C25  a3e03a           mov word ptr [0x3ae0], ax
  004C28  c49e7cff         les bx, ptr [bp - 0x84]
  004C2C  268b470e         mov ax, word ptr es:[bx + 0xe]
  004C30  260b470c         or ax, word ptr es:[bx + 0xc]
  004C34  7510             jne 0x4c46
  004C36  c45e04           les bx, ptr [bp + 4]
  004C39  2bc0             sub ax, ax
  004C3B  2689476a         mov word ptr es:[bx + 0x6a], ax
  004C3F  26894768         mov word ptr es:[bx + 0x68], ax
  004C43  e9bf00           jmp 0x4d05
  004C46  83be7aff00       cmp word ptr [bp - 0x86], 0
  004C4B  7469             je 0x4cb6
  004C4D  688805           push 0x588
  004C50  8d4680           lea ax, [bp - 0x80]
  004C53  50               push ax
  004C54  9ae6058813       lcall 0x1388, 0x5e6
  004C59  83c404           add sp, 4
  004C5C  833e700500       cmp word ptr [0x570], 0
  004C61  7516             jne 0x4c79
  004C63  8d5e80           lea bx, [bp - 0x80]
  004C66  2bc0             sub ax, ax
  004C68  9a0800db0d       lcall 0xddb, 8
  004C6D  c49e76ff         les bx, ptr [bp - 0x8a]
  004C71  2689470c         mov word ptr es:[bx + 0xc], ax
  004C75  2689570e         mov word ptr es:[bx + 0xe], dx
  004C79  c49e76ff         les bx, ptr [bp - 0x8a]
  004C7D  268b470e         mov ax, word ptr es:[bx + 0xe]
  004C81  260b470c         or ax, word ptr es:[bx + 0xc]
  004C85  7512             jne 0x4c99
  004C87  833e700500       cmp word ptr [0x570], 0
  004C8C  750b             jne 0x4c99
  004C8E  c70670050200     mov word ptr [0x570], 2
  004C94  9a00000000       lcall 0, 0
  004C99  833e700500       cmp word ptr [0x570], 0
  004C9E  7416             je 0x4cb6
  004CA0  8d5e80           lea bx, [bp - 0x80]
  004CA3  2bc0             sub ax, ax
  004CA5  9a0a000000       lcall 0, 0xa
  004CAA  c49e76ff         les bx, ptr [bp - 0x8a]
  004CAE  2689470c         mov word ptr es:[bx + 0xc], ax
  004CB2  2689570e         mov word ptr es:[bx + 0xe], dx
  004CB6  6a00             push 0
  004CB8  9a16000000       lcall 0, 0x16
  004CBD  83c402           add sp, 2
  004CC0  83be7aff00       cmp word ptr [bp - 0x86], 0
  004CC5  7433             je 0x4cfa
  004CC7  c49e76ff         les bx, ptr [bp - 0x8a]
  004CCB  268b470e         mov ax, word ptr es:[bx + 0xe]
  004CCF  260b470c         or ax, word ptr es:[bx + 0xc]
  004CD3  7525             jne 0x4cfa
  004CD5  833e700501       cmp word ptr [0x570], 1
  004CDA  7411             je 0x4ced
  004CDC  c49e7cff         les bx, ptr [bp - 0x84]
  004CE0  26ff770e         push word ptr es:[bx + 0xe]
  004CE4  26ff770c         push word ptr es:[bx + 0xc]
  004CE8  9a1003c90c       lcall 0xcc9, 0x310
  004CED  c45e04           les bx, ptr [bp + 4]
  004CF0  2bc0             sub ax, ax
  004CF2  2689476a         mov word ptr es:[bx + 0x6a], ax
  004CF6  26894768         mov word ptr es:[bx + 0x68], ax
  004CFA  6800a0           push 0xa000
  004CFD  6800fc           push 0xfc00
  004D00  9a0a00700d       lcall 0xd70, 0xa
  004D05  2bc0             sub ax, ax
  004D07  a3e23a           mov word ptr [0x3ae2], ax
  004D0A  a3e03a           mov word ptr [0x3ae0], ax
  004D0D  8b8674ff         mov ax, word ptr [bp - 0x8c]
  004D11  a3643c           mov word ptr [0x3c64], ax
  004D14  5e               pop si
  004D15  5f               pop di
  004D16  c9               leave
  004D17  c20400           ret 4
  004D1A  55               push bp
  004D1B  8bec             mov bp, sp
  004D1D  50               push ax
  004D1E  833e6c0500       cmp word ptr [0x56c], 0
  004D23  7469             je 0x4d8e
  004D25  807e0a07         cmp byte ptr [bp + 0xa], 7
  004D29  7563             jne 0x4d8e
  004D2B  833e8a0500       cmp word ptr [0x58a], 0
  004D30  7428             je 0x4d5a
  004D32  ff36023b         push word ptr [0x3b02]
  004D36  ff36003b         push word ptr [0x3b00]
  004D3A  ff36fe3a         push word ptr [0x3afe]
  004D3E  ff36fc3a         push word ptr [0x3afc]
  004D42  ff761a           push word ptr [bp + 0x1a]
  004D45  ff7618           push word ptr [bp + 0x18]
  004D48  ff7616           push word ptr [bp + 0x16]
  004D4B  ff7614           push word ptr [bp + 0x14]
  004D4E  ff7612           push word ptr [bp + 0x12]
  004D51  9a00004c0c       lcall 0xc4c, 0
  004D56  c9               leave
  004D57  c21800           ret 0x18
  004D5A  ff760e           push word ptr [bp + 0xe]
  004D5D  ff7610           push word ptr [bp + 0x10]
  004D60  ff7612           push word ptr [bp + 0x12]
  004D63  53               push bx
  004D64  52               push dx
  004D65  50               push ax
  004D66  8b1e6c05         mov bx, word ptr [0x56c]
  004D6A  ff7706           push word ptr [bx + 6]
  004D6D  ff7704           push word ptr [bx + 4]
  004D70  ff7702           push word ptr [bx + 2]
  004D73  ff37             push word ptr [bx]
  004D75  ff761a           push word ptr [bp + 0x1a]
  004D78  ff7618           push word ptr [bp + 0x18]
  004D7B  ff7616           push word ptr [bp + 0x16]
  004D7E  ff7614           push word ptr [bp + 0x14]
  004D81  9a0000b90c       lcall 0xcb9, 0
  004D86  83c41c           add sp, 0x1c
  004D89  c9               leave
  004D8A  c21800           ret 0x18
  004D8D  90               nop
  004D8E  ff761a           push word ptr [bp + 0x1a]
  004D91  ff7618           push word ptr [bp + 0x18]
  004D94  ff7616           push word ptr [bp + 0x16]
  004D97  ff7614           push word ptr [bp + 0x14]
  004D9A  ff7612           push word ptr [bp + 0x12]
  004D9D  8a460a           mov al, byte ptr [bp + 0xa]
  004DA0  50               push ax
  004DA1  8b46fe           mov ax, word ptr [bp - 2]
  004DA4  9a04005b0c       lcall 0xc5b, 4
  004DA9  c9               leave
  004DAA  c21800           ret 0x18
  004DAD  90               nop
