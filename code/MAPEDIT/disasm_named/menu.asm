; MAPEDIT.EXE named disasm — module menu.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _menu_set_font  file 0x00838E..0x008426  seg 0x6D7:0x1e  (menu.obj) ----
  00838E  55               push bp
  00838F  8bec             mov bp, sp
  008391  8b5e06           mov bx, word ptr [bp + 6]
  008394  8b460e           mov ax, word ptr [bp + 0xe]
  008397  8e4608           mov es, word ptr [bp + 8]
  00839A  268907           mov word ptr es:[bx], ax
  00839D  8b4610           mov ax, word ptr [bp + 0x10]
  0083A0  26894702         mov word ptr es:[bx + 2], ax
  0083A4  8b4612           mov ax, word ptr [bp + 0x12]
  0083A7  26894704         mov word ptr es:[bx + 4], ax
  0083AB  8b4614           mov ax, word ptr [bp + 0x14]
  0083AE  26894706         mov word ptr es:[bx + 6], ax
  0083B2  8b460a           mov ax, word ptr [bp + 0xa]
  0083B5  8b560c           mov dx, word ptr [bp + 0xc]
  0083B8  26894708         mov word ptr es:[bx + 8], ax
  0083BC  2689570a         mov word ptr es:[bx + 0xa], dx
  0083C0  c9               leave
  0083C1  cb               retf
  0083C2  55               push bp
  0083C3  8bec             mov bp, sp
  0083C5  50               push ax
  0083C6  833e320600       cmp word ptr [0x632], 0
  0083CB  7439             je 0x8406
  0083CD  807e0a07         cmp byte ptr [bp + 0xa], 7
  0083D1  7533             jne 0x8406
  0083D3  ff760e           push word ptr [bp + 0xe]
  0083D6  ff7610           push word ptr [bp + 0x10]
  0083D9  ff7612           push word ptr [bp + 0x12]
  0083DC  53               push bx
  0083DD  52               push dx
  0083DE  50               push ax
  0083DF  8b1e3206         mov bx, word ptr [0x632]
  0083E3  ff7706           push word ptr [bx + 6]
  0083E6  ff7704           push word ptr [bx + 4]
  0083E9  ff7702           push word ptr [bx + 2]
  0083EC  ff37             push word ptr [bx]
  0083EE  ff761a           push word ptr [bp + 0x1a]
  0083F1  ff7618           push word ptr [bp + 0x18]
  0083F4  ff7616           push word ptr [bp + 0x16]
  0083F7  ff7614           push word ptr [bp + 0x14]
  0083FA  9a0000b90c       lcall 0xcb9, 0
  0083FF  83c41c           add sp, 0x1c
  008402  c9               leave
  008403  c21800           ret 0x18
  008406  ff761a           push word ptr [bp + 0x1a]
  008409  ff7618           push word ptr [bp + 0x18]
  00840C  ff7616           push word ptr [bp + 0x16]
  00840F  ff7614           push word ptr [bp + 0x14]
  008412  ff7612           push word ptr [bp + 0x12]
  008415  8a460a           mov al, byte ptr [bp + 0xa]
  008418  50               push ax
  008419  8b46fe           mov ax, word ptr [bp - 2]
  00841C  9a04005b0c       lcall 0xc5b, 4
  008421  c9               leave
  008422  c21800           ret 0x18
  008425  90               nop

; ---- _menu_string_width  file 0x008426..0x00847C  seg 0x6D7:0xb6  (menu.obj) ----
  008426  c8500000         enter 0x50, 0
  00842A  56               push si
  00842B  ff760c           push word ptr [bp + 0xc]
  00842E  ff760a           push word ptr [bp + 0xa]
  008431  8d46b0           lea ax, [bp - 0x50]
  008434  16               push ss
  008435  50               push ax
  008436  9aec0d8813       lcall 0x1388, 0xdec
  00843B  83c408           add sp, 8
  00843E  6a7e             push 0x7e
  008440  8d46b0           lea ax, [bp - 0x50]
  008443  50               push ax
  008444  9ae8098813       lcall 0x1388, 0x9e8
  008449  83c404           add sp, 4
  00844C  8bf0             mov si, ax
  00844E  0bf6             or si, si
  008450  740f             je 0x8461
  008452  8d4401           lea ax, [si + 1]
  008455  1e               push ds
  008456  50               push ax
  008457  1e               push ds
  008458  56               push si
  008459  9aec0d8813       lcall 0x1388, 0xdec
  00845E  83c408           add sp, 8
  008461  c45e06           les bx, ptr [bp + 6]
  008464  26ff770a         push word ptr es:[bx + 0xa]
  008468  26ff7708         push word ptr es:[bx + 8]
  00846C  8d46b0           lea ax, [bp - 0x50]
  00846F  16               push ss
  008470  50               push ax
  008471  268b07           mov ax, word ptr es:[bx]
  008474  9a02006c0d       lcall 0xd6c, 2
  008479  5e               pop si
  00847A  c9               leave
  00847B  cb               retf

; ---- _menu_string_write  file 0x00847C..0x0085B6  seg 0x6D7:0x10c  (menu.obj) ----
  00847C  c80e0000         enter 0xe, 0
  008480  57               push di
  008481  56               push si
  008482  837e1200         cmp word ptr [bp + 0x12], 0
  008486  744a             je 0x84d2
  008488  8b7e06           mov di, word ptr [bp + 6]
  00848B  8e4608           mov es, word ptr [bp + 8]
  00848E  26ff7504         push word ptr es:[di + 4]
  008492  268b5d04         mov bx, word ptr es:[di + 4]
  008496  8bd3             mov dx, bx
  008498  b8ffff           mov ax, 0xffff
  00849B  8cc6             mov si, es
  00849D  9a06006a0d       lcall 0xd6a, 6
  0084A2  8ec6             mov es, si
  0084A4  26ff750a         push word ptr es:[di + 0xa]
  0084A8  26ff7508         push word ptr es:[di + 8]
  0084AC  ff760c           push word ptr [bp + 0xc]
  0084AF  ff760a           push word ptr [bp + 0xa]
  0084B2  26ff35           push word ptr es:[di]
  0084B5  8d1ef43a         lea bx, [0x3af4]
  0084B9  8b460e           mov ax, word ptr [bp + 0xe]
  0084BC  8b5610           mov dx, word ptr [bp + 0x10]
  0084BF  8cc6             mov si, es
  0084C1  9a0800530d       lcall 0xd53, 8
  0084C6  8ec6             mov es, si
  0084C8  260305           add ax, word ptr es:[di]
  0084CB  89460e           mov word ptr [bp + 0xe], ax
  0084CE  e9dd00           jmp 0x85ae
  0084D1  90               nop
  0084D2  8b7606           mov si, word ptr [bp + 6]
  0084D5  c646fb00         mov byte ptr [bp - 5], 0
  0084D9  8e4608           mov es, word ptr [bp + 8]
  0084DC  26ff7402         push word ptr es:[si + 2]
  0084E0  268b5402         mov dx, word ptr es:[si + 2]
  0084E4  8bda             mov bx, dx
  0084E6  b8ffff           mov ax, 0xffff
  0084E9  9a06006a0d       lcall 0xd6a, 6
  0084EE  c45e0a           les bx, ptr [bp + 0xa]
  0084F1  8bfb             mov di, bx
  0084F3  8c46fe           mov word ptr [bp - 2], es
  0084F6  26803f00         cmp byte ptr es:[bx], 0
  0084FA  7503             jne 0x84ff
  0084FC  e9af00           jmp 0x85ae
  0084FF  26803d7e         cmp byte ptr es:[di], 0x7e
  008503  7565             jne 0x856a
  008505  8e4608           mov es, word ptr [bp + 8]
  008508  26ff7406         push word ptr es:[si + 6]
  00850C  268b5c06         mov bx, word ptr es:[si + 6]
  008510  8bd3             mov dx, bx
  008512  b8ffff           mov ax, 0xffff
  008515  8976f6           mov word ptr [bp - 0xa], si
  008518  8c46f8           mov word ptr [bp - 8], es
  00851B  9a06006a0d       lcall 0xd6a, 6
  008520  8e46fe           mov es, word ptr [bp - 2]
  008523  47               inc di
  008524  268a05           mov al, byte ptr es:[di]
  008527  8846fa           mov byte ptr [bp - 6], al
  00852A  c45ef6           les bx, ptr [bp - 0xa]
  00852D  26ff770a         push word ptr es:[bx + 0xa]
  008531  26ff7708         push word ptr es:[bx + 8]
  008535  8d46fa           lea ax, [bp - 6]
  008538  16               push ss
  008539  50               push ax
  00853A  26ff37           push word ptr es:[bx]
  00853D  8d1ef43a         lea bx, [0x3af4]
  008541  8b460e           mov ax, word ptr [bp + 0xe]
  008544  8b5610           mov dx, word ptr [bp + 0x10]
  008547  9a0800530d       lcall 0xd53, 8
  00854C  c45ef6           les bx, ptr [bp - 0xa]
  00854F  260307           add ax, word ptr es:[bx]
  008552  89460e           mov word ptr [bp + 0xe], ax
  008555  26ff7702         push word ptr es:[bx + 2]
  008559  268b5f02         mov bx, word ptr es:[bx + 2]
  00855D  8bd3             mov dx, bx
  00855F  b8ffff           mov ax, 0xffff
  008562  9a06006a0d       lcall 0xd6a, 6
  008567  eb38             jmp 0x85a1
  008569  90               nop
  00856A  268a05           mov al, byte ptr es:[di]
  00856D  8846fa           mov byte ptr [bp - 6], al
  008570  8e4608           mov es, word ptr [bp + 8]
  008573  26ff740a         push word ptr es:[si + 0xa]
  008577  26ff7408         push word ptr es:[si + 8]
  00857B  8d46fa           lea ax, [bp - 6]
  00857E  16               push ss
  00857F  50               push ax
  008580  26ff34           push word ptr es:[si]
  008583  8d1ef43a         lea bx, [0x3af4]
  008587  8b460e           mov ax, word ptr [bp + 0xe]
  00858A  8b5610           mov dx, word ptr [bp + 0x10]
  00858D  8976f2           mov word ptr [bp - 0xe], si
  008590  8c46f4           mov word ptr [bp - 0xc], es
  008593  9a0800530d       lcall 0xd53, 8
  008598  c45ef2           les bx, ptr [bp - 0xe]
  00859B  260307           add ax, word ptr es:[bx]
  00859E  89460e           mov word ptr [bp + 0xe], ax
  0085A1  8e46fe           mov es, word ptr [bp - 2]
  0085A4  47               inc di
  0085A5  26803d00         cmp byte ptr es:[di], 0
  0085A9  7403             je 0x85ae
  0085AB  e951ff           jmp 0x84ff
  0085AE  8b460e           mov ax, word ptr [bp + 0xe]
  0085B1  5e               pop si
  0085B2  5f               pop di
  0085B3  c9               leave
  0085B4  cb               retf
  0085B5  90               nop

; ---- _menu_get_hotkey  file 0x0085B6..0x00866E  seg 0x6D7:0x246  (menu.obj) ----
  0085B6  c80c0000         enter 0xc, 0
  0085BA  57               push di
  0085BB  56               push si
  0085BC  c746f60000       mov word ptr [bp - 0xa], 0
  0085C1  6a7e             push 0x7e
  0085C3  ff7608           push word ptr [bp + 8]
  0085C6  ff7606           push word ptr [bp + 6]
  0085C9  9a820d8813       lcall 0x1388, 0xd82
  0085CE  83c406           add sp, 6
  0085D1  8bf0             mov si, ax
  0085D3  8956fe           mov word ptr [bp - 2], dx
  0085D6  6a7e             push 0x7e
  0085D8  ff7608           push word ptr [bp + 8]
  0085DB  ff7606           push word ptr [bp + 6]
  0085DE  9aa80c8813       lcall 0x1388, 0xca8
  0085E3  83c406           add sp, 6
  0085E6  8bf8             mov di, ax
  0085E8  8b4efe           mov cx, word ptr [bp - 2]
  0085EB  3bc6             cmp ax, si
  0085ED  7504             jne 0x85f3
  0085EF  3bd1             cmp dx, cx
  0085F1  7447             je 0x863a
  0085F3  8eda             mov ds, dx
  0085F5  807d0146         cmp byte ptr [di + 1], 0x46
  0085F9  753f             jne 0x863a
  0085FB  8e46fe           mov es, word ptr [bp - 2]
  0085FE  268a5c01         mov bl, byte ptr es:[si + 1]
  008602  2aff             sub bh, bh
  008604  36f687a94504     test byte ptr ss:[bx + 0x45a9], 4
  00860A  742e             je 0x863a
  00860C  b93b01           mov cx, 0x13b
  00860F  83c703           add di, 3
  008612  803d30           cmp byte ptr [di], 0x30
  008615  750c             jne 0x8623
  008617  b95401           mov cx, 0x154
  00861A  807d0230         cmp byte ptr [di + 2], 0x30
  00861E  7503             jne 0x8623
  008620  b95e01           mov cx, 0x15e
  008623  26807cff31       cmp byte ptr es:[si - 1], 0x31
  008628  7506             jne 0x8630
  00862A  83c109           add cx, 9
  00862D  eb33             jmp 0x8662
  00862F  90               nop
  008630  8bc3             mov ax, bx
  008632  2d3100           sub ax, 0x31
  008635  03c8             add cx, ax
  008637  eb29             jmp 0x8662
  008639  90               nop
  00863A  8b46fe           mov ax, word ptr [bp - 2]
  00863D  0bc6             or ax, si
  00863F  7419             je 0x865a
  008641  8e46fe           mov es, word ptr [bp - 2]
  008644  268a5c01         mov bl, byte ptr es:[si + 1]
  008648  2aff             sub bh, bh
  00864A  36f687a94502     test byte ptr ss:[bx + 0x45a9], 2
  008650  740e             je 0x8660
  008652  8bcb             mov cx, bx
  008654  83e920           sub cx, 0x20
  008657  eb09             jmp 0x8662
  008659  90               nop
  00865A  8b4ef6           mov cx, word ptr [bp - 0xa]
  00865D  eb03             jmp 0x8662
  00865F  90               nop
  008660  8bcb             mov cx, bx
  008662  8bc1             mov ax, cx
  008664  b9e715           mov cx, 0x15e7
  008667  8ed9             mov ds, cx
  008669  5e               pop si
  00866A  5f               pop di
  00866B  c9               leave
  00866C  cb               retf
  00866D  90               nop

