; MAPEDIT.EXE named disasm — module mouse_1.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _MOUSE_GET_STACK  file 0x010C50..0x010C57  seg 0xF65:0x0  (mouse_1.ASM.obj) ----
  010C50  bae715           mov dx, 0x15e7
  010C53  b8d03e           mov ax, 0x3ed0
  010C56  cb               retf

; ---- _mouse_show  file 0x010C57..0x010C9E  seg 0xF65:0x7  (mouse_1.ASM.obj) ----
  010C57  833ede5200       cmp word ptr [0x52de], 0
  010C5C  750a             jne 0x10c68
  010C5E  833ec04900       cmp word ptr [0x49c0], 0
  010C63  7421             je 0x10c86
  010C65  eb25             jmp 0x10c8c
  010C67  90               nop
  010C68  a0d25a           mov al, byte ptr [0x5ad2]
  010C6B  0ac0             or al, al
  010C6D  7417             je 0x10c86
  010C6F  fec0             inc al
  010C71  7513             jne 0x10c86
  010C73  50               push ax
  010C74  53               push bx
  010C75  51               push cx
  010C76  52               push dx
  010C77  56               push si
  010C78  57               push di
  010C79  1e               push ds
  010C7A  06               push es
  010C7B  e84106           call 0x112bf
  010C7E  07               pop es
  010C7F  1f               pop ds
  010C80  5f               pop di
  010C81  5e               pop si
  010C82  5a               pop dx
  010C83  59               pop cx
  010C84  5b               pop bx
  010C85  58               pop ax
  010C86  a2d25a           mov byte ptr [0x5ad2], al
  010C89  eb12             jmp 0x10c9d
  010C8B  90               nop
  010C8C  b80100           mov ax, 1
  010C8F  cd33             int 0x33
  010C91  a0d25a           mov al, byte ptr [0x5ad2]
  010C94  0ac0             or al, al
  010C96  7405             je 0x10c9d
  010C98  fec0             inc al
  010C9A  a2d25a           mov byte ptr [0x5ad2], al
  010C9D  cb               retf

; ---- _mouse_hide  file 0x010C9E..0x010CD6  seg 0xF65:0x4e  (mouse_1.ASM.obj) ----
  010C9E  833ede5200       cmp word ptr [0x52de], 0
  010CA3  750a             jne 0x10caf
  010CA5  833ec04900       cmp word ptr [0x49c0], 0
  010CAA  7429             je 0x10cd5
  010CAC  eb1e             jmp 0x10ccc
  010CAE  90               nop
  010CAF  802ed25a01       sub byte ptr [0x5ad2], 1
  010CB4  731f             jae 0x10cd5
  010CB6  50               push ax
  010CB7  53               push bx
  010CB8  51               push cx
  010CB9  52               push dx
  010CBA  56               push si
  010CBB  57               push di
  010CBC  1e               push ds
  010CBD  06               push es
  010CBE  e8d905           call 0x1129a
  010CC1  07               pop es
  010CC2  1f               pop ds
  010CC3  5f               pop di
  010CC4  5e               pop si
  010CC5  5a               pop dx
  010CC6  59               pop cx
  010CC7  5b               pop bx
  010CC8  58               pop ax
  010CC9  eb0a             jmp 0x10cd5
  010CCB  90               nop
  010CCC  b80200           mov ax, 2
  010CCF  cd33             int 0x33
  010CD1  fe0ed25a         dec byte ptr [0x5ad2]
  010CD5  cb               retf

