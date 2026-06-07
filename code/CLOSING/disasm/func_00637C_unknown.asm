; ============================================================================
; func_00637C_unknown
; Region   : load_image
; Bytes    : file 0x00637C..0x0063E5  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00637C  55                    PUSH   bp ; STACK_PUSH
00637D  8B EC                 MOV    bp, sp ; MOV
00637F  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
006382  32 FF                 XOR    bh, bh ; LOGIC
006384  88 7E FE              MOV    byte ptr [bp - 2], bh ; LOCAL_STORE
006387  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00638A  8B C8                 MOV    cx, ax ; MOV
00638C  C6 46 FC 00           MOV    byte ptr [bp - 4], 0 ; LOCAL_STORE
006390  A9 00 80              TEST   ax, 0x8000 ; LOGIC
006393  75 10                 JNE    0x63a5 ; CJUMP
006395  A9 00 40              TEST   ax, 0x4000 ; LOGIC
006398  75 07                 JNE    0x63a1 ; CJUMP
00639A  F6 06 99 43 80        TEST   byte ptr [0x4399], 0x80 ; LOGIC
00639F  75 04                 JNE    0x63a5 ; CJUMP
0063A1  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
0063A5  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0063A8  24 03                 AND    al, 3 ; LOGIC
0063AA  0A C7                 OR     al, bh ; LOGIC
0063AC  B4 3D                 MOV    ah, 0x3d ; CONST_LOAD
0063AE  CD 21                 INT    0x21 ; SYS
0063B0  73 12                 JAE    0x63c4 ; CJUMP
0063B2  3D 02 00              CMP    ax, 2 ; CMP
0063B5  75 09                 JNE    0x63c0 ; CJUMP
0063B7  F7 C1 00 01           TEST   cx, 0x100 ; LOGIC
0063BB  74 03                 JE     0x63c0 ; CJUMP
0063BD  E9 9F 00              JMP    0x645f ; JUMP
0063C0  F9                    STC ; FLAG
0063C1  E9 A5 EF              JMP    0x5369 ; JUMP
0063C4  93                    XCHG   bx, ax ; MOV
0063C5  8B C1                 MOV    ax, cx ; MOV
0063C7  25 00 05              AND    ax, 0x500 ; LOGIC
0063CA  3D 00 05              CMP    ax, 0x500 ; CMP
0063CD  75 09                 JNE    0x63d8 ; CJUMP
0063CF  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
0063D1  CD 21                 INT    0x21 ; SYS
0063D3  B8 00 11              MOV    ax, 0x1100 ; CONST_LOAD
0063D6  EB E8                 JMP    0x63c0 ; JUMP
0063D8  C6 46 FD 01           MOV    byte ptr [bp - 3], 1 ; LOCAL_STORE
0063DC  B8 00 44              MOV    ax, 0x4400 ; CONST_LOAD
0063DF  CD 21                 INT    0x21 ; SYS
0063E1  F6 C2 80              TEST   dl, 0x80 ; LOGIC
0063E4  74                    DB     0x74 ; DATA_BYTE
