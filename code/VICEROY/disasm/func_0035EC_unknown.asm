; ============================================================================
; func_0035EC_unknown
; Region   : load_image
; Bytes    : file 0x0035EC..0x003621  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0035EC  C8 1A 00 00           ENTER  0x1a, 0 ; PROLOGUE
0035F0  57                    PUSH   di ; STACK_PUSH
0035F1  56                    PUSH   si ; STACK_PUSH
0035F2  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0035F5  0E                    PUSH   cs ; STACK_PUSH
0035F6  E8 3D FE              CALL   0x3436 ; CALL_NEAR
0035F9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0035FC  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
0035FF  8A 4E 12              MOV    cl, byte ptr [bp + 0x12] ; LOCAL_LOAD
003602  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
003605  D3 F8                 SAR    ax, cl ; LOGIC
003607  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
00360A  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
00360D  BA 01 00              MOV    dx, 1 ; MOV
003610  D3 E2                 SHL    dx, cl ; LOGIC
003612  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
003615  8B D8                 MOV    bx, ax ; MOV
003617  48                    DEC    ax ; ARITH
003618  F7 D8                 NEG    ax ; ARITH
00361A  01 46 10              ADD    word ptr [bp + 0x10], ax ; ARITH
00361D  8B C2                 MOV    ax, dx ; MOV
00361F  8B D3                 MOV    dx, bx ; MOV
