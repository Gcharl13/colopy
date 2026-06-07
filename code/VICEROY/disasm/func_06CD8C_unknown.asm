; ============================================================================
; func_06CD8C_unknown
; Region   : overlay
; Bytes    : file 0x06CD8C..0x06CDAE  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CD8C  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
06CD90  56                    PUSH   si ; STACK_PUSH
06CD91  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06CD94  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c] ; MOV
06CD98  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e] ; MOV
06CD9C  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06CD9F  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
06CDA2  2B C0                 SUB    ax, ax ; ARITH
06CDA4  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06CDA7  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06CDAA  8B C2                 MOV    ax, dx ; MOV
06CDAC  0B                    DB     0x0B ; DATA_BYTE
06CDAD  46                    DB     0x46 ; DATA_BYTE