; ---- _menu_create  file 0x00866E..0x0087B6  seg 0x6D7:0x2fe  (menu.obj) ----
  00866E  c8200000         enter 0x20, 0
  008672  57               push di
  008673  56               push si
  008674  2bc0             sub ax, ax
  008676  8946f6           mov word ptr [bp - 0xa], ax
  008679  8946f4           mov word ptr [bp - 0xc], ax
  00867C  8b4606           mov ax, word ptr [bp + 6]
  00867F  054e00           add ax, 0x4e
  008682  99               cdq
  008683  9ae202c90c       lcall 0xcc9, 0x2e2
  008688  8bf8             mov di, ax
  00868A  8956f2           mov word ptr [bp - 0xe], dx
  00868D  0bd0             or dx, ax
  00868F  7503             jne 0x8694
  008691  e9fd00           jmp 0x8791
  008694  8b46f2           mov ax, word ptr [bp - 0xe]
  008697  8bcf             mov cx, di
  008699  8bd8             mov bx, ax
  00869B  8bf1             mov si, cx
  00869D  8946fe           mov word ptr [bp - 2], ax
  0086A0  894eec           mov word ptr [bp - 0x14], cx
  0086A3  895eee           mov word ptr [bp - 0x12], bx
  0086A6  83c13c           add cx, 0x3c
  0086A9  53               push bx
  0086AA  51               push cx
  0086AB  8b46ec           mov ax, word ptr [bp - 0x14]
  0086AE  8bd3             mov dx, bx
  0086B0  054e00           add ax, 0x4e
  0086B3  52               push dx
  0086B4  50               push ax
  0086B5  8b4606           mov ax, word ptr [bp + 6]
  0086B8  99               cdq
  0086B9  52               push dx
  0086BA  50               push ax
  0086BB  b82800           mov ax, 0x28
  0086BE  9a9000450f       lcall 0xf45, 0x90
  0086C3  c45eec           les bx, ptr [bp - 0x14]
  0086C6  2bc0             sub ax, ax
  0086C8  2689473a         mov word ptr es:[bx + 0x3a], ax
  0086CC  26894738         mov word ptr es:[bx + 0x38], ax
  0086D0  26894702         mov word ptr es:[bx + 2], ax
  0086D4  26c747060c00     mov word ptr es:[bx + 6], 0xc
  0086DA  26c747080300     mov word ptr es:[bx + 8], 3
  0086E0  26c7470c0400     mov word ptr es:[bx + 0xc], 4
  0086E6  b80100           mov ax, 1
  0086E9  26894704         mov word ptr es:[bx + 4], ax
  0086ED  2689470a         mov word ptr es:[bx + 0xa], ax
  0086F1  a11406           mov ax, word ptr [0x614]
  0086F4  8e46fe           mov es, word ptr [bp - 2]
  0086F7  2689440e         mov word ptr es:[si + 0xe], ax
  0086FB  a11606           mov ax, word ptr [0x616]
  0086FE  26894410         mov word ptr es:[si + 0x10], ax
  008702  ff363006         push word ptr [0x630]
  008706  ff362e06         push word ptr [0x62e]
  00870A  ff362c06         push word ptr [0x62c]
  00870E  6a00             push 0
  008710  ff760a           push word ptr [bp + 0xa]
  008713  ff7608           push word ptr [bp + 8]
  008716  8d4420           lea ax, [si + 0x20]
  008719  06               push es
  00871A  50               push ax
  00871B  8976e4           mov word ptr [bp - 0x1c], si
  00871E  8c46e6           mov word ptr [bp - 0x1a], es
  008721  0e               push cs
  008722  e869fc           call 0x838e
  008725  83c410           add sp, 0x10
  008728  a12006           mov ax, word ptr [0x620]
  00872B  c45ee4           les bx, ptr [bp - 0x1c]
  00872E  2689471a         mov word ptr es:[bx + 0x1a], ax
  008732  a12206           mov ax, word ptr [0x622]
  008735  2689471c         mov word ptr es:[bx + 0x1c], ax
  008739  a11806           mov ax, word ptr [0x618]
  00873C  8e46fe           mov es, word ptr [bp - 2]
  00873F  26894412         mov word ptr es:[si + 0x12], ax
  008743  a11a06           mov ax, word ptr [0x61a]
  008746  26894414         mov word ptr es:[si + 0x14], ax
  00874A  a11c06           mov ax, word ptr [0x61c]
  00874D  26894416         mov word ptr es:[si + 0x16], ax
  008751  a11e06           mov ax, word ptr [0x61e]
  008754  26894418         mov word ptr es:[si + 0x18], ax
  008758  a12406           mov ax, word ptr [0x624]
  00875B  2689441e         mov word ptr es:[si + 0x1e], ax
  00875F  ff362a06         push word ptr [0x62a]
  008763  ff362806         push word ptr [0x628]
  008767  ff362606         push word ptr [0x626]
  00876B  6a00             push 0
  00876D  ff760a           push word ptr [bp + 0xa]
  008770  ff7608           push word ptr [bp + 8]
  008773  8d442c           lea ax, [si + 0x2c]
  008776  06               push es
  008777  50               push ax
  008778  8976e0           mov word ptr [bp - 0x20], si
  00877B  8c46e2           mov word ptr [bp - 0x1e], es
  00877E  0e               push cs
  00877F  e80cfc           call 0x838e
  008782  83c410           add sp, 0x10
  008785  8b46e0           mov ax, word ptr [bp - 0x20]
  008788  8b56e2           mov dx, word ptr [bp - 0x1e]
  00878B  8946f4           mov word ptr [bp - 0xc], ax
  00878E  8956f6           mov word ptr [bp - 0xa], dx
  008791  8b46f2           mov ax, word ptr [bp - 0xe]
  008794  0bc7             or ax, di
  008796  7414             je 0x87ac
  008798  8b46f2           mov ax, word ptr [bp - 0xe]
  00879B  3b7ef4           cmp di, word ptr [bp - 0xc]
  00879E  7505             jne 0x87a5
  0087A0  3b46f6           cmp ax, word ptr [bp - 0xa]
  0087A3  7407             je 0x87ac
  0087A5  50               push ax
  0087A6  57               push di
  0087A7  9a1003c90c       lcall 0xcc9, 0x310
  0087AC  8b46f4           mov ax, word ptr [bp - 0xc]
  0087AF  8b56f6           mov dx, word ptr [bp - 0xa]
  0087B2  5e               pop si
  0087B3  5f               pop di
  0087B4  c9               leave
  0087B5  cb               retf

; ---- _menu_bar_item  file 0x0087B6..0x0087FC  seg 0x6D7:0x446  (menu.obj) ----
  0087B6  c8040000         enter 4, 0
  0087BA  57               push di
  0087BB  56               push si
  0087BC  2bc9             sub cx, cx
  0087BE  2bc0             sub ax, ax
  0087C0  99               cdq
  0087C1  8bf8             mov di, ax
  0087C3  8956fe           mov word ptr [bp - 2], dx
  0087C6  c47606           les si, ptr [bp + 6]
  0087C9  26c55c38         lds bx, ptr es:[si + 0x38]
  0087CD  8cd8             mov ax, ds
  0087CF  0bc3             or ax, bx
  0087D1  741a             je 0x87ed
  0087D3  8b460a           mov ax, word ptr [bp + 0xa]
  0087D6  39470a           cmp word ptr [bx + 0xa], ax
  0087D9  750b             jne 0x87e6
  0087DB  b90100           mov cx, 1
  0087DE  8bfb             mov di, bx
  0087E0  8c5efe           mov word ptr [bp - 2], ds
  0087E3  eb04             jmp 0x87e9
  0087E5  90               nop
  0087E6  c55f16           lds bx, ptr [bx + 0x16]
  0087E9  0bc9             or cx, cx
  0087EB  74e0             je 0x87cd
  0087ED  b8e715           mov ax, 0x15e7
  0087F0  8ed8             mov ds, ax
  0087F2  8bc7             mov ax, di
  0087F4  8b56fe           mov dx, word ptr [bp - 2]
  0087F7  5e               pop si
  0087F8  5f               pop di
  0087F9  c9               leave
  0087FA  cb               retf
  0087FB  90               nop

; ---- _menu_item  file 0x0087FC..0x008892  seg 0x6D7:0x48c  (menu.obj) ----
  0087FC  c8180000         enter 0x18, 0
  008800  57               push di
  008801  56               push si
  008802  2bc9             sub cx, cx
  008804  2bc0             sub ax, ax
  008806  8946ea           mov word ptr [bp - 0x16], ax
  008809  8946e8           mov word ptr [bp - 0x18], ax
  00880C  c47606           les si, ptr [bp + 6]
  00880F  268b4438         mov ax, word ptr es:[si + 0x38]
  008813  268b543a         mov dx, word ptr es:[si + 0x3a]
  008817  8bd8             mov bx, ax
  008819  8956f2           mov word ptr [bp - 0xe], dx
  00881C  8bc2             mov ax, dx
  00881E  0bc3             or ax, bx
  008820  7465             je 0x8887
  008822  8ec2             mov es, dx
  008824  268b471e         mov ax, word ptr es:[bx + 0x1e]
  008828  268b5720         mov dx, word ptr es:[bx + 0x20]
  00882C  8bf8             mov di, ax
  00882E  8956fa           mov word ptr [bp - 6], dx
  008831  0bc9             or cx, cx
  008833  753e             jne 0x8873
  008835  895ef0           mov word ptr [bp - 0x10], bx
  008838  8bf0             mov si, ax
  00883A  8b5ee8           mov bx, word ptr [bp - 0x18]
  00883D  8b46fa           mov ax, word ptr [bp - 6]
  008840  0bc6             or ax, si
  008842  7429             je 0x886d
  008844  8b460a           mov ax, word ptr [bp + 0xa]
  008847  8e46fa           mov es, word ptr [bp - 6]
  00884A  26394404         cmp word ptr es:[si + 4], ax
  00884E  750c             jne 0x885c
  008850  b90100           mov cx, 1
  008853  8cc0             mov ax, es
  008855  8bde             mov bx, si
  008857  8946ea           mov word ptr [bp - 0x16], ax
  00885A  eb0d             jmp 0x8869
  00885C  268b440e         mov ax, word ptr es:[si + 0xe]
  008860  268b5410         mov dx, word ptr es:[si + 0x10]
  008864  8bf0             mov si, ax
  008866  8956fa           mov word ptr [bp - 6], dx
  008869  0bc9             or cx, cx
  00886B  74d0             je 0x883d
  00886D  895ee8           mov word ptr [bp - 0x18], bx
  008870  8b5ef0           mov bx, word ptr [bp - 0x10]
  008873  8e46f2           mov es, word ptr [bp - 0xe]
  008876  268b4716         mov ax, word ptr es:[bx + 0x16]
  00887A  268b5718         mov dx, word ptr es:[bx + 0x18]
  00887E  8bd8             mov bx, ax
  008880  8956f2           mov word ptr [bp - 0xe], dx
  008883  0bc9             or cx, cx
  008885  7495             je 0x881c
  008887  8b46e8           mov ax, word ptr [bp - 0x18]
  00888A  8b56ea           mov dx, word ptr [bp - 0x16]
  00888D  5e               pop si
  00888E  5f               pop di
  00888F  c9               leave
  008890  cb               retf
  008891  90               nop

; ---- _menu_bar_hide  file 0x008892..0x0088CA  seg 0x6D7:0x522  (menu.obj) ----
  008892  c8040000         enter 4, 0
  008896  56               push si
  008897  ff760a           push word ptr [bp + 0xa]
  00889A  ff7608           push word ptr [bp + 8]
  00889D  ff7606           push word ptr [bp + 6]
  0088A0  0e               push cs
  0088A1  e812ff           call 0x87b6
  0088A4  83c406           add sp, 6
  0088A7  8bf0             mov si, ax
  0088A9  8956fe           mov word ptr [bp - 2], dx
  0088AC  0bd0             or dx, ax
  0088AE  7417             je 0x88c7
  0088B0  8e46fe           mov es, word ptr [bp - 2]
  0088B3  837e0c00         cmp word ptr [bp + 0xc], 0
  0088B7  7409             je 0x88c2
  0088B9  26804c0c01       or byte ptr es:[si + 0xc], 1
  0088BE  5e               pop si
  0088BF  c9               leave
  0088C0  cb               retf
  0088C1  90               nop
  0088C2  2680640cfe       and byte ptr es:[si + 0xc], 0xfe
  0088C7  5e               pop si
  0088C8  c9               leave
  0088C9  cb               retf

; ---- _menu_grey  file 0x0088CA..0x0088FA  seg 0x6D7:0x55a  (menu.obj) ----
  0088CA  c8040000         enter 4, 0
  0088CE  56               push si
  0088CF  ff760a           push word ptr [bp + 0xa]
  0088D2  ff7608           push word ptr [bp + 8]
  0088D5  ff7606           push word ptr [bp + 6]
  0088D8  0e               push cs
  0088D9  e820ff           call 0x87fc
  0088DC  83c406           add sp, 6
  0088DF  8bf0             mov si, ax
  0088E1  837e0c00         cmp word ptr [bp + 0xc], 0
  0088E5  7409             je 0x88f0
  0088E7  8ec2             mov es, dx
  0088E9  26800c01         or byte ptr es:[si], 1
  0088ED  5e               pop si
  0088EE  c9               leave
  0088EF  cb               retf
  0088F0  8ec2             mov es, dx
  0088F2  268024fe         and byte ptr es:[si], 0xfe
  0088F6  5e               pop si
  0088F7  c9               leave
  0088F8  cb               retf
  0088F9  90               nop

; ---- _menu_release_all_grey  file 0x0088FA..0x00893E  seg 0x6D7:0x58a  (menu.obj) ----
  0088FA  c8080000         enter 8, 0
  0088FE  57               push di
  0088FF  c45e06           les bx, ptr [bp + 6]
  008902  268b4738         mov ax, word ptr es:[bx + 0x38]
  008906  268b573a         mov dx, word ptr es:[bx + 0x3a]
  00890A  8bf8             mov di, ax
  00890C  8956fa           mov word ptr [bp - 6], dx
  00890F  0bd0             or dx, ax
  008911  7428             je 0x893b
  008913  8e46fa           mov es, word ptr [bp - 6]
  008916  26c55d1e         lds bx, ptr es:[di + 0x1e]
  00891A  8cd8             mov ax, ds
  00891C  0bc3             or ax, bx
  00891E  740c             je 0x892c
  008920  8027fe           and byte ptr [bx], 0xfe
  008923  c55f0e           lds bx, ptr [bx + 0xe]
  008926  8cd8             mov ax, ds
  008928  0bc3             or ax, bx
  00892A  75f4             jne 0x8920
  00892C  b8e715           mov ax, 0x15e7
  00892F  8ed8             mov ds, ax
  008931  26c47d16         les di, ptr es:[di + 0x16]
  008935  8cc0             mov ax, es
  008937  0bc7             or ax, di
  008939  75db             jne 0x8916
  00893B  5f               pop di
  00893C  c9               leave
  00893D  cb               retf

