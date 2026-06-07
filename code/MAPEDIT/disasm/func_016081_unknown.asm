; ============================================================================
; func_016081_unknown
; Region   : load_image
; Bytes    : file 0x016081..0x01608D  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016081  55                    PUSH   bp ; STACK_PUSH
016082  8B EC                 MOV    bp, sp ; MOV
016084  57                    PUSH   di ; STACK_PUSH
016085  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
016088  0E                    PUSH   cs ; STACK_PUSH
016089  E8 CA FF              CALL   0x16056 ; CALL_NEAR
01608C  0B                    DB     0x0B ; DATA_BYTE
