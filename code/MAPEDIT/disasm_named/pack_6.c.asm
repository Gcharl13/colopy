; MAPEDIT.EXE named disasm — module pack_6.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _far_to_near  file 0x01469A..0x0146BA  seg 0x1309:0xa  (pack_6.c.obj) ----
  01469A  55               push bp
  01469B  8bec             mov bp, sp
  01469D  c45e06           les bx, ptr [bp + 6]
  0146A0  8bc3             mov ax, bx
  0146A2  c9               leave
  0146A3  cb               retf
  0146A4  55               push bp
  0146A5  8bec             mov bp, sp
  0146A7  57               push di
  0146A8  c43e1645         les di, ptr [0x4516]
  0146AC  8cc0             mov ax, es
  0146AE  0bc7             or ax, di
  0146B0  7404             je 0x146b6
  0146B2  ff1e1645         lcall [0x4516]
  0146B6  5f               pop di
  0146B7  c9               leave
  0146B8  cb               retf
  0146B9  90               nop

; ---- _pack_set_special_buffer  file 0x0146BA..0x0146DA  seg 0x1309:0x2a  (pack_6.c.obj) ----
  0146BA  55               push bp
  0146BB  8bec             mov bp, sp
  0146BD  8b4606           mov ax, word ptr [bp + 6]
  0146C0  8b5608           mov dx, word ptr [bp + 8]
  0146C3  a31245           mov word ptr [0x4512], ax
  0146C6  89161445         mov word ptr [0x4514], dx
  0146CA  8b460a           mov ax, word ptr [bp + 0xa]
  0146CD  8b560c           mov dx, word ptr [bp + 0xc]
  0146D0  a31645           mov word ptr [0x4516], ax
  0146D3  89161845         mov word ptr [0x4518], dx
  0146D7  c9               leave
  0146D8  cb               retf
  0146D9  90               nop

