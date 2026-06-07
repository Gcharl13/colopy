; ============================================================================
; func_00738E_unknown
; Region   : load_image
; Bytes    : file 0x00738E..0x0073A8  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00738E  55                    PUSH   bp ; STACK_PUSH
00738F  8B EC                 MOV    bp, sp ; MOV
007391  56                    PUSH   si ; STACK_PUSH
007392  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007395  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007398  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
00739C  32 46 08              XOR    al, byte ptr [bp + 8] ; LOGIC
00739F  24 0F                 AND    al, 0xf ; LOGIC
0073A1  30 87 47 31           XOR    byte ptr [bx + 0x3147], al ; LOGIC
0073A5  5E                    POP    si ; STACK_POP
0073A6  C9                    LEAVE ; EPILOGUE
0073A7  CB                    RETF ; RETURN
