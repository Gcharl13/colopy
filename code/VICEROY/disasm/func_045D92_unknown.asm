; ============================================================================
; func_045D92_unknown
; Region   : overlay
; Bytes    : file 0x045D92..0x045DF1  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

045D92  55                    PUSH   bp ; STACK_PUSH
045D93  8B EC                 MOV    bp, sp ; MOV
045D95  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
045D99  7D 37                 JGE    0x45dd2 ; CJUMP
045D9B  6B 5E 0A 34           IMUL   bx, word ptr [bp + 0xa], 0x34 ; ARITH
045D9F  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
045DA4  75 2C                 JNE    0x45dd2 ; CJUMP
045DA6  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
045DAA  74 26                 JE     0x45dd2 ; CJUMP
045DAC  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
045DAF  05 04 00              ADD    ax, 4 ; ARITH
045DB2  50                    PUSH   ax ; STACK_PUSH
045DB3  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
045DB8  8B E5                 MOV    sp, bp ; MOV
045DBA  50                    PUSH   ax ; STACK_PUSH
045DBB  6A 00                 PUSH   0 ; STACK_PUSH
045DBD  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
045DC2  8B E5                 MOV    sp, bp ; MOV
045DC4  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
045DC8  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
045DCB  2B D2                 SUB    dx, dx ; ARITH
045DCD  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
045DD2  6A 40                 PUSH   0x40 ; PUSH_CONST
045DD4  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
045DD7  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
045DDA  05 04 00              ADD    ax, 4 ; ARITH
045DDD  50                    PUSH   ax ; STACK_PUSH
045DDE  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
045DE3  8B E5                 MOV    sp, bp ; MOV
045DE5  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
045DE8  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045DEB  0E                    PUSH   cs ; STACK_PUSH
045DEC  E8 FF 07              CALL   0x465ee ; CALL_NEAR
045DEF  C9                    LEAVE ; EPILOGUE
045DF0  CB                    RETF ; RETURN
