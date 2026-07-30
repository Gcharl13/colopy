; MAPEDIT.EXE named disasm — module pal_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @pal_init  file 0x011D6C..0x011E2C  seg 0x1074:0x2c  (pal_1.c.obj) ----
  011D6C  55               push bp
  011D6D  8bec             mov bp, sp
  011D6F  52               push dx
  011D70  50               push ax
  011D71  57               push di
  011D72  56               push si
  011D73  c706884a0000     mov word ptr [0x4a88], 0
  011D79  c706cc490001     mov word ptr [0x49cc], 0x100
  011D7F  2bc0             sub ax, ax
  011D81  bb7265           mov bx, 0x6572
  011D84  b90002           mov cx, 0x200
  011D87  8bfb             mov di, bx
  011D89  1e               push ds
  011D8A  07               pop es
  011D8B  f3ab             rep stosw word ptr es:[di], ax
  011D8D  39060a44         cmp word ptr [0x440a], ax
  011D91  750f             jne 0x11da2
  011D93  8d1e205b         lea bx, [0x5b20]
  011D97  9a0000b012       lcall 0x12b0, 0
  011D9C  c7060a44ffff     mov word ptr [0x440a], 0xffff
  011DA2  837efc00         cmp word ptr [bp - 4], 0
  011DA6  7e1e             jle 0x11dc6
  011DA8  c70672650100     mov word ptr [0x6572], 1
  011DAE  c70674650000     mov word ptr [0x6574], 0
  011DB4  b87665           mov ax, 0x6576
  011DB7  8b4efc           mov cx, word ptr [bp - 4]
  011DBA  49               dec cx
  011DBB  d1e1             shl cx, 1
  011DBD  8bf8             mov di, ax
  011DBF  be7265           mov si, 0x6572
  011DC2  1e               push ds
  011DC3  07               pop es
  011DC4  f3a5             rep movsw word ptr es:[di], word ptr [si]
  011DC6  837efe00         cmp word ptr [bp - 2], 0
  011DCA  7e20             jle 0x11dec
  011DCC  c7066e690100     mov word ptr [0x696e], 1
  011DD2  c70670690000     mov word ptr [0x6970], 0
  011DD8  b86c69           mov ax, 0x696c
  011DDB  8b4efe           mov cx, word ptr [bp - 2]
  011DDE  49               dec cx
  011DDF  d1e1             shl cx, 1
  011DE1  fd               std
  011DE2  8bf8             mov di, ax
  011DE4  be7069           mov si, 0x6970
  011DE7  1e               push ds
  011DE8  07               pop es
  011DE9  f3a5             rep movsw word ptr es:[di], word ptr [si]
  011DEB  fc               cld
  011DEC  2bc0             sub ax, ax
  011DEE  bb9452           mov bx, 0x5294
  011DF1  b92000           mov cx, 0x20
  011DF4  8bfb             mov di, bx
  011DF6  1e               push ds
  011DF7  07               pop es
  011DF8  f3ab             rep stosw word ptr es:[di], ax
  011DFA  b8ffff           mov ax, 0xffff
  011DFD  a39452           mov word ptr [0x5294], ax
  011E00  a39652           mov word ptr [0x5296], ax
  011E03  8b46fc           mov ax, word ptr [bp - 4]
  011E06  a3205e           mov word ptr [0x5e20], ax
  011E09  8b46fe           mov ax, word ptr [bp - 2]
  011E0C  a3d652           mov word ptr [0x52d6], ax
  011E0F  2bc0             sub ax, ax
  011E11  a30844           mov word ptr [0x4408], ax
  011E14  a31244           mov word ptr [0x4412], ax
  011E17  6a01             push 1
  011E19  ff360e44         push word ptr [0x440e]
  011E1D  ff360c44         push word ptr [0x440c]
  011E21  e82aff           call 0x11d4e
  011E24  83c406           add sp, 6
  011E27  5e               pop si
  011E28  5f               pop di
  011E29  c9               leave
  011E2A  cb               retf
  011E2B  90               nop

; ---- @pal_lock  file 0x011E2C..0x011E7A  seg 0x1074:0xec  (pal_1.c.obj) ----
  011E2C  c8020000         enter 2, 0
  011E30  833ed25200       cmp word ptr [0x52d2], 0
  011E35  741d             je 0x11e54
  011E37  833e084400       cmp word ptr [0x4408], 0
  011E3C  7516             jne 0x11e54
  011E3E  6a00             push 0
  011E40  6a20             push 0x20
  011E42  6a00             push 0
  011E44  6a01             push 1
  011E46  b8fbff           mov ax, 0xfffb
  011E49  ba0200           mov dx, 2
  011E4C  bb0300           mov bx, 3
  011E4F  9ad603d00e       lcall 0xed0, 0x3d6
  011E54  b8ffff           mov ax, 0xffff
  011E57  a30844           mov word ptr [0x4408], ax
  011E5A  a3d252           mov word ptr [0x52d2], ax
  011E5D  bb7265           mov bx, 0x6572
  011E60  8b4efe           mov cx, word ptr [bp - 2]
  011E63  8b4702           mov ax, word ptr [bx + 2]
  011E66  0b07             or ax, word ptr [bx]
  011E68  7404             je 0x11e6e
  011E6A  804f0380         or byte ptr [bx + 3], 0x80
  011E6E  83c304           add bx, 4
  011E71  81fb7269         cmp bx, 0x6972
  011E75  72ec             jb 0x11e63
  011E77  c9               leave
  011E78  cb               retf
  011E79  90               nop

; ---- @pal_unlock  file 0x011E7A..0x011E9A  seg 0x1074:0x13a  (pal_1.c.obj) ----
  011E7A  833e084400       cmp word ptr [0x4408], 0
  011E7F  7418             je 0x11e99
  011E81  bb7265           mov bx, 0x6572
  011E84  8067037f         and byte ptr [bx + 3], 0x7f
  011E88  83c304           add bx, 4
  011E8B  81fb7269         cmp bx, 0x6972
  011E8F  72f3             jb 0x11e84
  011E91  2bc0             sub ax, ax
  011E93  a3d452           mov word ptr [0x52d4], ax
  011E96  a30844           mov word ptr [0x4408], ax
  011E99  cb               retf

