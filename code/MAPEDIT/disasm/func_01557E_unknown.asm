; ============================================================================
; func_01557E_unknown
; Region   : load_image
; Bytes    : file 0x01557E..0x015599  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01557E  55                    PUSH   bp ; STACK_PUSH
01557F  8B EC                 MOV    bp, sp ; MOV
015581  57                    PUSH   di ; STACK_PUSH
015582  56                    PUSH   si ; STACK_PUSH
015583  1E                    PUSH   ds ; STACK_PUSH
015584  07                    POP    es ; STACK_POP
015585  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
015588  E3 26                 JCXZ   0x155b0 ; CJUMP
01558A  8B D9                 MOV    bx, cx ; MOV
01558C  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
01558F  8B F7                 MOV    si, di ; MOV
015591  33 C0                 XOR    ax, ax ; LOGIC
015593  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015595  F7 D9                 NEG    cx ; ARITH
015597  03 CB                 ADD    cx, bx ; ARITH
