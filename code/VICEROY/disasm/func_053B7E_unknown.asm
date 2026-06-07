; ============================================================================
; func_053B7E_unknown
; Region   : overlay
; Bytes    : file 0x053B7E..0x053BC1  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

053B7E  C8 C0 01 00           ENTER  0x1c0, 0 ; PROLOGUE
053B82  57                    PUSH   di ; STACK_PUSH
053B83  56                    PUSH   si ; STACK_PUSH
053B84  2B C0                 SUB    ax, ax ; ARITH
053B86  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
053B89  89 86 76 FF           MOV    word ptr [bp - 0x8a], ax ; LOCAL_STORE
053B8D  89 46 80              MOV    word ptr [bp - 0x80], ax ; LOCAL_STORE
053B90  89 86 70 FF           MOV    word ptr [bp - 0x90], ax ; LOCAL_STORE
053B94  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
053B97  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
053B9C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
053B9F  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
053BA3  80 3F 2E              CMP    byte ptr [bx], 0x2e ; CMP
053BA6  75 0E                 JNE    0x53bb6 ; CJUMP
053BA8  80 7F 01 14           CMP    byte ptr [bx + 1], 0x14 ; CMP
053BAC  75 08                 JNE    0x53bb6 ; CJUMP
053BAE  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
053BB3  EB 06                 JMP    0x53bbb ; JUMP
053BB5  90                    NOP ; NOP
053BB6  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
053BBB  6A 02                 PUSH   2 ; STACK_PUSH
053BBD  6A 00                 PUSH   0 ; STACK_PUSH
053BBF  8B C3                 MOV    ax, bx ; MOV
