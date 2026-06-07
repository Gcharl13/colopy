; ============================================================================
; func_013ADC_unknown
; Region   : load_image
; Bytes    : file 0x013ADC..0x013AEE  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013ADC  55                    PUSH   bp ; STACK_PUSH
013ADD  8B EC                 MOV    bp, sp ; MOV
013ADF  56                    PUSH   si ; STACK_PUSH
013AE0  8B D8                 MOV    bx, ax ; MOV
013AE2  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
013AE5  26 88 5C 2B           MOV    byte ptr es:[si + 0x2b], bl ; MOV
013AE9  5E                    POP    si ; STACK_POP
013AEA  C9                    LEAVE ; EPILOGUE
013AEB  CA 04 00              RETF   4 ; RETURN
