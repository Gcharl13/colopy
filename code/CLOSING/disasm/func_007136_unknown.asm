; ============================================================================
; func_007136_unknown
; Region   : load_image
; Bytes    : file 0x007136..0x007168  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007136  55                    PUSH   bp ; STACK_PUSH
007137  8B EC                 MOV    bp, sp ; MOV
007139  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
00713C  B8 00 43              MOV    ax, 0x4300 ; CONST_LOAD
00713F  CD 21                 INT    0x21 ; SYS
007141  72 0F                 JB     0x7152 ; CJUMP
007143  F6 46 08 02           TEST   byte ptr [bp + 8], 2 ; LOGIC
007147  74 09                 JE     0x7152 ; CJUMP
007149  F6 C1 01              TEST   cl, 1 ; LOGIC
00714C  74 04                 JE     0x7152 ; CJUMP
00714E  B8 00 0D              MOV    ax, 0xd00 ; CONST_LOAD
007151  F9                    STC ; FLAG
007152  E9 FF E1              JMP    0x5354 ; JUMP
007155  00 41 80              ADD    byte ptr [bx + di - 0x80], al ; ARITH
007158  E1 FE                 LOOPE  0x7158 ; CJUMP
00715A  53                    PUSH   bx ; STACK_PUSH
00715B  FC                    CLD ; FLAG
00715C  8B 77 08              MOV    si, word ptr [bx + 8] ; MOV
00715F  8B 5F 0A              MOV    bx, word ptr [bx + 0xa] ; MOV
007162  33 FF                 XOR    di, di ; LOGIC
007164  EB 23                 JMP    0x7189 ; JUMP
007166  8B C3                 MOV    ax, bx ; MOV
