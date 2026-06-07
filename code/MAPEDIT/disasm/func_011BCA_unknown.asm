; ============================================================================
; func_011BCA_unknown
; Region   : load_image
; Bytes    : file 0x011BCA..0x011BFB  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011BCA  55                    PUSH   bp ; STACK_PUSH
011BCB  8B EC                 MOV    bp, sp ; MOV
011BCD  57                    PUSH   di ; STACK_PUSH
011BCE  56                    PUSH   si ; STACK_PUSH
011BCF  C7 06 B6 3A 01 00     MOV    word ptr [0x3ab6], 1 ; GLOBAL_LOAD
011BD5  BB 40 00              MOV    bx, 0x40 ; CONST_LOAD
011BD8  BE 00 03              MOV    si, 0x300 ; CONST_LOAD
011BDB  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
011BDE  BA C7 03              MOV    dx, 0x3c7 ; CONST_LOAD
011BE1  32 C0                 XOR    al, al ; LOGIC
011BE3  EE                    OUT    dx, al ; IO
011BE4  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
011BE7  B4 08                 MOV    ah, 8 ; MOV
011BE9  EC                    IN     al, dx ; IO
011BEA  22 C4                 AND    al, ah ; LOGIC
011BEC  75 FB                 JNE    0x11be9 ; CJUMP
011BEE  EC                    IN     al, dx ; IO
011BEF  22 C4                 AND    al, ah ; LOGIC
011BF1  74 FB                 JE     0x11bee ; CJUMP
011BF3  FA                    CLI ; FLAG
011BF4  BA C9 03              MOV    dx, 0x3c9 ; CONST_LOAD
011BF7  8B CE                 MOV    cx, si ; MOV
011BF9  3B CB                 CMP    cx, bx ; CMP
