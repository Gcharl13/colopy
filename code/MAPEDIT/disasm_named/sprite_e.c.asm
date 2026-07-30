; MAPEDIT.EXE named disasm — module sprite_e.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sprite_series_load  file 0x00F3B8..0x00FD1C  seg 0xDDB:0x8  (sprite_e.c.obj) ----
  00F3B8  c8280200         enter 0x228, 0
  00F3BC  50               push ax
  00F3BD  53               push bx
  00F3BE  57               push di
  00F3BF  56               push si
  00F3C0  2bc0             sub ax, ax
  00F3C2  894698           mov word ptr [bp - 0x68], ax
  00F3C5  894696           mov word ptr [bp - 0x6a], ax
  00F3C8  89469c           mov word ptr [bp - 0x64], ax
  00F3CB  89469a           mov word ptr [bp - 0x66], ax
  00F3CE  8986e6fd         mov word ptr [bp - 0x21a], ax
  00F3D2  8986e4fd         mov word ptr [bp - 0x21c], ax
  00F3D6  8986dcfe         mov word ptr [bp - 0x124], ax
  00F3DA  8986dafe         mov word ptr [bp - 0x126], ax
  00F3DE  c7064c070d00     mov word ptr [0x74c], 0xd
  00F3E4  89860cfe         mov word ptr [bp - 0x1f4], ax
  00F3E8  53               push bx
  00F3E9  8d46ac           lea ax, [bp - 0x54]
  00F3EC  50               push ax
  00F3ED  9a26068813       lcall 0x1388, 0x626
  00F3F2  83c404           add sp, 4
  00F3F5  6a2e             push 0x2e
  00F3F7  8d46ac           lea ax, [bp - 0x54]
  00F3FA  50               push ax
  00F3FB  9ae8098813       lcall 0x1388, 0x9e8
  00F400  83c404           add sp, 4
  00F403  0bc0             or ax, ax
  00F405  750f             jne 0xf416
  00F407  68ba3a           push 0x3aba
  00F40A  8d46ac           lea ax, [bp - 0x54]
  00F40D  50               push ax
  00F40E  9ae6058813       lcall 0x1388, 0x5e6
  00F413  83c404           add sp, 4
  00F416  68be3a           push 0x3abe
  00F419  8d86f6fd         lea ax, [bp - 0x20a]
  00F41D  50               push ax
  00F41E  9a26068813       lcall 0x1388, 0x626
  00F423  83c404           add sp, 4
  00F426  8d46ac           lea ax, [bp - 0x54]
  00F429  89860afe         mov word ptr [bp - 0x1f6], ax
  00F42D  50               push ax
  00F42E  9a880a8813       lcall 0x1388, 0xa88
  00F433  83c402           add sp, 2
  00F436  807eac2a         cmp byte ptr [bp - 0x54], 0x2a
  00F43A  7507             jne 0xf443
  00F43C  8d46ad           lea ax, [bp - 0x53]
  00F43F  89860afe         mov word ptr [bp - 0x1f6], ax
  00F443  8b9e0afe         mov bx, word ptr [bp - 0x1f6]
  00F447  803f52           cmp byte ptr [bx], 0x52
  00F44A  750b             jne 0xf457
  00F44C  807f014d         cmp byte ptr [bx + 1], 0x4d
  00F450  7505             jne 0xf457
  00F452  83860afe02       add word ptr [bp - 0x1f6], 2
  00F457  6a06             push 6
  00F459  ffb60afe         push word ptr [bp - 0x1f6]
  00F45D  8d86f6fd         lea ax, [bp - 0x20a]
  00F461  50               push ax
  00F462  9aa0068813       lcall 0x1388, 0x6a0
  00F467  83c406           add sp, 6
  00F46A  8d860cfe         lea ax, [bp - 0x1f4]
  00F46E  16               push ss
  00F46F  50               push ax
  00F470  8d46ac           lea ax, [bp - 0x54]
  00F473  16               push ss
  00F474  50               push ax
  00F475  8d1ec13a         lea bx, [0x3ac1]
  00F479  b80100           mov ax, 1
  00F47C  9a00001a12       lcall 0x121a, 0
  00F481  0bc0             or ax, ax
  00F483  7409             je 0xf48e
  00F485  c706de3affff     mov word ptr [0x3ade], 0xffff
  00F48B  e91b08           jmp 0xfca9
  00F48E  c706de3afeff     mov word ptr [0x3ade], 0xfffe
  00F494  c786dcfd9800     mov word ptr [bp - 0x224], 0x98
  00F49A  8d86e2fe         lea ax, [bp - 0x11e]
  00F49E  16               push ss
  00F49F  50               push ax
  00F4A0  6a00             push 0
  00F4A2  6a01             push 1
  00F4A4  8d860cfe         lea ax, [bp - 0x1f4]
  00F4A8  16               push ss
  00F4A9  50               push ax
  00F4AA  b89800           mov ax, 0x98
  00F4AD  99               cdq
  00F4AE  9a02005812       lcall 0x1258, 2
  00F4B3  0bd0             or dx, ax
  00F4B5  7503             jne 0xf4ba
  00F4B7  e9ef07           jmp 0xfca9
  00F4BA  83beecfe00       cmp word ptr [bp - 0x114], 0
  00F4BF  7405             je 0xf4c6
  00F4C1  808ed6fd04       or byte ptr [bp - 0x22a], 4
  00F4C6  8b8608ff         mov ax, word ptr [bp - 0xf8]
  00F4CA  c1e004           shl ax, 4
  00F4CD  8946fc           mov word ptr [bp - 4], ax
  00F4D0  8b8608ff         mov ax, word ptr [bp - 0xf8]
  00F4D4  8bc8             mov cx, ax
  00F4D6  d1e0             shl ax, 1
  00F4D8  03c1             add ax, cx
  00F4DA  c1e002           shl ax, 2
  00F4DD  054200           add ax, 0x42
  00F4E0  99               cdq
  00F4E1  8986defe         mov word ptr [bp - 0x122], ax
  00F4E5  8996e0fe         mov word ptr [bp - 0x120], dx
  00F4E9  f686d6fd04       test byte ptr [bp - 0x22a], 4
  00F4EE  740e             je 0xf4fe
  00F4F0  056800           add ax, 0x68
  00F4F3  83d200           adc dx, 0
  00F4F6  8986defe         mov word ptr [bp - 0x122], ax
  00F4FA  8996e0fe         mov word ptr [bp - 0x120], dx
  00F4FE  89468e           mov word ptr [bp - 0x72], ax
  00F501  895690           mov word ptr [bp - 0x70], dx
  00F504  80bee2fe00       cmp byte ptr [bp - 0x11e], 0
  00F509  7414             je 0xf51f
  00F50B  83c122           add cx, 0x22
  00F50E  c1e103           shl cx, 3
  00F511  2bdb             sub bx, bx
  00F513  03c1             add ax, cx
  00F515  13d3             adc dx, bx
  00F517  8986defe         mov word ptr [bp - 0x122], ax
  00F51B  8996e0fe         mov word ptr [bp - 0x120], dx
  00F51F  8986e0fd         mov word ptr [bp - 0x220], ax
  00F523  8996e2fd         mov word ptr [bp - 0x21e], dx
  00F527  f686d6fd02       test byte ptr [bp - 0x22a], 2
  00F52C  7517             jne 0xf545
  00F52E  80bee2fe00       cmp byte ptr [bp - 0x11e], 0
  00F533  7510             jne 0xf545
  00F535  038676ff         add ax, word ptr [bp - 0x8a]
  00F539  139678ff         adc dx, word ptr [bp - 0x88]
  00F53D  8986e0fd         mov word ptr [bp - 0x220], ax
  00F541  8996e2fd         mov word ptr [bp - 0x21e], dx
  00F545  a1e63a           mov ax, word ptr [0x3ae6]
  00F548  0b06e43a         or ax, word ptr [0x3ae4]
  00F54C  7422             je 0xf570
  00F54E  a1c25e           mov ax, word ptr [0x5ec2]
  00F551  8b16c45e         mov dx, word ptr [0x5ec4]
  00F555  3996e2fd         cmp word ptr [bp - 0x21e], dx
  00F559  7f15             jg 0xf570
  00F55B  7c06             jl 0xf563
  00F55D  3986e0fd         cmp word ptr [bp - 0x220], ax
  00F561  770d             ja 0xf570
  00F563  a1e43a           mov ax, word ptr [0x3ae4]
  00F566  8b16e63a         mov dx, word ptr [0x3ae6]
  00F56A  89469a           mov word ptr [bp - 0x66], ax
  00F56D  89569c           mov word ptr [bp - 0x64], dx
  00F570  8b86e0fd         mov ax, word ptr [bp - 0x220]
  00F574  8b96e2fd         mov dx, word ptr [bp - 0x21e]
  00F578  a39a5a           mov word ptr [0x5a9a], ax
  00F57B  89169c5a         mov word ptr [0x5a9c], dx
  00F57F  8b4e9c           mov cx, word ptr [bp - 0x64]
  00F582  0b4e9a           or cx, word ptr [bp - 0x66]
  00F585  7511             jne 0xf598
  00F587  8d8ef6fd         lea cx, [bp - 0x20a]
  00F58B  16               push ss
  00F58C  51               push cx
  00F58D  9a3601c90c       lcall 0xcc9, 0x136
  00F592  89469a           mov word ptr [bp - 0x66], ax
  00F595  89569c           mov word ptr [bp - 0x64], dx
  00F598  8b469c           mov ax, word ptr [bp - 0x64]
  00F59B  0b469a           or ax, word ptr [bp - 0x66]
  00F59E  750a             jne 0xf5aa
  00F5A0  c706de3afcff     mov word ptr [0x3ade], 0xfffc
  00F5A6  e90007           jmp 0xfca9
  00F5A9  90               nop
  00F5AA  1e               push ds
  00F5AB  68c43a           push 0x3ac4
  00F5AE  8b46fc           mov ax, word ptr [bp - 4]
  00F5B1  99               cdq
  00F5B2  9a3601c90c       lcall 0xcc9, 0x136
  00F5B7  894696           mov word ptr [bp - 0x6a], ax
  00F5BA  895698           mov word ptr [bp - 0x68], dx
  00F5BD  0bd0             or dx, ax
  00F5BF  74df             je 0xf5a0
  00F5C1  c45e9a           les bx, ptr [bp - 0x66]
  00F5C4  2bc0             sub ax, ax
  00F5C6  26894740         mov word ptr es:[bx + 0x40], ax
  00F5CA  2689473e         mov word ptr es:[bx + 0x3e], ax
  00F5CE  26894738         mov word ptr es:[bx + 0x38], ax
  00F5D2  26894736         mov word ptr es:[bx + 0x36], ax
  00F5D6  26894730         mov word ptr es:[bx + 0x30], ax
  00F5DA  2689472e         mov word ptr es:[bx + 0x2e], ax
  00F5DE  26894734         mov word ptr es:[bx + 0x34], ax
  00F5E2  26894732         mov word ptr es:[bx + 0x32], ax
  00F5E6  2689473c         mov word ptr es:[bx + 0x3c], ax
  00F5EA  2689473a         mov word ptr es:[bx + 0x3a], ax
  00F5EE  ff7698           push word ptr [bp - 0x68]
  00F5F1  ff7696           push word ptr [bp - 0x6a]
  00F5F4  50               push ax
  00F5F5  6a01             push 1
  00F5F7  8d860cfe         lea ax, [bp - 0x1f4]
  00F5FB  16               push ss
  00F5FC  50               push ax
  00F5FD  8b46fc           mov ax, word ptr [bp - 4]
  00F600  99               cdq
  00F601  9a02005812       lcall 0x1258, 2
  00F606  0bd0             or dx, ax
  00F608  750a             jne 0xf614
  00F60A  c706de3afeff     mov word ptr [0x3ade], 0xfffe
  00F610  e99606           jmp 0xfca9
  00F613  90               nop
  00F614  83beeefe00       cmp word ptr [bp - 0x112], 0
  00F619  755b             jne 0xf676
  00F61B  1e               push ds
  00F61C  68cd3a           push 0x3acd
  00F61F  8bbe24fe         mov di, word ptr [bp - 0x1dc]
  00F623  8bc7             mov ax, di
  00F625  c1e702           shl di, 2
  00F628  03f8             add di, ax
  00F62A  d1e7             shl di, 1
  00F62C  8b8338fe         mov ax, word ptr [bp + di - 0x1c8]
  00F630  8b933afe         mov dx, word ptr [bp + di - 0x1c6]
  00F634  8986eafd         mov word ptr [bp - 0x216], ax
  00F638  8996ecfd         mov word ptr [bp - 0x214], dx
  00F63C  9a3601c90c       lcall 0xcc9, 0x136
  00F641  8986dafe         mov word ptr [bp - 0x126], ax
  00F645  8996dcfe         mov word ptr [bp - 0x124], dx
  00F649  0bd0             or dx, ax
  00F64B  7503             jne 0xf650
  00F64D  e950ff           jmp 0xf5a0
  00F650  ffb6dcfe         push word ptr [bp - 0x124]
  00F654  50               push ax
  00F655  6a00             push 0
  00F657  6a01             push 1
  00F659  8d860cfe         lea ax, [bp - 0x1f4]
  00F65D  16               push ss
  00F65E  50               push ax
  00F65F  8b86eafd         mov ax, word ptr [bp - 0x216]
  00F663  8b96ecfd         mov dx, word ptr [bp - 0x214]
  00F667  9a02005812       lcall 0x1258, 2
  00F66C  0bd0             or dx, ax
  00F66E  7403             je 0xf673
  00F670  e99300           jmp 0xf706
  00F673  e93306           jmp 0xfca9
  00F676  8bbe24fe         mov di, word ptr [bp - 0x1dc]
  00F67A  8bc7             mov ax, di
  00F67C  c1e702           shl di, 2
  00F67F  03f8             add di, ax
  00F681  d1e7             shl di, 1
  00F683  8b8338fe         mov ax, word ptr [bp + di - 0x1c8]
  00F687  8b933afe         mov dx, word ptr [bp + di - 0x1c6]
  00F68B  8986eafd         mov word ptr [bp - 0x216], ax
  00F68F  8996ecfd         mov word ptr [bp - 0x214], dx
  00F693  a1e23a           mov ax, word ptr [0x3ae2]
  00F696  0b06e03a         or ax, word ptr [0x3ae0]
  00F69A  7428             je 0xf6c4
  00F69C  a1e03a           mov ax, word ptr [0x3ae0]
  00F69F  8b16e23a         mov dx, word ptr [0x3ae2]
  00F6A3  89469e           mov word ptr [bp - 0x62], ax
  00F6A6  8956a0           mov word ptr [bp - 0x60], dx
  00F6A9  2bc9             sub cx, cx
  00F6AB  898edcfe         mov word ptr [bp - 0x124], cx
  00F6AF  898edafe         mov word ptr [bp - 0x126], cx
  00F6B3  52               push dx
  00F6B4  50               push ax
  00F6B5  51               push cx
  00F6B6  6a01             push 1
  00F6B8  8d860cfe         lea ax, [bp - 0x1f4]
  00F6BC  16               push ss
  00F6BD  50               push ax
  00F6BE  b80003           mov ax, 0x300
  00F6C1  99               cdq
  00F6C2  eba3             jmp 0xf667
  00F6C4  8d46a2           lea ax, [bp - 0x5e]
  00F6C7  50               push ax
  00F6C8  ffb612fe         push word ptr [bp - 0x1ee]
  00F6CC  9a62078813       lcall 0x1388, 0x762
  00F6D1  83c404           add sp, 4
  00F6D4  6a00             push 0
  00F6D6  8bbe24fe         mov di, word ptr [bp - 0x1dc]
  00F6DA  ff8624fe         inc word ptr [bp - 0x1dc]
  00F6DE  897eaa           mov word ptr [bp - 0x56], di
  00F6E1  8bc7             mov ax, di
  00F6E3  c1e702           shl di, 2
  00F6E6  03f8             add di, ax
  00F6E8  d1e7             shl di, 1
  00F6EA  8b833cfe         mov ax, word ptr [bp + di - 0x1c4]
  00F6EE  8b933efe         mov dx, word ptr [bp + di - 0x1c2]
  00F6F2  0346a2           add ax, word ptr [bp - 0x5e]
  00F6F5  1356a4           adc dx, word ptr [bp - 0x5c]
  00F6F8  52               push dx
  00F6F9  50               push ax
  00F6FA  ffb612fe         push word ptr [bp - 0x1ee]
  00F6FE  9afe078813       lcall 0x1388, 0x7fe
  00F703  83c408           add sp, 8
  00F706  8a86e2fe         mov al, byte ptr [bp - 0x11e]
  00F70A  c45e9a           les bx, ptr [bp - 0x66]
  00F70D  2688472c         mov byte ptr es:[bx + 0x2c], al
  00F711  83bee4fe00       cmp word ptr [bp - 0x11c], 0
  00F716  740e             je 0xf726
  00F718  83bee6fe04       cmp word ptr [bp - 0x11a], 4
  00F71D  7d07             jge 0xf726
  00F71F  26c7070100       mov word ptr es:[bx], 1
  00F724  eb08             jmp 0xf72e
  00F726  c45e9a           les bx, ptr [bp - 0x66]
  00F729  26c7070000       mov word ptr es:[bx], 0
  00F72E  8b86e6fe         mov ax, word ptr [bp - 0x11a]
  00F732  c45e9a           les bx, ptr [bp - 0x66]
  00F735  26894702         mov word ptr es:[bx + 2], ax
  00F739  8b8608ff         mov ax, word ptr [bp - 0xf8]
  00F73D  26894704         mov word ptr es:[bx + 4], ax
  00F741  8b8672ff         mov ax, word ptr [bp - 0x8e]
  00F745  26894728         mov word ptr es:[bx + 0x28], ax
  00F749  8b8674ff         mov ax, word ptr [bp - 0x8c]
  00F74D  2689472a         mov word ptr es:[bx + 0x2a], ax
  00F751  2bf6             sub si, si
  00F753  8e469c           mov es, word ptr [bp - 0x64]
  00F756  8bfe             mov di, si
  00F758  d1e7             shl di, 1
  00F75A  8b83e8fe         mov ax, word ptr [bp + di - 0x118]
  00F75E  8b5e9a           mov bx, word ptr [bp - 0x66]
  00F761  26894108         mov word ptr es:[bx + di + 8], ax
  00F765  46               inc si
  00F766  83fe10           cmp si, 0x10
  00F769  7ceb             jl 0xf756
  00F76B  f686d6fd04       test byte ptr [bp - 0x22a], 4
  00F770  7441             je 0xf7b3
  00F772  8b468e           mov ax, word ptr [bp - 0x72]
  00F775  03469a           add ax, word ptr [bp - 0x66]
  00F778  8b569c           mov dx, word ptr [bp - 0x64]
  00F77B  2d6800           sub ax, 0x68
  00F77E  c45e9a           les bx, ptr [bp - 0x66]
  00F781  2689473e         mov word ptr es:[bx + 0x3e], ax
  00F785  26895740         mov word ptr es:[bx + 0x40], dx
  00F789  52               push dx
  00F78A  50               push ax
  00F78B  9a02004f10       lcall 0x104f, 2
  00F790  c45e9a           les bx, ptr [bp - 0x66]
  00F793  2689473e         mov word ptr es:[bx + 0x3e], ax
  00F797  26895740         mov word ptr es:[bx + 0x40], dx
  00F79B  6a68             push 0x68
  00F79D  8d860aff         lea ax, [bp - 0xf6]
  00F7A1  16               push ss
  00F7A2  50               push ax
  00F7A3  26ff7740         push word ptr es:[bx + 0x40]
  00F7A7  26ff773e         push word ptr es:[bx + 0x3e]
  00F7AB  9a4a0c8813       lcall 0x1388, 0xc4a
  00F7B0  83c40a           add sp, 0xa
  00F7B3  8b86defe         mov ax, word ptr [bp - 0x122]
  00F7B7  03469a           add ax, word ptr [bp - 0x66]
  00F7BA  8b569c           mov dx, word ptr [bp - 0x64]
  00F7BD  52               push dx
  00F7BE  50               push ax
  00F7BF  9a02004f10       lcall 0x104f, 2
  00F7C4  8986f2fd         mov word ptr [bp - 0x20e], ax
  00F7C8  8996f4fd         mov word ptr [bp - 0x20c], dx
  00F7CC  89468a           mov word ptr [bp - 0x76], ax
  00F7CF  89568c           mov word ptr [bp - 0x74], dx
  00F7D2  2bf6             sub si, si
  00F7D4  eb17             jmp 0xf7ed
  00F7D6  8bfe             mov di, si
  00F7D8  d1e7             shl di, 1
  00F7DA  03fe             add di, si
  00F7DC  c1e702           shl di, 2
  00F7DF  c45e9a           les bx, ptr [bp - 0x66]
  00F7E2  2bc0             sub ax, ax
  00F7E4  26894144         mov word ptr es:[bx + di + 0x44], ax
  00F7E8  26894142         mov word ptr es:[bx + di + 0x42], ax
  00F7EC  46               inc si
  00F7ED  c45e9a           les bx, ptr [bp - 0x66]
  00F7F0  26397704         cmp word ptr es:[bx + 4], si
  00F7F4  7e7e             jle 0xf874
  00F7F6  8bfe             mov di, si
  00F7F8  c1e704           shl di, 4
  00F7FB  037e96           add di, word ptr [bp - 0x6a]
  00F7FE  8e4698           mov es, word ptr [bp - 0x68]
  00F801  268b4508         mov ax, word ptr es:[di + 8]
  00F805  8bde             mov bx, si
  00F807  d1e3             shl bx, 1
  00F809  03de             add bx, si
  00F80B  c1e302           shl bx, 2
  00F80E  8cc1             mov cx, es
  00F810  035e9a           add bx, word ptr [bp - 0x66]
  00F813  8e469c           mov es, word ptr [bp - 0x64]
  00F816  26894746         mov word ptr es:[bx + 0x46], ax
  00F81A  8cc0             mov ax, es
  00F81C  8ec1             mov es, cx
  00F81E  268b550a         mov dx, word ptr es:[di + 0xa]
  00F822  8ec0             mov es, ax
  00F824  26895748         mov word ptr es:[bx + 0x48], dx
  00F828  8ec1             mov es, cx
  00F82A  268b550c         mov dx, word ptr es:[di + 0xc]
  00F82E  8ec0             mov es, ax
  00F830  2689574a         mov word ptr es:[bx + 0x4a], dx
  00F834  8ec1             mov es, cx
  00F836  268b550e         mov dx, word ptr es:[di + 0xe]
  00F83A  8ec0             mov es, ax
  00F83C  2689574c         mov word ptr es:[bx + 0x4c], dx
  00F840  f686d6fd02       test byte ptr [bp - 0x22a], 2
  00F845  758f             jne 0xf7d6
  00F847  80bee2fe00       cmp byte ptr [bp - 0x11e], 0
  00F84C  7588             jne 0xf7d6
  00F84E  8b468a           mov ax, word ptr [bp - 0x76]
  00F851  8b568c           mov dx, word ptr [bp - 0x74]
  00F854  26894742         mov word ptr es:[bx + 0x42], ax
  00F858  26895744         mov word ptr es:[bx + 0x44], dx
  00F85C  8ec1             mov es, cx
  00F85E  26034504         add ax, word ptr es:[di + 4]
  00F862  52               push dx
  00F863  50               push ax
  00F864  9a02004f10       lcall 0x104f, 2
  00F869  89468a           mov word ptr [bp - 0x76], ax
  00F86C  89568c           mov word ptr [bp - 0x74], dx
  00F86F  e97aff           jmp 0xf7ec
  00F872  90               nop
  00F873  90               nop
  00F874  f686d6fd02       test byte ptr [bp - 0x22a], 2
  00F879  752d             jne 0xf8a8
  00F87B  80bee2fe00       cmp byte ptr [bp - 0x11e], 0
  00F880  7526             jne 0xf8a8
  00F882  ffb6f4fd         push word ptr [bp - 0x20c]
  00F886  ffb6f2fd         push word ptr [bp - 0x20e]
  00F88A  6a00             push 0
  00F88C  6a01             push 1
  00F88E  8d860cfe         lea ax, [bp - 0x1f4]
  00F892  16               push ss
  00F893  50               push ax
  00F894  8b8676ff         mov ax, word ptr [bp - 0x8a]
  00F898  8b9678ff         mov dx, word ptr [bp - 0x88]
  00F89C  9a02005812       lcall 0x1258, 2
  00F8A1  0bd0             or dx, ax
  00F8A3  7503             jne 0xf8a8
  00F8A5  e90104           jmp 0xfca9
  00F8A8  83beeefe00       cmp word ptr [bp - 0x112], 0
  00F8AD  7403             je 0xf8b2
  00F8AF  e96701           jmp 0xfa19
  00F8B2  f686d6fd09       test byte ptr [bp - 0x22a], 9
  00F8B7  7503             jne 0xf8bc
  00F8B9  e90c01           jmp 0xf9c8
  00F8BC  c45e9a           les bx, ptr [bp - 0x66]
  00F8BF  26c747060000     mov word ptr es:[bx + 6], 0
  00F8C5  f686d6fd08       test byte ptr [bp - 0x22a], 8
  00F8CA  7503             jne 0xf8cf
  00F8CC  e94a01           jmp 0xfa19
  00F8CF  2bf6             sub si, si
  00F8D1  89b6defd         mov word ptr [bp - 0x222], si
  00F8D5  e9d100           jmp 0xf9a9
  00F8D8  837efe04         cmp word ptr [bp - 2], 4
  00F8DC  7d59             jge 0xf937
  00F8DE  6a03             push 3
  00F8E0  8b46fe           mov ax, word ptr [bp - 2]
  00F8E3  8bc8             mov cx, ax
  00F8E5  d1e0             shl ax, 1
  00F8E7  03c1             add ax, cx
  00F8E9  05205b           add ax, 0x5b20
  00F8EC  1e               push ds
  00F8ED  50               push ax
  00F8EE  8bc6             mov ax, si
  00F8F0  d1e0             shl ax, 1
  00F8F2  03c6             add ax, si
  00F8F4  d1e0             shl ax, 1
  00F8F6  0386dafe         add ax, word ptr [bp - 0x126]
  00F8FA  8b96dcfe         mov dx, word ptr [bp - 0x124]
  00F8FE  8bc8             mov cx, ax
  00F900  8bda             mov bx, dx
  00F902  40               inc ax
  00F903  40               inc ax
  00F904  52               push dx
  00F905  50               push ax
  00F906  8bf9             mov di, cx
  00F908  89bed8fd         mov word ptr [bp - 0x228], di
  00F90C  899edafd         mov word ptr [bp - 0x226], bx
  00F910  9aee0b8813       lcall 0x1388, 0xbee
  00F915  83c40a           add sp, 0xa
  00F918  0bc0             or ax, ax
  00F91A  7511             jne 0xf92d
  00F91C  c786e8fd0100     mov word ptr [bp - 0x218], 1
  00F922  8a46fe           mov al, byte ptr [bp - 2]
  00F925  c49ed8fd         les bx, ptr [bp - 0x228]
  00F929  26884705         mov byte ptr es:[bx + 5], al
  00F92D  ff46fe           inc word ptr [bp - 2]
  00F930  83bee8fd00       cmp word ptr [bp - 0x218], 0
  00F935  74a1             je 0xf8d8
  00F937  83bee8fd00       cmp word ptr [bp - 0x218], 0
  00F93C  756a             jne 0xf9a8
  00F93E  6a03             push 3
  00F940  8bc6             mov ax, si
  00F942  d1e0             shl ax, 1
  00F944  03c6             add ax, si
  00F946  d1e0             shl ax, 1
  00F948  0386dafe         add ax, word ptr [bp - 0x126]
  00F94C  8b96dcfe         mov dx, word ptr [bp - 0x124]
  00F950  8bc8             mov cx, ax
  00F952  8bda             mov bx, dx
  00F954  40               inc ax
  00F955  40               inc ax
  00F956  52               push dx
  00F957  50               push ax
  00F958  8e06b648         mov es, word ptr [0x48b6]
  00F95C  8bbedefd         mov di, word ptr [bp - 0x222]
  00F960  268a850000       mov al, byte ptr es:[di]
  00F965  2ae4             sub ah, ah
  00F967  8bd0             mov dx, ax
  00F969  d1e0             shl ax, 1
  00F96B  03c2             add ax, dx
  00F96D  05205b           add ax, 0x5b20
  00F970  1e               push ds
  00F971  50               push ax
  00F972  8bf9             mov di, cx
  00F974  89bed8fd         mov word ptr [bp - 0x228], di
  00F978  899edafd         mov word ptr [bp - 0x226], bx
  00F97C  9a4a0c8813       lcall 0x1388, 0xc4a
  00F981  83c40a           add sp, 0xa
  00F984  8e06b648         mov es, word ptr [0x48b6]
  00F988  8b9edefd         mov bx, word ptr [bp - 0x222]
  00F98C  268a870000       mov al, byte ptr es:[bx]
  00F991  c4bed8fd         les di, ptr [bp - 0x228]
  00F995  26884505         mov byte ptr es:[di + 5], al
  00F999  8d4701           lea ax, [bx + 1]
  00F99C  3d0600           cmp ax, 6
  00F99F  7e03             jle 0xf9a4
  00F9A1  b80600           mov ax, 6
  00F9A4  8986defd         mov word ptr [bp - 0x222], ax
  00F9A8  46               inc si
  00F9A9  c49edafe         les bx, ptr [bp - 0x126]
  00F9AD  263937           cmp word ptr es:[bx], si
  00F9B0  7e0c             jle 0xf9be
  00F9B2  2bc0             sub ax, ax
  00F9B4  8986e8fd         mov word ptr [bp - 0x218], ax
  00F9B8  8946fe           mov word ptr [bp - 2], ax
  00F9BB  e972ff           jmp 0xf930
  00F9BE  ff769c           push word ptr [bp - 0x64]
  00F9C1  ff769a           push word ptr [bp - 0x66]
  00F9C4  06               push es
  00F9C5  53               push bx
  00F9C6  eb4c             jmp 0xfa14
  00F9C8  ffb6dcfe         push word ptr [bp - 0x124]
  00F9CC  ffb6dafe         push word ptr [bp - 0x126]
  00F9D0  ff360644         push word ptr [0x4406]
  00F9D4  ff360444         push word ptr [0x4404]
  00F9D8  8aa6d7fd         mov ah, byte ptr [bp - 0x229]
  00F9DC  2500fc           and ax, 0xfc00
  00F9DF  9a16047410       lcall 0x1074, 0x416
  00F9E4  c45e9a           les bx, ptr [bp - 0x66]
  00F9E7  26894706         mov word ptr es:[bx + 6], ax
  00F9EB  0bc0             or ax, ax
  00F9ED  7d09             jge 0xf9f8
  00F9EF  c706de3af7ff     mov word ptr [0x3ade], 0xfff7
  00F9F5  e9b102           jmp 0xfca9
  00F9F8  f686d6fd02       test byte ptr [bp - 0x22a], 2
  00F9FD  751a             jne 0xfa19
  00F9FF  80bee2fe00       cmp byte ptr [bp - 0x11e], 0
  00FA04  7513             jne 0xfa19
  00FA06  ff769c           push word ptr [bp - 0x64]
  00FA09  ff769a           push word ptr [bp - 0x66]
  00FA0C  ffb6dcfe         push word ptr [bp - 0x124]
  00FA10  ffb6dafe         push word ptr [bp - 0x126]
  00FA14  9a06006910       lcall 0x1069, 6
  00FA19  80bee2fe00       cmp byte ptr [bp - 0x11e], 0
  00FA1E  7503             jne 0xfa23
  00FA20  e97802           jmp 0xfc9b
  00FA23  8b468e           mov ax, word ptr [bp - 0x72]
  00FA26  03469a           add ax, word ptr [bp - 0x66]
  00FA29  8b569c           mov dx, word ptr [bp - 0x64]
  00FA2C  c45e9a           les bx, ptr [bp - 0x66]
  00FA2F  26894736         mov word ptr es:[bx + 0x36], ax
  00FA33  26895738         mov word ptr es:[bx + 0x38], dx
  00FA37  05fc00           add ax, 0xfc
  00FA3A  2689472e         mov word ptr es:[bx + 0x2e], ax
  00FA3E  26895730         mov word ptr es:[bx + 0x30], dx
  00FA42  894692           mov word ptr [bp - 0x6e], ax
  00FA45  895694           mov word ptr [bp - 0x6c], dx
  00FA48  051400           add ax, 0x14
  00FA4B  26894732         mov word ptr es:[bx + 0x32], ax
  00FA4F  26895734         mov word ptr es:[bx + 0x34], dx
  00FA53  8946a6           mov word ptr [bp - 0x5a], ax
  00FA56  8956a8           mov word ptr [bp - 0x58], dx
  00FA59  2bf6             sub si, si
  00FA5B  eb18             jmp 0xfa75
  00FA5D  90               nop
  00FA5E  8bfe             mov di, si
  00FA60  d1e7             shl di, 1
  00FA62  03fe             add di, si
  00FA64  d1e7             shl di, 1
  00FA66  268a4105         mov al, byte ptr es:[bx + di + 5]
  00FA6A  c45e9a           les bx, ptr [bp - 0x66]
  00FA6D  26c45f36         les bx, ptr es:[bx + 0x36]
  00FA71  268800           mov byte ptr es:[bx + si], al
  00FA74  46               inc si
  00FA75  c49edafe         les bx, ptr [bp - 0x126]
  00FA79  263937           cmp word ptr es:[bx], si
  00FA7C  7fe0             jg 0xfa5e
  00FA7E  8a86e3fe         mov al, byte ptr [bp - 0x11d]
  00FA82  c45e92           les bx, ptr [bp - 0x6e]
  00FA85  26884701         mov byte ptr es:[bx + 1], al
  00FA89  8a8610fe         mov al, byte ptr [bp - 0x1f0]
  00FA8D  268807           mov byte ptr es:[bx], al
  00FA90  8bc8             mov cx, ax
  00FA92  fec8             dec al
  00FA94  7408             je 0xfa9e
  00FA96  80f902           cmp cl, 2
  00FA99  7403             je 0xfa9e
  00FA9B  e9be00           jmp 0xfb5c
  00FA9E  8b8614fe         mov ax, word ptr [bp - 0x1ec]
  00FAA2  c45e92           les bx, ptr [bp - 0x6e]
  00FAA5  26894708         mov word ptr es:[bx + 8], ax
  00FAA9  8b861cfe         mov ax, word ptr [bp - 0x1e4]
  00FAAD  2689470a         mov word ptr es:[bx + 0xa], ax
  00FAB1  8b861efe         mov ax, word ptr [bp - 0x1e2]
  00FAB5  2689470c         mov word ptr es:[bx + 0xc], ax
  00FAB9  8b8616fe         mov ax, word ptr [bp - 0x1ea]
  00FABD  2689470e         mov word ptr es:[bx + 0xe], ax
  00FAC1  8b8618fe         mov ax, word ptr [bp - 0x1e8]
  00FAC5  8b961afe         mov dx, word ptr [bp - 0x1e6]
  00FAC9  26894710         mov word ptr es:[bx + 0x10], ax
  00FACD  26895712         mov word ptr es:[bx + 0x12], dx
  00FAD1  2bc0             sub ax, ax
  00FAD3  8986f0fd         mov word ptr [bp - 0x210], ax
  00FAD7  8986eefd         mov word ptr [bp - 0x212], ax
  00FADB  8986d8fe         mov word ptr [bp - 0x128], ax
  00FADF  8986d6fe         mov word ptr [bp - 0x12a], ax
  00FAE3  2bf6             sub si, si
  00FAE5  eb02             jmp 0xfae9
  00FAE7  90               nop
  00FAE8  46               inc si
  00FAE9  c45e9a           les bx, ptr [bp - 0x66]
  00FAEC  26397704         cmp word ptr es:[bx + 4], si
  00FAF0  7f03             jg 0xfaf5
  00FAF2  e90b01           jmp 0xfc00
  00FAF5  8b86d6fe         mov ax, word ptr [bp - 0x12a]
  00FAF9  8b96d8fe         mov dx, word ptr [bp - 0x128]
  00FAFD  8bde             mov bx, si
  00FAFF  c1e303           shl bx, 3
  00FB02  c47ea6           les di, ptr [bp - 0x5a]
  00FB05  268901           mov word ptr es:[bx + di], ax
  00FB08  26895102         mov word ptr es:[bx + di + 2], dx
  00FB0C  8bfe             mov di, si
  00FB0E  c1e704           shl di, 4
  00FB11  8bcb             mov cx, bx
  00FB13  c45e96           les bx, ptr [bp - 0x6a]
  00FB16  268b4104         mov ax, word ptr es:[bx + di + 4]
  00FB1A  268b5106         mov dx, word ptr es:[bx + di + 6]
  00FB1E  c45ea6           les bx, ptr [bp - 0x5a]
  00FB21  03d9             add bx, cx
  00FB23  26894704         mov word ptr es:[bx + 4], ax
  00FB27  26895706         mov word ptr es:[bx + 6], dx
  00FB2B  0186d6fe         add word ptr [bp - 0x12a], ax
  00FB2F  1196d8fe         adc word ptr [bp - 0x128], dx
  00FB33  268b4704         mov ax, word ptr es:[bx + 4]
  00FB37  268b5706         mov dx, word ptr es:[bx + 6]
  00FB3B  3b96f0fd         cmp dx, word ptr [bp - 0x210]
  00FB3F  7f10             jg 0xfb51
  00FB41  7c06             jl 0xfb49
  00FB43  3b86eefd         cmp ax, word ptr [bp - 0x212]
  00FB47  7308             jae 0xfb51
  00FB49  8b96f0fd         mov dx, word ptr [bp - 0x210]
  00FB4D  8b86eefd         mov ax, word ptr [bp - 0x212]
  00FB51  8986eefd         mov word ptr [bp - 0x212], ax
  00FB55  8996f0fd         mov word ptr [bp - 0x210], dx
  00FB59  eb8d             jmp 0xfae8
  00FB5B  90               nop
  00FB5C  8b8612fe         mov ax, word ptr [bp - 0x1ee]
  00FB60  c45e92           les bx, ptr [bp - 0x6e]
  00FB63  26894702         mov word ptr es:[bx + 2], ax
  00FB67  8d86d6fe         lea ax, [bp - 0x12a]
  00FB6B  50               push ax
  00FB6C  ffb612fe         push word ptr [bp - 0x1ee]
  00FB70  9a62078813       lcall 0x1388, 0x762
  00FB75  83c404           add sp, 4
  00FB78  8b86d6fe         mov ax, word ptr [bp - 0x12a]
  00FB7C  8b96d8fe         mov dx, word ptr [bp - 0x128]
  00FB80  c45e92           les bx, ptr [bp - 0x6e]
  00FB83  26894704         mov word ptr es:[bx + 4], ax
  00FB87  26895706         mov word ptr es:[bx + 6], dx
  00FB8B  2bc0             sub ax, ax
  00FB8D  8986f0fd         mov word ptr [bp - 0x210], ax
  00FB91  8986eefd         mov word ptr [bp - 0x212], ax
  00FB95  2bf6             sub si, si
  00FB97  eb5e             jmp 0xfbf7
  00FB99  90               nop
  00FB9A  8bde             mov bx, si
  00FB9C  c1e304           shl bx, 4
  00FB9F  c47e96           les di, ptr [bp - 0x6a]
  00FBA2  268b01           mov ax, word ptr es:[bx + di]
  00FBA5  268b5102         mov dx, word ptr es:[bx + di + 2]
  00FBA9  8bcb             mov cx, bx
  00FBAB  8bde             mov bx, si
  00FBAD  c1e303           shl bx, 3
  00FBB0  c47ea6           les di, ptr [bp - 0x5a]
  00FBB3  268901           mov word ptr es:[bx + di], ax
  00FBB6  26895102         mov word ptr es:[bx + di + 2], dx
  00FBBA  8bc3             mov ax, bx
  00FBBC  c45e96           les bx, ptr [bp - 0x6a]
  00FBBF  03d9             add bx, cx
  00FBC1  8bc8             mov cx, ax
  00FBC3  268b4704         mov ax, word ptr es:[bx + 4]
  00FBC7  268b5706         mov dx, word ptr es:[bx + 6]
  00FBCB  c45ea6           les bx, ptr [bp - 0x5a]
  00FBCE  03d9             add bx, cx
  00FBD0  26894704         mov word ptr es:[bx + 4], ax
  00FBD4  26895706         mov word ptr es:[bx + 6], dx
  00FBD8  3b96f0fd         cmp dx, word ptr [bp - 0x210]
  00FBDC  7f10             jg 0xfbee
  00FBDE  7c06             jl 0xfbe6
  00FBE0  3b86eefd         cmp ax, word ptr [bp - 0x212]
  00FBE4  7308             jae 0xfbee
  00FBE6  8b96f0fd         mov dx, word ptr [bp - 0x210]
  00FBEA  8b86eefd         mov ax, word ptr [bp - 0x212]
  00FBEE  8986eefd         mov word ptr [bp - 0x212], ax
  00FBF2  8996f0fd         mov word ptr [bp - 0x210], dx
  00FBF6  46               inc si
  00FBF7  c45e9a           les bx, ptr [bp - 0x66]
  00FBFA  26397704         cmp word ptr es:[bx + 4], si
  00FBFE  7f9a             jg 0xfb9a
  00FC00  f686d6fd02       test byte ptr [bp - 0x22a], 2
  00FC05  7403             je 0xfc0a
  00FC07  e98400           jmp 0xfc8e
  00FC0A  8b86dcfe         mov ax, word ptr [bp - 0x124]
  00FC0E  0b86dafe         or ax, word ptr [bp - 0x126]
  00FC12  740d             je 0xfc21
  00FC14  ffb6dcfe         push word ptr [bp - 0x124]
  00FC18  ffb6dafe         push word ptr [bp - 0x126]
  00FC1C  9a1003c90c       lcall 0xcc9, 0x310
  00FC21  2bc0             sub ax, ax
  00FC23  8986dcfe         mov word ptr [bp - 0x124], ax
  00FC27  8986dafe         mov word ptr [bp - 0x126], ax
  00FC2B  8b4698           mov ax, word ptr [bp - 0x68]
  00FC2E  0b4696           or ax, word ptr [bp - 0x6a]
  00FC31  740b             je 0xfc3e
  00FC33  ff7698           push word ptr [bp - 0x68]
  00FC36  ff7696           push word ptr [bp - 0x6a]
  00FC39  9a1003c90c       lcall 0xcc9, 0x310
  00FC3E  2bc0             sub ax, ax
  00FC40  894698           mov word ptr [bp - 0x68], ax
  00FC43  894696           mov word ptr [bp - 0x6a], ax
  00FC46  1e               push ds
  00FC47  68d53a           push 0x3ad5
  00FC4A  8b86eefd         mov ax, word ptr [bp - 0x212]
  00FC4E  8b96f0fd         mov dx, word ptr [bp - 0x210]
  00FC52  9a3601c90c       lcall 0xcc9, 0x136
  00FC57  c45e9a           les bx, ptr [bp - 0x66]
  00FC5A  2689473a         mov word ptr es:[bx + 0x3a], ax
  00FC5E  2689573c         mov word ptr es:[bx + 0x3c], dx
  00FC62  8bc2             mov ax, dx
  00FC64  260b473a         or ax, word ptr es:[bx + 0x3a]
  00FC68  743f             je 0xfca9
  00FC6A  6a04             push 4
  00FC6C  8d86eefd         lea ax, [bp - 0x212]
  00FC70  16               push ss
  00FC71  50               push ax
  00FC72  8b469a           mov ax, word ptr [bp - 0x66]
  00FC75  8b569c           mov dx, word ptr [bp - 0x64]
  00FC78  050800           add ax, 8
  00FC7B  52               push dx
  00FC7C  50               push ax
  00FC7D  9a4a0c8813       lcall 0x1388, 0xc4a
  00FC82  83c40a           add sp, 0xa
  00FC85  c7860cfe0000     mov word ptr [bp - 0x1f4], 0
  00FC8B  eb0e             jmp 0xfc9b
  00FC8D  90               nop
  00FC8E  c45e9a           les bx, ptr [bp - 0x66]
  00FC91  2bc0             sub ax, ax
  00FC93  2689473c         mov word ptr es:[bx + 0x3c], ax
  00FC97  2689473a         mov word ptr es:[bx + 0x3a], ax
  00FC9B  8b469a           mov ax, word ptr [bp - 0x66]
  00FC9E  8b569c           mov dx, word ptr [bp - 0x64]
  00FCA1  8986e4fd         mov word ptr [bp - 0x21c], ax
  00FCA5  8996e6fd         mov word ptr [bp - 0x21a], dx
  00FCA9  83be0cfe00       cmp word ptr [bp - 0x1f4], 0
  00FCAE  740b             je 0xfcbb
  00FCB0  8d860cfe         lea ax, [bp - 0x1f4]
  00FCB4  16               push ss
  00FCB5  50               push ax
  00FCB6  9a4e031a12       lcall 0x121a, 0x34e
  00FCBB  8b86dcfe         mov ax, word ptr [bp - 0x124]
  00FCBF  0b86dafe         or ax, word ptr [bp - 0x126]
  00FCC3  740d             je 0xfcd2
  00FCC5  ffb6dcfe         push word ptr [bp - 0x124]
  00FCC9  ffb6dafe         push word ptr [bp - 0x126]
  00FCCD  9a1003c90c       lcall 0xcc9, 0x310
  00FCD2  8b4698           mov ax, word ptr [bp - 0x68]
  00FCD5  0b4696           or ax, word ptr [bp - 0x6a]
  00FCD8  740b             je 0xfce5
  00FCDA  ff7698           push word ptr [bp - 0x68]
  00FCDD  ff7696           push word ptr [bp - 0x6a]
  00FCE0  9a1003c90c       lcall 0xcc9, 0x310
  00FCE5  8b469c           mov ax, word ptr [bp - 0x64]
  00FCE8  0b469a           or ax, word ptr [bp - 0x66]
  00FCEB  7423             je 0xfd10
  00FCED  8b469a           mov ax, word ptr [bp - 0x66]
  00FCF0  8b569c           mov dx, word ptr [bp - 0x64]
  00FCF3  3906e43a         cmp word ptr [0x3ae4], ax
  00FCF7  7506             jne 0xfcff
  00FCF9  3916e63a         cmp word ptr [0x3ae6], dx
  00FCFD  7411             je 0xfd10
  00FCFF  8b8ee6fd         mov cx, word ptr [bp - 0x21a]
  00FD03  0b8ee4fd         or cx, word ptr [bp - 0x21c]
  00FD07  7507             jne 0xfd10
  00FD09  52               push dx
  00FD0A  50               push ax
  00FD0B  9a1003c90c       lcall 0xcc9, 0x310
  00FD10  8b86e4fd         mov ax, word ptr [bp - 0x21c]
  00FD14  8b96e6fd         mov dx, word ptr [bp - 0x21a]
  00FD18  5e               pop si
  00FD19  5f               pop di
  00FD1A  c9               leave
  00FD1B  cb               retf
