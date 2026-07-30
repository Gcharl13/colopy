; MAPEDIT.EXE named disasm — module pfabcomp.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PFABCOMP  file 0x012C86..0x012CE1  seg 0x1168:0x6  (pfabcomp.ASM.obj) ----
  012C86  c8000000         enter 0, 0
  012C8A  56               push si
  012C8B  57               push di
  012C8C  1e               push ds
  012C8D  55               push bp
  012C8E  c4460e           les ax, ptr [bp + 0xe]
  012C91  050f00           add ax, 0xf
  012C94  c1e804           shr ax, 4
  012C97  8cc2             mov dx, es
  012C99  03d0             add dx, ax
  012C9B  750b             jne 0x12ca8
  012C9D  b8be71           mov ax, 0x71be
  012CA0  5d               pop bp
  012CA1  1f               pop ds
  012CA2  5f               pop di
  012CA3  5e               pop si
  012CA4  c9               leave
  012CA5  ca1400           retf 0x14
  012CA8  55               push bp
  012CA9  1e               push ds
  012CAA  8eda             mov ds, dx
  012CAC  8f060200         pop word ptr [2]
  012CB0  8f060000         pop word ptr [0]
  012CB4  c44616           les ax, ptr [bp + 0x16]
  012CB7  a30400           mov word ptr [4], ax
  012CBA  8c060600         mov word ptr [6], es
  012CBE  c44612           les ax, ptr [bp + 0x12]
  012CC1  a30c00           mov word ptr [0xc], ax
  012CC4  8c060e00         mov word ptr [0xe], es
  012CC8  e8c601           call 0x12e91
  012CCB  8b2e0000         mov bp, word ptr [0]
  012CCF  c5760e           lds si, ptr [bp + 0xe]
  012CD2  8904             mov word ptr [si], ax
  012CD4  895402           mov word ptr [si + 2], dx
  012CD7  33c0             xor ax, ax
  012CD9  5d               pop bp
  012CDA  1f               pop ds
  012CDB  5f               pop di
  012CDC  5e               pop si
  012CDD  c9               leave
  012CDE  ca1400           retf 0x14

; ---- RWinit  file 0x012CE1..0x012CF5  seg 0x1168:0x61  (pfabcomp.ASM.obj) ----
  012CE1  c7060a000100     mov word ptr [0xa], 1
  012CE7  8d06ae69         lea ax, [0x69ae]
  012CEB  a31000           mov word ptr [0x10], ax
  012CEE  b80008           mov ax, 0x800
  012CF1  a31200           mov word ptr [0x12], ax
  012CF4  c3               ret

; ---- RBin  file 0x012CF5..0x012D29  seg 0x1168:0x75  (pfabcomp.ASM.obj) ----
  012CF5  53               push bx
  012CF6  51               push cx
  012CF7  52               push dx
  012CF8  56               push si
  012CF9  57               push di
  012CFA  06               push es
  012CFB  1e               push ds
  012CFC  8d06ae61         lea ax, [0x61ae]
  012D00  a30800           mov word ptr [8], ax
  012D03  1e               push ds
  012D04  50               push ax
  012D05  b80008           mov ax, 0x800
  012D08  a3ac61           mov word ptr [0x61ac], ax
  012D0B  1e               push ds
  012D0C  68ac61           push 0x61ac
  012D0F  8b2e0000         mov bp, word ptr [0]
  012D13  8e1e0200         mov ds, word ptr [2]
  012D17  26ff1e0400       lcall es:[4]
  012D1C  1f               pop ds
  012D1D  40               inc ax
  012D1E  a30a00           mov word ptr [0xa], ax
  012D21  48               dec ax
  012D22  07               pop es
  012D23  5f               pop di
  012D24  5e               pop si
  012D25  5a               pop dx
  012D26  59               pop cx
  012D27  5b               pop bx
  012D28  c3               ret

