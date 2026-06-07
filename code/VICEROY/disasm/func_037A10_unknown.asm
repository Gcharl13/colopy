; ============================================================================
; func_037A10_unknown
; Region   : overlay
; Bytes    : file 0x037A10..0x037A9C  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

037A10  C8 6E 00 00           ENTER  0x6e, 0 ; PROLOGUE
037A14  56                    PUSH   si ; STACK_PUSH
037A15  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
037A18  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
037A1D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037A20  6A 03                 PUSH   3 ; STACK_PUSH
037A22  0E                    PUSH   cs ; STACK_PUSH
037A23  E8 2D 24              CALL   0x39e53 ; CALL_NEAR
037A26  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037A29  68 90 00              PUSH   0x90 ; PUSH_CONST
037A2C  6A 05                 PUSH   5 ; STACK_PUSH
037A2E  68 40 01              PUSH   0x140 ; PUSH_CONST
037A31  6A 00                 PUSH   0 ; STACK_PUSH
037A33  FF 36 04 2E           PUSH   word ptr [0x2e04] ; PUSH_GLOBAL
037A37  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
037A3C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037A3F  52                    PUSH   dx ; STACK_PUSH
037A40  50                    PUSH   ax ; STACK_PUSH
037A41  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
037A46  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
037A49  C7 46 AA 04 00        MOV    word ptr [bp - 0x56], 4 ; LOCAL_STORE
037A4E  C7 46 A6 19 00        MOV    word ptr [bp - 0x5a], 0x19 ; LOCAL_STORE
037A53  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
037A57  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
037A5C  75 62                 JNE    0x37ac0 ; CJUMP
037A5E  FF 36 9A 2E           PUSH   word ptr [0x2e9a] ; PUSH_GLOBAL
037A62  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
037A65  50                    PUSH   ax ; STACK_PUSH
037A66  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
037A6B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
037A6E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
037A71  50                    PUSH   ax ; STACK_PUSH
037A72  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
037A77  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037A7A  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
037A7E  83 7F 12 00           CMP    word ptr [bx + 0x12], 0 ; CMP
037A82  7D 03                 JGE    0x37a87 ; CJUMP
037A84  E9 81 00              JMP    0x37b08 ; JUMP
037A87  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
037A8A  50                    PUSH   ax ; STACK_PUSH
037A8B  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
037A90  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037A93  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
037A97  8B 5F 12              MOV    bx, word ptr [bx + 0x12] ; MOV
037A9A  8B C3                 MOV    ax, bx ; MOV
