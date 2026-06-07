; ============================================================================
; func_015556_unknown
; Region   : load_image
; Bytes    : file 0x015556..0x015578  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015556  55                    PUSH   bp ; STACK_PUSH
015557  8B EC                 MOV    bp, sp ; MOV
015559  57                    PUSH   di ; STACK_PUSH
01555A  56                    PUSH   si ; STACK_PUSH
01555B  1E                    PUSH   ds ; STACK_PUSH
01555C  07                    POP    es ; STACK_POP
01555D  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
015560  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
015563  8B DF                 MOV    bx, di ; MOV
015565  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
015568  E3 0C                 JCXZ   0x15576 ; CJUMP
01556A  AC                    LODSB  al, byte ptr [si] ; STR
01556B  0A C0                 OR     al, al ; LOGIC
01556D  74 03                 JE     0x15572 ; CJUMP
01556F  AA                    STOSB  byte ptr es:[di], al ; STR
015570  E2 F8                 LOOP   0x1556a ; CJUMP
015572  32 C0                 XOR    al, al ; LOGIC
015574  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
015576  8B C3                 MOV    ax, bx ; MOV