; ---- WBout  file 0x012D29..0x012D6A  seg 0x1168:0xa9  (pfabcomp.ASM.obj) ----
  012D29  53               push bx
  012D2A  51               push cx
  012D2B  52               push dx
  012D2C  56               push si
  012D2D  57               push di
  012D2E  1e               push ds
  012D2F  06               push es
  012D30  b80008           mov ax, 0x800
  012D33  a31200           mov word ptr [0x12], ax
  012D36  a11000           mov ax, word ptr [0x10]
  012D39  8d1eae69         lea bx, [0x69ae]
  012D3D  891e1000         mov word ptr [0x10], bx
  012D41  1e               push ds
  012D42  53               push bx
  012D43  2bc3             sub ax, bx
  012D45  a3ac61           mov word ptr [0x61ac], ax
  012D48  01061400         add word ptr [0x14], ax
  012D4C  8316160000       adc word ptr [0x16], 0
  012D51  1e               push ds
  012D52  68ac61           push 0x61ac
  012D55  8b2e0000         mov bp, word ptr [0]
  012D59  8e1e0200         mov ds, word ptr [2]
  012D5D  26ff1e0c00       lcall es:[0xc]
  012D62  07               pop es
  012D63  1f               pop ds
  012D64  5f               pop di
  012D65  5e               pop si
  012D66  5a               pop dx
  012D67  59               pop cx
  012D68  5b               pop bx
  012D69  c3               ret

; ---- WBend  file 0x012D6A..0x012D6E  seg 0x1168:0xea  (pfabcomp.ASM.obj) ----
  012D6A  e8bcff           call 0x12d29
  012D6D  c3               ret

; ---- WBput  file 0x012D6E..0x012D82  seg 0x1168:0xee  (pfabcomp.ASM.obj) ----
  012D6E  8b1e1000         mov bx, word ptr [0x10]
  012D72  ff061000         inc word ptr [0x10]
  012D76  8807             mov byte ptr [bx], al
  012D78  ff0e1200         dec word ptr [0x12]
  012D7C  7503             jne 0x12d81
  012D7E  e8a8ff           call 0x12d29
  012D81  c3               ret

; ---- Packet  file 0x012D82..0x012DB6  seg 0x1168:0x102  (pfabcomp.ASM.obj) ----
  012D82  be2800           mov si, 0x28
  012D85  ff062000         inc word ptr [0x20]
  012D89  ac               lodsb al, byte ptr [si]
  012D8A  8b1e1000         mov bx, word ptr [0x10]
  012D8E  ff061000         inc word ptr [0x10]
  012D92  8807             mov byte ptr [bx], al
  012D94  ff0e1200         dec word ptr [0x12]
  012D98  7503             jne 0x12d9d
  012D9A  e88cff           call 0x12d29
  012D9D  3b362400         cmp si, word ptr [0x24]
  012DA1  75e2             jne 0x12d85
  012DA3  c70626000100     mov word ptr [0x26], 1
  012DA9  c70628000000     mov word ptr [0x28], 0
  012DAF  c70624002a00     mov word ptr [0x24], 0x2a
  012DB5  c3               ret

; ---- Huff1  file 0x012DB6..0x012DCB  seg 0x1168:0x136  (pfabcomp.ASM.obj) ----
  012DB6  0ac0             or al, al
  012DB8  7407             je 0x12dc1
  012DBA  a12600           mov ax, word ptr [0x26]
  012DBD  09062800         or word ptr [0x28], ax
  012DC1  d1262600         shl word ptr [0x26], 1
  012DC5  7503             jne 0x12dca
  012DC7  e8b8ff           call 0x12d82
  012DCA  c3               ret

; ---- push1  file 0x012DCB..0x012DD6  seg 0x1168:0x14b  (pfabcomp.ASM.obj) ----
  012DCB  8b3e2400         mov di, word ptr [0x24]
  012DCF  ff062400         inc word ptr [0x24]
  012DD3  8805             mov byte ptr [di], al
  012DD5  c3               ret

; ---- Link  file 0x012DD6..0x012DFF  seg 0x1168:0x156  (pfabcomp.ASM.obj) ----
  012DD6  56               push si
  012DD7  57               push di
  012DD8  8bb5aa00         mov si, word ptr [di + 0xaa]
  012DDC  81e6ff07         and si, 0x7ff
  012DE0  81c60110         add si, 0x1001
  012DE4  d1e6             shl si, 1
  012DE6  d1e7             shl di, 1
  012DE8  8b9ca811         mov bx, word ptr [si + 0x11a8]
  012DEC  899da811         mov word ptr [di + 0x11a8], bx
  012DF0  89bca811         mov word ptr [si + 0x11a8], di
  012DF4  89bfaa41         mov word ptr [bx + 0x41aa], di
  012DF8  89b5aa41         mov word ptr [di + 0x41aa], si
  012DFC  5f               pop di
  012DFD  5e               pop si
  012DFE  c3               ret