; ---- _mouse_init  file 0x010CD6..0x010E44  seg 0xF65:0x86  (mouse_1.ASM.obj) ----
  010CD6  c8020000         enter 2, 0
  010CDA  53               push bx
  010CDB  51               push cx
  010CDC  52               push dx
  010CDD  06               push es
  010CDE  6a00             push 0
  010CE0  ff7608           push word ptr [bp + 8]
  010CE3  9a0800c50e       lcall 0xec5, 8
  010CE8  83c404           add sp, 4
  010CEB  b81000           mov ax, 0x10
  010CEE  a3e052           mov word ptr [0x52e0], ax
  010CF1  a3e252           mov word ptr [0x52e2], ax
  010CF4  b8d842           mov ax, 0x42d8
  010CF7  a3e452           mov word ptr [0x52e4], ax
  010CFA  b8e715           mov ax, 0x15e7
  010CFD  a3e652           mov word ptr [0x52e6], ax
  010D00  8b4608           mov ax, word ptr [bp + 8]
  010D03  a34660           mov word ptr [0x6046], ax
  010D06  c706c0490000     mov word ptr [0x49c0], 0
  010D0C  c706de520000     mov word ptr [0x52de], 0
  010D12  c746fe0000       mov word ptr [bp - 2], 0
  010D17  b83335           mov ax, 0x3533
  010D1A  cd21             int 0x21
  010D1C  8cc0             mov ax, es
  010D1E  0bc3             or ax, bx
  010D20  7503             jne 0x10d25
  010D22  eb35             jmp 0x10d59
  010D24  90               nop
  010D25  268a07           mov al, byte ptr es:[bx]
  010D28  3ccf             cmp al, 0xcf
  010D2A  7503             jne 0x10d2f
  010D2C  eb2b             jmp 0x10d59
  010D2E  90               nop
  010D2F  33c0             xor ax, ax
  010D31  cd33             int 0x33
  010D33  3dffff           cmp ax, 0xffff
  010D36  7403             je 0x10d3b
  010D38  eb1f             jmp 0x10d59
  010D3A  90               nop
  010D3B  b80f00           mov ax, 0xf
  010D3E  b90800           mov cx, 8
  010D41  ba1800           mov dx, 0x18
  010D44  cd33             int 0x33
  010D46  b9ffff           mov cx, 0xffff
  010D49  51               push cx
  010D4A  b80300           mov ax, 3
  010D4D  cd33             int 0x33
  010D4F  59               pop cx
  010D50  0bdb             or bx, bx
  010D52  e0f5             loopne 0x10d49
  010D54  c746feffff       mov word ptr [bp - 2], 0xffff
  010D59  8b4606           mov ax, word ptr [bp + 6]
  010D5C  0bc0             or ax, ax
  010D5E  7503             jne 0x10d63
  010D60  e9d800           jmp 0x10e3b
  010D63  8b46fe           mov ax, word ptr [bp - 2]
  010D66  a3c049           mov word ptr [0x49c0], ax
  010D69  c606d25aff       mov byte ptr [0x5ad2], 0xff
  010D6E  c6068e3c00       mov byte ptr [0x3c8e], 0
  010D73  c706225ea000     mov word ptr [0x5e22], 0xa0
  010D79  c706245e6400     mov word ptr [0x5e24], 0x64
  010D7F  c7066e4c0000     mov word ptr [0x4c6e], 0
  010D85  c606af3c01       mov byte ptr [0x3caf], 1
  010D8A  c606893c00       mov byte ptr [0x3c89], 0
  010D8F  a1853c           mov ax, word ptr [0x3c85]
  010D92  a3873c           mov word ptr [0x3c87], ax
  010D95  32c0             xor al, al
  010D97  a29c3c           mov byte ptr [0x3c9c], al
  010D9A  a29d3c           mov byte ptr [0x3c9d], al
  010D9D  a14660           mov ax, word ptr [0x6046]
  010DA0  c706de52ffff     mov word ptr [0x52de], 0xffff
  010DA6  3d1300           cmp ax, 0x13
  010DA9  7426             je 0x10dd1
  010DAB  c706de520000     mov word ptr [0x52de], 0
  010DB1  3d0400           cmp ax, 4
  010DB4  7503             jne 0x10db9
  010DB6  eb46             jmp 0x10dfe
  010DB8  90               nop
  010DB9  3d0300           cmp ax, 3
  010DBC  7608             jbe 0x10dc6
  010DBE  3d0700           cmp ax, 7
  010DC1  7403             je 0x10dc6
  010DC3  eb41             jmp 0x10e06
  010DC5  90               nop
  010DC6  b003             mov al, 3
  010DC8  a29c3c           mov byte ptr [0x3c9c], al
  010DCB  a29d3c           mov byte ptr [0x3c9d], al
  010DCE  eb36             jmp 0x10e06
  010DD0  90               nop
  010DD1  a19e3c           mov ax, word ptr [0x3c9e]
  010DD4  0bc0             or ax, ax
  010DD6  7505             jne 0x10ddd
  010DD8  c6069c3c01       mov byte ptr [0x3c9c], 1
  010DDD  b85706           mov ax, 0x657
  010DE0  a3de43           mov word ptr [0x43de], ax
  010DE3  b8e506           mov ax, 0x6e5
  010DE6  a3e043           mov word ptr [0x43e0], ax
  010DE9  b89108           mov ax, 0x891
  010DEC  a3e243           mov word ptr [0x43e2], ax
  010DEF  b81509           mov ax, 0x915
  010DF2  a3e443           mov word ptr [0x43e4], ax
  010DF5  b81b06           mov ax, 0x61b
  010DF8  a3e643           mov word ptr [0x43e6], ax
  010DFB  eb09             jmp 0x10e06
  010DFD  90               nop
  010DFE  c6069c3c01       mov byte ptr [0x3c9c], 1
  010E03  eb36             jmp 0x10e3b
  010E05  90               nop
  010E06  837efe00         cmp word ptr [bp - 2], 0
  010E0A  742f             je 0x10e3b
  010E0C  a1743c           mov ax, word ptr [0x3c74]
  010E0F  0bc0             or ax, ax
  010E11  7519             jne 0x10e2c
  010E13  a1de52           mov ax, word ptr [0x52de]
  010E16  0bc0             or ax, ax
  010E18  7421             je 0x10e3b
  010E1A  8cc8             mov ax, cs
  010E1C  8ec0             mov es, ax
  010E1E  baf803           mov dx, 0x3f8
  010E21  b90100           mov cx, 1
  010E24  b81400           mov ax, 0x14
  010E27  cd33             int 0x33
  010E29  eb10             jmp 0x10e3b
  010E2B  90               nop
  010E2C  8cc8             mov ax, cs
  010E2E  8ec0             mov es, ax
  010E30  bae402           mov dx, 0x2e4
  010E33  b90100           mov cx, 1
  010E36  b81400           mov ax, 0x14
  010E39  cd33             int 0x33
  010E3B  a1c049           mov ax, word ptr [0x49c0]
  010E3E  07               pop es
  010E3F  5a               pop dx
  010E40  59               pop cx
  010E41  5b               pop bx
  010E42  c9               leave
  010E43  cb               retf

; ---- _MOUSE_SET_HOTSPOT  file 0x010E44..0x010E5D  seg 0xF65:0x1f4  (mouse_1.ASM.obj) ----
  010E44  c8000000         enter 0, 0
  010E48  8b4606           mov ax, word ptr [bp + 6]
  010E4B  250f00           and ax, 0xf
  010E4E  8b5e08           mov bx, word ptr [bp + 8]
  010E51  83e30f           and bx, 0xf
  010E54  a3943c           mov word ptr [0x3c94], ax
  010E57  891e963c         mov word ptr [0x3c96], bx
  010E5B  c9               leave
  010E5C  cb               retf

; ---- _MOUSE_TIMING  file 0x010E5D..0x010E72  seg 0xF65:0x20d  (mouse_1.ASM.obj) ----
  010E5D  1e               push ds
  010E5E  56               push si
  010E5F  b84000           mov ax, 0x40
  010E62  8ed8             mov ds, ax
  010E64  be6c00           mov si, 0x6c
  010E67  8b04             mov ax, word ptr [si]
  010E69  8b1c             mov bx, word ptr [si]
  010E6B  3bd8             cmp bx, ax
  010E6D  74fa             je 0x10e69
  010E6F  5e               pop si
  010E70  1f               pop ds
  010E71  cb               retf

; ---- _MOUSE_SCREEN_SWAP  file 0x010E72..0x010ECA  seg 0xF65:0x222  (mouse_1.ASM.obj) ----
  010E72  c8000000         enter 0, 0
  010E76  06               push es
  010E77  56               push si
  010E78  833ec04900       cmp word ptr [0x49c0], 0
  010E7D  7447             je 0x10ec6
  010E7F  9a4e00650f       lcall 0xf65, 0x4e
  010E84  b84000           mov ax, 0x40
  010E87  8ec0             mov es, ax
  010E89  bb4900           mov bx, 0x49
  010E8C  be1000           mov si, 0x10
  010E8F  8b4606           mov ax, word ptr [bp + 6]
  010E92  268a2f           mov ch, byte ptr es:[bx]
  010E95  268a0c           mov cl, byte ptr es:[si]
  010E98  50               push ax
  010E99  8ae1             mov ah, cl
  010E9B  3c03             cmp al, 3
  010E9D  7409             je 0x10ea8
  010E9F  3c07             cmp al, 7
  010EA1  740a             je 0x10ead
  010EA3  32c0             xor al, al
  010EA5  eb08             jmp 0x10eaf
  010EA7  90               nop
  010EA8  b020             mov al, 0x20
  010EAA  eb03             jmp 0x10eaf
  010EAC  90               nop
  010EAD  b030             mov al, 0x30
  010EAF  80e4cf           and ah, 0xcf
  010EB2  0ae0             or ah, al
  010EB4  268824           mov byte ptr es:[si], ah
  010EB7  58               pop ax
  010EB8  50               push ax
  010EB9  268807           mov byte ptr es:[bx], al
  010EBC  6aff             push -1
  010EBE  9a8600650f       lcall 0xf65, 0x86
  010EC3  83c404           add sp, 4
  010EC6  5e               pop si
  010EC7  07               pop es
  010EC8  c9               leave
  010EC9  cb               retf

