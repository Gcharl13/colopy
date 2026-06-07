; ============================================================================
; func_00877E_unknown
; Region   : load_image
; Bytes    : file 0x00877E..0x008790  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00877E  55                    PUSH   bp ; STACK_PUSH
00877F  8B EC                 MOV    bp, sp ; MOV
008781  56                    PUSH   si ; STACK_PUSH
008782  8B D8                 MOV    bx, ax ; MOV
008784  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
008787  26 88 5C 2B           MOV    byte ptr es:[si + 0x2b], bl ; MOV
00878B  5E                    POP    si ; STACK_POP
00878C  C9                    LEAVE ; EPILOGUE
00878D  CA 04 00              RETF   4 ; RETURN
