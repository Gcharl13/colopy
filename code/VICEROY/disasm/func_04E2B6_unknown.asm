; ============================================================================
; func_04E2B6_unknown
; Region   : overlay
; Bytes    : file 0x04E2B6..0x04E2D6  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E2B6  55                    PUSH   bp ; STACK_PUSH
04E2B7  8B EC                 MOV    bp, sp ; MOV
04E2B9  56                    PUSH   si ; STACK_PUSH
04E2BA  6B F0 1C              IMUL   si, ax, 0x1c ; ARITH
04E2BD  88 94 4B 31           MOV    byte ptr [si + 0x314b], dl ; MOV
04E2C1  C6 84 4C 31 0B        MOV    byte ptr [si + 0x314c], 0xb ; CONST_LOAD
04E2C6  88 9C 4D 31           MOV    byte ptr [si + 0x314d], bl ; MOV
04E2CA  8A 46 04              MOV    al, byte ptr [bp + 4] ; LOCAL_LOAD
04E2CD  88 84 4E 31           MOV    byte ptr [si + 0x314e], al ; MOV
04E2D1  5E                    POP    si ; STACK_POP
04E2D2  C9                    LEAVE ; EPILOGUE
04E2D3  C2 02 00              RET    2 ; RETURN
