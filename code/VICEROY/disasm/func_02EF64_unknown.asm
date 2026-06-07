; ============================================================================
; func_02EF64_unknown
; Region   : overlay
; Bytes    : file 0x02EF64..0x02F050  (236 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "DEADCONVERTS"  (auto-named via string xrefs)
; ============================================================================

02EF64  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
02EF68  56                    PUSH   si ; STACK_PUSH
02EF69  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
02EF6E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
02EF72  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
02EF76  2A E4                 SUB    ah, ah ; ARITH
02EF78  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02EF7B  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
02EF7F  2A ED                 SUB    ch, ch ; ARITH
02EF81  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
02EF84  51                    PUSH   cx ; STACK_PUSH
02EF85  50                    PUSH   ax ; STACK_PUSH
02EF86  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
02EF8B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02EF8E  0B C0                 OR     ax, ax ; LOGIC
02EF90  75 03                 JNE    0x2ef95 ; CJUMP
02EF92  E9 B5 00              JMP    0x2f04a ; JUMP
02EF95  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
02EF99  80 BF 46 31 00        CMP    byte ptr [bx + 0x3146], 0 ; CMP
02EF9E  74 03                 JE     0x2efa3 ; CJUMP
02EFA0  E9 A7 00              JMP    0x2f04a ; JUMP
02EFA3  80 BF 5B 31 1B        CMP    byte ptr [bx + 0x315b], 0x1b ; CMP
02EFA8  74 03                 JE     0x2efad ; CJUMP
02EFAA  E9 9D 00              JMP    0x2f04a ; JUMP
02EFAD  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02EFB0  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02EFB3  8B F3                 MOV    si, bx ; MOV
02EFB5  9A BE 06 1F 18        LCALL  0x181f, 0x6be ; THUNK -> 0x037F:0x03E4 (thunk @file 0x01ACAE type B) overlay @file 0x02EF20
02EFBA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02EFBD  0B C0                 OR     ax, ax ; LOGIC
02EFBF  7C 03                 JL     0x2efc4 ; CJUMP
02EFC1  E9 86 00              JMP    0x2f04a ; JUMP
02EFC4  6A 02                 PUSH   2 ; STACK_PUSH
02EFC6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02EFC9  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
02EFCE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02EFD1  3D 02 00              CMP    ax, 2 ; CMP
02EFD4  7D 74                 JGE    0x2f04a ; CJUMP
02EFD6  FE 84 5A 31           INC    byte ptr [si + 0x315a] ; ARITH
02EFDA  80 BC 5A 31 08        CMP    byte ptr [si + 0x315a], 8 ; CMP
02EFDF  76 69                 JBE    0x2f04a ; CJUMP
02EFE1  8A 84 47 31           MOV    al, byte ptr [si + 0x3147] ; MOV
02EFE5  25 0F 00              AND    ax, 0xf ; LOGIC
02EFE8  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02EFEB  3D 04 00              CMP    ax, 4 ; CMP
02EFEE  7D 18                 JGE    0x2f008 ; CJUMP
02EFF0  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
02EFF3  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02EFF8  75 0E                 JNE    0x2f008 ; CJUMP
02EFFA  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02EFFD  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02F000  9A 9A 0D 1F 18        LCALL  0x181f, 0xd9a ; THUNK -> 0x0984:0x03B2 (thunk @file 0x01B38A type B) overlay @file 0x0322C8
02F005  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02F008  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02F00B  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
02F010  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02F013  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
02F018  83 7E F8 04           CMP    word ptr [bp - 8], 4 ; CMP
02F01C  7D 2C                 JGE    0x2f04a ; CJUMP
02F01E  6B 5E F8 34           IMUL   bx, word ptr [bp - 8], 0x34 ; ARITH
02F022  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02F027  75 21                 JNE    0x2f04a ; CJUMP
02F029  6A 01                 PUSH   1 ; STACK_PUSH
02F02B  6A 01                 PUSH   1 ; STACK_PUSH
02F02D  6A 01                 PUSH   1 ; STACK_PUSH
02F02F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02F032  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02F035  9A BA 09 1F 18        LCALL  0x181f, 0x9ba ; THUNK -> 0x0000:0x0004 (thunk @file 0x01AFAA type A) overlay @file 0x025904
02F03A  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
02F03D  6A 04                 PUSH   4 ; STACK_PUSH
02F03F  68 E2 0E              PUSH   0xee2                        ; STRING: "DEADCONVERTS"
02F042  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
02F047  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02F04A  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
02F04D  5E                    POP    si ; STACK_POP
02F04E  C9                    LEAVE ; EPILOGUE
02F04F  CB                    RETF ; RETURN
