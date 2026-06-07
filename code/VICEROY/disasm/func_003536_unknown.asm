; ============================================================================
; func_003536_unknown
; Region   : load_image
; Bytes    : file 0x003536..0x00356B  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003536  C8 1A 00 00           ENTER  0x1a, 0 ; PROLOGUE
00353A  57                    PUSH   di ; STACK_PUSH
00353B  56                    PUSH   si ; STACK_PUSH
00353C  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00353F  0E                    PUSH   cs ; STACK_PUSH
003540  E8 F3 FE              CALL   0x3436 ; CALL_NEAR
003543  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
003546  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
003549  8A 4E 12              MOV    cl, byte ptr [bp + 0x12] ; LOCAL_LOAD
00354C  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
00354F  D3 F8                 SAR    ax, cl ; LOGIC
003551  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
003554  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
003557  BA 01 00              MOV    dx, 1 ; MOV
00355A  D3 E2                 SHL    dx, cl ; LOGIC
00355C  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
00355F  8B D8                 MOV    bx, ax ; MOV
003561  48                    DEC    ax ; ARITH
003562  F7 D8                 NEG    ax ; ARITH
003564  01 46 10              ADD    word ptr [bp + 0x10], ax ; ARITH
003567  8B C2                 MOV    ax, dx ; MOV
003569  8B D3                 MOV    dx, bx ; MOV
