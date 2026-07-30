; MAPEDIT.EXE named disasm — module pfabexp0.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PFABEXP0  file 0x013070..0x01322D  seg 0x11A7:0x0  (pfabexp0.ASM.obj) ----
  013070  c8000000         enter 0, 0
  013074  56               push si
  013075  57               push di
  013076  1e               push ds
  013077  c44606           les ax, ptr [bp + 6]
  01307A  050f00           add ax, 0xf
  01307D  c1e804           shr ax, 4
  013080  8cc2             mov dx, es
  013082  03d0             add dx, ax
  013084  750a             jne 0x13090
  013086  b82c38           mov ax, 0x382c
  013089  1f               pop ds
  01308A  5f               pop di
  01308B  5e               pop si
  01308C  c9               leave
  01308D  ca0c00           retf 0xc
  013090  55               push bp
  013091  1e               push ds
  013092  8eda             mov ds, dx
  013094  8f060200         pop word ptr [2]
  013098  8f060000         pop word ptr [0]
  01309C  c4460e           les ax, ptr [bp + 0xe]
  01309F  a30c00           mov word ptr [0xc], ax
  0130A2  8c060e00         mov word ptr [0xe], es
  0130A6  c4460a           les ax, ptr [bp + 0xa]
  0130A9  a31000           mov word ptr [0x10], ax
  0130AC  8c061200         mov word ptr [0x12], es
  0130B0  8d361c00         lea si, [0x1c]
  0130B4  81c60008         add si, 0x800
  0130B8  8d3e1c28         lea di, [0x281c]
  0130BC  8ec2             mov es, dx
  0130BE  33c0             xor ax, ax
  0130C0  a31600           mov word ptr [0x16], ax
  0130C3  a31800           mov word ptr [0x18], ax
  0130C6  81fe1b08         cmp si, 0x81b
  0130CA  7203             jb 0x130cf
  0130CC  e85e01           call 0x1322d
  0130CF  ad               lodsw ax, word ptr [si]
  0130D0  3d4641           cmp ax, 0x4146
  0130D3  755a             jne 0x1312f
  0130D5  81fe1b08         cmp si, 0x81b
  0130D9  7203             jb 0x130de
  0130DB  e84f01           call 0x1322d
  0130DE  ad               lodsw ax, word ptr [si]
  0130DF  3c42             cmp al, 0x42
  0130E1  754c             jne 0x1312f
  0130E3  80fc0a           cmp ah, 0xa
  0130E6  7247             jb 0x1312f
  0130E8  80fc0d           cmp ah, 0xd
  0130EB  7742             ja 0x1312f
  0130ED  b110             mov cl, 0x10
  0130EF  2acc             sub cl, ah
  0130F1  880e0400         mov byte ptr [4], cl
  0130F5  b001             mov al, 1
  0130F7  d2e0             shl al, cl
  0130F9  fec8             dec al
  0130FB  a20500           mov byte ptr [5], al
  0130FE  8acc             mov cl, ah
  013100  b80100           mov ax, 1
  013103  d3e0             shl ax, cl
  013105  a30800           mov word ptr [8], ax
  013108  80e904           sub cl, 4
  01310B  b80100           mov ax, 1
  01310E  d3e0             shl ax, cl
  013110  a30a00           mov word ptr [0xa], ax
  013113  80e904           sub cl, 4
  013116  b0ff             mov al, 0xff
  013118  d2e0             shl al, cl
  01311A  a20600           mov byte ptr [6], al
  01311D  81fe1b08         cmp si, 0x81b
  013121  7203             jb 0x13126
  013123  e80701           call 0x1322d
  013126  ad               lodsw ax, word ptr [si]
  013127  8be8             mov bp, ax
  013129  ba1000           mov dx, 0x10
  01312C  eb0b             jmp 0x13139
  01312E  90               nop
  01312F  b81600           mov ax, 0x16
  013132  1f               pop ds
  013133  5f               pop di
  013134  5e               pop si
  013135  c9               leave
  013136  ca0c00           retf 0xc
  013139  4a               dec dx
  01313A  7512             jne 0x1314e
  01313C  81fe1b08         cmp si, 0x81b
  013140  7203             jb 0x13145
  013142  e8e800           call 0x1322d
  013145  ad               lodsw ax, word ptr [si]
  013146  b210             mov dl, 0x10
  013148  d1ed             shr bp, 1
  01314A  8be8             mov bp, ax
  01314C  d1d5             rcl bp, 1
  01314E  d1dd             rcr bp, 1
  013150  7316             jae 0x13168
  013152  81fe1b08         cmp si, 0x81b
  013156  7603             jbe 0x1315b
  013158  e8d200           call 0x1322d
  01315B  ac               lodsb al, byte ptr [si]
  01315C  81ff1b38         cmp di, 0x381b
  013160  7603             jbe 0x13165
  013162  e8fc00           call 0x13261
  013165  aa               stosb byte ptr es:[di], al
  013166  ebd1             jmp 0x13139
  013168  33c9             xor cx, cx
  01316A  4a               dec dx
  01316B  7512             jne 0x1317f
  01316D  81fe1b08         cmp si, 0x81b
  013171  7203             jb 0x13176
  013173  e8b700           call 0x1322d
  013176  ad               lodsw ax, word ptr [si]
  013177  b210             mov dl, 0x10
  013179  d1ed             shr bp, 1
  01317B  8be8             mov bp, ax
  01317D  d1d5             rcl bp, 1
  01317F  d1dd             rcr bp, 1
  013181  7245             jb 0x131c8
  013183  4a               dec dx
  013184  7512             jne 0x13198
  013186  81fe1b08         cmp si, 0x81b
  01318A  7203             jb 0x1318f
  01318C  e89e00           call 0x1322d
  01318F  ad               lodsw ax, word ptr [si]
  013190  b210             mov dl, 0x10
  013192  d1ed             shr bp, 1
  013194  8be8             mov bp, ax
  013196  d1d5             rcl bp, 1
  013198  d1dd             rcr bp, 1
  01319A  d1d1             rcl cx, 1
  01319C  4a               dec dx
  01319D  7512             jne 0x131b1
  01319F  81fe1b08         cmp si, 0x81b
  0131A3  7203             jb 0x131a8
  0131A5  e88500           call 0x1322d
  0131A8  ad               lodsw ax, word ptr [si]
  0131A9  b210             mov dl, 0x10
  0131AB  d1ed             shr bp, 1
  0131AD  8be8             mov bp, ax
  0131AF  d1d5             rcl bp, 1
  0131B1  d1dd             rcr bp, 1
  0131B3  d1d1             rcl cx, 1
  0131B5  41               inc cx
  0131B6  41               inc cx
  0131B7  81fe1b08         cmp si, 0x81b
  0131BB  7603             jbe 0x131c0
  0131BD  e86d00           call 0x1322d
  0131C0  ac               lodsb al, byte ptr [si]
  0131C1  b7ff             mov bh, 0xff
  0131C3  8ad8             mov bl, al
  0131C5  eb21             jmp 0x131e8
  0131C7  90               nop
  0131C8  81fe1b08         cmp si, 0x81b
  0131CC  7203             jb 0x131d1
  0131CE  e85c00           call 0x1322d
  0131D1  ad               lodsw ax, word ptr [si]
  0131D2  8bd8             mov bx, ax
  0131D4  8a0e0400         mov cl, byte ptr [4]
  0131D8  d2ef             shr bh, cl
  0131DA  0a3e0600         or bh, byte ptr [6]
  0131DE  22260500         and ah, byte ptr [5]
  0131E2  7416             je 0x131fa
  0131E4  8acc             mov cl, ah
  0131E6  41               inc cx
  0131E7  41               inc cx
  0131E8  268a01           mov al, byte ptr es:[bx + di]
  0131EB  81ff1b38         cmp di, 0x381b
  0131EF  7603             jbe 0x131f4
  0131F1  e86d00           call 0x13261
  0131F4  aa               stosb byte ptr es:[di], al
  0131F5  e2f1             loop 0x131e8
  0131F7  e93fff           jmp 0x13139
  0131FA  81fe1b08         cmp si, 0x81b
  0131FE  7603             jbe 0x13203
  013200  e82a00           call 0x1322d
  013203  ac               lodsb al, byte ptr [si]
  013204  0ac0             or al, al
  013206  740c             je 0x13214
  013208  3c01             cmp al, 1
  01320A  7405             je 0x13211
  01320C  8ac8             mov cl, al
  01320E  41               inc cx
  01320F  ebd7             jmp 0x131e8
  013211  e925ff           jmp 0x13139
  013214  e84a00           call 0x13261
  013217  8b2e0000         mov bp, word ptr [0]
  01321B  8d361600         lea si, [0x16]
  01321F  c47e06           les di, ptr [bp + 6]
  013222  a5               movsw word ptr es:[di], word ptr [si]
  013223  a5               movsw word ptr es:[di], word ptr [si]
  013224  33c0             xor ax, ax
  013226  1f               pop ds
  013227  5f               pop di
  013228  5e               pop si
  013229  c9               leave
  01322A  ca0c00           retf 0xc

