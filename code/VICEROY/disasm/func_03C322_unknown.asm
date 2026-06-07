; ============================================================================
; func_03C322_unknown
; Region   : overlay
; Bytes    : file 0x03C322..0x03C3F1  (207 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "AMBUSHHINT", "CONSIDER"  (auto-named via string xrefs)
; ============================================================================

03C322  55                    PUSH   bp ; STACK_PUSH
03C323  8B EC                 MOV    bp, sp ; MOV
03C325  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C328  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
03C32D  8B E5                 MOV    sp, bp ; MOV
03C32F  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
03C332  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03C336  01 47 0C              ADD    word ptr [bx + 0xc], ax ; ARITH
03C339  01 47 0E              ADD    word ptr [bx + 0xe], ax ; ARITH
03C33C  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03C341  75 0F                 JNE    0x3c352 ; CJUMP
03C343  83 7F 12 00           CMP    word ptr [bx + 0x12], 0 ; CMP
03C347  7D 09                 JGE    0x3c352 ; CJUMP
03C349  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C34C  0E                    PUSH   cs ; STACK_PUSH
03C34D  E8 B1 00              CALL   0x3c401 ; CALL_NEAR
03C350  8B E5                 MOV    sp, bp ; MOV
03C352  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03C357  74 54                 JE     0x3c3ad ; CJUMP
03C359  F6 06 82 53 06        TEST   byte ptr [0x5382], 6 ; LOGIC
03C35E  75 4D                 JNE    0x3c3ad ; CJUMP
03C360  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
03C363  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03C367  39 47 0C              CMP    word ptr [bx + 0xc], ax ; CMP
03C36A  7E 41                 JLE    0x3c3ad ; CJUMP
03C36C  FF 36 D4 53           PUSH   word ptr [0x53d4] ; PUSH_GLOBAL
03C370  6A 01                 PUSH   1 ; STACK_PUSH
03C372  6A 00                 PUSH   0 ; STACK_PUSH
03C374  9A C8 0A 1F 19        LCALL  0x191f, 0xac8 ; THUNK -> 0x0000:0x0404 (thunk @file 0x01C0B8 type A) overlay @file 0x025D04
03C379  8B E5                 MOV    sp, bp ; MOV
03C37B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C37E  0E                    PUSH   cs ; STACK_PUSH
03C37F  E8 70 00              CALL   0x3c3f2 ; CALL_NEAR
03C382  8B E5                 MOV    sp, bp ; MOV
03C384  99                    CDQ ; ARITH
03C385  52                    PUSH   dx ; STACK_PUSH
03C386  50                    PUSH   ax ; STACK_PUSH
03C387  6A 00                 PUSH   0 ; STACK_PUSH
03C389  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
03C38E  8B E5                 MOV    sp, bp ; MOV
03C390  6A 01                 PUSH   1 ; STACK_PUSH
03C392  68 6F 12              PUSH   0x126f                       ; STRING: "AMBUSHHINT"
03C395  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
03C39A  8B E5                 MOV    sp, bp ; MOV
03C39C  6A 01                 PUSH   1 ; STACK_PUSH
03C39E  68 7A 12              PUSH   0x127a                       ; STRING: "CONSIDER"
03C3A1  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
03C3A6  8B E5                 MOV    sp, bp ; MOV
03C3A8  80 0E 82 53 04        OR     byte ptr [0x5382], 4 ; LOGIC
03C3AD  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C3B0  0E                    PUSH   cs ; STACK_PUSH
03C3B1  E8 3E 00              CALL   0x3c3f2 ; CALL_NEAR
03C3B4  8B E5                 MOV    sp, bp ; MOV
03C3B6  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03C3BA  3B 47 0C              CMP    ax, word ptr [bx + 0xc] ; CMP
03C3BD  7F 30                 JG     0x3c3ef ; CJUMP
03C3BF  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03C3C4  74 0E                 JE     0x3c3d4 ; CJUMP
03C3C6  F6 06 82 53 02        TEST   byte ptr [0x5382], 2 ; LOGIC
03C3CB  75 22                 JNE    0x3c3ef ; CJUMP
03C3CD  9A 48 03 1F 19        LCALL  0x191f, 0x348 ; THUNK -> 0x0000:0x1528 (thunk @file 0x01B938 type A) overlay @file 0x026E28
03C3D2  EB 12                 JMP    0x3c3e6 ; JUMP
03C3D4  83 7F 12 00           CMP    word ptr [bx + 0x12], 0 ; CMP
03C3D8  7C 0C                 JL     0x3c3e6 ; CJUMP
03C3DA  6A 00                 PUSH   0 ; STACK_PUSH
03C3DC  FF 77 12              PUSH   word ptr [bx + 0x12] ; PUSH_GLOBAL
03C3DF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C3E2  0E                    PUSH   cs ; STACK_PUSH
03C3E3  E8 16 00              CALL   0x3c3fc ; CALL_NEAR
03C3E6  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03C3EA  C7 47 0C 00 00        MOV    word ptr [bx + 0xc], 0 ; MOV
03C3EF  C9                    LEAVE ; EPILOGUE
03C3F0  CB                    RETF ; RETURN