; ---- _MOUSE_GET_VIDEO_MODE  file 0x010ECA..0x010ECE  seg 0xF65:0x27a  (mouse_1.ASM.obj) ----
  010ECA  a14660           mov ax, word ptr [0x6046]
  010ECD  cb               retf

; ---- _MOUSE_BEGIN_DOUBLE  file 0x010ECE..0x010F13  seg 0xF65:0x27e  (mouse_1.ASM.obj) ----
  010ECE  c8000000         enter 0, 0
  010ED2  833ec04900       cmp word ptr [0x49c0], 0
  010ED7  7438             je 0x10f11
  010ED9  833e743c00       cmp word ptr [0x3c74], 0
  010EDE  7531             jne 0x10f11
  010EE0  8b4606           mov ax, word ptr [bp + 6]
  010EE3  a3763c           mov word ptr [0x3c76], ax
  010EE6  50               push ax
  010EE7  8b4608           mov ax, word ptr [bp + 8]
  010EEA  a3783c           mov word ptr [0x3c78], ax
  010EED  8b460a           mov ax, word ptr [bp + 0xa]
  010EF0  a37a3c           mov word ptr [0x3c7a], ax
  010EF3  8b460c           mov ax, word ptr [bp + 0xc]
  010EF6  a3853c           mov word ptr [0x3c85], ax
  010EF9  a3873c           mov word ptr [0x3c87], ax
  010EFC  c706743cffff     mov word ptr [0x3c74], 0xffff
  010F02  c606893c00       mov byte ptr [0x3c89], 0
  010F07  6aff             push -1
  010F09  9a8600650f       lcall 0xf65, 0x86
  010F0E  83c404           add sp, 4
  010F11  c9               leave
  010F12  cb               retf

; ---- _mouse_double_freedom  file 0x010F13..0x010F1F  seg 0xF65:0x2c3  (mouse_1.ASM.obj) ----
  010F13  c8000000         enter 0, 0
  010F17  8b4606           mov ax, word ptr [bp + 6]
  010F1A  a3873c           mov word ptr [0x3c87], ax
  010F1D  c9               leave
  010F1E  cb               retf

; ---- _MOUSE_END_DOUBLE  file 0x010F1F..0x010F34  seg 0xF65:0x2cf  (mouse_1.ASM.obj) ----
  010F1F  833ec04900       cmp word ptr [0x49c0], 0
  010F24  740d             je 0x10f33
  010F26  833e743c00       cmp word ptr [0x3c74], 0
  010F2B  7406             je 0x10f33
  010F2D  c706743c0000     mov word ptr [0x3c74], 0
  010F33  cb               retf

; ---- _MOUSE_DOUBLE_CURSOR  file 0x010F34..0x010FDA  seg 0xF65:0x2e4  (mouse_1.ASM.obj) ----
  010F34  9c               pushf
  010F35  50               push ax
  010F36  1e               push ds
  010F37  b8e715           mov ax, 0x15e7
  010F3A  8ed8             mov ds, ax
  010F3C  833e833c00       cmp word ptr [0x3c83], 0
  010F41  753c             jne 0x10f7f
  010F43  833e873c00       cmp word ptr [0x3c87], 0
  010F48  7435             je 0x10f7f
  010F4A  a14660           mov ax, word ptr [0x6046]
  010F4D  3b06763c         cmp ax, word ptr [0x3c76]
  010F51  7516             jne 0x10f69
  010F53  33c0             xor ax, ax
  010F55  833e7a3c00       cmp word ptr [0x3c7a], 0
  010F5A  7403             je 0x10f5f
  010F5C  b87802           mov ax, 0x278
  010F5F  3bc8             cmp cx, ax
  010F61  751c             jne 0x10f7f
  010F63  a1783c           mov ax, word ptr [0x3c78]
  010F66  eb26             jmp 0x10f8e
  010F68  90               nop
  010F69  33c0             xor ax, ax
  010F6B  833e7a3c00       cmp word ptr [0x3c7a], 0
  010F70  7503             jne 0x10f75
  010F72  b87e02           mov ax, 0x27e
  010F75  3bc8             cmp cx, ax
  010F77  7506             jne 0x10f7f
  010F79  a1763c           mov ax, word ptr [0x3c76]
  010F7C  eb10             jmp 0x10f8e
  010F7E  90               nop
  010F7F  833ede5200       cmp word ptr [0x52de], 0
  010F84  7405             je 0x10f8b
  010F86  9af803650f       lcall 0xf65, 0x3f8
  010F8B  eb49             jmp 0x10fd6
  010F8D  90               nop
  010F8E  53               push bx
  010F8F  51               push cx
  010F90  52               push dx
  010F91  8a1ed25a         mov bl, byte ptr [0x5ad2]
  010F95  3d0300           cmp ax, 3
  010F98  7415             je 0x10faf
  010F9A  3d0700           cmp ax, 7
  010F9D  7410             je 0x10faf
  010F9F  0bc9             or cx, cx
  010FA1  7406             je 0x10fa9
  010FA3  b90100           mov cx, 1
  010FA6  eb17             jmp 0x10fbf
  010FA8  90               nop
  010FA9  b97d02           mov cx, 0x27d
  010FAC  eb11             jmp 0x10fbf
  010FAE  90               nop
  010FAF  0bc9             or cx, cx
  010FB1  7406             je 0x10fb9
  010FB3  b90800           mov cx, 8
  010FB6  eb07             jmp 0x10fbf
  010FB8  90               nop
  010FB9  b97602           mov cx, 0x276
  010FBC  eb01             jmp 0x10fbf
  010FBE  90               nop
  010FBF  a37c3c           mov word ptr [0x3c7c], ax
  010FC2  881e7e3c         mov byte ptr [0x3c7e], bl
  010FC6  890e7f3c         mov word ptr [0x3c7f], cx
  010FCA  8916813c         mov word ptr [0x3c81], dx
  010FCE  c606893cff       mov byte ptr [0x3c89], 0xff
  010FD3  5a               pop dx
  010FD4  59               pop cx
  010FD5  5b               pop bx
  010FD6  1f               pop ds
  010FD7  58               pop ax
  010FD8  9d               popf
  010FD9  cb               retf

