; ============================================================================
; func_00304A_unknown
; Region   : load_image
; Bytes    : file 0x00304A..0x0030D8  (142 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00304A  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
00304E  53                    PUSH   bx ; STACK_PUSH
00304F  52                    PUSH   dx ; STACK_PUSH
003050  50                    PUSH   ax ; STACK_PUSH
003051  56                    PUSH   si ; STACK_PUSH
003052  C7 46 F4 FF FF        MOV    word ptr [bp - 0xc], 0xffff ; LOCAL_STORE
003057  8D 4E 0E              LEA    cx, [bp + 0xe] ; ADDR
00305A  51                    PUSH   cx ; STACK_PUSH
00305B  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00305E  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
003061  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
003064  6A 00                 PUSH   0 ; STACK_PUSH
003066  8D 4E FA              LEA    cx, [bp - 6] ; ADDR
003069  51                    PUSH   cx ; STACK_PUSH
00306A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00306D  0E                    PUSH   cs ; STACK_PUSH
00306E  E8 03 FD              CALL   0x2d74 ; CALL_NEAR
003071  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
003074  0B C0                 OR     ax, ax ; LOGIC
003076  75 03                 JNE    0x307b ; CJUMP
003078  E9 81 00              JMP    0x30fc ; JUMP
00307B  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
00307E  8B C6                 MOV    ax, si ; MOV
003080  D1 E6                 SHL    si, 1 ; LOGIC
003082  03 F0                 ADD    si, ax ; ARITH
003084  C1 E6 02              SHL    si, 2 ; LOGIC
003087  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
00308B  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
00308F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
003092  F6 46 06 02           TEST   byte ptr [bp + 6], 2 ; LOGIC
003096  74 05                 JE     0x309d ; CJUMP
003098  40                    INC    ax ; ARITH
003099  40                    INC    ax ; ARITH
00309A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00309D  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
0030A0  8B C6                 MOV    ax, si ; MOV
0030A2  D1 E6                 SHL    si, 1 ; LOGIC
0030A4  03 F0                 ADD    si, ax ; ARITH
0030A6  C1 E6 02              SHL    si, 2 ; LOGIC
0030A9  26 8B 40 40           MOV    ax, word ptr es:[bx + si + 0x40] ; MOV
0030AD  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0030B0  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
0030B3  48                    DEC    ax ; ARITH
0030B4  8B C8                 MOV    cx, ax ; MOV
0030B6  F7 6E F6              IMUL   word ptr [bp - 0xa] ; ARITH
0030B9  01 46 0E              ADD    word ptr [bp + 0xe], ax ; ARITH
0030BC  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
0030BF  EB 35                 JMP    0x30f6 ; JUMP
0030C1  90                    NOP ; NOP
0030C2  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0030C6  7C 34                 JL     0x30fc ; CJUMP
0030C8  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0030CB  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
0030CE  50                    PUSH   ax ; STACK_PUSH
0030CF  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
0030D2  42                    INC    dx ; ARITH
0030D3  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
0030D6  8B C3                 MOV    ax, bx ; MOV
