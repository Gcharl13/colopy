; ============================================================================
; func_078184_unknown
; Region   : overlay
; Bytes    : file 0x078184..0x0781DE  (90 bytes)
; Purpose  : VICEROY.LOG game-state debug log writer  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "VICEROY.LOG"  (auto-named via string xrefs)
; ============================================================================

078184  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
078188  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
07818D  80 3E F0 25 00        CMP    byte ptr [0x25f0], 0 ; CMP
078192  75 08                 JNE    0x7819c ; CJUMP
078194  68 C1 25              PUSH   0x25c1 ; PUSH_CONST
078197  68 C4 25              PUSH   0x25c4                       ; STRING: "VICEROY.LOG"
07819A  EB 06                 JMP    0x781a2 ; JUMP
07819C  68 D0 25              PUSH   0x25d0 ; PUSH_CONST
07819F  68 D3 25              PUSH   0x25d3                       ; STRING: "VICEROY.LOG"
0781A2  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
0781A7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0781AA  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0781AD  0B C0                 OR     ax, ax ; LOGIC
0781AF  74 1D                 JE     0x781ce ; CJUMP
0781B1  C6 06 F0 25 01        MOV    byte ptr [0x25f0], 1 ; GLOBAL_LOAD
0781B6  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0781B9  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0781BC  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0781BF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0781C2  68 DF 25              PUSH   0x25df ; PUSH_CONST
0781C5  50                    PUSH   ax ; STACK_PUSH
0781C6  9A F0 04 1D 0D        LCALL  0xd1d, 0x4f0 ; LCALL
0781CB  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0781CE  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0781D2  74 08                 JE     0x781dc ; CJUMP
0781D4  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0781D7  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
0781DC  C9                    LEAVE ; EPILOGUE
0781DD  CB                    RETF ; RETURN
