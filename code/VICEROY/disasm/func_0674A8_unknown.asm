; ============================================================================
; func_0674A8_unknown
; Region   : overlay
; Bytes    : file 0x0674A8..0x067528  (128 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0674A8  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0674AC  56                    PUSH   si ; STACK_PUSH
0674AD  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
0674B2  75 76                 JNE    0x6752a ; CJUMP
0674B4  83 3E 26 08 00        CMP    word ptr [0x826], 0 ; CMP
0674B9  75 6F                 JNE    0x6752a ; CJUMP
0674BB  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
0674C0  75 68                 JNE    0x6752a ; CJUMP
0674C2  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
0674C7  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
0674CA  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
0674CE  24 0F                 AND    al, 0xf ; LOGIC
0674D0  3C 04                 CMP    al, 4 ; CMP
0674D2  73 56                 JAE    0x6752a ; CJUMP
0674D4  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
0674D8  24 0F                 AND    al, 0xf ; LOGIC
0674DA  2A E4                 SUB    ah, ah ; ARITH
0674DC  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
0674DF  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah ; CMP
0674E3  75 45                 JNE    0x6752a ; CJUMP
0674E5  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
0674E8  9A 66 09 1F 18        LCALL  0x181f, 0x966 ; THUNK -> 0x0427:0x1330 (thunk @file 0x01AF56 type B) overlay @file 0x032044
0674ED  0B C0                 OR     ax, ax ; LOGIC
0674EF  74 39                 JE     0x6752a ; CJUMP
0674F1  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0674F4  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0674F7  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
0674FA  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0674FE  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
067503  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
067506  38 87 44 31           CMP    byte ptr [bx + 0x3144], al ; CMP
06750A  75 1E                 JNE    0x6752a ; CJUMP
06750C  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
06750F  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
067513  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
067516  38 87 45 31           CMP    byte ptr [bx + 0x3145], al ; CMP
06751A  75 0E                 JNE    0x6752a ; CJUMP
06751C  6A 01                 PUSH   1 ; STACK_PUSH
06751E  0E                    PUSH   cs ; STACK_PUSH
06751F  E8 09 01              CALL   0x6762b ; CALL_NEAR
067522  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
067525  5E                    POP    si ; STACK_POP
067526  C9                    LEAVE ; EPILOGUE
067527  CB                    RETF ; RETURN
