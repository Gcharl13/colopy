; ============================================================================
; func_011D30_unknown
; Region   : load_image
; Bytes    : file 0x011D30..0x011D99  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011D30  55                    PUSH   bp ; STACK_PUSH
011D31  8B EC                 MOV    bp, sp ; MOV
011D33  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
011D36  32 FF                 XOR    bh, bh ; LOGIC
011D38  88 7E FE              MOV    byte ptr [bp - 2], bh ; LOCAL_STORE
011D3B  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
011D3E  8B C8                 MOV    cx, ax ; MOV
011D40  C6 46 FC 00           MOV    byte ptr [bp - 4], 0 ; LOCAL_STORE
011D44  A9 00 80              TEST   ax, 0x8000 ; LOGIC
011D47  75 10                 JNE    0x11d59 ; CJUMP
011D49  A9 00 40              TEST   ax, 0x4000 ; LOGIC
011D4C  75 07                 JNE    0x11d55 ; CJUMP
011D4E  F6 06 01 2B 80        TEST   byte ptr [0x2b01], 0x80 ; LOGIC
011D53  75 04                 JNE    0x11d59 ; CJUMP
011D55  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
011D59  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
011D5C  24 03                 AND    al, 3 ; LOGIC
011D5E  0A C7                 OR     al, bh ; LOGIC
011D60  B4 3D                 MOV    ah, 0x3d ; CONST_LOAD
011D62  CD 21                 INT    0x21 ; SYS
011D64  73 12                 JAE    0x11d78 ; CJUMP
011D66  3D 02 00              CMP    ax, 2 ; CMP
011D69  75 09                 JNE    0x11d74 ; CJUMP
011D6B  F7 C1 00 01           TEST   cx, 0x100 ; LOGIC
011D6F  74 03                 JE     0x11d74 ; CJUMP
011D71  E9 9F 00              JMP    0x11e13 ; JUMP
011D74  F9                    STC ; FLAG
011D75  E9 6D ED              JMP    0x10ae5 ; JUMP
011D78  93                    XCHG   bx, ax ; MOV
011D79  8B C1                 MOV    ax, cx ; MOV
011D7B  25 00 05              AND    ax, 0x500 ; LOGIC
011D7E  3D 00 05              CMP    ax, 0x500 ; CMP
011D81  75 09                 JNE    0x11d8c ; CJUMP
011D83  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
011D85  CD 21                 INT    0x21 ; SYS
011D87  B8 00 11              MOV    ax, 0x1100 ; CONST_LOAD
011D8A  EB E8                 JMP    0x11d74 ; JUMP
011D8C  C6 46 FD 01           MOV    byte ptr [bp - 3], 1 ; LOCAL_STORE
011D90  B8 00 44              MOV    ax, 0x4400 ; CONST_LOAD
011D93  CD 21                 INT    0x21 ; SYS
011D95  F6 C2 80              TEST   dl, 0x80 ; LOGIC
011D98  74                    DB     0x74 ; DATA_BYTE
