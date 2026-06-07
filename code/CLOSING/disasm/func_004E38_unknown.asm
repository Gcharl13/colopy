; ============================================================================
; func_004E38_unknown
; Region   : load_image
; Bytes    : file 0x004E38..0x004E52  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004E38  55                    PUSH   bp ; STACK_PUSH
004E39  8B EC                 MOV    bp, sp ; MOV
004E3B  57                    PUSH   di ; STACK_PUSH
004E3C  56                    PUSH   si ; STACK_PUSH
004E3D  1E                    PUSH   ds ; STACK_PUSH
004E3E  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
004E41  E3 27                 JCXZ   0x4e6a ; CJUMP
004E43  8B D9                 MOV    bx, cx ; MOV
004E45  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004E48  8B F7                 MOV    si, di ; MOV
004E4A  33 C0                 XOR    ax, ax ; LOGIC
004E4C  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004E4E  F7 D9                 NEG    cx ; ARITH
004E50  03 CB                 ADD    cx, bx ; ARITH
