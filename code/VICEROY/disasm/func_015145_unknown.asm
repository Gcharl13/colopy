; ============================================================================
; func_015145_unknown
; Region   : load_image
; Bytes    : file 0x015145..0x015158  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015145  55                    PUSH   bp ; STACK_PUSH
015146  8B EC                 MOV    bp, sp ; MOV
015148  1E                    PUSH   ds ; STACK_PUSH
015149  56                    PUSH   si ; STACK_PUSH
01514A  06                    PUSH   es ; STACK_PUSH
01514B  57                    PUSH   di ; STACK_PUSH
01514C  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
01514F  E8 C7 00              CALL   0x15219 ; CALL_NEAR
015152  5F                    POP    di ; STACK_POP
015153  07                    POP    es ; STACK_POP
015154  5E                    POP    si ; STACK_POP
015155  1F                    POP    ds ; STACK_POP
015156  5D                    POP    bp ; STACK_POP
015157  CB                    RETF ; RETURN
