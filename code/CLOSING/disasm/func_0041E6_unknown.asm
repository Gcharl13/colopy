; ============================================================================
; func_0041E6_unknown
; Region   : load_image
; Bytes    : file 0x0041E6..0x00422A  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0041E6  55                    PUSH   bp ; STACK_PUSH
0041E7  8B EC                 MOV    bp, sp ; MOV
0041E9  56                    PUSH   si ; STACK_PUSH
0041EA  57                    PUSH   di ; STACK_PUSH
0041EB  1E                    PUSH   ds ; STACK_PUSH
0041EC  33 C0                 XOR    ax, ax ; LOGIC
0041EE  8E C0                 MOV    es, ax ; MOV
0041F0  B0 01                 MOV    al, 1 ; MOV
0041F2  26 A2 40 04           MOV    byte ptr es:[0x440], al ; GLOBAL_LOAD
0041F6  26 38 06 40 04        CMP    byte ptr es:[0x440], al ; CMP
0041FB  74 F9                 JE     0x41f6 ; CJUMP
0041FD  8E 5E 08              MOV    ds, word ptr [bp + 8] ; LOCAL_LOAD
004200  8E 46 0A              MOV    es, word ptr [bp + 0xa] ; LOCAL_LOAD
004203  2E 83 3E 12 00 00     CMP    word ptr cs:[0x12], 0 ; CMP
004209  75 03                 JNE    0x420e ; CJUMP
00420B  E8 8C 00              CALL   0x429a ; CALL_NEAR
00420E  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
004211  E3 49                 JCXZ   0x425c ; CJUMP
004213  B8 60 22              MOV    ax, 0x2260 ; CONST_LOAD
004216  BA 00 00              MOV    dx, 0 ; MOV
004219  F7 F1                 DIV    cx ; ARITH
00421B  8B D8                 MOV    bx, ax ; MOV
00421D  0B DB                 OR     bx, bx ; LOGIC
00421F  75 03                 JNE    0x4224 ; CJUMP
004221  BB 01 00              MOV    bx, 1 ; MOV
004224  2E A1 12 00           MOV    ax, word ptr cs:[0x12] ; GLOBAL_LOAD
004228  2B C3                 SUB    ax, bx ; ARITH
