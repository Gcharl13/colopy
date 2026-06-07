; ============================================================================
; func_071106_unknown
; Region   : overlay
; Bytes    : file 0x071106..0x071246  (320 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

071106  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
07110A  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
07110F  1E                    PUSH   ds ; STACK_PUSH
071110  68 54 85              PUSH   0x8554 ; PUSH_CONST
071113  1E                    PUSH   ds ; STACK_PUSH
071114  68 54 85              PUSH   0x8554 ; PUSH_CONST
071117  1E                    PUSH   ds ; STACK_PUSH
071118  68 54 01              PUSH   0x154 ; PUSH_CONST
07111B  9A AA 0C 1F 1A        LCALL  0x1a1f, 0xcaa ; THUNK -> 0x0B32:0x005C (thunk @file 0x01D29A type B) overlay @file 0x040656
071120  1E                    PUSH   ds ; STACK_PUSH
071121  68 54 85              PUSH   0x8554 ; PUSH_CONST
071124  8D 1E 8E 20           LEA    bx, [0x208e] ; ADDR
071128  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
07112D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
071130  0B C0                 OR     ax, ax ; LOGIC
071132  75 0A                 JNE    0x7113e ; CJUMP
071134  C7 06 58 01 01 00     MOV    word ptr [0x158], 1 ; GLOBAL_LOAD
07113A  E9 F6 00              JMP    0x71233 ; JUMP
07113D  90                    NOP ; NOP
07113E  50                    PUSH   ax ; STACK_PUSH
07113F  6A 01                 PUSH   1 ; STACK_PUSH
071141  6A 04                 PUSH   4 ; STACK_PUSH
071143  68 3A 85              PUSH   0x853a ; PUSH_CONST
071146  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
07114B  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
07114E  0B C0                 OR     ax, ax ; LOGIC
071150  75 0A                 JNE    0x7115c ; CJUMP
071152  C7 06 58 01 02 00     MOV    word ptr [0x158], 2 ; GLOBAL_LOAD
071158  E9 D8 00              JMP    0x71233 ; JUMP
07115B  90                    NOP ; NOP
07115C  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
07115F  6A 01                 PUSH   1 ; STACK_PUSH
071161  6A 02                 PUSH   2 ; STACK_PUSH
071163  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
071166  50                    PUSH   ax ; STACK_PUSH
071167  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
07116C  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
07116F  0B C0                 OR     ax, ax ; LOGIC
071171  74 DF                 JE     0x71152 ; CJUMP
071173  83 7E FC 04           CMP    word ptr [bp - 4], 4 ; CMP
071177  7F 02                 JG     0x7117b ; CJUMP
071179  7D 11                 JGE    0x7118c ; CJUMP
07117B  83 3E 52 01 00        CMP    word ptr [0x152], 0 ; CMP
071180  7C 0A                 JL     0x7118c ; CJUMP
071182  C7 06 58 01 03 00     MOV    word ptr [0x158], 3 ; GLOBAL_LOAD
071188  E9 A8 00              JMP    0x71233 ; JUMP
07118B  90                    NOP ; NOP
07118C  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
07118F  A3 52 01              MOV    word ptr [0x152], ax ; GLOBAL_LOAD
071192  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
071195  F7 2E 3A 85           IMUL   word ptr [0x853a] ; ARITH
071199  A3 A4 85              MOV    word ptr [0x85a4], ax ; GLOBAL_LOAD
07119C  89 16 A6 85           MOV    word ptr [0x85a6], dx ; GLOBAL_LOAD
0711A0  0E                    PUSH   cs ; STACK_PUSH
0711A1  E8 D8 02              CALL   0x7147c ; CALL_NEAR
0711A4  0B C0                 OR     ax, ax ; LOGIC
0711A6  74 03                 JE     0x711ab ; CJUMP
0711A8  E9 88 00              JMP    0x71233 ; JUMP
0711AB  39 06 5A 01           CMP    word ptr [0x15a], ax ; CMP
0711AF  75 77                 JNE    0x71228 ; CJUMP
0711B1  FF 36 5E 01           PUSH   word ptr [0x15e] ; PUSH_GLOBAL
0711B5  FF 36 5C 01           PUSH   word ptr [0x15c] ; PUSH_GLOBAL
0711B9  50                    PUSH   ax ; STACK_PUSH
0711BA  6A 01                 PUSH   1 ; STACK_PUSH
0711BC  A1 A4 85              MOV    ax, word ptr [0x85a4] ; GLOBAL_LOAD
0711BF  8B 16 A6 85           MOV    dx, word ptr [0x85a6] ; GLOBAL_LOAD
0711C3  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
0711C6  9A B4 0C 1F 1A        LCALL  0x1a1f, 0xcb4 ; THUNK -> 0x0B01:0x000E (thunk @file 0x01D2A4 type B)
0711CB  0B D0                 OR     dx, ax ; LOGIC
0711CD  75 09                 JNE    0x711d8 ; CJUMP
0711CF  C7 06 58 01 04 00     MOV    word ptr [0x158], 4 ; GLOBAL_LOAD
0711D5  EB 5C                 JMP    0x71233 ; JUMP
0711D7  90                    NOP ; NOP
0711D8  FF 36 62 01           PUSH   word ptr [0x162] ; PUSH_GLOBAL
0711DC  FF 36 60 01           PUSH   word ptr [0x160] ; PUSH_GLOBAL
0711E0  6A 00                 PUSH   0 ; STACK_PUSH
0711E2  6A 01                 PUSH   1 ; STACK_PUSH
0711E4  A1 A4 85              MOV    ax, word ptr [0x85a4] ; GLOBAL_LOAD
0711E7  8B 16 A6 85           MOV    dx, word ptr [0x85a6] ; GLOBAL_LOAD
0711EB  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
0711EE  9A B4 0C 1F 1A        LCALL  0x1a1f, 0xcb4 ; THUNK -> 0x0B01:0x000E (thunk @file 0x01D2A4 type B)
0711F3  0B D0                 OR     dx, ax ; LOGIC
0711F5  75 09                 JNE    0x71200 ; CJUMP
0711F7  C7 06 58 01 05 00     MOV    word ptr [0x158], 5 ; GLOBAL_LOAD
0711FD  EB 34                 JMP    0x71233 ; JUMP
0711FF  90                    NOP ; NOP
071200  FF 36 66 01           PUSH   word ptr [0x166] ; PUSH_GLOBAL
071204  FF 36 64 01           PUSH   word ptr [0x164] ; PUSH_GLOBAL
071208  6A 00                 PUSH   0 ; STACK_PUSH
07120A  6A 01                 PUSH   1 ; STACK_PUSH
07120C  A1 A4 85              MOV    ax, word ptr [0x85a4] ; GLOBAL_LOAD
07120F  8B 16 A6 85           MOV    dx, word ptr [0x85a6] ; GLOBAL_LOAD
071213  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
071216  9A B4 0C 1F 1A        LCALL  0x1a1f, 0xcb4 ; THUNK -> 0x0B01:0x000E (thunk @file 0x01D2A4 type B)
07121B  0B D0                 OR     dx, ax ; LOGIC
07121D  75 09                 JNE    0x71228 ; CJUMP
07121F  C7 06 58 01 06 00     MOV    word ptr [0x158], 6 ; GLOBAL_LOAD
071225  EB 0C                 JMP    0x71233 ; JUMP
071227  90                    NOP ; NOP
071228  2B C0                 SUB    ax, ax ; ARITH
07122A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
07122D  A3 58 01              MOV    word ptr [0x158], ax ; GLOBAL_LOAD
071230  E8 6D FD              CALL   0x70fa0 ; CALL_NEAR
071233  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
071237  74 08                 JE     0x71241 ; CJUMP
071239  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
07123C  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
071241  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
071244  C9                    LEAVE ; EPILOGUE
071245  CB                    RETF ; RETURN