; ---- @pack_data  file 0x0146DA..0x0149EA  seg 0x1309:0x4a  (pack_6.c.obj) ----
  0146DA  c8060000         enter 6, 0
  0146DE  53               push bx
  0146DF  52               push dx
  0146E0  50               push ax
  0146E1  57               push di
  0146E2  56               push si
  0146E3  c746fc0000       mov word ptr [bp - 4], 0
  0146E8  0bd2             or dx, dx
  0146EA  751c             jne 0x14708
  0146EC  c70642600600     mov word ptr [0x6042], 6
  0146F2  c70644605913     mov word ptr [0x6044], 0x1359
  0146F8  8b460a           mov ax, word ptr [bp + 0xa]
  0146FB  8b560c           mov dx, word ptr [bp + 0xc]
  0146FE  a34863           mov word ptr [0x6348], ax
  014701  89164a63         mov word ptr [0x634a], dx
  014705  eb1d             jmp 0x14724
  014707  90               nop
  014708  c70642600800     mov word ptr [0x6042], 8
  01470E  c70644606713     mov word ptr [0x6044], 0x1367
  014714  ff760c           push word ptr [bp + 0xc]
  014717  ff760a           push word ptr [bp + 0xa]
  01471A  0e               push cs
  01471B  e87cff           call 0x1469a
  01471E  83c404           add sp, 4
  014721  a37c4e           mov word ptr [0x4e7c], ax
  014724  837ef802         cmp word ptr [bp - 8], 2
  014728  7528             jne 0x14752
  01472A  c706e8640400     mov word ptr [0x64e8], 4
  014730  c706ea647813     mov word ptr [0x64ea], 0x1378
  014736  8b5e06           mov bx, word ptr [bp + 6]
  014739  8e4608           mov es, word ptr [bp + 8]
  01473C  268b07           mov ax, word ptr es:[bx]
  01473F  a37869           mov word ptr [0x6978], ax
  014742  268b4702         mov ax, word ptr es:[bx + 2]
  014746  a3b44b           mov word ptr [0x4bb4], ax
  014749  268b4704         mov ax, word ptr es:[bx + 4]
  01474D  a3824e           mov word ptr [0x4e82], ax
  014750  eb3e             jmp 0x14790
  014752  837ef800         cmp word ptr [bp - 8], 0
  014756  751c             jne 0x14774
  014758  c706e8640a00     mov word ptr [0x64e8], 0xa
  01475E  c706ea646013     mov word ptr [0x64ea], 0x1360
  014764  8b4606           mov ax, word ptr [bp + 6]
  014767  8b5608           mov dx, word ptr [bp + 8]
  01476A  a39e5a           mov word ptr [0x5a9e], ax
  01476D  8916a05a         mov word ptr [0x5aa0], dx
  014771  eb1d             jmp 0x14790
  014773  90               nop
  014774  c706e8640200     mov word ptr [0x64e8], 2
  01477A  c706ea646f13     mov word ptr [0x64ea], 0x136f
  014780  ff7608           push word ptr [bp + 8]
  014783  ff7606           push word ptr [bp + 6]
  014786  0e               push cs
  014787  e810ff           call 0x1469a
  01478A  83c404           add sp, 4
  01478D  a37a4e           mov word ptr [0x4e7a], ax
  014790  2bc0             sub ax, ax
  014792  a38669           mov word ptr [0x6986], ax
  014795  a38469           mov word ptr [0x6984], ax
  014798  a30c4b           mov word ptr [0x4b0c], ax
  01479B  a30a4b           mov word ptr [0x4b0a], ax
  01479E  8b46f4           mov ax, word ptr [bp - 0xc]
  0147A1  0bc0             or ax, ax
  0147A3  742d             je 0x147d2
  0147A5  48               dec ax
  0147A6  7503             jne 0x147ab
  0147A8  e98d00           jmp 0x14838
  0147AB  c70628600010     mov word ptr [0x6028], 0x1000
  0147B1  8b460e           mov ax, word ptr [bp + 0xe]
  0147B4  8b5610           mov dx, word ptr [bp + 0x10]
  0147B7  a39052           mov word ptr [0x5290], ax
  0147BA  89169252         mov word ptr [0x5292], dx
  0147BE  a3844a           mov word ptr [0x4a84], ax
  0147C1  8916864a         mov word ptr [0x4a86], dx
  0147C5  c746fa9052       mov word ptr [bp - 6], 0x5290
  0147CA  c746fe8469       mov word ptr [bp - 2], 0x6984
  0147CF  e92201           jmp 0x148f4
  0147D2  833e8c4401       cmp word ptr [0x448c], 1
  0147D7  750f             jne 0x147e8
  0147D9  c7062860d0d1     mov word ptr [0x6028], 0xd1d0
  0147DF  a19844           mov ax, word ptr [0x4498]
  0147E2  0b069644         or ax, word ptr [0x4496]
  0147E6  eb0d             jmp 0x147f5
  0147E8  c7062860b889     mov word ptr [0x6028], 0x89b8
  0147EE  a19044           mov ax, word ptr [0x4490]
  0147F1  0b068e44         or ax, word ptr [0x448e]
  0147F5  751a             jne 0x14811
  0147F7  8b46f4           mov ax, word ptr [bp - 0xc]
  0147FA  99               cdq
  0147FB  52               push dx
  0147FC  50               push ax
  0147FD  a18c44           mov ax, word ptr [0x448c]
  014800  99               cdq
  014801  52               push dx
  014802  50               push ax
  014803  b8e3ff           mov ax, 0xffe3
  014806  ba0300           mov dx, 3
  014809  bb1800           mov bx, 0x18
  01480C  9ad603d00e       lcall 0xed0, 0x3d6
  014811  8b460e           mov ax, word ptr [bp + 0xe]
  014814  8b5610           mov dx, word ptr [bp + 0x10]
  014817  a39052           mov word ptr [0x5290], ax
  01481A  89169252         mov word ptr [0x5292], dx
  01481E  c706844affff     mov word ptr [0x4a84], 0xffff
  014824  c706864affff     mov word ptr [0x4a86], 0xffff
  01482A  c746fa9052       mov word ptr [bp - 6], 0x5290
  01482F  c746fe0a4b       mov word ptr [bp - 2], 0x4b0a
  014834  e9bd00           jmp 0x148f4
  014837  90               nop
  014838  c7069052ffff     mov word ptr [0x5290], 0xffff
  01483E  c7069252ffff     mov word ptr [0x5292], 0xffff
  014844  8b460e           mov ax, word ptr [bp + 0xe]
  014847  8b5610           mov dx, word ptr [bp + 0x10]
  01484A  a3844a           mov word ptr [0x4a84], ax
  01484D  8916864a         mov word ptr [0x4a86], dx
  014851  c746fa844a       mov word ptr [bp - 6], 0x4a84
  014856  833e8c4401       cmp word ptr [0x448c], 1
  01485B  7569             jne 0x148c6
  01485D  837ef600         cmp word ptr [bp - 0xa], 0
  014861  7523             jne 0x14886
  014863  837ef800         cmp word ptr [bp - 8], 0
  014867  751d             jne 0x14886
  014869  a1a444           mov ax, word ptr [0x44a4]
  01486C  0b06a244         or ax, word ptr [0x44a2]
  014870  7414             je 0x14886
  014872  8d460e           lea ax, [bp + 0xe]
  014875  8946fe           mov word ptr [bp - 2], ax
  014878  c70628600400     mov word ptr [0x6028], 4
  01487E  c746fc0200       mov word ptr [bp - 4], 2
  014883  eb6f             jmp 0x148f4
  014885  90               nop
  014886  837ef801         cmp word ptr [bp - 8], 1
  01488A  7420             je 0x148ac
  01488C  837ef802         cmp word ptr [bp - 8], 2
  014890  741a             je 0x148ac
  014892  8d460e           lea ax, [bp + 0xe]
  014895  8946fe           mov word ptr [bp - 2], ax
  014898  c70628602208     mov word ptr [0x6028], 0x822
  01489E  c746fc0100       mov word ptr [bp - 4], 1
  0148A3  a1a044           mov ax, word ptr [0x44a0]
  0148A6  0b069e44         or ax, word ptr [0x449e]
  0148AA  eb2c             jmp 0x148d8
  0148AC  c746fe8469       mov word ptr [bp - 2], 0x6984
  0148B1  c70628602e38     mov word ptr [0x6028], 0x382e
  0148B7  c746fc0000       mov word ptr [bp - 4], 0
  0148BC  a19c44           mov ax, word ptr [0x449c]
  0148BF  0b069a44         or ax, word ptr [0x449a]
  0148C3  eb13             jmp 0x148d8
  0148C5  90               nop
  0148C6  c746fe8469       mov word ptr [bp - 2], 0x6984
  0148CB  c70628601e31     mov word ptr [0x6028], 0x311e
  0148D1  a19444           mov ax, word ptr [0x4494]
  0148D4  0b069244         or ax, word ptr [0x4492]
  0148D8  751a             jne 0x148f4
  0148DA  8b46f4           mov ax, word ptr [bp - 0xc]
  0148DD  99               cdq
  0148DE  52               push dx
  0148DF  50               push ax
  0148E0  a18c44           mov ax, word ptr [0x448c]
  0148E3  99               cdq
  0148E4  52               push dx
  0148E5  50               push ax
  0148E6  b8e3ff           mov ax, 0xffe3
  0148E9  ba0300           mov dx, 3
  0148EC  bb1800           mov bx, 0x18
  0148EF  9ad603d00e       lcall 0xed0, 0x3d6
  0148F4  2bc0             sub ax, ax
  0148F6  a3a64e           mov word ptr [0x4ea6], ax
  0148F9  a3a44e           mov word ptr [0x4ea4], ax
  0148FC  a11445           mov ax, word ptr [0x4514]
  0148FF  0b061245         or ax, word ptr [0x4512]
  014903  752b             jne 0x14930
  014905  1e               push ds
  014906  681a45           push 0x451a
  014909  a12860           mov ax, word ptr [0x6028]
  01490C  2bd2             sub dx, dx
  01490E  9a3601c90c       lcall 0xcc9, 0x136
  014913  a3a44e           mov word ptr [0x4ea4], ax
  014916  8916a64e         mov word ptr [0x4ea6], dx
  01491A  8bc2             mov ax, dx
  01491C  0b06a44e         or ax, word ptr [0x4ea4]
  014920  751c             jne 0x1493e
  014922  8b5efe           mov bx, word ptr [bp - 2]
  014925  2bc0             sub ax, ax
  014927  894702           mov word ptr [bx + 2], ax
  01492A  8907             mov word ptr [bx], ax
  01492C  e98800           jmp 0x149b7
  01492F  90               nop
  014930  a11245           mov ax, word ptr [0x4512]
  014933  8b161445         mov dx, word ptr [0x4514]
  014937  a3a44e           mov word ptr [0x4ea4], ax
  01493A  8916a64e         mov word ptr [0x4ea6], dx
  01493E  837ef401         cmp word ptr [bp - 0xc], 1
  014942  7530             jne 0x14974
  014944  837ef800         cmp word ptr [bp - 8], 0
  014948  752a             jne 0x14974
  01494A  8b46f4           mov ax, word ptr [bp - 0xc]
  01494D  8b56fc           mov dx, word ptr [bp - 4]
  014950  9a86000212       lcall 0x1202, 0x86
  014955  8bf0             mov si, ax
  014957  0bf6             or si, si
  014959  745c             je 0x149b7
  01495B  8b5efe           mov bx, word ptr [bp - 2]
  01495E  2bc0             sub ax, ax
  014960  894702           mov word ptr [bx + 2], ax
  014963  8907             mov word ptr [bx], ax
  014965  6946f4e803       imul ax, word ptr [bp - 0xc], 0x3e8
  01496A  0346fc           add ax, word ptr [bp - 4]
  01496D  99               cdq
  01496E  52               push dx
  01496F  50               push ax
  014970  8bc6             mov ax, si
  014972  eb32             jmp 0x149a6
  014974  8b76fa           mov si, word ptr [bp - 6]
  014977  8b7ef4           mov di, word ptr [bp - 0xc]
  01497A  837c0200         cmp word ptr [si + 2], 0
  01497E  7c37             jl 0x149b7
  014980  7f05             jg 0x14987
  014982  833c00           cmp word ptr [si], 0
  014985  7430             je 0x149b7
  014987  8bc7             mov ax, di
  014989  2bd2             sub dx, dx
  01498B  9a86000212       lcall 0x1202, 0x86
  014990  0bc0             or ax, ax
  014992  74e6             je 0x1497a
  014994  8b5efe           mov bx, word ptr [bp - 2]
  014997  2bc0             sub ax, ax
  014999  894702           mov word ptr [bx + 2], ax
  01499C  8907             mov word ptr [bx], ax
  01499E  8bc7             mov ax, di
  0149A0  99               cdq
  0149A1  52               push dx
  0149A2  50               push ax
  0149A3  8b46f8           mov ax, word ptr [bp - 8]
  0149A6  99               cdq
  0149A7  52               push dx
  0149A8  50               push ax
  0149A9  b8e4ff           mov ax, 0xffe4
  0149AC  ba0300           mov dx, 3
  0149AF  bb1800           mov bx, 0x18
  0149B2  9ad603d00e       lcall 0xed0, 0x3d6
  0149B7  a11445           mov ax, word ptr [0x4514]
  0149BA  0b061245         or ax, word ptr [0x4512]
  0149BE  7518             jne 0x149d8
  0149C0  a1a64e           mov ax, word ptr [0x4ea6]
  0149C3  0b06a44e         or ax, word ptr [0x4ea4]
  0149C7  7413             je 0x149dc
  0149C9  ff36a64e         push word ptr [0x4ea6]
  0149CD  ff36a44e         push word ptr [0x4ea4]
  0149D1  9a1003c90c       lcall 0xcc9, 0x310
  0149D6  eb04             jmp 0x149dc
  0149D8  0e               push cs
  0149D9  e8c8fc           call 0x146a4
  0149DC  8b5efe           mov bx, word ptr [bp - 2]
  0149DF  8b07             mov ax, word ptr [bx]
  0149E1  8b5702           mov dx, word ptr [bx + 2]
  0149E4  5e               pop si
  0149E5  5f               pop di
  0149E6  c9               leave
  0149E7  ca0c00           retf 0xc
