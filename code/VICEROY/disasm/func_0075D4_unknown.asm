; ============================================================================
; func_0075D4_unknown
; Region   : load_image
; Bytes    : file 0x0075D4..0x0075E4  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0075D4  55                    PUSH   bp ; STACK_PUSH
0075D5  8B EC                 MOV    bp, sp ; MOV
0075D7  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
0075DB  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
0075DF  25 0F 00              AND    ax, 0xf ; LOGIC
0075E2  C9                    LEAVE ; EPILOGUE
0075E3  CB                    RETF ; RETURN
