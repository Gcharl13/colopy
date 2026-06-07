; ============================================================================
; func_005142_unknown
; Region   : load_image
; Bytes    : file 0x005142..0x005186  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005142  55                    PUSH   bp ; STACK_PUSH
005143  8B EC                 MOV    bp, sp ; MOV
005145  56                    PUSH   si ; STACK_PUSH
005146  57                    PUSH   di ; STACK_PUSH
005147  1E                    PUSH   ds ; STACK_PUSH
005148  33 C0                 XOR    ax, ax ; LOGIC
00514A  8E C0                 MOV    es, ax ; MOV
00514C  B0 01                 MOV    al, 1 ; MOV
00514E  26 A2 40 04           MOV    byte ptr es:[0x440], al ; GLOBAL_LOAD
005152  26 38 06 40 04        CMP    byte ptr es:[0x440], al ; CMP
005157  74 F9                 JE     0x5152 ; CJUMP
005159  8E 5E 08              MOV    ds, word ptr [bp + 8] ; LOCAL_LOAD
00515C  8E 46 0A              MOV    es, word ptr [bp + 0xa] ; LOCAL_LOAD
00515F  2E 83 3E 1E 00 00     CMP    word ptr cs:[0x1e], 0 ; CMP
005165  75 03                 JNE    0x516a ; CJUMP
005167  E8 8C 00              CALL   0x51f6 ; CALL_NEAR
00516A  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
00516D  E3 49                 JCXZ   0x51b8 ; CJUMP
00516F  B8 60 22              MOV    ax, 0x2260 ; CONST_LOAD
005172  BA 00 00              MOV    dx, 0 ; MOV
005175  F7 F1                 DIV    cx ; ARITH
005177  8B D8                 MOV    bx, ax ; MOV
005179  0B DB                 OR     bx, bx ; LOGIC
00517B  75 03                 JNE    0x5180 ; CJUMP
00517D  BB 01 00              MOV    bx, 1 ; MOV
005180  2E A1 1E 00           MOV    ax, word ptr cs:[0x1e] ; GLOBAL_LOAD
005184  2B C3                 SUB    ax, bx ; ARITH
