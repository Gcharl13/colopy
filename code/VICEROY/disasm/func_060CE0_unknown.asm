; ============================================================================
; func_060CE0_unknown
; Region   : overlay
; Bytes    : file 0x060CE0..0x060D8B  (171 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060CE0  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
060CE4  68 00 08              PUSH   0x800 ; PUSH_CONST
060CE7  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
060CEB  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
060CEF  9A C4 07 1F 1A        LCALL  0x1a1f, 0x7c4 ; THUNK -> 0x0000:0x3084 (thunk @file 0x01CDB4 type A) overlay @file 0x028984
060CF4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
060CF7  2B D2                 SUB    dx, dx ; ARITH
060CF9  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
060CFC  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
060D00  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
060D03  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
060D08  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
060D0B  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
060D0E  0B D0                 OR     dx, ax ; LOGIC
060D10  74 50                 JE     0x60d62 ; CJUMP
060D12  C4 5E FA              LES    bx, ptr [bp - 6] ; MOV_FAR
060D15  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1 ; LOGIC
060D1A  26 C7 47 22 0A 00     MOV    word ptr es:[bx + 0x22], 0xa ; CONST_LOAD
060D20  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
060D25  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
060D28  40                    INC    ax ; ARITH
060D29  50                    PUSH   ax ; STACK_PUSH
060D2A  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
060D2D  D1 E3                 SHL    bx, 1 ; LOGIC
060D2F  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
060D33  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
060D38  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060D3B  52                    PUSH   dx ; STACK_PUSH
060D3C  50                    PUSH   ax ; STACK_PUSH
060D3D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
060D40  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
060D43  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
060D48  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
060D4B  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
060D4E  83 7E F8 10           CMP    word ptr [bp - 8], 0x10 ; CMP
060D52  7C D1                 JL     0x60d25 ; CJUMP
060D54  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
060D57  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
060D5A  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
060D5F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
060D62  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
060D65  0B 46 FA              OR     ax, word ptr [bp - 6] ; LOGIC
060D68  74 0B                 JE     0x60d75 ; CJUMP
060D6A  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
060D6D  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
060D70  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
060D75  68 00 08              PUSH   0x800 ; PUSH_CONST
060D78  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
060D7C  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
060D80  9A C4 07 1F 1A        LCALL  0x1a1f, 0x7c4 ; THUNK -> 0x0000:0x3084 (thunk @file 0x01CDB4 type A) overlay @file 0x028984
060D85  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
060D88  48                    DEC    ax ; ARITH
060D89  C9                    LEAVE ; EPILOGUE
060D8A  CB                    RETF ; RETURN