; ---- @pal_deallocate  file 0x011E9A..0x011F1A  seg 0x1074:0x15a  (pal_1.c.obj) ----
  011E9A  c8080000         enter 8, 0
  011E9E  57               push di
  011E9F  8bf8             mov di, ax
  011EA1  83ff20           cmp di, 0x20
  011EA4  7d6d             jge 0x11f13
  011EA6  0bff             or di, di
  011EA8  7e69             jle 0x11f13
  011EAA  b80100           mov ax, 1
  011EAD  99               cdq
  011EAE  8bcf             mov cx, di
  011EB0  0ac9             or cl, cl
  011EB2  7408             je 0x11ebc
  011EB4  d1e0             shl ax, 1
  011EB6  d1d2             rcl dx, 1
  011EB8  fec9             dec cl
  011EBA  75f8             jne 0x11eb4
  011EBC  f7d0             not ax
  011EBE  f7d2             not dx
  011EC0  8946fc           mov word ptr [bp - 4], ax
  011EC3  8956fe           mov word ptr [bp - 2], dx
  011EC6  bb7265           mov bx, 0x6572
  011EC9  8b4efa           mov cx, word ptr [bp - 6]
  011ECC  8b46fc           mov ax, word ptr [bp - 4]
  011ECF  8b56fe           mov dx, word ptr [bp - 2]
  011ED2  2107             and word ptr [bx], ax
  011ED4  215702           and word ptr [bx + 2], dx
  011ED7  833f02           cmp word ptr [bx], 2
  011EDA  750d             jne 0x11ee9
  011EDC  837f0200         cmp word ptr [bx + 2], 0
  011EE0  7507             jne 0x11ee9
  011EE2  2bc0             sub ax, ax
  011EE4  894702           mov word ptr [bx + 2], ax
  011EE7  8907             mov word ptr [bx], ax
  011EE9  83c304           add bx, 4
  011EEC  81fb7269         cmp bx, 0x6972
  011EF0  72da             jb 0x11ecc
  011EF2  8bdf             mov bx, di
  011EF4  d1e3             shl bx, 1
  011EF6  81c39452         add bx, 0x5294
  011EFA  833f00           cmp word ptr [bx], 0
  011EFD  7414             je 0x11f13
  011EFF  c7070000         mov word ptr [bx], 0
  011F03  6a04             push 4
  011F05  ff360e44         push word ptr [0x440e]
  011F09  ff360c44         push word ptr [0x440c]
  011F0D  e83efe           call 0x11d4e
  011F10  83c406           add sp, 6
  011F13  2bc0             sub ax, ax
  011F15  5f               pop di
  011F16  c9               leave
  011F17  cb               retf
  011F18  90               nop
  011F19  90               nop

; ---- @pal_compact  file 0x011F1A..0x011FC8  seg 0x1074:0x1da  (pal_1.c.obj) ----
  011F1A  c80e0000         enter 0xe, 0
  011F1E  50               push ax
  011F1F  57               push di
  011F20  56               push si
  011F21  8bca             mov cx, dx
  011F23  c746fcffff       mov word ptr [bp - 4], 0xffff
  011F28  c746feffff       mov word ptr [bp - 2], 0xffff
  011F2D  2bc0             sub ax, ax
  011F2F  8946fa           mov word ptr [bp - 6], ax
  011F32  8946f8           mov word ptr [bp - 8], ax
  011F35  8946f2           mov word ptr [bp - 0xe], ax
  011F38  0bc9             or cx, cx
  011F3A  7e2f             jle 0x11f6b
  011F3C  8bf9             mov di, cx
  011F3E  b80100           mov ax, 1
  011F41  99               cdq
  011F42  8a0f             mov cl, byte ptr [bx]
  011F44  0ac9             or cl, cl
  011F46  7408             je 0x11f50
  011F48  d1e0             shl ax, 1
  011F4A  d1d2             rcl dx, 1
  011F4C  fec9             dec cl
  011F4E  75f8             jne 0x11f48
  011F50  3146fc           xor word ptr [bp - 4], ax
  011F53  3156fe           xor word ptr [bp - 2], dx
  011F56  0946f8           or word ptr [bp - 8], ax
  011F59  0956fa           or word ptr [bp - 6], dx
  011F5C  8b37             mov si, word ptr [bx]
  011F5E  d1e6             shl si, 1
  011F60  c78494520000     mov word ptr [si + 0x5294], 0
  011F66  43               inc bx
  011F67  43               inc bx
  011F68  4f               dec di
  011F69  75d3             jne 0x11f3e
  011F6B  b80100           mov ax, 1
  011F6E  99               cdq
  011F6F  8a4ef0           mov cl, byte ptr [bp - 0x10]
  011F72  0ac9             or cl, cl
  011F74  7408             je 0x11f7e
  011F76  d1e0             shl ax, 1
  011F78  d1d2             rcl dx, 1
  011F7A  fec9             dec cl
  011F7C  75f8             jne 0x11f76
  011F7E  8946f4           mov word ptr [bp - 0xc], ax
  011F81  8956f6           mov word ptr [bp - 0xa], dx
  011F84  bb7265           mov bx, 0x6572
  011F87  8b4ef2           mov cx, word ptr [bp - 0xe]
  011F8A  8b46f8           mov ax, word ptr [bp - 8]
  011F8D  8b56fa           mov dx, word ptr [bp - 6]
  011F90  2307             and ax, word ptr [bx]
  011F92  235702           and dx, word ptr [bx + 2]
  011F95  0bd0             or dx, ax
  011F97  7416             je 0x11faf
  011F99  8b46fc           mov ax, word ptr [bp - 4]
  011F9C  8b56fe           mov dx, word ptr [bp - 2]
  011F9F  2107             and word ptr [bx], ax
  011FA1  215702           and word ptr [bx + 2], dx
  011FA4  8b46f4           mov ax, word ptr [bp - 0xc]
  011FA7  8b56f6           mov dx, word ptr [bp - 0xa]
  011FAA  0907             or word ptr [bx], ax
  011FAC  095702           or word ptr [bx + 2], dx
  011FAF  83c304           add bx, 4
  011FB2  81fb7269         cmp bx, 0x6972
  011FB6  72d2             jb 0x11f8a
  011FB8  8b5ef0           mov bx, word ptr [bp - 0x10]
  011FBB  d1e3             shl bx, 1
  011FBD  c7879452ffff     mov word ptr [bx + 0x5294], 0xffff
  011FC3  5e               pop si
  011FC4  5f               pop di
  011FC5  c9               leave
  011FC6  cb               retf
  011FC7  90               nop

