; ============================================================================
; func_0042D6_unknown
; Region   : load_image
; Bytes    : file 0x0042D6..0x0042E0  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0042D6  55                    PUSH   bp ; STACK_PUSH
0042D7  8B EC                 MOV    bp, sp ; MOV
0042D9  8B C8                 MOV    cx, ax ; MOV
0042DB  88 0E CA 38           MOV    byte ptr [0x38ca], cl ; GLOBAL_LOAD
0042DF  88                    DB     0x88 ; DATA_BYTE