; ---- _mouse_check_double  file 0x010FDA..0x011048  seg 0xF65:0x38a  (mouse_1.ASM.obj) ----
  010FDA  833ec04900       cmp word ptr [0x49c0], 0
  010FDF  7453             je 0x11034
  010FE1  c706833cffff     mov word ptr [0x3c83], 0xffff
  010FE7  803e893c00       cmp byte ptr [0x3c89], 0
  010FEC  7446             je 0x11034
  010FEE  a17c3c           mov ax, word ptr [0x3c7c]
  010FF1  50               push ax
  010FF2  9a2202650f       lcall 0xf65, 0x222
  010FF7  83c402           add sp, 2
  010FFA  8b0e7f3c         mov cx, word ptr [0x3c7f]
  010FFE  8b16813c         mov dx, word ptr [0x3c81]
  011002  51               push cx
  011003  52               push dx
  011004  b80400           mov ax, 4
  011007  cd33             int 0x33
  011009  5a               pop dx
  01100A  59               pop cx
  01100B  e89e01           call 0x111ac
  01100E  890e225e         mov word ptr [0x5e22], cx
  011012  8916245e         mov word ptr [0x5e24], dx
  011016  8a1e7e3c         mov bl, byte ptr [0x3c7e]
  01101A  0adb             or bl, bl
  01101C  7411             je 0x1102f
  01101E  8a1e7e3c         mov bl, byte ptr [0x3c7e]
  011022  3a1ed25a         cmp bl, byte ptr [0x5ad2]
  011026  740c             je 0x11034
  011028  9a4e00650f       lcall 0xf65, 0x4e
  01102D  ebef             jmp 0x1101e
  01102F  9a0700650f       lcall 0xf65, 7
  011034  8b1e853c         mov bx, word ptr [0x3c85]
  011038  891e873c         mov word ptr [0x3c87], bx
  01103C  c606893c00       mov byte ptr [0x3c89], 0
  011041  c706833c0000     mov word ptr [0x3c83], 0
  011047  cb               retf

; ---- _MOUSE_CURSOR  file 0x011048..0x01110F  seg 0xF65:0x3f8  (mouse_1.ASM.obj) ----
  011048  50               push ax
  011049  1e               push ds
  01104A  b8e715           mov ax, 0x15e7
  01104D  8ed8             mov ds, ax
  01104F  833ed64200       cmp word ptr [0x42d6], 0
  011054  7403             je 0x11059
  011056  1f               pop ds
  011057  58               pop ax
  011058  cb               retf
  011059  c706d6420100     mov word ptr [0x42d6], 1
  01105F  8c16d242         mov word ptr [0x42d2], ss
  011063  8926d442         mov word ptr [0x42d4], sp
  011067  8ed0             mov ss, ax
  011069  bcd042           mov sp, 0x42d0
  01106C  53               push bx
  01106D  51               push cx
  01106E  52               push dx
  01106F  06               push es
  011070  56               push si
  011071  57               push di
  011072  55               push bp
  011073  1e               push ds
  011074  9c               pushf
  011075  fc               cld
  011076  803e8e3c00       cmp byte ptr [0x3c8e], 0
  01107B  7410             je 0x1108d
  01107D  c6068f3cff       mov byte ptr [0x3c8f], 0xff
  011082  890ea03c         mov word ptr [0x3ca0], cx
  011086  8916a23c         mov word ptr [0x3ca2], dx
  01108A  eb69             jmp 0x110f5
  01108C  90               nop
  01108D  8bc1             mov ax, cx
  01108F  8a0e9c3c         mov cl, byte ptr [0x3c9c]
  011093  d3e8             shr ax, cl
  011095  803ed25a00       cmp byte ptr [0x5ad2], 0
  01109A  7447             je 0x110e3
  01109C  803ed25a80       cmp byte ptr [0x5ad2], 0x80
  0110A1  7407             je 0x110aa
  0110A3  a3225e           mov word ptr [0x5e22], ax
  0110A6  8916245e         mov word ptr [0x5e24], dx
  0110AA  eb49             jmp 0x110f5
  0110AC  90               nop
  0110AD  50               push ax
  0110AE  1e               push ds
  0110AF  b8e715           mov ax, 0x15e7
  0110B2  8ed8             mov ds, ax
  0110B4  833ed64200       cmp word ptr [0x42d6], 0
  0110B9  7403             je 0x110be
  0110BB  1f               pop ds
  0110BC  58               pop ax
  0110BD  cb               retf
  0110BE  c706d6420100     mov word ptr [0x42d6], 1
  0110C4  8c16d242         mov word ptr [0x42d2], ss
  0110C8  8926d442         mov word ptr [0x42d4], sp
  0110CC  8ed0             mov ss, ax
  0110CE  bcd042           mov sp, 0x42d0
  0110D1  53               push bx
  0110D2  51               push cx
  0110D3  52               push dx
  0110D4  06               push es
  0110D5  56               push si
  0110D6  57               push di
  0110D7  55               push bp
  0110D8  1e               push ds
  0110D9  9c               pushf
  0110DA  fc               cld
  0110DB  8bc1             mov ax, cx
  0110DD  8a0e9c3c         mov cl, byte ptr [0x3c9c]
  0110E1  d3e8             shr ax, cl
  0110E3  50               push ax
  0110E4  52               push dx
  0110E5  e8b201           call 0x1129a
  0110E8  5a               pop dx
  0110E9  59               pop cx
  0110EA  890e225e         mov word ptr [0x5e22], cx
  0110EE  8916245e         mov word ptr [0x5e24], dx
  0110F2  e8ca01           call 0x112bf
  0110F5  9d               popf
  0110F6  1f               pop ds
  0110F7  5d               pop bp
  0110F8  5f               pop di
  0110F9  5e               pop si
  0110FA  07               pop es
  0110FB  5a               pop dx
  0110FC  59               pop cx
  0110FD  5b               pop bx
  0110FE  8e16d242         mov ss, word ptr [0x42d2]
  011102  8b26d442         mov sp, word ptr [0x42d4]
  011106  c706d6420000     mov word ptr [0x42d6], 0
  01110C  1f               pop ds
  01110D  58               pop ax
  01110E  cb               retf

; ---- _mouse_freeze  file 0x01110F..0x011121  seg 0xF65:0x4bf  (mouse_1.ASM.obj) ----
  01110F  833ede5200       cmp word ptr [0x52de], 0
  011114  740a             je 0x11120
  011116  c6068f3c00       mov byte ptr [0x3c8f], 0
  01111B  c6068e3cff       mov byte ptr [0x3c8e], 0xff
  011120  cb               retf

