; ============================================================================
; func_03B980_unknown
; Region   : overlay
; Bytes    : file 0x03B980..0x03B9AA  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B980  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
03B984  56                    PUSH   si ; STACK_PUSH
03B985  2B C0                 SUB    ax, ax ; ARITH
03B987  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03B98A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03B98D  EB 45                 JMP    0x3b9d4 ; JUMP
03B98F  90                    NOP ; NOP
03B990  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
03B993  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03B996  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
03B99B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B99E  0B C0                 OR     ax, ax ; LOGIC
03B9A0  75 2F                 JNE    0x3b9d1 ; CJUMP
03B9A2  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
03B9A5  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
03B9A8  8B CB                 MOV    cx, bx ; MOV
