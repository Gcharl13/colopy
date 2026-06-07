; ============================================================================
; func_06DE6E_unknown
; Region   : overlay
; Bytes    : file 0x06DE6E..0x06E008  (410 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06DE6E  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
06DE72  53                    PUSH   bx ; STACK_PUSH
06DE73  52                    PUSH   dx ; STACK_PUSH
06DE74  50                    PUSH   ax ; STACK_PUSH
06DE75  56                    PUSH   si ; STACK_PUSH
06DE76  C7 06 62 1F 00 00     MOV    word ptr [0x1f62], 0 ; GLOBAL_LOAD
06DE7C  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06DE7F  26 8B 47 5E           MOV    ax, word ptr es:[bx + 0x5e] ; MOV
06DE83  26 0B 47 5C           OR     ax, word ptr es:[bx + 0x5c] ; LOGIC
06DE87  75 03                 JNE    0x6de8c ; CJUMP
06DE89  E9 36 02              JMP    0x6e0c2 ; JUMP
06DE8C  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c] ; MOV
06DE90  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e] ; MOV
06DE94  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06DE97  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
06DE9A  C4 5E F4              LES    bx, ptr [bp - 0xc] ; MOV_FAR
06DE9D  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12] ; MOV
06DEA1  26 0B 47 10           OR     ax, word ptr es:[bx + 0x10] ; LOGIC
06DEA5  74 0B                 JE     0x6deb2 ; CJUMP
06DEA7  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10] ; MOV
06DEAB  26 8B 57 12           MOV    dx, word ptr es:[bx + 0x12] ; MOV
06DEAF  EB E3                 JMP    0x6de94 ; JUMP
06DEB1  90                    NOP ; NOP
06DEB2  26 8B 47 02           MOV    ax, word ptr es:[bx + 2] ; MOV
06DEB6  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
06DEB9  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06DEBC  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c] ; MOV
06DEC0  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e] ; MOV
06DEC4  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06DEC7  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
06DECA  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa] ; MOV
06DECE  8B C8                 MOV    cx, ax ; MOV
06DED0  25 10 00              AND    ax, 0x10 ; LOGIC
06DED3  3D 01 00              CMP    ax, 1 ; CMP
06DED6  1B C0                 SBB    ax, ax ; ARITH
06DED8  25 03 00              AND    ax, 3 ; LOGIC
06DEDB  8B D0                 MOV    dx, ax ; MOV
06DEDD  26 03 47 10           ADD    ax, word ptr es:[bx + 0x10] ; ARITH
06DEE1  26 03 57 12           ADD    dx, word ptr es:[bx + 0x12] ; ARITH
06DEE5  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06DEE8  26 03 47 48           ADD    ax, word ptr es:[bx + 0x48] ; ARITH
06DEEC  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06DEEF  26 03 57 46           ADD    dx, word ptr es:[bx + 0x46] ; ARITH
06DEF3  F6 C1 02              TEST   cl, 2 ; LOGIC
06DEF6  74 08                 JE     0x6df00 ; CJUMP
06DEF8  C7 46 EE 10 00        MOV    word ptr [bp - 0x12], 0x10 ; LOCAL_STORE
06DEFD  EB 1C                 JMP    0x6df1b ; JUMP
06DEFF  90                    NOP ; NOP
06DF00  C4 5E F4              LES    bx, ptr [bp - 0xc] ; MOV_FAR
06DF03  26 8B 77 04           MOV    si, word ptr es:[bx + 4] ; MOV
06DF07  8B C6                 MOV    ax, si ; MOV
06DF09  D1 E6                 SHL    si, 1 ; LOGIC
06DF0B  03 F0                 ADD    si, ax ; ARITH
06DF0D  C1 E6 02              SHL    si, 2 ; LOGIC
06DF10  26 C4 5F 0C           LES    bx, ptr es:[bx + 0xc] ; MOV_FAR
06DF14  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
06DF18  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
06DF1B  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
06DF1E  C4 5E F4              LES    bx, ptr [bp - 0xc] ; MOV_FAR
06DF21  26 2B 07              SUB    ax, word ptr es:[bx] ; ARITH
06DF24  40                    INC    ax ; ARITH
06DF25  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0 ; CMP
06DF29  74 47                 JE     0x6df72 ; CJUMP
06DF2B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06DF2F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06DF33  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06DF37  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06DF3B  40                    INC    ax ; ARITH
06DF3C  40                    INC    ax ; ARITH
06DF3D  50                    PUSH   ax ; STACK_PUSH
06DF3E  8C C0                 MOV    ax, es ; MOV
06DF40  C4 76 04              LES    si, ptr [bp + 4] ; MOV_FAR
06DF43  26 FF 74 10           PUSH   word ptr es:[si + 0x10] ; PUSH_GLOBAL
06DF47  26 FF 74 12           PUSH   word ptr es:[si + 0x12] ; PUSH_GLOBAL
06DF4B  26 FF 74 14           PUSH   word ptr es:[si + 0x14] ; PUSH_GLOBAL
06DF4F  26 8A 4C 3C           MOV    cl, byte ptr es:[si + 0x3c] ; MOV
06DF53  51                    PUSH   cx ; STACK_PUSH
06DF54  26 8A 4C 3E           MOV    cl, byte ptr es:[si + 0x3e] ; MOV
06DF58  51                    PUSH   cx ; STACK_PUSH
06DF59  6A 00                 PUSH   0 ; STACK_PUSH
06DF5B  6A 00                 PUSH   0 ; STACK_PUSH
06DF5D  8E C0                 MOV    es, ax ; MOV
06DF5F  26 8B 17              MOV    dx, word ptr es:[bx] ; MOV
06DF62  03 56 FC              ADD    dx, word ptr [bp - 4] ; ARITH
06DF65  4A                    DEC    dx ; ARITH
06DF66  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
06DF69  48                    DEC    ax ; ARITH
06DF6A  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
06DF6D  43                    INC    bx ; ARITH
06DF6E  43                    INC    bx ; ARITH
06DF6F  E8 1A E2              CALL   0x6c18c ; CALL_NEAR
06DF72  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
06DF75  0B 46 F4              OR     ax, word ptr [bp - 0xc] ; LOGIC
06DF78  75 03                 JNE    0x6df7d ; CJUMP
06DF7A  E9 29 01              JMP    0x6e0a6 ; JUMP
06DF7D  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06DF80  26 F6 47 0A 02        TEST   byte ptr es:[bx + 0xa], 2 ; LOGIC
06DF85  74 1F                 JE     0x6dfa6 ; CJUMP
06DF87  C4 5E F4              LES    bx, ptr [bp - 0xc] ; MOV_FAR
06DF8A  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
06DF8D  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
06DF90  50                    PUSH   ax ; STACK_PUSH
06DF91  6A 10                 PUSH   0x10 ; PUSH_CONST
06DF93  6A 64                 PUSH   0x64 ; PUSH_CONST
06DF95  26 8B 47 04           MOV    ax, word ptr es:[bx + 4] ; MOV
06DF99  2B D2                 SUB    dx, dx ; ARITH
06DF9B  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
06DF9E  9A BC 02 1F 18        LCALL  0x181f, 0x2bc ; THUNK -> 0x012B:0x01BA (thunk @file 0x01A8AC type B) overlay @file 0x023724
06DFA3  EB 23                 JMP    0x6dfc8 ; JUMP
06DFA5  90                    NOP ; NOP
06DFA6  C4 5E F4              LES    bx, ptr [bp - 0xc] ; MOV_FAR
06DFA9  26 FF 77 0E           PUSH   word ptr es:[bx + 0xe] ; PUSH_GLOBAL
06DFAD  26 FF 77 0C           PUSH   word ptr es:[bx + 0xc] ; PUSH_GLOBAL
06DFB1  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
06DFB4  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
06DFB7  50                    PUSH   ax ; STACK_PUSH
06DFB8  26 8B 47 04           MOV    ax, word ptr es:[bx + 4] ; MOV
06DFBC  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06DFC0  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
06DFC3  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06DFC8  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
06DFCB  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
06DFCE  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06DFD1  26 39 47 50           CMP    word ptr es:[bx + 0x50], ax ; CMP
06DFD5  75 50                 JNE    0x6e027 ; CJUMP
06DFD7  26 39 57 52           CMP    word ptr es:[bx + 0x52], dx ; CMP
06DFDB  75 4A                 JNE    0x6e027 ; CJUMP
06DFDD  83 7E E8 00           CMP    word ptr [bp - 0x18], 0 ; CMP
06DFE1  74 44                 JE     0x6e027 ; CJUMP
06DFE3  26 F6 47 0A 80        TEST   byte ptr es:[bx + 0xa], 0x80 ; LOGIC
06DFE8  74 3D                 JE     0x6e027 ; CJUMP
06DFEA  26 8B 4F 66           MOV    cx, word ptr es:[bx + 0x66] ; MOV
06DFEE  26 0B 4F 64           OR     cx, word ptr es:[bx + 0x64] ; LOGIC
06DFF2  74 33                 JE     0x6e027 ; CJUMP
06DFF4  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06DFF8  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06DFFC  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06E000  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06E004  8E C2                 MOV    es, dx ; MOV
06E006  8B D8                 MOV    bx, ax ; MOV
