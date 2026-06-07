; ============================================================================
; func_03BC42_unknown
; Region   : overlay
; Bytes    : file 0x03BC42..0x03BC72  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03BC42  C8 60 00 00           ENTER  0x60, 0 ; PROLOGUE
03BC46  56                    PUSH   si ; STACK_PUSH
03BC47  A1 C6 8D              MOV    ax, word ptr [0x8dc6] ; GLOBAL_LOAD
03BC4A  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
03BC4D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BC50  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
03BC55  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03BC58  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
03BC5C  7C 3C                 JL     0x3bc9a ; CJUMP
03BC5E  6A 01                 PUSH   1 ; STACK_PUSH
03BC60  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
03BC63  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BC66  0E                    PUSH   cs ; STACK_PUSH
03BC67  E8 AB 07              CALL   0x3c415 ; CALL_NEAR
03BC6A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03BC6D  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
03BC70  8B C3                 MOV    ax, bx ; MOV
