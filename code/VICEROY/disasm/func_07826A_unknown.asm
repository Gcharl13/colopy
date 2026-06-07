; ============================================================================
; func_07826A_unknown
; Region   : overlay
; Bytes    : file 0x07826A..0x0782D3  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

07826A  C8 12 03 00           ENTER  0x312, 0 ; PROLOGUE
07826E  50                    PUSH   ax ; STACK_PUSH
07826F  57                    PUSH   di ; STACK_PUSH
078270  56                    PUSH   si ; STACK_PUSH
078271  8D 86 F6 FC           LEA    ax, [bp - 0x30a] ; ADDR
078275  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
078278  8C 56 FE              MOV    word ptr [bp - 2], ss ; LOCAL_STORE
07827B  2B C9                 SUB    cx, cx ; ARITH
07827D  89 0E 3A 83           MOV    word ptr [0x833a], cx ; GLOBAL_LOAD
078281  89 0E 38 83           MOV    word ptr [0x8338], cx ; GLOBAL_LOAD
078285  6A 03                 PUSH   3 ; STACK_PUSH
078287  16                    PUSH   ss ; STACK_PUSH
078288  50                    PUSH   ax ; STACK_PUSH
078289  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
07828C  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
07828F  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
078292  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
078295  52                    PUSH   dx ; STACK_PUSH
078296  50                    PUSH   ax ; STACK_PUSH
078297  0E                    PUSH   cs ; STACK_PUSH
078298  E8 43 01              CALL   0x783de ; CALL_NEAR
07829B  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
07829E  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
0782A3  9A 22 00 0C 0C        LCALL  0xc0c, 0x22 ; LCALL
0782A8  8B C8                 MOV    cx, ax ; MOV
0782AA  8B 86 EC FC           MOV    ax, word ptr [bp - 0x314] ; LOCAL_LOAD
0782AE  8B DA                 MOV    bx, dx ; MOV
0782B0  99                    CDQ ; ARITH
0782B1  03 C1                 ADD    ax, cx ; ARITH
0782B3  13 D3                 ADC    dx, bx ; ARITH
0782B5  89 86 F2 FC           MOV    word ptr [bp - 0x30e], ax ; LOCAL_STORE
0782B9  89 96 F4 FC           MOV    word ptr [bp - 0x30c], dx ; LOCAL_STORE
0782BD  1E                    PUSH   ds ; STACK_PUSH
0782BE  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
0782C1  C4 7E F8              LES    di, ptr [bp - 8] ; MOV_FAR
0782C4  C5 76 F8              LDS    si, ptr [bp - 8] ; MOV_FAR
0782C7  B9 00 03              MOV    cx, 0x300 ; CONST_LOAD
0782CA  AC                    LODSB  al, byte ptr [si] ; STR
0782CB  36 8A 17              MOV    dl, byte ptr ss:[bx] ; MOV
0782CE  43                    INC    bx ; ARITH
0782CF  2A C2                 SUB    al, dl ; ARITH
0782D1  73 02                 JAE    0x782d5 ; CJUMP
