; ============================================================================
; func_00C07A_unknown
; Region   : load_image
; Bytes    : file 0x00C07A..0x00C09A  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C07A  55                    PUSH   bp ; STACK_PUSH
00C07B  8B EC                 MOV    bp, sp ; MOV
00C07D  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00C080  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C083  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C086  9A 44 02 09 00        LCALL  9, 0x244 ; LCALL
00C08B  8B E5                 MOV    sp, bp ; MOV
00C08D  6A 00                 PUSH   0 ; STACK_PUSH
00C08F  6A 00                 PUSH   0 ; STACK_PUSH
00C091  6A 01                 PUSH   1 ; STACK_PUSH
00C093  9A CC 02 09 00        LCALL  9, 0x2cc ; LCALL
00C098  C9                    LEAVE ; EPILOGUE
00C099  CB                    RETF ; RETURN
