; ============================================================================
; func_0086E4_unknown
; Region   : load_image
; Bytes    : file 0x0086E4..0x008706  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0086E4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0086E8  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
0086ED  EB 26                 JMP    0x8715 ; JUMP
0086EF  90                    NOP ; NOP
0086F0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0086F3  0E                    PUSH   cs ; STACK_PUSH
0086F4  E8 47 FF              CALL   0x863e ; CALL_NEAR
0086F7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0086FA  0B C0                 OR     ax, ax ; LOGIC
0086FC  74 1D                 JE     0x871b ; CJUMP
0086FE  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008701  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
008704  8B C3                 MOV    ax, bx ; MOV
