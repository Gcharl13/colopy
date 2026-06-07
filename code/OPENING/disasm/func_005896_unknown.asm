; ============================================================================
; func_005896_unknown
; Region   : load_image
; Bytes    : file 0x005896..0x0058B8  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005896  55                    PUSH   bp ; STACK_PUSH
005897  8B EC                 MOV    bp, sp ; MOV
005899  57                    PUSH   di ; STACK_PUSH
00589A  56                    PUSH   si ; STACK_PUSH
00589B  1E                    PUSH   ds ; STACK_PUSH
00589C  07                    POP    es ; STACK_POP
00589D  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0058A0  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
0058A3  8B DF                 MOV    bx, di ; MOV
0058A5  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0058A8  E3 0C                 JCXZ   0x58b6 ; CJUMP
0058AA  AC                    LODSB  al, byte ptr [si] ; STR
0058AB  0A C0                 OR     al, al ; LOGIC
0058AD  74 03                 JE     0x58b2 ; CJUMP
0058AF  AA                    STOSB  byte ptr es:[di], al ; STR
0058B0  E2 F8                 LOOP   0x58aa ; CJUMP
0058B2  32 C0                 XOR    al, al ; LOGIC
0058B4  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
0058B6  8B C3                 MOV    ax, bx ; MOV
