; ============================================================================
; func_00531D_unknown
; Region   : load_image
; Bytes    : file 0x00531D..0x005329  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00531D  55                    PUSH   bp ; STACK_PUSH
00531E  8B EC                 MOV    bp, sp ; MOV
005320  57                    PUSH   di ; STACK_PUSH
005321  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005324  0E                    PUSH   cs ; STACK_PUSH
005325  E8 CA FF              CALL   0x52f2 ; CALL_NEAR
005328  0B                    DB     0x0B ; DATA_BYTE
