; ============================================================================
; func_00F5E6_unknown
; Region   : load_image
; Bytes    : file 0x00F5E6..0x00F62A  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F5E6  55                    PUSH   bp ; STACK_PUSH
00F5E7  8B EC                 MOV    bp, sp ; MOV
00F5E9  56                    PUSH   si ; STACK_PUSH
00F5EA  57                    PUSH   di ; STACK_PUSH
00F5EB  1E                    PUSH   ds ; STACK_PUSH
00F5EC  33 C0                 XOR    ax, ax ; LOGIC
00F5EE  8E C0                 MOV    es, ax ; MOV
00F5F0  B0 01                 MOV    al, 1 ; MOV
00F5F2  26 A2 40 04           MOV    byte ptr es:[0x440], al ; GLOBAL_LOAD
00F5F6  26 38 06 40 04        CMP    byte ptr es:[0x440], al ; CMP
00F5FB  74 F9                 JE     0xf5f6 ; CJUMP
00F5FD  8E 5E 08              MOV    ds, word ptr [bp + 8] ; LOCAL_LOAD
00F600  8E 46 0A              MOV    es, word ptr [bp + 0xa] ; LOCAL_LOAD
00F603  2E 83 3E 12 00 00     CMP    word ptr cs:[0x12], 0 ; CMP
00F609  75 03                 JNE    0xf60e ; CJUMP
00F60B  E8 8C 00              CALL   0xf69a ; CALL_NEAR
00F60E  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
00F611  E3 49                 JCXZ   0xf65c ; CJUMP
00F613  B8 60 22              MOV    ax, 0x2260 ; CONST_LOAD
00F616  BA 00 00              MOV    dx, 0 ; MOV
00F619  F7 F1                 DIV    cx ; ARITH
00F61B  8B D8                 MOV    bx, ax ; MOV
00F61D  0B DB                 OR     bx, bx ; LOGIC
00F61F  75 03                 JNE    0xf624 ; CJUMP
00F621  BB 01 00              MOV    bx, 1 ; MOV
00F624  2E A1 12 00           MOV    ax, word ptr cs:[0x12] ; GLOBAL_LOAD
00F628  2B C3                 SUB    ax, bx ; ARITH
