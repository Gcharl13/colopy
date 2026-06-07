; ============================================================================
; func_00860E_unknown
; Region   : load_image
; Bytes    : file 0x00860E..0x00861D  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00860E  55                    PUSH   bp ; STACK_PUSH
00860F  8B EC                 MOV    bp, sp ; MOV
008611  56                    PUSH   si ; STACK_PUSH
008612  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
008616  7D 06                 JGE    0x861e ; CJUMP
008618  2B C0                 SUB    ax, ax ; ARITH
00861A  5E                    POP    si ; STACK_POP
00861B  C9                    LEAVE ; EPILOGUE
00861C  CB                    RETF ; RETURN
