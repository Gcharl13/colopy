; ============================================================================
; func_0130A4_unknown
; Region   : load_image
; Bytes    : file 0x0130A4..0x0130B8  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0130A4  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
0130A8  56                    PUSH   si ; STACK_PUSH
0130A9  57                    PUSH   di ; STACK_PUSH
0130AA  1E                    PUSH   ds ; STACK_PUSH
0130AB  C4 46 06              LES    ax, ptr [bp + 6] ; MOV_FAR
0130AE  05 0F 00              ADD    ax, 0xf ; ARITH
0130B1  C1 E8 04              SHR    ax, 4 ; LOGIC
0130B4  8C C2                 MOV    dx, es ; MOV
0130B6  03 D0                 ADD    dx, ax ; ARITH
