; ============================================================================
; func_0155BC_unknown
; Region   : load_image
; Bytes    : file 0x0155BC..0x0155D8  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0155BC  55                    PUSH   bp ; STACK_PUSH
0155BD  8B EC                 MOV    bp, sp ; MOV
0155BF  56                    PUSH   si ; STACK_PUSH
0155C0  57                    PUSH   di ; STACK_PUSH
0155C1  B3 01                 MOV    bl, 1 ; MOV
0155C3  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0155C6  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0155C9  33 D2                 XOR    dx, dx ; LOGIC
0155CB  83 F9 0A              CMP    cx, 0xa ; CMP
0155CE  75 01                 JNE    0x155d1 ; CJUMP
0155D0  99                    CDQ ; ARITH
0155D1  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0155D4  E9 0D 1A              JMP    0x16fe4 ; JUMP
0155D7  00                    DB     0x00 ; DATA_BYTE
