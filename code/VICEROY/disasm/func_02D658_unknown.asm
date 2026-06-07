; ============================================================================
; func_02D658 — colony_screen_open  (BYTE_VERIFIED 2026-05-04 structural)
; ----------------------------------------------------------------------------
; Opens the colony management screen for the colony specified by [bp+6].
;
; Args:
;   [bp+6]  colony_id — passed to set_current_colony at line 02D666
;
; Globals (BYTE_VERIFIED via separate analysis):
;   [0x8542] colony_struct ptr (g_current_colony)
;     +0x1A  byte  owner_nation
;     +0x90  word  field_a — zeroed at 02D6C2
;     +0x9A  word  field_b — read at 02D6BB
;   [0xA898] byte  entry flag — set to 0 at 02D65E
;
; Outer-loop overlay LCALL chain (resolved via Day-1 LCALL formula):
;   02D666  set_current_colony(colony_id)         -> overlay file 0x02701C
;   02D67C  init_with_owner_nation                -> overlay file 0x025900
;   02D685  CALL near 0x2EF5A                     same-segment helper
;   02D688  load_PIK_background                   -> overlay file 0x0296D4
;   02D68D  screen_clear_or_composer              -> overlay file 0x02A946
;   02D696  colony_query(0x12)                    -> overlay file 0x027AFC
;   02D6A7  generic_global_setter                 -> overlay file 0x026322
;   02D6AF  colony_query_further                  -> overlay file 0x027A40
;
; Per-colonist iteration loop continues through body with further LCALLs
; (0x181F:0xAB0, 0xCFE, 0xC86 — see lcall_resolution_VICEROY.json).
;
; Strings:  NOCOLONIESEITHER, NOPORT, SEACOLONY, TOOMOUNTAIN, TOONEAR,
;           ABANDON, BUILT, FULL, NOTEACHER
; Region:   overlay
; Bytes:    file 0x02D658..0x02DA7D  (1061 bytes)
; Status:   BYTE_VERIFIED structural (call-graph + globals identified;
;           per-line body annotation is M1W2 work)
; ============================================================================

