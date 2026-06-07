; ============================================================================
; func_023F1C_unknown
; Region   : overlay
; Bytes    : file 0x023F1C..0x023FF8  (220 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023F1C  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
023F20  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
023F25  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
023F2A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
023F2F  A1 1E 98              MOV    ax, word ptr [0x981e] ; GLOBAL_LOAD
023F32  3D 11 01              CMP    ax, 0x111 ; CMP
023F35  74 3D                 JE     0x23f74 ; CJUMP
023F37  7E 03                 JLE    0x23f3c ; CJUMP
023F39  E9 F6 01              JMP    0x24132 ; JUMP
023F3C  3D 33 00              CMP    ax, 0x33 ; CMP
023F3F  75 03                 JNE    0x23f44 ; CJUMP
023F41  E9 30 01              JMP    0x24074 ; JUMP
023F44  7E 03                 JLE    0x23f49 ; CJUMP
023F46  E9 B3 01              JMP    0x240fc ; JUMP
023F49  3D 32 00              CMP    ax, 0x32 ; CMP
023F4C  75 03                 JNE    0x23f51 ; CJUMP
023F4E  E9 CD 00              JMP    0x2401e ; JUMP
023F51  76 03                 JBE    0x23f56 ; CJUMP
023F53  E9 BC 01              JMP    0x24112 ; JUMP
023F56  2C 11                 SUB    al, 0x11 ; ARITH
023F58  75 03                 JNE    0x23f5d ; CJUMP
023F5A  E9 87 00              JMP    0x23fe4 ; JUMP
023F5D  2C 07                 SUB    al, 7 ; ARITH
023F5F  75 03                 JNE    0x23f64 ; CJUMP
023F61  E9 80 00              JMP    0x23fe4 ; JUMP
023F64  2C 03                 SUB    al, 3 ; ARITH
023F66  74 7C                 JE     0x23fe4 ; CJUMP
023F68  2C 16                 SUB    al, 0x16 ; ARITH
023F6A  75 03                 JNE    0x23f6f ; CJUMP
023F6C  E9 2F 01              JMP    0x2409e ; JUMP
023F6F  E9 A0 01              JMP    0x24112 ; JUMP
023F72  90                    NOP ; NOP
023F73  90                    NOP ; NOP
023F74  8A 26 83 53           MOV    ah, byte ptr [0x5383] ; GLOBAL_LOAD
023F78  25 00 20              AND    ax, 0x2000 ; LOGIC
023F7B  74 25                 JE     0x23fa2 ; CJUMP
023F7D  50                    PUSH   ax ; STACK_PUSH
023F7E  6A 06                 PUSH   6 ; STACK_PUSH
023F80  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
023F84  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
023F88  9A 5C 04 1F 19        LCALL  0x191f, 0x45c ; THUNK -> 0x0000:0x051A (thunk @file 0x01BA4C type A) overlay @file 0x025E1A
023F8D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
023F90  6A 01                 PUSH   1 ; STACK_PUSH
023F92  9A EA 0D 1F 18        LCALL  0x181f, 0xdea ; THUNK -> 0x0984:0x0490 (thunk @file 0x01B3DA type B) overlay @file 0x0323A6
023F97  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
023F9A  80 36 83 53 20        XOR    byte ptr [0x5383], 0x20 ; LOGIC
023F9F  E9 E0 01              JMP    0x24182 ; JUMP
023FA2  83 3E 92 0B 00        CMP    word ptr [0xb92], 0 ; CMP
023FA7  75 09                 JNE    0x23fb2 ; CJUMP
023FA9  81 3E 1E 98 11 01     CMP    word ptr [0x981e], 0x111 ; CMP
023FAF  EB 0E                 JMP    0x23fbf ; JUMP
023FB1  90                    NOP ; NOP
023FB2  83 3E 92 0B 01        CMP    word ptr [0xb92], 1 ; CMP
023FB7  75 17                 JNE    0x23fd0 ; CJUMP
023FB9  81 3E 1E 98 17 01     CMP    word ptr [0x981e], 0x117 ; CMP
023FBF  74 03                 JE     0x23fc4 ; CJUMP
023FC1  E9 BE 01              JMP    0x24182 ; JUMP
023FC4  FF 06 92 0B           INC    word ptr [0xb92] ; ARITH
023FC8  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
023FCD  E9 B2 01              JMP    0x24182 ; JUMP
023FD0  81 3E 1E 98 31 01     CMP    word ptr [0x981e], 0x131 ; CMP
023FD6  74 03                 JE     0x23fdb ; CJUMP
023FD8  E9 A7 01              JMP    0x24182 ; JUMP
023FDB  8A 26 83 53           MOV    ah, byte ptr [0x5383] ; GLOBAL_LOAD
023FDF  25 00 20              AND    ax, 0x2000 ; LOGIC
023FE2  EB 99                 JMP    0x23f7d ; JUMP
023FE4  8D 1E 8B 0B           LEA    bx, [0xb8b] ; ADDR
023FE8  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
023FED  48                    DEC    ax ; ARITH
023FEE  74 03                 JE     0x23ff3 ; CJUMP
023FF0  E9 8F 01              JMP    0x24182 ; JUMP
023FF3  C7                    DB     0xC7 ; DATA_BYTE
023FF4  06                    DB     0x06 ; DATA_BYTE
023FF5  C2                    DB     0xC2 ; DATA_BYTE
023FF6  53                    DB     0x53 ; DATA_BYTE
023FF7  00                    DB     0x00 ; DATA_BYTE
