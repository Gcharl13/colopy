; ============================================================================
; func_057AA2_unknown
; Region   : overlay
; Bytes    : file 0x057AA2..0x057AFB  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "MEEKNESS"  (auto-named via string xrefs)
; ============================================================================

057AA2  C8 56 00 00           ENTER  0x56, 0 ; PROLOGUE
057AA6  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
057AA9  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
057AAC  68 84 18              PUSH   0x1884                       ; STRING: "MEEKNESS"
057AAF  68 7C 08              PUSH   0x87c ; PUSH_CONST
057AB2  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
057AB7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057ABA  0B C0                 OR     ax, ax ; LOGIC
057ABC  75 27                 JNE    0x57ae5 ; CJUMP
057ABE  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
057AC2  1B C0                 SBB    ax, ax ; ARITH
057AC4  25 01 00              AND    ax, 1 ; LOGIC
057AC7  40                    INC    ax ; ARITH
057AC8  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
057ACB  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0 ; LOCAL_STORE
057AD0  EB 0B                 JMP    0x57add ; JUMP
057AD2  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
057AD7  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
057ADA  FF 46 AC              INC    word ptr [bp - 0x54] ; ARITH
057ADD  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
057AE0  39 46 AE              CMP    word ptr [bp - 0x52], ax ; CMP
057AE3  7F ED                 JG     0x57ad2 ; CJUMP
057AE5  1E                    PUSH   ds ; STACK_PUSH
057AE6  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
057AE9  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057AEC  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
057AF1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
057AF4  9A B8 0F 1F 19        LCALL  0x191f, 0xfb8 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5A8 type A) overlay @file 0x025900
057AF9  C9                    LEAVE ; EPILOGUE
057AFA  CB                    RETF ; RETURN