02D658  C8 2C 01 00           ENTER  0x12c, 0 ; PROLOGUE
02D65C  57                    PUSH   di ; STACK_PUSH
02D65D  56                    PUSH   si ; STACK_PUSH
02D65E  C6 06 98 A8 00        MOV    byte ptr [0xa898], 0 ; GLOBAL_LOAD
02D663  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02D666  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
02D66B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D66E  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D672  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
02D675  2A E4                 SUB    ah, ah ; ARITH
02D677  89 86 D6 FE           MOV    word ptr [bp - 0x12a], ax ; LOCAL_STORE
02D67B  50                    PUSH   ax ; STACK_PUSH
02D67C  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
02D681  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D684  0E                    PUSH   cs ; STACK_PUSH
02D685  E8 D2 18              CALL   0x2ef5a ; CALL_NEAR
02D688  9A 72 0C 1F 18        LCALL  0x181f, 0xc72 ; THUNK -> 0x05EB:0x26E4 (thunk @file 0x01B262 type B) overlay @file 0x0296D4
02D68D  9A 22 0C 1F 18        LCALL  0x181f, 0xc22 ; THUNK -> 0x05EB:0x3956 (thunk @file 0x01B212 type B) overlay @file 0x02A946
02D692  6A 00                 PUSH   0 ; STACK_PUSH
02D694  6A 12                 PUSH   0x12 ; PUSH_CONST
02D696  9A 50 0B 1F 18        LCALL  0x181f, 0xb50 ; THUNK -> 0x05EB:0x0B0C (thunk @file 0x01B140 type B) overlay @file 0x027AFC
02D69B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D69E  89 86 48 FF           MOV    word ptr [bp - 0xb8], ax ; LOCAL_STORE
02D6A2  50                    PUSH   ax ; STACK_PUSH
02D6A3  FF B6 D6 FE           PUSH   word ptr [bp - 0x12a] ; PUSH_GLOBAL
02D6A7  9A F8 09 1F 19        LCALL  0x191f, 0x9f8 ; THUNK -> 0x0000:0x0A22 (thunk @file 0x01BFE8 type A) overlay @file 0x026322
02D6AC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D6AF  9A 3A 0D 1F 18        LCALL  0x181f, 0xd3a ; THUNK -> 0x05EB:0x0A50 (thunk @file 0x01B32A type B) overlay @file 0x027A40
02D6B4  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
02D6B7  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D6BB  8B 87 9A 00           MOV    ax, word ptr [bx + 0x9a] ; MOV
02D6BF  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
02D6C2  C7 87 90 00 00 00     MOV    word ptr [bx + 0x90], 0 ; MOV
02D6C8  2B C0                 SUB    ax, ax ; ARITH
02D6CA  89 86 3E FF           MOV    word ptr [bp - 0xc2], ax ; LOCAL_STORE
02D6CE  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
02D6D1  89 86 4C FF           MOV    word ptr [bp - 0xb4], ax ; LOCAL_STORE
02D6D5  E9 10 02              JMP    0x2d8e8 ; JUMP
02D6D8  FF B6 4C FF           PUSH   word ptr [bp - 0xb4] ; PUSH_GLOBAL
02D6DC  0E                    PUSH   cs ; STACK_PUSH
02D6DD  E8 75 18              CALL   0x2ef55 ; CALL_NEAR
02D6E0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D6E3  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02D6E6  0B C0                 OR     ax, ax ; LOGIC
02D6E8  75 03                 JNE    0x2d6ed ; CJUMP
02D6EA  E9 8A 01              JMP    0x2d877 ; JUMP
02D6ED  8B B6 4C FF           MOV    si, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D6F1  D1 E6                 SHL    si, 1 ; LOGIC
02D6F3  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D6F7  83 B8 9A 00 64        CMP    word ptr [bx + si + 0x9a], 0x64 ; CMP
02D6FC  7D 03                 JGE    0x2d701 ; CJUMP
02D6FE  E9 76 01              JMP    0x2d877 ; JUMP
02D701  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; MOV
02D705  2D 32 00              SUB    ax, 0x32 ; ARITH
02D708  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02D70B  29 80 9A 00           SUB    word ptr [bx + si + 0x9a], ax ; ARITH
02D70F  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
02D712  29 86 7C FF           SUB    word ptr [bp - 0x84], ax ; ARITH
02D716  FF B6 4C FF           PUSH   word ptr [bp - 0xb4] ; PUSH_GLOBAL
02D71A  9A EA 09 1F 19        LCALL  0x191f, 0x9ea ; THUNK -> 0x0000:0x0040 (thunk @file 0x01BFDA type A) overlay @file 0x025940
02D71F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D722  F7 6E FE              IMUL   word ptr [bp - 2] ; ARITH
02D725  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
02D728  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
02D72D  75 21                 JNE    0x2d750 ; CJUMP
02D72F  6A 00                 PUSH   0 ; STACK_PUSH
02D731  6A 64                 PUSH   0x64 ; PUSH_CONST
02D733  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
02D737  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
02D73A  98                    CWDE ; ARITH
02D73B  F7 6E 9C              IMUL   word ptr [bp - 0x64] ; ARITH
02D73E  52                    PUSH   dx ; STACK_PUSH
02D73F  50                    PUSH   ax ; STACK_PUSH
02D740  9A C6 0E 1D 0D        LCALL  0xd1d, 0xec6 ; LCALL
02D745  89 86 D8 FE           MOV    word ptr [bp - 0x128], ax ; LOCAL_STORE
02D749  2B 46 9C              SUB    ax, word ptr [bp - 0x64] ; ARITH
02D74C  F7 D8                 NEG    ax ; ARITH
02D74E  EB 06                 JMP    0x2d756 ; JUMP
02D750  C7 86 D8 FE 00 00     MOV    word ptr [bp - 0x128], 0 ; LOCAL_STORE
02D756  89 86 DA FE           MOV    word ptr [bp - 0x126], ax ; LOCAL_STORE
02D75A  99                    CDQ ; ARITH
02D75B  52                    PUSH   dx ; STACK_PUSH
02D75C  50                    PUSH   ax ; STACK_PUSH
02D75D  FF 36 12 9E           PUSH   word ptr [0x9e12] ; PUSH_GLOBAL
02D761  8B F0                 MOV    si, ax ; MOV
02D763  8B FA                 MOV    di, dx ; MOV
02D765  9A BA 0A 1F 18        LCALL  0x181f, 0xaba ; THUNK -> 0x05EB:0x0556 (thunk @file 0x01B0AA type B) overlay @file 0x027546
02D76A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02D76D  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02D770  FF B6 4C FF           PUSH   word ptr [bp - 0xb4] ; PUSH_GLOBAL
02D774  9A 2E 0A 1F 19        LCALL  0x191f, 0xa2e ; THUNK -> 0x0000:0x1DFA (thunk @file 0x01C01E type A) overlay @file 0x0276FA
02D779  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D77C  8B 86 D8 FE           MOV    ax, word ptr [bp - 0x128] ; LOCAL_LOAD
02D780  99                    CDQ ; ARITH
02D781  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
02D785  01 47 22              ADD    word ptr [bx + 0x22], ax ; ARITH
02D788  11 57 24              ADC    word ptr [bx + 0x24], dx ; ARITH
02D78B  01 77 26              ADD    word ptr [bx + 0x26], si ; ARITH
02D78E  11 7F 28              ADC    word ptr [bx + 0x28], di ; ARITH
02D791  83 BE D6 FE 04        CMP    word ptr [bp - 0x12a], 4 ; CMP
02D796  7C 03                 JL     0x2d79b ; CJUMP
02D798  E9 DC 00              JMP    0x2d877 ; JUMP
02D79B  6B 9E D6 FE 34        IMUL   bx, word ptr [bp - 0x12a], 0x34 ; ARITH
02D7A0  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02D7A5  74 03                 JE     0x2d7aa ; CJUMP
02D7A7  E9 CD 00              JMP    0x2d877 ; JUMP
02D7AA  6A 01                 PUSH   1 ; STACK_PUSH
02D7AC  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
02D7B1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D7B4  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
02D7B7  40                    INC    ax ; ARITH
02D7B8  40                    INC    ax ; ARITH
02D7B9  1E                    PUSH   ds ; STACK_PUSH
02D7BA  50                    PUSH   ax ; STACK_PUSH
02D7BB  9A 6A 00 1F 18        LCALL  0x181f, 0x6a ; THUNK -> 0x0009:0x017E (thunk @file 0x01A65A type B) overlay @file 0x022948
02D7C0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D7C3  FF 36 18 2E           PUSH   word ptr [0x2e18] ; PUSH_GLOBAL
02D7C7  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
02D7CC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D7CF  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02D7D2  9A 7E 00 1F 18        LCALL  0x181f, 0x7e ; THUNK -> 0x0009:0x01B8 (thunk @file 0x01A66E type B) overlay @file 0x022982
02D7D7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D7DA  8B 9E 4C FF           MOV    bx, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D7DE  D1 E3                 SHL    bx, 1 ; LOGIC
02D7E0  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
02D7E4  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
02D7E9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D7EC  FF 36 1A 2E           PUSH   word ptr [0x2e1a] ; PUSH_GLOBAL
02D7F0  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
02D7F5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D7F8  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
02D7FB  9A 7E 00 1F 18        LCALL  0x181f, 0x7e ; THUNK -> 0x0009:0x01B8 (thunk @file 0x01A66E type B) overlay @file 0x022982
02D800  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D803  9A 88 00 1F 18        LCALL  0x181f, 0x88 ; THUNK -> 0x0009:0x0222 (thunk @file 0x01A678 type B) overlay @file 0x0229EC
02D808  1E                    PUSH   ds ; STACK_PUSH
02D809  68 88 0D              PUSH   0xd88 ; PUSH_CONST
02D80C  9A 6A 00 1F 18        LCALL  0x181f, 0x6a ; THUNK -> 0x0009:0x017E (thunk @file 0x01A65A type B) overlay @file 0x022948
02D811  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D814  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
02D819  75 47                 JNE    0x2d862 ; CJUMP
02D81B  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
02D81F  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
02D822  98                    CWDE ; ARITH
02D823  50                    PUSH   ax ; STACK_PUSH
02D824  9A 7E 00 1F 18        LCALL  0x181f, 0x7e ; THUNK -> 0x0009:0x01B8 (thunk @file 0x01A66E type B) overlay @file 0x022982
02D829  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D82C  9A 88 00 1F 18        LCALL  0x181f, 0x88 ; THUNK -> 0x0009:0x0222 (thunk @file 0x01A678 type B) overlay @file 0x0229EC
02D831  6A 11                 PUSH   0x11 ; PUSH_CONST
02D833  9A D4 07 1F 19        LCALL  0x191f, 0x7d4 ; THUNK -> 0x0000:0x2EB2 (thunk @file 0x01BDC4 type A) overlay @file 0x0287B2
02D838  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D83B  FF B6 D8 FE           PUSH   word ptr [bp - 0x128] ; PUSH_GLOBAL
02D83F  9A 7E 00 1F 18        LCALL  0x181f, 0x7e ; THUNK -> 0x0009:0x01B8 (thunk @file 0x01A66E type B) overlay @file 0x022982
02D844  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D847  9A 88 00 1F 18        LCALL  0x181f, 0x88 ; THUNK -> 0x0009:0x0222 (thunk @file 0x01A678 type B) overlay @file 0x0229EC
02D84C  6A 12                 PUSH   0x12 ; PUSH_CONST
02D84E  9A D4 07 1F 19        LCALL  0x191f, 0x7d4 ; THUNK -> 0x0000:0x2EB2 (thunk @file 0x01BDC4 type A) overlay @file 0x0287B2
02D853  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D856  FF B6 DA FE           PUSH   word ptr [bp - 0x126] ; PUSH_GLOBAL
02D85A  9A 7E 00 1F 18        LCALL  0x181f, 0x7e ; THUNK -> 0x0009:0x01B8 (thunk @file 0x01A66E type B) overlay @file 0x022982
02D85F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D862  80 3E 97 A8 00        CMP    byte ptr [0xa897], 0 ; CMP
02D867  74 0E                 JE     0x2d877 ; CJUMP
02D869  6A 00                 PUSH   0 ; STACK_PUSH
02D86B  6A 78                 PUSH   0x78 ; PUSH_CONST
02D86D  6A 01                 PUSH   1 ; STACK_PUSH
02D86F  9A B0 07 1F 19        LCALL  0x191f, 0x7b0 ; THUNK -> 0x0000:0x2E92 (thunk @file 0x01BDA0 type A) overlay @file 0x028792
02D874  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02D877  83 BE 4C FF 00        CMP    word ptr [bp - 0xb4], 0 ; CMP
02D87C  74 2A                 JE     0x2d8a8 ; CJUMP
02D87E  FF B6 7C FF           PUSH   word ptr [bp - 0x84] ; PUSH_GLOBAL
02D882  6A 00                 PUSH   0 ; STACK_PUSH
02D884  8B B6 4C FF           MOV    si, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D888  D1 E6                 SHL    si, 1 ; LOGIC
02D88A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D88E  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; MOV
02D892  2B 46 98              SUB    ax, word ptr [bp - 0x68] ; ARITH
02D895  89 82 1E FF           MOV    word ptr [bp + si - 0xe2], ax ; LOCAL_STORE
02D899  50                    PUSH   ax ; STACK_PUSH
02D89A  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
02D89F  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02D8A2  89 82 1E FF           MOV    word ptr [bp + si - 0xe2], ax ; LOCAL_STORE
02D8A6  EB 0C                 JMP    0x2d8b4 ; JUMP
02D8A8  8B B6 4C FF           MOV    si, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D8AC  D1 E6                 SHL    si, 1 ; LOGIC
02D8AE  C7 82 1E FF 00 00     MOV    word ptr [bp + si - 0xe2], 0 ; LOCAL_STORE
02D8B4  8B 9E 4C FF           MOV    bx, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D8B8  D1 E3                 SHL    bx, 1 ; LOGIC
02D8BA  83 BF C8 8D 00        CMP    word ptr [bx - 0x7238], 0 ; CMP
02D8BF  74 23                 JE     0x2d8e4 ; CJUMP
02D8C1  83 BE 7C FF 00        CMP    word ptr [bp - 0x84], 0 ; CMP
02D8C6  7F 0B                 JG     0x2d8d3 ; CJUMP
02D8C8  75 1A                 JNE    0x2d8e4 ; CJUMP
02D8CA  8B F3                 MOV    si, bx ; MOV
02D8CC  83 BA 1E FF 00        CMP    word ptr [bp + si - 0xe2], 0 ; CMP
02D8D1  74 11                 JE     0x2d8e4 ; CJUMP
02D8D3  8A 8E 4C FF           MOV    cl, byte ptr [bp - 0xb4] ; LOCAL_LOAD
02D8D7  B8 01 00              MOV    ax, 1 ; MOV
02D8DA  D3 E0                 SHL    ax, cl ; LOGIC
02D8DC  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D8E0  09 87 90 00           OR     word ptr [bx + 0x90], ax ; LOGIC
02D8E4  FF 86 4C FF           INC    word ptr [bp - 0xb4] ; ARITH
02D8E8  83 BE 4C FF 10        CMP    word ptr [bp - 0xb4], 0x10 ; CMP
02D8ED  7C 03                 JL     0x2d8f2 ; CJUMP
02D8EF  E9 E4 00              JMP    0x2d9d6 ; JUMP
02D8F2  8B B6 4C FF           MOV    si, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D8F6  D1 E6                 SHL    si, 1 ; LOGIC
02D8F8  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D8FC  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; MOV
02D900  89 82 54 FF           MOV    word ptr [bp + si - 0xac], ax ; LOCAL_STORE
02D904  6A 00                 PUSH   0 ; STACK_PUSH
02D906  FF B6 4C FF           PUSH   word ptr [bp - 0xb4] ; PUSH_GLOBAL
02D90A  9A 50 0B 1F 18        LCALL  0x181f, 0xb50 ; THUNK -> 0x05EB:0x0B0C (thunk @file 0x01B140 type B) overlay @file 0x027AFC
02D90F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D912  89 86 7C FF           MOV    word ptr [bp - 0x84], ax ; LOCAL_STORE
02D916  83 BE D6 FE 04        CMP    word ptr [bp - 0x12a], 4 ; CMP
02D91B  7D 0C                 JGE    0x2d929 ; CJUMP
02D91D  6B 9E D6 FE 34        IMUL   bx, word ptr [bp - 0x12a], 0x34 ; ARITH
02D922  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02D927  74 12                 JE     0x2d93b ; CJUMP
02D929  8B 9E 4C FF           MOV    bx, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D92D  D1 E3                 SHL    bx, 1 ; LOGIC
02D92F  8B 87 C8 8D           MOV    ax, word ptr [bx - 0x7238] ; MOV
02D933  2B 87 0A 8E           SUB    ax, word ptr [bx - 0x71f6] ; ARITH
02D937  89 86 7C FF           MOV    word ptr [bp - 0x84], ax ; LOCAL_STORE
02D93B  83 BE D6 FE 04        CMP    word ptr [bp - 0x12a], 4 ; CMP
02D940  7D 0C                 JGE    0x2d94e ; CJUMP
02D942  6B 9E D6 FE 34        IMUL   bx, word ptr [bp - 0x12a], 0x34 ; ARITH
02D947  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02D94C  74 12                 JE     0x2d960 ; CJUMP
02D94E  83 BE 4C FF 00        CMP    word ptr [bp - 0xb4], 0 ; CMP
02D953  75 0B                 JNE    0x2d960 ; CJUMP
02D955  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
02D958  D0 E8                 SHR    al, 1 ; LOGIC
02D95A  2A E4                 SUB    ah, ah ; ARITH
02D95C  01 86 7C FF           ADD    word ptr [bp - 0x84], ax ; ARITH
02D960  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84] ; LOCAL_LOAD
02D964  8B B6 4C FF           MOV    si, word ptr [bp - 0xb4] ; LOCAL_LOAD
02D968  D1 E6                 SHL    si, 1 ; LOGIC
02D96A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D96E  01 80 9A 00           ADD    word ptr [bx + si + 0x9a], ax ; ARITH
02D972  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; MOV
02D976  0B C0                 OR     ax, ax ; LOGIC
02D978  7D 02                 JGE    0x2d97c ; CJUMP
02D97A  2B C0                 SUB    ax, ax ; ARITH
02D97C  89 80 9A 00           MOV    word ptr [bx + si + 0x9a], ax ; MOV
02D980  6A 12                 PUSH   0x12 ; PUSH_CONST
02D982  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
02D987  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D98A  0B C0                 OR     ax, ax ; LOGIC
02D98C  75 03                 JNE    0x2d991 ; CJUMP
02D98E  E9 E6 FE              JMP    0x2d877 ; JUMP
02D991  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D995  F6 47 1B 03           TEST   byte ptr [bx + 0x1b], 3 ; LOGIC
02D999  74 16                 JE     0x2d9b1 ; CJUMP
02D99B  83 BE D6 FE 04        CMP    word ptr [bp - 0x12a], 4 ; CMP
02D9A0  7D 0F                 JGE    0x2d9b1 ; CJUMP
02D9A2  6B 9E D6 FE 34        IMUL   bx, word ptr [bp - 0x12a], 0x34 ; ARITH
02D9A7  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02D9AC  75 03                 JNE    0x2d9b1 ; CJUMP
02D9AE  E9 C6 FE              JMP    0x2d877 ; JUMP
02D9B1  83 BE D6 FE 04        CMP    word ptr [bp - 0x12a], 4 ; CMP
02D9B6  7C 03                 JL     0x2d9bb ; CJUMP
02D9B8  E9 1D FD              JMP    0x2d6d8 ; JUMP
02D9BB  6B 9E D6 FE 34        IMUL   bx, word ptr [bp - 0x12a], 0x34 ; ARITH
02D9C0  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
02D9C5  74 03                 JE     0x2d9ca ; CJUMP
02D9C7  E9 0E FD              JMP    0x2d6d8 ; JUMP
02D9CA  FF B6 4C FF           PUSH   word ptr [bp - 0xb4] ; PUSH_GLOBAL
02D9CE  9A FE 0C 1F 18        LCALL  0x181f, 0xcfe ; THUNK -> 0x05EB:0x0302 (thunk @file 0x01B2EE type B) overlay @file 0x0272F2
02D9D3  E9 0A FD              JMP    0x2d6e0 ; JUMP
02D9D6  9A 86 0C 1F 18        LCALL  0x181f, 0xc86 ; THUNK -> 0x05EB:0x0274 (thunk @file 0x01B276 type B) overlay @file 0x027264
02D9DB  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax ; LOCAL_STORE
02D9DF  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
02D9E4  74 1A                 JE     0x2da00 ; CJUMP
02D9E6  A0 D2 53              MOV    al, byte ptr [0x53d2] ; GLOBAL_LOAD
02D9E9  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D9ED  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
02D9F0  75 0E                 JNE    0x2da00 ; CJUMP
02D9F2  8B 86 48 FF           MOV    ax, word ptr [bp - 0xb8] ; LOCAL_LOAD
02D9F6  D1 F8                 SAR    ax, 1 ; LOGIC
02D9F8  F7 D8                 NEG    ax ; ARITH
02D9FA  89 86 48 FF           MOV    word ptr [bp - 0xb8], ax ; LOCAL_STORE
02D9FE  EB 1C                 JMP    0x2da1c ; JUMP
02DA00  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02DA04  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
02DA07  98                    CWDE ; ARITH
02DA08  3B 86 48 FF           CMP    ax, word ptr [bp - 0xb8] ; CMP
02DA0C  7E 0E                 JLE    0x2da1c ; CJUMP
02DA0E  8B 86 74 FF           MOV    ax, word ptr [bp - 0x8c] ; LOCAL_LOAD
02DA12  B9 EC FF              MOV    cx, 0xffec ; CONST_LOAD
02DA15  99                    CDQ ; ARITH
02DA16  F7 F9                 IDIV   cx ; ARITH
02DA18  01 86 48 FF           ADD    word ptr [bp - 0xb8], ax ; ARITH
02DA1C  8B 87 C6 00           MOV    ax, word ptr [bx + 0xc6] ; MOV
02DA20  8B 97 C8 00           MOV    dx, word ptr [bx + 0xc8] ; MOV
02DA24  D1 FA                 SAR    dx, 1 ; LOGIC
02DA26  D1 D8                 RCR    ax, 1 ; LOGIC
02DA28  D1 FA                 SAR    dx, 1 ; LOGIC
02DA2A  D1 D8                 RCR    ax, 1 ; LOGIC
02DA2C  D1 FA                 SAR    dx, 1 ; LOGIC
02DA2E  D1 D8                 RCR    ax, 1 ; LOGIC
02DA30  D1 FA                 SAR    dx, 1 ; LOGIC
02DA32  D1 D8                 RCR    ax, 1 ; LOGIC
02DA34  D1 FA                 SAR    dx, 1 ; LOGIC
02DA36  D1 D8                 RCR    ax, 1 ; LOGIC
02DA38  D1 FA                 SAR    dx, 1 ; LOGIC
02DA3A  D1 D8                 RCR    ax, 1 ; LOGIC
02DA3C  29 87 C6 00           SUB    word ptr [bx + 0xc6], ax ; ARITH
02DA40  19 97 C8 00           SBB    word ptr [bx + 0xc8], dx ; ARITH
02DA44  8B 87 C6 00           MOV    ax, word ptr [bx + 0xc6] ; MOV
02DA48  8B 97 C8 00           MOV    dx, word ptr [bx + 0xc8] ; MOV
02DA4C  0B D2                 OR     dx, dx ; LOGIC
02DA4E  7F 0C                 JG     0x2da5c ; CJUMP
02DA50  7C 05                 JL     0x2da57 ; CJUMP
02DA52  3D 01 00              CMP    ax, 1 ; CMP
02DA55  73 05                 JAE    0x2da5c ; CJUMP
02DA57  2B D2                 SUB    dx, dx ; ARITH
02DA59  B8 01 00              MOV    ax, 1 ; MOV
02DA5C  89 87 C6 00           MOV    word ptr [bx + 0xc6], ax ; MOV
02DA60  89 97 C8 00           MOV    word ptr [bx + 0xc8], dx ; MOV
02DA64  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
02DA67  98                    CWDE ; ARITH
02DA68  D1 E0                 SHL    ax, 1 ; LOGIC
02DA6A  99                    CDQ ; ARITH
02DA6B  01 87 C6 00           ADD    word ptr [bx + 0xc6], ax ; ARITH
02DA6F  11 97 C8 00           ADC    word ptr [bx + 0xc8], dx ; ARITH
02DA73  8B 86 48 FF           MOV    ax, word ptr [bp - 0xb8] ; LOCAL_LOAD
02DA77  99                    CDQ ; ARITH
02DA78  8B 8F C2 00           MOV    cx, word ptr [bx + 0xc2] ; MOV
02DA7C  8B                    DB     0x8B ; DATA_BYTE
