; ============================================================================
; func_035B06_unknown
; Region   : overlay
; Bytes    : file 0x035B06..0x035B7C  (118 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035B06  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
035B0A  56                    PUSH   si ; STACK_PUSH
035B0B  9A 5E 09 1F 19        LCALL  0x191f, 0x95e ; THUNK -> 0x0000:0x01F6 (thunk @file 0x01BF4E type A) overlay @file 0x025AF6
035B10  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
035B13  0E                    PUSH   cs ; STACK_PUSH
035B14  E8 F7 0C              CALL   0x3680e ; CALL_NEAR
035B17  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
035B1A  6A 00                 PUSH   0 ; STACK_PUSH
035B1C  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
035B21  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
035B24  6A 07                 PUSH   7 ; STACK_PUSH
035B26  68 40 01              PUSH   0x140 ; PUSH_CONST
035B29  6A 00                 PUSH   0 ; STACK_PUSH
035B2B  6A 00                 PUSH   0 ; STACK_PUSH
035B2D  9A A6 00 1F 18        LCALL  0x181f, 0xa6 ; THUNK -> 0x0009:0x02AE (thunk @file 0x01A696 type B) overlay @file 0x022A78
035B32  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
035B35  C7 06 92 08 01 00     MOV    word ptr [0x892], 1 ; GLOBAL_LOAD
035B3B  0E                    PUSH   cs ; STACK_PUSH
035B3C  E8 9C 0D              CALL   0x368db ; CALL_NEAR
035B3F  0E                    PUSH   cs ; STACK_PUSH
035B40  E8 DE 0D              CALL   0x36921 ; CALL_NEAR
035B43  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
035B48  05 14 00              ADD    ax, 0x14 ; ARITH
035B4B  83 D2 00              ADC    dx, 0 ; ARITH
035B4E  A3 30 9E              MOV    word ptr [0x9e30], ax ; GLOBAL_LOAD
035B51  89 16 32 9E           MOV    word ptr [0x9e32], dx ; GLOBAL_LOAD
035B55  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
035B5A  C7 06 38 9E 01 00     MOV    word ptr [0x9e38], 1 ; GLOBAL_LOAD
035B60  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
035B64  7C 76                 JL     0x35bdc ; CJUMP
035B66  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
035B69  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
035B6C  6A 00                 PUSH   0 ; STACK_PUSH
035B6E  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
035B73  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
035B76  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
035B7A  8B C3                 MOV    ax, bx ; MOV
