; MAPEDIT.EXE named disasm — module output.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __output  file 0x016526..0x0169FE  seg 0x1388:0x16a6  (output.asm.obj) ----
  016526  55               push bp
  016527  8bec             mov bp, sp
  016529  b87101           mov ax, 0x171
  01652C  0e               push cs
  01652D  e8eeeb           call 0x1511e
  016530  56               push si
  016531  57               push di
  016532  33c0             xor ax, ax
  016534  8946f8           mov word ptr [bp - 8], ax
  016537  8846fb           mov byte ptr [bp - 5], al
  01653A  8b7608           mov si, word ptr [bp + 8]
  01653D  ac               lodsb al, byte ptr [si]
  01653E  897608           mov word ptr [bp + 8], si
  016541  8846fe           mov byte ptr [bp - 2], al
  016544  0ac0             or al, al
  016546  7406             je 0x1654e
  016548  837ef800         cmp word ptr [bp - 8], 0
  01654C  7d06             jge 0x16554
  01654E  8b46f8           mov ax, word ptr [bp - 8]
  016551  e9a304           jmp 0x169f7
  016554  bb0e48           mov bx, 0x480e
  016557  2c20             sub al, 0x20
  016559  3c58             cmp al, 0x58
  01655B  7705             ja 0x16562
  01655D  d7               xlatb
  01655E  240f             and al, 0xf
  016560  eb02             jmp 0x16564
  016562  b000             mov al, 0
  016564  b103             mov cl, 3
  016566  d2e0             shl al, cl
  016568  0246fb           add al, byte ptr [bp - 5]
  01656B  d7               xlatb
  01656C  fec1             inc cl
  01656E  d2e8             shr al, cl
  016570  8846fb           mov byte ptr [bp - 5], al
  016573  98               cwde
  016574  8bd8             mov bx, ax
  016576  d1e3             shl bx, 1
  016578  2effa79616       jmp word ptr cs:[bx + 0x1696]
  01657D  8a56fe           mov dl, byte ptr [bp - 2]
  016580  b90100           mov cx, 1
  016583  e82404           call 0x169aa
  016586  ebb2             jmp 0x1653a
  016588  33c0             xor ax, ax
  01658A  8946f0           mov word ptr [bp - 0x10], ax
  01658D  8946f6           mov word ptr [bp - 0xa], ax
  016590  8946ee           mov word ptr [bp - 0x12], ax
  016593  8946fc           mov word ptr [bp - 4], ax
  016596  48               dec ax
  016597  8946f4           mov word ptr [bp - 0xc], ax
  01659A  eb9e             jmp 0x1653a
  01659C  8a46fe           mov al, byte ptr [bp - 2]
  01659F  3c2d             cmp al, 0x2d
  0165A1  7506             jne 0x165a9
  0165A3  804efc04         or byte ptr [bp - 4], 4
  0165A7  eb91             jmp 0x1653a
  0165A9  3c2b             cmp al, 0x2b
  0165AB  7506             jne 0x165b3
  0165AD  804efc01         or byte ptr [bp - 4], 1
  0165B1  eb87             jmp 0x1653a
  0165B3  3c20             cmp al, 0x20
  0165B5  7507             jne 0x165be
  0165B7  804efc02         or byte ptr [bp - 4], 2
  0165BB  e97cff           jmp 0x1653a
  0165BE  3c23             cmp al, 0x23
  0165C0  7507             jne 0x165c9
  0165C2  804efc80         or byte ptr [bp - 4], 0x80
  0165C6  e971ff           jmp 0x1653a
  0165C9  804efc08         or byte ptr [bp - 4], 8
  0165CD  e96aff           jmp 0x1653a
  0165D0  8a4efe           mov cl, byte ptr [bp - 2]
  0165D3  80f92a           cmp cl, 0x2a
  0165D6  750f             jne 0x165e7
  0165D8  e85603           call 0x16931
  0165DB  0bc0             or ax, ax
  0165DD  7917             jns 0x165f6
  0165DF  f7d8             neg ax
  0165E1  804efc04         or byte ptr [bp - 4], 4
  0165E5  eb0f             jmp 0x165f6
  0165E7  80e930           sub cl, 0x30
  0165EA  32ed             xor ch, ch
  0165EC  8b46f6           mov ax, word ptr [bp - 0xa]
  0165EF  bb0a00           mov bx, 0xa
  0165F2  f7e3             mul bx
  0165F4  03c1             add ax, cx
  0165F6  8946f6           mov word ptr [bp - 0xa], ax
  0165F9  e93eff           jmp 0x1653a
  0165FC  c746f40000       mov word ptr [bp - 0xc], 0
  016601  e936ff           jmp 0x1653a
  016604  8a4efe           mov cl, byte ptr [bp - 2]
  016607  80f92a           cmp cl, 0x2a
  01660A  750c             jne 0x16618
  01660C  e82203           call 0x16931
  01660F  0bc0             or ax, ax
  016611  7914             jns 0x16627
  016613  b8ffff           mov ax, 0xffff
  016616  eb0f             jmp 0x16627
  016618  80e930           sub cl, 0x30
  01661B  32ed             xor ch, ch
  01661D  8b46f4           mov ax, word ptr [bp - 0xc]
  016620  bb0a00           mov bx, 0xa
  016623  f7e3             mul bx
  016625  03c1             add ax, cx
  016627  8946f4           mov word ptr [bp - 0xc], ax
  01662A  e90dff           jmp 0x1653a
  01662D  8a46fe           mov al, byte ptr [bp - 2]
  016630  3c6c             cmp al, 0x6c
  016632  7506             jne 0x1663a
  016634  804efc10         or byte ptr [bp - 4], 0x10
  016638  eb22             jmp 0x1665c
  01663A  3c46             cmp al, 0x46
  01663C  7506             jne 0x16644
  01663E  804efc20         or byte ptr [bp - 4], 0x20
  016642  eb18             jmp 0x1665c
  016644  3c4e             cmp al, 0x4e
  016646  7506             jne 0x1664e
  016648  804efd10         or byte ptr [bp - 3], 0x10
  01664C  eb0e             jmp 0x1665c
  01664E  3c4c             cmp al, 0x4c
  016650  7506             jne 0x16658
  016652  804efd04         or byte ptr [bp - 3], 4
  016656  eb04             jmp 0x1665c
  016658  804efd08         or byte ptr [bp - 3], 8
  01665C  e9dbfe           jmp 0x1653a
  01665F  8a46fe           mov al, byte ptr [bp - 2]
  016662  3c64             cmp al, 0x64
  016664  7503             jne 0x16669
  016666  e98e01           jmp 0x167f7
  016669  3c69             cmp al, 0x69
  01666B  7503             jne 0x16670
  01666D  e98701           jmp 0x167f7
  016670  3c75             cmp al, 0x75
  016672  7503             jne 0x16677
  016674  e98401           jmp 0x167fb
  016677  3c58             cmp al, 0x58
  016679  7503             jne 0x1667e
  01667B  e98301           jmp 0x16801
  01667E  3c78             cmp al, 0x78
  016680  7503             jne 0x16685
  016682  e98201           jmp 0x16807
  016685  3c6f             cmp al, 0x6f
  016687  7503             jne 0x1668c
  016689  e99c01           jmp 0x16828
  01668C  3c63             cmp al, 0x63
  01668E  741a             je 0x166aa
  016690  3c73             cmp al, 0x73
  016692  7427             je 0x166bb
  016694  3c6e             cmp al, 0x6e
  016696  7451             je 0x166e9
  016698  3c70             cmp al, 0x70
  01669A  7460             je 0x166fc
  01669C  3c45             cmp al, 0x45
  01669E  7407             je 0x166a7
  0166A0  3c47             cmp al, 0x47
  0166A2  7403             je 0x166a7
  0166A4  e9bb00           jmp 0x16762
  0166A7  e9b500           jmp 0x1675f
  0166AA  e88402           call 0x16931
  0166AD  8dbe8ffe         lea di, [bp - 0x171]
  0166B1  16               push ss
  0166B2  07               pop es
  0166B3  aa               stosb byte ptr es:[di], al
  0166B4  4f               dec di
  0166B5  b90100           mov cx, 1
  0166B8  e9eb01           jmp 0x168a6
  0166BB  e88702           call 0x16945
  0166BE  0bff             or di, di
  0166C0  7512             jne 0x166d4
  0166C2  8cc0             mov ax, es
  0166C4  0bc0             or ax, ax
  0166C6  750c             jne 0x166d4
  0166C8  1e               push ds
  0166C9  07               pop es
  0166CA  bf6748           mov di, 0x4867
  0166CD  8b0e6d48         mov cx, word ptr [0x486d]
  0166D1  e9d201           jmp 0x168a6
  0166D4  57               push di
  0166D5  8b4ef4           mov cx, word ptr [bp - 0xc]
  0166D8  e307             jcxz 0x166e1
  0166DA  32c0             xor al, al
  0166DC  f2ae             repne scasb al, byte ptr es:[di]
  0166DE  7501             jne 0x166e1
  0166E0  4f               dec di
  0166E1  59               pop cx
  0166E2  2bf9             sub di, cx
  0166E4  87cf             xchg di, cx
  0166E6  e9bd01           jmp 0x168a6
  0166E9  e85902           call 0x16945
  0166EC  8b46f8           mov ax, word ptr [bp - 8]
  0166EF  ab               stosw word ptr es:[di], ax
  0166F0  f646fc10         test byte ptr [bp - 4], 0x10
  0166F4  7403             je 0x166f9
  0166F6  33c0             xor ax, ax
  0166F8  ab               stosw word ptr es:[di], ax
  0166F9  e93efe           jmp 0x1653a
  0166FC  f646fc30         test byte ptr [bp - 4], 0x30
  016700  7505             jne 0x16707
  016702  e82c02           call 0x16931
  016705  eb39             jmp 0x16740
  016707  e82f02           call 0x16939
  01670A  f646fd18         test byte ptr [bp - 3], 0x18
  01670E  7530             jne 0x16740
  016710  c646ff07         mov byte ptr [bp - 1], 7
  016714  b91000           mov cx, 0x10
  016717  16               push ss
  016718  07               pop es
  016719  52               push dx
  01671A  33d2             xor dx, dx
  01671C  8dbe97fe         lea di, [bp - 0x169]
  016720  be0400           mov si, 4
  016723  e8a002           call 0x169c6
  016726  b91000           mov cx, 0x10
  016729  8dbe92fe         lea di, [bp - 0x16e]
  01672D  58               pop ax
  01672E  33d2             xor dx, dx
  016730  be0400           mov si, 4
  016733  e89002           call 0x169c6
  016736  c68693fe3a       mov byte ptr [bp - 0x16d], 0x3a
  01673B  b90900           mov cx, 9
  01673E  eb18             jmp 0x16758
  016740  c646ff07         mov byte ptr [bp - 1], 7
  016744  b91000           mov cx, 0x10
  016747  16               push ss
  016748  07               pop es
  016749  33d2             xor dx, dx
  01674B  8dbe92fe         lea di, [bp - 0x16e]
  01674F  be0400           mov si, 4
  016752  e87102           call 0x169c6
  016755  b90400           mov cx, 4
  016758  8dbe8ffe         lea di, [bp - 0x171]
  01675C  e94701           jmp 0x168a6
  01675F  ff46ee           inc word ptr [bp - 0x12]
  016762  804efc40         or byte ptr [bp - 4], 0x40
  016766  8a46fe           mov al, byte ptr [bp - 2]
  016769  0c20             or al, 0x20
  01676B  98               cwde
  01676C  8bf0             mov si, ax
  01676E  837ef400         cmp word ptr [bp - 0xc], 0
  016772  7f13             jg 0x16787
  016774  7407             je 0x1677d
  016776  c746f40600       mov word ptr [bp - 0xc], 6
  01677B  eb0a             jmp 0x16787
  01677D  3d6700           cmp ax, 0x67
  016780  7505             jne 0x16787
  016782  c746f40100       mov word ptr [bp - 0xc], 1
  016787  8dbe8ffe         lea di, [bp - 0x171]
  01678B  ff76ee           push word ptr [bp - 0x12]
  01678E  ff76f4           push word ptr [bp - 0xc]
  016791  56               push si
  016792  57               push di
  016793  ff760a           push word ptr [bp + 0xa]
  016796  f646fd04         test byte ptr [bp - 3], 4
  01679A  740a             je 0x167a6
  01679C  ff1e8648         lcall [0x4886]
  0167A0  83460a0a         add word ptr [bp + 0xa], 0xa
  0167A4  eb08             jmp 0x167ae
  0167A6  ff1e7248         lcall [0x4872]
  0167AA  83460a08         add word ptr [bp + 0xa], 8
  0167AE  83c40a           add sp, 0xa
  0167B1  f646fc80         test byte ptr [bp - 4], 0x80
  0167B5  740e             je 0x167c5
  0167B7  837ef400         cmp word ptr [bp - 0xc], 0
  0167BB  7508             jne 0x167c5
  0167BD  57               push di
  0167BE  ff1e7e48         lcall [0x487e]
  0167C2  83c402           add sp, 2
  0167C5  83fe67           cmp si, 0x67
  0167C8  750f             jne 0x167d9
  0167CA  f746fc8000       test word ptr [bp - 4], 0x80
  0167CF  7508             jne 0x167d9
  0167D1  57               push di
  0167D2  ff1e7648         lcall [0x4876]
  0167D6  83c402           add sp, 2
  0167D9  16               push ss
  0167DA  07               pop es
  0167DB  26803d2d         cmp byte ptr es:[di], 0x2d
  0167DF  7505             jne 0x167e6
  0167E1  47               inc di
  0167E2  804efd01         or byte ptr [bp - 3], 1
  0167E6  b9ffff           mov cx, 0xffff
  0167E9  57               push di
  0167EA  b000             mov al, 0
  0167EC  f2ae             repne scasb al, byte ptr es:[di]
  0167EE  4f               dec di
  0167EF  59               pop cx
  0167F0  2bf9             sub di, cx
  0167F2  87cf             xchg di, cx
  0167F4  e9af00           jmp 0x168a6
  0167F7  804efc40         or byte ptr [bp - 4], 0x40
  0167FB  c646fa0a         mov byte ptr [bp - 6], 0xa
  0167FF  eb35             jmp 0x16836
  016801  c646ff07         mov byte ptr [bp - 1], 7
  016805  eb04             jmp 0x1680b
  016807  c646ff27         mov byte ptr [bp - 1], 0x27
  01680B  f646fc80         test byte ptr [bp - 4], 0x80
  01680F  7411             je 0x16822
  016811  c746f00200       mov word ptr [bp - 0x10], 2
  016816  c646f230         mov byte ptr [bp - 0xe], 0x30
  01681A  b251             mov dl, 0x51
  01681C  0256ff           add dl, byte ptr [bp - 1]
  01681F  8856f3           mov byte ptr [bp - 0xd], dl
  016822  c646fa10         mov byte ptr [bp - 6], 0x10
  016826  eb0e             jmp 0x16836
  016828  f646fc80         test byte ptr [bp - 4], 0x80
  01682C  7404             je 0x16832
  01682E  804efd02         or byte ptr [bp - 3], 2
  016832  c646fa08         mov byte ptr [bp - 6], 8
  016836  f646fc10         test byte ptr [bp - 4], 0x10
  01683A  7405             je 0x16841
  01683C  e8fa00           call 0x16939
  01683F  eb0e             jmp 0x1684f
  016841  e8ed00           call 0x16931
  016844  f646fc40         test byte ptr [bp - 4], 0x40
  016848  7403             je 0x1684d
  01684A  99               cdq
  01684B  eb02             jmp 0x1684f
  01684D  33d2             xor dx, dx
  01684F  f646fc40         test byte ptr [bp - 4], 0x40
  016853  740f             je 0x16864
  016855  0bd2             or dx, dx
  016857  7d0b             jge 0x16864
  016859  804efd01         or byte ptr [bp - 3], 1
  01685D  f7d8             neg ax
  01685F  83d200           adc dx, 0
  016862  f7da             neg dx
  016864  837ef400         cmp word ptr [bp - 0xc], 0
  016868  7d07             jge 0x16871
  01686A  c746f40100       mov word ptr [bp - 0xc], 1
  01686F  eb04             jmp 0x16875
  016871  8066fcf7         and byte ptr [bp - 4], 0xf7
  016875  8bd8             mov bx, ax
  016877  0bda             or bx, dx
  016879  7505             jne 0x16880
  01687B  c746f00000       mov word ptr [bp - 0x10], 0
  016880  8d7eeb           lea di, [bp - 0x15]
  016883  16               push ss
  016884  07               pop es
  016885  8a4efa           mov cl, byte ptr [bp - 6]
  016888  32ed             xor ch, ch
  01688A  8b76f4           mov si, word ptr [bp - 0xc]
  01688D  e83601           call 0x169c6
  016890  f646fd02         test byte ptr [bp - 3], 2
  016894  740e             je 0x168a4
  016896  e306             jcxz 0x1689e
  016898  26803d30         cmp byte ptr es:[di], 0x30
  01689C  7406             je 0x168a4
  01689E  4f               dec di
  01689F  26c60530         mov byte ptr es:[di], 0x30
  0168A3  41               inc cx
  0168A4  eb00             jmp 0x168a6
  0168A6  f646fc40         test byte ptr [bp - 4], 0x40
  0168AA  7431             je 0x168dd
  0168AC  f646fd01         test byte ptr [bp - 3], 1
  0168B0  740b             je 0x168bd
  0168B2  c646f22d         mov byte ptr [bp - 0xe], 0x2d
  0168B6  c746f00100       mov word ptr [bp - 0x10], 1
  0168BB  eb20             jmp 0x168dd
  0168BD  f646fc01         test byte ptr [bp - 4], 1
  0168C1  740b             je 0x168ce
  0168C3  c646f22b         mov byte ptr [bp - 0xe], 0x2b
  0168C7  c746f00100       mov word ptr [bp - 0x10], 1
  0168CC  eb0f             jmp 0x168dd
  0168CE  f646fc02         test byte ptr [bp - 4], 2
  0168D2  7409             je 0x168dd
  0168D4  c646f220         mov byte ptr [bp - 0xe], 0x20
  0168D8  c746f00100       mov word ptr [bp - 0x10], 1
  0168DD  8b46f6           mov ax, word ptr [bp - 0xa]
  0168E0  2bc1             sub ax, cx
  0168E2  2b46f0           sub ax, word ptr [bp - 0x10]
  0168E5  7d02             jge 0x168e9
  0168E7  33c0             xor ax, ax
  0168E9  06               push es
  0168EA  57               push di
  0168EB  51               push cx
  0168EC  f646fc0c         test byte ptr [bp - 4], 0xc
  0168F0  7507             jne 0x168f9
  0168F2  8bc8             mov cx, ax
  0168F4  b220             mov dl, 0x20
  0168F6  e8b100           call 0x169aa
  0168F9  50               push ax
  0168FA  16               push ss
  0168FB  07               pop es
  0168FC  8d7ef2           lea di, [bp - 0xe]
  0168FF  8b4ef0           mov cx, word ptr [bp - 0x10]
  016902  e88700           call 0x1698c
  016905  58               pop ax
  016906  f646fc08         test byte ptr [bp - 4], 8
  01690A  740d             je 0x16919
  01690C  f646fc04         test byte ptr [bp - 4], 4
  016910  7507             jne 0x16919
  016912  8bc8             mov cx, ax
  016914  b230             mov dl, 0x30
  016916  e89100           call 0x169aa
  016919  59               pop cx
  01691A  5f               pop di
  01691B  07               pop es
  01691C  50               push ax
  01691D  e86c00           call 0x1698c
  016920  58               pop ax
  016921  f646fc04         test byte ptr [bp - 4], 4
  016925  7407             je 0x1692e
  016927  8bc8             mov cx, ax
  016929  b220             mov dl, 0x20
  01692B  e87c00           call 0x169aa
  01692E  e909fc           jmp 0x1653a
  016931  8b760a           mov si, word ptr [bp + 0xa]
  016934  ad               lodsw ax, word ptr [si]
  016935  89760a           mov word ptr [bp + 0xa], si
  016938  c3               ret
  016939  8b760a           mov si, word ptr [bp + 0xa]
  01693C  ad               lodsw ax, word ptr [si]
  01693D  8bd0             mov dx, ax
  01693F  ad               lodsw ax, word ptr [si]
  016940  92               xchg dx, ax
  016941  89760a           mov word ptr [bp + 0xa], si
  016944  c3               ret
  016945  f646fc20         test byte ptr [bp - 4], 0x20
  016949  7408             je 0x16953
  01694B  e8ebff           call 0x16939
  01694E  8ec2             mov es, dx
  016950  8bf8             mov di, ax
  016952  c3               ret
  016953  e8dbff           call 0x16931
  016956  8bf8             mov di, ax
  016958  0bc0             or ax, ax
  01695A  7503             jne 0x1695f
  01695C  8ec0             mov es, ax
  01695E  c3               ret
  01695F  1e               push ds
  016960  07               pop es
  016961  c3               ret
  016962  98               cwde
  016963  57               push di
  016964  8b5e06           mov bx, word ptr [bp + 6]
  016967  ff4f02           dec word ptr [bx + 2]
  01696A  780a             js 0x16976
  01696C  8b3f             mov di, word ptr [bx]
  01696E  ff07             inc word ptr [bx]
  016970  8805             mov byte ptr [di], al
  016972  33c0             xor ax, ax
  016974  5f               pop di
  016975  c3               ret
  016976  06               push es
  016977  51               push cx
  016978  52               push dx
  016979  53               push bx
  01697A  50               push ax
  01697B  0e               push cs
  01697C  e825f8           call 0x161a4
  01697F  83c404           add sp, 4
  016982  5a               pop dx
  016983  59               pop cx
  016984  07               pop es
  016985  3dffff           cmp ax, 0xffff
  016988  75e8             jne 0x16972
  01698A  ebe8             jmp 0x16974
  01698C  e31b             jcxz 0x169a9
  01698E  8bf7             mov si, di
  016990  014ef8           add word ptr [bp - 8], cx
  016993  57               push di
  016994  33ff             xor di, di
  016996  26ac             lodsb al, byte ptr es:[si]
  016998  e8c7ff           call 0x16962
  01699B  0bf8             or di, ax
  01699D  e2f7             loop 0x16996
  01699F  0bff             or di, di
  0169A1  5f               pop di
  0169A2  7405             je 0x169a9
  0169A4  c746f8ffff       mov word ptr [bp - 8], 0xffff
  0169A9  c3               ret
  0169AA  e319             jcxz 0x169c5
  0169AC  014ef8           add word ptr [bp - 8], cx
  0169AF  57               push di
  0169B0  33ff             xor di, di
  0169B2  8ac2             mov al, dl
  0169B4  e8abff           call 0x16962
  0169B7  0bf8             or di, ax
  0169B9  e2f7             loop 0x169b2
  0169BB  0bff             or di, di
  0169BD  5f               pop di
  0169BE  7405             je 0x169c5
  0169C0  c746f8ffff       mov word ptr [bp - 8], 0xffff
  0169C5  c3               ret
  0169C6  fd               std
  0169C7  57               push di
  0169C8  93               xchg bx, ax
  0169C9  0bf6             or si, si
  0169CB  7f0a             jg 0x169d7
  0169CD  0bdb             or bx, bx
  0169CF  7506             jne 0x169d7
  0169D1  0bd2             or dx, dx
  0169D3  7502             jne 0x169d7
  0169D5  eb1a             jmp 0x169f1
  0169D7  92               xchg dx, ax
  0169D8  33d2             xor dx, dx
  0169DA  f7f1             div cx
  0169DC  93               xchg bx, ax
  0169DD  f7f1             div cx
  0169DF  92               xchg dx, ax
  0169E0  87d3             xchg bx, dx
  0169E2  0430             add al, 0x30
  0169E4  3c39             cmp al, 0x39
  0169E6  7603             jbe 0x169eb
  0169E8  0246ff           add al, byte ptr [bp - 1]
  0169EB  aa               stosb byte ptr es:[di], al
  0169EC  8bc2             mov ax, dx
  0169EE  4e               dec si
  0169EF  ebd8             jmp 0x169c9
  0169F1  59               pop cx
  0169F2  2bcf             sub cx, di
  0169F4  47               inc di
  0169F5  fc               cld
  0169F6  c3               ret
  0169F7  5f               pop di
  0169F8  5e               pop si
  0169F9  8be5             mov sp, bp
  0169FB  5d               pop bp
  0169FC  cb               retf
  0169FD  00               .byte 0x00
