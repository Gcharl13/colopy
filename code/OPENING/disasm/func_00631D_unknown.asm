; ============================================================================
; func_00631D_unknown
; Region   : load_image
; Bytes    : file 0x00631D..0x006329  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00631D  55                    PUSH   bp ; STACK_PUSH
00631E  8B EC                 MOV    bp, sp ; MOV
006320  57                    PUSH   di ; STACK_PUSH
006321  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
006324  0E                    PUSH   cs ; STACK_PUSH
006325  E8 CA FF              CALL   0x62f2 ; CALL_NEAR
006328  0B                    DB     0x0B ; DATA_BYTE
