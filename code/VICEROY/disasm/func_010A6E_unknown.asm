; ============================================================================
; func_010A6E_unknown
; Region   : load_image
; Bytes    : file 0x010A6E..0x010A80  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010A6E  55                    PUSH   bp ; STACK_PUSH
010A6F  8B EC                 MOV    bp, sp ; MOV
010A71  56                    PUSH   si ; STACK_PUSH
010A72  57                    PUSH   di ; STACK_PUSH
010A73  1E                    PUSH   ds ; STACK_PUSH
010A74  07                    POP    es ; STACK_POP
010A75  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
010A78  BE 42 2B              MOV    si, 0x2b42 ; CONST_LOAD
010A7B  AD                    LODSW  ax, word ptr [si] ; STR
010A7C  3B C2                 CMP    ax, dx ; CMP
010A7E  74 10                 JE     0x10a90 ; CJUMP
