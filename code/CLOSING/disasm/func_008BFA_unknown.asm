; ============================================================================
; func_008BFA_unknown
; Region   : load_image
; Bytes    : file 0x008BFA..0x008C2B  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008BFA  55                    PUSH   bp ; STACK_PUSH
008BFB  8B EC                 MOV    bp, sp ; MOV
008BFD  57                    PUSH   di ; STACK_PUSH
008BFE  56                    PUSH   si ; STACK_PUSH
008BFF  C7 06 80 36 01 00     MOV    word ptr [0x3680], 1 ; GLOBAL_LOAD
008C05  BB 40 00              MOV    bx, 0x40 ; CONST_LOAD
008C08  BE 00 03              MOV    si, 0x300 ; CONST_LOAD
008C0B  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
008C0E  BA C7 03              MOV    dx, 0x3c7 ; CONST_LOAD
008C11  32 C0                 XOR    al, al ; LOGIC
008C13  EE                    OUT    dx, al ; IO
008C14  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
008C17  B4 08                 MOV    ah, 8 ; MOV
008C19  EC                    IN     al, dx ; IO
008C1A  22 C4                 AND    al, ah ; LOGIC
008C1C  75 FB                 JNE    0x8c19 ; CJUMP
008C1E  EC                    IN     al, dx ; IO
008C1F  22 C4                 AND    al, ah ; LOGIC
008C21  74 FB                 JE     0x8c1e ; CJUMP
008C23  FA                    CLI ; FLAG
008C24  BA C9 03              MOV    dx, 0x3c9 ; CONST_LOAD
008C27  8B CE                 MOV    cx, si ; MOV
008C29  3B CB                 CMP    cx, bx ; CMP
