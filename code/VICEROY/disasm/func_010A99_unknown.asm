; ============================================================================
; func_010A99_unknown
; Region   : load_image
; Bytes    : file 0x010A99..0x010AA5  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010A99  55                    PUSH   bp ; STACK_PUSH
010A9A  8B EC                 MOV    bp, sp ; MOV
010A9C  57                    PUSH   di ; STACK_PUSH
010A9D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
010AA0  0E                    PUSH   cs ; STACK_PUSH
010AA1  E8 CA FF              CALL   0x10a6e ; CALL_NEAR
010AA4  0B                    DB     0x0B ; DATA_BYTE