; ---- _mouse_thaw  file 0x011121..0x011150  seg 0xF65:0x4d1  (mouse_1.ASM.obj) ----
  011121  833ede5200       cmp word ptr [0x52de], 0
  011126  7427             je 0x1114f
  011128  b380             mov bl, 0x80
  01112A  861ed25a         xchg byte ptr [0x5ad2], bl
  01112E  8b0ea03c         mov cx, word ptr [0x3ca0]
  011132  8b16a23c         mov dx, word ptr [0x3ca2]
  011136  c6068e3c00       mov byte ptr [0x3c8e], 0
  01113B  803e8f3c00       cmp byte ptr [0x3c8f], 0
  011140  7409             je 0x1114b
  011142  0adb             or bl, bl
  011144  7505             jne 0x1114b
  011146  9a5d04650f       lcall 0xf65, 0x45d
  01114B  881ed25a         mov byte ptr [0x5ad2], bl
  01114F  cb               retf

; ---- _MOUSE_FORCE  file 0x011150..0x0111AC  seg 0xF65:0x500  (mouse_1.ASM.obj) ----
  011150  c8000000         enter 0, 0
  011154  8bc1             mov ax, cx
  011156  8b4e06           mov cx, word ptr [bp + 6]
  011159  d1e1             shl cx, 1
  01115B  8b5608           mov dx, word ptr [bp + 8]
  01115E  50               push ax
  01115F  51               push cx
  011160  52               push dx
  011161  833ede5200       cmp word ptr [0x52de], 0
  011166  7508             jne 0x11170
  011168  9a4e00650f       lcall 0xf65, 0x4e
  01116D  eb06             jmp 0x11175
  01116F  90               nop
  011170  9abf04650f       lcall 0xf65, 0x4bf
  011175  5a               pop dx
  011176  59               pop cx
  011177  58               pop ax
  011178  a3225e           mov word ptr [0x5e22], ax
  01117B  8916245e         mov word ptr [0x5e24], dx
  01117F  833ec04900       cmp word ptr [0x49c0], 0
  011184  7410             je 0x11196
  011186  51               push cx
  011187  52               push dx
  011188  b80400           mov ax, 4
  01118B  cd33             int 0x33
  01118D  5a               pop dx
  01118E  59               pop cx
  01118F  833ede5200       cmp word ptr [0x52de], 0
  011194  7508             jne 0x1119e
  011196  9a0700650f       lcall 0xf65, 7
  01119B  eb0d             jmp 0x111aa
  01119D  90               nop
  01119E  fa               cli
  01119F  9af803650f       lcall 0xf65, 0x3f8
  0111A4  fb               sti
  0111A5  9ad104650f       lcall 0xf65, 0x4d1
  0111AA  c9               leave
  0111AB  cb               retf

; ---- _MOUSE_SCALE_COORD  file 0x0111AC..0x0111CC  seg 0xF65:0x55c  (mouse_1.ASM.obj) ----
  0111AC  50               push ax
  0111AD  8bc1             mov ax, cx
  0111AF  8b0e9c3c         mov cx, word ptr [0x3c9c]
  0111B3  d3e8             shr ax, cl
  0111B5  86e9             xchg cl, ch
  0111B7  d3ea             shr dx, cl
  0111B9  8bc8             mov cx, ax
  0111BB  833ede5200       cmp word ptr [0x52de], 0
  0111C0  7508             jne 0x111ca
  0111C2  890e225e         mov word ptr [0x5e22], cx
  0111C6  8916245e         mov word ptr [0x5e24], dx
  0111CA  58               pop ax
  0111CB  c3               ret

; ---- _mouse_get_status  file 0x0111CC..0x01120F  seg 0xF65:0x57c  (mouse_1.ASM.obj) ----
  0111CC  c8000000         enter 0, 0
  0111D0  33db             xor bx, bx
  0111D2  833ede5200       cmp word ptr [0x52de], 0
  0111D7  740c             je 0x111e5
  0111D9  8b0e225e         mov cx, word ptr [0x5e22]
  0111DD  8b16245e         mov dx, word ptr [0x5e24]
  0111E1  33db             xor bx, bx
  0111E3  51               push cx
  0111E4  52               push dx
  0111E5  833ec04900       cmp word ptr [0x49c0], 0
  0111EA  7408             je 0x111f4
  0111EC  b80300           mov ax, 3
  0111EF  cd33             int 0x33
  0111F1  e8b8ff           call 0x111ac
  0111F4  833ede5200       cmp word ptr [0x52de], 0
  0111F9  7402             je 0x111fd
  0111FB  5a               pop dx
  0111FC  59               pop cx
  0111FD  53               push bx
  0111FE  8b5e06           mov bx, word ptr [bp + 6]
  011201  890f             mov word ptr [bx], cx
  011203  8b5e08           mov bx, word ptr [bp + 8]
  011206  8917             mov word ptr [bx], dx
  011208  58               pop ax
  011209  0b066e4c         or ax, word ptr [0x4c6e]
  01120D  c9               leave
  01120E  cb               retf

; ---- _MOUSE_HORIZ_BOUND  file 0x01120F..0x011227  seg 0xF65:0x5bf  (mouse_1.ASM.obj) ----
  01120F  c8000000         enter 0, 0
  011213  833ec04900       cmp word ptr [0x49c0], 0
  011218  740b             je 0x11225
  01121A  8b4e06           mov cx, word ptr [bp + 6]
  01121D  8b5608           mov dx, word ptr [bp + 8]
  011220  b80700           mov ax, 7
  011223  cd33             int 0x33
  011225  c9               leave
  011226  cb               retf

; ---- _MOUSE_VERT_BOUND  file 0x011227..0x01123F  seg 0xF65:0x5d7  (mouse_1.ASM.obj) ----
  011227  c8000000         enter 0, 0
  01122B  833ec04900       cmp word ptr [0x49c0], 0
  011230  740b             je 0x1123d
  011232  8b4e06           mov cx, word ptr [bp + 6]
  011235  8b5608           mov dx, word ptr [bp + 8]
  011238  b80800           mov ax, 8
  01123B  cd33             int 0x33
  01123D  c9               leave
  01123E  cb               retf

; ---- _MOUSE_CHANGE_CURSOR_BEGIN  file 0x01123F..0x011253  seg 0xF65:0x5ef  (mouse_1.ASM.obj) ----
  01123F  833ede5200       cmp word ptr [0x52de], 0
  011244  740c             je 0x11252
  011246  803ed25a00       cmp byte ptr [0x5ad2], 0
  01124B  7505             jne 0x11252
  01124D  9abf04650f       lcall 0xf65, 0x4bf
  011252  cb               retf