; ---- @pal_get_hash  file 0x011FC8..0x011FEE  seg 0x1074:0x288  (pal_1.c.obj) ----
  011FC8  55               push bp
  011FC9  8bec             mov bp, sp
  011FCB  57               push di
  011FCC  56               push si
  011FCD  1e               push ds
  011FCE  c47e0a           les di, ptr [bp + 0xa]
  011FD1  c57606           lds si, ptr [bp + 6]
  011FD4  b90300           mov cx, 3
  011FD7  33d2             xor dx, dx
  011FD9  ac               lodsb al, byte ptr [si]
  011FDA  262a05           sub al, byte ptr es:[di]
  011FDD  47               inc di
  011FDE  f6e8             imul al
  011FE0  03d0             add dx, ax
  011FE2  e2f5             loop 0x11fd9
  011FE4  8bc2             mov ax, dx
  011FE6  1f               pop ds
  011FE7  5e               pop si
  011FE8  5f               pop di
  011FE9  c9               leave
  011FEA  ca0800           retf 8
  011FED  90               nop

; ---- @pal_shadow_sort  file 0x011FEE..0x012072  seg 0x1074:0x2ae  (pal_1.c.obj) ----
  011FEE  c8160000         enter 0x16, 0
  011FF2  57               push di
  011FF3  56               push si
  011FF4  8b760a           mov si, word ptr [bp + 0xa]
  011FF7  c746fa0000       mov word ptr [bp - 6], 0
  011FFC  8e460c           mov es, word ptr [bp + 0xc]
  011FFF  26833c00         cmp word ptr es:[si], 0
  012003  7e50             jle 0x12055
  012005  8d4402           lea ax, [si + 2]
  012008  8cc2             mov dx, es
  01200A  8bc8             mov cx, ax
  01200C  8956f8           mov word ptr [bp - 8], dx
  01200F  8d7eea           lea di, [bp - 0x16]
  012012  894ef6           mov word ptr [bp - 0xa], cx
  012015  8bf1             mov si, cx
  012017  8e46f8           mov es, word ptr [bp - 8]
  01201A  8bde             mov bx, si
  01201C  46               inc si
  01201D  46               inc si
  01201E  268b07           mov ax, word ptr es:[bx]
  012021  8bc8             mov cx, ax
  012023  d1e0             shl ax, 1
  012025  03c1             add ax, cx
  012027  d1e0             shl ax, 1
  012029  034606           add ax, word ptr [bp + 6]
  01202C  8b5608           mov dx, word ptr [bp + 8]
  01202F  40               inc ax
  012030  40               inc ax
  012031  52               push dx
  012032  50               push ax
  012033  9a0a003e13       lcall 0x133e, 0xa
  012038  83c404           add sp, 4
  01203B  99               cdq
  01203C  83c704           add di, 4
  01203F  8945fc           mov word ptr [di - 4], ax
  012042  8955fe           mov word ptr [di - 2], dx
  012045  ff46fa           inc word ptr [bp - 6]
  012048  8b46fa           mov ax, word ptr [bp - 6]
  01204B  c45e0a           les bx, ptr [bp + 0xa]
  01204E  263907           cmp word ptr es:[bx], ax
  012051  7fc4             jg 0x12017
  012053  8bf3             mov si, bx
  012055  8cc1             mov cx, es
  012057  8d4402           lea ax, [si + 2]
  01205A  51               push cx
  01205B  50               push ax
  01205C  8d46ea           lea ax, [bp - 0x16]
  01205F  16               push ss
  012060  50               push ax
  012061  8ec1             mov es, cx
  012063  268b04           mov ax, word ptr es:[si]
  012066  9a0e00c712       lcall 0x12c7, 0xe
  01206B  5e               pop si
  01206C  5f               pop di
  01206D  c9               leave
  01206E  ca0800           retf 8
  012071  90               nop

; ---- @pal_init_shadow  file 0x012072..0x0120D2  seg 0x1074:0x332  (pal_1.c.obj) ----
  012072  c8080000         enter 8, 0
  012076  57               push di
  012077  56               push si
  012078  8b7e0a           mov di, word ptr [bp + 0xa]
  01207B  8b4e06           mov cx, word ptr [bp + 6]
  01207E  2bdb             sub bx, bx
  012080  8e460c           mov es, word ptr [bp + 0xc]
  012083  26891d           mov word ptr es:[di], bx
  012086  8e4608           mov es, word ptr [bp + 8]
  012089  8bf1             mov si, cx
  01208B  26391c           cmp word ptr es:[si], bx
  01208E  7e3b             jle 0x120cb
  012090  8bc1             mov ax, cx
  012092  050700           add ax, 7
  012095  8cc2             mov dx, es
  012097  8946f8           mov word ptr [bp - 8], ax
  01209A  8956fa           mov word ptr [bp - 6], dx
  01209D  8e5e0c           mov ds, word ptr [bp + 0xc]
  0120A0  c476f8           les si, ptr [bp - 8]
  0120A3  26f60410         test byte ptr es:[si], 0x10
  0120A7  7410             je 0x120b9
  0120A9  833d03           cmp word ptr [di], 3
  0120AC  7d0b             jge 0x120b9
  0120AE  8b35             mov si, word ptr [di]
  0120B0  d1e6             shl si, 1
  0120B2  03f7             add si, di
  0120B4  895c02           mov word ptr [si + 2], bx
  0120B7  ff05             inc word ptr [di]
  0120B9  8346f806         add word ptr [bp - 8], 6
  0120BD  43               inc bx
  0120BE  c47606           les si, ptr [bp + 6]
  0120C1  26391c           cmp word ptr es:[si], bx
  0120C4  7fda             jg 0x120a0
  0120C6  b9e715           mov cx, 0x15e7
  0120C9  8ed9             mov ds, cx
  0120CB  5e               pop si
  0120CC  5f               pop di
  0120CD  c9               leave
  0120CE  ca0800           retf 8
  0120D1  90               nop

