; ============================================================================
; func_044E7C_unknown
; Region   : overlay
; Bytes    : file 0x044E7C..0x044F62  (230 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044E7C  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
044E80  56                    PUSH   si ; STACK_PUSH
044E81  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044E84  26 FF 77 2A           PUSH   word ptr es:[bx + 0x2a] ; PUSH_GLOBAL
044E88  26 FF 77 28           PUSH   word ptr es:[bx + 0x28] ; PUSH_GLOBAL
044E8C  E8 B1 F6              CALL   0x44540 ; CALL_NEAR
044E8F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
044E92  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044E95  26 03 47 04           ADD    ax, word ptr es:[bx + 4] ; ARITH
044E99  40                    INC    ax ; ARITH
044E9A  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
044E9D  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
044EA1  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
044EA5  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
044EA9  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
044EAD  50                    PUSH   ax ; STACK_PUSH
044EAE  6A 00                 PUSH   0 ; STACK_PUSH
044EB0  6A 00                 PUSH   0 ; STACK_PUSH
044EB2  68 40 01              PUSH   0x140 ; PUSH_CONST
044EB5  26 8A 47 0E           MOV    al, byte ptr es:[bx + 0xe] ; MOV
044EB9  50                    PUSH   ax ; STACK_PUSH
044EBA  26 8A 47 10           MOV    al, byte ptr es:[bx + 0x10] ; MOV
044EBE  50                    PUSH   ax ; STACK_PUSH
044EBF  6A 00                 PUSH   0 ; STACK_PUSH
044EC1  6A 00                 PUSH   0 ; STACK_PUSH
044EC3  2B C0                 SUB    ax, ax ; ARITH
044EC5  99                    CDQ ; ARITH
044EC6  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
044EC9  E8 BE F6              CALL   0x4458a ; CALL_NEAR
044ECC  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044ECF  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38] ; MOV
044ED3  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a] ; MOV
044ED7  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
044EDA  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
044EDD  0B D0                 OR     dx, ax ; LOGIC
044EDF  75 03                 JNE    0x44ee4 ; CJUMP
044EE1  E9 A5 00              JMP    0x44f89 ; JUMP
044EE4  C4 5E F4              LES    bx, ptr [bp - 0xc] ; MOV_FAR
044EE7  26 F6 47 0C 01        TEST   byte ptr es:[bx + 0xc], 1 ; LOGIC
044EEC  74 03                 JE     0x44ef1 ; CJUMP
044EEE  E9 80 00              JMP    0x44f71 ; JUMP
044EF1  26 8B 47 02           MOV    ax, word ptr es:[bx + 2] ; MOV
044EF5  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
044EF8  8C C0                 MOV    ax, es ; MOV
044EFA  3B 5E 0A              CMP    bx, word ptr [bp + 0xa] ; CMP
044EFD  75 45                 JNE    0x44f44 ; CJUMP
044EFF  3B 46 0C              CMP    ax, word ptr [bp + 0xc] ; CMP
044F02  75 40                 JNE    0x44f44 ; CJUMP
044F04  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
044F08  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
044F0C  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
044F10  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
044F14  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
044F17  6A 00                 PUSH   0 ; STACK_PUSH
044F19  6A 00                 PUSH   0 ; STACK_PUSH
044F1B  68 40 01              PUSH   0x140 ; PUSH_CONST
044F1E  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044F21  26 8A 47 1A           MOV    al, byte ptr es:[bx + 0x1a] ; MOV
044F25  50                    PUSH   ax ; STACK_PUSH
044F26  26 8A 47 1C           MOV    al, byte ptr es:[bx + 0x1c] ; MOV
044F2A  50                    PUSH   ax ; STACK_PUSH
044F2B  6A 00                 PUSH   0 ; STACK_PUSH
044F2D  6A 00                 PUSH   0 ; STACK_PUSH
044F2F  26 8B 5F 0A           MOV    bx, word ptr es:[bx + 0xa] ; MOV
044F33  D1 E3                 SHL    bx, 1 ; LOGIC
044F35  C4 76 F4              LES    si, ptr [bp - 0xc] ; MOV_FAR
044F38  26 03 5C 04           ADD    bx, word ptr es:[si + 4] ; ARITH
044F3C  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
044F3F  2B D2                 SUB    dx, dx ; ARITH
044F41  E8 46 F6              CALL   0x4458a ; CALL_NEAR
044F44  6A 00                 PUSH   0 ; STACK_PUSH
044F46  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044F49  26 FF 77 04           PUSH   word ptr es:[bx + 4] ; STACK_PUSH
044F4D  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa] ; MOV
044F51  03 46 FE              ADD    ax, word ptr [bp - 2] ; ARITH
044F54  50                    PUSH   ax ; STACK_PUSH
044F55  C4 76 F4              LES    si, ptr [bp - 0xc] ; MOV_FAR
044F58  26 FF 74 10           PUSH   word ptr es:[si + 0x10] ; PUSH_GLOBAL
044F5C  26 FF 74 0E           PUSH   word ptr es:[si + 0xe] ; PUSH_GLOBAL
044F60  8B C3                 MOV    ax, bx ; MOV