; ---- _menu_off  file 0x00893E..0x00896E  seg 0x6D7:0x5ce  (menu.obj) ----
  00893E  c8040000         enter 4, 0
  008942  56               push si
  008943  ff760a           push word ptr [bp + 0xa]
  008946  ff7608           push word ptr [bp + 8]
  008949  ff7606           push word ptr [bp + 6]
  00894C  0e               push cs
  00894D  e8acfe           call 0x87fc
  008950  83c406           add sp, 6
  008953  8bf0             mov si, ax
  008955  837e0c00         cmp word ptr [bp + 0xc], 0
  008959  7409             je 0x8964
  00895B  8ec2             mov es, dx
  00895D  26800c02         or byte ptr es:[si], 2
  008961  5e               pop si
  008962  c9               leave
  008963  cb               retf
  008964  8ec2             mov es, dx
  008966  268024fd         and byte ptr es:[si], 0xfd
  00896A  5e               pop si
  00896B  c9               leave
  00896C  cb               retf
  00896D  90               nop

; ---- _menu_release_all_off  file 0x00896E..0x0089B2  seg 0x6D7:0x5fe  (menu.obj) ----
  00896E  c8080000         enter 8, 0
  008972  57               push di
  008973  c45e06           les bx, ptr [bp + 6]
  008976  268b4738         mov ax, word ptr es:[bx + 0x38]
  00897A  268b573a         mov dx, word ptr es:[bx + 0x3a]
  00897E  8bf8             mov di, ax
  008980  8956fa           mov word ptr [bp - 6], dx
  008983  0bd0             or dx, ax
  008985  7428             je 0x89af
  008987  8e46fa           mov es, word ptr [bp - 6]
  00898A  26c55d1e         lds bx, ptr es:[di + 0x1e]
  00898E  8cd8             mov ax, ds
  008990  0bc3             or ax, bx
  008992  740c             je 0x89a0
  008994  8027fd           and byte ptr [bx], 0xfd
  008997  c55f0e           lds bx, ptr [bx + 0xe]
  00899A  8cd8             mov ax, ds
  00899C  0bc3             or ax, bx
  00899E  75f4             jne 0x8994
  0089A0  b8e715           mov ax, 0x15e7
  0089A3  8ed8             mov ds, ax
  0089A5  26c47d16         les di, ptr es:[di + 0x16]
  0089A9  8cc0             mov ax, es
  0089AB  0bc7             or ax, di
  0089AD  75db             jne 0x898a
  0089AF  5f               pop di
  0089B0  c9               leave
  0089B1  cb               retf

; ---- _menu_add_bar_item  file 0x0089B2..0x008B4E  seg 0x6D7:0x642  (menu.obj) ----
  0089B2  c8160000         enter 0x16, 0
  0089B6  57               push di
  0089B7  56               push si
  0089B8  c746fa0000       mov word ptr [bp - 6], 0
  0089BD  c45e06           les bx, ptr [bp + 6]
  0089C0  268b4738         mov ax, word ptr es:[bx + 0x38]
  0089C4  268b573a         mov dx, word ptr es:[bx + 0x3a]
  0089C8  8bf8             mov di, ax
  0089CA  8956f4           mov word ptr [bp - 0xc], dx
  0089CD  8bc8             mov cx, ax
  0089CF  8bf2             mov si, dx
  0089D1  8bd8             mov bx, ax
  0089D3  8956f8           mov word ptr [bp - 8], dx
  0089D6  0bf1             or si, cx
  0089D8  745c             je 0x8a36
  0089DA  8eda             mov ds, dx
  0089DC  8b4f02           mov cx, word ptr [bx + 2]
  0089DF  034f04           add cx, word ptr [bx + 4]
  0089E2  8cd8             mov ax, ds
  0089E4  8bfb             mov di, bx
  0089E6  8ec0             mov es, ax
  0089E8  c55f16           lds bx, ptr [bx + 0x16]
  0089EB  8cd8             mov ax, ds
  0089ED  0bc3             or ax, bx
  0089EF  75eb             jne 0x89dc
  0089F1  8c46f4           mov word ptr [bp - 0xc], es
  0089F4  894efa           mov word ptr [bp - 6], cx
  0089F7  897ef2           mov word ptr [bp - 0xe], di
  0089FA  b8e715           mov ax, 0x15e7
  0089FD  8ed8             mov ds, ax
  0089FF  8b7e06           mov di, word ptr [bp + 6]
  008A02  8e4608           mov es, word ptr [bp + 8]
  008A05  268b4506         mov ax, word ptr es:[di + 6]
  008A09  0146fa           add word ptr [bp - 6], ax
  008A0C  8d453c           lea ax, [di + 0x3c]
  008A0F  06               push es
  008A10  50               push ax
  008A11  b82200           mov ax, 0x22
  008A14  99               cdq
  008A15  9a0a01450f       lcall 0xf45, 0x10a
  008A1A  8bf0             mov si, ax
  008A1C  8956f8           mov word ptr [bp - 8], dx
  008A1F  8b46f4           mov ax, word ptr [bp - 0xc]
  008A22  0b46f2           or ax, word ptr [bp - 0xe]
  008A25  7415             je 0x8a3c
  008A27  8bc2             mov ax, dx
  008A29  c45ef2           les bx, ptr [bp - 0xe]
  008A2C  26897716         mov word ptr es:[bx + 0x16], si
  008A30  26894718         mov word ptr es:[bx + 0x18], ax
  008A34  eb13             jmp 0x8a49
  008A36  897ef2           mov word ptr [bp - 0xe], di
  008A39  ebc4             jmp 0x89ff
  008A3B  90               nop
  008A3C  8bc2             mov ax, dx
  008A3E  8e4608           mov es, word ptr [bp + 8]
  008A41  26897538         mov word ptr es:[di + 0x38], si
  008A45  2689453a         mov word ptr es:[di + 0x3a], ax
  008A49  8b46f2           mov ax, word ptr [bp - 0xe]
  008A4C  8b56f4           mov dx, word ptr [bp - 0xc]
  008A4F  8e46f8           mov es, word ptr [bp - 8]
  008A52  2689441a         mov word ptr es:[si + 0x1a], ax
  008A56  2689541c         mov word ptr es:[si + 0x1c], dx
  008A5A  2bc0             sub ax, ax
  008A5C  26894418         mov word ptr es:[si + 0x18], ax
  008A60  26894416         mov word ptr es:[si + 0x16], ax
  008A64  26894420         mov word ptr es:[si + 0x20], ax
  008A68  2689441e         mov word ptr es:[si + 0x1e], ax
  008A6C  268904           mov word ptr es:[si], ax
  008A6F  ff760c           push word ptr [bp + 0xc]
  008A72  ff760a           push word ptr [bp + 0xa]
  008A75  8bc7             mov ax, di
  008A77  8b5608           mov dx, word ptr [bp + 8]
  008A7A  8bc8             mov cx, ax
  008A7C  8bda             mov bx, dx
  008A7E  053c00           add ax, 0x3c
  008A81  52               push dx
  008A82  50               push ax
  008A83  ff760c           push word ptr [bp + 0xc]
  008A86  ff760a           push word ptr [bp + 0xa]
  008A89  894eee           mov word ptr [bp - 0x12], cx
  008A8C  895ef0           mov word ptr [bp - 0x10], bx
  008A8F  8976ea           mov word ptr [bp - 0x16], si
  008A92  8c46ec           mov word ptr [bp - 0x14], es
  008A95  9ad40d8813       lcall 0x1388, 0xdd4
  008A9A  83c404           add sp, 4
  008A9D  40               inc ax
  008A9E  2bd2             sub dx, dx
  008AA0  9a0a01450f       lcall 0xf45, 0x10a
  008AA5  c45eea           les bx, ptr [bp - 0x16]
  008AA8  2689470e         mov word ptr es:[bx + 0xe], ax
  008AAC  26895710         mov word ptr es:[bx + 0x10], dx
  008AB0  52               push dx
  008AB1  50               push ax
  008AB2  9aec0d8813       lcall 0x1388, 0xdec
  008AB7  83c408           add sp, 8
  008ABA  ff760c           push word ptr [bp + 0xc]
  008ABD  ff760a           push word ptr [bp + 0xa]
  008AC0  0e               push cs
  008AC1  e8f2fa           call 0x85b6
  008AC4  83c404           add sp, 4
  008AC7  c45eea           les bx, ptr [bp - 0x16]
  008ACA  26894708         mov word ptr es:[bx + 8], ax
  008ACE  26c747060a00     mov word ptr es:[bx + 6], 0xa
  008AD4  8b46fa           mov ax, word ptr [bp - 6]
  008AD7  26894702         mov word ptr es:[bx + 2], ax
  008ADB  ff760c           push word ptr [bp + 0xc]
  008ADE  ff760a           push word ptr [bp + 0xa]
  008AE1  8b46ee           mov ax, word ptr [bp - 0x12]
  008AE4  8b56f0           mov dx, word ptr [bp - 0x10]
  008AE7  052000           add ax, 0x20
  008AEA  52               push dx
  008AEB  50               push ax
  008AEC  0e               push cs
  008AED  e836f9           call 0x8426
  008AF0  83c408           add sp, 8
  008AF3  c45eee           les bx, ptr [bp - 0x12]
  008AF6  268b4f0a         mov cx, word ptr es:[bx + 0xa]
  008AFA  d1e1             shl cx, 1
  008AFC  03c1             add ax, cx
  008AFE  c45eea           les bx, ptr [bp - 0x16]
  008B01  26894704         mov word ptr es:[bx + 4], ax
  008B05  837e1000         cmp word ptr [bp + 0x10], 0
  008B09  7419             je 0x8b24
  008B0B  b84001           mov ax, 0x140
  008B0E  8e46f8           mov es, word ptr [bp - 8]
  008B11  262b4404         sub ax, word ptr es:[si + 4]
  008B15  8cc1             mov cx, es
  008B17  8e4608           mov es, word ptr [bp + 8]
  008B1A  262b4506         sub ax, word ptr es:[di + 6]
  008B1E  8ec1             mov es, cx
  008B20  26894402         mov word ptr es:[si + 2], ax
  008B24  8b4608           mov ax, word ptr [bp + 8]
  008B27  8e46f8           mov es, word ptr [bp - 8]
  008B2A  26897c12         mov word ptr es:[si + 0x12], di
  008B2E  26894414         mov word ptr es:[si + 0x14], ax
  008B32  8b4e0e           mov cx, word ptr [bp + 0xe]
  008B35  26894c0a         mov word ptr es:[si + 0xa], cx
  008B39  26c7440c0000     mov word ptr es:[si + 0xc], 0
  008B3F  8cc2             mov dx, es
  008B41  8ec0             mov es, ax
  008B43  26ff4502         inc word ptr es:[di + 2]
  008B47  8bc6             mov ax, si
  008B49  5e               pop si
  008B4A  5f               pop di
  008B4B  c9               leave
  008B4C  cb               retf
  008B4D  90               nop

