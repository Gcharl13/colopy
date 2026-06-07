; ============================================================================
; func_012E56_unknown
; Region   : load_image
; Bytes    : file 0x012E56..0x012E6A  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012E56  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
012E5A  56                    PUSH   si ; STACK_PUSH
012E5B  57                    PUSH   di ; STACK_PUSH
012E5C  1E                    PUSH   ds ; STACK_PUSH
012E5D  C4 46 06              LES    ax, ptr [bp + 6] ; MOV_FAR
012E60  05 0F 00              ADD    ax, 0xf ; ARITH
012E63  C1 E8 04              SHR    ax, 4 ; LOGIC
012E66  8C C2                 MOV    dx, es ; MOV
012E68  03 D0                 ADD    dx, ax ; ARITH
