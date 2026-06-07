; ============================================================================
; func_004EE6_unknown
; Region   : load_image
; Bytes    : file 0x004EE6..0x00500F  (297 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004EE6  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
004EEA  83 3E A2 00 00        CMP    word ptr [0xa2], 0 ; CMP
004EEF  75 0A                 JNE    0x4efb ; CJUMP
004EF1  83 3E 9E 00 00        CMP    word ptr [0x9e], 0 ; CMP
004EF6  75 03                 JNE    0x4efb ; CJUMP
004EF8  E9 BF 01              JMP    0x50ba ; JUMP
004EFB  6A 08                 PUSH   8 ; STACK_PUSH
004EFD  9A 0A 00 59 10        LCALL  0x1059, 0xa ; LCALL
004F02  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004F05  0B C0                 OR     ax, ax ; LOGIC
004F07  74 03                 JE     0x4f0c ; CJUMP
004F09  E9 AE 01              JMP    0x50ba ; JUMP
004F0C  A3 9E 00              MOV    word ptr [0x9e], ax ; GLOBAL_LOAD
004F0F  39 06 94 00           CMP    word ptr [0x94], ax ; CMP
004F13  7C 0F                 JL     0x4f24 ; CJUMP
004F15  A1 94 00              MOV    ax, word ptr [0x94] ; GLOBAL_LOAD
004F18  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
004F1B  C7 06 94 00 FF FF     MOV    word ptr [0x94], 0xffff ; GLOBAL_LOAD
004F21  E9 8B 01              JMP    0x50af ; JUMP
004F24  FF 36 A8 83           PUSH   word ptr [0x83a8] ; PUSH_GLOBAL
004F28  9A 2C 00 EF 09        LCALL  0x9ef, 0x2c ; LCALL
004F2D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004F30  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
004F35  75 27                 JNE    0x4f5e ; CJUMP
004F37  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
004F3C  C7 46 FC 0C 00        MOV    word ptr [bp - 4], 0xc ; LOCAL_STORE
004F41  6A 08                 PUSH   8 ; STACK_PUSH
004F43  6A 00                 PUSH   0 ; STACK_PUSH
004F45  9A 32 00 EF 09        LCALL  0x9ef, 0x32 ; LCALL
004F4A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004F4D  0B C0                 OR     ax, ax ; LOGIC
004F4F  75 31                 JNE    0x4f82 ; CJUMP
004F51  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd ; LOCAL_STORE
004F56  C7 46 FC 0B 00        MOV    word ptr [bp - 4], 0xb ; LOCAL_STORE
004F5B  EB 25                 JMP    0x4f82 ; JUMP
004F5D  90                    NOP ; NOP
004F5E  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd ; LOCAL_STORE
004F63  C7 46 FC 06 00        MOV    word ptr [bp - 4], 6 ; LOCAL_STORE
004F68  6A 04                 PUSH   4 ; STACK_PUSH
004F6A  6A 00                 PUSH   0 ; STACK_PUSH
004F6C  9A 32 00 EF 09        LCALL  0x9ef, 0x32 ; LCALL
004F71  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004F74  0B C0                 OR     ax, ax ; LOGIC
004F76  75 0A                 JNE    0x4f82 ; CJUMP
004F78  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
004F7D  C7 46 FC 0C 00        MOV    word ptr [bp - 4], 0xc ; LOCAL_STORE
004F82  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
004F87  74 0A                 JE     0x4f93 ; CJUMP
004F89  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
004F8E  C7 46 FC 18 00        MOV    word ptr [bp - 4], 0x18 ; LOCAL_STORE
004F93  A1 9A 00              MOV    ax, word ptr [0x9a] ; GLOBAL_LOAD
004F96  EB 62                 JMP    0x4ffa ; JUMP
004F98  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
004F9D  C7 46 FC 07 00        MOV    word ptr [bp - 4], 7 ; LOCAL_STORE
004FA2  EB 72                 JMP    0x5016 ; JUMP
004FA4  90                    NOP ; NOP
004FA5  90                    NOP ; NOP
004FA6  C7 46 FE 08 00        MOV    word ptr [bp - 2], 8 ; LOCAL_STORE
004FAB  C7 46 FC 05 00        MOV    word ptr [bp - 4], 5 ; LOCAL_STORE
004FB0  EB 64                 JMP    0x5016 ; JUMP
004FB2  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd ; LOCAL_STORE
004FB7  C7 46 FC 06 00        MOV    word ptr [bp - 4], 6 ; LOCAL_STORE
004FBC  EB 58                 JMP    0x5016 ; JUMP
004FBE  C7 46 FE 13 00        MOV    word ptr [bp - 2], 0x13 ; LOCAL_STORE
004FC3  C7 46 FC 04 00        MOV    word ptr [bp - 4], 4 ; LOCAL_STORE
004FC8  EB 4C                 JMP    0x5016 ; JUMP
004FCA  83 3E 96 00 33        CMP    word ptr [0x96], 0x33 ; CMP
004FCF  74 45                 JE     0x5016 ; CJUMP
004FD1  C7 46 FE 17 00        MOV    word ptr [bp - 2], 0x17 ; LOCAL_STORE
004FD6  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
004FDB  EB 39                 JMP    0x5016 ; JUMP
004FDD  90                    NOP ; NOP
004FDE  83 3E 96 00 35        CMP    word ptr [0x96], 0x35 ; CMP
004FE3  74 31                 JE     0x5016 ; CJUMP
004FE5  C7 46 FE 19 00        MOV    word ptr [bp - 2], 0x19 ; LOCAL_STORE
004FEA  EB EA                 JMP    0x4fd6 ; JUMP
004FEC  83 3E 96 00 36        CMP    word ptr [0x96], 0x36 ; CMP
004FF1  74 23                 JE     0x5016 ; CJUMP
004FF3  C7 46 FE 1A 00        MOV    word ptr [bp - 2], 0x1a ; LOCAL_STORE
004FF8  EB DC                 JMP    0x4fd6 ; JUMP
004FFA  48                    DEC    ax ; ARITH
004FFB  3D 06 00              CMP    ax, 6 ; CMP
004FFE  77 16                 JA     0x5016 ; CJUMP
005000  D1 E0                 SHL    ax, 1 ; LOGIC
005002  93                    XCHG   bx, ax ; MOV
005003  2E FF A7 18 02        JMP    word ptr cs:[bx + 0x218] ; JUMP
005008  A8 01                 TEST   al, 1 ; LOGIC
00500A  B6 01                 MOV    dh, 1 ; MOV
00500C  C2 01 CE              RET    0xce01 ; RETURN