; ---- _menu_add_item  file 0x008B4E..0x008CB4  seg 0x6D7:0x7de  (menu.obj) ----
  008B4E  c8140000         enter 0x14, 0
  008B52  57               push di
  008B53  56               push si
  008B54  2bc0             sub ax, ax
  008B56  99               cdq
  008B57  8bf0             mov si, ax
  008B59  8956fa           mov word ptr [bp - 6], dx
  008B5C  ff760a           push word ptr [bp + 0xa]
  008B5F  ff7608           push word ptr [bp + 8]
  008B62  ff7606           push word ptr [bp + 6]
  008B65  0e               push cs
  008B66  e84dfc           call 0x87b6
  008B69  83c406           add sp, 6
  008B6C  8946ec           mov word ptr [bp - 0x14], ax
  008B6F  8956ee           mov word ptr [bp - 0x12], dx
  008B72  0bd0             or dx, ax
  008B74  7503             jne 0x8b79
  008B76  e93101           jmp 0x8caa
  008B79  2bc0             sub ax, ax
  008B7B  99               cdq
  008B7C  8bc8             mov cx, ax
  008B7E  8956f2           mov word ptr [bp - 0xe], dx
  008B81  c476ec           les si, ptr [bp - 0x14]
  008B84  268b441e         mov ax, word ptr es:[si + 0x1e]
  008B88  268b5420         mov dx, word ptr es:[si + 0x20]
  008B8C  8bd8             mov bx, ax
  008B8E  8956fa           mov word ptr [bp - 6], dx
  008B91  0bd0             or dx, ax
  008B93  7531             jne 0x8bc6
  008B95  8bf9             mov di, cx
  008B97  8b4606           mov ax, word ptr [bp + 6]
  008B9A  8b5608           mov dx, word ptr [bp + 8]
  008B9D  053c00           add ax, 0x3c
  008BA0  52               push dx
  008BA1  50               push ax
  008BA2  b81600           mov ax, 0x16
  008BA5  99               cdq
  008BA6  9a0a01450f       lcall 0xf45, 0x10a
  008BAB  8bf0             mov si, ax
  008BAD  8956fa           mov word ptr [bp - 6], dx
  008BB0  8b46f2           mov ax, word ptr [bp - 0xe]
  008BB3  0bc7             or ax, di
  008BB5  742b             je 0x8be2
  008BB7  8bc2             mov ax, dx
  008BB9  8e46f2           mov es, word ptr [bp - 0xe]
  008BBC  2689750e         mov word ptr es:[di + 0xe], si
  008BC0  26894510         mov word ptr es:[di + 0x10], ax
  008BC4  eb29             jmp 0x8bef
  008BC6  8e5efa           mov ds, word ptr [bp - 6]
  008BC9  8bfb             mov di, bx
  008BCB  1e               push ds
  008BCC  07               pop es
  008BCD  26c55f0e         lds bx, ptr es:[bx + 0xe]
  008BD1  8cd8             mov ax, ds
  008BD3  0bc3             or ax, bx
  008BD5  75f2             jne 0x8bc9
  008BD7  8c46f2           mov word ptr [bp - 0xe], es
  008BDA  b8e715           mov ax, 0x15e7
  008BDD  8ed8             mov ds, ax
  008BDF  ebb6             jmp 0x8b97
  008BE1  90               nop
  008BE2  8bc2             mov ax, dx
  008BE4  c45eec           les bx, ptr [bp - 0x14]
  008BE7  2689771e         mov word ptr es:[bx + 0x1e], si
  008BEB  26894720         mov word ptr es:[bx + 0x20], ax
  008BEF  8b46f2           mov ax, word ptr [bp - 0xe]
  008BF2  8ec2             mov es, dx
  008BF4  26897c12         mov word ptr es:[si + 0x12], di
  008BF8  26894414         mov word ptr es:[si + 0x14], ax
  008BFC  2bc0             sub ax, ax
  008BFE  26894410         mov word ptr es:[si + 0x10], ax
  008C02  2689440e         mov word ptr es:[si + 0xe], ax
  008C06  268904           mov word ptr es:[si], ax
  008C09  ff760e           push word ptr [bp + 0xe]
  008C0C  ff760c           push word ptr [bp + 0xc]
  008C0F  8b4606           mov ax, word ptr [bp + 6]
  008C12  8b5608           mov dx, word ptr [bp + 8]
  008C15  053c00           add ax, 0x3c
  008C18  52               push dx
  008C19  50               push ax
  008C1A  ff760e           push word ptr [bp + 0xe]
  008C1D  ff760c           push word ptr [bp + 0xc]
  008C20  8cc7             mov di, es
  008C22  9ad40d8813       lcall 0x1388, 0xdd4
  008C27  83c404           add sp, 4
  008C2A  40               inc ax
  008C2B  2bd2             sub dx, dx
  008C2D  9a0a01450f       lcall 0xf45, 0x10a
  008C32  8ec7             mov es, di
  008C34  26894406         mov word ptr es:[si + 6], ax
  008C38  26895408         mov word ptr es:[si + 8], dx
  008C3C  52               push dx
  008C3D  50               push ax
  008C3E  9aec0d8813       lcall 0x1388, 0xdec
  008C43  83c408           add sp, 8
  008C46  c45e0c           les bx, ptr [bp + 0xc]
  008C49  26803f00         cmp byte ptr es:[bx], 0
  008C4D  7506             jne 0x8c55
  008C4F  8ec7             mov es, di
  008C51  26800c01         or byte ptr es:[si], 1
  008C55  8b4610           mov ax, word ptr [bp + 0x10]
  008C58  8ec7             mov es, di
  008C5A  26894404         mov word ptr es:[si + 4], ax
  008C5E  ff760e           push word ptr [bp + 0xe]
  008C61  53               push bx
  008C62  0e               push cs
  008C63  e850f9           call 0x85b6
  008C66  83c404           add sp, 4
  008C69  8ec7             mov es, di
  008C6B  26894402         mov word ptr es:[si + 2], ax
  008C6F  ff760e           push word ptr [bp + 0xe]
  008C72  ff760c           push word ptr [bp + 0xc]
  008C75  8b4606           mov ax, word ptr [bp + 6]
  008C78  8b5608           mov dx, word ptr [bp + 8]
  008C7B  052c00           add ax, 0x2c
  008C7E  52               push dx
  008C7F  50               push ax
  008C80  0e               push cs
  008C81  e8a2f7           call 0x8426
  008C84  83c408           add sp, 8
  008C87  8946fe           mov word ptr [bp - 2], ax
  008C8A  c45e06           les bx, ptr [bp + 6]
  008C8D  268b470c         mov ax, word ptr es:[bx + 0xc]
  008C91  d1e0             shl ax, 1
  008C93  0346fe           add ax, word ptr [bp - 2]
  008C96  c45eec           les bx, ptr [bp - 0x14]
  008C99  263b4706         cmp ax, word ptr es:[bx + 6]
  008C9D  7d04             jge 0x8ca3
  008C9F  268b4706         mov ax, word ptr es:[bx + 6]
  008CA3  26894706         mov word ptr es:[bx + 6], ax
  008CA7  26ff07           inc word ptr es:[bx]
  008CAA  8bc6             mov ax, si
  008CAC  8b56fa           mov dx, word ptr [bp - 6]
  008CAF  5e               pop si
  008CB0  5f               pop di
  008CB1  c9               leave
  008CB2  cb               retf
  008CB3  90               nop

; ---- _menu_draw_bar  file 0x008CB4..0x008DDC  seg 0x6D7:0x944  (menu.obj) ----
  008CB4  c80c0000         enter 0xc, 0
  008CB8  56               push si
  008CB9  c45e06           les bx, ptr [bp + 6]
  008CBC  26ff772a         push word ptr es:[bx + 0x2a]
  008CC0  26ff7728         push word ptr es:[bx + 0x28]
  008CC4  e8b1f6           call 0x8378
  008CC7  83c404           add sp, 4
  008CCA  c45e06           les bx, ptr [bp + 6]
  008CCD  26034704         add ax, word ptr es:[bx + 4]
  008CD1  40               inc ax
  008CD2  8946f8           mov word ptr [bp - 8], ax
  008CD5  ff36fa3a         push word ptr [0x3afa]
  008CD9  ff36f83a         push word ptr [0x3af8]
  008CDD  ff36f63a         push word ptr [0x3af6]
  008CE1  ff36f43a         push word ptr [0x3af4]
  008CE5  50               push ax
  008CE6  6a00             push 0
  008CE8  6a00             push 0
  008CEA  684001           push 0x140
  008CED  268a470e         mov al, byte ptr es:[bx + 0xe]
  008CF1  50               push ax
  008CF2  268a4710         mov al, byte ptr es:[bx + 0x10]
  008CF6  50               push ax
  008CF7  6a00             push 0
  008CF9  6a00             push 0
  008CFB  2bc0             sub ax, ax
  008CFD  99               cdq
  008CFE  bb4001           mov bx, 0x140
  008D01  e8bef6           call 0x83c2
  008D04  c45e06           les bx, ptr [bp + 6]
  008D07  268b4738         mov ax, word ptr es:[bx + 0x38]
  008D0B  268b573a         mov dx, word ptr es:[bx + 0x3a]
  008D0F  8946f4           mov word ptr [bp - 0xc], ax
  008D12  8956f6           mov word ptr [bp - 0xa], dx
  008D15  0bd0             or dx, ax
  008D17  7503             jne 0x8d1c
  008D19  e9a500           jmp 0x8dc1
  008D1C  c45ef4           les bx, ptr [bp - 0xc]
  008D1F  26f6470c01       test byte ptr es:[bx + 0xc], 1
  008D24  7403             je 0x8d29
  008D26  e98000           jmp 0x8da9
  008D29  268b4702         mov ax, word ptr es:[bx + 2]
  008D2D  8946fe           mov word ptr [bp - 2], ax
  008D30  8cc0             mov ax, es
  008D32  3b5e0a           cmp bx, word ptr [bp + 0xa]
  008D35  7545             jne 0x8d7c
  008D37  3b460c           cmp ax, word ptr [bp + 0xc]
  008D3A  7540             jne 0x8d7c
  008D3C  ff36fa3a         push word ptr [0x3afa]
  008D40  ff36f83a         push word ptr [0x3af8]
  008D44  ff36f63a         push word ptr [0x3af6]
  008D48  ff36f43a         push word ptr [0x3af4]
  008D4C  ff76f8           push word ptr [bp - 8]
  008D4F  6a00             push 0
  008D51  6a00             push 0
  008D53  684001           push 0x140
  008D56  c45e06           les bx, ptr [bp + 6]
  008D59  268a471a         mov al, byte ptr es:[bx + 0x1a]
  008D5D  50               push ax
  008D5E  268a471c         mov al, byte ptr es:[bx + 0x1c]
  008D62  50               push ax
  008D63  6a00             push 0
  008D65  6a00             push 0
  008D67  268b5f0a         mov bx, word ptr es:[bx + 0xa]
  008D6B  d1e3             shl bx, 1
  008D6D  c476f4           les si, ptr [bp - 0xc]
  008D70  26035c04         add bx, word ptr es:[si + 4]
  008D74  8b46fe           mov ax, word ptr [bp - 2]
  008D77  2bd2             sub dx, dx
  008D79  e846f6           call 0x83c2
  008D7C  6a00             push 0
  008D7E  c45e06           les bx, ptr [bp + 6]
  008D81  26ff7704         push word ptr es:[bx + 4]
  008D85  268b470a         mov ax, word ptr es:[bx + 0xa]
  008D89  0346fe           add ax, word ptr [bp - 2]
  008D8C  50               push ax
  008D8D  c476f4           les si, ptr [bp - 0xc]
  008D90  26ff7410         push word ptr es:[si + 0x10]
  008D94  26ff740e         push word ptr es:[si + 0xe]
  008D98  8bc3             mov ax, bx
  008D9A  8b5608           mov dx, word ptr [bp + 8]
  008D9D  052000           add ax, 0x20
  008DA0  52               push dx
  008DA1  50               push ax
  008DA2  0e               push cs
  008DA3  e8d6f6           call 0x847c
  008DA6  83c40e           add sp, 0xe
  008DA9  c45ef4           les bx, ptr [bp - 0xc]
  008DAC  268b4716         mov ax, word ptr es:[bx + 0x16]
  008DB0  268b5718         mov dx, word ptr es:[bx + 0x18]
  008DB4  8946f4           mov word ptr [bp - 0xc], ax
  008DB7  8956f6           mov word ptr [bp - 0xa], dx
  008DBA  0bd0             or dx, ax
  008DBC  7403             je 0x8dc1
  008DBE  e95bff           jmp 0x8d1c
  008DC1  837e0e00         cmp word ptr [bp + 0xe], 0
  008DC5  7412             je 0x8dd9
  008DC7  6a00             push 0
  008DC9  684001           push 0x140
  008DCC  ff76f8           push word ptr [bp - 8]
  008DCF  2bc0             sub ax, ax
  008DD1  99               cdq
  008DD2  2bdb             sub bx, bx
  008DD4  9a4400340c       lcall 0xc34, 0x44
  008DD9  5e               pop si
  008DDA  c9               leave
  008DDB  cb               retf

; ---- _menu_compute_size  file 0x008DDC..0x008EF2  seg 0x6D7:0xa6c  (menu.obj) ----
  008DDC  c8120000         enter 0x12, 0
  008DE0  57               push di
  008DE1  56               push si
  008DE2  8b7606           mov si, word ptr [bp + 6]
  008DE5  8e4608           mov es, word ptr [bp + 8]
  008DE8  268b4402         mov ax, word ptr es:[si + 2]
  008DEC  8b5e0a           mov bx, word ptr [bp + 0xa]
  008DEF  8907             mov word ptr [bx], ax
  008DF1  8cc0             mov ax, es
  008DF3  26c45c12         les bx, ptr es:[si + 0x12]
  008DF7  895eee           mov word ptr [bp - 0x12], bx
  008DFA  8c46f0           mov word ptr [bp - 0x10], es
  008DFD  26ff772a         push word ptr es:[bx + 0x2a]
  008E01  26ff7728         push word ptr es:[bx + 0x28]
  008E05  8bf8             mov di, ax
  008E07  e86ef5           call 0x8378
  008E0A  83c404           add sp, 4
  008E0D  c45eee           les bx, ptr [bp - 0x12]
  008E10  26034704         add ax, word ptr es:[bx + 4]
  008E14  050300           add ax, 3
  008E17  8b5e0c           mov bx, word ptr [bp + 0xc]
  008E1A  8907             mov word ptr [bx], ax
  008E1C  c746fa0000       mov word ptr [bp - 6], 0
  008E21  8ec7             mov es, di
  008E23  268b441e         mov ax, word ptr es:[si + 0x1e]
  008E27  268b5420         mov dx, word ptr es:[si + 0x20]
  008E2B  8956f8           mov word ptr [bp - 8], dx
  008E2E  0bd0             or dx, ax
  008E30  741f             je 0x8e51
  008E32  8bd8             mov bx, ax
  008E34  8b4efa           mov cx, word ptr [bp - 6]
  008E37  8e5ef8           mov ds, word ptr [bp - 8]
  008E3A  f60702           test byte ptr [bx], 2
  008E3D  7501             jne 0x8e40
  008E3F  41               inc cx
  008E40  c55f0e           lds bx, ptr [bx + 0xe]
  008E43  8cd8             mov ax, ds
  008E45  0bc3             or ax, bx
  008E47  75f1             jne 0x8e3a
  008E49  894efa           mov word ptr [bp - 6], cx
  008E4C  b8e715           mov ax, 0x15e7
  008E4F  8ed8             mov ds, ax
  008E51  8b760a           mov si, word ptr [bp + 0xa]
  008E54  8b7e0c           mov di, word ptr [bp + 0xc]
  008E57  c45e06           les bx, ptr [bp + 6]
  008E5A  268b4706         mov ax, word ptr es:[bx + 6]
  008E5E  40               inc ax
  008E5F  40               inc ax
  008E60  8b5e0e           mov bx, word ptr [bp + 0xe]
  008E63  8907             mov word ptr [bx], ax
  008E65  0304             add ax, word ptr [si]
  008E67  48               dec ax
  008E68  8946f8           mov word ptr [bp - 8], ax
  008E6B  c45eee           les bx, ptr [bp - 0x12]
  008E6E  26ff7736         push word ptr es:[bx + 0x36]
  008E72  26ff7734         push word ptr es:[bx + 0x34]
  008E76  e8fff4           call 0x8378
  008E79  83c404           add sp, 4
  008E7C  c45eee           les bx, ptr [bp - 0x12]
  008E7F  26034708         add ax, word ptr es:[bx + 8]
  008E83  f76efa           imul word ptr [bp - 6]
  008E86  26034708         add ax, word ptr es:[bx + 8]
  008E8A  40               inc ax
  008E8B  40               inc ax
  008E8C  8b5e10           mov bx, word ptr [bp + 0x10]
  008E8F  8907             mov word ptr [bx], ax
  008E91  0305             add ax, word ptr [di]
  008E93  48               dec ax
  008E94  8946fe           mov word ptr [bp - 2], ax
  008E97  817ef83e01       cmp word ptr [bp - 8], 0x13e
  008E9C  7c08             jl 0x8ea6
  008E9E  b83d01           mov ax, 0x13d
  008EA1  2b46f8           sub ax, word ptr [bp - 8]
  008EA4  0104             add word ptr [si], ax
  008EA6  817efec600       cmp word ptr [bp - 2], 0xc6
  008EAB  7c08             jl 0x8eb5
  008EAD  b8c700           mov ax, 0xc7
  008EB0  2b46fe           sub ax, word ptr [bp - 2]
  008EB3  0105             add word ptr [di], ax
  008EB5  8b04             mov ax, word ptr [si]
  008EB7  40               inc ax
  008EB8  8b5e12           mov bx, word ptr [bp + 0x12]
  008EBB  8907             mov word ptr [bx], ax
  008EBD  8b5eee           mov bx, word ptr [bp - 0x12]
  008EC0  268b4708         mov ax, word ptr es:[bx + 8]
  008EC4  0305             add ax, word ptr [di]
  008EC6  40               inc ax
  008EC7  8b5e14           mov bx, word ptr [bp + 0x14]
  008ECA  8907             mov word ptr [bx], ax
  008ECC  833c00           cmp word ptr [si], 0
  008ECF  7c05             jl 0x8ed6
  008ED1  833d00           cmp word ptr [di], 0
  008ED4  7d18             jge 0x8eee
  008ED6  8b04             mov ax, word ptr [si]
  008ED8  99               cdq
  008ED9  52               push dx
  008EDA  50               push ax
  008EDB  8b05             mov ax, word ptr [di]
  008EDD  99               cdq
  008EDE  52               push dx
  008EDF  50               push ax
  008EE0  b8b0ff           mov ax, 0xffb0
  008EE3  ba0200           mov dx, 2
  008EE6  bb2800           mov bx, 0x28
  008EE9  9ad603d00e       lcall 0xed0, 0x3d6
  008EEE  5e               pop si
  008EEF  5f               pop di
  008EF0  c9               leave
  008EF1  cb               retf

