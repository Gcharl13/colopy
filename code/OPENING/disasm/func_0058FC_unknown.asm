; ============================================================================
; func_0058FC_unknown
; Region   : load_image
; Bytes    : file 0x0058FC..0x005918  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0058FC  55                    PUSH   bp ; STACK_PUSH
0058FD  8B EC                 MOV    bp, sp ; MOV
0058FF  56                    PUSH   si ; STACK_PUSH
005900  57                    PUSH   di ; STACK_PUSH
005901  B3 01                 MOV    bl, 1 ; MOV
005903  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
005906  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005909  33 D2                 XOR    dx, dx ; LOGIC
00590B  83 F9 0A              CMP    cx, 0xa ; CMP
00590E  75 01                 JNE    0x5911 ; CJUMP
005910  99                    CDQ ; ARITH
005911  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
005914  E9 45 17              JMP    0x705c ; JUMP
005917  00                    DB     0x00 ; DATA_BYTE
