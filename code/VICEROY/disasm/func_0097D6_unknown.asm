; ============================================================================
; func_0097D6_unknown
; Region   : load_image
; Bytes    : file 0x0097D6..0x0097F2  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0097D6  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0097DA  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
0097DF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0097E2  0E                    PUSH   cs ; STACK_PUSH
0097E3  E8 58 EE              CALL   0x863e ; CALL_NEAR
0097E6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0097E9  0B C0                 OR     ax, ax ; LOGIC
0097EB  74 26                 JE     0x9813 ; CJUMP
0097ED  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0097F0  8B C3                 MOV    ax, bx ; MOV