; ---- _menu_draw_menu  file 0x008EF2..0x00910C  seg 0x6D7:0xb82  (menu.obj) ----
  008EF2  c8240000         enter 0x24, 0
  008EF6  57               push di
  008EF7  56               push si
  008EF8  c45e06           les bx, ptr [bp + 6]
  008EFB  268b4712         mov ax, word ptr es:[bx + 0x12]
  008EFF  268b5714         mov dx, word ptr es:[bx + 0x14]
  008F03  8946e8           mov word ptr [bp - 0x18], ax
  008F06  8956ea           mov word ptr [bp - 0x16], dx
  008F09  8d46dc           lea ax, [bp - 0x24]
  008F0C  50               push ax
  008F0D  8d4ee0           lea cx, [bp - 0x20]
  008F10  51               push cx
  008F11  8d56de           lea dx, [bp - 0x22]
  008F14  52               push dx
  008F15  8d76e2           lea si, [bp - 0x1e]
  008F18  56               push si
  008F19  8d7ee6           lea di, [bp - 0x1a]
  008F1C  57               push di
  008F1D  8d46e4           lea ax, [bp - 0x1c]
  008F20  50               push ax
  008F21  06               push es
  008F22  53               push bx
  008F23  0e               push cs
  008F24  e8b5fe           call 0x8ddc
  008F27  83c410           add sp, 0x10
  008F2A  ff36fa3a         push word ptr [0x3afa]
  008F2E  ff36f83a         push word ptr [0x3af8]
  008F32  ff36f63a         push word ptr [0x3af6]
  008F36  ff36f43a         push word ptr [0x3af4]
  008F3A  8b46de           mov ax, word ptr [bp - 0x22]
  008F3D  0346e6           add ax, word ptr [bp - 0x1a]
  008F40  48               dec ax
  008F41  50               push ax
  008F42  c45ee8           les bx, ptr [bp - 0x18]
  008F45  268a471e         mov al, byte ptr es:[bx + 0x1e]
  008F49  50               push ax
  008F4A  8b46e4           mov ax, word ptr [bp - 0x1c]
  008F4D  8b5ee2           mov bx, word ptr [bp - 0x1e]
  008F50  03d8             add bx, ax
  008F52  8d5fff           lea bx, [bx - 1]
  008F55  8b56e6           mov dx, word ptr [bp - 0x1a]
  008F58  9a0c00860c       lcall 0xc86, 0xc
  008F5D  8b46e4           mov ax, word ptr [bp - 0x1c]
  008F60  40               inc ax
  008F61  8946e0           mov word ptr [bp - 0x20], ax
  008F64  8b4ee6           mov cx, word ptr [bp - 0x1a]
  008F67  41               inc cx
  008F68  894edc           mov word ptr [bp - 0x24], cx
  008F6B  8b56e2           mov dx, word ptr [bp - 0x1e]
  008F6E  4a               dec dx
  008F6F  4a               dec dx
  008F70  8956f2           mov word ptr [bp - 0xe], dx
  008F73  ff36fa3a         push word ptr [0x3afa]
  008F77  ff36f83a         push word ptr [0x3af8]
  008F7B  ff36f63a         push word ptr [0x3af6]
  008F7F  ff36f43a         push word ptr [0x3af4]
  008F83  8b5ede           mov bx, word ptr [bp - 0x22]
  008F86  4b               dec bx
  008F87  4b               dec bx
  008F88  53               push bx
  008F89  ff76e4           push word ptr [bp - 0x1c]
  008F8C  ff76e6           push word ptr [bp - 0x1a]
  008F8F  ff76e2           push word ptr [bp - 0x1e]
  008F92  c45ee8           les bx, ptr [bp - 0x18]
  008F95  268a5f12         mov bl, byte ptr es:[bx + 0x12]
  008F99  53               push bx
  008F9A  8b5ee8           mov bx, word ptr [bp - 0x18]
  008F9D  268a5f14         mov bl, byte ptr es:[bx + 0x14]
  008FA1  53               push bx
  008FA2  6a00             push 0
  008FA4  6a00             push 0
  008FA6  8bda             mov bx, dx
  008FA8  8bd1             mov dx, cx
  008FAA  8bf0             mov si, ax
  008FAC  8bf9             mov di, cx
  008FAE  e811f4           call 0x83c2
  008FB1  c45e06           les bx, ptr [bp + 6]
  008FB4  268b471e         mov ax, word ptr es:[bx + 0x1e]
  008FB8  268b5720         mov dx, word ptr es:[bx + 0x20]
  008FBC  8946ec           mov word ptr [bp - 0x14], ax
  008FBF  8956ee           mov word ptr [bp - 0x12], dx
  008FC2  c45ee8           les bx, ptr [bp - 0x18]
  008FC5  2603770c         add si, word ptr es:[bx + 0xc]
  008FC9  8976f0           mov word ptr [bp - 0x10], si
  008FCC  26037f08         add di, word ptr es:[bx + 8]
  008FD0  897ef4           mov word ptr [bp - 0xc], di
  008FD3  0bd0             or dx, ax
  008FD5  7503             jne 0x8fda
  008FD7  e91701           jmp 0x90f1
  008FDA  c45eec           les bx, ptr [bp - 0x14]
  008FDD  26f60702         test byte ptr es:[bx], 2
  008FE1  7403             je 0x8fe6
  008FE3  e9f300           jmp 0x90d9
  008FE6  8cc2             mov dx, es
  008FE8  39460a           cmp word ptr [bp + 0xa], ax
  008FEB  7557             jne 0x9044
  008FED  39560c           cmp word ptr [bp + 0xc], dx
  008FF0  7552             jne 0x9044
  008FF2  ff36fa3a         push word ptr [0x3afa]
  008FF6  ff36f83a         push word ptr [0x3af8]
  008FFA  ff36f63a         push word ptr [0x3af6]
  008FFE  ff36f43a         push word ptr [0x3af4]
  009002  c45ee8           les bx, ptr [bp - 0x18]
  009005  26ff7736         push word ptr es:[bx + 0x36]
  009009  26ff7734         push word ptr es:[bx + 0x34]
  00900D  e868f3           call 0x8378
  009010  83c404           add sp, 4
  009013  40               inc ax
  009014  40               inc ax
  009015  50               push ax
  009016  ff76e4           push word ptr [bp - 0x1c]
  009019  ff76e6           push word ptr [bp - 0x1a]
  00901C  ff76e2           push word ptr [bp - 0x1e]
  00901F  c45ee8           les bx, ptr [bp - 0x18]
  009022  268a4716         mov al, byte ptr es:[bx + 0x16]
  009026  50               push ax
  009027  268a4718         mov al, byte ptr es:[bx + 0x18]
  00902B  50               push ax
  00902C  6a00             push 0
  00902E  6a00             push 0
  009030  8b46e0           mov ax, word ptr [bp - 0x20]
  009033  40               inc ax
  009034  c45e06           les bx, ptr [bp + 6]
  009037  268b5f06         mov bx, word ptr es:[bx + 6]
  00903B  4b               dec bx
  00903C  4b               dec bx
  00903D  8b56f4           mov dx, word ptr [bp - 0xc]
  009040  4a               dec dx
  009041  e87ef3           call 0x83c2
  009044  c45eec           les bx, ptr [bp - 0x14]
  009047  26c45f06         les bx, ptr es:[bx + 6]
  00904B  26803f00         cmp byte ptr es:[bx], 0
  00904F  7543             jne 0x9094
  009051  c45ee8           les bx, ptr [bp - 0x18]
  009054  26ff7736         push word ptr es:[bx + 0x36]
  009058  26ff7734         push word ptr es:[bx + 0x34]
  00905C  e819f3           call 0x8378
  00905F  83c404           add sp, 4
  009062  d1f8             sar ax, 1
  009064  0346f4           add ax, word ptr [bp - 0xc]
  009067  8946f6           mov word ptr [bp - 0xa], ax
  00906A  ff36fa3a         push word ptr [0x3afa]
  00906E  ff36f83a         push word ptr [0x3af8]
  009072  ff36f63a         push word ptr [0x3af6]
  009076  ff36f43a         push word ptr [0x3af4]
  00907A  6a01             push 1
  00907C  c45ee8           les bx, ptr [bp - 0x18]
  00907F  268a472e         mov al, byte ptr es:[bx + 0x2e]
  009083  50               push ax
  009084  8b46e0           mov ax, word ptr [bp - 0x20]
  009087  8b56f6           mov dx, word ptr [bp - 0xa]
  00908A  8b5ef2           mov bx, word ptr [bp - 0xe]
  00908D  9a04005b0c       lcall 0xc5b, 4
  009092  eb2a             jmp 0x90be
  009094  c45eec           les bx, ptr [bp - 0x14]
  009097  268a07           mov al, byte ptr es:[bx]
  00909A  250100           and ax, 1
  00909D  50               push ax
  00909E  ff76f4           push word ptr [bp - 0xc]
  0090A1  ff76f0           push word ptr [bp - 0x10]
  0090A4  26ff7708         push word ptr es:[bx + 8]
  0090A8  26ff7706         push word ptr es:[bx + 6]
  0090AC  8b46e8           mov ax, word ptr [bp - 0x18]
  0090AF  8b56ea           mov dx, word ptr [bp - 0x16]
  0090B2  052c00           add ax, 0x2c
  0090B5  52               push dx
  0090B6  50               push ax
  0090B7  0e               push cs
  0090B8  e8c1f3           call 0x847c
  0090BB  83c40e           add sp, 0xe
  0090BE  c45ee8           les bx, ptr [bp - 0x18]
  0090C1  26ff7736         push word ptr es:[bx + 0x36]
  0090C5  26ff7734         push word ptr es:[bx + 0x34]
  0090C9  e8acf2           call 0x8378
  0090CC  83c404           add sp, 4
  0090CF  c45ee8           les bx, ptr [bp - 0x18]
  0090D2  26034708         add ax, word ptr es:[bx + 8]
  0090D6  0146f4           add word ptr [bp - 0xc], ax
  0090D9  c45eec           les bx, ptr [bp - 0x14]
  0090DC  268b470e         mov ax, word ptr es:[bx + 0xe]
  0090E0  268b5710         mov dx, word ptr es:[bx + 0x10]
  0090E4  8946ec           mov word ptr [bp - 0x14], ax
  0090E7  8956ee           mov word ptr [bp - 0x12], dx
  0090EA  0bd0             or dx, ax
  0090EC  7403             je 0x90f1
  0090EE  e9e9fe           jmp 0x8fda
  0090F1  ff76e6           push word ptr [bp - 0x1a]
  0090F4  ff76e2           push word ptr [bp - 0x1e]
  0090F7  ff76de           push word ptr [bp - 0x22]
  0090FA  8b46e4           mov ax, word ptr [bp - 0x1c]
  0090FD  8b56e6           mov dx, word ptr [bp - 0x1a]
  009100  8bd8             mov bx, ax
  009102  9a4400340c       lcall 0xc34, 0x44
  009107  5e               pop si
  009108  5f               pop di
  009109  c9               leave
  00910A  cb               retf
  00910B  90               nop

