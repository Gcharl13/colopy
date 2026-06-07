; ============================================================================
; func_009C92_unknown
; Region   : load_image
; Bytes    : file 0x009C92..0x009CA1  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009C92  55                    PUSH   bp ; STACK_PUSH
009C93  8B EC                 MOV    bp, sp ; MOV
009C95  57                    PUSH   di ; STACK_PUSH
009C96  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
009C99  0B D2                 OR     dx, dx ; LOGIC
009C9B  7F 07                 JG     0x9ca4 ; CJUMP
009C9D  8B C2                 MOV    ax, dx ; MOV
009C9F  F7 D0                 NOT    ax ; LOGIC
