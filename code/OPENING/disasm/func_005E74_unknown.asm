; ============================================================================
; func_005E74_unknown
; Region   : load_image
; Bytes    : file 0x005E74..0x005E95  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005E74  55                    PUSH   bp ; STACK_PUSH
005E75  8B EC                 MOV    bp, sp ; MOV
005E77  57                    PUSH   di ; STACK_PUSH
005E78  56                    PUSH   si ; STACK_PUSH
005E79  1E                    PUSH   ds ; STACK_PUSH
005E7A  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005E7D  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
005E80  8B DF                 MOV    bx, di ; MOV
005E82  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
005E85  E3 0C                 JCXZ   0x5e93 ; CJUMP
005E87  AC                    LODSB  al, byte ptr [si] ; STR
005E88  0A C0                 OR     al, al ; LOGIC
005E8A  74 03                 JE     0x5e8f ; CJUMP
005E8C  AA                    STOSB  byte ptr es:[di], al ; STR
005E8D  E2 F8                 LOOP   0x5e87 ; CJUMP
005E8F  32 C0                 XOR    al, al ; LOGIC
005E91  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
005E93  8B C3                 MOV    ax, bx ; MOV
