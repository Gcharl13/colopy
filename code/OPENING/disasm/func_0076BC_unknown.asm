; ============================================================================
; func_0076BC_unknown
; Region   : load_image
; Bytes    : file 0x0076BC..0x007769  (173 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0076BC  55                    PUSH   bp ; STACK_PUSH
0076BD  8B EC                 MOV    bp, sp ; MOV
0076BF  B8 AE 00              MOV    ax, 0xae ; CONST_LOAD
0076C2  9A DC 03 52 04        LCALL  0x452, 0x3dc ; LCALL
0076C7  56                    PUSH   si ; STACK_PUSH
0076C8  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0076CB  C7 46 D8 01 00        MOV    word ptr [bp - 0x28], 1 ; LOCAL_STORE
0076D0  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0 ; LOCAL_STORE
0076D5  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
0076D9  75 46                 JNE    0x7721 ; CJUMP
0076DB  89 76 DC              MOV    word ptr [bp - 0x24], si ; LOCAL_STORE
0076DE  B8 D0 45              MOV    ax, 0x45d0 ; CONST_LOAD
0076E1  50                    PUSH   ax ; STACK_PUSH
0076E2  9A 3C 25 52 04        LCALL  0x452, 0x253c ; LCALL
0076E7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0076EA  8B F0                 MOV    si, ax ; MOV
0076EC  0B F6                 OR     si, si ; LOGIC
0076EE  75 0C                 JNE    0x76fc ; CJUMP
0076F0  C7 06 A0 42 08 00     MOV    word ptr [0x42a0], 8 ; GLOBAL_LOAD
0076F6  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0076F9  E9 4E 01              JMP    0x784a ; JUMP
0076FC  FF 76 DC              PUSH   word ptr [bp - 0x24] ; PUSH_GLOBAL
0076FF  56                    PUSH   si ; STACK_PUSH
007700  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
007704  50                    PUSH   ax ; STACK_PUSH
007705  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
007708  50                    PUSH   ax ; STACK_PUSH
007709  8D 46 D2              LEA    ax, [bp - 0x2e] ; ADDR
00770C  50                    PUSH   ax ; STACK_PUSH
00770D  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
007710  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007713  9A 0C 2A 52 04        LCALL  0x452, 0x2a0c ; LCALL
007718  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
00771B  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
00771E  40                    INC    ax ; ARITH
00771F  74 D5                 JE     0x76f6 ; CJUMP
007721  B8 20 00              MOV    ax, 0x20 ; CONST_LOAD
007724  50                    PUSH   ax ; STACK_PUSH
007725  B8 00 80              MOV    ax, 0x8000 ; CONST_LOAD
007728  50                    PUSH   ax ; STACK_PUSH
007729  56                    PUSH   si ; STACK_PUSH
00772A  9A 34 22 52 04        LCALL  0x452, 0x2234 ; LCALL
00772F  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
007732  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
007735  40                    INC    ax ; ARITH
007736  75 14                 JNE    0x774c ; CJUMP
007738  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0 ; CMP
00773C  74 B8                 JE     0x76f6 ; CJUMP
00773E  FF 76 D2              PUSH   word ptr [bp - 0x2e] ; PUSH_GLOBAL
007741  9A 36 25 52 04        LCALL  0x452, 0x2536 ; LCALL
007746  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007749  EB AB                 JMP    0x76f6 ; JUMP
00774B  90                    NOP ; NOP
00774C  B8 18 00              MOV    ax, 0x18 ; CONST_LOAD
00774F  50                    PUSH   ax ; STACK_PUSH
007750  8D 46 E2              LEA    ax, [bp - 0x1e] ; ADDR
007753  50                    PUSH   ax ; STACK_PUSH
007754  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
007757  9A 64 1B 52 04        LCALL  0x452, 0x1b64 ; LCALL
00775C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00775F  40                    INC    ax ; ARITH
007760  75 2C                 JNE    0x778e ; CJUMP
007762  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
007765  9A                    DB     0x9A ; DATA_BYTE
007766  CA                    DB     0xCA ; DATA_BYTE
007767  1A                    DB     0x1A ; DATA_BYTE
007768  52                    DB     0x52 ; DATA_BYTE
