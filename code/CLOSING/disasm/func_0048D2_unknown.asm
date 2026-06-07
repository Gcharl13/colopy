; ============================================================================
; func_0048D2_unknown
; Region   : load_image
; Bytes    : file 0x0048D2..0x0048F4  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0048D2  55                    PUSH   bp ; STACK_PUSH
0048D3  8B EC                 MOV    bp, sp ; MOV
0048D5  57                    PUSH   di ; STACK_PUSH
0048D6  56                    PUSH   si ; STACK_PUSH
0048D7  1E                    PUSH   ds ; STACK_PUSH
0048D8  07                    POP    es ; STACK_POP
0048D9  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0048DC  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
0048DF  8B DF                 MOV    bx, di ; MOV
0048E1  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0048E4  E3 0C                 JCXZ   0x48f2 ; CJUMP
0048E6  AC                    LODSB  al, byte ptr [si] ; STR
0048E7  0A C0                 OR     al, al ; LOGIC
0048E9  74 03                 JE     0x48ee ; CJUMP
0048EB  AA                    STOSB  byte ptr es:[di], al ; STR
0048EC  E2 F8                 LOOP   0x48e6 ; CJUMP
0048EE  32 C0                 XOR    al, al ; LOGIC
0048F0  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
0048F2  8B C3                 MOV    ax, bx ; MOV
