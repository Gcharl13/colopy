; ============================================================================
; func_010654_unknown
; Region   : load_image
; Bytes    : file 0x010654..0x01066E  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010654  55                    PUSH   bp ; STACK_PUSH
010655  8B EC                 MOV    bp, sp ; MOV
010657  57                    PUSH   di ; STACK_PUSH
010658  56                    PUSH   si ; STACK_PUSH
010659  1E                    PUSH   ds ; STACK_PUSH
01065A  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
01065D  E3 27                 JCXZ   0x10686 ; CJUMP
01065F  8B D9                 MOV    bx, cx ; MOV
010661  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
010664  8B F7                 MOV    si, di ; MOV
010666  33 C0                 XOR    ax, ax ; LOGIC
010668  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
01066A  F7 D9                 NEG    cx ; ARITH
01066C  03 CB                 ADD    cx, bx ; ARITH
