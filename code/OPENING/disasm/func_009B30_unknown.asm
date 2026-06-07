; ============================================================================
; func_009B30_unknown
; Region   : load_image
; Bytes    : file 0x009B30..0x009B61  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009B30  55                    PUSH   bp ; STACK_PUSH
009B31  8B EC                 MOV    bp, sp ; MOV
009B33  57                    PUSH   di ; STACK_PUSH
009B34  56                    PUSH   si ; STACK_PUSH
009B35  C7 06 D6 38 01 00     MOV    word ptr [0x38d6], 1 ; GLOBAL_LOAD
009B3B  BB 40 00              MOV    bx, 0x40 ; CONST_LOAD
009B3E  BE 00 03              MOV    si, 0x300 ; CONST_LOAD
009B41  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
009B44  BA C7 03              MOV    dx, 0x3c7 ; CONST_LOAD
009B47  32 C0                 XOR    al, al ; LOGIC
009B49  EE                    OUT    dx, al ; IO
009B4A  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
009B4D  B4 08                 MOV    ah, 8 ; MOV
009B4F  EC                    IN     al, dx ; IO
009B50  22 C4                 AND    al, ah ; LOGIC
009B52  75 FB                 JNE    0x9b4f ; CJUMP
009B54  EC                    IN     al, dx ; IO
009B55  22 C4                 AND    al, ah ; LOGIC
009B57  74 FB                 JE     0x9b54 ; CJUMP
009B59  FA                    CLI ; FLAG
009B5A  BA C9 03              MOV    dx, 0x3c9 ; CONST_LOAD
009B5D  8B CE                 MOV    cx, si ; MOV
009B5F  3B CB                 CMP    cx, bx ; CMP
