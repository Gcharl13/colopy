; ============================================================================
; func_02287E_unknown
; Region   : overlay
; Bytes    : file 0x02287E..0x02291D  (159 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "DISBANDSHIP"  (auto-named via string xrefs)
; ============================================================================

02287E  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
022882  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
022886  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
02288A  9A DC 06 1F 18        LCALL  0x181f, 0x6dc ; THUNK -> 0x037F:0x0200 (thunk @file 0x01ACCC type B) overlay @file 0x02ED3C
02288F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022892  98                    CWDE ; ARITH
022893  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
022896  F6 06 83 53 20        TEST   byte ptr [0x5383], 0x20 ; LOGIC
02289B  75 0B                 JNE    0x228a8 ; CJUMP
02289D  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
0228A0  39 46 FA              CMP    word ptr [bp - 6], ax ; CMP
0228A3  74 03                 JE     0x228a8 ; CJUMP
0228A5  E9 90 01              JMP    0x22a38 ; JUMP
0228A8  A1 40 85              MOV    ax, word ptr [0x8540] ; GLOBAL_LOAD
0228AB  8B 16 3E 85           MOV    dx, word ptr [0x853e] ; GLOBAL_LOAD
0228AF  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
0228B4  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0228B7  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
0228BC  75 06                 JNE    0x228c4 ; CJUMP
0228BE  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
0228C1  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0228C4  0B C0                 OR     ax, ax ; LOGIC
0228C6  7D 03                 JGE    0x228cb ; CJUMP
0228C8  E9 F5 00              JMP    0x229c0 ; JUMP
0228CB  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
0228CE  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
0228D3  72 49                 JB     0x2291e ; CJUMP
0228D5  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
0228DA  77 42                 JA     0x2291e ; CJUMP
0228DC  50                    PUSH   ax ; STACK_PUSH
0228DD  9A 20 09 1F 18        LCALL  0x181f, 0x920 ; THUNK -> 0x0427:0x10BE (thunk @file 0x01AF10 type B) overlay @file 0x031DD2
0228E2  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0228E5  6A 02                 PUSH   2 ; STACK_PUSH
0228E7  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0228EA  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
0228EF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0228F2  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0228F5  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
0228F9  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
0228FD  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
022900  9A 48 09 1F 18        LCALL  0x181f, 0x948 ; THUNK -> 0x0427:0x040C (thunk @file 0x01AF38 type B) overlay @file 0x031120
022905  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
022908  83 7E FE 01           CMP    word ptr [bp - 2], 1 ; CMP
02290C  7E 10                 JLE    0x2291e ; CJUMP
02290E  6A 00                 PUSH   0 ; STACK_PUSH
022910  68 F5 09              PUSH   0x9f5                        ; STRING: "DISBANDSHIP"
022913  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
022918  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02291B  C9                    LEAVE ; EPILOGUE
02291C  CB                    RETF ; RETURN
