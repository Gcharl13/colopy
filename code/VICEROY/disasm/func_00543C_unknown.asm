; ============================================================================
; func_00543C_unknown
; Region   : load_image
; Bytes    : file 0x00543C..0x0054BF  (131 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00543C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
005440  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
005445  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
005449  7E 1A                 JLE    0x5465 ; CJUMP
00544B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00544E  0E                    PUSH   cs ; STACK_PUSH
00544F  E8 C6 FF              CALL   0x5418 ; CALL_NEAR
005452  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005455  0B C0                 OR     ax, ax ; LOGIC
005457  75 7C                 JNE    0x54d5 ; CJUMP
005459  6A 01                 PUSH   1 ; STACK_PUSH
00545B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00545E  0E                    PUSH   cs ; STACK_PUSH
00545F  E8 7C FF              CALL   0x53de ; CALL_NEAR
005462  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005465  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005468  EB 3C                 JMP    0x54a6 ; JUMP
00546A  90                    NOP ; NOP
00546B  90                    NOP ; NOP
00546C  83 3E A0 00 00        CMP    word ptr [0xa0], 0 ; CMP
005471  74 57                 JE     0x54ca ; CJUMP
005473  83 3E A2 00 00        CMP    word ptr [0xa2], 0 ; CMP
005478  75 50                 JNE    0x54ca ; CJUMP
00547A  6A 02                 PUSH   2 ; STACK_PUSH
00547C  9A 18 03 9F 02        LCALL  0x29f, 0x318 ; LCALL
005481  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005484  EB 44                 JMP    0x54ca ; JUMP
005486  6A 02                 PUSH   2 ; STACK_PUSH
005488  9A 4C 03 9F 02        LCALL  0x29f, 0x34c ; LCALL
00548D  EB F2                 JMP    0x5481 ; JUMP
00548F  90                    NOP ; NOP
005490  6A 33                 PUSH   0x33 ; PUSH_CONST
005492  9A CC 02 9F 02        LCALL  0x29f, 0x2cc ; LCALL
005497  EB E8                 JMP    0x5481 ; JUMP
005499  90                    NOP ; NOP
00549A  6A 35                 PUSH   0x35 ; PUSH_CONST
00549C  EB F4                 JMP    0x5492 ; JUMP
00549E  6A 36                 PUSH   0x36 ; PUSH_CONST
0054A0  EB F0                 JMP    0x5492 ; JUMP
0054A2  6A 39                 PUSH   0x39 ; PUSH_CONST
0054A4  EB EC                 JMP    0x5492 ; JUMP
0054A6  3D 0A 00              CMP    ax, 0xa ; CMP
0054A9  77 1F                 JA     0x54ca ; CJUMP
0054AB  D1 E0                 SHL    ax, 1 ; LOGIC
0054AD  93                    XCHG   bx, ax ; MOV
0054AE  2E FF A7 E4 00        JMP    word ptr cs:[bx + 0xe4] ; JUMP
0054B3  90                    NOP ; NOP
0054B4  9C                    PUSHF ; STACK_PUSH
0054B5  00 9C 00 B6           ADD    byte ptr [si - 0x4a00], bl ; ARITH
0054B9  00 C0                 ADD    al, al ; ARITH
0054BB  00 CA                 ADD    dl, cl ; ARITH
0054BD  00 CE                 ADD    dh, cl ; ARITH
