; MAPEDIT.EXE named disasm — module error_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @error_dump_file  file 0x0103AC..0x0106D6  seg 0xED0:0xac  (error_1.c.obj) ----
  0103AC  c8580000         enter 0x58, 0
  0103B0  53               push bx
  0103B1  56               push si
  0103B2  c746aeffff       mov word ptr [bp - 0x52], 0xffff
  0103B7  1e               push ds
  0103B8  53               push bx
  0103B9  8d1e823b         lea bx, [0x3b82]
  0103BD  9a04019702       lcall 0x297, 0x104
  0103C2  8946a8           mov word ptr [bp - 0x58], ax
  0103C5  0bc0             or ax, ax
  0103C7  7478             je 0x10441
  0103C9  c746acffff       mov word ptr [bp - 0x54], 0xffff
  0103CE  8b5ea8           mov bx, word ptr [bp - 0x58]
  0103D1  f6470610         test byte ptr [bx + 6], 0x10
  0103D5  756a             jne 0x10441
  0103D7  53               push bx
  0103D8  6a4f             push 0x4f
  0103DA  8d46b0           lea ax, [bp - 0x50]
  0103DD  50               push ax
  0103DE  9a8a078813       lcall 0x1388, 0x78a
  0103E3  83c406           add sp, 6
  0103E6  0bc0             or ax, ax
  0103E8  7457             je 0x10441
  0103EA  c746aa0000       mov word ptr [bp - 0x56], 0
  0103EF  eb11             jmp 0x10402
  0103F1  90               nop
  0103F2  8b76aa           mov si, word ptr [bp - 0x56]
  0103F5  807ab020         cmp byte ptr [bp + si - 0x50], 0x20
  0103F9  7d04             jge 0x103ff
  0103FB  c642b000         mov byte ptr [bp + si - 0x50], 0
  0103FF  ff46aa           inc word ptr [bp - 0x56]
  010402  8d46b0           lea ax, [bp - 0x50]
  010405  50               push ax
  010406  9a84068813       lcall 0x1388, 0x684
  01040B  83c402           add sp, 2
  01040E  3b46aa           cmp ax, word ptr [bp - 0x56]
  010411  7fdf             jg 0x103f2
  010413  6a03             push 3
  010415  68853b           push 0x3b85
  010418  8d46b0           lea ax, [bp - 0x50]
  01041B  50               push ax
  01041C  9afe068813       lcall 0x1388, 0x6fe
  010421  83c406           add sp, 6
  010424  0bc0             or ax, ax
  010426  7506             jne 0x1042e
  010428  8946ac           mov word ptr [bp - 0x54], ax
  01042B  eb0e             jmp 0x1043b
  01042D  90               nop
  01042E  8d46b0           lea ax, [bp - 0x50]
  010431  16               push ss
  010432  50               push ax
  010433  b8ffff           mov ax, 0xffff
  010436  9a00007b12       lcall 0x127b, 0
  01043B  837eac00         cmp word ptr [bp - 0x54], 0
  01043F  758d             jne 0x103ce
  010441  837ea800         cmp word ptr [bp - 0x58], 0
  010445  740b             je 0x10452
  010447  ff76a8           push word ptr [bp - 0x58]
  01044A  9ac2028813       lcall 0x1388, 0x2c2
  01044F  83c402           add sp, 2
  010452  5e               pop si
  010453  c9               leave
  010454  cb               retf
  010455  90               nop
  010456  c8580000         enter 0x58, 0
  01045A  52               push dx
  01045B  50               push ax
  01045C  53               push bx
  01045D  9a19011511       lcall 0x1115, 0x119
  010462  0bc0             or ax, ax
  010464  740f             je 0x10475
  010466  6a00             push 0
  010468  9a04002711       lcall 0x1127, 4
  01046D  83c402           add sp, 2
  010470  9a59002711       lcall 0x1127, 0x59
  010475  9af3011c0d       lcall 0xd1c, 0x1f3
  01047A  9ac701fe0f       lcall 0xffe, 0x1c7
  01047F  9a0c003e0f       lcall 0xf3e, 0xc
  010484  6a03             push 3
  010486  6a00             push 0
  010488  9a8600650f       lcall 0xf65, 0x86
  01048D  83c404           add sp, 4
  010490  b80300           mov ax, 3
  010493  9a0a003c0c       lcall 0xc3c, 0xa
  010498  b80300           mov ax, 3
  01049B  cd10             int 0x10
  01049D  837e04ec         cmp word ptr [bp + 4], -0x14
  0104A1  7503             jne 0x104a6
  0104A3  e90202           jmp 0x106a8
  0104A6  68893b           push 0x3b89
  0104A9  8d46b0           lea ax, [bp - 0x50]
  0104AC  50               push ax
  0104AD  9a26068813       lcall 0x1388, 0x626
  0104B2  83c404           add sp, 4
  0104B5  ff76a2           push word ptr [bp - 0x5e]
  0104B8  8d46b0           lea ax, [bp - 0x50]
  0104BB  50               push ax
  0104BC  9ae6058813       lcall 0x1388, 0x5e6
  0104C1  83c404           add sp, 4
  0104C4  68913b           push 0x3b91
  0104C7  8d46b0           lea ax, [bp - 0x50]
  0104CA  50               push ax
  0104CB  9ae6058813       lcall 0x1388, 0x5e6
  0104D0  83c404           add sp, 4
  0104D3  ff76a4           push word ptr [bp - 0x5c]
  0104D6  8d46b0           lea ax, [bp - 0x50]
  0104D9  50               push ax
  0104DA  9ae6058813       lcall 0x1388, 0x5e6
  0104DF  83c404           add sp, 4
  0104E2  689f3b           push 0x3b9f
  0104E5  8d46b0           lea ax, [bp - 0x50]
  0104E8  50               push ax
  0104E9  9ae6058813       lcall 0x1388, 0x5e6
  0104EE  83c404           add sp, 4
  0104F1  ff76a6           push word ptr [bp - 0x5a]
  0104F4  8d46b0           lea ax, [bp - 0x50]
  0104F7  50               push ax
  0104F8  9ae6058813       lcall 0x1388, 0x5e6
  0104FD  83c404           add sp, 4
  010500  68a83b           push 0x3ba8
  010503  8d46b0           lea ax, [bp - 0x50]
  010506  50               push ax
  010507  9ae6058813       lcall 0x1388, 0x5e6
  01050C  83c404           add sp, 4
  01050F  ff760a           push word ptr [bp + 0xa]
  010512  8d46b0           lea ax, [bp - 0x50]
  010515  50               push ax
  010516  9ae6058813       lcall 0x1388, 0x5e6
  01051B  83c404           add sp, 4
  01051E  8d46b0           lea ax, [bp - 0x50]
  010521  16               push ss
  010522  50               push ax
  010523  b8ffff           mov ax, 0xffff
  010526  9a00007b12       lcall 0x127b, 0
  01052B  68323b           push 0x3b32
  01052E  9a84068813       lcall 0x1388, 0x684
  010533  83c402           add sp, 2
  010536  0bc0             or ax, ax
  010538  740c             je 0x10546
  01053A  1e               push ds
  01053B  68323b           push 0x3b32
  01053E  b8ffff           mov ax, 0xffff
  010541  9a00007b12       lcall 0x127b, 0
  010546  803e4b0700       cmp byte ptr [0x74b], 0
  01054B  7503             jne 0x10550
  01054D  e98200           jmp 0x105d2
  010550  6a0a             push 0xa
  010552  ff76a6           push word ptr [bp - 0x5a]
  010555  ff365007         push word ptr [0x750]
  010559  ff364e07         push word ptr [0x74e]
  01055D  9a58078813       lcall 0x1388, 0x758
  010562  83c408           add sp, 8
  010565  6a0a             push 0xa
  010567  ff760a           push word ptr [bp + 0xa]
  01056A  ff365407         push word ptr [0x754]
  01056E  ff365207         push word ptr [0x752]
  010572  9a58078813       lcall 0x1388, 0x758
  010577  83c408           add sp, 8
  01057A  68aa3b           push 0x3baa
  01057D  8d46b0           lea ax, [bp - 0x50]
  010580  50               push ax
  010581  9a26068813       lcall 0x1388, 0x626
  010586  83c404           add sp, 4
  010589  ff76a6           push word ptr [bp - 0x5a]
  01058C  8d46b0           lea ax, [bp - 0x50]
  01058F  50               push ax
  010590  9ae6058813       lcall 0x1388, 0x5e6
  010595  83c404           add sp, 4
  010598  68bd3b           push 0x3bbd
  01059B  8d46b0           lea ax, [bp - 0x50]
  01059E  50               push ax
  01059F  9ae6058813       lcall 0x1388, 0x5e6
  0105A4  83c404           add sp, 4
  0105A7  ff760a           push word ptr [bp + 0xa]
  0105AA  8d46b0           lea ax, [bp - 0x50]
  0105AD  50               push ax
  0105AE  9ae6058813       lcall 0x1388, 0x5e6
  0105B3  83c404           add sp, 4
  0105B6  68cf3b           push 0x3bcf
  0105B9  8d46b0           lea ax, [bp - 0x50]
  0105BC  50               push ax
  0105BD  9ae6058813       lcall 0x1388, 0x5e6
  0105C2  83c404           add sp, 4
  0105C5  8d46b0           lea ax, [bp - 0x50]
  0105C8  16               push ss
  0105C9  50               push ax
  0105CA  b8ffff           mov ax, 0xffff
  0105CD  9a00007b12       lcall 0x127b, 0
  0105D2  1e               push ds
  0105D3  68e13b           push 0x3be1
  0105D6  b8ffff           mov ax, 0xffff
  0105D9  9a00007b12       lcall 0x127b, 0
  0105DE  68e33b           push 0x3be3
  0105E1  8d46b0           lea ax, [bp - 0x50]
  0105E4  50               push ax
  0105E5  9a26068813       lcall 0x1388, 0x626
  0105EA  83c404           add sp, 4
  0105ED  6a0a             push 0xa
  0105EF  ff76a6           push word ptr [bp - 0x5a]
  0105F2  ff7608           push word ptr [bp + 8]
  0105F5  ff7606           push word ptr [bp + 6]
  0105F8  9a58078813       lcall 0x1388, 0x758
  0105FD  83c408           add sp, 8
  010600  ff76a6           push word ptr [bp - 0x5a]
  010603  8d46b0           lea ax, [bp - 0x50]
  010606  50               push ax
  010607  9ae6058813       lcall 0x1388, 0x5e6
  01060C  83c404           add sp, 4
  01060F  8d46b0           lea ax, [bp - 0x50]
  010612  16               push ss
  010613  50               push ax
  010614  b8ffff           mov ax, 0xffff
  010617  9a00007b12       lcall 0x127b, 0
  01061C  68fe3b           push 0x3bfe
  01061F  8d46b0           lea ax, [bp - 0x50]
  010622  50               push ax
  010623  9a26068813       lcall 0x1388, 0x626
  010628  83c404           add sp, 4
  01062B  6a0a             push 0xa
  01062D  ff76a6           push word ptr [bp - 0x5a]
  010630  ff366845         push word ptr [0x4568]
  010634  9a3c078813       lcall 0x1388, 0x73c
  010639  83c406           add sp, 6
  01063C  ff76a6           push word ptr [bp - 0x5a]
  01063F  8d46b0           lea ax, [bp - 0x50]
  010642  50               push ax
  010643  9ae6058813       lcall 0x1388, 0x5e6
  010648  83c404           add sp, 4
  01064B  8d46b0           lea ax, [bp - 0x50]
  01064E  16               push ss
  01064F  50               push ax
  010650  b8ffff           mov ax, 0xffff
  010653  9a00007b12       lcall 0x127b, 0
  010658  68193c           push 0x3c19
  01065B  8d46b0           lea ax, [bp - 0x50]
  01065E  50               push ax
  01065F  9a26068813       lcall 0x1388, 0x626
  010664  83c404           add sp, 4
  010667  6a0a             push 0xa
  010669  ff76a6           push word ptr [bp - 0x5a]
  01066C  9a1b00aa12       lcall 0x12aa, 0x1b
  010671  50               push ax
  010672  9a3c078813       lcall 0x1388, 0x73c
  010677  83c406           add sp, 6
  01067A  ff76a6           push word ptr [bp - 0x5a]
  01067D  8d46b0           lea ax, [bp - 0x50]
  010680  50               push ax
  010681  9ae6058813       lcall 0x1388, 0x5e6
  010686  83c404           add sp, 4
  010689  8d46b0           lea ax, [bp - 0x50]
  01068C  16               push ss
  01068D  50               push ax
  01068E  b8ffff           mov ax, 0xffff
  010691  9a00007b12       lcall 0x127b, 0
  010696  1e               push ds
  010697  68343c           push 0x3c34
  01069A  b8ffff           mov ax, 0xffff
  01069D  9a00007b12       lcall 0x127b, 0
  0106A2  8d1e363c         lea bx, [0x3c36]
  0106A6  eb04             jmp 0x106ac
  0106A8  8d1e413c         lea bx, [0x3c41]
  0106AC  0e               push cs
  0106AD  e8fcfc           call 0x103ac
  0106B0  a12e3b           mov ax, word ptr [0x3b2e]
  0106B3  0b062c3b         or ax, word ptr [0x3b2c]
  0106B7  7404             je 0x106bd
  0106B9  ff1e2c3b         lcall [0x3b2c]
  0106BD  a12a3b           mov ax, word ptr [0x3b2a]
  0106C0  0b06283b         or ax, word ptr [0x3b28]
  0106C4  7404             je 0x106ca
  0106C6  ff1e283b         lcall [0x3b28]
  0106CA  6a03             push 3
  0106CC  9adb018813       lcall 0x1388, 0x1db
  0106D1  c9               leave
  0106D2  c20800           ret 8
  0106D5  90               nop

