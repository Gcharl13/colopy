; ============================================================================
; func_025C32_unknown
; Region   : overlay
; Bytes    : file 0x025C32..0x025CFE  (204 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025C32  C8 A4 00 00           ENTER  0xa4, 0 ; PROLOGUE
025C36  57                    PUSH   di ; STACK_PUSH
025C37  56                    PUSH   si ; STACK_PUSH
025C38  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
025C3C  80 7F 1F 02           CMP    byte ptr [bx + 0x1f], 2 ; CMP
025C40  7D 03                 JGE    0x25c45 ; CJUMP
025C42  E9 EB 00              JMP    0x25d30 ; JUMP
025C45  C7 46 BC 00 00        MOV    word ptr [bp - 0x44], 0 ; LOCAL_STORE
025C4A  EB 2A                 JMP    0x25c76 ; JUMP
025C4C  8A 46 BC              MOV    al, byte ptr [bp - 0x44] ; LOCAL_LOAD
025C4F  8B 76 BC              MOV    si, word ptr [bp - 0x44] ; LOCAL_LOAD
025C52  88 82 5C FF           MOV    byte ptr [bp + si - 0xa4], al ; LOCAL_STORE
025C56  8A 40 40              MOV    al, byte ptr [bx + si + 0x40] ; MOV
025C59  88 82 7C FF           MOV    byte ptr [bp + si - 0x84], al ; LOCAL_STORE
025C5D  56                    PUSH   si ; STACK_PUSH
025C5E  9A 1C 0D 1F 18        LCALL  0x181f, 0xd1c ; THUNK -> 0x05EB:0x0C7A (thunk @file 0x01B30C type B) overlay @file 0x027C6A
025C63  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
025C66  88 42 DE              MOV    byte ptr [bp + si - 0x22], al ; LOCAL_STORE
025C69  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
025C6D  8A 40 20              MOV    al, byte ptr [bx + si + 0x20] ; MOV
025C70  88 42 9C              MOV    byte ptr [bp + si - 0x64], al ; LOCAL_STORE
025C73  FF 46 BC              INC    word ptr [bp - 0x44] ; ARITH
025C76  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
025C79  98                    CWDE ; ARITH
025C7A  3B 46 BC              CMP    ax, word ptr [bp - 0x44] ; CMP
025C7D  7F CD                 JG     0x25c4c ; CJUMP
025C7F  8D 86 5C FF           LEA    ax, [bp - 0xa4] ; ADDR
025C83  16                    PUSH   ss ; STACK_PUSH
025C84  50                    PUSH   ax ; STACK_PUSH
025C85  8D 46 9C              LEA    ax, [bp - 0x64] ; ADDR
025C88  16                    PUSH   ss ; STACK_PUSH
025C89  50                    PUSH   ax ; STACK_PUSH
025C8A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
025C8E  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
025C91  98                    CWDE ; ARITH
025C92  9A 70 08 1F 19        LCALL  0x191f, 0x870 ; THUNK -> 0x0D05:0x0000 (thunk @file 0x01BE60 type B)
025C97  C7 46 BC 00 00        MOV    word ptr [bp - 0x44], 0 ; LOCAL_STORE
025C9C  EB 14                 JMP    0x25cb2 ; JUMP
025C9E  8A 46 BC              MOV    al, byte ptr [bp - 0x44] ; LOCAL_LOAD
025CA1  8B 76 BC              MOV    si, word ptr [bp - 0x44] ; LOCAL_LOAD
025CA4  8A 8A 5C FF           MOV    cl, byte ptr [bp + si - 0xa4] ; LOCAL_LOAD
025CA8  2A ED                 SUB    ch, ch ; ARITH
025CAA  8B F9                 MOV    di, cx ; MOV
025CAC  88 43 BE              MOV    byte ptr [bp + di - 0x42], al ; LOCAL_STORE
025CAF  FF 46 BC              INC    word ptr [bp - 0x44] ; ARITH
025CB2  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
025CB6  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
025CB9  98                    CWDE ; ARITH
025CBA  3B 46 BC              CMP    ax, word ptr [bp - 0x44] ; CMP
025CBD  7F DF                 JG     0x25c9e ; CJUMP
025CBF  C7 46 BC 00 00        MOV    word ptr [bp - 0x44], 0 ; LOCAL_STORE
025CC4  EB 29                 JMP    0x25cef ; JUMP
025CC6  8B 76 BC              MOV    si, word ptr [bp - 0x44] ; LOCAL_LOAD
025CC9  8A 82 7C FF           MOV    al, byte ptr [bp + si - 0x84] ; LOCAL_LOAD
025CCD  8A 4A BE              MOV    cl, byte ptr [bp + si - 0x42] ; LOCAL_LOAD
025CD0  2A ED                 SUB    ch, ch ; ARITH
025CD2  8B F9                 MOV    di, cx ; MOV
025CD4  88 41 40              MOV    byte ptr [bx + di + 0x40], al ; MOV
025CD7  8A 42 9C              MOV    al, byte ptr [bp + si - 0x64] ; LOCAL_LOAD
025CDA  88 40 20              MOV    byte ptr [bx + si + 0x20], al ; MOV
025CDD  8A 42 DE              MOV    al, byte ptr [bp + si - 0x22] ; LOCAL_LOAD
025CE0  2A E4                 SUB    ah, ah ; ARITH
025CE2  50                    PUSH   ax ; STACK_PUSH
025CE3  57                    PUSH   di ; STACK_PUSH
025CE4  9A 7E 0A 1F 18        LCALL  0x181f, 0xa7e ; THUNK -> 0x05EB:0x0CBC (thunk @file 0x01B06E type B) overlay @file 0x027CAC
025CE9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
025CEC  FF 46 BC              INC    word ptr [bp - 0x44] ; ARITH
025CEF  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
025CF3  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
025CF6  98                    CWDE ; ARITH
025CF7  3B 46 BC              CMP    ax, word ptr [bp - 0x44] ; CMP
025CFA  7F CA                 JG     0x25cc6 ; CJUMP
025CFC  8B                    DB     0x8B ; DATA_BYTE
025CFD  36                    DB     0x36 ; DATA_BYTE
