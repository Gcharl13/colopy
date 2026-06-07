; ============================================================================
; func_03BFD2_unknown
; Region   : overlay
; Bytes    : file 0x03BFD2..0x03C01C  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03BFD2  C8 74 00 00           ENTER  0x74, 0 ; PROLOGUE
03BFD6  56                    PUSH   si ; STACK_PUSH
03BFD7  2B C0                 SUB    ax, ax ; ARITH
03BFD9  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
03BFDC  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
03BFDF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BFE2  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
03BFE7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03BFEA  0E                    PUSH   cs ; STACK_PUSH
03BFEB  E8 2C 04              CALL   0x3c41a ; CALL_NEAR
03BFEE  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
03BFF1  2B C0                 SUB    ax, ax ; ARITH
03BFF3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03BFF6  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
03BFF9  EB 65                 JMP    0x3c060 ; JUMP
03BFFB  90                    NOP ; NOP
03BFFC  83 7E 96 19           CMP    word ptr [bp - 0x6a], 0x19 ; CMP
03C000  7D 50                 JGE    0x3c052 ; CJUMP
03C002  FF 76 96              PUSH   word ptr [bp - 0x6a] ; PUSH_GLOBAL
03C005  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C008  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
03C00D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03C010  0B C0                 OR     ax, ax ; LOGIC
03C012  75 35                 JNE    0x3c049 ; CJUMP
03C014  8A 46 98              MOV    al, byte ptr [bp - 0x68] ; LOCAL_LOAD
03C017  8B 5E 96              MOV    bx, word ptr [bp - 0x6a] ; LOCAL_LOAD
03C01A  8B CB                 MOV    cx, bx ; MOV
