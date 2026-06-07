; ============================================================================
; func_06AE08_unknown
; Region   : overlay
; Bytes    : file 0x06AE08..0x06AE58  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06AE08  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
06AE0C  56                    PUSH   si ; STACK_PUSH
06AE0D  0E                    PUSH   cs ; STACK_PUSH
06AE0E  E8 81 08              CALL   0x6b692 ; CALL_NEAR
06AE11  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06AE14  2A E4                 SUB    ah, ah ; ARITH
06AE16  50                    PUSH   ax ; STACK_PUSH
06AE17  6A 05                 PUSH   5 ; STACK_PUSH
06AE19  68 40 01              PUSH   0x140 ; PUSH_CONST
06AE1C  6A 00                 PUSH   0 ; STACK_PUSH
06AE1E  FF 36 92 2E           PUSH   word ptr [0x2e92] ; PUSH_GLOBAL
06AE22  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
06AE27  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AE2A  52                    PUSH   dx ; STACK_PUSH
06AE2B  50                    PUSH   ax ; STACK_PUSH
06AE2C  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06AE31  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06AE34  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
06AE38  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06AE3B  2A E4                 SUB    ah, ah ; ARITH
06AE3D  05 07 00              ADD    ax, 7 ; ARITH
06AE40  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
06AE43  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
06AE47  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AE4A  50                    PUSH   ax ; STACK_PUSH
06AE4B  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
06AE50  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AE53  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06AE56  8B C3                 MOV    ax, bx ; MOV
