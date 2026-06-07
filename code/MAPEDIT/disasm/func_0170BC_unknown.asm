; ============================================================================
; func_0170BC_unknown
; Region   : load_image
; Bytes    : file 0x0170BC..0x017125  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0170BC  55                    PUSH   bp ; STACK_PUSH
0170BD  8B EC                 MOV    bp, sp ; MOV
0170BF  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
0170C2  32 FF                 XOR    bh, bh ; LOGIC
0170C4  88 7E FE              MOV    byte ptr [bp - 2], bh ; LOCAL_STORE
0170C7  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0170CA  8B C8                 MOV    cx, ax ; MOV
0170CC  C6 46 FC 00           MOV    byte ptr [bp - 4], 0 ; LOCAL_STORE
0170D0  A9 00 80              TEST   ax, 0x8000 ; LOGIC
0170D3  75 10                 JNE    0x170e5 ; CJUMP
0170D5  A9 00 40              TEST   ax, 0x4000 ; LOGIC
0170D8  75 07                 JNE    0x170e1 ; CJUMP
0170DA  F6 06 91 48 80        TEST   byte ptr [0x4891], 0x80 ; LOGIC
0170DF  75 04                 JNE    0x170e5 ; CJUMP
0170E1  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
0170E5  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0170E8  24 03                 AND    al, 3 ; LOGIC
0170EA  0A C7                 OR     al, bh ; LOGIC
0170EC  B4 3D                 MOV    ah, 0x3d ; CONST_LOAD
0170EE  CD 21                 INT    0x21 ; SYS
0170F0  73 12                 JAE    0x17104 ; CJUMP
0170F2  3D 02 00              CMP    ax, 2 ; CMP
0170F5  75 09                 JNE    0x17100 ; CJUMP
0170F7  F7 C1 00 01           TEST   cx, 0x100 ; LOGIC
0170FB  74 03                 JE     0x17100 ; CJUMP
0170FD  E9 9F 00              JMP    0x1719f ; JUMP
017100  F9                    STC ; FLAG
017101  E9 C9 EF              JMP    0x160cd ; JUMP
017104  93                    XCHG   bx, ax ; MOV
017105  8B C1                 MOV    ax, cx ; MOV
017107  25 00 05              AND    ax, 0x500 ; LOGIC
01710A  3D 00 05              CMP    ax, 0x500 ; CMP
01710D  75 09                 JNE    0x17118 ; CJUMP
01710F  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
017111  CD 21                 INT    0x21 ; SYS
017113  B8 00 11              MOV    ax, 0x1100 ; CONST_LOAD
017116  EB E8                 JMP    0x17100 ; JUMP
017118  C6 46 FD 01           MOV    byte ptr [bp - 3], 1 ; LOCAL_STORE
01711C  B8 00 44              MOV    ax, 0x4400 ; CONST_LOAD
01711F  CD 21                 INT    0x21 ; SYS
017121  F6 C2 80              TEST   dl, 0x80 ; LOGIC
017124  74                    DB     0x74 ; DATA_BYTE
