; ============================================================================
; func_076AEC_unknown
; Region   : overlay
; Bytes    : file 0x076AEC..0x076B9E  (178 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

076AEC  C8 26 01 00           ENTER  0x126, 0 ; PROLOGUE
076AF0  57                    PUSH   di ; STACK_PUSH
076AF1  56                    PUSH   si ; STACK_PUSH
076AF2  BE 01 00              MOV    si, 1 ; MOV
076AF5  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
076AF8  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
076AFB  50                    PUSH   ax ; STACK_PUSH
076AFC  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
076B01  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
076B04  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
076B07  16                    PUSH   ss ; STACK_PUSH
076B08  50                    PUSH   ax ; STACK_PUSH
076B09  1E                    PUSH   ds ; STACK_PUSH
076B0A  68 FA 23              PUSH   0x23fa ; PUSH_CONST
076B0D  9A 94 0A 1F 1A        LCALL  0x1a1f, 0xa94 ; THUNK -> 0x0B32:0x000E (thunk @file 0x01D084 type B) overlay @file 0x040608
076B12  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076B16  16                    PUSH   ss ; STACK_PUSH
076B17  50                    PUSH   ax ; STACK_PUSH
076B18  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
076B1B  16                    PUSH   ss ; STACK_PUSH
076B1C  50                    PUSH   ax ; STACK_PUSH
076B1D  8D 1E FE 23           LEA    bx, [0x23fe] ; ADDR
076B21  2B C0                 SUB    ax, ax ; ARITH
076B23  9A 9E 0E 1F 1A        LCALL  0x1a1f, 0xe9e ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D48E type A) overlay @file 0x025900
076B28  0B C0                 OR     ax, ax ; LOGIC
076B2A  75 6C                 JNE    0x76b98 ; CJUMP
076B2C  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
076B2F  16                    PUSH   ss ; STACK_PUSH
076B30  50                    PUSH   ax ; STACK_PUSH
076B31  6A 00                 PUSH   0 ; STACK_PUSH
076B33  6A 01                 PUSH   1 ; STACK_PUSH
076B35  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076B39  16                    PUSH   ss ; STACK_PUSH
076B3A  50                    PUSH   ax ; STACK_PUSH
076B3B  B8 08 00              MOV    ax, 8 ; MOV
076B3E  99                    CDQ ; ARITH
076B3F  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
076B44  0B D0                 OR     dx, ax ; LOGIC
076B46  74 50                 JE     0x76b98 ; CJUMP
076B48  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
076B4B  8B 56 0E              MOV    dx, word ptr [bp + 0xe] ; LOCAL_LOAD
076B4E  8B F8                 MOV    di, ax ; MOV
076B50  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
076B53  83 7E 10 00           CMP    word ptr [bp + 0x10], 0 ; CMP
076B57  74 15                 JE     0x76b6e ; CJUMP
076B59  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
076B5C  2B 56 F4              SUB    dx, word ptr [bp - 0xc] ; ARITH
076B5F  8D 5E 08              LEA    bx, [bp + 8] ; ADDR
076B62  2B C0                 SUB    ax, ax ; ARITH
076B64  9A 90 02 1F 18        LCALL  0x181f, 0x290 ; THUNK -> 0x0A4E:0x0008 (thunk @file 0x01A880 type B) overlay @file 0x0287B2
076B69  8B F8                 MOV    di, ax ; MOV
076B6B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
076B6E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
076B71  57                    PUSH   di ; STACK_PUSH
076B72  6A 00                 PUSH   0 ; STACK_PUSH
076B74  6A 01                 PUSH   1 ; STACK_PUSH
076B76  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076B7A  16                    PUSH   ss ; STACK_PUSH
076B7B  50                    PUSH   ax ; STACK_PUSH
076B7C  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
076B7F  F7 6E F4              IMUL   word ptr [bp - 0xc] ; ARITH
076B82  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
076B87  0B D0                 OR     dx, ax ; LOGIC
076B89  74 0D                 JE     0x76b98 ; CJUMP
076B8B  8D 86 DA FE           LEA    ax, [bp - 0x126] ; ADDR
076B8F  16                    PUSH   ss ; STACK_PUSH
076B90  50                    PUSH   ax ; STACK_PUSH
076B91  9A AC 0E 1F 1A        LCALL  0x1a1f, 0xeac ; THUNK -> 0x0000:0x021C (thunk @file 0x01D49C type A) overlay @file 0x025B1C
076B96  2B F6                 SUB    si, si ; ARITH
076B98  8B C6                 MOV    ax, si ; MOV
076B9A  5E                    POP    si ; STACK_POP
076B9B  5F                    POP    di ; STACK_POP
076B9C  C9                    LEAVE ; EPILOGUE
076B9D  CB                    RETF ; RETURN
