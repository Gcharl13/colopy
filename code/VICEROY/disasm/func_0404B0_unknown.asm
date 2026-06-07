; ============================================================================
; func_0404B0_unknown
; Region   : overlay
; Bytes    : file 0x0404B0..0x040579  (201 bytes)
; Purpose  : Colony naming prompt  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "ENGLISH", "FRENCH", "SPANISH"  (auto-named via string xrefs)
; ============================================================================

0404B0  C8 66 00 00           ENTER  0x66, 0 ; PROLOGUE
0404B4  68 34 14              PUSH   0x1434 ; PUSH_CONST
0404B7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0404BA  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0404BF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0404C2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0404C5  0B C0                 OR     ax, ax ; LOGIC
0404C7  74 0B                 JE     0x404d4 ; CJUMP
0404C9  48                    DEC    ax ; ARITH
0404CA  74 2E                 JE     0x404fa ; CJUMP
0404CC  48                    DEC    ax ; ARITH
0404CD  74 31                 JE     0x40500 ; CJUMP
0404CF  48                    DEC    ax ; ARITH
0404D0  74 34                 JE     0x40506 ; CJUMP
0404D2  EB 0F                 JMP    0x404e3 ; JUMP
0404D4  68 36 14              PUSH   0x1436                       ; STRING: "ENGLISH"
0404D7  8D 46 9C              LEA    ax, [bp - 0x64] ; ADDR
0404DA  50                    PUSH   ax ; STACK_PUSH
0404DB  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0404E0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0404E3  8D 46 9C              LEA    ax, [bp - 0x64] ; ADDR
0404E6  50                    PUSH   ax ; STACK_PUSH
0404E7  68 53 14              PUSH   0x1453                       ; STRING: "COLONY"
0404EA  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
0404EF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0404F2  0B C0                 OR     ax, ax ; LOGIC
0404F4  74 16                 JE     0x4050c ; CJUMP
0404F6  EB 7A                 JMP    0x40572 ; JUMP
0404F8  90                    NOP ; NOP
0404F9  90                    NOP ; NOP
0404FA  68 3E 14              PUSH   0x143e                       ; STRING: "FRENCH"
0404FD  EB D8                 JMP    0x404d7 ; JUMP
0404FF  90                    NOP ; NOP
040500  68 45 14              PUSH   0x1445                       ; STRING: "SPANISH"
040503  EB D2                 JMP    0x404d7 ; JUMP
040505  90                    NOP ; NOP
040506  68 4D 14              PUSH   0x144d                       ; STRING: "DUTCH"
040509  EB CC                 JMP    0x404d7 ; JUMP
04050B  90                    NOP ; NOP
04050C  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
040511  EB 43                 JMP    0x40556 ; JUMP
040513  90                    NOP ; NOP
040514  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
040519  9A C4 0F 1F 19        LCALL  0x191f, 0xfc4 ; THUNK -> 0x0000:0x015E (thunk @file 0x01C5B4 type A) overlay @file 0x025A5E
04051E  50                    PUSH   ax ; STACK_PUSH
04051F  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
040522  50                    PUSH   ax ; STACK_PUSH
040523  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
040528  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04052B  80 7E B0 40           CMP    byte ptr [bp - 0x50], 0x40 ; CMP
04052F  74 41                 JE     0x40572 ; CJUMP
040531  83 7E 9A 00           CMP    word ptr [bp - 0x66], 0 ; CMP
040535  74 0D                 JE     0x40544 ; CJUMP
040537  8B 46 9A              MOV    ax, word ptr [bp - 0x66] ; LOCAL_LOAD
04053A  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
04053E  39 87 40 54           CMP    word ptr [bx + 0x5440], ax ; CMP
040542  75 0F                 JNE    0x40553 ; CJUMP
040544  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
040547  50                    PUSH   ax ; STACK_PUSH
040548  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04054B  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
040550  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040553  FF 46 9A              INC    word ptr [bp - 0x66] ; ARITH
040556  8B 46 9A              MOV    ax, word ptr [bp - 0x66] ; LOCAL_LOAD
040559  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
04055D  39 87 40 54           CMP    word ptr [bx + 0x5440], ax ; CMP
040561  7D B1                 JGE    0x40514 ; CJUMP
040563  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
040566  C6 47 17 00           MOV    byte ptr [bx + 0x17], 0 ; MOV
04056A  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
04056E  FF 87 40 54           INC    word ptr [bx + 0x5440] ; ARITH
040572  9A B8 0F 1F 19        LCALL  0x191f, 0xfb8 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5A8 type A) overlay @file 0x025900
040577  C9                    LEAVE ; EPILOGUE
040578  CB                    RETF ; RETURN
