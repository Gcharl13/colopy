; ============================================================================
; func_00268C_unknown
; Region   : load_image
; Bytes    : file 0x00268C..0x0026B2  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00268C  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
002690  C6 46 EC 00           MOV    byte ptr [bp - 0x14], 0 ; LOCAL_STORE
002694  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002697  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00269A  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
00269D  16                    PUSH   ss ; STACK_PUSH
00269E  50                    PUSH   ax ; STACK_PUSH
00269F  9A E8 01 4B 00        LCALL  0x4b, 0x1e8 ; LCALL
0026A4  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0026A7  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
0026AA  16                    PUSH   ss ; STACK_PUSH
0026AB  50                    PUSH   ax ; STACK_PUSH
0026AC  0E                    PUSH   cs ; STACK_PUSH
0026AD  E8 5E FF              CALL   0x260e ; CALL_NEAR
0026B0  C9                    LEAVE ; EPILOGUE
0026B1  CB                    RETF ; RETURN
