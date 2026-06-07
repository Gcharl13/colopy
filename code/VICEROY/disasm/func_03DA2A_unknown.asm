; ============================================================================
; func_03DA2A_unknown
; Region   : overlay
; Bytes    : file 0x03DA2A..0x03DB05  (219 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "DECOIND"  (auto-named via string xrefs)
; ============================================================================

03DA2A  C8 1E 05 00           ENTER  0x51e, 0 ; PROLOGUE
03DA2E  56                    PUSH   si ; STACK_PUSH
03DA2F  8D 86 04 FB           LEA    ax, [bp - 0x4fc] ; ADDR
03DA33  16                    PUSH   ss ; STACK_PUSH
03DA34  50                    PUSH   ax ; STACK_PUSH
03DA35  6A 00                 PUSH   0 ; STACK_PUSH
03DA37  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
03DA3B  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
03DA3F  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
03DA43  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
03DA47  68 E8 12              PUSH   0x12e8                       ; STRING: "DECOIND"
03DA4A  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
03DA4F  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
03DA52  0B C0                 OR     ax, ax ; LOGIC
03DA54  74 03                 JE     0x3da59 ; CJUMP
03DA56  E9 E9 03              JMP    0x3de42 ; JUMP
03DA59  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
03DA5E  C7 06 72 03 00 00     MOV    word ptr [0x372], 0 ; GLOBAL_LOAD
03DA64  8D 86 04 FB           LEA    ax, [bp - 0x4fc] ; ADDR
03DA68  16                    PUSH   ss ; STACK_PUSH
03DA69  50                    PUSH   ax ; STACK_PUSH
03DA6A  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
03DA6F  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
03DA73  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
03DA77  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
03DA7B  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
03DA7F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
03DA83  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
03DA87  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
03DA8B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03DA8F  68 C8 00              PUSH   0xc8 ; PUSH_CONST
03DA92  2B C0                 SUB    ax, ax ; ARITH
03DA94  99                    CDQ ; ARITH
03DA95  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
03DA98  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
03DA9D  6A 00                 PUSH   0 ; STACK_PUSH
03DA9F  68 40 01              PUSH   0x140 ; PUSH_CONST
03DAA2  68 C8 00              PUSH   0xc8 ; PUSH_CONST
03DAA5  2B C0                 SUB    ax, ax ; ARITH
03DAA7  99                    CDQ ; ARITH
03DAA8  2B DB                 SUB    bx, bx ; ARITH
03DAAA  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
03DAAF  9A DE 0F 1F 19        LCALL  0x191f, 0xfde ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5CE type A) overlay @file 0x025900
03DAB4  6B 06 98 53 34        IMUL   ax, word ptr [0x5398], 0x34 ; ARITH
03DAB9  05 0E 54              ADD    ax, 0x540e ; ARITH
03DABC  50                    PUSH   ax ; STACK_PUSH
03DABD  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
03DAC0  50                    PUSH   ax ; STACK_PUSH
03DAC1  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
03DAC6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03DAC9  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
03DACC  50                    PUSH   ax ; STACK_PUSH
03DACD  9A 46 0D 1D 0D        LCALL  0xd1d, 0xd46 ; LCALL
03DAD2  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03DAD5  6A 1A                 PUSH   0x1a ; PUSH_CONST
03DAD7  6A 00                 PUSH   0 ; STACK_PUSH
03DAD9  8D 86 E8 FA           LEA    ax, [bp - 0x518] ; ADDR
03DADD  50                    PUSH   ax ; STACK_PUSH
03DADE  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
03DAE3  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03DAE6  6A 1A                 PUSH   0x1a ; PUSH_CONST
03DAE8  6A 00                 PUSH   0 ; STACK_PUSH
03DAEA  8D 86 CC FE           LEA    ax, [bp - 0x134] ; ADDR
03DAEE  50                    PUSH   ax ; STACK_PUSH
03DAEF  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
03DAF4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03DAF7  C7 86 E4 FA 01 00     MOV    word ptr [bp - 0x51c], 1 ; LOCAL_STORE
03DAFD  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
03DB00  89 86 CA FE           MOV    word ptr [bp - 0x136], ax ; LOCAL_STORE
03DB04  EB                    DB     0xEB ; DATA_BYTE
