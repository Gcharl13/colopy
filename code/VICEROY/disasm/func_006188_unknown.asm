; ============================================================================
; func_006188_unknown
; Region   : load_image
; Bytes    : file 0x006188..0x0061E3  (91 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006188  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
00618C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
006191  83 3E 90 01 00        CMP    word ptr [0x190], 0 ; CMP
006196  74 67                 JE     0x61ff ; CJUMP
006198  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00619B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00619E  9A 3A 00 E4 03        LCALL  0x3e4, 0x3a ; LCALL
0061A3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0061A6  3D 19 00              CMP    ax, 0x19 ; CMP
0061A9  74 54                 JE     0x61ff ; CJUMP
0061AB  3D 1A 00              CMP    ax, 0x1a ; CMP
0061AE  74 4F                 JE     0x61ff ; CJUMP
0061B0  3D 18 00              CMP    ax, 0x18 ; CMP
0061B3  74 4A                 JE     0x61ff ; CJUMP
0061B5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0061B8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0061BB  0E                    PUSH   cs ; STACK_PUSH
0061BC  E8 31 FC              CALL   0x5df0 ; CALL_NEAR
0061BF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0061C2  98                    CWDE ; ARITH
0061C3  0B C0                 OR     ax, ax ; LOGIC
0061C5  7D 38                 JGE    0x61ff ; CJUMP
0061C7  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0061CA  25 03 00              AND    ax, 3 ; LOGIC
0061CD  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
0061D0  C1 F9 02              SAR    cx, 2 ; LOGIC
0061D3  6B C9 13              IMUL   cx, cx, 0x13 ; ARITH
0061D6  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0061D9  C1 FA 02              SAR    dx, 2 ; LOGIC
0061DC  6B D2 11              IMUL   dx, dx, 0x11 ; ARITH
0061DF  03 CA                 ADD    cx, dx ; ARITH
0061E1  03                    DB     0x03 ; DATA_BYTE
0061E2  0E                    DB     0x0E ; DATA_BYTE
