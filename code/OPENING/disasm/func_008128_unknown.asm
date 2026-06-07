; ============================================================================
; func_008128_unknown
; Region   : load_image
; Bytes    : file 0x008128..0x00815A  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008128  55                    PUSH   bp ; STACK_PUSH
008129  8B EC                 MOV    bp, sp ; MOV
00812B  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
00812E  B8 00 43              MOV    ax, 0x4300 ; CONST_LOAD
008131  CD 21                 INT    0x21 ; SYS
008133  72 0F                 JB     0x8144 ; CJUMP
008135  F6 46 08 02           TEST   byte ptr [bp + 8], 2 ; LOGIC
008139  74 09                 JE     0x8144 ; CJUMP
00813B  F6 C1 01              TEST   cl, 1 ; LOGIC
00813E  74 04                 JE     0x8144 ; CJUMP
008140  B8 00 0D              MOV    ax, 0xd00 ; CONST_LOAD
008143  F9                    STC ; FLAG
008144  E9 0D E2              JMP    0x6354 ; JUMP
008147  00 41 80              ADD    byte ptr [bx + di - 0x80], al ; ARITH
00814A  E1 FE                 LOOPE  0x814a ; CJUMP
00814C  53                    PUSH   bx ; STACK_PUSH
00814D  FC                    CLD ; FLAG
00814E  8B 77 08              MOV    si, word ptr [bx + 8] ; MOV
008151  8B 5F 0A              MOV    bx, word ptr [bx + 0xa] ; MOV
008154  33 FF                 XOR    di, di ; LOGIC
008156  EB 23                 JMP    0x817b ; JUMP
008158  8B C3                 MOV    ax, bx ; MOV
