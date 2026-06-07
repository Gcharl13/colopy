; ============================================================================
; func_0241CE_unknown
; Region   : overlay
; Bytes    : file 0x0241CE..0x0241FB  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0241CE  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0241D2  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
0241D7  A1 1E 98              MOV    ax, word ptr [0x981e] ; GLOBAL_LOAD
0241DA  2D 0D 00              SUB    ax, 0xd ; ARITH
0241DD  75 3B                 JNE    0x2421a ; CJUMP
0241DF  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
0241E3  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
0241E7  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
0241EC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0241EF  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0241F2  0B C0                 OR     ax, ax ; LOGIC
0241F4  7C 29                 JL     0x2421f ; CJUMP
0241F6  69 D8 CA 00           IMUL   bx, ax, 0xca ; ARITH
0241FA  A0                    DB     0xA0 ; DATA_BYTE
