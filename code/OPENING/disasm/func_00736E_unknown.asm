; ============================================================================
; func_00736E_unknown
; Region   : load_image
; Bytes    : file 0x00736E..0x0073D7  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00736E  55                    PUSH   bp ; STACK_PUSH
00736F  8B EC                 MOV    bp, sp ; MOV
007371  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
007374  32 FF                 XOR    bh, bh ; LOGIC
007376  88 7E FE              MOV    byte ptr [bp - 2], bh ; LOCAL_STORE
007379  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00737C  8B C8                 MOV    cx, ax ; MOV
00737E  C6 46 FC 00           MOV    byte ptr [bp - 4], 0 ; LOCAL_STORE
007382  A9 00 80              TEST   ax, 0x8000 ; LOGIC
007385  75 10                 JNE    0x7397 ; CJUMP
007387  A9 00 40              TEST   ax, 0x4000 ; LOGIC
00738A  75 07                 JNE    0x7393 ; CJUMP
00738C  F6 06 EF 45 80        TEST   byte ptr [0x45ef], 0x80 ; LOGIC
007391  75 04                 JNE    0x7397 ; CJUMP
007393  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
007397  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
00739A  24 03                 AND    al, 3 ; LOGIC
00739C  0A C7                 OR     al, bh ; LOGIC
00739E  B4 3D                 MOV    ah, 0x3d ; CONST_LOAD
0073A0  CD 21                 INT    0x21 ; SYS
0073A2  73 12                 JAE    0x73b6 ; CJUMP
0073A4  3D 02 00              CMP    ax, 2 ; CMP
0073A7  75 09                 JNE    0x73b2 ; CJUMP
0073A9  F7 C1 00 01           TEST   cx, 0x100 ; LOGIC
0073AD  74 03                 JE     0x73b2 ; CJUMP
0073AF  E9 9F 00              JMP    0x7451 ; JUMP
0073B2  F9                    STC ; FLAG
0073B3  E9 B3 EF              JMP    0x6369 ; JUMP
0073B6  93                    XCHG   bx, ax ; MOV
0073B7  8B C1                 MOV    ax, cx ; MOV
0073B9  25 00 05              AND    ax, 0x500 ; LOGIC
0073BC  3D 00 05              CMP    ax, 0x500 ; CMP
0073BF  75 09                 JNE    0x73ca ; CJUMP
0073C1  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
0073C3  CD 21                 INT    0x21 ; SYS
0073C5  B8 00 11              MOV    ax, 0x1100 ; CONST_LOAD
0073C8  EB E8                 JMP    0x73b2 ; JUMP
0073CA  C6 46 FD 01           MOV    byte ptr [bp - 3], 1 ; LOCAL_STORE
0073CE  B8 00 44              MOV    ax, 0x4400 ; CONST_LOAD
0073D1  CD 21                 INT    0x21 ; SYS
0073D3  F6 C2 80              TEST   dl, 0x80 ; LOGIC
0073D6  74                    DB     0x74 ; DATA_BYTE
