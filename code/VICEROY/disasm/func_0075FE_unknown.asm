; ============================================================================
; func_0075FE_unknown
; Region   : load_image
; Bytes    : file 0x0075FE..0x00760F  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0075FE  55                    PUSH   bp ; STACK_PUSH
0075FF  8B EC                 MOV    bp, sp ; MOV
007601  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007605  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
007609  C0 F8 04              SAR    al, 4 ; LOGIC
00760C  98                    CWDE ; ARITH
00760D  C9                    LEAVE ; EPILOGUE
00760E  CB                    RETF ; RETURN
