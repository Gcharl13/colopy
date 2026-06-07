; ============================================================================
; func_024A48_unknown
; Region   : overlay
; Bytes    : file 0x024A48..0x024AFF  (183 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024A48  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
024A4C  B8 01 00              MOV    ax, 1 ; MOV
024A4F  A3 C4 53              MOV    word ptr [0x53c4], ax ; GLOBAL_LOAD
024A52  50                    PUSH   ax ; STACK_PUSH
024A53  9A 1C 0E 1F 18        LCALL  0x181f, 0xe1c ; THUNK -> 0x0000:0x00C0 (thunk @file 0x01B40C type A) overlay @file 0x0259C0
024A58  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
024A5B  C7 06 92 53 FF FF     MOV    word ptr [0x5392], 0xffff ; GLOBAL_LOAD
024A61  2B C0                 SUB    ax, ax ; ARITH
024A63  A3 B0 97              MOV    word ptr [0x97b0], ax ; GLOBAL_LOAD
024A66  50                    PUSH   ax ; STACK_PUSH
024A67  0E                    PUSH   cs ; STACK_PUSH
024A68  E8 E5 00              CALL   0x24b50 ; CALL_NEAR
024A6B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
024A6E  9A A2 04 1F 19        LCALL  0x191f, 0x4a2 ; THUNK -> 0x0AE7:0x002C (thunk @file 0x01BA92 type B) overlay @file 0x02701C
024A73  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
024A78  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
024A7D  75 51                 JNE    0x24ad0 ; CJUMP
024A7F  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
024A82  9A F4 07 1F 18        LCALL  0x181f, 0x7f4 ; THUNK -> 0x0427:0x1410 (thunk @file 0x01ADE4 type B) overlay @file 0x032124
024A87  0B C0                 OR     ax, ax ; LOGIC
024A89  75 45                 JNE    0x24ad0 ; CJUMP
024A8B  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
024A90  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
024A93  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
024A96  6A 00                 PUSH   0 ; STACK_PUSH
024A98  0E                    PUSH   cs ; STACK_PUSH
024A99  E8 B4 00              CALL   0x24b50 ; CALL_NEAR
024A9C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
024A9F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
024AA2  0B C0                 OR     ax, ax ; LOGIC
024AA4  75 2A                 JNE    0x24ad0 ; CJUMP
024AA6  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
024AAB  8B 4E FA              MOV    cx, word ptr [bp - 6] ; LOCAL_LOAD
024AAE  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
024AB1  83 C1 1E              ADD    cx, 0x1e ; ARITH
024AB4  83 D3 00              ADC    bx, 0 ; ARITH
024AB7  3B D3                 CMP    dx, bx ; CMP
024AB9  7F 06                 JG     0x24ac1 ; CJUMP
024ABB  7C E9                 JL     0x24aa6 ; CJUMP
024ABD  3B C1                 CMP    ax, cx ; CMP
024ABF  72 E5                 JB     0x24aa6 ; CJUMP
024AC1  9A A2 04 1F 19        LCALL  0x191f, 0x4a2 ; THUNK -> 0x0AE7:0x002C (thunk @file 0x01BA92 type B) overlay @file 0x02701C
024AC6  F6 06 82 53 80        TEST   byte ptr [0x5382], 0x80 ; LOGIC
024ACB  74 03                 JE     0x24ad0 ; CJUMP
024ACD  E8 80 C4              CALL   0x20f50 ; CALL_NEAR
024AD0  83 3E C4 53 00        CMP    word ptr [0x53c4], 0 ; CMP
024AD5  74 23                 JE     0x24afa ; CJUMP
024AD7  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
024ADB  75 0C                 JNE    0x24ae9 ; CJUMP
024ADD  6A 00                 PUSH   0 ; STACK_PUSH
024ADF  6A 01                 PUSH   1 ; STACK_PUSH
024AE1  9A 5E 05 1F 18        LCALL  0x181f, 0x55e ; THUNK -> 0x0000:0x0424 (thunk @file 0x01AB4E type A) overlay @file 0x025D24
024AE6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
024AE9  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
024AEE  75 06                 JNE    0x24af6 ; CJUMP
024AF0  0E                    PUSH   cs ; STACK_PUSH
024AF1  E8 8E 00              CALL   0x24b82 ; CALL_NEAR
024AF4  EB 04                 JMP    0x24afa ; JUMP
024AF6  0E                    PUSH   cs ; STACK_PUSH
024AF7  E8 E2 00              CALL   0x24bdc ; CALL_NEAR
024AFA  83 3E C2 53 00        CMP    word ptr [0x53c2], 0 ; CMP
