; ============================================================================
; func_045DF2_unknown
; Region   : overlay
; Bytes    : file 0x045DF2..0x045F16  (292 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

045DF2  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
045DF6  56                    PUSH   si ; STACK_PUSH
045DF7  6A 64                 PUSH   0x64 ; PUSH_CONST
045DF9  6A 00                 PUSH   0 ; STACK_PUSH
045DFB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045DFE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
045E01  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
045E06  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045E09  50                    PUSH   ax ; STACK_PUSH
045E0A  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
045E0F  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
045E12  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
045E15  50                    PUSH   ax ; STACK_PUSH
045E16  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
045E1B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
045E1E  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
045E21  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
045E25  75 09                 JNE    0x45e30 ; CJUMP
045E27  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
045E2B  7E 03                 JLE    0x45e30 ; CJUMP
045E2D  D1 7E 0A              SAR    word ptr [bp + 0xa], 1 ; LOGIC
045E30  6A 10                 PUSH   0x10 ; PUSH_CONST
045E32  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045E35  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
045E3A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045E3D  0B C0                 OR     ax, ax ; LOGIC
045E3F  74 09                 JE     0x45e4a ; CJUMP
045E41  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
045E45  7E 03                 JLE    0x45e4a ; CJUMP
045E47  D1 7E 0A              SAR    word ptr [bp + 0xa], 1 ; LOGIC
045E4A  6A 64                 PUSH   0x64 ; PUSH_CONST
045E4C  6A 00                 PUSH   0 ; STACK_PUSH
045E4E  6B 5E 06 27           IMUL   bx, word ptr [bp + 6], 0x27 ; ARITH
045E52  03 5E 08              ADD    bx, word ptr [bp + 8] ; ARITH
045E55  D1 E3                 SHL    bx, 1 ; LOGIC
045E57  8B 87 1C 5B           MOV    ax, word ptr [bx + 0x5b1c] ; MOV
045E5B  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
045E5E  50                    PUSH   ax ; STACK_PUSH
045E5F  8B F3                 MOV    si, bx ; MOV
045E61  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
045E66  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
045E69  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
045E6C  89 84 1C 5B           MOV    word ptr [si + 0x5b1c], ax ; MOV
045E70  50                    PUSH   ax ; STACK_PUSH
045E71  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
045E76  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
045E79  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
045E7C  D1 7E FC              SAR    word ptr [bp - 4], 1 ; LOGIC
045E7F  D1 7E FA              SAR    word ptr [bp - 6], 1 ; LOGIC
045E82  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
045E86  7D 2A                 JGE    0x45eb2 ; CJUMP
045E88  6A 04                 PUSH   4 ; STACK_PUSH
045E8A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045E8D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
045E90  05 04 00              ADD    ax, 4 ; ARITH
045E93  50                    PUSH   ax ; STACK_PUSH
045E94  8B F0                 MOV    si, ax ; MOV
045E96  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
045E9B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
045E9E  83 7E 9E 4B           CMP    word ptr [bp - 0x62], 0x4b ; CMP
045EA2  7D 0E                 JGE    0x45eb2 ; CJUMP
045EA4  6A 02                 PUSH   2 ; STACK_PUSH
045EA6  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045EA9  56                    PUSH   si ; STACK_PUSH
045EAA  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
045EAF  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
045EB2  83 7E 9E 64           CMP    word ptr [bp - 0x62], 0x64 ; CMP
045EB6  7C 5E                 JL     0x45f16 ; CJUMP
045EB8  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045EBB  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
045EBE  05 04 00              ADD    ax, 4 ; ARITH
045EC1  50                    PUSH   ax ; STACK_PUSH
045EC2  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
045EC7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045ECA  A8 40                 TEST   al, 0x40 ; LOGIC
045ECC  74 48                 JE     0x45f16 ; CJUMP
045ECE  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
045ED2  7D 16                 JGE    0x45eea ; CJUMP
045ED4  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
045ED8  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
045EDD  75 0B                 JNE    0x45eea ; CJUMP
045EDF  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
045EE2  2A E4                 SUB    ah, ah ; ARITH
045EE4  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
045EE7  EB 06                 JMP    0x45eef ; JUMP
045EE9  90                    NOP ; NOP
045EEA  C7 46 9C 01 00        MOV    word ptr [bp - 0x64], 1 ; LOCAL_STORE
045EEF  6A 0A                 PUSH   0xa ; PUSH_CONST
045EF1  6A 00                 PUSH   0 ; STACK_PUSH
045EF3  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
045EF8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045EFB  8B 4E 9C              MOV    cx, word ptr [bp - 0x64] ; LOCAL_LOAD
045EFE  41                    INC    cx ; ARITH
045EFF  3B C1                 CMP    ax, cx ; CMP
045F01  7E 03                 JLE    0x45f06 ; CJUMP
045F03  E9 FA 00              JMP    0x46000 ; JUMP
045F06  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045F09  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
045F0C  0E                    PUSH   cs ; STACK_PUSH
045F0D  E8 DE 06              CALL   0x465ee ; CALL_NEAR
045F10  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045F13  5E                    POP    si ; STACK_POP
045F14  C9                    LEAVE ; EPILOGUE
045F15  CB                    RETF ; RETURN
