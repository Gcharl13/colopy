; ============================================================================
; func_010690_unknown
; Region   : load_image
; Bytes    : file 0x010690..0x0106B1  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010690  55                    PUSH   bp ; STACK_PUSH
010691  8B EC                 MOV    bp, sp ; MOV
010693  57                    PUSH   di ; STACK_PUSH
010694  56                    PUSH   si ; STACK_PUSH
010695  1E                    PUSH   ds ; STACK_PUSH
010696  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
010699  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
01069C  8B DF                 MOV    bx, di ; MOV
01069E  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
0106A1  E3 0C                 JCXZ   0x106af ; CJUMP
0106A3  AC                    LODSB  al, byte ptr [si] ; STR
0106A4  0A C0                 OR     al, al ; LOGIC
0106A6  74 03                 JE     0x106ab ; CJUMP
0106A8  AA                    STOSB  byte ptr es:[di], al ; STR
0106A9  E2 F8                 LOOP   0x106a3 ; CJUMP
0106AB  32 C0                 XOR    al, al ; LOGIC
0106AD  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
0106AF  8B C3                 MOV    ax, bx ; MOV
