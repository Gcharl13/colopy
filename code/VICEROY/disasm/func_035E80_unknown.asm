; ============================================================================
; func_035E80_unknown
; Region   : overlay
; Bytes    : file 0x035E80..0x035F9A  (282 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035E80  C8 1C 00 00           ENTER  0x1c, 0 ; PROLOGUE
035E84  57                    PUSH   di ; STACK_PUSH
035E85  56                    PUSH   si ; STACK_PUSH
035E86  2B C0                 SUB    ax, ax ; ARITH
035E88  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
035E8B  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
035E8E  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
035E91  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
035E94  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
035E97  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
035E9A  3D 04 00              CMP    ax, 4 ; CMP
035E9D  7C 03                 JL     0x35ea2 ; CJUMP
035E9F  E9 92 02              JMP    0x36134 ; JUMP
035EA2  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
035EA5  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
035EAA  74 03                 JE     0x35eaf ; CJUMP
035EAC  E9 85 02              JMP    0x36134 ; JUMP
035EAF  6A 13                 PUSH   0x13 ; PUSH_CONST
035EB1  50                    PUSH   ax ; STACK_PUSH
035EB2  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
035EB7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
035EBA  0B C0                 OR     ax, ax ; LOGIC
035EBC  74 03                 JE     0x35ec1 ; CJUMP
035EBE  E9 73 02              JMP    0x36134 ; JUMP
035EC1  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
035EC4  2A E4                 SUB    ah, ah ; ARITH
035EC6  40                    INC    ax ; ARITH
035EC7  40                    INC    ax ; ARITH
035EC8  F7 2E 8E 53           IMUL   word ptr [0x538e] ; ARITH
035ECC  3D 20 03              CMP    ax, 0x320 ; CMP
035ECF  7D 03                 JGE    0x35ed4 ; CJUMP
035ED1  E9 60 02              JMP    0x36134 ; JUMP
035ED4  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
035ED9  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
035EDC  39 46 E6              CMP    word ptr [bp - 0x1a], ax ; CMP
035EDF  75 03                 JNE    0x35ee4 ; CJUMP
035EE1  E9 85 00              JMP    0x35f69 ; JUMP
035EE4  39 06 D2 53           CMP    word ptr [0x53d2], ax ; CMP
035EE8  74 7F                 JE     0x35f69 ; CJUMP
035EEA  69 D8 3C 01           IMUL   bx, ax, 0x13c ; ARITH
035EEE  F6 87 08 88 04        TEST   byte ptr [bx - 0x77f8], 4 ; LOGIC
035EF3  75 74                 JNE    0x35f69 ; CJUMP
035EF5  50                    PUSH   ax ; STACK_PUSH
035EF6  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
035EF9  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
035EFE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
035F01  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
035F04  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
035F07  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
035F0C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
035F0F  A8 40                 TEST   al, 0x40 ; LOGIC
035F11  74 03                 JE     0x35f16 ; CJUMP
035F13  FF 46 E4              INC    word ptr [bp - 0x1c] ; ARITH
035F16  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
035F19  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
035F1C  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
035F21  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
035F24  24 60                 AND    al, 0x60 ; LOGIC
035F26  3C 20                 CMP    al, 0x20 ; CMP
035F28  75 3F                 JNE    0x35f69 ; CJUMP
035F2A  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
035F2D  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
035F32  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
035F35  C1 E0 04              SHL    ax, 4 ; LOGIC
035F38  05 E6 94              ADD    ax, 0x94e6 ; ARITH
035F3B  74 23                 JE     0x35f60 ; CJUMP
035F3D  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
035F40  C1 E0 04              SHL    ax, 4 ; LOGIC
035F43  05 E6 94              ADD    ax, 0x94e6 ; ARITH
035F46  74 18                 JE     0x35f60 ; CJUMP
035F48  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
035F4B  D1 E3                 SHL    bx, 1 ; LOGIC
035F4D  8B 87 1C 94           MOV    ax, word ptr [bx - 0x6be4] ; MOV
035F51  01 46 F8              ADD    word ptr [bp - 8], ax ; ARITH
035F54  8B 5E E6              MOV    bx, word ptr [bp - 0x1a] ; LOCAL_LOAD
035F57  D1 E3                 SHL    bx, 1 ; LOGIC
035F59  8B 87 1C 94           MOV    ax, word ptr [bx - 0x6be4] ; MOV
035F5D  01 46 F0              ADD    word ptr [bp - 0x10], ax ; ARITH
035F60  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
035F63  83 7E FC 0F           CMP    word ptr [bp - 4], 0xf ; CMP
035F67  7C C9                 JL     0x35f32 ; CJUMP
035F69  FF 46 EE              INC    word ptr [bp - 0x12] ; ARITH
035F6C  83 7E EE 04           CMP    word ptr [bp - 0x12], 4 ; CMP
035F70  7D 03                 JGE    0x35f75 ; CJUMP
035F72  E9 64 FF              JMP    0x35ed9 ; JUMP
035F75  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
035F79  75 03                 JNE    0x35f7e ; CJUMP
035F7B  E9 B6 01              JMP    0x36134 ; JUMP
035F7E  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
035F82  74 03                 JE     0x35f87 ; CJUMP
035F84  E9 AD 01              JMP    0x36134 ; JUMP
035F87  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
035F8A  39 46 F0              CMP    word ptr [bp - 0x10], ax ; CMP
035F8D  7D 03                 JGE    0x35f92 ; CJUMP
035F8F  E9 A2 01              JMP    0x36134 ; JUMP
035F92  FF 36 A6 83           PUSH   word ptr [0x83a6] ; PUSH_GLOBAL
035F96  9A                    DB     0x9A ; DATA_BYTE
035F97  CA                    DB     0xCA ; DATA_BYTE
035F98  04                    DB     0x04 ; DATA_BYTE
035F99  1F                    DB     0x1F ; DATA_BYTE
