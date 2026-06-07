; ============================================================================
; func_06C850_unknown
; Region   : overlay
; Bytes    : file 0x06C850..0x06C872  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C850  C8 20 00 00           ENTER  0x20, 0 ; PROLOGUE
06C854  56                    PUSH   si ; STACK_PUSH
06C855  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06C858  26 8B 47 54           MOV    ax, word ptr es:[bx + 0x54] ; MOV
06C85C  26 8B 57 56           MOV    dx, word ptr es:[bx + 0x56] ; MOV
06C860  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
06C863  89 56 E2              MOV    word ptr [bp - 0x1e], dx ; LOCAL_STORE
06C866  2B C0                 SUB    ax, ax ; ARITH
06C868  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
06C86B  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
06C86E  8B C2                 MOV    ax, dx ; MOV
06C870  0B                    DB     0x0B ; DATA_BYTE
06C871  46                    DB     0x46 ; DATA_BYTE
