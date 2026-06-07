; ============================================================================
; func_06AA88_unknown
; Region   : overlay
; Bytes    : file 0x06AA88..0x06AAD8  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06AA88  C8 6C 00 00           ENTER  0x6c, 0 ; PROLOGUE
06AA8C  56                    PUSH   si ; STACK_PUSH
06AA8D  0E                    PUSH   cs ; STACK_PUSH
06AA8E  E8 01 0C              CALL   0x6b692 ; CALL_NEAR
06AA91  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06AA94  2A E4                 SUB    ah, ah ; ARITH
06AA96  50                    PUSH   ax ; STACK_PUSH
06AA97  6A 05                 PUSH   5 ; STACK_PUSH
06AA99  68 40 01              PUSH   0x140 ; PUSH_CONST
06AA9C  6A 00                 PUSH   0 ; STACK_PUSH
06AA9E  FF 36 92 2E           PUSH   word ptr [0x2e92] ; PUSH_GLOBAL
06AAA2  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
06AAA7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AAAA  52                    PUSH   dx ; STACK_PUSH
06AAAB  50                    PUSH   ax ; STACK_PUSH
06AAAC  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06AAB1  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06AAB4  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
06AAB8  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06AABB  2A E4                 SUB    ah, ah ; ARITH
06AABD  05 07 00              ADD    ax, 7 ; ARITH
06AAC0  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
06AAC3  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
06AAC7  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06AACA  50                    PUSH   ax ; STACK_PUSH
06AACB  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
06AAD0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AAD3  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06AAD6  8B C3                 MOV    ax, bx ; MOV
