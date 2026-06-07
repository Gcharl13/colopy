; ============================================================================
; func_045AE4_unknown
; Region   : overlay
; Bytes    : file 0x045AE4..0x045BE7  (259 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

045AE4  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
045AE8  57                    PUSH   di ; STACK_PUSH
045AE9  56                    PUSH   si ; STACK_PUSH
045AEA  B8 01 00              MOV    ax, 1 ; MOV
045AED  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
045AF0  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
045AF3  8D 46 FF              LEA    ax, [bp - 1] ; ADDR
045AF6  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
045AF9  8C 56 F8              MOV    word ptr [bp - 8], ss ; LOCAL_STORE
045AFC  8D 1E BC 14           LEA    bx, [0x14bc] ; ADDR
045B00  2B C0                 SUB    ax, ax ; ARITH
045B02  9A 72 03 1F 1A        LCALL  0x1a1f, 0x372 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01C962 type A) overlay @file 0x025902
045B07  8B F0                 MOV    si, ax ; MOV
045B09  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
045B0C  0B D0                 OR     dx, ax ; LOGIC
045B0E  75 03                 JNE    0x45b13 ; CJUMP
045B10  E9 D0 00              JMP    0x45be3 ; JUMP
045B13  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
045B16  50                    PUSH   ax ; STACK_PUSH
045B17  56                    PUSH   si ; STACK_PUSH
045B18  6A 00                 PUSH   0 ; STACK_PUSH
045B1A  8B F8                 MOV    di, ax ; MOV
045B1C  B8 01 00              MOV    ax, 1 ; MOV
045B1F  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
045B22  2B D2                 SUB    dx, dx ; ARITH
045B24  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
045B29  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
045B2C  2A E4                 SUB    ah, ah ; ARITH
045B2E  A3 9C 14              MOV    word ptr [0x149c], ax ; GLOBAL_LOAD
045B31  A3 A0 14              MOV    word ptr [0x14a0], ax ; GLOBAL_LOAD
045B34  57                    PUSH   di ; STACK_PUSH
045B35  56                    PUSH   si ; STACK_PUSH
045B36  6A 00                 PUSH   0 ; STACK_PUSH
045B38  B8 02 00              MOV    ax, 2 ; MOV
045B3B  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
045B3E  2B D2                 SUB    dx, dx ; ARITH
045B40  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
045B45  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
045B48  2A E4                 SUB    ah, ah ; ARITH
045B4A  A3 9E 14              MOV    word ptr [0x149e], ax ; GLOBAL_LOAD
045B4D  A3 A2 14              MOV    word ptr [0x14a2], ax ; GLOBAL_LOAD
045B50  57                    PUSH   di ; STACK_PUSH
045B51  56                    PUSH   si ; STACK_PUSH
045B52  6A 00                 PUSH   0 ; STACK_PUSH
045B54  B8 03 00              MOV    ax, 3 ; MOV
045B57  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
045B5A  2B D2                 SUB    dx, dx ; ARITH
045B5C  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
045B61  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
045B64  2A E4                 SUB    ah, ah ; ARITH
045B66  A3 A8 14              MOV    word ptr [0x14a8], ax ; GLOBAL_LOAD
045B69  A3 A4 14              MOV    word ptr [0x14a4], ax ; GLOBAL_LOAD
045B6C  57                    PUSH   di ; STACK_PUSH
045B6D  56                    PUSH   si ; STACK_PUSH
045B6E  6A 00                 PUSH   0 ; STACK_PUSH
045B70  B8 04 00              MOV    ax, 4 ; MOV
045B73  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
045B76  2B D2                 SUB    dx, dx ; ARITH
045B78  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
045B7D  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
045B80  2A E4                 SUB    ah, ah ; ARITH
045B82  A3 AA 14              MOV    word ptr [0x14aa], ax ; GLOBAL_LOAD
045B85  A3 A6 14              MOV    word ptr [0x14a6], ax ; GLOBAL_LOAD
045B88  57                    PUSH   di ; STACK_PUSH
045B89  56                    PUSH   si ; STACK_PUSH
045B8A  6A 00                 PUSH   0 ; STACK_PUSH
045B8C  B8 05 00              MOV    ax, 5 ; MOV
045B8F  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
045B92  2B D2                 SUB    dx, dx ; ARITH
045B94  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
045B99  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
045B9C  2A E4                 SUB    ah, ah ; ARITH
045B9E  A3 B4 14              MOV    word ptr [0x14b4], ax ; GLOBAL_LOAD
045BA1  A3 AE 14              MOV    word ptr [0x14ae], ax ; GLOBAL_LOAD
045BA4  57                    PUSH   di ; STACK_PUSH
045BA5  56                    PUSH   si ; STACK_PUSH
045BA6  6A 00                 PUSH   0 ; STACK_PUSH
045BA8  B8 06 00              MOV    ax, 6 ; MOV
045BAB  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
045BAE  2B D2                 SUB    dx, dx ; ARITH
045BB0  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
045BB5  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
045BB8  2A E4                 SUB    ah, ah ; ARITH
045BBA  A3 B8 14              MOV    word ptr [0x14b8], ax ; GLOBAL_LOAD
045BBD  A3 B2 14              MOV    word ptr [0x14b2], ax ; GLOBAL_LOAD
045BC0  57                    PUSH   di ; STACK_PUSH
045BC1  56                    PUSH   si ; STACK_PUSH
045BC2  6A 00                 PUSH   0 ; STACK_PUSH
045BC4  B8 07 00              MOV    ax, 7 ; MOV
045BC7  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
045BCA  2B D2                 SUB    dx, dx ; ARITH
045BCC  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
045BD1  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
045BD4  2A E4                 SUB    ah, ah ; ARITH
045BD6  A3 B4 14              MOV    word ptr [0x14b4], ax ; GLOBAL_LOAD
045BD9  A3 B0 14              MOV    word ptr [0x14b0], ax ; GLOBAL_LOAD
045BDC  57                    PUSH   di ; STACK_PUSH
045BDD  56                    PUSH   si ; STACK_PUSH
045BDE  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
045BE3  5E                    POP    si ; STACK_POP
045BE4  5F                    POP    di ; STACK_POP
045BE5  C9                    LEAVE ; EPILOGUE
045BE6  CB                    RETF ; RETURN
