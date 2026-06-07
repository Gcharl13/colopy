; ============================================================================
; func_07705A_unknown
; Region   : overlay
; Bytes    : file 0x07705A..0x07706C  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

07705A  55                    PUSH   bp ; STACK_PUSH
07705B  8B EC                 MOV    bp, sp ; MOV
07705D  56                    PUSH   si ; STACK_PUSH
07705E  8B D8                 MOV    bx, ax ; MOV
077060  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
077063  26 88 5C 2B           MOV    byte ptr es:[si + 0x2b], bl ; MOV
077067  5E                    POP    si ; STACK_POP
077068  C9                    LEAVE ; EPILOGUE
077069  CA 04 00              RETF   4 ; RETURN
