; ============================================================================
; func_00BD28_unknown
; Region   : load_image
; Bytes    : file 0x00BD28..0x00BD4A  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BD28  55                    PUSH   bp ; STACK_PUSH
00BD29  8B EC                 MOV    bp, sp ; MOV
00BD2B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00BD2E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00BD31  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00BD36  8B E5                 MOV    sp, bp ; MOV
00BD38  0B C0                 OR     ax, ax ; LOGIC
00BD3A  74 0C                 JE     0xbd48 ; CJUMP
00BD3C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00BD3F  A3 40 85              MOV    word ptr [0x8540], ax ; GLOBAL_LOAD
00BD42  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00BD45  A3 3E 85              MOV    word ptr [0x853e], ax ; GLOBAL_LOAD
00BD48  C9                    LEAVE ; EPILOGUE
00BD49  CB                    RETF ; RETURN
