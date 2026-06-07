; ============================================================================
; func_06076A_unknown
; Region   : overlay
; Bytes    : file 0x06076A..0x0607AB  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06076A  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
06076E  56                    PUSH   si ; STACK_PUSH
06076F  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
060774  2B C0                 SUB    ax, ax ; ARITH
060776  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
060779  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06077C  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
060780  26 80 7F 20 00        CMP    byte ptr es:[bx + 0x20], 0 ; CMP
060785  74 0B                 JE     0x60792 ; CJUMP
060787  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
06078B  8D 06 23 1D           LEA    ax, [0x1d23] ; ADDR
06078F  EB 09                 JMP    0x6079a ; JUMP
060791  90                    NOP ; NOP
060792  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
060796  8D 06 2C 1D           LEA    ax, [0x1d2c] ; ADDR
06079A  2B D2                 SUB    dx, dx ; ARITH
06079C  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
0607A1  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0607A4  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
0607A7  8B C2                 MOV    ax, dx ; MOV
0607A9  0B                    DB     0x0B ; DATA_BYTE
0607AA  46                    DB     0x46 ; DATA_BYTE
