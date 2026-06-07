; ============================================================================
; func_004900_unknown
; Region   : load_image
; Bytes    : file 0x004900..0x00490F  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004900  55                    PUSH   bp ; STACK_PUSH
004901  8B EC                 MOV    bp, sp ; MOV
004903  57                    PUSH   di ; STACK_PUSH
004904  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
004907  0B D2                 OR     dx, dx ; LOGIC
004909  7F 07                 JG     0x4912 ; CJUMP
00490B  8B C2                 MOV    ax, dx ; MOV
00490D  F7 D0                 NOT    ax ; LOGIC
