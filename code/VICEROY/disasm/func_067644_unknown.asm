; ============================================================================
; func_067644_unknown
; Region   : overlay
; Bytes    : file 0x067644..0x067700  (188 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067644  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
067648  56                    PUSH   si ; STACK_PUSH
067649  8B 76 0E              MOV    si, word ptr [bp + 0xe] ; LOCAL_LOAD
06764C  8D 46 0C              LEA    ax, [bp + 0xc] ; ADDR
06764F  50                    PUSH   ax ; STACK_PUSH
067650  8D 4E 0A              LEA    cx, [bp + 0xa] ; ADDR
067653  51                    PUSH   cx ; STACK_PUSH
067654  8D 56 08              LEA    dx, [bp + 8] ; ADDR
067657  52                    PUSH   dx ; STACK_PUSH
067658  8D 5E 06              LEA    bx, [bp + 6] ; ADDR
06765B  53                    PUSH   bx ; STACK_PUSH
06765C  9A 14 09 1F 1A        LCALL  0x1a1f, 0x914 ; THUNK -> 0x0000:0x0052 (thunk @file 0x01CF04 type A) overlay @file 0x025952
067661  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
067664  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
067667  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
06766C  74 06                 JE     0x67674 ; CJUMP
06766E  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
067671  EB 04                 JMP    0x67677 ; JUMP
067673  90                    NOP ; NOP
067674  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
067677  50                    PUSH   ax ; STACK_PUSH
067678  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06767B  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
06767E  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
067681  9A 68 09 1F 1A        LCALL  0x1a1f, 0x968 ; THUNK -> 0x0000:0x0D6C (thunk @file 0x01CF58 type A) overlay @file 0x02666C
067686  9A 88 08 1F 19        LCALL  0x191f, 0x888 ; THUNK -> 0x0000:0x00EA (thunk @file 0x01BE78 type A) overlay @file 0x0259EA
06768B  9A 96 08 1F 19        LCALL  0x191f, 0x896 ; THUNK -> 0x0000:0x0248 (thunk @file 0x01BE86 type A) overlay @file 0x025B48
067690  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
067693  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
067696  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
067699  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06769C  9A 2C 03 1F 18        LCALL  0x181f, 0x32c ; THUNK -> 0x0000:0x00C8 (thunk @file 0x01A91C type A) overlay @file 0x0259C8
0676A1  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0676A4  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0676A7  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0676AA  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0676AD  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0676B0  9A 44 03 1F 18        LCALL  0x181f, 0x344 ; THUNK -> 0x0000:0x04BC (thunk @file 0x01A934 type A) overlay @file 0x025DBC
0676B5  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0676B8  6A 00                 PUSH   0 ; STACK_PUSH
0676BA  89 76 FE              MOV    word ptr [bp - 2], si ; LOCAL_STORE
0676BD  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
0676C2  74 06                 JE     0x676ca ; CJUMP
0676C4  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0676C7  EB 04                 JMP    0x676cd ; JUMP
0676C9  90                    NOP ; NOP
0676CA  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
0676CD  50                    PUSH   ax ; STACK_PUSH
0676CE  56                    PUSH   si ; STACK_PUSH
0676CF  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0676D2  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0676D5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0676D8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0676DB  9A 38 0E 1F 18        LCALL  0x181f, 0xe38 ; THUNK -> 0x0000:0x0360 (thunk @file 0x01B428 type A) overlay @file 0x025C60
0676E0  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
0676E3  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0676E7  74 14                 JE     0x676fd ; CJUMP
0676E9  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0676EC  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0676EF  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0676F2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0676F5  9A F8 08 1F 1A        LCALL  0x1a1f, 0x8f8 ; THUNK -> 0x0000:0x023C (thunk @file 0x01CEE8 type A) overlay @file 0x025B3C
0676FA  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0676FD  5E                    POP    si ; STACK_POP
0676FE  C9                    LEAVE ; EPILOGUE
0676FF  CB                    RETF ; RETURN