; ---- UnLink  file 0x012DFF..0x012E1A  seg 0x1168:0x17f  (pfabcomp.ASM.obj) ----
  012DFF  d1e6             shl si, 1
  012E01  8b9caa41         mov bx, word ptr [si + 0x41aa]
  012E05  81fb0020         cmp bx, 0x2000
  012E09  740c             je 0x12e17
  012E0B  c787a8110020     mov word ptr [bx + 0x11a8], 0x2000
  012E11  c784aa410020     mov word ptr [si + 0x41aa], 0x2000
  012E17  d1ee             shr si, 1
  012E19  c3               ret

; ---- Match  file 0x012E1A..0x012E91  seg 0x1168:0x19a  (pfabcomp.ASM.obj) ----
  012E1A  56               push si
  012E1B  57               push di
  012E1C  57               push di
  012E1D  81c7aa00         add di, 0xaa
  012E21  8bd7             mov dx, di
  012E23  42               inc dx
  012E24  8b1d             mov bx, word ptr [di]
  012E26  81e3ff07         and bx, 0x7ff
  012E2A  81c30110         add bx, 0x1001
  012E2E  d1e3             shl bx, 1
  012E30  53               push bx
  012E31  b8fc00           mov ax, 0xfc
  012E34  8b9fa811         mov bx, word ptr [bx + 0x11a8]
  012E38  81fb0020         cmp bx, 0x2000
  012E3C  7420             je 0x12e5e
  012E3E  8bf3             mov si, bx
  012E40  d1ee             shr si, 1
  012E42  81c6ab00         add si, 0xab
  012E46  8bfa             mov di, dx
  012E48  b9fc00           mov cx, 0xfc
  012E4B  f3a6             repe cmpsb byte ptr [si], byte ptr es:[di]
  012E4D  740a             je 0x12e59
  012E4F  3bc8             cmp cx, ax
  012E51  73e1             jae 0x12e34
  012E53  8beb             mov bp, bx
  012E55  8bc1             mov ax, cx
  012E57  ebdb             jmp 0x12e34
  012E59  8beb             mov bp, bx
  012E5B  b8ffff           mov ax, 0xffff
  012E5E  5e               pop si
  012E5F  5f               pop di
  012E60  d1e7             shl di, 1
  012E62  b9fd00           mov cx, 0xfd
  012E65  2bc8             sub cx, ax
  012E67  49               dec cx
  012E68  890e1a00         mov word ptr [0x1a], cx
  012E6C  8bc7             mov ax, di
  012E6E  2bc5             sub ax, bp
  012E70  d1e8             shr ax, 1
  012E72  25ff0f           and ax, 0xfff
  012E75  f7d8             neg ax
  012E77  a31c00           mov word ptr [0x1c], ax
  012E7A  8b9ca811         mov bx, word ptr [si + 0x11a8]
  012E7E  899da811         mov word ptr [di + 0x11a8], bx
  012E82  89bca811         mov word ptr [si + 0x11a8], di
  012E86  89bfaa41         mov word ptr [bx + 0x41aa], di
  012E8A  89b5aa41         mov word ptr [di + 0x41aa], si
  012E8E  5f               pop di
  012E8F  5e               pop si
  012E90  c3               ret

