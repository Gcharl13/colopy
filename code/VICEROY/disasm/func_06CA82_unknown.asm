; ============================================================================
; func_06CA82_unknown
; Region   : overlay
; Bytes    : file 0x06CA82..0x06CAA4  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CA82  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
06CA86  56                    PUSH   si ; STACK_PUSH
06CA87  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06CA8A  26 8B 47 58           MOV    ax, word ptr es:[bx + 0x58] ; MOV
06CA8E  26 8B 57 5A           MOV    dx, word ptr es:[bx + 0x5a] ; MOV
06CA92  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06CA95  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
06CA98  2B C0                 SUB    ax, ax ; ARITH
06CA9A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06CA9D  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06CAA0  8B C2                 MOV    ax, dx ; MOV
06CAA2  0B                    DB     0x0B ; DATA_BYTE
06CAA3  46                    DB     0x46 ; DATA_BYTE
