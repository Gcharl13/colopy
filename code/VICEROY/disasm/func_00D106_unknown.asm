; ============================================================================
; func_00D106_unknown
; Region   : load_image
; Bytes    : file 0x00D106..0x00D1A4  (158 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D106  55                    PUSH   bp ; STACK_PUSH
00D107  8B EC                 MOV    bp, sp ; MOV
00D109  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
00D10C  A3 F8 07              MOV    word ptr [0x7f8], ax ; GLOBAL_LOAD
00D10F  A1 EA 07              MOV    ax, word ptr [0x7ea] ; GLOBAL_LOAD
00D112  A3 FA 07              MOV    word ptr [0x7fa], ax ; GLOBAL_LOAD
00D115  68 EA 07              PUSH   0x7ea ; PUSH_CONST
00D118  68 E8 07              PUSH   0x7e8 ; PUSH_CONST
00D11B  9A 8B 03 58 0A        LCALL  0xa58, 0x38b ; LCALL
00D120  8B E5                 MOV    sp, bp ; MOV
00D122  A3 E6 07              MOV    word ptr [0x7e6], ax ; GLOBAL_LOAD
00D125  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
00D12A  A3 FC 07              MOV    word ptr [0x7fc], ax ; GLOBAL_LOAD
00D12D  89 16 FE 07           MOV    word ptr [0x7fe], dx ; GLOBAL_LOAD
00D131  8B 1E E6 07           MOV    bx, word ptr [0x7e6] ; GLOBAL_LOAD
00D135  83 3E F2 07 00        CMP    word ptr [0x7f2], 0 ; CMP
00D13A  74 0C                 JE     0xd148 ; CJUMP
00D13C  0B DB                 OR     bx, bx ; LOGIC
00D13E  75 08                 JNE    0xd148 ; CJUMP
00D140  C7 06 F4 07 01 00     MOV    word ptr [0x7f4], 1 ; GLOBAL_LOAD
00D146  EB 06                 JMP    0xd14e ; JUMP
00D148  C7 06 F4 07 00 00     MOV    word ptr [0x7f4], 0 ; GLOBAL_LOAD
00D14E  0B DB                 OR     bx, bx ; LOGIC
00D150  74 0C                 JE     0xd15e ; CJUMP
00D152  83 3E EE 07 00        CMP    word ptr [0x7ee], 0 ; CMP
00D157  75 05                 JNE    0xd15e ; CJUMP
00D159  BA 01 00              MOV    dx, 1 ; MOV
00D15C  EB 02                 JMP    0xd160 ; JUMP
00D15E  2B D2                 SUB    dx, dx ; ARITH
00D160  89 1E EE 07           MOV    word ptr [0x7ee], bx ; GLOBAL_LOAD
00D164  0B DB                 OR     bx, bx ; LOGIC
00D166  75 04                 JNE    0xd16c ; CJUMP
00D168  89 1E F2 07           MOV    word ptr [0x7f2], bx ; GLOBAL_LOAD
00D16C  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
00D16F  39 06 F8 07           CMP    word ptr [0x7f8], ax ; CMP
00D173  75 19                 JNE    0xd18e ; CJUMP
00D175  A1 EA 07              MOV    ax, word ptr [0x7ea] ; GLOBAL_LOAD
00D178  39 06 FA 07           CMP    word ptr [0x7fa], ax ; CMP
00D17C  75 10                 JNE    0xd18e ; CJUMP
00D17E  0B D2                 OR     dx, dx ; LOGIC
00D180  75 0C                 JNE    0xd18e ; CJUMP
00D182  39 16 F4 07           CMP    word ptr [0x7f4], dx ; CMP
00D186  75 06                 JNE    0xd18e ; CJUMP
00D188  89 16 F0 07           MOV    word ptr [0x7f0], dx ; GLOBAL_LOAD
00D18C  EB 06                 JMP    0xd194 ; JUMP
00D18E  C7 06 F0 07 01 00     MOV    word ptr [0x7f0], 1 ; GLOBAL_LOAD
00D194  89 16 EC 07           MOV    word ptr [0x7ec], dx ; GLOBAL_LOAD
00D198  0B D2                 OR     dx, dx ; LOGIC
00D19A  74 15                 JE     0xd1b1 ; CJUMP
00D19C  C7 06 F2 07 01 00     MOV    word ptr [0x7f2], 1 ; GLOBAL_LOAD
00D1A2  8A C3                 MOV    al, bl ; MOV
