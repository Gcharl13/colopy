; ============================================================================
; func_021D32_unknown
; Region   : overlay
; Bytes    : file 0x021D32..0x021E72  (320 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021D32  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
021D36  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
021D3B  83 3E 90 53 01        CMP    word ptr [0x5390], 1 ; CMP
021D40  1B C0                 SBB    ax, ax ; ARITH
021D42  40                    INC    ax ; ARITH
021D43  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
021D46  83 3E 92 53 00        CMP    word ptr [0x5392], 0 ; CMP
021D4B  7C 33                 JL     0x21d80 ; CJUMP
021D4D  C7 06 A2 1E 00 00     MOV    word ptr [0x1ea2], 0 ; GLOBAL_LOAD
021D53  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
021D56  9A A0 07 1F 18        LCALL  0x181f, 0x7a0 ; THUNK -> 0x03F1:0x02F8 (thunk @file 0x01AD90 type B) overlay @file 0x022586
021D5B  6A 01                 PUSH   1 ; STACK_PUSH
021D5D  6A 01                 PUSH   1 ; STACK_PUSH
021D5F  6A 01                 PUSH   1 ; STACK_PUSH
021D61  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
021D66  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
021D6A  2A E4                 SUB    ah, ah ; ARITH
021D6C  50                    PUSH   ax ; STACK_PUSH
021D6D  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
021D71  50                    PUSH   ax ; STACK_PUSH
021D72  9A BA 09 1F 18        LCALL  0x181f, 0x9ba ; THUNK -> 0x0000:0x0004 (thunk @file 0x01AFAA type A) overlay @file 0x025904
021D77  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
021D7A  C7 06 A2 1E 01 00     MOV    word ptr [0x1ea2], 1 ; GLOBAL_LOAD
021D80  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
021D83  9A F4 07 1F 18        LCALL  0x181f, 0x7f4 ; THUNK -> 0x0427:0x1410 (thunk @file 0x01ADE4 type B) overlay @file 0x032124
021D88  0B C0                 OR     ax, ax ; LOGIC
021D8A  74 06                 JE     0x21d92 ; CJUMP
021D8C  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
021D90  74 3C                 JE     0x21dce ; CJUMP
021D92  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
021D95  9A 30 08 1F 18        LCALL  0x181f, 0x830 ; THUNK -> 0x0427:0x14A0 (thunk @file 0x01AE20 type B) overlay @file 0x0321B4
021D9A  50                    PUSH   ax ; STACK_PUSH
021D9B  9A 6C 08 1F 18        LCALL  0x181f, 0x86c ; THUNK -> 0x0427:0x08EA (thunk @file 0x01AE5C type B) overlay @file 0x0315FE
021DA0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
021DA3  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
021DA8  8A 87 4C 31           MOV    al, byte ptr [bx + 0x314c] ; MOV
021DAC  2A E4                 SUB    ah, ah ; ARITH
021DAE  2D 05 00              SUB    ax, 5 ; ARITH
021DB1  7C 0A                 JL     0x21dbd ; CJUMP
021DB3  48                    DEC    ax ; ARITH
021DB4  7E 0E                 JLE    0x21dc4 ; CJUMP
021DB6  48                    DEC    ax ; ARITH
021DB7  48                    DEC    ax ; ARITH
021DB8  7C 03                 JL     0x21dbd ; CJUMP
021DBA  48                    DEC    ax ; ARITH
021DBB  7E 07                 JLE    0x21dc4 ; CJUMP
021DBD  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
021DC2  EB 0A                 JMP    0x21dce ; JUMP
021DC4  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
021DC9  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
021DCE  83 3E 92 53 00        CMP    word ptr [0x5392], 0 ; CMP
021DD3  7C 69                 JL     0x21e3e ; CJUMP
021DD5  2B C0                 SUB    ax, ax ; ARITH
021DD7  A3 90 53              MOV    word ptr [0x5390], ax ; GLOBAL_LOAD
021DDA  A3 C6 53              MOV    word ptr [0x53c6], ax ; GLOBAL_LOAD
021DDD  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
021DE0  75 56                 JNE    0x21e38 ; CJUMP
021DE2  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
021DE7  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
021DEB  2A E4                 SUB    ah, ah ; ARITH
021DED  50                    PUSH   ax ; STACK_PUSH
021DEE  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
021DF2  50                    PUSH   ax ; STACK_PUSH
021DF3  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
021DF8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021DFB  0B C0                 OR     ax, ax ; LOGIC
021DFD  74 39                 JE     0x21e38 ; CJUMP
021DFF  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
021E04  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
021E08  2A E4                 SUB    ah, ah ; ARITH
021E0A  50                    PUSH   ax ; STACK_PUSH
021E0B  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
021E0F  50                    PUSH   ax ; STACK_PUSH
021E10  9A B8 0D 1F 18        LCALL  0x181f, 0xdb8 ; THUNK -> 0x0984:0x00E8 (thunk @file 0x01B3A8 type B) overlay @file 0x031FFE
021E15  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021E18  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
021E1C  74 1A                 JE     0x21e38 ; CJUMP
021E1E  6A 00                 PUSH   0 ; STACK_PUSH
021E20  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
021E24  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
021E28  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
021E2C  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
021E30  9A 52 03 1F 18        LCALL  0x181f, 0x352 ; THUNK -> 0x0984:0x02FC (thunk @file 0x01A942 type B) overlay @file 0x032212
021E35  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
021E38  0E                    PUSH   cs ; STACK_PUSH
021E39  E8 9B 2D              CALL   0x24bd7 ; CALL_NEAR
021E3C  EB 1E                 JMP    0x21e5c ; JUMP
021E3E  C7 06 C6 53 01 00     MOV    word ptr [0x53c6], 1 ; GLOBAL_LOAD
021E44  0E                    PUSH   cs ; STACK_PUSH
021E45  E8 5D 2D              CALL   0x24ba5 ; CALL_NEAR
021E48  83 3E B0 97 00        CMP    word ptr [0x97b0], 0 ; CMP
021E4D  74 0D                 JE     0x21e5c ; CJUMP
021E4F  F6 06 83 53 08        TEST   byte ptr [0x5383], 8 ; LOGIC
021E54  75 06                 JNE    0x21e5c ; CJUMP
021E56  C7 06 C4 53 00 00     MOV    word ptr [0x53c4], 0 ; GLOBAL_LOAD
021E5C  83 3E 92 53 00        CMP    word ptr [0x5392], 0 ; CMP
021E61  7C 0A                 JL     0x21e6d ; CJUMP
021E63  F6 06 82 53 80        TEST   byte ptr [0x5382], 0x80 ; LOGIC
021E68  74 03                 JE     0x21e6d ; CJUMP
021E6A  E8 E3 F0              CALL   0x20f50 ; CALL_NEAR
021E6D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
021E70  C9                    LEAVE ; EPILOGUE
021E71  CB                    RETF ; RETURN
