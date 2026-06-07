; ============================================================================
; func_008BB2_unknown
; Region   : load_image
; Bytes    : file 0x008BB2..0x008BC6  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008BB2  55                    PUSH   bp ; STACK_PUSH
008BB3  8B EC                 MOV    bp, sp ; MOV
008BB5  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
008BB9  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
008BBD  2A FF                 SUB    bh, bh ; ARITH
008BBF  8A 87 0E 03           MOV    al, byte ptr [bx + 0x30e] ; MOV
008BC3  98                    CWDE ; ARITH
008BC4  C9                    LEAVE ; EPILOGUE
008BC5  CB                    RETF ; RETURN
