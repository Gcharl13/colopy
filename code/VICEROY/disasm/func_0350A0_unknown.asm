; ============================================================================
; func_0350A0_unknown
; Region   : overlay
; Bytes    : file 0x0350A0..0x035105  (101 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0350A0  C8 74 00 00           ENTER  0x74, 0 ; PROLOGUE
0350A4  56                    PUSH   si ; STACK_PUSH
0350A5  2B C0                 SUB    ax, ax ; ARITH
0350A7  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
0350AA  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
0350AD  C7 06 5E 1F 02 00     MOV    word ptr [0x1f5e], 2 ; GLOBAL_LOAD
0350B3  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
0350B7  8D 06 11 11           LEA    ax, [0x1111] ; ADDR
0350BB  2B D2                 SUB    dx, dx ; ARITH
0350BD  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
0350C2  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
0350C5  89 56 96              MOV    word ptr [bp - 0x6a], dx ; LOCAL_STORE
0350C8  0B D0                 OR     dx, ax ; LOGIC
0350CA  75 03                 JNE    0x350cf ; CJUMP
0350CC  E9 59 02              JMP    0x35328 ; JUMP
0350CF  C4 5E 94              LES    bx, ptr [bp - 0x6c] ; MOV_FAR
0350D2  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1 ; LOGIC
0350D7  26 C7 47 22 08 00     MOV    word ptr es:[bx + 0x22], 8 ; MOV
0350DD  6A 01                 PUSH   1 ; STACK_PUSH
0350DF  FF 36 C0 2D           PUSH   word ptr [0x2dc0] ; PUSH_GLOBAL
0350E3  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0350E8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0350EB  52                    PUSH   dx ; STACK_PUSH
0350EC  50                    PUSH   ax ; STACK_PUSH
0350ED  FF 76 96              PUSH   word ptr [bp - 0x6a] ; PUSH_GLOBAL
0350F0  FF 76 94              PUSH   word ptr [bp - 0x6c] ; PUSH_GLOBAL
0350F3  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
0350F8  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0350FB  C7 46 8E 00 00        MOV    word ptr [bp - 0x72], 0 ; LOCAL_STORE
035100  8B 5E 8E              MOV    bx, word ptr [bp - 0x72] ; LOCAL_LOAD
035103  8B C3                 MOV    ax, bx ; MOV
