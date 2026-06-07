; ============================================================================
; func_07431E_unknown
; Region   : overlay
; Bytes    : file 0x07431E..0x074405  (231 bytes)
; Purpose  : Wood panel dialog background  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "WOODPANL"  (auto-named via string xrefs)
; ============================================================================

07431E  C8 60 00 00           ENTER  0x60, 0 ; PROLOGUE
074322  57                    PUSH   di ; STACK_PUSH
074323  56                    PUSH   si ; STACK_PUSH
074324  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1 ; LOCAL_STORE
074329  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
07432E  75 0C                 JNE    0x7433c ; CJUMP
074330  9A 66 0B 1F 1A        LCALL  0x1a1f, 0xb66 ; THUNK -> 0x0000:0x0790 (thunk @file 0x01D156 type A) overlay @file 0x026090
074335  0B C0                 OR     ax, ax ; LOGIC
074337  74 08                 JE     0x74341 ; CJUMP
074339  E9 AD 02              JMP    0x745e9 ; JUMP
07433C  C6 06 A6 53 02        MOV    byte ptr [0x53a6], 2 ; GLOBAL_LOAD
074341  80 3E A6 53 00        CMP    byte ptr [0x53a6], 0 ; CMP
074346  75 05                 JNE    0x7434d ; CJUMP
074348  80 0E 82 53 80        OR     byte ptr [0x5382], 0x80 ; LOGIC
07434D  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
074352  75 0C                 JNE    0x74360 ; CJUMP
074354  9A 74 0B 1F 1A        LCALL  0x1a1f, 0xb74 ; THUNK -> 0x0000:0x0C2A (thunk @file 0x01D164 type A) overlay @file 0x02652A
074359  0B C0                 OR     ax, ax ; LOGIC
07435B  74 12                 JE     0x7436f ; CJUMP
07435D  E9 89 02              JMP    0x745e9 ; JUMP
074360  6A 03                 PUSH   3 ; STACK_PUSH
074362  6A 00                 PUSH   0 ; STACK_PUSH
074364  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
074369  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07436C  A3 98 53              MOV    word ptr [0x5398], ax ; GLOBAL_LOAD
07436F  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
074372  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
074375  3D 03 00              CMP    ax, 3 ; CMP
074378  7E 06                 JLE    0x74380 ; CJUMP
07437A  C7 06 98 53 00 00     MOV    word ptr [0x5398], 0 ; GLOBAL_LOAD
074380  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
074385  74 03                 JE     0x7438a ; CJUMP
074387  E9 74 01              JMP    0x744fe ; JUMP
07438A  6A 00                 PUSH   0 ; STACK_PUSH
07438C  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
074390  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
074394  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
074398  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
07439C  68 89 21              PUSH   0x2189                       ; STRING: "WOODPANL"
07439F  9A 7A 08 1F 19        LCALL  0x191f, 0x87a ; THUNK -> 0x0000:0x000C (thunk @file 0x01BE6A type A) overlay @file 0x02590C
0743A4  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0743A7  3D 01 00              CMP    ax, 1 ; CMP
0743AA  1B C0                 SBB    ax, ax ; ARITH
0743AC  F7 D8                 NEG    ax ; ARITH
0743AE  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0743B1  0B C0                 OR     ax, ax ; LOGIC
0743B3  74 45                 JE     0x743fa ; CJUMP
0743B5  9A 0A 04 1F 18        LCALL  0x181f, 0x40a ; THUNK -> 0x0000:0x37F6 (thunk @file 0x01A9FA type A) overlay @file 0x0290F6
0743BA  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0743BE  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0743C2  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0743C6  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0743CA  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0743CE  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0743D2  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0743D6  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0743DA  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0743DD  2B C0                 SUB    ax, ax ; ARITH
0743DF  99                    CDQ ; ARITH
0743E0  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
0743E3  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
0743E8  6A 00                 PUSH   0 ; STACK_PUSH
0743EA  68 40 01              PUSH   0x140 ; PUSH_CONST
0743ED  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0743F0  2B C0                 SUB    ax, ax ; ARITH
0743F2  99                    CDQ ; ARITH
0743F3  2B DB                 SUB    bx, bx ; ARITH
0743F5  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0743FA  6A 17                 PUSH   0x17 ; PUSH_CONST
0743FC  6B 16 98 53 34        IMUL   dx, word ptr [0x5398], 0x34 ; ARITH
074401  81 C2 0E 54           ADD    dx, 0x540e ; ARITH
