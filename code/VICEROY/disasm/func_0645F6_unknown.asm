; ============================================================================
; func_0645F6_unknown
; Region   : overlay
; Bytes    : file 0x0645F6..0x064659  (99 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0645F6  C8 26 00 00           ENTER  0x26, 0 ; PROLOGUE
0645FA  2B C0                 SUB    ax, ax ; ARITH
0645FC  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
0645FF  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
064602  FF 36 80 01           PUSH   word ptr [0x180] ; PUSH_GLOBAL
064606  FF 36 5E 01           PUSH   word ptr [0x15e] ; PUSH_GLOBAL
06460A  FF 36 5C 01           PUSH   word ptr [0x15c] ; PUSH_GLOBAL
06460E  FF 36 6A 01           PUSH   word ptr [0x16a] ; PUSH_GLOBAL
064612  FF 36 68 01           PUSH   word ptr [0x168] ; PUSH_GLOBAL
064616  9A B2 0F 1D 0D        LCALL  0xd1d, 0xfb2 ; LCALL
06461B  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
06461E  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
064621  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0 ; LOCAL_STORE
064626  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
064629  48                    DEC    ax ; ARITH
06462A  48                    DEC    ax ; ARITH
06462B  50                    PUSH   ax ; STACK_PUSH
06462C  6A 01                 PUSH   1 ; STACK_PUSH
06462E  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064633  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064636  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
064639  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
06463C  48                    DEC    ax ; ARITH
06463D  48                    DEC    ax ; ARITH
06463E  50                    PUSH   ax ; STACK_PUSH
06463F  6A 01                 PUSH   1 ; STACK_PUSH
064641  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064646  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064649  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
06464C  FF 36 C6 85           PUSH   word ptr [0x85c6] ; PUSH_GLOBAL
064650  FF 36 C4 85           PUSH   word ptr [0x85c4] ; PUSH_GLOBAL
064654  FF 36 C2 85           PUSH   word ptr [0x85c2] ; PUSH_GLOBAL
064658  FF                    DB     0xFF ; DATA_BYTE
