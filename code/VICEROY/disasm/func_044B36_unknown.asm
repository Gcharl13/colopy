; ============================================================================
; func_044B36_unknown
; Region   : overlay
; Bytes    : file 0x044B36..0x044B5A  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044B36  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
044B3A  57                    PUSH   di ; STACK_PUSH
044B3B  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044B3E  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38] ; MOV
044B42  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a] ; MOV
044B46  8B F8                 MOV    di, ax ; MOV
044B48  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
044B4B  0B D0                 OR     dx, ax ; LOGIC
044B4D  74 28                 JE     0x44b77 ; CJUMP
044B4F  8E 46 FA              MOV    es, word ptr [bp - 6] ; LOCAL_LOAD
044B52  26 C5 5D 1E           LDS    bx, ptr es:[di + 0x1e] ; MOV_FAR
044B56  8C D8                 MOV    ax, ds ; MOV
044B58  0B C3                 OR     ax, bx ; LOGIC
