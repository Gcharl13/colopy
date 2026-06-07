; ============================================================================
; func_015BD8_unknown
; Region   : load_image
; Bytes    : file 0x015BD8..0x015BF9  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015BD8  55                    PUSH   bp ; STACK_PUSH
015BD9  8B EC                 MOV    bp, sp ; MOV
015BDB  57                    PUSH   di ; STACK_PUSH
015BDC  56                    PUSH   si ; STACK_PUSH
015BDD  1E                    PUSH   ds ; STACK_PUSH
015BDE  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015BE1  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
015BE4  8B DF                 MOV    bx, di ; MOV
015BE6  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
015BE9  E3 0C                 JCXZ   0x15bf7 ; CJUMP
015BEB  AC                    LODSB  al, byte ptr [si] ; STR
015BEC  0A C0                 OR     al, al ; LOGIC
015BEE  74 03                 JE     0x15bf3 ; CJUMP
015BF0  AA                    STOSB  byte ptr es:[di], al ; STR
015BF1  E2 F8                 LOOP   0x15beb ; CJUMP
015BF3  32 C0                 XOR    al, al ; LOGIC
015BF5  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
015BF7  8B C3                 MOV    ax, bx ; MOV