; ---- _MOUSE_CHANGE_CURSOR_END  file 0x011253..0x01129A  seg 0xF65:0x603  (mouse_1.ASM.obj) ----
  011253  06               push es
  011254  57               push di
  011255  56               push si
  011256  833ede5200       cmp word ptr [0x52de], 0
  01125B  740b             je 0x11268
  01125D  803ed25a00       cmp byte ptr [0x5ad2], 0
  011262  7504             jne 0x11268
  011264  ff26e643         jmp word ptr [0x43e6]
  011268  eb2c             jmp 0x11296
  01126A  90               nop
  01126B  e82801           call 0x11396
  01126E  a18a3c           mov ax, word ptr [0x3c8a]
  011271  8ec0             mov es, ax
  011273  8b3e8c3c         mov di, word ptr [0x3c8c]
  011277  bed03d           mov si, 0x3dd0
  01127A  0336ac3c         add si, word ptr [0x3cac]
  01127E  8a26a43c         mov ah, byte ptr [0x3ca4]
  011282  a0a63c           mov al, byte ptr [0x3ca6]
  011285  bb1000           mov bx, 0x10
  011288  ba4001           mov dx, 0x140
  01128B  e8f300           call 0x11381
  01128E  eb01             jmp 0x11291
  011290  90               nop
  011291  9ad104650f       lcall 0xf65, 0x4d1
  011296  5e               pop si
  011297  5f               pop di
  011298  07               pop es
  011299  cb               retf

; ---- _MOUSE_WIPE  file 0x01129A..0x0112BF  seg 0xF65:0x64a  (mouse_1.ASM.obj) ----
  01129A  a18a3c           mov ax, word ptr [0x3c8a]
  01129D  8ec0             mov es, ax
  01129F  8b3e8c3c         mov di, word ptr [0x3c8c]
  0112A3  ff26de43         jmp word ptr [0x43de]
  0112A7  bed03c           mov si, 0x3cd0
  0112AA  0336ac3c         add si, word ptr [0x3cac]
  0112AE  8a26a43c         mov ah, byte ptr [0x3ca4]
  0112B2  a0a63c           mov al, byte ptr [0x3ca6]
  0112B5  bb1000           mov bx, 0x10
  0112B8  ba4001           mov dx, 0x140
  0112BB  e8c300           call 0x11381
  0112BE  c3               ret

; ---- _MOUSE_DRAW  file 0x0112BF..0x011381  seg 0xF65:0x66f  (mouse_1.ASM.obj) ----
  0112BF  33c9             xor cx, cx
  0112C1  890ea83c         mov word ptr [0x3ca8], cx
  0112C5  890eaa3c         mov word ptr [0x3caa], cx
  0112C9  8b0e225e         mov cx, word ptr [0x5e22]
  0112CD  8b16245e         mov dx, word ptr [0x5e24]
  0112D1  2b0e943c         sub cx, word ptr [0x3c94]
  0112D5  7908             jns 0x112df
  0112D7  f7d9             neg cx
  0112D9  890ea83c         mov word ptr [0x3ca8], cx
  0112DD  33c9             xor cx, cx
  0112DF  890e983c         mov word ptr [0x3c98], cx
  0112E3  2b16963c         sub dx, word ptr [0x3c96]
  0112E7  7908             jns 0x112f1
  0112E9  f7da             neg dx
  0112EB  8916aa3c         mov word ptr [0x3caa], dx
  0112EF  33d2             xor dx, dx
  0112F1  89169a3c         mov word ptr [0x3c9a], dx
  0112F5  b81000           mov ax, 0x10
  0112F8  81fab800         cmp dx, 0xb8
  0112FC  7e05             jle 0x11303
  0112FE  b8c800           mov ax, 0xc8
  011301  2bc2             sub ax, dx
  011303  2b06aa3c         sub ax, word ptr [0x3caa]
  011307  a3a43c           mov word ptr [0x3ca4], ax
  01130A  b81000           mov ax, 0x10
  01130D  81f93001         cmp cx, 0x130
  011311  7e05             jle 0x11318
  011313  b84001           mov ax, 0x140
  011316  2bc1             sub ax, cx
  011318  2b06a83c         sub ax, word ptr [0x3ca8]
  01131C  a3a63c           mov word ptr [0x3ca6], ax
  01131F  9a02001411       lcall 0x1114, 2
  011324  8cc0             mov ax, es
  011326  a38a3c           mov word ptr [0x3c8a], ax
  011329  893e8c3c         mov word ptr [0x3c8c], di
  01132D  890e903c         mov word ptr [0x3c90], cx
  011331  ff26e043         jmp word ptr [0x43e0]
  011335  8bf7             mov si, di
  011337  bfd03c           mov di, 0x3cd0
  01133A  b81000           mov ax, 0x10
  01133D  f726aa3c         mul word ptr [0x3caa]
  011341  0306a83c         add ax, word ptr [0x3ca8]
  011345  a3ac3c           mov word ptr [0x3cac], ax
  011348  03f8             add di, ax
  01134A  8a26a43c         mov ah, byte ptr [0x3ca4]
  01134E  a0a63c           mov al, byte ptr [0x3ca6]
  011351  bb4001           mov bx, 0x140
  011354  ba1000           mov dx, 0x10
  011357  06               push es
  011358  1e               push ds
  011359  07               pop es
  01135A  1f               pop ds
  01135B  e82300           call 0x11381
  01135E  06               push es
  01135F  1e               push ds
  011360  07               pop es
  011361  1f               pop ds
  011362  e83100           call 0x11396
  011365  8b3e8c3c         mov di, word ptr [0x3c8c]
  011369  bed03d           mov si, 0x3dd0
  01136C  0336ac3c         add si, word ptr [0x3cac]
  011370  8a26a43c         mov ah, byte ptr [0x3ca4]
  011374  a0a63c           mov al, byte ptr [0x3ca6]
  011377  ba4001           mov dx, 0x140
  01137A  bb1000           mov bx, 0x10
  01137D  e80100           call 0x11381
  011380  c3               ret

; ---- _MOUSE_COPY  file 0x011381..0x011396  seg 0xF65:0x731  (mouse_1.ASM.obj) ----
  011381  32ed             xor ch, ch
  011383  8ac8             mov cl, al
  011385  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  011387  8ac8             mov cl, al
  011389  2bf9             sub di, cx
  01138B  2bf1             sub si, cx
  01138D  03f3             add si, bx
  01138F  03fa             add di, dx
  011391  fecc             dec ah
  011393  75f0             jne 0x11385
  011395  c3               ret

; ---- _MOUSE_OVERLAY_VGA  file 0x011396..0x0113AE  seg 0xF65:0x746  (mouse_1.ASM.obj) ----
  011396  bed842           mov si, 0x42d8
  011399  bfd03d           mov di, 0x3dd0
  01139C  b90001           mov cx, 0x100
  01139F  ac               lodsb al, byte ptr [si]
  0113A0  3cff             cmp al, 0xff
  0113A2  7504             jne 0x113a8
  0113A4  8a8500ff         mov al, byte ptr [di - 0x100]
  0113A8  8805             mov byte ptr [di], al
  0113AA  47               inc di
  0113AB  e2f2             loop 0x1139f
  0113AD  c3               ret

