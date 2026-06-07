; ============================================================================
; func_078548_unknown
; Region   : overlay
; Bytes    : file 0x078548..0x078579  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078548  55                    PUSH   bp ; STACK_PUSH
078549  8B EC                 MOV    bp, sp ; MOV
07854B  57                    PUSH   di ; STACK_PUSH
07854C  56                    PUSH   si ; STACK_PUSH
07854D  C7 06 08 08 01 00     MOV    word ptr [0x808], 1 ; GLOBAL_LOAD
078553  BB 40 00              MOV    bx, 0x40 ; CONST_LOAD
078556  BE 00 03              MOV    si, 0x300 ; CONST_LOAD
078559  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
07855C  BA C7 03              MOV    dx, 0x3c7 ; CONST_LOAD
07855F  32 C0                 XOR    al, al ; LOGIC
078561  EE                    OUT    dx, al ; IO
078562  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
078565  B4 08                 MOV    ah, 8 ; MOV
078567  EC                    IN     al, dx ; IO
078568  22 C4                 AND    al, ah ; LOGIC
07856A  75 FB                 JNE    0x78567 ; CJUMP
07856C  EC                    IN     al, dx ; IO
07856D  22 C4                 AND    al, ah ; LOGIC
07856F  74 FB                 JE     0x7856c ; CJUMP
078571  FA                    CLI ; FLAG
078572  BA C9 03              MOV    dx, 0x3c9 ; CONST_LOAD
078575  8B CE                 MOV    cx, si ; MOV
078577  3B CB                 CMP    cx, bx ; CMP
