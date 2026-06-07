; ============================================================================
; func_070DE8_unknown
; Region   : overlay
; Bytes    : file 0x070DE8..0x070EB9  (209 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CONFIG.COL"  (auto-named via string xrefs)
; ============================================================================

070DE8  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
070DEC  68 56 20              PUSH   0x2056 ; PUSH_CONST
070DEF  68 59 20              PUSH   0x2059                       ; STRING: "CONFIG.COL"
070DF2  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
070DF7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070DFA  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
070DFD  0B C0                 OR     ax, ax ; LOGIC
070DFF  75 03                 JNE    0x70e04 ; CJUMP
070E01  E9 97 00              JMP    0x70e9b ; JUMP
070E04  50                    PUSH   ax ; STACK_PUSH
070E05  6A 01                 PUSH   1 ; STACK_PUSH
070E07  6A 02                 PUSH   2 ; STACK_PUSH
070E09  68 0A 26              PUSH   0x260a ; PUSH_CONST
070E0C  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
070E11  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070E14  0B C0                 OR     ax, ax ; LOGIC
070E16  75 03                 JNE    0x70e1b ; CJUMP
070E18  E9 80 00              JMP    0x70e9b ; JUMP
070E1B  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070E1E  6A 01                 PUSH   1 ; STACK_PUSH
070E20  6A 02                 PUSH   2 ; STACK_PUSH
070E22  68 0C 26              PUSH   0x260c ; PUSH_CONST
070E25  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
070E2A  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070E2D  0B C0                 OR     ax, ax ; LOGIC
070E2F  74 6A                 JE     0x70e9b ; CJUMP
070E31  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070E34  6A 01                 PUSH   1 ; STACK_PUSH
070E36  6A 02                 PUSH   2 ; STACK_PUSH
070E38  68 0E 26              PUSH   0x260e ; PUSH_CONST
070E3B  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
070E40  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070E43  0B C0                 OR     ax, ax ; LOGIC
070E45  74 54                 JE     0x70e9b ; CJUMP
070E47  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070E4A  6A 01                 PUSH   1 ; STACK_PUSH
070E4C  6A 02                 PUSH   2 ; STACK_PUSH
070E4E  68 10 26              PUSH   0x2610 ; PUSH_CONST
070E51  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
070E56  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070E59  0B C0                 OR     ax, ax ; LOGIC
070E5B  74 3E                 JE     0x70e9b ; CJUMP
070E5D  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070E60  6A 01                 PUSH   1 ; STACK_PUSH
070E62  6A 02                 PUSH   2 ; STACK_PUSH
070E64  68 12 26              PUSH   0x2612 ; PUSH_CONST
070E67  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
070E6C  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070E6F  0B C0                 OR     ax, ax ; LOGIC
070E71  74 28                 JE     0x70e9b ; CJUMP
070E73  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070E76  6A 01                 PUSH   1 ; STACK_PUSH
070E78  6A 02                 PUSH   2 ; STACK_PUSH
070E7A  68 14 26              PUSH   0x2614 ; PUSH_CONST
070E7D  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
070E82  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070E85  0B C0                 OR     ax, ax ; LOGIC
070E87  74 12                 JE     0x70e9b ; CJUMP
070E89  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070E8C  6A 01                 PUSH   1 ; STACK_PUSH
070E8E  6A 02                 PUSH   2 ; STACK_PUSH
070E90  68 16 26              PUSH   0x2616 ; PUSH_CONST
070E93  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
070E98  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070E9B  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
070E9F  74 0B                 JE     0x70eac ; CJUMP
070EA1  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070EA4  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
070EA9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070EAC  A1 0C 26              MOV    ax, word ptr [0x260c] ; GLOBAL_LOAD
070EAF  9A 50 0C 1F 1A        LCALL  0x1a1f, 0xc50 ; THUNK -> 0x105F:0x000C (thunk @file 0x01D240 type B)
070EB4  A2 08 26              MOV    byte ptr [0x2608], al ; GLOBAL_LOAD
070EB7  C9                    LEAVE ; EPILOGUE
070EB8  CB                    RETF ; RETURN
