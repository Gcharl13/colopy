; ============================================================================
; func_068FDC_unknown
; Region   : overlay
; Bytes    : file 0x068FDC..0x068FF3  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068FDC  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
068FE0  57                    PUSH   di ; STACK_PUSH
068FE1  56                    PUSH   si ; STACK_PUSH
068FE2  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
068FE5  D1 E3                 SHL    bx, 1 ; LOGIC
068FE7  C4 36 A6 1E           LES    si, ptr [0x1ea6] ; MOV_FAR
068FEB  26 8B 00              MOV    ax, word ptr es:[bx + si] ; MOV
068FEE  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
068FF1  8B C3                 MOV    ax, bx ; MOV