; ---- @menu_bar_run  file 0x00910C..0x009724  seg 0x6D7:0xd9c  (menu.obj) ----
  00910C  c83c0000         enter 0x3c, 0
  009110  56               push si
  009111  c746e00000       mov word ptr [bp - 0x20], 0
  009116  2bc0             sub ax, ax
  009118  8946d8           mov word ptr [bp - 0x28], ax
  00911B  8946d6           mov word ptr [bp - 0x2a], ax
  00911E  c45e06           les bx, ptr [bp + 6]
  009121  268b4712         mov ax, word ptr es:[bx + 0x12]
  009125  268b5714         mov dx, word ptr es:[bx + 0x14]
  009129  8946f2           mov word ptr [bp - 0xe], ax
  00912C  8956f4           mov word ptr [bp - 0xc], dx
  00912F  c746f60100       mov word ptr [bp - 0xa], 1
  009134  bb4000           mov bx, 0x40
  009137  8ec3             mov es, bx
  009139  bb1700           mov bx, 0x17
  00913C  268a07           mov al, byte ptr es:[bx]
  00913F  250800           and ax, 8
  009142  8946e6           mov word ptr [bp - 0x1a], ax
  009145  c746ec0000       mov word ptr [bp - 0x14], 0
  00914A  c746d00100       mov word ptr [bp - 0x30], 1
  00914F  c45e06           les bx, ptr [bp + 6]
  009152  268b4720         mov ax, word ptr es:[bx + 0x20]
  009156  260b471e         or ax, word ptr es:[bx + 0x1e]
  00915A  7503             jne 0x915f
  00915C  e9a705           jmp 0x9706
  00915F  6a01             push 1
  009161  06               push es
  009162  53               push bx
  009163  ff76f4           push word ptr [bp - 0xc]
  009166  ff76f2           push word ptr [bp - 0xe]
  009169  0e               push cs
  00916A  e847fb           call 0x8cb4
  00916D  83c40a           add sp, 0xa
  009170  8d46e8           lea ax, [bp - 0x18]
  009173  50               push ax
  009174  8d46f0           lea ax, [bp - 0x10]
  009177  50               push ax
  009178  8d46d4           lea ax, [bp - 0x2c]
  00917B  50               push ax
  00917C  8d4eda           lea cx, [bp - 0x26]
  00917F  51               push cx
  009180  8d56e2           lea dx, [bp - 0x1e]
  009183  52               push dx
  009184  8d5ee4           lea bx, [bp - 0x1c]
  009187  53               push bx
  009188  ff7608           push word ptr [bp + 8]
  00918B  ff7606           push word ptr [bp + 6]
  00918E  0e               push cs
  00918F  e84afc           call 0x8ddc
  009192  83c410           add sp, 0x10
  009195  c45ef2           les bx, ptr [bp - 0xe]
  009198  26ff7736         push word ptr es:[bx + 0x36]
  00919C  26ff7734         push word ptr es:[bx + 0x34]
  0091A0  e8d5f1           call 0x8378
  0091A3  83c404           add sp, 4
  0091A6  c45ef2           les bx, ptr [bp - 0xe]
  0091A9  26034708         add ax, word ptr es:[bx + 8]
  0091AD  8946f8           mov word ptr [bp - 8], ax
  0091B0  ff76e4           push word ptr [bp - 0x1c]
  0091B3  ff76e2           push word ptr [bp - 0x1e]
  0091B6  ff76da           push word ptr [bp - 0x26]
  0091B9  ff76d4           push word ptr [bp - 0x2c]
  0091BC  8d1ef43a         lea bx, [0x3af4]
  0091C0  b8f8ff           mov ax, 0xfff8
  0091C3  99               cdq
  0091C4  9a0e009d0c       lcall 0xc9d, 0xe
  0091C9  8946ea           mov word ptr [bp - 0x16], ax
  0091CC  a12a07           mov ax, word ptr [0x72a]
  0091CF  8946dc           mov word ptr [bp - 0x24], ax
  0091D2  0bc0             or ax, ax
  0091D4  7511             jne 0x91e7
  0091D6  c45e06           les bx, ptr [bp + 6]
  0091D9  268b471e         mov ax, word ptr es:[bx + 0x1e]
  0091DD  268b5720         mov dx, word ptr es:[bx + 0x20]
  0091E1  8946d6           mov word ptr [bp - 0x2a], ax
  0091E4  8956d8           mov word ptr [bp - 0x28], dx
  0091E7  9a04000000       lcall 0, 4
  0091EC  2bc0             sub ax, ax
  0091EE  9a4200210c       lcall 0xc21, 0x42
  0091F3  833e320700       cmp word ptr [0x732], 0
  0091F8  7503             jne 0x91fd
  0091FA  e96d01           jmp 0x936a
  0091FD  c746d20000       mov word ptr [bp - 0x2e], 0
  009202  c45ef2           les bx, ptr [bp - 0xe]
  009205  26ff772a         push word ptr es:[bx + 0x2a]
  009209  26ff7728         push word ptr es:[bx + 0x28]
  00920D  e868f1           call 0x8378
  009210  83c404           add sp, 4
  009213  c45ef2           les bx, ptr [bp - 0xe]
  009216  26034704         add ax, word ptr es:[bx + 4]
  00921A  40               inc ax
  00921B  3b062607         cmp ax, word ptr [0x726]
  00921F  7c61             jl 0x9282
  009221  268b4738         mov ax, word ptr es:[bx + 0x38]
  009225  268b573a         mov dx, word ptr es:[bx + 0x3a]
  009229  8946fa           mov word ptr [bp - 6], ax
  00922C  8956fc           mov word ptr [bp - 4], dx
  00922F  8b46fc           mov ax, word ptr [bp - 4]
  009232  0b46fa           or ax, word ptr [bp - 6]
  009235  744b             je 0x9282
  009237  837ed200         cmp word ptr [bp - 0x2e], 0
  00923B  7545             jne 0x9282
  00923D  c45efa           les bx, ptr [bp - 6]
  009240  268b4702         mov ax, word ptr es:[bx + 2]
  009244  8946fe           mov word ptr [bp - 2], ax
  009247  26034704         add ax, word ptr es:[bx + 4]
  00924B  8946de           mov word ptr [bp - 0x22], ax
  00924E  3b062407         cmp ax, word ptr [0x724]
  009252  7c24             jl 0x9278
  009254  26f6470c01       test byte ptr es:[bx + 0xc], 1
  009259  751d             jne 0x9278
  00925B  8cc0             mov ax, es
  00925D  395e06           cmp word ptr [bp + 6], bx
  009260  7505             jne 0x9267
  009262  394608           cmp word ptr [bp + 8], ax
  009265  7407             je 0x926e
  009267  c746d20100       mov word ptr [bp - 0x2e], 1
  00926C  ebc1             jmp 0x922f
  00926E  2bc0             sub ax, ax
  009270  8946fc           mov word ptr [bp - 4], ax
  009273  8946fa           mov word ptr [bp - 6], ax
  009276  ebb7             jmp 0x922f
  009278  268b4716         mov ax, word ptr es:[bx + 0x16]
  00927C  268b5718         mov dx, word ptr es:[bx + 0x18]
  009280  eba7             jmp 0x9229
  009282  837ed200         cmp word ptr [bp - 0x2e], 0
  009286  741a             je 0x92a2
  009288  8b46fa           mov ax, word ptr [bp - 6]
  00928B  8b56fc           mov dx, word ptr [bp - 4]
  00928E  894606           mov word ptr [bp + 6], ax
  009291  895608           mov word ptr [bp + 8], dx
  009294  c746ec0100       mov word ptr [bp - 0x14], 1
  009299  c746e00000       mov word ptr [bp - 0x20], 0
  00929E  e9c900           jmp 0x936a
  0092A1  90               nop
  0092A2  8b46e2           mov ax, word ptr [bp - 0x1e]
  0092A5  39062607         cmp word ptr [0x726], ax
  0092A9  7c1d             jl 0x92c8
  0092AB  0346d4           add ax, word ptr [bp - 0x2c]
  0092AE  48               dec ax
  0092AF  3b062607         cmp ax, word ptr [0x726]
  0092B3  7c13             jl 0x92c8
  0092B5  8b46e4           mov ax, word ptr [bp - 0x1c]
  0092B8  39062407         cmp word ptr [0x724], ax
  0092BC  7c0a             jl 0x92c8
  0092BE  0346da           add ax, word ptr [bp - 0x26]
  0092C1  48               dec ax
  0092C2  3b062407         cmp ax, word ptr [0x724]
  0092C6  7d14             jge 0x92dc
  0092C8  c746d00100       mov word ptr [bp - 0x30], 1
  0092CD  2bc0             sub ax, ax
  0092CF  8946d8           mov word ptr [bp - 0x28], ax
  0092D2  8946d6           mov word ptr [bp - 0x2a], ax
  0092D5  8946e0           mov word ptr [bp - 0x20], ax
  0092D8  e98f00           jmp 0x936a
  0092DB  90               nop
  0092DC  c45e06           les bx, ptr [bp + 6]
  0092DF  268b471e         mov ax, word ptr es:[bx + 0x1e]
  0092E3  268b5720         mov dx, word ptr es:[bx + 0x20]
  0092E7  8946cc           mov word ptr [bp - 0x34], ax
  0092EA  8956ce           mov word ptr [bp - 0x32], dx
  0092ED  c746d20000       mov word ptr [bp - 0x2e], 0
  0092F2  8b46e8           mov ax, word ptr [bp - 0x18]
  0092F5  8946ee           mov word ptr [bp - 0x12], ax
  0092F8  eb6a             jmp 0x9364
  0092FA  8b46ce           mov ax, word ptr [bp - 0x32]
  0092FD  0b46cc           or ax, word ptr [bp - 0x34]
  009300  7468             je 0x936a
  009302  c45ecc           les bx, ptr [bp - 0x34]
  009305  268b07           mov ax, word ptr es:[bx]
  009308  8bc8             mov cx, ax
  00930A  a802             test al, 2
  00930C  7545             jne 0x9353
  00930E  8b46ee           mov ax, word ptr [bp - 0x12]
  009311  48               dec ax
  009312  3b062607         cmp ax, word ptr [0x726]
  009316  7f35             jg 0x934d
  009318  8b46f8           mov ax, word ptr [bp - 8]
  00931B  0346ee           add ax, word ptr [bp - 0x12]
  00931E  48               dec ax
  00931F  3b062607         cmp ax, word ptr [0x726]
  009323  7e28             jle 0x934d
  009325  f6c101           test cl, 1
  009328  7523             jne 0x934d
  00932A  26c47706         les si, ptr es:[bx + 6]
  00932E  26803c00         cmp byte ptr es:[si], 0
  009332  7419             je 0x934d
  009334  8bc3             mov ax, bx
  009336  8b56ce           mov dx, word ptr [bp - 0x32]
  009339  8946d6           mov word ptr [bp - 0x2a], ax
  00933C  8956d8           mov word ptr [bp - 0x28], dx
  00933F  b80100           mov ax, 1
  009342  8946d2           mov word ptr [bp - 0x2e], ax
  009345  8946d0           mov word ptr [bp - 0x30], ax
  009348  c746e00000       mov word ptr [bp - 0x20], 0
  00934D  8b46f8           mov ax, word ptr [bp - 8]
  009350  0146ee           add word ptr [bp - 0x12], ax
  009353  8e46ce           mov es, word ptr [bp - 0x32]
  009356  268b470e         mov ax, word ptr es:[bx + 0xe]
  00935A  268b5710         mov dx, word ptr es:[bx + 0x10]
  00935E  8946cc           mov word ptr [bp - 0x34], ax
  009361  8956ce           mov word ptr [bp - 0x32], dx
  009364  837ed200         cmp word ptr [bp - 0x2e], 0
  009368  7490             je 0x92fa
  00936A  9a0400af0b       lcall 0xbaf, 4
  00936F  0bc0             or ax, ax
  009371  7503             jne 0x9376
  009373  e9dc00           jmp 0x9452
  009376  837ef600         cmp word ptr [bp - 0xa], 0
  00937A  7503             jne 0x937f
  00937C  e9d300           jmp 0x9452
  00937F  837eec00         cmp word ptr [bp - 0x14], 0
  009383  7403             je 0x9388
  009385  e9ca00           jmp 0x9452
  009388  9a1800af0b       lcall 0xbaf, 0x18
  00938D  8946c4           mov word ptr [bp - 0x3c], ax
  009390  3d0001           cmp ax, 0x100
  009393  7d0f             jge 0x93a4
  009395  8bd8             mov bx, ax
  009397  f687a94502       test byte ptr [bx + 0x45a9], 2
  00939C  7406             je 0x93a4
  00939E  2d2000           sub ax, 0x20
  0093A1  8946c4           mov word ptr [bp - 0x3c], ax
  0093A4  c746e00000       mov word ptr [bp - 0x20], 0
  0093A9  3d3800           cmp ax, 0x38
  0093AC  7424             je 0x93d2
  0093AE  7e03             jle 0x93b3
  0093B0  e94102           jmp 0x95f4
  0093B3  3d3200           cmp ax, 0x32
  0093B6  7503             jne 0x93bb
  0093B8  e9e100           jmp 0x949c
  0093BB  7603             jbe 0x93c0
  0093BD  e95302           jmp 0x9613
  0093C0  2c0d             sub al, 0xd
  0093C2  7503             jne 0x93c7
  0093C4  e9c101           jmp 0x9588
  0093C7  2c0e             sub al, 0xe
  0093C9  7503             jne 0x93ce
  0093CB  e9c201           jmp 0x9590
  0093CE  e94202           jmp 0x9613
  0093D1  90               nop
  0093D2  2bc0             sub ax, ax
  0093D4  8946c8           mov word ptr [bp - 0x38], ax
  0093D7  8946c6           mov word ptr [bp - 0x3a], ax
  0093DA  8b46d8           mov ax, word ptr [bp - 0x28]
  0093DD  0b46d6           or ax, word ptr [bp - 0x2a]
  0093E0  7411             je 0x93f3
  0093E2  c45ed6           les bx, ptr [bp - 0x2a]
  0093E5  268b4712         mov ax, word ptr es:[bx + 0x12]
  0093E9  268b5714         mov dx, word ptr es:[bx + 0x14]
  0093ED  8946d6           mov word ptr [bp - 0x2a], ax
  0093F0  8956d8           mov word ptr [bp - 0x28], dx
  0093F3  8b46d8           mov ax, word ptr [bp - 0x28]
  0093F6  0b46d6           or ax, word ptr [bp - 0x2a]
  0093F9  7539             jne 0x9434
  0093FB  c45e06           les bx, ptr [bp + 6]
  0093FE  268b471e         mov ax, word ptr es:[bx + 0x1e]
  009402  268b5720         mov dx, word ptr es:[bx + 0x20]
  009406  8946d6           mov word ptr [bp - 0x2a], ax
  009409  8956d8           mov word ptr [bp - 0x28], dx
  00940C  c45ed6           les bx, ptr [bp - 0x2a]
  00940F  268b4710         mov ax, word ptr es:[bx + 0x10]
  009413  260b470e         or ax, word ptr es:[bx + 0xe]
  009417  740b             je 0x9424
  009419  268b470e         mov ax, word ptr es:[bx + 0xe]
  00941D  268b5710         mov dx, word ptr es:[bx + 0x10]
  009421  ebe3             jmp 0x9406
  009423  90               nop
  009424  837ec600         cmp word ptr [bp - 0x3a], 0
  009428  7405             je 0x942f
  00942A  c746c80100       mov word ptr [bp - 0x38], 1
  00942F  c746c60100       mov word ptr [bp - 0x3a], 1
  009434  c45ed6           les bx, ptr [bp - 0x2a]
  009437  26f60703         test byte ptr es:[bx], 3
  00943B  750a             jne 0x9447
  00943D  26c45f06         les bx, ptr es:[bx + 6]
  009441  26803f00         cmp byte ptr es:[bx], 0
  009445  7506             jne 0x944d
  009447  837ec800         cmp word ptr [bp - 0x38], 0
  00944B  748d             je 0x93da
  00944D  c746d00100       mov word ptr [bp - 0x30], 1
  009452  bb4000           mov bx, 0x40
  009455  8ec3             mov es, bx
  009457  bb1700           mov bx, 0x17
  00945A  268a07           mov al, byte ptr es:[bx]
  00945D  250800           and ax, 8
  009460  8946ca           mov word ptr [bp - 0x36], ax
  009463  837ee000         cmp word ptr [bp - 0x20], 0
  009467  7411             je 0x947a
  009469  0bc0             or ax, ax
  00946B  750d             jne 0x947a
  00946D  3946e6           cmp word ptr [bp - 0x1a], ax
  009470  7503             jne 0x9475
  009472  8946f6           mov word ptr [bp - 0xa], ax
  009475  c746e60000       mov word ptr [bp - 0x1a], 0
  00947A  0bc0             or ax, ax
  00947C  7503             jne 0x9481
  00947E  e9a501           jmp 0x9626
  009481  837ed000         cmp word ptr [bp - 0x30], 0
  009485  7403             je 0x948a
  009487  e99c01           jmp 0x9626
  00948A  837eec00         cmp word ptr [bp - 0x14], 0
  00948E  7403             je 0x9493
  009490  e99301           jmp 0x9626
  009493  c746e00100       mov word ptr [bp - 0x20], 1
  009498  e99001           jmp 0x962b
  00949B  90               nop
  00949C  2bc0             sub ax, ax
  00949E  8946c8           mov word ptr [bp - 0x38], ax
  0094A1  8946c6           mov word ptr [bp - 0x3a], ax
  0094A4  8b46d8           mov ax, word ptr [bp - 0x28]
  0094A7  0b46d6           or ax, word ptr [bp - 0x2a]
  0094AA  7411             je 0x94bd
  0094AC  c45ed6           les bx, ptr [bp - 0x2a]
  0094AF  268b470e         mov ax, word ptr es:[bx + 0xe]
  0094B3  268b5710         mov dx, word ptr es:[bx + 0x10]
  0094B7  8946d6           mov word ptr [bp - 0x2a], ax
  0094BA  8956d8           mov word ptr [bp - 0x28], dx
  0094BD  8b46d8           mov ax, word ptr [bp - 0x28]
  0094C0  0b46d6           or ax, word ptr [bp - 0x2a]
  0094C3  7521             jne 0x94e6
  0094C5  c45e06           les bx, ptr [bp + 6]
  0094C8  268b471e         mov ax, word ptr es:[bx + 0x1e]
  0094CC  268b5720         mov dx, word ptr es:[bx + 0x20]
  0094D0  8946d6           mov word ptr [bp - 0x2a], ax
  0094D3  8956d8           mov word ptr [bp - 0x28], dx
  0094D6  837ec600         cmp word ptr [bp - 0x3a], 0
  0094DA  7405             je 0x94e1
  0094DC  c746c80100       mov word ptr [bp - 0x38], 1
  0094E1  c746c60100       mov word ptr [bp - 0x3a], 1
  0094E6  c45ed6           les bx, ptr [bp - 0x2a]
  0094E9  26f60703         test byte ptr es:[bx], 3
  0094ED  750d             jne 0x94fc
  0094EF  26c45f06         les bx, ptr es:[bx + 6]
  0094F3  26803f00         cmp byte ptr es:[bx], 0
  0094F7  7403             je 0x94fc
  0094F9  e951ff           jmp 0x944d
  0094FC  837ec800         cmp word ptr [bp - 0x38], 0
  009500  74a2             je 0x94a4
  009502  e948ff           jmp 0x944d
  009505  90               nop
  009506  c45e06           les bx, ptr [bp + 6]
  009509  268b471a         mov ax, word ptr es:[bx + 0x1a]
  00950D  268b571c         mov dx, word ptr es:[bx + 0x1c]
  009511  894606           mov word ptr [bp + 6], ax
  009514  895608           mov word ptr [bp + 8], dx
  009517  0bd0             or dx, ax
  009519  7529             jne 0x9544
  00951B  c45ef2           les bx, ptr [bp - 0xe]
  00951E  268b4738         mov ax, word ptr es:[bx + 0x38]
  009522  268b573a         mov dx, word ptr es:[bx + 0x3a]
  009526  894606           mov word ptr [bp + 6], ax
  009529  895608           mov word ptr [bp + 8], dx
  00952C  c45e06           les bx, ptr [bp + 6]
  00952F  268b4718         mov ax, word ptr es:[bx + 0x18]
  009533  260b4716         or ax, word ptr es:[bx + 0x16]
  009537  740b             je 0x9544
  009539  268b4716         mov ax, word ptr es:[bx + 0x16]
  00953D  268b5718         mov dx, word ptr es:[bx + 0x18]
  009541  ebe3             jmp 0x9526
  009543  90               nop
  009544  c45e06           les bx, ptr [bp + 6]
  009547  26f6470c01       test byte ptr es:[bx + 0xc], 1
  00954C  75b8             jne 0x9506
  00954E  c746ec0100       mov word ptr [bp - 0x14], 1
  009553  e9fcfe           jmp 0x9452
  009556  c45e06           les bx, ptr [bp + 6]
  009559  268b4716         mov ax, word ptr es:[bx + 0x16]
  00955D  268b5718         mov dx, word ptr es:[bx + 0x18]
  009561  894606           mov word ptr [bp + 6], ax
  009564  895608           mov word ptr [bp + 8], dx
  009567  0bd0             or dx, ax
  009569  7511             jne 0x957c
  00956B  c45ef2           les bx, ptr [bp - 0xe]
  00956E  268b4738         mov ax, word ptr es:[bx + 0x38]
  009572  268b573a         mov dx, word ptr es:[bx + 0x3a]
  009576  894606           mov word ptr [bp + 6], ax
  009579  895608           mov word ptr [bp + 8], dx
  00957C  c45e06           les bx, ptr [bp + 6]
  00957F  26f6470c01       test byte ptr es:[bx + 0xc], 1
  009584  75d0             jne 0x9556
  009586  ebc6             jmp 0x954e
  009588  c746f60000       mov word ptr [bp - 0xa], 0
  00958D  e9c2fe           jmp 0x9452
  009590  c746f60000       mov word ptr [bp - 0xa], 0
  009595  2bc0             sub ax, ax
  009597  8946d8           mov word ptr [bp - 0x28], ax
  00959A  8946d6           mov word ptr [bp - 0x2a], ax
  00959D  e9b2fe           jmp 0x9452
  0095A0  8b46ce           mov ax, word ptr [bp - 0x32]
  0095A3  0b46cc           or ax, word ptr [bp - 0x34]
  0095A6  742e             je 0x95d6
  0095A8  8b46c4           mov ax, word ptr [bp - 0x3c]
  0095AB  c45ecc           les bx, ptr [bp - 0x34]
  0095AE  26394702         cmp word ptr es:[bx + 2], ax
  0095B2  750e             jne 0x95c2
  0095B4  26f60703         test byte ptr es:[bx], 3
  0095B8  7508             jne 0x95c2
  0095BA  c746d20100       mov word ptr [bp - 0x2e], 1
  0095BF  eb0f             jmp 0x95d0
  0095C1  90               nop
  0095C2  268b470e         mov ax, word ptr es:[bx + 0xe]
  0095C6  268b5710         mov dx, word ptr es:[bx + 0x10]
  0095CA  8946cc           mov word ptr [bp - 0x34], ax
  0095CD  8956ce           mov word ptr [bp - 0x32], dx
  0095D0  837ed200         cmp word ptr [bp - 0x2e], 0
  0095D4  74ca             je 0x95a0
  0095D6  837ed200         cmp word ptr [bp - 0x2e], 0
  0095DA  7503             jne 0x95df
  0095DC  e973fe           jmp 0x9452
  0095DF  8b46cc           mov ax, word ptr [bp - 0x34]
  0095E2  8b56ce           mov dx, word ptr [bp - 0x32]
  0095E5  8946d6           mov word ptr [bp - 0x2a], ax
  0095E8  8956d8           mov word ptr [bp - 0x28], dx
  0095EB  c746f60000       mov word ptr [bp - 0xa], 0
  0095F0  e95afe           jmp 0x944d
  0095F3  90               nop
  0095F4  2d4801           sub ax, 0x148
  0095F7  7503             jne 0x95fc
  0095F9  e9d6fd           jmp 0x93d2
  0095FC  2d0300           sub ax, 3
  0095FF  7503             jne 0x9604
  009601  e902ff           jmp 0x9506
  009604  48               dec ax
  009605  48               dec ax
  009606  7503             jne 0x960b
  009608  e94bff           jmp 0x9556
  00960B  2d0300           sub ax, 3
  00960E  7503             jne 0x9613
  009610  e989fe           jmp 0x949c
  009613  c746d20000       mov word ptr [bp - 0x2e], 0
  009618  c45e06           les bx, ptr [bp + 6]
  00961B  268b471e         mov ax, word ptr es:[bx + 0x1e]
  00961F  268b5720         mov dx, word ptr es:[bx + 0x20]
  009623  eba5             jmp 0x95ca
  009625  90               nop
  009626  c746e00000       mov word ptr [bp - 0x20], 0
  00962B  837ed000         cmp word ptr [bp - 0x30], 0
  00962F  741e             je 0x964f
  009631  837eec00         cmp word ptr [bp - 0x14], 0
  009635  7518             jne 0x964f
  009637  ff76d8           push word ptr [bp - 0x28]
  00963A  ff76d6           push word ptr [bp - 0x2a]
  00963D  ff7608           push word ptr [bp + 8]
  009640  ff7606           push word ptr [bp + 6]
  009643  0e               push cs
  009644  e8abf8           call 0x8ef2
  009647  83c408           add sp, 8
  00964A  c746d00000       mov word ptr [bp - 0x30], 0
  00964F  833e300700       cmp word ptr [0x730], 0
  009654  7412             je 0x9668
  009656  8b46d8           mov ax, word ptr [bp - 0x28]
  009659  0b46d6           or ax, word ptr [bp - 0x2a]
  00965C  7474             je 0x96d2
  00965E  c746f60000       mov word ptr [bp - 0xa], 0
  009663  c746dc0000       mov word ptr [bp - 0x24], 0
  009668  2bc0             sub ax, ax
  00966A  8b56f6           mov dx, word ptr [bp - 0xa]
  00966D  9a1001210c       lcall 0xc21, 0x110
  009672  837ef600         cmp word ptr [bp - 0xa], 0
  009676  7409             je 0x9681
  009678  837eec00         cmp word ptr [bp - 0x14], 0
  00967C  7503             jne 0x9681
  00967E  e966fb           jmp 0x91e7
  009681  ff76e4           push word ptr [bp - 0x1c]
  009684  ff76e2           push word ptr [bp - 0x1e]
  009687  ff76da           push word ptr [bp - 0x26]
  00968A  ff76d4           push word ptr [bp - 0x2c]
  00968D  8d1ef43a         lea bx, [0x3af4]
  009691  8b46ea           mov ax, word ptr [bp - 0x16]
  009694  baffff           mov dx, 0xffff
  009697  9aec009d0c       lcall 0xc9d, 0xec
  00969C  ff76e2           push word ptr [bp - 0x1e]
  00969F  ff76da           push word ptr [bp - 0x26]
  0096A2  ff76d4           push word ptr [bp - 0x2c]
  0096A5  8b46e4           mov ax, word ptr [bp - 0x1c]
  0096A8  8b56e2           mov dx, word ptr [bp - 0x1e]
  0096AB  8bd8             mov bx, ax
  0096AD  9a4400340c       lcall 0xc34, 0x44
  0096B2  837ef600         cmp word ptr [bp - 0xa], 0
  0096B6  7403             je 0x96bb
  0096B8  e98afa           jmp 0x9145
  0096BB  8b46d8           mov ax, word ptr [bp - 0x28]
  0096BE  0b46d6           or ax, word ptr [bp - 0x2a]
  0096C1  743b             je 0x96fe
  0096C3  c45ed6           les bx, ptr [bp - 0x2a]
  0096C6  268b4704         mov ax, word ptr es:[bx + 4]
  0096CA  c45ef2           les bx, ptr [bp - 0xe]
  0096CD  268907           mov word ptr es:[bx], ax
  0096D0  eb34             jmp 0x9706
  0096D2  837edc00         cmp word ptr [bp - 0x24], 0
  0096D6  7486             je 0x965e
  0096D8  c45ef2           les bx, ptr [bp - 0xe]
  0096DB  26ff772a         push word ptr es:[bx + 0x2a]
  0096DF  26ff7728         push word ptr es:[bx + 0x28]
  0096E3  e892ec           call 0x8378
  0096E6  83c404           add sp, 4
  0096E9  c45ef2           les bx, ptr [bp - 0xe]
  0096EC  26034704         add ax, word ptr es:[bx + 4]
  0096F0  40               inc ax
  0096F1  3b062607         cmp ax, word ptr [0x726]
  0096F5  7c03             jl 0x96fa
  0096F7  e969ff           jmp 0x9663
  0096FA  e961ff           jmp 0x965e
  0096FD  90               nop
  0096FE  c45ef2           les bx, ptr [bp - 0xe]
  009701  26c7070000       mov word ptr es:[bx], 0
  009706  9a2a00210c       lcall 0xc21, 0x2a
  00970B  6a01             push 1
  00970D  6a00             push 0
  00970F  6a00             push 0
  009711  ff76f4           push word ptr [bp - 0xc]
  009714  ff76f2           push word ptr [bp - 0xe]
  009717  0e               push cs
  009718  e899f5           call 0x8cb4
  00971B  83c40a           add sp, 0xa
  00971E  5e               pop si
  00971F  c9               leave
  009720  ca0400           retf 4
  009723  90               nop

