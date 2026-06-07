; ============================================================================
; func_056B92_unknown
; Region   : overlay
; Bytes    : file 0x056B92..0x056C3D  (171 bytes)
; Purpose  : Indian peace overture  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "INDIANPEACE", "INDIANCOME"  (auto-named via string xrefs)
; ============================================================================

056B92  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
056B96  56                    PUSH   si ; STACK_PUSH
056B97  6A 40                 PUSH   0x40 ; PUSH_CONST
056B99  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
056B9C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
056B9F  9A 06 0A 1F 18        LCALL  0x181f, 0xa06 ; THUNK -> 0x05B3:0x0066 (thunk @file 0x01AFF6 type B) overlay @file 0x05FC92
056BA4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
056BA7  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
056BAA  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
056BAE  7C 03                 JL     0x56bb3 ; CJUMP
056BB0  E9 84 00              JMP    0x56c37 ; JUMP
056BB3  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
056BB7  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
056BBC  75 79                 JNE    0x56c37 ; CJUMP
056BBE  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
056BC1  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
056BC6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
056BC9  50                    PUSH   ax ; STACK_PUSH
056BCA  6A 00                 PUSH   0 ; STACK_PUSH
056BCC  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
056BD1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056BD4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
056BD7  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
056BDC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
056BDF  50                    PUSH   ax ; STACK_PUSH
056BE0  6A 01                 PUSH   1 ; STACK_PUSH
056BE2  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
056BE7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056BEA  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
056BED  2D 04 00              SUB    ax, 4 ; ARITH
056BF0  50                    PUSH   ax ; STACK_PUSH
056BF1  68 EC 17              PUSH   0x17ec                       ; STRING: "INDIANPEACE"
056BF4  8B F0                 MOV    si, ax ; MOV
056BF6  9A 9C 01 1F 19        LCALL  0x191f, 0x19c ; THUNK -> 0x0000:0x3760 (thunk @file 0x01B78C type A) overlay @file 0x029060
056BFB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056BFE  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
056C01  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
056C04  2D 04 00              SUB    ax, 4 ; ARITH
056C07  50                    PUSH   ax ; STACK_PUSH
056C08  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
056C0D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056C10  3D 19 00              CMP    ax, 0x19 ; CMP
056C13  7D 22                 JGE    0x56c37 ; CJUMP
056C15  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
056C18  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
056C1D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
056C20  50                    PUSH   ax ; STACK_PUSH
056C21  6A 00                 PUSH   0 ; STACK_PUSH
056C23  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
056C28  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056C2B  56                    PUSH   si ; STACK_PUSH
056C2C  68 F8 17              PUSH   0x17f8                       ; STRING: "INDIANCOME"
056C2F  9A 9C 01 1F 19        LCALL  0x191f, 0x19c ; THUNK -> 0x0000:0x3760 (thunk @file 0x01B78C type A) overlay @file 0x029060
056C34  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056C37  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
056C3A  5E                    POP    si ; STACK_POP
056C3B  C9                    LEAVE ; EPILOGUE
056C3C  CB                    RETF ; RETURN