; ---- _mouse_set_work_buffer  file 0x0113AE..0x0113C7  seg 0xF65:0x75e  (mouse_1.ASM.obj) ----
  0113AE  c8000000         enter 0, 0
  0113B2  06               push es
  0113B3  c44606           les ax, ptr [bp + 6]
  0113B6  a3b23c           mov word ptr [0x3cb2], ax
  0113B9  8cc0             mov ax, es
  0113BB  a3b03c           mov word ptr [0x3cb0], ax
  0113BE  8b460a           mov ax, word ptr [bp + 0xa]
  0113C1  a3b43c           mov word ptr [0x3cb4], ax
  0113C4  07               pop es
  0113C5  c9               leave
  0113C6  cb               retf

; ---- _mouse_set_view_port_loc  file 0x0113C7..0x0113F8  seg 0xF65:0x777  (mouse_1.ASM.obj) ----
  0113C7  c8000000         enter 0, 0
  0113CB  06               push es
  0113CC  57               push di
  0113CD  8b4e06           mov cx, word ptr [bp + 6]
  0113D0  890eb63c         mov word ptr [0x3cb6], cx
  0113D4  8b5608           mov dx, word ptr [bp + 8]
  0113D7  8916ba3c         mov word ptr [0x3cba], dx
  0113DB  8b460a           mov ax, word ptr [bp + 0xa]
  0113DE  a3b83c           mov word ptr [0x3cb8], ax
  0113E1  8b460c           mov ax, word ptr [bp + 0xc]
  0113E4  a3bc3c           mov word ptr [0x3cbc], ax
  0113E7  9a02001411       lcall 0x1114, 2
  0113EC  893ec63c         mov word ptr [0x3cc6], di
  0113F0  890ec83c         mov word ptr [0x3cc8], cx
  0113F4  5f               pop di
  0113F5  07               pop es
  0113F6  c9               leave
  0113F7  cb               retf

; ---- _mouse_set_view_port  file 0x0113F8..0x01141D  seg 0xF65:0x7a8  (mouse_1.ASM.obj) ----
  0113F8  c8000000         enter 0, 0
  0113FC  8b5e06           mov bx, word ptr [bp + 6]
  0113FF  891ebe3c         mov word ptr [0x3cbe], bx
  011403  8b4608           mov ax, word ptr [bp + 8]
  011406  a3c03c           mov word ptr [0x3cc0], ax
  011409  8b16b43c         mov dx, word ptr [0x3cb4]
  01140D  f7e2             mul dx
  01140F  03c3             add ax, bx
  011411  a3c23c           mov word ptr [0x3cc2], ax
  011414  0306b23c         add ax, word ptr [0x3cb2]
  011418  a3c43c           mov word ptr [0x3cc4], ax
  01141B  c9               leave
  01141C  cb               retf

; ---- _mouse_refresh_view_port  file 0x01141D..0x011553  seg 0xF65:0x7cd  (mouse_1.ASM.obj) ----
  01141D  c8120000         enter 0x12, 0
  011421  06               push es
  011422  57               push di
  011423  56               push si
  011424  833ede5200       cmp word ptr [0x52de], 0
  011429  745a             je 0x11485
  01142B  803ed25a00       cmp byte ptr [0x5ad2], 0
  011430  7553             jne 0x11485
  011432  be1000           mov si, 0x10
  011435  2b36a83c         sub si, word ptr [0x3ca8]
  011439  bf1000           mov di, 0x10
  01143C  2b3eaa3c         sub di, word ptr [0x3caa]
  011440  8b0e983c         mov cx, word ptr [0x3c98]
  011444  3b0eb83c         cmp cx, word ptr [0x3cb8]
  011448  7f3b             jg 0x11485
  01144A  8bd1             mov dx, cx
  01144C  03d6             add dx, si
  01144E  4a               dec dx
  01144F  3b16b63c         cmp dx, word ptr [0x3cb6]
  011453  7c30             jl 0x11485
  011455  a19a3c           mov ax, word ptr [0x3c9a]
  011458  3b06bc3c         cmp ax, word ptr [0x3cbc]
  01145C  7f27             jg 0x11485
  01145E  8bd8             mov bx, ax
  011460  03df             add bx, di
  011462  4b               dec bx
  011463  3b1eba3c         cmp bx, word ptr [0x3cba]
  011467  7c1c             jl 0x11485
  011469  2b06ba3c         sub ax, word ptr [0x3cba]
  01146D  7c1c             jl 0x1148b
  01146F  8946f6           mov word ptr [bp - 0xa], ax
  011472  c746fe0000       mov word ptr [bp - 2], 0
  011477  2b1ebc3c         sub bx, word ptr [0x3cbc]
  01147B  7f22             jg 0x1149f
  01147D  8bc7             mov ax, di
  01147F  8846fa           mov byte ptr [bp - 6], al
  011482  eb22             jmp 0x114a6
  011484  90               nop
  011485  b80000           mov ax, 0
  011488  e9c300           jmp 0x1154e
  01148B  8bd8             mov bx, ax
  01148D  f7d8             neg ax
  01148F  8946fe           mov word ptr [bp - 2], ax
  011492  03df             add bx, di
  011494  885efa           mov byte ptr [bp - 6], bl
  011497  c746f60000       mov word ptr [bp - 0xa], 0
  01149C  eb08             jmp 0x114a6
  01149E  90               nop
  01149F  8bc7             mov ax, di
  0114A1  2bc3             sub ax, bx
  0114A3  8846fa           mov byte ptr [bp - 6], al
  0114A6  2b0eb63c         sub cx, word ptr [0x3cb6]
  0114AA  7c16             jl 0x114c2
  0114AC  894ef4           mov word ptr [bp - 0xc], cx
  0114AF  c746fc0000       mov word ptr [bp - 4], 0
  0114B4  2b16b83c         sub dx, word ptr [0x3cb8]
  0114B8  7f1c             jg 0x114d6
  0114BA  8bce             mov cx, si
  0114BC  884ef8           mov byte ptr [bp - 8], cl
  0114BF  eb1c             jmp 0x114dd
  0114C1  90               nop
  0114C2  8bd1             mov dx, cx
  0114C4  f7d9             neg cx
  0114C6  894efc           mov word ptr [bp - 4], cx
  0114C9  03d6             add dx, si
  0114CB  8856f8           mov byte ptr [bp - 8], dl
  0114CE  c746f40000       mov word ptr [bp - 0xc], 0
  0114D3  eb08             jmp 0x114dd
  0114D5  90               nop
  0114D6  8bce             mov cx, si
  0114D8  2bca             sub cx, dx
  0114DA  884ef8           mov byte ptr [bp - 8], cl
  0114DD  ff26e243         jmp word ptr [0x43e2]
  0114E1  8b46f6           mov ax, word ptr [bp - 0xa]
  0114E4  8b16b43c         mov dx, word ptr [0x3cb4]
  0114E8  f7e2             mul dx
  0114EA  8b76f4           mov si, word ptr [bp - 0xc]
  0114ED  03f0             add si, ax
  0114EF  0336c43c         add si, word ptr [0x3cc4]
  0114F3  8b46fe           mov ax, word ptr [bp - 2]
  0114F6  ba1000           mov dx, 0x10
  0114F9  f7e2             mul dx
  0114FB  bfd03c           mov di, 0x3cd0
  0114FE  033eac3c         add di, word ptr [0x3cac]
  011502  03f8             add di, ax
  011504  037efc           add di, word ptr [bp - 4]
  011507  8b1eb43c         mov bx, word ptr [0x3cb4]
  01150B  ba1000           mov dx, 0x10
  01150E  8a66fa           mov ah, byte ptr [bp - 6]
  011511  8a46f8           mov al, byte ptr [bp - 8]
  011514  56               push si
  011515  57               push di
  011516  50               push ax
  011517  8b0eb03c         mov cx, word ptr [0x3cb0]
  01151B  8ed9             mov ds, cx
  01151D  1e               push ds
  01151E  b9e715           mov cx, 0x15e7
  011521  8ec1             mov es, cx
  011523  e85bfe           call 0x11381
  011526  06               push es
  011527  1f               pop ds
  011528  e86bfe           call 0x11396
  01152B  07               pop es
  01152C  58               pop ax
  01152D  5e               pop si
  01152E  5f               pop di
  01152F  a3ca3c           mov word ptr [0x3cca], ax
  011532  8936cc3c         mov word ptr [0x3ccc], si
  011536  893ece3c         mov word ptr [0x3cce], di
  01153A  81c60001         add si, 0x100
  01153E  bb1000           mov bx, 0x10
  011541  8b16b43c         mov dx, word ptr [0x3cb4]
  011545  e839fe           call 0x11381
  011548  b8ffff           mov ax, 0xffff
  01154B  eb01             jmp 0x1154e
  01154D  90               nop
  01154E  5e               pop si
  01154F  5f               pop di
  011550  07               pop es
  011551  c9               leave
  011552  cb               retf