; ---- @menu_bar_mouse_parse  file 0x009724..0x0097C2  seg 0x6D7:0x13b4  (menu.obj) ----
  009724  c8060000         enter 6, 0
  009728  50               push ax
  009729  57               push di
  00972A  56               push si
  00972B  8b7e06           mov di, word ptr [bp + 6]
  00972E  2bc0             sub ax, ax
  009730  8946fa           mov word ptr [bp - 6], ax
  009733  8e4608           mov es, word ptr [bp + 8]
  009736  268905           mov word ptr es:[di], ax
  009739  39062807         cmp word ptr [0x728], ax
  00973D  747a             je 0x97b9
  00973F  26ff752a         push word ptr es:[di + 0x2a]
  009743  26ff7528         push word ptr es:[di + 0x28]
  009747  8cc6             mov si, es
  009749  e82cec           call 0x8378
  00974C  83c404           add sp, 4
  00974F  8ec6             mov es, si
  009751  268b7504         mov si, word ptr es:[di + 4]
  009755  03f0             add si, ax
  009757  46               inc si
  009758  3b362607         cmp si, word ptr [0x726]
  00975C  7c5b             jl 0x97b9
  00975E  2bc9             sub cx, cx
  009760  26c57538         lds si, ptr es:[di + 0x38]
  009764  8cd8             mov ax, ds
  009766  0bc6             or ax, si
  009768  7429             je 0x9793
  00976A  368b1e2407       mov bx, word ptr ss:[0x724]
  00976F  0bc9             or cx, cx
  009771  7520             jne 0x9793
  009773  8b4402           mov ax, word ptr [si + 2]
  009776  034404           add ax, word ptr [si + 4]
  009779  3bc3             cmp ax, bx
  00977B  7c0d             jl 0x978a
  00977D  f6440c01         test byte ptr [si + 0xc], 1
  009781  7507             jne 0x978a
  009783  b90100           mov cx, 1
  009786  eb05             jmp 0x978d
  009788  90               nop
  009789  90               nop
  00978A  c57416           lds si, ptr [si + 0x16]
  00978D  8cd8             mov ax, ds
  00978F  0bc6             or ax, si
  009791  75dc             jne 0x976f
  009793  0bc9             or cx, cx
  009795  7507             jne 0x979e
  009797  b8e715           mov ax, 0x15e7
  00979A  8ed8             mov ds, ax
  00979C  eb1b             jmp 0x97b9
  00979E  c746fa0100       mov word ptr [bp - 6], 1
  0097A3  837ef800         cmp word ptr [bp - 8], 0
  0097A7  74ee             je 0x9797
  0097A9  8c5efe           mov word ptr [bp - 2], ds
  0097AC  b8e715           mov ax, 0x15e7
  0097AF  8ed8             mov ds, ax
  0097B1  ff76fe           push word ptr [bp - 2]
  0097B4  56               push si
  0097B5  0e               push cs
  0097B6  e853f9           call 0x910c
  0097B9  8b46fa           mov ax, word ptr [bp - 6]
  0097BC  5e               pop si
  0097BD  5f               pop di
  0097BE  c9               leave
  0097BF  ca0400           retf 4

