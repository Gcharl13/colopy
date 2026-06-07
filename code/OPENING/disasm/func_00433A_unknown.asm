; ============================================================================
; func_00433A_unknown
; Region   : load_image
; Bytes    : file 0x00433A..0x00436B  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00433A  55                    PUSH   bp ; STACK_PUSH
00433B  8B EC                 MOV    bp, sp ; MOV
00433D  57                    PUSH   di ; STACK_PUSH
00433E  56                    PUSH   si ; STACK_PUSH
00433F  C7 06 D6 38 01 00     MOV    word ptr [0x38d6], 1 ; GLOBAL_LOAD
004345  8B 1E D4 38           MOV    bx, word ptr [0x38d4] ; GLOBAL_LOAD
004349  BF 00 03              MOV    di, 0x300 ; CONST_LOAD
00434C  1E                    PUSH   ds ; STACK_PUSH
00434D  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
004350  BA C8 03              MOV    dx, 0x3c8 ; CONST_LOAD
004353  32 C0                 XOR    al, al ; LOGIC
004355  EE                    OUT    dx, al ; IO
004356  42                    INC    dx ; ARITH
004357  52                    PUSH   dx ; STACK_PUSH
004358  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
00435B  B4 08                 MOV    ah, 8 ; MOV
00435D  EC                    IN     al, dx ; IO
00435E  22 C4                 AND    al, ah ; LOGIC
004360  75 FB                 JNE    0x435d ; CJUMP
004362  EC                    IN     al, dx ; IO
004363  22 C4                 AND    al, ah ; LOGIC
004365  74 FB                 JE     0x4362 ; CJUMP
004367  FA                    CLI ; FLAG
004368  5A                    POP    dx ; STACK_POP
004369  8B CF                 MOV    cx, di ; MOV
