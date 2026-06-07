; ============================================================================
; func_011CD2_unknown
; Region   : load_image
; Bytes    : file 0x011CD2..0x011CEB  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011CD2  55                    PUSH   bp ; STACK_PUSH
011CD3  8B EC                 MOV    bp, sp ; MOV
011CD5  56                    PUSH   si ; STACK_PUSH
011CD6  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
011CD9  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
011CDC  50                    PUSH   ax ; STACK_PUSH
011CDD  9A 16 29 1D 0D        LCALL  0xd1d, 0x2916 ; LCALL
011CE2  59                    POP    cx ; STACK_POP
011CE3  8B DE                 MOV    bx, si ; MOV
011CE5  81 EB 0E 29           SUB    bx, 0x290e ; ARITH
011CE9  81                    DB     0x81 ; DATA_BYTE
011CEA  C3                    DB     0xC3 ; DATA_BYTE
