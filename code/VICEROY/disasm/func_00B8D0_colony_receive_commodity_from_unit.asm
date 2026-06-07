; ============================================================================
; func_00B8D0_unknown
; Region   : load_image
; Bytes    : file 0x00B8D0..0x00B8FF  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B8D0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00B8D4  56                    PUSH   si ; STACK_PUSH
00B8D5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00B8D8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B8DB  0E                    PUSH   cs ; STACK_PUSH
00B8DC  E8 4D FB              CALL   0xb42c ; CALL_NEAR
00B8DF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B8E2  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00B8E5  0B C0                 OR     ax, ax ; LOGIC
00B8E7  7C 10                 JL     0xb8f9 ; CJUMP
00B8E9  A1 C4 8D              MOV    ax, word ptr [0x8dc4] ; GLOBAL_LOAD
00B8EC  8B 76 FC              MOV    si, word ptr [bp - 4] ; LOCAL_LOAD
00B8EF  D1 E6                 SHL    si, 1 ; LOGIC
00B8F1  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00B8F5  01 80 9A 00           ADD    word ptr [bx + si + 0x9a], ax ; ARITH
00B8F9  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00B8FC  5E                    POP    si ; STACK_POP
00B8FD  C9                    LEAVE ; EPILOGUE
00B8FE  CB                    RETF ; RETURN
