; ============================================================================
; func_004938_unknown
; Region   : load_image
; Bytes    : file 0x004938..0x004954  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004938  55                    PUSH   bp ; STACK_PUSH
004939  8B EC                 MOV    bp, sp ; MOV
00493B  56                    PUSH   si ; STACK_PUSH
00493C  57                    PUSH   di ; STACK_PUSH
00493D  B3 01                 MOV    bl, 1 ; MOV
00493F  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
004942  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004945  33 D2                 XOR    dx, dx ; LOGIC
004947  83 F9 0A              CMP    cx, 0xa ; CMP
00494A  75 01                 JNE    0x494d ; CJUMP
00494C  99                    CDQ ; ARITH
00494D  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
004950  E9 09 17              JMP    0x605c ; JUMP
004953  00                    DB     0x00 ; DATA_BYTE
