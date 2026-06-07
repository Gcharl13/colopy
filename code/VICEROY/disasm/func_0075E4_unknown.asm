; ============================================================================
; func_0075E4_unknown
; Region   : load_image
; Bytes    : file 0x0075E4..0x0075FE  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0075E4  55                    PUSH   bp ; STACK_PUSH
0075E5  8B EC                 MOV    bp, sp ; MOV
0075E7  56                    PUSH   si ; STACK_PUSH
0075E8  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0075EB  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0075EE  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
0075F2  32 46 08              XOR    al, byte ptr [bp + 8] ; LOGIC
0075F5  24 0F                 AND    al, 0xf ; LOGIC
0075F7  30 87 5B 31           XOR    byte ptr [bx + 0x315b], al ; LOGIC
0075FB  5E                    POP    si ; STACK_POP
0075FC  C9                    LEAVE ; EPILOGUE
0075FD  CB                    RETF ; RETURN
