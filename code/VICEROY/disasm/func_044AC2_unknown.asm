; ============================================================================
; func_044AC2_unknown
; Region   : overlay
; Bytes    : file 0x044AC2..0x044AE6  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044AC2  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
044AC6  57                    PUSH   di ; STACK_PUSH
044AC7  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044ACA  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38] ; MOV
044ACE  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a] ; MOV
044AD2  8B F8                 MOV    di, ax ; MOV
044AD4  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
044AD7  0B D0                 OR     dx, ax ; LOGIC
044AD9  74 28                 JE     0x44b03 ; CJUMP
044ADB  8E 46 FA              MOV    es, word ptr [bp - 6] ; LOCAL_LOAD
044ADE  26 C5 5D 1E           LDS    bx, ptr es:[di + 0x1e] ; MOV_FAR
044AE2  8C D8                 MOV    ax, ds ; MOV
044AE4  0B C3                 OR     ax, bx ; LOGIC
