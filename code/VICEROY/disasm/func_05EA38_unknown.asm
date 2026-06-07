; ============================================================================
; func_05EA38_unknown
; Region   : overlay
; Bytes    : file 0x05EA38..0x05EAF2  (186 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05EA38  C8 05 06 00           ENTER  0x605, 0 ; PROLOGUE
05EA3C  50                    PUSH   ax ; STACK_PUSH
05EA3D  68 D0 00              PUSH   0xd0 ; PUSH_CONST
05EA40  B8 38 00              MOV    ax, 0x38 ; CONST_LOAD
05EA43  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
05EA46  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
05EA49  50                    PUSH   ax ; STACK_PUSH
05EA4A  FF 36 50 2E           PUSH   word ptr [0x2e50] ; PUSH_GLOBAL
05EA4E  8B F1                 MOV    si, cx ; MOV
05EA50  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
05EA55  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05EA58  52                    PUSH   dx ; STACK_PUSH
05EA59  50                    PUSH   ax ; STACK_PUSH
05EA5A  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
05EA5F  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
05EA62  8D 44 14              LEA    ax, [si + 0x14] ; ADDR
05EA65  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
05EA68  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
05EA6B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
05EA6E  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0 ; LOCAL_STORE
05EA73  E9 C5 0F              JMP    0x5fa3b ; JUMP
05EA76  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
05EA79  89 46 88              MOV    word ptr [bp - 0x78], ax ; LOCAL_STORE
05EA7C  83 7E E8 00           CMP    word ptr [bp - 0x18], 0 ; CMP
05EA80  75 06                 JNE    0x5ea88 ; CJUMP
05EA82  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
05EA85  EB 04                 JMP    0x5ea8b ; JUMP
05EA87  90                    NOP ; NOP
05EA88  8B 46 14              MOV    ax, word ptr [bp + 0x14] ; LOCAL_LOAD
05EA8B  89 86 36 FF           MOV    word ptr [bp - 0xca], ax ; LOCAL_STORE
05EA8F  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
05EA92  89 46 8C              MOV    word ptr [bp - 0x74], ax ; LOCAL_STORE
05EA95  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
05EA99  74 13                 JE     0x5eaae ; CJUMP
05EA9B  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
05EA9E  6A 00                 PUSH   0 ; STACK_PUSH
05EAA0  6A 64                 PUSH   0x64 ; PUSH_CONST
05EAA2  8B D8                 MOV    bx, ax ; MOV
05EAA4  8B 46 88              MOV    ax, word ptr [bp - 0x78] ; LOCAL_LOAD
05EAA7  2B D2                 SUB    dx, dx ; ARITH
05EAA9  9A BC 02 1F 18        LCALL  0x181f, 0x2bc ; THUNK -> 0x012B:0x01BA (thunk @file 0x01A8AC type B) overlay @file 0x023724
05EAAE  83 46 8C 11           ADD    word ptr [bp - 0x74], 0x11 ; ARITH
05EAB2  F6 46 8B 02           TEST   byte ptr [bp - 0x75], 2 ; LOGIC
05EAB6  74 2A                 JE     0x5eae2 ; CJUMP
05EAB8  C6 46 94 00           MOV    byte ptr [bp - 0x6c], 0 ; LOCAL_STORE
05EABC  6B 5E 88 1C           IMUL   bx, word ptr [bp - 0x78], 0x1c ; ARITH
05EAC0  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
05EAC4  98                    CWDE ; ARITH
05EAC5  50                    PUSH   ax ; STACK_PUSH
05EAC6  9A 18 0C 1F 18        LCALL  0x181f, 0xc18 ; THUNK -> 0x05EB:0x022C (thunk @file 0x01B208 type B) overlay @file 0x02721C
05EACB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05EACE  50                    PUSH   ax ; STACK_PUSH
05EACF  8D 46 94              LEA    ax, [bp - 0x6c] ; ADDR
05EAD2  50                    PUSH   ax ; STACK_PUSH
05EAD3  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
05EAD8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05EADB  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
05EAE0  EB 36                 JMP    0x5eb18 ; JUMP
05EAE2  C6 46 94 00           MOV    byte ptr [bp - 0x6c], 0 ; LOCAL_STORE
05EAE6  6B 5E 88 1C           IMUL   bx, word ptr [bp - 0x78], 0x1c ; ARITH
05EAEA  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
05EAEE  2A FF                 SUB    bh, bh ; ARITH
05EAF0  8B C3                 MOV    ax, bx ; MOV