; ---- RBin_x0  file 0x01322D..0x013261  seg 0x11A7:0x1bd  (pfabexp0.ASM.obj) ----
  01322D  8a04             mov al, byte ptr [si]
  01322F  81ee0008         sub si, 0x800
  013233  8804             mov byte ptr [si], al
  013235  c70614000008     mov word ptr [0x14], 0x800
  01323B  53               push bx
  01323C  51               push cx
  01323D  52               push dx
  01323E  56               push si
  01323F  57               push di
  013240  1e               push ds
  013241  06               push es
  013242  55               push bp
  013243  1e               push ds
  013244  681c00           push 0x1c
  013247  1e               push ds
  013248  681400           push 0x14
  01324B  8b2e0000         mov bp, word ptr [0]
  01324F  8e1e0200         mov ds, word ptr [2]
  013253  26ff1e0c00       lcall es:[0xc]
  013258  5d               pop bp
  013259  07               pop es
  01325A  1f               pop ds
  01325B  5f               pop di
  01325C  5e               pop si
  01325D  5a               pop dx
  01325E  59               pop cx
  01325F  5b               pop bx
  013260  c3               ret

; ---- WBout_x0  file 0x013261..0x0132BE  seg 0x11A7:0x1f1  (pfabexp0.ASM.obj) ----
  013261  81ef1c28         sub di, 0x281c
  013265  893e1400         mov word ptr [0x14], di
  013269  013e1600         add word ptr [0x16], di
  01326D  8316180000       adc word ptr [0x18], 0
  013272  50               push ax
  013273  53               push bx
  013274  51               push cx
  013275  52               push dx
  013276  56               push si
  013277  57               push di
  013278  1e               push ds
  013279  06               push es
  01327A  55               push bp
  01327B  06               push es
  01327C  681c28           push 0x281c
  01327F  1e               push ds
  013280  681400           push 0x14
  013283  8b2e0000         mov bp, word ptr [0]
  013287  8e1e0200         mov ds, word ptr [2]
  01328B  26ff1e1000       lcall es:[0x10]
  013290  5d               pop bp
  013291  07               pop es
  013292  1f               pop ds
  013293  5f               pop di
  013294  5e               pop si
  013295  5a               pop dx
  013296  59               pop cx
  013297  5b               pop bx
  013298  58               pop ax
  013299  813e14000010     cmp word ptr [0x14], 0x1000
  01329F  7518             jne 0x132b9
  0132A1  51               push cx
  0132A2  56               push si
  0132A3  8b0e0800         mov cx, word ptr [8]
  0132A7  8d361c38         lea si, [0x381c]
  0132AB  2bf1             sub si, cx
  0132AD  8d3e1c28         lea di, [0x281c]
  0132B1  2bf9             sub di, cx
  0132B3  d1e9             shr cx, 1
  0132B5  f3a5             rep movsw word ptr es:[di], word ptr [si]
  0132B7  5e               pop si
  0132B8  59               pop cx
  0132B9  c3               ret
  0132BA  0000             add byte ptr [bx + si], al
  0132BC  0000             add byte ptr [bx + si], al
