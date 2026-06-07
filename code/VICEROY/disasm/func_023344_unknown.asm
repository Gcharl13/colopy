; ============================================================================
; func_023344_unknown
; Region   : overlay
; Bytes    : file 0x023344..0x02356B  (551 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023344  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
023348  2B C0                 SUB    ax, ax ; ARITH
02334A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02334D  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
023350  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
023353  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
023356  A1 96 00              MOV    ax, word ptr [0x96] ; GLOBAL_LOAD
023359  EB 79                 JMP    0x233d4 ; JUMP
02335B  90                    NOP ; NOP
02335C  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
023361  E9 B8 00              JMP    0x2341c ; JUMP
023364  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2 ; LOCAL_STORE
023369  E9 B0 00              JMP    0x2341c ; JUMP
02336C  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3 ; LOCAL_STORE
023371  E9 A8 00              JMP    0x2341c ; JUMP
023374  C7 46 FE 04 00        MOV    word ptr [bp - 2], 4 ; LOCAL_STORE
023379  E9 A0 00              JMP    0x2341c ; JUMP
02337C  C7 46 FE 05 00        MOV    word ptr [bp - 2], 5 ; LOCAL_STORE
023381  E9 98 00              JMP    0x2341c ; JUMP
023384  C7 46 FE 06 00        MOV    word ptr [bp - 2], 6 ; LOCAL_STORE
023389  E9 90 00              JMP    0x2341c ; JUMP
02338C  C7 46 FE 07 00        MOV    word ptr [bp - 2], 7 ; LOCAL_STORE
023391  E9 88 00              JMP    0x2341c ; JUMP
023394  C7 46 FE 08 00        MOV    word ptr [bp - 2], 8 ; LOCAL_STORE
023399  E9 80 00              JMP    0x2341c ; JUMP
02339C  C7 46 FE 09 00        MOV    word ptr [bp - 2], 9 ; LOCAL_STORE
0233A1  EB 79                 JMP    0x2341c ; JUMP
0233A3  90                    NOP ; NOP
0233A4  C7 46 FE 0A 00        MOV    word ptr [bp - 2], 0xa ; LOCAL_STORE
0233A9  EB 71                 JMP    0x2341c ; JUMP
0233AB  90                    NOP ; NOP
0233AC  C7 46 FE 0B 00        MOV    word ptr [bp - 2], 0xb ; LOCAL_STORE
0233B1  EB 69                 JMP    0x2341c ; JUMP
0233B3  90                    NOP ; NOP
0233B4  C7 46 FE 0C 00        MOV    word ptr [bp - 2], 0xc ; LOCAL_STORE
0233B9  EB 61                 JMP    0x2341c ; JUMP
0233BB  90                    NOP ; NOP
0233BC  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd ; LOCAL_STORE
0233C1  EB 59                 JMP    0x2341c ; JUMP
0233C3  90                    NOP ; NOP
0233C4  C7 46 FE 0E 00        MOV    word ptr [bp - 2], 0xe ; LOCAL_STORE
0233C9  EB 51                 JMP    0x2341c ; JUMP
0233CB  90                    NOP ; NOP
0233CC  C7 46 FE 0F 00        MOV    word ptr [bp - 2], 0xf ; LOCAL_STORE
0233D1  EB 49                 JMP    0x2341c ; JUMP
0233D3  90                    NOP ; NOP
0233D4  2D 20 00              SUB    ax, 0x20 ; ARITH
0233D7  3D 1B 00              CMP    ax, 0x1b ; CMP
0233DA  77 40                 JA     0x2341c ; CJUMP
0233DC  D1 E0                 SHL    ax, 1 ; LOGIC
0233DE  93                    XCHG   bx, ax ; MOV
0233DF  2E FF A7 04 25        JMP    word ptr cs:[bx + 0x2504] ; JUMP
0233E4  7C 24                 JL     0x2340a ; CJUMP
0233E6  84 24                 TEST   byte ptr [si], ah ; LOGIC
0233E8  8C 24                 MOV    word ptr [si], fs ; MOV
0233EA  94                    XCHG   sp, ax ; MOV
0233EB  24 9C                 AND    al, 0x9c ; LOGIC
0233ED  24 A4                 AND    al, 0xa4 ; LOGIC
0233EF  24 AC                 AND    al, 0xac ; LOGIC
0233F1  24 B4                 AND    al, 0xb4 ; LOGIC
0233F3  24 DC                 AND    al, 0xdc ; LOGIC
0233F5  24 DC                 AND    al, 0xdc ; LOGIC
0233F7  24 DC                 AND    al, 0xdc ; LOGIC
0233F9  24 DC                 AND    al, 0xdc ; LOGIC
0233FB  24 DC                 AND    al, 0xdc ; LOGIC
0233FD  24 DC                 AND    al, 0xdc ; LOGIC
0233FF  24 E4                 AND    al, 0xe4 ; LOGIC
023401  24 E4                 AND    al, 0xe4 ; LOGIC
023403  24 E4                 AND    al, 0xe4 ; LOGIC
023405  24 E4                 AND    al, 0xe4 ; LOGIC
023407  24 EC                 AND    al, 0xec ; LOGIC
023409  24 EC                 AND    al, 0xec ; LOGIC
02340B  24 3C                 AND    al, 0x3c ; LOGIC
02340D  25 EC 24              AND    ax, 0x24ec ; LOGIC
023410  EC                    IN     al, dx ; IO
023411  24 3C                 AND    al, 0x3c ; LOGIC
023413  25 C4 24              AND    ax, 0x24c4 ; LOGIC
023416  BC 24 CC              MOV    sp, 0xcc24 ; CONST_LOAD
023419  24 D4                 AND    al, 0xd4 ; LOGIC
02341B  24 8D                 AND    al, 0x8d ; LOGIC
02341D  1E                    PUSH   ds ; STACK_PUSH
02341E  7C 08                 JL     0x23428 ; CJUMP
023420  8D 06 88 0A           LEA    ax, [0xa88] ; ADDR
023424  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
023427  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
02342C  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02342F  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
023432  0B D0                 OR     dx, ax ; LOGIC
023434  75 03                 JNE    0x23439 ; CJUMP
023436  E9 30 01              JMP    0x23569 ; JUMP
023439  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
02343D  74 11                 JE     0x23450 ; CJUMP
02343F  6A 01                 PUSH   1 ; STACK_PUSH
023441  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
023444  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
023447  50                    PUSH   ax ; STACK_PUSH
023448  9A 3C 03 1F 19        LCALL  0x191f, 0x33c ; THUNK -> 0x0000:0x092A (thunk @file 0x01B92C type A) overlay @file 0x02622A
02344D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
023450  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
023453  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
023456  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
02345B  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02345E  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
023461  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
023464  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
023469  2B C0                 SUB    ax, ax ; ARITH
02346B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02346E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
023471  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
023474  7F 03                 JG     0x23479 ; CJUMP
023476  E9 F0 00              JMP    0x23569 ; JUMP
023479  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
02347C  E9 AD 00              JMP    0x2352c ; JUMP
02347F  90                    NOP ; NOP
023480  C7 46 F8 20 00        MOV    word ptr [bp - 8], 0x20 ; LOCAL_STORE
023485  E9 D0 00              JMP    0x23558 ; JUMP
023488  C7 46 F8 21 00        MOV    word ptr [bp - 8], 0x21 ; LOCAL_STORE
02348D  E9 C8 00              JMP    0x23558 ; JUMP
023490  C7 46 F8 22 00        MOV    word ptr [bp - 8], 0x22 ; LOCAL_STORE
023495  E9 C0 00              JMP    0x23558 ; JUMP
023498  C7 46 F8 23 00        MOV    word ptr [bp - 8], 0x23 ; LOCAL_STORE
02349D  E9 B8 00              JMP    0x23558 ; JUMP
0234A0  C7 46 F8 24 00        MOV    word ptr [bp - 8], 0x24 ; LOCAL_STORE
0234A5  E9 B0 00              JMP    0x23558 ; JUMP
0234A8  C7 46 F8 25 00        MOV    word ptr [bp - 8], 0x25 ; LOCAL_STORE
0234AD  E9 A8 00              JMP    0x23558 ; JUMP
0234B0  C7 46 F8 26 00        MOV    word ptr [bp - 8], 0x26 ; LOCAL_STORE
0234B5  E9 A0 00              JMP    0x23558 ; JUMP
0234B8  C7 46 F8 27 00        MOV    word ptr [bp - 8], 0x27 ; LOCAL_STORE
0234BD  E9 98 00              JMP    0x23558 ; JUMP
0234C0  C7 46 F8 39 00        MOV    word ptr [bp - 8], 0x39 ; LOCAL_STORE
0234C5  E9 90 00              JMP    0x23558 ; JUMP
0234C8  C7 46 F8 38 00        MOV    word ptr [bp - 8], 0x38 ; LOCAL_STORE
0234CD  E9 88 00              JMP    0x23558 ; JUMP
0234D0  C7 46 F8 3A 00        MOV    word ptr [bp - 8], 0x3a ; LOCAL_STORE
0234D5  E9 80 00              JMP    0x23558 ; JUMP
0234D8  C7 46 F8 3B 00        MOV    word ptr [bp - 8], 0x3b ; LOCAL_STORE
0234DD  EB 79                 JMP    0x23558 ; JUMP
0234DF  90                    NOP ; NOP
0234E0  8D 1E 92 0A           LEA    bx, [0xa92] ; ADDR
0234E4  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
0234E9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0234EC  0B C0                 OR     ax, ax ; LOGIC
0234EE  74 68                 JE     0x23558 ; CJUMP
0234F0  05 28 00              ADD    ax, 0x28 ; ARITH
0234F3  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0234F6  EB 60                 JMP    0x23558 ; JUMP
0234F8  8D 1E A3 0A           LEA    bx, [0xaa3] ; ADDR
0234FC  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
023501  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
023504  0B C0                 OR     ax, ax ; LOGIC
023506  74 50                 JE     0x23558 ; CJUMP
023508  05 2D 00              ADD    ax, 0x2d ; ARITH
02350B  EB E6                 JMP    0x234f3 ; JUMP
02350D  90                    NOP ; NOP
02350E  8D 1E B0 0A           LEA    bx, [0xab0] ; ADDR
023512  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
023517  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02351A  3D 02 00              CMP    ax, 2 ; CMP
02351D  7E 04                 JLE    0x23523 ; CJUMP
02351F  40                    INC    ax ; ARITH
023520  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
023523  0B C0                 OR     ax, ax ; LOGIC
023525  74 31                 JE     0x23558 ; CJUMP
023527  05 31 00              ADD    ax, 0x31 ; ARITH
02352A  EB C7                 JMP    0x234f3 ; JUMP
02352C  48                    DEC    ax ; ARITH
02352D  3D 0E 00              CMP    ax, 0xe ; CMP
023530  77 26                 JA     0x23558 ; CJUMP
023532  D1 E0                 SHL    ax, 1 ; LOGIC
023534  93                    XCHG   bx, ax ; MOV
023535  2E FF A7 5A 26        JMP    word ptr cs:[bx + 0x265a] ; JUMP
02353A  A0 25 A8              MOV    al, byte ptr [0xa825] ; GLOBAL_LOAD
02353D  25 B0 25              AND    ax, 0x25b0 ; LOGIC
023540  B8 25 C0              MOV    ax, 0xc025 ; CONST_LOAD
023543  25 C8 25              AND    ax, 0x25c8 ; LOGIC
023546  D0 25                 SHL    byte ptr [di], 1 ; LOGIC
023548  D8 25                 FSUB   dword ptr [di]               ; UNKNOWN
02354A  E0 25                 LOOPNE 0x23571 ; CJUMP
02354C  E8 25 F0              CALL   0x22574 ; CALL_NEAR
02354F  25 F8 25              AND    ax, 0x25f8 ; LOGIC
023552  00 26 18 26           ADD    byte ptr [0x2618], ah ; ARITH
023556  2E 26 83 7E F8 00     CMP    word ptr es:[bp - 8], 0 ; CMP
02355C  74 0B                 JE     0x23569 ; CJUMP
02355E  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
023561  A3 96 00              MOV    word ptr [0x96], ax ; GLOBAL_LOAD
023564  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
023569  C9                    LEAVE ; EPILOGUE
02356A  CB                    RETF ; RETURN
