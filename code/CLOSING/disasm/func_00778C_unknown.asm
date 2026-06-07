; ============================================================================
; func_00778C_unknown
; Region   : load_image
; Bytes    : file 0x00778C..0x00779E  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00778C  55                    PUSH   bp ; STACK_PUSH
00778D  8B EC                 MOV    bp, sp ; MOV
00778F  56                    PUSH   si ; STACK_PUSH
007790  8B D8                 MOV    bx, ax ; MOV
007792  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
007795  26 88 5C 2B           MOV    byte ptr es:[si + 0x2b], bl ; MOV
007799  5E                    POP    si ; STACK_POP
00779A  C9                    LEAVE ; EPILOGUE
00779B  CA 04 00              RETF   4 ; RETURN
