; ============================================================================
; func_03B9E0_unknown
; Region   : overlay
; Bytes    : file 0x03B9E0..0x03BA08  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B9E0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
03B9E4  2B C0                 SUB    ax, ax ; ARITH
03B9E6  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03B9E9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03B9EC  EB 2C                 JMP    0x3ba1a ; JUMP
03B9EE  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
03B9F1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03B9F4  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
03B9F9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B9FC  0B C0                 OR     ax, ax ; LOGIC
03B9FE  74 17                 JE     0x3ba17 ; CJUMP
03BA00  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
03BA03  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
03BA06  8B CB                 MOV    cx, bx ; MOV
