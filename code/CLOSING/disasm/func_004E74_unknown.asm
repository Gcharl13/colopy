; ============================================================================
; func_004E74_unknown
; Region   : load_image
; Bytes    : file 0x004E74..0x004E95  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004E74  55                    PUSH   bp ; STACK_PUSH
004E75  8B EC                 MOV    bp, sp ; MOV
004E77  57                    PUSH   di ; STACK_PUSH
004E78  56                    PUSH   si ; STACK_PUSH
004E79  1E                    PUSH   ds ; STACK_PUSH
004E7A  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004E7D  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
004E80  8B DF                 MOV    bx, di ; MOV
004E82  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
004E85  E3 0C                 JCXZ   0x4e93 ; CJUMP
004E87  AC                    LODSB  al, byte ptr [si] ; STR
004E88  0A C0                 OR     al, al ; LOGIC
004E8A  74 03                 JE     0x4e8f ; CJUMP
004E8C  AA                    STOSB  byte ptr es:[di], al ; STR
004E8D  E2 F8                 LOOP   0x4e87 ; CJUMP
004E8F  32 C0                 XOR    al, al ; LOGIC
004E91  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
004E93  8B C3                 MOV    ax, bx ; MOV
