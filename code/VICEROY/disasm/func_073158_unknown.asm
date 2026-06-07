; ============================================================================
; func_073158_unknown
; Region   : overlay
; Bytes    : file 0x073158..0x073266  (270 bytes)
; Purpose  : Load game prompt  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "LOADGAME"  (auto-named via string xrefs)
; ============================================================================

073158  C8 5A 00 00           ENTER  0x5a, 0 ; PROLOGUE
07315C  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1 ; LOCAL_STORE
073161  6A 0A                 PUSH   0xa ; PUSH_CONST
073163  68 1A 21              PUSH   0x211a                       ; STRING: "LOADGAME"
073166  0E                    PUSH   cs ; STACK_PUSH
073167  E8 01 01              CALL   0x7326b ; CALL_NEAR
07316A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07316D  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
073170  89 56 AA              MOV    word ptr [bp - 0x56], dx ; LOCAL_STORE
073173  0B D0                 OR     dx, ax ; LOGIC
073175  75 03                 JNE    0x7317a ; CJUMP
073177  E9 D4 00              JMP    0x7324e ; JUMP
07317A  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
07317D  50                    PUSH   ax ; STACK_PUSH
07317E  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
073183  48                    DEC    ax ; ARITH
073184  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
073187  0B C0                 OR     ax, ax ; LOGIC
073189  7D 03                 JGE    0x7318e ; CJUMP
07318B  E9 C0 00              JMP    0x7324e ; JUMP
07318E  8B D8                 MOV    bx, ax ; MOV
073190  80 BF 0C A6 00        CMP    byte ptr [bx - 0x59f4], 0 ; CMP
073195  75 03                 JNE    0x7319a ; CJUMP
073197  E9 B4 00              JMP    0x7324e ; JUMP
07319A  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
07319D  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
0731A0  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
0731A5  2B C0                 SUB    ax, ax ; ARITH
0731A7  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
0731AA  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
0731AD  FF 76 AE              PUSH   word ptr [bp - 0x52] ; PUSH_GLOBAL
0731B0  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0731B3  50                    PUSH   ax ; STACK_PUSH
0731B4  0E                    PUSH   cs ; STACK_PUSH
0731B5  E8 AE 00              CALL   0x73266 ; CALL_NEAR
0731B8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0731BB  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0731BE  50                    PUSH   ax ; STACK_PUSH
0731BF  9A 12 0D 1F 1A        LCALL  0x1a1f, 0xd12 ; THUNK -> 0x0000:0x0940 (thunk @file 0x01D302 type A) overlay @file 0x026240
0731C4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0731C7  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
0731CA  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0731CD  16                    PUSH   ss ; STACK_PUSH
0731CE  50                    PUSH   ax ; STACK_PUSH
0731CF  1E                    PUSH   ds ; STACK_PUSH
0731D0  68 D2 9C              PUSH   0x9cd2 ; PUSH_CONST
0731D3  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
0731D8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0731DB  83 7E A6 00           CMP    word ptr [bp - 0x5a], 0 ; CMP
0731DF  75 17                 JNE    0x731f8 ; CJUMP
0731E1  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
0731E5  8D 06 23 21           LEA    ax, [0x2123] ; ADDR
0731E9  2B D2                 SUB    dx, dx ; ARITH
0731EB  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
0731F0  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0 ; LOCAL_STORE
0731F5  EB 57                 JMP    0x7324e ; JUMP
0731F7  90                    NOP ; NOP
0731F8  8B 46 A6              MOV    ax, word ptr [bp - 0x5a] ; LOCAL_LOAD
0731FB  48                    DEC    ax ; ARITH
0731FC  48                    DEC    ax ; ARITH
0731FD  74 0B                 JE     0x7320a ; CJUMP
0731FF  48                    DEC    ax ; ARITH
073200  74 1A                 JE     0x7321c ; CJUMP
073202  48                    DEC    ax ; ARITH
073203  74 21                 JE     0x73226 ; CJUMP
073205  48                    DEC    ax ; ARITH
073206  74 28                 JE     0x73230 ; CJUMP
073208  EB 30                 JMP    0x7323a ; JUMP
07320A  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
07320E  8D 06 2C 21           LEA    ax, [0x212c] ; ADDR
073212  2B D2                 SUB    dx, dx ; ARITH
073214  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
073219  EB 33                 JMP    0x7324e ; JUMP
07321B  90                    NOP ; NOP
07321C  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
073220  8D 06 34 21           LEA    ax, [0x2134] ; ADDR
073224  EB EC                 JMP    0x73212 ; JUMP
073226  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
07322A  8D 06 3C 21           LEA    ax, [0x213c] ; ADDR
07322E  EB E2                 JMP    0x73212 ; JUMP
073230  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
073234  8D 06 45 21           LEA    ax, [0x2145] ; ADDR
073238  EB D8                 JMP    0x73212 ; JUMP
07323A  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
07323E  8D 06 4D 21           LEA    ax, [0x214d] ; ADDR
073242  2B D2                 SUB    dx, dx ; ARITH
073244  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
073249  C7 46 AC 02 00        MOV    word ptr [bp - 0x54], 2 ; LOCAL_STORE
07324E  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
073251  0B 46 A8              OR     ax, word ptr [bp - 0x58] ; LOGIC
073254  74 0B                 JE     0x73261 ; CJUMP
073256  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
073259  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
07325C  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
073261  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
073264  C9                    LEAVE ; EPILOGUE
073265  CB                    RETF ; RETURN