; ---- @menu_bar_key_parse  file 0x0097C2..0x009856  seg 0x6D7:0x1452  (menu.obj) ----
  0097C2  c80a0000         enter 0xa, 0
  0097C6  57               push di
  0097C7  56               push si
  0097C8  8bf8             mov di, ax
  0097CA  8b5e06           mov bx, word ptr [bp + 6]
  0097CD  8e4608           mov es, word ptr [bp + 8]
  0097D0  268b4738         mov ax, word ptr es:[bx + 0x38]
  0097D4  268b573a         mov dx, word ptr es:[bx + 0x3a]
  0097D8  8bf0             mov si, ax
  0097DA  8956f8           mov word ptr [bp - 8], dx
  0097DD  2bc0             sub ax, ax
  0097DF  8946fa           mov word ptr [bp - 6], ax
  0097E2  268907           mov word ptr es:[bx], ax
  0097E5  8946fc           mov word ptr [bp - 4], ax
  0097E8  8bc7             mov ax, di
  0097EA  9a0e00b20b       lcall 0xbb2, 0xe
  0097EF  8946fe           mov word ptr [bp - 2], ax
  0097F2  3bc7             cmp ax, di
  0097F4  7426             je 0x981c
  0097F6  8b46f8           mov ax, word ptr [bp - 8]
  0097F9  0bc6             or ax, si
  0097FB  741f             je 0x981c
  0097FD  8b4efc           mov cx, word ptr [bp - 4]
  009800  8b5efe           mov bx, word ptr [bp - 2]
  009803  0bc9             or cx, cx
  009805  752f             jne 0x9836
  009807  8e46f8           mov es, word ptr [bp - 8]
  00980A  26395c08         cmp word ptr es:[si + 8], bx
  00980E  7512             jne 0x9822
  009810  26f6440c01       test byte ptr es:[si + 0xc], 1
  009815  750b             jne 0x9822
  009817  b90100           mov cx, 1
  00981A  eb13             jmp 0x982f
  00981C  8b4efc           mov cx, word ptr [bp - 4]
  00981F  eb15             jmp 0x9836
  009821  90               nop
  009822  268b4416         mov ax, word ptr es:[si + 0x16]
  009826  268b5418         mov dx, word ptr es:[si + 0x18]
  00982A  8bf0             mov si, ax
  00982C  8956f8           mov word ptr [bp - 8], dx
  00982F  8b46f8           mov ax, word ptr [bp - 8]
  009832  0bc6             or ax, si
  009834  75cd             jne 0x9803
  009836  8b7efa           mov di, word ptr [bp - 6]
  009839  0bc9             or cx, cx
  00983B  740b             je 0x9848
  00983D  ff76f8           push word ptr [bp - 8]
  009840  56               push si
  009841  0e               push cs
  009842  e8c7f8           call 0x910c
  009845  bf0100           mov di, 1
  009848  9a2a00210c       lcall 0xc21, 0x2a
  00984D  8bc7             mov ax, di
  00984F  5e               pop si
  009850  5f               pop di
  009851  c9               leave
  009852  ca0400           retf 4
  009855  90               nop

; ---- @menu_key_parse  file 0x009856..0x00991C  seg 0x6D7:0x14e6  (menu.obj) ----
  009856  c8140000         enter 0x14, 0
  00985A  50               push ax
  00985B  57               push di
  00985C  56               push si
  00985D  c47606           les si, ptr [bp + 6]
  009860  2bc0             sub ax, ax
  009862  99               cdq
  009863  8bc8             mov cx, ax
  009865  8956f4           mov word ptr [bp - 0xc], dx
  009868  268b4438         mov ax, word ptr es:[si + 0x38]
  00986C  268b543a         mov dx, word ptr es:[si + 0x3a]
  009870  8bd8             mov bx, ax
  009872  8956f0           mov word ptr [bp - 0x10], dx
  009875  2bff             sub di, di
  009877  897eec           mov word ptr [bp - 0x14], di
  00987A  26893c           mov word ptr es:[si], di
  00987D  897efa           mov word ptr [bp - 6], di
  009880  894ef2           mov word ptr [bp - 0xe], cx
  009883  0bd0             or dx, ax
  009885  7474             je 0x98fb
  009887  8bf1             mov si, cx
  009889  8b4efa           mov cx, word ptr [bp - 6]
  00988C  0bc9             or cx, cx
  00988E  7568             jne 0x98f8
  009890  8e46f0           mov es, word ptr [bp - 0x10]
  009893  26f6470c01       test byte ptr es:[bx + 0xc], 1
  009898  754a             jne 0x98e4
  00989A  268b471e         mov ax, word ptr es:[bx + 0x1e]
  00989E  268b5720         mov dx, word ptr es:[bx + 0x20]
  0098A2  8bf0             mov si, ax
  0098A4  8956f4           mov word ptr [bp - 0xc], dx
  0098A7  0bd0             or dx, ax
  0098A9  7439             je 0x98e4
  0098AB  895eee           mov word ptr [bp - 0x12], bx
  0098AE  8b5eea           mov bx, word ptr [bp - 0x16]
  0098B1  0bc9             or cx, cx
  0098B3  7529             jne 0x98de
  0098B5  8e46f4           mov es, word ptr [bp - 0xc]
  0098B8  26395c02         cmp word ptr es:[si + 2], bx
  0098BC  750c             jne 0x98ca
  0098BE  26f60403         test byte ptr es:[si], 3
  0098C2  7506             jne 0x98ca
  0098C4  b90100           mov cx, 1
  0098C7  eb0e             jmp 0x98d7
  0098C9  90               nop
  0098CA  268b440e         mov ax, word ptr es:[si + 0xe]
  0098CE  268b5410         mov dx, word ptr es:[si + 0x10]
  0098D2  8bf0             mov si, ax
  0098D4  8956f4           mov word ptr [bp - 0xc], dx
  0098D7  8b46f4           mov ax, word ptr [bp - 0xc]
  0098DA  0bc6             or ax, si
  0098DC  75d3             jne 0x98b1
  0098DE  894efa           mov word ptr [bp - 6], cx
  0098E1  8b5eee           mov bx, word ptr [bp - 0x12]
  0098E4  8e46f0           mov es, word ptr [bp - 0x10]
  0098E7  268b4716         mov ax, word ptr es:[bx + 0x16]
  0098EB  268b5718         mov dx, word ptr es:[bx + 0x18]
  0098EF  8bd8             mov bx, ax
  0098F1  8956f0           mov word ptr [bp - 0x10], dx
  0098F4  0bd0             or dx, ax
  0098F6  7591             jne 0x9889
  0098F8  8976f2           mov word ptr [bp - 0xe], si
  0098FB  8b5eec           mov bx, word ptr [bp - 0x14]
  0098FE  8b7ef2           mov di, word ptr [bp - 0xe]
  009901  837efa00         cmp word ptr [bp - 6], 0
  009905  740d             je 0x9914
  009907  8e46f4           mov es, word ptr [bp - 0xc]
  00990A  268b5d04         mov bx, word ptr es:[di + 4]
  00990E  c47606           les si, ptr [bp + 6]
  009911  26891c           mov word ptr es:[si], bx
  009914  8bc3             mov ax, bx
  009916  5e               pop si
  009917  5f               pop di
  009918  c9               leave
  009919  ca0400           retf 4

; ---- _menu_read_colors  file 0x00991C..0x009A20  seg 0x6D7:0x15ac  (menu.obj) ----
  00991C  c80e0000         enter 0xe, 0
  009920  57               push di
  009921  56               push si
  009922  b80100           mov ax, 1
  009925  8946f4           mov word ptr [bp - 0xc], ax
  009928  8946f2           mov word ptr [bp - 0xe], ax
  00992B  8d46ff           lea ax, [bp - 1]
  00992E  8946f6           mov word ptr [bp - 0xa], ax
  009931  8c56f8           mov word ptr [bp - 8], ss
  009934  8d1e3406         lea bx, [0x634]
  009938  2bc0             sub ax, ax
  00993A  9a0800db0d       lcall 0xddb, 8
  00993F  8bf0             mov si, ax
  009941  8956fc           mov word ptr [bp - 4], dx
  009944  0bd0             or dx, ax
  009946  7503             jne 0x994b
  009948  e9d000           jmp 0x9a1b
  00994B  8b46fc           mov ax, word ptr [bp - 4]
  00994E  50               push ax
  00994F  56               push si
  009950  6a00             push 0
  009952  8bf8             mov di, ax
  009954  b80100           mov ax, 1
  009957  8d5ef2           lea bx, [bp - 0xe]
  00995A  2bd2             sub dx, dx
  00995C  9a00008f0d       lcall 0xd8f, 0
  009961  8a46ff           mov al, byte ptr [bp - 1]
  009964  2ae4             sub ah, ah
  009966  a31406           mov word ptr [0x614], ax
  009969  a31806           mov word ptr [0x618], ax
  00996C  57               push di
  00996D  56               push si
  00996E  6a00             push 0
  009970  b80200           mov ax, 2
  009973  8d5ef2           lea bx, [bp - 0xe]
  009976  2bd2             sub dx, dx
  009978  9a00008f0d       lcall 0xd8f, 0
  00997D  8a46ff           mov al, byte ptr [bp - 1]
  009980  2ae4             sub ah, ah
  009982  a31606           mov word ptr [0x616], ax
  009985  a31a06           mov word ptr [0x61a], ax
  009988  57               push di
  009989  56               push si
  00998A  6a00             push 0
  00998C  b80300           mov ax, 3
  00998F  8d5ef2           lea bx, [bp - 0xe]
  009992  2bd2             sub dx, dx
  009994  9a00008f0d       lcall 0xd8f, 0
  009999  8a46ff           mov al, byte ptr [bp - 1]
  00999C  2ae4             sub ah, ah
  00999E  a32006           mov word ptr [0x620], ax
  0099A1  a31c06           mov word ptr [0x61c], ax
  0099A4  57               push di
  0099A5  56               push si
  0099A6  6a00             push 0
  0099A8  b80400           mov ax, 4
  0099AB  8d5ef2           lea bx, [bp - 0xe]
  0099AE  2bd2             sub dx, dx
  0099B0  9a00008f0d       lcall 0xd8f, 0
  0099B5  8a46ff           mov al, byte ptr [bp - 1]
  0099B8  2ae4             sub ah, ah
  0099BA  a32206           mov word ptr [0x622], ax
  0099BD  a31e06           mov word ptr [0x61e], ax
  0099C0  57               push di
  0099C1  56               push si
  0099C2  6a00             push 0
  0099C4  b80500           mov ax, 5
  0099C7  8d5ef2           lea bx, [bp - 0xe]
  0099CA  2bd2             sub dx, dx
  0099CC  9a00008f0d       lcall 0xd8f, 0
  0099D1  8a46ff           mov al, byte ptr [bp - 1]
  0099D4  2ae4             sub ah, ah
  0099D6  a32c06           mov word ptr [0x62c], ax
  0099D9  a32606           mov word ptr [0x626], ax
  0099DC  57               push di
  0099DD  56               push si
  0099DE  6a00             push 0
  0099E0  b80600           mov ax, 6
  0099E3  8d5ef2           lea bx, [bp - 0xe]
  0099E6  2bd2             sub dx, dx
  0099E8  9a00008f0d       lcall 0xd8f, 0
  0099ED  8a46ff           mov al, byte ptr [bp - 1]
  0099F0  2ae4             sub ah, ah
  0099F2  a33006           mov word ptr [0x630], ax
  0099F5  a32a06           mov word ptr [0x62a], ax
  0099F8  57               push di
  0099F9  56               push si
  0099FA  6a00             push 0
  0099FC  b80700           mov ax, 7
  0099FF  8d5ef2           lea bx, [bp - 0xe]
  009A02  2bd2             sub dx, dx
  009A04  9a00008f0d       lcall 0xd8f, 0
  009A09  8a46ff           mov al, byte ptr [bp - 1]
  009A0C  2ae4             sub ah, ah
  009A0E  a32c06           mov word ptr [0x62c], ax
  009A11  a32806           mov word ptr [0x628], ax
  009A14  57               push di
  009A15  56               push si
  009A16  9a1003c90c       lcall 0xcc9, 0x310
  009A1B  5e               pop si
  009A1C  5f               pop di
  009A1D  c9               leave
  009A1E  cb               retf
  009A1F  90               nop
