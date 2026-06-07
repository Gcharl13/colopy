; ============================================================================
; func_06C7AA_unknown
; Region   : overlay
; Bytes    : file 0x06C7AA..0x06C7C3  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C7AA  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06C7AE  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06C7B1  26 8B 47 54           MOV    ax, word ptr es:[bx + 0x54] ; MOV
06C7B5  26 8B 57 56           MOV    dx, word ptr es:[bx + 0x56] ; MOV
06C7B9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06C7BC  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06C7BF  8B C2                 MOV    ax, dx ; MOV
06C7C1  0B                    DB     0x0B ; DATA_BYTE
06C7C2  46                    DB     0x46 ; DATA_BYTE
