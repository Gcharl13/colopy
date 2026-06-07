; ============================================================================
; func_0060A0_unknown
; Region   : load_image
; Bytes    : file 0x0060A0..0x006120  (128 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0060A0  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
0060A4  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
0060A9  83 3E 90 01 00        CMP    word ptr [0x190], 0 ; CMP
0060AE  75 03                 JNE    0x60b3 ; CJUMP
0060B0  E9 D0 00              JMP    0x6183 ; JUMP
0060B3  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0060B6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0060B9  0E                    PUSH   cs ; STACK_PUSH
0060BA  E8 C5 FE              CALL   0x5f82 ; CALL_NEAR
0060BD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0060C0  0B C0                 OR     ax, ax ; LOGIC
0060C2  7C 03                 JL     0x60c7 ; CJUMP
0060C4  E9 BC 00              JMP    0x6183 ; JUMP
0060C7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0060CA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0060CD  0E                    PUSH   cs ; STACK_PUSH
0060CE  E8 2D FC              CALL   0x5cfe ; CALL_NEAR
0060D1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0060D4  2A E4                 SUB    ah, ah ; ARITH
0060D6  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0060D9  80 66 F8 3F           AND    byte ptr [bp - 8], 0x3f ; LOGIC
0060DD  83 7E F8 08           CMP    word ptr [bp - 8], 8 ; CMP
0060E1  7C 06                 JL     0x60e9 ; CJUMP
0060E3  83 7E F8 10           CMP    word ptr [bp - 8], 0x10 ; CMP
0060E7  7C 0C                 JL     0x60f5 ; CJUMP
0060E9  83 7E F8 10           CMP    word ptr [bp - 8], 0x10 ; CMP
0060ED  7C 0D                 JL     0x60fc ; CJUMP
0060EF  83 7E F8 18           CMP    word ptr [bp - 8], 0x18 ; CMP
0060F3  7D 07                 JGE    0x60fc ; CJUMP
0060F5  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0060FA  EB 05                 JMP    0x6101 ; JUMP
0060FC  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
006101  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
006104  25 03 00              AND    ax, 3 ; LOGIC
006107  C1 E0 02              SHL    ax, 2 ; LOGIC
00610A  8A 4E 08              MOV    cl, byte ptr [bp + 8] ; LOCAL_LOAD
00610D  83 E1 03              AND    cx, 3 ; LOGIC
006110  03 C1                 ADD    ax, cx ; ARITH
006112  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
006115  C1 F9 02              SAR    cx, 2 ; LOGIC
006118  8B D1                 MOV    dx, cx ; MOV
00611A  D1 E1                 SHL    cx, 1 ; LOGIC
00611C  03 CA                 ADD    cx, dx ; ARITH
00611E  8B                    DB     0x8B ; DATA_BYTE
00611F  56                    DB     0x56 ; DATA_BYTE
