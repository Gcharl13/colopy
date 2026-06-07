; ============================================================================
; func_0458EC_unknown
; Region   : overlay
; Bytes    : file 0x0458EC..0x045943  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0458EC  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0458F0  50                    PUSH   ax ; STACK_PUSH
0458F1  57                    PUSH   di ; STACK_PUSH
0458F2  56                    PUSH   si ; STACK_PUSH
0458F3  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0458F6  2B C0                 SUB    ax, ax ; ARITH
0458F8  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0458FB  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
0458FE  26 89 05              MOV    word ptr es:[di], ax ; MOV
045901  39 06 EC 07           CMP    word ptr [0x7ec], ax ; CMP
045905  74 7A                 JE     0x45981 ; CJUMP
045907  26 FF 75 2A           PUSH   word ptr es:[di + 0x2a] ; PUSH_GLOBAL
04590B  26 FF 75 28           PUSH   word ptr es:[di + 0x28] ; PUSH_GLOBAL
04590F  8C C6                 MOV    si, es ; MOV
045911  E8 2C EC              CALL   0x44540 ; CALL_NEAR
045914  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045917  8E C6                 MOV    es, si ; MOV
045919  26 8B 75 04           MOV    si, word ptr es:[di + 4] ; MOV
04591D  03 F0                 ADD    si, ax ; ARITH
04591F  46                    INC    si ; ARITH
045920  3B 36 EA 07           CMP    si, word ptr [0x7ea] ; CMP
045924  7C 5B                 JL     0x45981 ; CJUMP
045926  2B C9                 SUB    cx, cx ; ARITH
045928  26 C5 75 38           LDS    si, ptr es:[di + 0x38] ; MOV_FAR
04592C  8C D8                 MOV    ax, ds ; MOV
04592E  0B C6                 OR     ax, si ; LOGIC
045930  74 29                 JE     0x4595b ; CJUMP
045932  36 8B 1E E8 07        MOV    bx, word ptr ss:[0x7e8] ; GLOBAL_LOAD
045937  0B C9                 OR     cx, cx ; LOGIC
045939  75 20                 JNE    0x4595b ; CJUMP
04593B  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
04593E  03 44 04              ADD    ax, word ptr [si + 4] ; ARITH
045941  3B C3                 CMP    ax, bx ; CMP
