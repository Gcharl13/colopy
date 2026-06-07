; ============================================================================
; func_044FA4_unknown
; Region   : overlay
; Bytes    : file 0x044FA4..0x04500F  (107 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044FA4  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
044FA8  57                    PUSH   di ; STACK_PUSH
044FA9  56                    PUSH   si ; STACK_PUSH
044FAA  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
044FAD  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
044FB0  26 8B 44 02           MOV    ax, word ptr es:[si + 2] ; MOV
044FB4  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
044FB7  89 07                 MOV    word ptr [bx], ax ; MOV
044FB9  8C C0                 MOV    ax, es ; MOV
044FBB  26 C4 5C 12           LES    bx, ptr es:[si + 0x12] ; MOV_FAR
044FBF  89 5E EE              MOV    word ptr [bp - 0x12], bx ; LOCAL_STORE
044FC2  8C 46 F0              MOV    word ptr [bp - 0x10], es ; LOCAL_STORE
044FC5  26 FF 77 2A           PUSH   word ptr es:[bx + 0x2a] ; PUSH_GLOBAL
044FC9  26 FF 77 28           PUSH   word ptr es:[bx + 0x28] ; PUSH_GLOBAL
044FCD  8B F8                 MOV    di, ax ; MOV
044FCF  E8 6E F5              CALL   0x44540 ; CALL_NEAR
044FD2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
044FD5  C4 5E EE              LES    bx, ptr [bp - 0x12] ; MOV_FAR
044FD8  26 03 47 04           ADD    ax, word ptr es:[bx + 4] ; ARITH
044FDC  05 03 00              ADD    ax, 3 ; ARITH
044FDF  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
044FE2  89 07                 MOV    word ptr [bx], ax ; MOV
044FE4  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
044FE9  8E C7                 MOV    es, di ; MOV
044FEB  26 8B 44 1E           MOV    ax, word ptr es:[si + 0x1e] ; MOV
044FEF  26 8B 54 20           MOV    dx, word ptr es:[si + 0x20] ; MOV
044FF3  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
044FF6  0B D0                 OR     dx, ax ; LOGIC
044FF8  74 1F                 JE     0x45019 ; CJUMP
044FFA  8B D8                 MOV    bx, ax ; MOV
044FFC  8B 4E FA              MOV    cx, word ptr [bp - 6] ; LOCAL_LOAD
044FFF  8E 5E F8              MOV    ds, word ptr [bp - 8] ; LOCAL_LOAD
045002  F6 07 02              TEST   byte ptr [bx], 2 ; LOGIC
045005  75 01                 JNE    0x45008 ; CJUMP
045007  41                    INC    cx ; ARITH
045008  C5 5F 0E              LDS    bx, ptr [bx + 0xe] ; MOV_FAR
04500B  8C D8                 MOV    ax, ds ; MOV
04500D  0B C3                 OR     ax, bx ; LOGIC