; ---- @error_report  file 0x0106D6..0x01076E  seg 0xED0:0x3d6  (error_1.c.obj) ----
  0106D6  c86a0000         enter 0x6a, 0
  0106DA  53               push bx
  0106DB  52               push dx
  0106DC  50               push ax
  0106DD  57               push di
  0106DE  56               push si
  0106DF  8bfb             mov di, bx
  0106E1  8bf0             mov si, ax
  0106E3  c746fe0000       mov word ptr [bp - 2], 0
  0106E8  a1303b           mov ax, word ptr [0x3b30]
  0106EB  3bd0             cmp dx, ax
  0106ED  7c79             jl 0x10768
  0106EF  6a0a             push 0xa
  0106F1  8d46be           lea ax, [bp - 0x42]
  0106F4  50               push ax
  0106F5  56               push si
  0106F6  9a3c078813       lcall 0x1388, 0x73c
  0106FB  83c406           add sp, 6
  0106FE  6a0a             push 0xa
  010700  8d4696           lea ax, [bp - 0x6a]
  010703  50               push ax
  010704  57               push di
  010705  9a3c078813       lcall 0x1388, 0x73c
  01070A  83c406           add sp, 6
  01070D  6a0a             push 0xa
  01070F  8d46f2           lea ax, [bp - 0xe]
  010712  50               push ax
  010713  ff760c           push word ptr [bp + 0xc]
  010716  ff760a           push word ptr [bp + 0xa]
  010719  9a58078813       lcall 0x1388, 0x758
  01071E  83c408           add sp, 8
  010721  6a0a             push 0xa
  010723  8d46e6           lea ax, [bp - 0x1a]
  010726  50               push ax
  010727  ff7608           push word ptr [bp + 8]
  01072A  ff7606           push word ptr [bp + 6]
  01072D  9a58078813       lcall 0x1388, 0x758
  010732  83c408           add sp, 8
  010735  8bd6             mov dx, si
  010737  f7d2             not dx
  010739  42               inc dx
  01073A  8d5ebe           lea bx, [bp - 0x42]
  01073D  8d064c3c         lea ax, [0x3c4c]
  010741  e8c4fb           call 0x10308
  010744  8bd7             mov dx, di
  010746  8d5e96           lea bx, [bp - 0x6a]
  010749  8d06573c         lea ax, [0x3c57]
  01074D  e8b8fb           call 0x10308
  010750  8d46e6           lea ax, [bp - 0x1a]
  010753  50               push ax
  010754  9a8200080d       lcall 0xd08, 0x82
  010759  52               push dx
  01075A  50               push ax
  01075B  56               push si
  01075C  8d5ebe           lea bx, [bp - 0x42]
  01075F  8d4696           lea ax, [bp - 0x6a]
  010762  8d56f2           lea dx, [bp - 0xe]
  010765  e8eefc           call 0x10456
  010768  5e               pop si
  010769  5f               pop di
  01076A  c9               leave
  01076B  ca0800           retf 8
