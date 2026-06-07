; ============================================================================
; func_00D1E4_unknown
; Region   : load_image
; Bytes    : file 0x00D1E4..0x00D218  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D1E4  55                    PUSH   bp ; STACK_PUSH
00D1E5  8B EC                 MOV    bp, sp ; MOV
00D1E7  57                    PUSH   di ; STACK_PUSH
00D1E8  56                    PUSH   si ; STACK_PUSH
00D1E9  C7 06 08 08 01 00     MOV    word ptr [0x808], 1 ; GLOBAL_LOAD
00D1EF  8B 1E 06 08           MOV    bx, word ptr [0x806] ; GLOBAL_LOAD
00D1F3  BB 00 03              MOV    bx, 0x300 ; CONST_LOAD
00D1F6  BF 00 03              MOV    di, 0x300 ; CONST_LOAD
00D1F9  1E                    PUSH   ds ; STACK_PUSH
00D1FA  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
00D1FD  BA C8 03              MOV    dx, 0x3c8 ; CONST_LOAD
00D200  32 C0                 XOR    al, al ; LOGIC
00D202  EE                    OUT    dx, al ; IO
00D203  42                    INC    dx ; ARITH
00D204  52                    PUSH   dx ; STACK_PUSH
00D205  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
00D208  B4 08                 MOV    ah, 8 ; MOV
00D20A  EC                    IN     al, dx ; IO
00D20B  22 C4                 AND    al, ah ; LOGIC
00D20D  75 FB                 JNE    0xd20a ; CJUMP
00D20F  EC                    IN     al, dx ; IO
00D210  22 C4                 AND    al, ah ; LOGIC
00D212  74 FB                 JE     0xd20f ; CJUMP
00D214  FA                    CLI ; FLAG
00D215  5A                    POP    dx ; STACK_POP
00D216  8B CF                 MOV    cx, di ; MOV
