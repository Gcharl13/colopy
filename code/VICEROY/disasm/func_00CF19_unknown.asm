; ============================================================================
; func_00CF19_unknown
; Region   : load_image
; Bytes    : file 0x00CF19..0x00CF32  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CF19  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00CF1D  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00CF20  89 1E BA 05           MOV    word ptr [0x5ba], bx ; GLOBAL_LOAD
00CF24  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00CF27  A3 BC 05              MOV    word ptr [0x5bc], ax ; GLOBAL_LOAD
00CF2A  8B 16 B0 05           MOV    dx, word ptr [0x5b0] ; GLOBAL_LOAD
00CF2E  F7 E2                 MUL    dx ; ARITH
00CF30  03 C3                 ADD    ax, bx ; ARITH
