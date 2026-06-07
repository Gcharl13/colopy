; ============================================================================
; func_070580_unknown
; Region   : overlay
; Bytes    : file 0x070580..0x07068C  (268 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "DIFFICUL"  (auto-named via string xrefs)
; ============================================================================

070580  C8 12 03 00           ENTER  0x312, 0 ; PROLOGUE
070584  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
070589  8D 86 F0 FC           LEA    ax, [bp - 0x310] ; ADDR
07058D  16                    PUSH   ss ; STACK_PUSH
07058E  50                    PUSH   ax ; STACK_PUSH
07058F  2B C0                 SUB    ax, ax ; ARITH
070591  A3 0A A6              MOV    word ptr [0xa60a], ax ; GLOBAL_LOAD
070594  50                    PUSH   ax ; STACK_PUSH
070595  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
070599  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
07059D  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0705A1  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0705A5  68 2D 20              PUSH   0x202d                       ; STRING: "DIFFICUL"
0705A8  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
0705AD  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
0705B0  0B C0                 OR     ax, ax ; LOGIC
0705B2  74 24                 JE     0x705d8 ; CJUMP
0705B4  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
0705B8  8D 06 36 20           LEA    ax, [0x2036] ; ADDR
0705BC  2B D2                 SUB    dx, dx ; ARITH
0705BE  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
0705C3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0705C6  0B C0                 OR     ax, ax ; LOGIC
0705C8  7F 03                 JG     0x705cd ; CJUMP
0705CA  E9 A0 01              JMP    0x7076d ; JUMP
0705CD  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
0705D0  FE C8                 DEC    al ; ARITH
0705D2  A2 A6 53              MOV    byte ptr [0x53a6], al ; GLOBAL_LOAD
0705D5  E9 90 01              JMP    0x70768 ; JUMP
0705D8  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
0705DD  8D 86 F0 FC           LEA    ax, [bp - 0x310] ; ADDR
0705E1  16                    PUSH   ss ; STACK_PUSH
0705E2  50                    PUSH   ax ; STACK_PUSH
0705E3  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
0705E8  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0705EC  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0705F0  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0705F4  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0705F8  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0705FC  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
070600  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
070604  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
070608  68 C8 00              PUSH   0xc8 ; PUSH_CONST
07060B  2B C0                 SUB    ax, ax ; ARITH
07060D  99                    CDQ ; ARITH
07060E  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
070611  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
070616  6A 00                 PUSH   0 ; STACK_PUSH
070618  68 40 01              PUSH   0x140 ; PUSH_CONST
07061B  68 C8 00              PUSH   0xc8 ; PUSH_CONST
07061E  2B C0                 SUB    ax, ax ; ARITH
070620  99                    CDQ ; ARITH
070621  2B DB                 SUB    bx, bx ; ARITH
070623  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
070628  0E                    PUSH   cs ; STACK_PUSH
070629  E8 38 06              CALL   0x70c64 ; CALL_NEAR
07062C  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
070631  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
070636  2B C0                 SUB    ax, ax ; ARITH
070638  9A 66 04 1F 18        LCALL  0x181f, 0x466 ; THUNK -> 0x0ACB:0x0056 (thunk @file 0x01AA56 type B) overlay @file 0x0318F8
07063D  A1 0A A6              MOV    ax, word ptr [0xa60a] ; GLOBAL_LOAD
070640  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
070643  9A F6 00 1F 18        LCALL  0x181f, 0xf6 ; THUNK -> 0x0AE7:0x0002 (thunk @file 0x01A6E6 type B) overlay @file 0x026FF2
070648  0B C0                 OR     ax, ax ; LOGIC
07064A  74 2B                 JE     0x70677 ; CJUMP
07064C  9A E0 03 1F 18        LCALL  0x181f, 0x3e0 ; THUNK -> 0x0AE7:0x0016 (thunk @file 0x01A9D0 type B) overlay @file 0x027006
070651  89 86 EE FC           MOV    word ptr [bp - 0x312], ax ; LOCAL_STORE
070655  3D 20 00              CMP    ax, 0x20 ; CMP
070658  74 66                 JE     0x706c0 ; CJUMP
07065A  7F 70                 JG     0x706cc ; CJUMP
07065C  3D 1B 00              CMP    ax, 0x1b ; CMP
07065F  75 03                 JNE    0x70664 ; CJUMP
070661  E9 09 01              JMP    0x7076d ; JUMP
070664  77 11                 JA     0x70677 ; CJUMP
070666  2C 08                 SUB    al, 8 ; ARITH
070668  74 28                 JE     0x70692 ; CJUMP
07066A  FE C8                 DEC    al ; ARITH
07066C  74 52                 JE     0x706c0 ; CJUMP
07066E  2C 04                 SUB    al, 4 ; ARITH
070670  75 05                 JNE    0x70677 ; CJUMP
070672  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
070677  83 3E F0 07 00        CMP    word ptr [0x7f0], 0 ; CMP
07067C  75 03                 JNE    0x70681 ; CJUMP
07067E  E9 D4 00              JMP    0x70755 ; JUMP
070681  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
070686  75 03                 JNE    0x7068b ; CJUMP
070688  E9 CA 00              JMP    0x70755 ; JUMP
07068B  C7                    DB     0xC7 ; DATA_BYTE
