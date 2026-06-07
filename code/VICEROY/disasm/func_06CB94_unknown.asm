; ============================================================================
; func_06CB94_unknown
; Region   : overlay
; Bytes    : file 0x06CB94..0x06CBB7  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CB94  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
06CB98  57                    PUSH   di ; STACK_PUSH
06CB99  56                    PUSH   si ; STACK_PUSH
06CB9A  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06CB9D  26 8B 47 60           MOV    ax, word ptr es:[bx + 0x60] ; MOV
06CBA1  26 8B 57 62           MOV    dx, word ptr es:[bx + 0x62] ; MOV
06CBA5  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06CBA8  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06CBAB  2B C0                 SUB    ax, ax ; ARITH
06CBAD  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06CBB0  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06CBB3  8B C2                 MOV    ax, dx ; MOV
06CBB5  0B                    DB     0x0B ; DATA_BYTE
06CBB6  46                    DB     0x46 ; DATA_BYTE