; ---- @pal_activate_shadow  file 0x0120D2..0x012156  seg 0x1074:0x392  (pal_1.c.obj) ----
  0120D2  55               push bp
  0120D3  8bec             mov bp, sp
  0120D5  8b4606           mov ax, word ptr [bp + 6]
  0120D8  8b5608           mov dx, word ptr [bp + 8]
  0120DB  a30444           mov word ptr [0x4404], ax
  0120DE  89160644         mov word ptr [0x4406], dx
  0120E2  c9               leave
  0120E3  ca0400           retf 4
  0120E6  57               push di
  0120E7  bff6ff           mov di, 0xfff6
  0120EA  2bd2             sub dx, dx
  0120EC  bb9452           mov bx, 0x5294
  0120EF  833f00           cmp word ptr [bx], 0
  0120F2  740c             je 0x12100
  0120F4  42               inc dx
  0120F5  43               inc bx
  0120F6  43               inc bx
  0120F7  81fbd452         cmp bx, 0x52d4
  0120FB  72f2             jb 0x120ef
  0120FD  eb07             jmp 0x12106
  0120FF  90               nop
  012100  8bfa             mov di, dx
  012102  8bc7             mov ax, di
  012104  5f               pop di
  012105  c3               ret
  012106  6a00             push 0
  012108  6a20             push 0x20
  01210A  6a00             push 0
  01210C  6a01             push 1
  01210E  b8fbff           mov ax, 0xfffb
  012111  ba0200           mov dx, 2
  012114  bb0300           mov bx, 3
  012117  9ad603d00e       lcall 0xed0, 0x3d6
  01211C  8bc7             mov ax, di
  01211E  5f               pop di
  01211F  c3               ret
  012120  c8020000         enter 2, 0
  012124  57               push di
  012125  8b7e04           mov di, word ptr [bp + 4]
  012128  c705ffff         mov word ptr [di], 0xffff
  01212C  2bc9             sub cx, cx
  01212E  894efe           mov word ptr [bp - 2], cx
  012131  bb7265           mov bx, 0x6572
  012134  8b4702           mov ax, word ptr [bx + 2]
  012137  0b07             or ax, word ptr [bx]
  012139  750a             jne 0x12145
  01213B  ff46fe           inc word ptr [bp - 2]
  01213E  833d00           cmp word ptr [di], 0
  012141  7d02             jge 0x12145
  012143  890d             mov word ptr [di], cx
  012145  41               inc cx
  012146  83c304           add bx, 4
  012149  81fb7269         cmp bx, 0x6972
  01214D  72e5             jb 0x12134
  01214F  8b46fe           mov ax, word ptr [bp - 2]
  012152  5f               pop di
  012153  c9               leave
  012154  c3               ret
  012155  90               nop

