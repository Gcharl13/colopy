; ============================================================================
; func_005E38_unknown
; Region   : load_image
; Bytes    : file 0x005E38..0x005E52  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005E38  55                    PUSH   bp ; STACK_PUSH
005E39  8B EC                 MOV    bp, sp ; MOV
005E3B  57                    PUSH   di ; STACK_PUSH
005E3C  56                    PUSH   si ; STACK_PUSH
005E3D  1E                    PUSH   ds ; STACK_PUSH
005E3E  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
005E41  E3 27                 JCXZ   0x5e6a ; CJUMP
005E43  8B D9                 MOV    bx, cx ; MOV
005E45  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005E48  8B F7                 MOV    si, di ; MOV
005E4A  33 C0                 XOR    ax, ax ; LOGIC
005E4C  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005E4E  F7 D9                 NEG    cx ; ARITH
005E50  03 CB                 ADD    cx, bx ; ARITH
