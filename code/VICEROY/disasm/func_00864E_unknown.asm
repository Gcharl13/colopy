; ============================================================================
; func_00864E_unknown
; Region   : load_image
; Bytes    : file 0x00864E..0x00866D  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00864E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
008652  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
008657  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00865A  0E                    PUSH   cs ; STACK_PUSH
00865B  E8 E0 FF              CALL   0x863e ; CALL_NEAR
00865E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
008661  0B C0                 OR     ax, ax ; LOGIC
008663  74 03                 JE     0x8668 ; CJUMP
008665  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
008668  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00866B  8B C3                 MOV    ax, bx ; MOV