; ---- _mouse_refresh_done  file 0x011553..0x01157C  seg 0xF65:0x903  (mouse_1.ASM.obj) ----
  011553  06               push es
  011554  57               push di
  011555  56               push si
  011556  a1ca3c           mov ax, word ptr [0x3cca]
  011559  8b36cc3c         mov si, word ptr [0x3ccc]
  01155D  8b3ece3c         mov di, word ptr [0x3cce]
  011561  ff26e443         jmp word ptr [0x43e4]
  011565  8b0eb03c         mov cx, word ptr [0x3cb0]
  011569  8ec1             mov es, cx
  01156B  bb1000           mov bx, 0x10
  01156E  8b16b43c         mov dx, word ptr [0x3cb4]
  011572  e80cfe           call 0x11381
  011575  eb01             jmp 0x11578
  011577  90               nop
  011578  5e               pop si
  011579  5f               pop di
  01157A  07               pop es
  01157B  cb               retf

; ---- _MOUSE_DISABLE_SCALE  file 0x01157C..0x011583  seg 0xF65:0x92c  (mouse_1.ASM.obj) ----
  01157C  c7069e3cffff     mov word ptr [0x3c9e], 0xffff
  011582  cb               retf

; ---- _MOUSE_HARD_CURSOR_MODE  file 0x011583..0x011605  seg 0xF65:0x933  (mouse_1.ASM.obj) ----
  011583  c8000000         enter 0, 0
  011587  1e               push ds
  011588  06               push es
  011589  56               push si
  01158A  57               push di
  01158B  8cd8             mov ax, ds
  01158D  8ec0             mov es, ax
  01158F  bed842           mov si, 0x42d8
  011592  bfd842           mov di, 0x42d8
  011595  b90001           mov cx, 0x100
  011598  8b5e06           mov bx, word ptr [bp + 6]
  01159B  83fb01           cmp bx, 1
  01159E  7408             je 0x115a8
  0115A0  83fb02           cmp bx, 2
  0115A3  7419             je 0x115be
  0115A5  eb3f             jmp 0x115e6
  0115A7  90               nop
  0115A8  ac               lodsb al, byte ptr [si]
  0115A9  3c07             cmp al, 7
  0115AB  7502             jne 0x115af
  0115AD  b002             mov al, 2
  0115AF  3c0f             cmp al, 0xf
  0115B1  7502             jne 0x115b5
  0115B3  b003             mov al, 3
  0115B5  aa               stosb byte ptr es:[di], al
  0115B6  e2f0             loop 0x115a8
  0115B8  ba0200           mov dx, 2
  0115BB  eb17             jmp 0x115d4
  0115BD  90               nop
  0115BE  ac               lodsb al, byte ptr [si]
  0115BF  3c07             cmp al, 7
  0115C1  7502             jne 0x115c5
  0115C3  b0fd             mov al, 0xfd
  0115C5  3c0f             cmp al, 0xf
  0115C7  7502             jne 0x115cb
  0115C9  b0fe             mov al, 0xfe
  0115CB  aa               stosb byte ptr es:[di], al
  0115CC  e2f0             loop 0x115be
  0115CE  bafd00           mov dx, 0xfd
  0115D1  eb01             jmp 0x115d4
  0115D3  90               nop
  0115D4  bed843           mov si, 0x43d8
  0115D7  c47e08           les di, ptr [bp + 8]
  0115DA  b80300           mov ax, 3
  0115DD  f7e2             mul dx
  0115DF  03f8             add di, ax
  0115E1  b90600           mov cx, 6
  0115E4  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  0115E6  5f               pop di
  0115E7  5e               pop si
  0115E8  07               pop es
  0115E9  1f               pop ds
  0115EA  c9               leave
  0115EB  cb               retf
  0115EC  0000             add byte ptr [bx + si], al
  0115EE  0000             add byte ptr [bx + si], al
  0115F0  0000             add byte ptr [bx + si], al
  0115F2  0000             add byte ptr [bx + si], al
  0115F4  0000             add byte ptr [bx + si], al
  0115F6  0000             add byte ptr [bx + si], al
  0115F8  050109           add ax, 0x901
  0115FB  40               inc ax
  0115FC  0410             add al, 0x10
  0115FE  0800             or byte ptr [bx + si], al
  011600  06               push es
  011601  020a             add cl, byte ptr [bp + si]
  011603  1020             adc byte ptr [bx + si], ah
