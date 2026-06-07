; ============================================================================
; func_00C4A4_unknown
; Region   : load_image
; Bytes    : file 0x00C4A4..0x00C4DB  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C4A4  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00C4A8  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
00C4AD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00C4B0  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
00C4B3  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
00C4B8  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00C4BB  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
00C4BE  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
00C4C1  C1 E3 02              SHL    bx, 2 ; LOGIC
00C4C4  89 87 C4 92           MOV    word ptr [bx - 0x6d3c], ax ; MOV
00C4C8  89 97 C6 92           MOV    word ptr [bx - 0x6d3a], dx ; MOV
00C4CC  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
00C4CF  83 7E FA 08           CMP    word ptr [bp - 6], 8 ; CMP
00C4D3  7C E3                 JL     0xc4b8 ; CJUMP
00C4D5  2B C0                 SUB    ax, ax ; ARITH
00C4D7  A3 C2 92              MOV    word ptr [0x92c2], ax ; GLOBAL_LOAD
00C4DA  89                    DB     0x89 ; DATA_BYTE
