; MAPEDIT.EXE named disasm — module sprite_m.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sprite_draw_scaled_black  file 0x00FF2A..0x01020A  seg 0xE92:0xa  (sprite_m.c.obj) ----
  00FF2A  c86e0100         enter 0x16e, 0
  00FF2E  52               push dx
  00FF2F  53               push bx
  00FF30  50               push ax
  00FF31  57               push di
  00FF32  56               push si
  00FF33  8b4702           mov ax, word ptr [bx + 2]
  00FF36  48               dec ax
  00FF37  89869efe         mov word ptr [bp - 0x162], ax
  00FF3B  8b07             mov ax, word ptr [bx]
  00FF3D  48               dec ax
  00FF3E  898694fe         mov word ptr [bp - 0x16c], ax
  00FF42  ba0100           mov dx, 1
  00FF45  8b868cfe         mov ax, word ptr [bp - 0x174]
  00FF49  0bc0             or ax, ax
  00FF4B  7903             jns 0xff50
  00FF4D  baffff           mov dx, 0xffff
  00FF50  8956f0           mov word ptr [bp - 0x10], dx
  00FF53  25ff7f           and ax, 0x7fff
  00FF56  89868cfe         mov word ptr [bp - 0x174], ax
  00FF5A  8b9e8cfe         mov bx, word ptr [bp - 0x174]
  00FF5E  8bc3             mov ax, bx
  00FF60  d1e3             shl bx, 1
  00FF62  03d8             add bx, ax
  00FF64  c1e302           shl bx, 2
  00FF67  035e0a           add bx, word ptr [bp + 0xa]
  00FF6A  8e460c           mov es, word ptr [bp + 0xc]
  00FF6D  83c336           add bx, 0x36
  00FF70  895ef2           mov word ptr [bp - 0xe], bx
  00FF73  8c46f4           mov word ptr [bp - 0xc], es
  00FF76  268b07           mov ax, word ptr es:[bx]
  00FF79  268b5702         mov dx, word ptr es:[bx + 2]
  00FF7D  8986a4fe         mov word ptr [bp - 0x15c], ax
  00FF81  8996a6fe         mov word ptr [bp - 0x15a], dx
  00FF85  8bb68efe         mov si, word ptr [bp - 0x172]
  00FF89  8b4404           mov ax, word ptr [si + 4]
  00FF8C  8b5406           mov dx, word ptr [si + 6]
  00FF8F  8986a8fe         mov word ptr [bp - 0x158], ax
  00FF93  8996aafe         mov word ptr [bp - 0x156], dx
  00FF97  8b4402           mov ax, word ptr [si + 2]
  00FF9A  8946fe           mov word ptr [bp - 2], ax
  00FF9D  268b4708         mov ax, word ptr es:[bx + 8]
  00FFA1  8986a2fe         mov word ptr [bp - 0x15e], ax
  00FFA5  268b4f0a         mov cx, word ptr es:[bx + 0xa]
  00FFA9  898e9cfe         mov word ptr [bp - 0x164], cx
  00FFAD  3bc1             cmp ax, cx
  00FFAF  7d02             jge 0xffb3
  00FFB1  8bc1             mov ax, cx
  00FFB3  89869afe         mov word ptr [bp - 0x166], ax
  00FFB7  1e               push ds
  00FFB8  33ff             xor di, di
  00FFBA  8b7606           mov si, word ptr [bp + 6]
  00FFBD  33c0             xor ax, ax
  00FFBF  8946ee           mov word ptr [bp - 0x12], ax
  00FFC2  8986acfe         mov word ptr [bp - 0x154], ax
  00FFC6  b83200           mov ax, 0x32
  00FFC9  8b9ea2fe         mov bx, word ptr [bp - 0x15e]
  00FFCD  8b969cfe         mov dx, word ptr [bp - 0x164]
  00FFD1  03c6             add ax, si
  00FFD3  3d6400           cmp ax, 0x64
  00FFD6  7c1a             jl 0xfff2
  00FFD8  c683aefeff       mov byte ptr [bp + di - 0x152], 0xff
  00FFDD  2d6400           sub ax, 0x64
  00FFE0  3bfb             cmp di, bx
  00FFE2  7d03             jge 0xffe7
  00FFE4  ff46ee           inc word ptr [bp - 0x12]
  00FFE7  3bfa             cmp di, dx
  00FFE9  7d0c             jge 0xfff7
  00FFEB  ff86acfe         inc word ptr [bp - 0x154]
  00FFEF  eb06             jmp 0xfff7
  00FFF1  90               nop
  00FFF2  c683aefe00       mov byte ptr [bp + di - 0x152], 0
  00FFF7  47               inc di
  00FFF8  3bbe9afe         cmp di, word ptr [bp - 0x166]
  00FFFC  7cd3             jl 0xffd1
  00FFFE  8b46ee           mov ax, word ptr [bp - 0x12]
  010001  d1e8             shr ax, 1
  010003  298690fe         sub word ptr [bp - 0x170], ax
  010007  8b86acfe         mov ax, word ptr [bp - 0x154]
  01000B  294608           sub word ptr [bp + 8], ax
  01000E  ff4608           inc word ptr [bp + 8]
  010011  8b5eee           mov bx, word ptr [bp - 0x12]
  010014  33c9             xor cx, cx
  010016  8b8690fe         mov ax, word ptr [bp - 0x170]
  01001A  8bd0             mov dx, ax
  01001C  03d3             add dx, bx
  01001E  4a               dec dx
  01001F  0bc0             or ax, ax
  010021  7d04             jge 0x10027
  010023  03d8             add bx, ax
  010025  2bc8             sub cx, ax
  010027  2b969efe         sub dx, word ptr [bp - 0x162]
  01002B  7e02             jle 0x1002f
  01002D  2bda             sub bx, dx
  01002F  898e98fe         mov word ptr [bp - 0x168], cx
  010033  895efa           mov word ptr [bp - 6], bx
  010036  03cb             add cx, bx
  010038  898ea0fe         mov word ptr [bp - 0x160], cx
  01003C  0bdb             or bx, bx
  01003E  7f04             jg 0x10044
  010040  e9bf01           jmp 0x10202
  010043  90               nop
  010044  837ef001         cmp word ptr [bp - 0x10], 1
  010048  741b             je 0x10065
  01004A  8b7eee           mov di, word ptr [bp - 0x12]
  01004D  03c7             add ax, di
  01004F  48               dec ax
  010050  898690fe         mov word ptr [bp - 0x170], ax
  010054  2bf9             sub di, cx
  010056  f7df             neg di
  010058  89be98fe         mov word ptr [bp - 0x168], di
  01005C  f7df             neg di
  01005E  037efa           add di, word ptr [bp - 6]
  010061  89bea0fe         mov word ptr [bp - 0x160], di
  010065  8b9eacfe         mov bx, word ptr [bp - 0x154]
  010069  33c9             xor cx, cx
  01006B  8b4608           mov ax, word ptr [bp + 8]
  01006E  8bd0             mov dx, ax
  010070  03d3             add dx, bx
  010072  4a               dec dx
  010073  0bc0             or ax, ax
  010075  7d04             jge 0x1007b
  010077  03d8             add bx, ax
  010079  2bc8             sub cx, ax
  01007B  2b9694fe         sub dx, word ptr [bp - 0x16c]
  01007F  7e02             jle 0x10083
  010081  2bda             sub bx, dx
  010083  898e92fe         mov word ptr [bp - 0x16e], cx
  010087  895ef6           mov word ptr [bp - 0xa], bx
  01008A  51               push cx
  01008B  03cb             add cx, bx
  01008D  898e96fe         mov word ptr [bp - 0x16a], cx
  010091  59               pop cx
  010092  0bdb             or bx, bx
  010094  7f04             jg 0x1009a
  010096  e96901           jmp 0x10202
  010099  90               nop
  01009A  c49ea8fe         les bx, ptr [bp - 0x158]
  01009E  8cc2             mov dx, es
  0100A0  8b7efe           mov di, word ptr [bp - 2]
  0100A3  03c8             add cx, ax
  0100A5  740e             je 0x100b5
  0100A7  03df             add bx, di
  0100A9  7908             jns 0x100b3
  0100AB  81eb0070         sub bx, 0x7000
  0100AF  81c20007         add dx, 0x700
  0100B3  e2f2             loop 0x100a7
  0100B5  039e90fe         add bx, word ptr [bp - 0x170]
  0100B9  039e98fe         add bx, word ptr [bp - 0x168]
  0100BD  8ec2             mov es, dx
  0100BF  c5b6a4fe         lds si, ptr [bp - 0x15c]
  0100C3  8b8698fe         mov ax, word ptr [bp - 0x168]
  0100C7  f76ef0           imul word ptr [bp - 0x10]
  0100CA  898698fe         mov word ptr [bp - 0x168], ax
  0100CE  bfffff           mov di, 0xffff
  0100D1  baffff           mov dx, 0xffff
  0100D4  c746fc0000       mov word ptr [bp - 4], 0
  0100D9  47               inc di
  0100DA  3bbe9cfe         cmp di, word ptr [bp - 0x164]
  0100DE  7c04             jl 0x100e4
  0100E0  e91f01           jmp 0x10202
  0100E3  90               nop
  0100E4  8a83aefe         mov al, byte ptr [bp + di - 0x152]
  0100E8  0ac0             or al, al
  0100EA  7504             jne 0x100f0
  0100EC  e90401           jmp 0x101f3
  0100EF  90               nop
  0100F0  42               inc dx
  0100F1  3b9696fe         cmp dx, word ptr [bp - 0x16a]
  0100F5  7c03             jl 0x100fa
  0100F7  e90801           jmp 0x10202
  0100FA  3b9692fe         cmp dx, word ptr [bp - 0x16e]
  0100FE  7d04             jge 0x10104
  010100  e9f000           jmp 0x101f3
  010103  90               nop
  010104  57               push di
  010105  33ff             xor di, di
  010107  53               push bx
  010108  52               push dx
  010109  33d2             xor dx, dx
  01010B  ac               lodsb al, byte ptr [si]
  01010C  3cff             cmp al, 0xff
  01010E  7406             je 0x10116
  010110  3cfd             cmp al, 0xfd
  010112  740a             je 0x1011e
  010114  eb54             jmp 0x1016a
  010116  c746fcffff       mov word ptr [bp - 4], 0xffff
  01011B  e9c200           jmp 0x101e0
  01011E  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  010122  7c04             jl 0x10128
  010124  e9b900           jmp 0x101e0
  010127  90               nop
  010128  ac               lodsb al, byte ptr [si]
  010129  3cff             cmp al, 0xff
  01012B  7509             jne 0x10136
  01012D  c746fcffff       mov word ptr [bp - 4], 0xffff
  010132  e9ab00           jmp 0x101e0
  010135  90               nop
  010136  8ae0             mov ah, al
  010138  ac               lodsb al, byte ptr [si]
  010139  8a8baefe         mov cl, byte ptr [bp + di - 0x152]
  01013D  0ac9             or cl, cl
  01013F  7503             jne 0x10144
  010141  eb1e             jmp 0x10161
  010143  90               nop
  010144  3b9698fe         cmp dx, word ptr [bp - 0x168]
  010148  7c16             jl 0x10160
  01014A  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  01014E  7d10             jge 0x10160
  010150  3cfd             cmp al, 0xfd
  010152  7409             je 0x1015d
  010154  26803f00         cmp byte ptr es:[bx], 0
  010158  7503             jne 0x1015d
  01015A  268807           mov byte ptr es:[bx], al
  01015D  035ef0           add bx, word ptr [bp - 0x10]
  010160  42               inc dx
  010161  47               inc di
  010162  fecc             dec ah
  010164  7402             je 0x10168
  010166  ebd1             jmp 0x10139
  010168  ebb4             jmp 0x1011e
  01016A  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  01016E  7c02             jl 0x10172
  010170  eb6e             jmp 0x101e0
  010172  ac               lodsb al, byte ptr [si]
  010173  3cff             cmp al, 0xff
  010175  7407             je 0x1017e
  010177  3cfe             cmp al, 0xfe
  010179  7405             je 0x10180
  01017B  eb39             jmp 0x101b6
  01017D  90               nop
  01017E  ebad             jmp 0x1012d
  010180  ac               lodsb al, byte ptr [si]
  010181  8ae0             mov ah, al
  010183  ac               lodsb al, byte ptr [si]
  010184  8a8baefe         mov cl, byte ptr [bp + di - 0x152]
  010188  0ac9             or cl, cl
  01018A  7502             jne 0x1018e
  01018C  eb1d             jmp 0x101ab
  01018E  3b9698fe         cmp dx, word ptr [bp - 0x168]
  010192  7c16             jl 0x101aa
  010194  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  010198  7d10             jge 0x101aa
  01019A  3cfd             cmp al, 0xfd
  01019C  7409             je 0x101a7
  01019E  26803f00         cmp byte ptr es:[bx], 0
  0101A2  7503             jne 0x101a7
  0101A4  268807           mov byte ptr es:[bx], al
  0101A7  035ef0           add bx, word ptr [bp - 0x10]
  0101AA  42               inc dx
  0101AB  47               inc di
  0101AC  fecc             dec ah
  0101AE  7402             je 0x101b2
  0101B0  ebd2             jmp 0x10184
  0101B2  ebb6             jmp 0x1016a
  0101B4  eb26             jmp 0x101dc
  0101B6  8a8baefe         mov cl, byte ptr [bp + di - 0x152]
  0101BA  0ac9             or cl, cl
  0101BC  7502             jne 0x101c0
  0101BE  eb1d             jmp 0x101dd
  0101C0  3b9698fe         cmp dx, word ptr [bp - 0x168]
  0101C4  7c16             jl 0x101dc
  0101C6  3b96a0fe         cmp dx, word ptr [bp - 0x160]
  0101CA  7d10             jge 0x101dc
  0101CC  3cfd             cmp al, 0xfd
  0101CE  7409             je 0x101d9
  0101D0  26803f00         cmp byte ptr es:[bx], 0
  0101D4  7503             jne 0x101d9
  0101D6  268807           mov byte ptr es:[bx], al
  0101D9  035ef0           add bx, word ptr [bp - 0x10]
  0101DC  42               inc dx
  0101DD  47               inc di
  0101DE  eb8a             jmp 0x1016a
  0101E0  5a               pop dx
  0101E1  5b               pop bx
  0101E2  5f               pop di
  0101E3  035efe           add bx, word ptr [bp - 2]
  0101E6  790b             jns 0x101f3
  0101E8  81eb0070         sub bx, 0x7000
  0101EC  8cc0             mov ax, es
  0101EE  050007           add ax, 0x700
  0101F1  8ec0             mov es, ax
  0101F3  837efcff         cmp word ptr [bp - 4], -1
  0101F7  7405             je 0x101fe
  0101F9  ac               lodsb al, byte ptr [si]
  0101FA  3cff             cmp al, 0xff
  0101FC  75fb             jne 0x101f9
  0101FE  e9d3fe           jmp 0x100d4
  010201  90               nop
  010202  1f               pop ds
  010203  5e               pop si
  010204  5f               pop di
  010205  c9               leave
  010206  ca0800           retf 8
  010209  90               nop