; ---- Fabrice  file 0x012E91..0x013070  seg 0x1168:0x211  (pfabcomp.ASM.obj) ----
  012E91  1e               push ds
  012E92  07               pop es
  012E93  e84bfe           call 0x12ce1
  012E96  b90010           mov cx, 0x1000
  012E99  b80020           mov ax, 0x2000
  012E9C  8d3eaa41         lea di, [0x41aa]
  012EA0  f3ab             rep stosw word ptr es:[di], ax
  012EA2  b90118           mov cx, 0x1801
  012EA5  8d3ea811         lea di, [0x11a8]
  012EA9  f3ab             rep stosw word ptr es:[di], ax
  012EAB  8d3eaa00         lea di, [0xaa]
  012EAF  b9fc10           mov cx, 0x10fc
  012EB2  b000             mov al, 0
  012EB4  f3aa             rep stosb byte ptr es:[di], al
  012EB6  c70626000100     mov word ptr [0x26], 1
  012EBC  c70624002a00     mov word ptr [0x24], 0x2a
  012EC2  33c0             xor ax, ax
  012EC4  a32800           mov word ptr [0x28], ax
  012EC7  a31e00           mov word ptr [0x1e], ax
  012ECA  a32000           mov word ptr [0x20], ax
  012ECD  a32200           mov word ptr [0x22], ax
  012ED0  a31400           mov word ptr [0x14], ax
  012ED3  a31600           mov word ptr [0x16], ax
  012ED6  b046             mov al, 0x46
  012ED8  e893fe           call 0x12d6e
  012EDB  b041             mov al, 0x41
  012EDD  e88efe           call 0x12d6e
  012EE0  b042             mov al, 0x42
  012EE2  e889fe           call 0x12d6e
  012EE5  b00c             mov al, 0xc
  012EE7  e884fe           call 0x12d6e
  012EEA  bfad0f           mov di, 0xfad
  012EED  b9fd00           mov cx, 0xfd
  012EF0  ff0e0a00         dec word ptr [0xa]
  012EF4  7509             jne 0x12eff
  012EF6  e8fcfd           call 0x12cf5
  012EF9  0bc0             or ax, ax
  012EFB  740d             je 0x12f0a
  012EFD  ebf1             jmp 0x12ef0
  012EFF  8b360800         mov si, word ptr [8]
  012F03  ff060800         inc word ptr [8]
  012F07  a4               movsb byte ptr es:[di], byte ptr [si]
  012F08  e2e6             loop 0x12ef0
  012F0A  b8fd00           mov ax, 0xfd
  012F0D  2bc1             sub ax, cx
  012F0F  7503             jne 0x12f14
  012F11  e93501           jmp 0x13049
  012F14  a31800           mov word ptr [0x18], ax
  012F17  bf030f           mov di, 0xf03
  012F1A  33f6             xor si, si
  012F1C  e8fbfe           call 0x12e1a
  012F1F  a11a00           mov ax, word ptr [0x1a]
  012F22  3b061800         cmp ax, word ptr [0x18]
  012F26  7e06             jle 0x12f2e
  012F28  a11800           mov ax, word ptr [0x18]
  012F2B  a31a00           mov word ptr [0x1a], ax
  012F2E  56               push si
  012F2F  57               push di
  012F30  3d0200           cmp ax, 2
  012F33  720a             jb 0x12f3f
  012F35  771c             ja 0x12f53
  012F37  813e1c0000ff     cmp word ptr [0x1c], 0xff00
  012F3D  7f14             jg 0x12f53
  012F3F  c7061a000100     mov word ptr [0x1a], 1
  012F45  b001             mov al, 1
  012F47  e86cfe           call 0x12db6
  012F4A  8a85aa00         mov al, byte ptr [di + 0xaa]
  012F4E  e87afe           call 0x12dcb
  012F51  eb5e             jmp 0x12fb1
  012F53  b000             mov al, 0
  012F55  e85efe           call 0x12db6
  012F58  833e1a0005       cmp word ptr [0x1a], 5
  012F5D  7726             ja 0x12f85
  012F5F  813e1c0000ff     cmp word ptr [0x1c], 0xff00
  012F65  7e1e             jle 0x12f85
  012F67  b000             mov al, 0
  012F69  e84afe           call 0x12db6
  012F6C  a11a00           mov ax, word ptr [0x1a]
  012F6F  48               dec ax
  012F70  48               dec ax
  012F71  50               push ax
  012F72  2402             and al, 2
  012F74  e83ffe           call 0x12db6
  012F77  58               pop ax
  012F78  2401             and al, 1
  012F7A  e839fe           call 0x12db6
  012F7D  a11c00           mov ax, word ptr [0x1c]
  012F80  e848fe           call 0x12dcb
  012F83  eb2c             jmp 0x12fb1
  012F85  b001             mov al, 1
  012F87  e82cfe           call 0x12db6
  012F8A  a11c00           mov ax, word ptr [0x1c]
  012F8D  e83bfe           call 0x12dcb
  012F90  8ac4             mov al, ah
  012F92  b104             mov cl, 4
  012F94  d2e0             shl al, cl
  012F96  8b1e1a00         mov bx, word ptr [0x1a]
  012F9A  83fb11           cmp bx, 0x11
  012F9D  7709             ja 0x12fa8
  012F9F  4b               dec bx
  012FA0  4b               dec bx
  012FA1  0ac3             or al, bl
  012FA3  e825fe           call 0x12dcb
  012FA6  eb09             jmp 0x12fb1
  012FA8  e820fe           call 0x12dcb
  012FAB  8bc3             mov ax, bx
  012FAD  48               dec ax
  012FAE  e81afe           call 0x12dcb
  012FB1  a11a00           mov ax, word ptr [0x1a]
  012FB4  29062000         sub word ptr [0x20], ax
  012FB8  7d10             jge 0x12fca
  012FBA  ff062200         inc word ptr [0x22]
  012FBE  8306200010       add word ptr [0x20], 0x10
  012FC3  833e200000       cmp word ptr [0x20], 0
  012FC8  7cf0             jl 0x12fba
  012FCA  01061e00         add word ptr [0x1e], ax
  012FCE  813e1e0000a0     cmp word ptr [0x1e], 0xa000
  012FD4  721f             jb 0x12ff5
  012FD6  b000             mov al, 0
  012FD8  e8dbfd           call 0x12db6
  012FDB  b001             mov al, 1
  012FDD  e8d6fd           call 0x12db6
  012FE0  b000             mov al, 0
  012FE2  e8e6fd           call 0x12dcb
  012FE5  b000             mov al, 0
  012FE7  e8e1fd           call 0x12dcb
  012FEA  b001             mov al, 1
  012FEC  e8dcfd           call 0x12dcb
  012FEF  c7061e000000     mov word ptr [0x1e], 0
  012FF5  5f               pop di
  012FF6  5e               pop si
  012FF7  eb03             jmp 0x12ffc
  012FF9  e8dafd           call 0x12dd6
  012FFC  e800fe           call 0x12dff
  012FFF  ff0e0a00         dec word ptr [0xa]
  013003  7509             jne 0x1300e
  013005  e8edfc           call 0x12cf5
  013008  0bc0             or ax, ax
  01300A  741c             je 0x13028
  01300C  ebf1             jmp 0x12fff
  01300E  8b1e0800         mov bx, word ptr [8]
  013012  ff060800         inc word ptr [8]
  013016  8a07             mov al, byte ptr [bx]
  013018  8884aa00         mov byte ptr [si + 0xaa], al
  01301C  81fefc00         cmp si, 0xfc
  013020  7304             jae 0x13026
  013022  8884aa10         mov byte ptr [si + 0x10aa], al
  013026  eb04             jmp 0x1302c
  013028  ff0e1800         dec word ptr [0x18]
  01302C  46               inc si
  01302D  47               inc di
  01302E  81e6ff0f         and si, 0xfff
  013032  81e7ff0f         and di, 0xfff
  013036  ff0e1a00         dec word ptr [0x1a]
  01303A  75bd             jne 0x12ff9
  01303C  e8dbfd           call 0x12e1a
  01303F  833e180000       cmp word ptr [0x18], 0
  013044  7e03             jle 0x13049
  013046  e9d6fe           jmp 0x12f1f
  013049  b000             mov al, 0
  01304B  e868fd           call 0x12db6
  01304E  b001             mov al, 1
  013050  e863fd           call 0x12db6
  013053  b000             mov al, 0
  013055  e873fd           call 0x12dcb
  013058  b000             mov al, 0
  01305A  e86efd           call 0x12dcb
  01305D  b000             mov al, 0
  01305F  e869fd           call 0x12dcb
  013062  e81dfd           call 0x12d82
  013065  e802fd           call 0x12d6a
  013068  a11400           mov ax, word ptr [0x14]
  01306B  8b161600         mov dx, word ptr [0x16]
  01306F  c3               ret