; ---- @pal_allocate  file 0x012156..0x012742  seg 0x1074:0x416  (pal_1.c.obj) ----
  012156  c84c0200         enter 0x24c, 0
  01215A  50               push ax
  01215B  57               push di
  01215C  56               push si
  01215D  8d8ec8fd         lea cx, [bp - 0x238]
  012161  898ee8fe         mov word ptr [bp - 0x118], cx
  012165  c786bafd205b     mov word ptr [bp - 0x246], 0x5b20
  01216B  8bc8             mov cx, ax
  01216D  250008           and ax, 0x800
  012170  3d0100           cmp ax, 1
  012173  1bc0             sbb ax, ax
  012175  24fc             and al, 0xfc
  012177  80c401           add ah, 1
  01217A  8986bcfd         mov word ptr [bp - 0x244], ax
  01217E  f6c540           test ch, 0x40
  012181  7407             je 0x1218a
  012183  c746fa0000       mov word ptr [bp - 6], 0
  012188  eb17             jmp 0x121a1
  01218A  a1205e           mov ax, word ptr [0x5e20]
  01218D  8946fa           mov word ptr [bp - 6], ax
  012190  b80001           mov ax, 0x100
  012193  2b06d652         sub ax, word ptr [0x52d6]
  012197  3b86bcfd         cmp ax, word ptr [bp - 0x244]
  01219B  7e04             jle 0x121a1
  01219D  8b86bcfd         mov ax, word ptr [bp - 0x244]
  0121A1  8986c6fd         mov word ptr [bp - 0x23a], ax
  0121A5  a1884a           mov ax, word ptr [0x4a88]
  0121A8  3b46fa           cmp ax, word ptr [bp - 6]
  0121AB  7d03             jge 0x121b0
  0121AD  8b46fa           mov ax, word ptr [bp - 6]
  0121B0  8946fa           mov word ptr [bp - 6], ax
  0121B3  a1cc49           mov ax, word ptr [0x49cc]
  0121B6  3b86c6fd         cmp ax, word ptr [bp - 0x23a]
  0121BA  7e04             jle 0x121c0
  0121BC  8b86c6fd         mov ax, word ptr [bp - 0x23a]
  0121C0  8986c6fd         mov word ptr [bp - 0x23a], ax
  0121C4  e81fff           call 0x120e6
  0121C7  8986d4fd         mov word ptr [bp - 0x22c], ax
  0121CB  0bc0             or ax, ax
  0121CD  7d03             jge 0x121d2
  0121CF  e96505           jmp 0x12737
  0121D2  b80100           mov ax, 1
  0121D5  99               cdq
  0121D6  8a8ed4fd         mov cl, byte ptr [bp - 0x22c]
  0121DA  0ac9             or cl, cl
  0121DC  7408             je 0x121e6
  0121DE  d1e0             shl ax, 1
  0121E0  d1d2             rcl dx, 1
  0121E2  fec9             dec cl
  0121E4  75f8             jne 0x121de
  0121E6  8986c2fd         mov word ptr [bp - 0x23e], ax
  0121EA  8996c4fd         mov word ptr [bp - 0x23c], dx
  0121EE  8aa6b3fd         mov ah, byte ptr [bp - 0x24d]
  0121F2  250080           and ax, 0x8000
  0121F5  8946f4           mov word ptr [bp - 0xc], ax
  0121F8  8aaeb3fd         mov ch, byte ptr [bp - 0x24d]
  0121FC  81e10084         and cx, 0x8400
  012200  894ef6           mov word ptr [bp - 0xa], cx
  012203  8b4e08           mov cx, word ptr [bp + 8]
  012206  0b4e06           or cx, word ptr [bp + 6]
  012209  7405             je 0x12210
  01220B  b80100           mov ax, 1
  01220E  eb02             jmp 0x12212
  012210  2bc0             sub ax, ax
  012212  8986b8fd         mov word ptr [bp - 0x248], ax
  012216  c786eefe0000     mov word ptr [bp - 0x112], 0
  01221C  0bc0             or ax, ax
  01221E  742a             je 0x1224a
  012220  837ef400         cmp word ptr [bp - 0xc], 0
  012224  7509             jne 0x1222f
  012226  c45e06           les bx, ptr [bp + 6]
  012229  26833f00         cmp word ptr es:[bx], 0
  01222D  7506             jne 0x12235
  01222F  c786b8fd0000     mov word ptr [bp - 0x248], 0
  012235  837ef400         cmp word ptr [bp - 0xc], 0
  012239  740f             je 0x1224a
  01223B  c45e06           les bx, ptr [bp + 6]
  01223E  26833f00         cmp word ptr es:[bx], 0
  012242  7406             je 0x1224a
  012244  c786eefeffff     mov word ptr [bp - 0x112], 0xffff
  01224A  83beb8fd00       cmp word ptr [bp - 0x248], 0
  01224F  7420             je 0x12271
  012251  8d86dafd         lea ax, [bp - 0x226]
  012255  16               push ss
  012256  50               push ax
  012257  ff760c           push word ptr [bp + 0xc]
  01225A  ff760a           push word ptr [bp + 0xa]
  01225D  0e               push cs
  01225E  e811fe           call 0x12072
  012261  8d86dafd         lea ax, [bp - 0x226]
  012265  16               push ss
  012266  50               push ax
  012267  ff760c           push word ptr [bp + 0xc]
  01226A  ff760a           push word ptr [bp + 0xa]
  01226D  0e               push cs
  01226E  e87dfd           call 0x11fee
  012271  8d86d8fd         lea ax, [bp - 0x228]
  012275  50               push ax
  012276  e8a7fe           call 0x12120
  012279  83c402           add sp, 2
  01227C  8946f8           mov word ptr [bp - 8], ax
  01227F  8b46fa           mov ax, word ptr [bp - 6]
  012282  3b86d8fd         cmp ax, word ptr [bp - 0x228]
  012286  7d04             jge 0x1228c
  012288  8b86d8fd         mov ax, word ptr [bp - 0x228]
  01228C  8986d8fd         mov word ptr [bp - 0x228], ax
  012290  c786d6fd0000     mov word ptr [bp - 0x22a], 0
  012296  eb63             jmp 0x122fb
  012298  2ae4             sub ah, ah
  01229A  8d8ee2fd         lea cx, [bp - 0x21e]
  01229E  8b9ed6fd         mov bx, word ptr [bp - 0x22a]
  0122A2  03d9             add bx, cx
  0122A4  8807             mov byte ptr [bx], al
  0122A6  8b9ed6fd         mov bx, word ptr [bp - 0x22a]
  0122AA  8d86f4fe         lea ax, [bp - 0x10c]
  0122AE  03d8             add bx, ax
  0122B0  c60700           mov byte ptr [bx], 0
  0122B3  8bc3             mov ax, bx
  0122B5  8b9ed6fd         mov bx, word ptr [bp - 0x22a]
  0122B9  8bcb             mov cx, bx
  0122BB  d1e3             shl bx, 1
  0122BD  03d9             add bx, cx
  0122BF  d1e3             shl bx, 1
  0122C1  035e0a           add bx, word ptr [bp + 0xa]
  0122C4  8e460c           mov es, word ptr [bp + 0xc]
  0122C7  26f6470780       test byte ptr es:[bx + 7], 0x80
  0122CC  7505             jne 0x122d3
  0122CE  8bd8             mov bx, ax
  0122D0  c60740           mov byte ptr [bx], 0x40
  0122D3  8b9ed6fd         mov bx, word ptr [bp - 0x22a]
  0122D7  8bc3             mov ax, bx
  0122D9  d1e3             shl bx, 1
  0122DB  03d8             add bx, ax
  0122DD  d1e3             shl bx, 1
  0122DF  035e0a           add bx, word ptr [bp + 0xa]
  0122E2  8e460c           mov es, word ptr [bp + 0xc]
  0122E5  26f6470760       test byte ptr es:[bx + 7], 0x60
  0122EA  740b             je 0x122f7
  0122EC  8bd8             mov bx, ax
  0122EE  8d86f4fe         lea ax, [bp - 0x10c]
  0122F2  03d8             add bx, ax
  0122F4  800f20           or byte ptr [bx], 0x20
  0122F7  ff86d6fd         inc word ptr [bp - 0x22a]
  0122FB  8b86d6fd         mov ax, word ptr [bp - 0x22a]
  0122FF  c45e0a           les bx, ptr [bp + 0xa]
  012302  263907           cmp word ptr es:[bx], ax
  012305  7f91             jg 0x12298
  012307  8d86e2fd         lea ax, [bp - 0x21e]
  01230B  16               push ss
  01230C  50               push ax
  01230D  8d86f4fe         lea ax, [bp - 0x10c]
  012311  16               push ss
  012312  50               push ax
  012313  8b5e0a           mov bx, word ptr [bp + 0xa]
  012316  268b07           mov ax, word ptr es:[bx]
  012319  9a0800e012       lcall 0x12e0, 8
  01231E  f686b3fd40       test byte ptr [bp - 0x24d], 0x40
  012323  7409             je 0x1232e
  012325  c786ccfdffff     mov word ptr [bp - 0x234], 0xffff
  01232B  eb07             jmp 0x12334
  01232D  90               nop
  01232E  c786ccfdfeff     mov word ptr [bp - 0x234], 0xfffe
  012334  c786cefdffff     mov word ptr [bp - 0x232], 0xffff
  01233A  c786ecfe0000     mov word ptr [bp - 0x114], 0
  012340  e92303           jmp 0x12666
  012343  90               nop
  012344  8b86e6fe         mov ax, word ptr [bp - 0x11a]
  012348  3986dafd         cmp word ptr [bp - 0x226], ax
  01234C  7e3e             jle 0x1238c
  01234E  8bd8             mov bx, ax
  012350  d1e3             shl bx, 1
  012352  8d8edcfd         lea cx, [bp - 0x224]
  012356  03d9             add bx, cx
  012358  393f             cmp word ptr [bx], di
  01235A  7525             jne 0x12381
  01235C  c786befdffff     mov word ptr [bp - 0x242], 0xffff
  012362  c45e06           les bx, ptr [bp + 6]
  012365  268b0f           mov cx, word ptr es:[bx]
  012368  49               dec cx
  012369  3bc8             cmp cx, ax
  01236B  7e02             jle 0x1236f
  01236D  8bc8             mov cx, ax
  01236F  898ec0fd         mov word ptr [bp - 0x240], cx
  012373  8bd9             mov bx, cx
  012375  d1e3             shl bx, 1
  012377  035e06           add bx, word ptr [bp + 6]
  01237A  268b4702         mov ax, word ptr es:[bx + 2]
  01237E  8946fc           mov word ptr [bp - 4], ax
  012381  ff86e6fe         inc word ptr [bp - 0x11a]
  012385  83bebefd00       cmp word ptr [bp - 0x242], 0
  01238A  74b8             je 0x12344
  01238C  83beeefe00       cmp word ptr [bp - 0x112], 0
  012391  7479             je 0x1240c
  012393  8bdf             mov bx, di
  012395  d1e3             shl bx, 1
  012397  03df             add bx, di
  012399  d1e3             shl bx, 1
  01239B  035e0a           add bx, word ptr [bp + 0xa]
  01239E  8e460c           mov es, word ptr [bp + 0xc]
  0123A1  26f6470710       test byte ptr es:[bx + 7], 0x10
  0123A6  7464             je 0x1240c
  0123A8  c786e6fe0000     mov word ptr [bp - 0x11a], 0
  0123AE  eb55             jmp 0x12405
  0123B0  90               nop
  0123B1  90               nop
  0123B2  8b86e6fe         mov ax, word ptr [bp - 0x11a]
  0123B6  c41e0444         les bx, ptr [0x4404]
  0123BA  263907           cmp word ptr es:[bx], ax
  0123BD  7e4d             jle 0x1240c
  0123BF  d1e0             shl ax, 1
  0123C1  43               inc bx
  0123C2  43               inc bx
  0123C3  03d8             add bx, ax
  0123C5  26393f           cmp word ptr es:[bx], di
  0123C8  7537             jne 0x12401
  0123CA  c786befdffff     mov word ptr [bp - 0x242], 0xffff
  0123D0  8b86e6fe         mov ax, word ptr [bp - 0x11a]
  0123D4  05f000           add ax, 0xf0
  0123D7  8946fc           mov word ptr [bp - 4], ax
  0123DA  6a03             push 3
  0123DC  8bcf             mov cx, di
  0123DE  d1e1             shl cx, 1
  0123E0  03cf             add cx, di
  0123E2  d1e1             shl cx, 1
  0123E4  034e0a           add cx, word ptr [bp + 0xa]
  0123E7  8b560c           mov dx, word ptr [bp + 0xc]
  0123EA  41               inc cx
  0123EB  41               inc cx
  0123EC  52               push dx
  0123ED  51               push cx
  0123EE  8bc8             mov cx, ax
  0123F0  d1e0             shl ax, 1
  0123F2  03c1             add ax, cx
  0123F4  05205b           add ax, 0x5b20
  0123F7  1e               push ds
  0123F8  50               push ax
  0123F9  9a4a0c8813       lcall 0x1388, 0xc4a
  0123FE  83c40a           add sp, 0xa
  012401  ff86e6fe         inc word ptr [bp - 0x11a]
  012405  83bebefd00       cmp word ptr [bp - 0x242], 0
  01240A  74a6             je 0x123b2
  01240C  8bdf             mov bx, di
  01240E  d1e3             shl bx, 1
  012410  03df             add bx, di
  012412  d1e3             shl bx, 1
  012414  035e0a           add bx, word ptr [bp + 0xa]
  012417  8e460c           mov es, word ptr [bp + 0xc]
  01241A  26f6470780       test byte ptr es:[bx + 7], 0x80
  01241F  740d             je 0x1242e
  012421  2bc0             sub ax, ax
  012423  8986d2fd         mov word ptr [bp - 0x22e], ax
  012427  8986d0fd         mov word ptr [bp - 0x230], ax
  01242B  eb0d             jmp 0x1243a
  01242D  90               nop
  01242E  c786d0fd0200     mov word ptr [bp - 0x230], 2
  012434  c786d2fd0000     mov word ptr [bp - 0x22e], 0
  01243A  83bebefd00       cmp word ptr [bp - 0x242], 0
  01243F  750f             jne 0x12450
  012441  837ef400         cmp word ptr [bp - 0xc], 0
  012445  7509             jne 0x12450
  012447  c786eafe0100     mov word ptr [bp - 0x116], 1
  01244D  eb07             jmp 0x12456
  01244F  90               nop
  012450  c786eafe0000     mov word ptr [bp - 0x116], 0
  012456  83beeafe00       cmp word ptr [bp - 0x116], 0
  01245B  7503             jne 0x12460
  01245D  e9fc00           jmp 0x1255c
  012460  8bdf             mov bx, di
  012462  d1e3             shl bx, 1
  012464  03df             add bx, di
  012466  d1e3             shl bx, 1
  012468  035e0a           add bx, word ptr [bp + 0xa]
  01246B  26f6470720       test byte ptr es:[bx + 7], 0x20
  012470  751b             jne 0x1248d
  012472  f686b3fd20       test byte ptr [bp - 0x24d], 0x20
  012477  7507             jne 0x12480
  012479  26f6470740       test byte ptr es:[bx + 7], 0x40
  01247E  7414             je 0x12494
  012480  f686b3fd10       test byte ptr [bp - 0x24d], 0x10
  012485  7506             jne 0x1248d
  012487  837ef800         cmp word ptr [bp - 8], 0
  01248B  7507             jne 0x12494
  01248D  c746feff7f       mov word ptr [bp - 2], 0x7fff
  012492  eb05             jmp 0x12499
  012494  c746fe0100       mov word ptr [bp - 2], 1
  012499  8b76fa           mov si, word ptr [bp - 6]
  01249C  eb50             jmp 0x124ee
  01249E  8bde             mov bx, si
  0124A0  d1e3             shl bx, 1
  0124A2  03de             add bx, si
  0124A4  8b87205b         mov ax, word ptr [bx + 0x5b20]
  0124A8  8bcb             mov cx, bx
  0124AA  8bdf             mov bx, di
  0124AC  d1e3             shl bx, 1
  0124AE  03df             add bx, di
  0124B0  d1e3             shl bx, 1
  0124B2  035e0a           add bx, word ptr [bp + 0xa]
  0124B5  8e460c           mov es, word ptr [bp + 0xc]
  0124B8  26394702         cmp word ptr es:[bx + 2], ax
  0124BC  7514             jne 0x124d2
  0124BE  268a4704         mov al, byte ptr es:[bx + 4]
  0124C2  8bd9             mov bx, cx
  0124C4  3a87225b         cmp al, byte ptr [bx + 0x5b22]
  0124C8  7508             jne 0x124d2
  0124CA  c786f2fe0000     mov word ptr [bp - 0x10e], 0
  0124D0  eb06             jmp 0x124d8
  0124D2  c786f2fe0100     mov word ptr [bp - 0x10e], 1
  0124D8  8b86f2fe         mov ax, word ptr [bp - 0x10e]
  0124DC  3946fe           cmp word ptr [bp - 2], ax
  0124DF  7e0c             jle 0x124ed
  0124E1  c786befdffff     mov word ptr [bp - 0x242], 0xffff
  0124E7  8976fc           mov word ptr [bp - 4], si
  0124EA  8946fe           mov word ptr [bp - 2], ax
  0124ED  46               inc si
  0124EE  39b6c6fd         cmp word ptr [bp - 0x23a], si
  0124F2  7e68             jle 0x1255c
  0124F4  8bde             mov bx, si
  0124F6  c1e302           shl bx, 2
  0124F9  8b877465         mov ax, word ptr [bx + 0x6574]
  0124FD  0b877265         or ax, word ptr [bx + 0x6572]
  012501  74ea             je 0x124ed
  012503  f687726501       test byte ptr [bx + 0x6572], 1
  012508  7407             je 0x12511
  01250A  f686b3fd40       test byte ptr [bp - 0x24d], 0x40
  01250F  74dc             je 0x124ed
  012511  8bde             mov bx, si
  012513  c1e302           shl bx, 2
  012516  8b877265         mov ax, word ptr [bx + 0x6572]
  01251A  8b977465         mov dx, word ptr [bx + 0x6574]
  01251E  2386d0fd         and ax, word ptr [bp - 0x230]
  012522  2396d2fd         and dx, word ptr [bp - 0x22e]
  012526  0bd0             or dx, ax
  012528  75c3             jne 0x124ed
  01252A  837efe01         cmp word ptr [bp - 2], 1
  01252E  7f03             jg 0x12533
  012530  e96bff           jmp 0x1249e
  012533  8bc7             mov ax, di
  012535  d1e0             shl ax, 1
  012537  03c7             add ax, di
  012539  d1e0             shl ax, 1
  01253B  03460a           add ax, word ptr [bp + 0xa]
  01253E  8b560c           mov dx, word ptr [bp + 0xc]
  012541  40               inc ax
  012542  40               inc ax
  012543  52               push dx
  012544  50               push ax
  012545  8bc6             mov ax, si
  012547  d1e0             shl ax, 1
  012549  03c6             add ax, si
  01254B  05205b           add ax, 0x5b20
  01254E  1e               push ds
  01254F  50               push ax
  012550  0e               push cs
  012551  e874fa           call 0x11fc8
  012554  8986f2fe         mov word ptr [bp - 0x10e], ax
  012558  e97dff           jmp 0x124d8
  01255B  90               nop
  01255C  83bebefd00       cmp word ptr [bp - 0x242], 0
  012561  752b             jne 0x1258e
  012563  f686b3fd10       test byte ptr [bp - 0x24d], 0x10
  012568  741c             je 0x12586
  01256A  8bdf             mov bx, di
  01256C  d1e3             shl bx, 1
  01256E  03df             add bx, di
  012570  d1e3             shl bx, 1
  012572  035e0a           add bx, word ptr [bp + 0xa]
  012575  8e460c           mov es, word ptr [bp + 0xc]
  012578  26f6470760       test byte ptr es:[bx + 7], 0x60
  01257D  750f             jne 0x1258e
  01257F  f686b3fd20       test byte ptr [bp - 0x24d], 0x20
  012584  7508             jne 0x1258e
  012586  c786f0fe0100     mov word ptr [bp - 0x110], 1
  01258C  eb06             jmp 0x12594
  01258E  c786f0fe0000     mov word ptr [bp - 0x110], 0
  012594  83bef0fe00       cmp word ptr [bp - 0x110], 0
  012599  745c             je 0x125f7
  01259B  8bb6d8fd         mov si, word ptr [bp - 0x228]
  01259F  eb4f             jmp 0x125f0
  0125A1  90               nop
  0125A2  39b6c6fd         cmp word ptr [bp - 0x23a], si
  0125A6  7e4f             jle 0x125f7
  0125A8  8bde             mov bx, si
  0125AA  c1e302           shl bx, 2
  0125AD  8b877465         mov ax, word ptr [bx + 0x6574]
  0125B1  0b877265         or ax, word ptr [bx + 0x6572]
  0125B5  7538             jne 0x125ef
  0125B7  ff4ef8           dec word ptr [bp - 8]
  0125BA  ff86d8fd         inc word ptr [bp - 0x228]
  0125BE  c786befdffff     mov word ptr [bp - 0x242], 0xffff
  0125C4  8976fc           mov word ptr [bp - 4], si
  0125C7  8bc7             mov ax, di
  0125C9  d1e0             shl ax, 1
  0125CB  03c7             add ax, di
  0125CD  d1e0             shl ax, 1
  0125CF  03460a           add ax, word ptr [bp + 0xa]
  0125D2  8b560c           mov dx, word ptr [bp + 0xc]
  0125D5  40               inc ax
  0125D6  40               inc ax
  0125D7  8bde             mov bx, si
  0125D9  d1e3             shl bx, 1
  0125DB  03de             add bx, si
  0125DD  56               push si
  0125DE  57               push di
  0125DF  1e               push ds
  0125E0  8dbf205b         lea di, [bx + 0x5b20]
  0125E4  8bf0             mov si, ax
  0125E6  1e               push ds
  0125E7  07               pop es
  0125E8  8eda             mov ds, dx
  0125EA  a5               movsw word ptr es:[di], word ptr [si]
  0125EB  a4               movsb byte ptr es:[di], byte ptr [si]
  0125EC  1f               pop ds
  0125ED  5f               pop di
  0125EE  5e               pop si
  0125EF  46               inc si
  0125F0  83bebefd00       cmp word ptr [bp - 0x242], 0
  0125F5  74ab             je 0x125a2
  0125F7  83bebefd00       cmp word ptr [bp - 0x242], 0
  0125FC  7503             jne 0x12601
  0125FE  e9d100           jmp 0x126d2
  012601  837ef400         cmp word ptr [bp - 0xc], 0
  012605  741d             je 0x12624
  012607  8bdf             mov bx, di
  012609  d1e3             shl bx, 1
  01260B  03df             add bx, di
  01260D  d1e3             shl bx, 1
  01260F  035e0a           add bx, word ptr [bp + 0xa]
  012612  8e460c           mov es, word ptr [bp + 0xc]
  012615  26807f0600       cmp byte ptr es:[bx + 6], 0
  01261A  7408             je 0x12624
  01261C  c786b4fd0200     mov word ptr [bp - 0x24c], 2
  012622  eb06             jmp 0x1262a
  012624  c786b4fd0000     mov word ptr [bp - 0x24c], 0
  01262A  8b86b4fd         mov ax, word ptr [bp - 0x24c]
  01262E  99               cdq
  01262F  8986e2fe         mov word ptr [bp - 0x11e], ax
  012633  8996e4fe         mov word ptr [bp - 0x11c], dx
  012637  0b86c2fd         or ax, word ptr [bp - 0x23e]
  01263B  0b96c4fd         or dx, word ptr [bp - 0x23c]
  01263F  8b5efc           mov bx, word ptr [bp - 4]
  012642  c1e302           shl bx, 2
  012645  09877265         or word ptr [bx + 0x6572], ax
  012649  09977465         or word ptr [bx + 0x6574], dx
  01264D  8a46fc           mov al, byte ptr [bp - 4]
  012650  8bdf             mov bx, di
  012652  d1e3             shl bx, 1
  012654  03df             add bx, di
  012656  d1e3             shl bx, 1
  012658  035e0a           add bx, word ptr [bp + 0xa]
  01265B  8e460c           mov es, word ptr [bp + 0xc]
  01265E  26884705         mov byte ptr es:[bx + 5], al
  012662  ff86ecfe         inc word ptr [bp - 0x114]
  012666  8b86ecfe         mov ax, word ptr [bp - 0x114]
  01266A  c45e0a           les bx, ptr [bp + 0xa]
  01266D  263907           cmp word ptr es:[bx], ax
  012670  7f03             jg 0x12675
  012672  e99d00           jmp 0x12712
  012675  c786befd0000     mov word ptr [bp - 0x242], 0
  01267B  c746fcffff       mov word ptr [bp - 4], 0xffff
  012680  8dbee2fd         lea di, [bp - 0x21e]
  012684  03f8             add di, ax
  012686  8a05             mov al, byte ptr [di]
  012688  2ae4             sub ah, ah
  01268A  8bf8             mov di, ax
  01268C  8bd8             mov bx, ax
  01268E  d1e3             shl bx, 1
  012690  03df             add bx, di
  012692  d1e3             shl bx, 1
  012694  035e0a           add bx, word ptr [bp + 0xa]
  012697  26f6470708       test byte ptr es:[bx + 7], 8
  01269C  740b             je 0x126a9
  01269E  c786befdffff     mov word ptr [bp - 0x242], 0xffff
  0126A4  c746fcfd00       mov word ptr [bp - 4], 0xfd
  0126A9  83beb8fd00       cmp word ptr [bp - 0x248], 0
  0126AE  7503             jne 0x126b3
  0126B0  e9d9fc           jmp 0x1238c
  0126B3  8bdf             mov bx, di
  0126B5  d1e3             shl bx, 1
  0126B7  03df             add bx, di
  0126B9  d1e3             shl bx, 1
  0126BB  035e0a           add bx, word ptr [bp + 0xa]
  0126BE  26f6470710       test byte ptr es:[bx + 7], 0x10
  0126C3  7503             jne 0x126c8
  0126C5  e9c4fc           jmp 0x1238c
  0126C8  c786e6fe0000     mov word ptr [bp - 0x11a], 0
  0126CE  e9b4fc           jmp 0x12385
  0126D1  90               nop
  0126D2  c45e0a           les bx, ptr [bp + 0xa]
  0126D5  268b07           mov ax, word ptr es:[bx]
  0126D8  a31244           mov word ptr [0x4412], ax
  0126DB  6a03             push 3
  0126DD  ff360e44         push word ptr [0x440e]
  0126E1  ff360c44         push word ptr [0x440c]
  0126E5  e866f6           call 0x11d4e
  0126E8  83c406           add sp, 6
  0126EB  c45e0a           les bx, ptr [bp + 0xa]
  0126EE  268b07           mov ax, word ptr es:[bx]
  0126F1  99               cdq
  0126F2  52               push dx
  0126F3  50               push ax
  0126F4  8b86ecfe         mov ax, word ptr [bp - 0x114]
  0126F8  99               cdq
  0126F9  52               push dx
  0126FA  50               push ax
  0126FB  b8faff           mov ax, 0xfffa
  0126FE  ba0200           mov dx, 2
  012701  bb0300           mov bx, 3
  012704  9ad603d00e       lcall 0xed0, 0x3d6
  012709  c786d4fdf5ff     mov word ptr [bp - 0x22c], 0xfff5
  01270F  eb26             jmp 0x12737
  012711  90               nop
  012712  8b9ed4fd         mov bx, word ptr [bp - 0x22c]
  012716  d1e3             shl bx, 1
  012718  c7879452ffff     mov word ptr [bx + 0x5294], 0xffff
  01271E  c45e0a           les bx, ptr [bp + 0xa]
  012721  268b07           mov ax, word ptr es:[bx]
  012724  a31244           mov word ptr [0x4412], ax
  012727  6a02             push 2
  012729  ff360e44         push word ptr [0x440e]
  01272D  ff360c44         push word ptr [0x440c]
  012731  e81af6           call 0x11d4e
  012734  83c406           add sp, 6
  012737  8b86d4fd         mov ax, word ptr [bp - 0x22c]
  01273B  5e               pop si
  01273C  5f               pop di
  01273D  c9               leave
  01273E  ca0800           retf 8
  012741  90               nop
