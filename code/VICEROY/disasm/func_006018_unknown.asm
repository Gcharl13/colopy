; ============================================================================
; func_006018_unknown
; Region   : load_image
; Bytes    : file 0x006018..0x006039  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006018  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00601C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00601F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
006022  0E                    PUSH   cs ; STACK_PUSH
006023  E8 AE FF              CALL   0x5fd4 ; CALL_NEAR
006026  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006029  0B C0                 OR     ax, ax ; LOGIC
00602B  7D 0A                 JGE    0x6037 ; CJUMP
00602D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
006030  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
006033  0E                    PUSH   cs ; STACK_PUSH
006034  E8 CD FE              CALL   0x5f04 ; CALL_NEAR
006037  C9                    LEAVE ; EPILOGUE
006038  CB                    RETF ; RETURN
