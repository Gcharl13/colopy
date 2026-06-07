; ============================================================================
; func_005418_unknown
; Region   : load_image
; Bytes    : file 0x005418..0x005436  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005418  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00541C  FF 4E 06              DEC    word ptr [bp + 6] ; ARITH
00541F  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005422  C1 F8 03              SAR    ax, 3 ; LOGIC
005425  8A 4E 06              MOV    cl, byte ptr [bp + 6] ; LOCAL_LOAD
005428  80 E1 07              AND    cl, 7 ; LOGIC
00542B  BA 01 00              MOV    dx, 1 ; MOV
00542E  D3 E2                 SHL    dx, cl ; LOGIC
005430  8B D8                 MOV    bx, ax ; MOV
005432  8B C2                 MOV    ax, dx ; MOV
005434  22                    DB     0x22 ; DATA_BYTE
005435  87                    DB     0x87 ; DATA_BYTE
