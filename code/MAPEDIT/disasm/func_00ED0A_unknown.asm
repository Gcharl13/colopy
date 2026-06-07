; ============================================================================
; func_00ED0A_unknown
; Region   : load_image
; Bytes    : file 0x00ED0A..0x00ED3B  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00ED0A  55                    PUSH   bp ; STACK_PUSH
00ED0B  8B EC                 MOV    bp, sp ; MOV
00ED0D  57                    PUSH   di ; STACK_PUSH
00ED0E  56                    PUSH   si ; STACK_PUSH
00ED0F  C7 06 B6 3A 01 00     MOV    word ptr [0x3ab6], 1 ; GLOBAL_LOAD
00ED15  8B 1E B4 3A           MOV    bx, word ptr [0x3ab4] ; GLOBAL_LOAD
00ED19  BF 00 03              MOV    di, 0x300 ; CONST_LOAD
00ED1C  1E                    PUSH   ds ; STACK_PUSH
00ED1D  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
00ED20  BA C8 03              MOV    dx, 0x3c8 ; CONST_LOAD
00ED23  32 C0                 XOR    al, al ; LOGIC
00ED25  EE                    OUT    dx, al ; IO
00ED26  42                    INC    dx ; ARITH
00ED27  52                    PUSH   dx ; STACK_PUSH
00ED28  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
00ED2B  B4 08                 MOV    ah, 8 ; MOV
00ED2D  EC                    IN     al, dx ; IO
00ED2E  22 C4                 AND    al, ah ; LOGIC
00ED30  75 FB                 JNE    0xed2d ; CJUMP
00ED32  EC                    IN     al, dx ; IO
00ED33  22 C4                 AND    al, ah ; LOGIC
00ED35  74 FB                 JE     0xed32 ; CJUMP
00ED37  FA                    CLI ; FLAG
00ED38  5A                    POP    dx ; STACK_POP
00ED39  8B CF                 MOV    cx, di ; MOV
