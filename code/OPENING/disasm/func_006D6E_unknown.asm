; ============================================================================
; func_006D6E_unknown
; Region   : load_image
; Bytes    : file 0x006D6E..0x006D9C  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006D6E  55                    PUSH   bp ; STACK_PUSH
006D6F  8B EC                 MOV    bp, sp ; MOV
006D71  57                    PUSH   di ; STACK_PUSH
006D72  56                    PUSH   si ; STACK_PUSH
006D73  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006D76  33 C0                 XOR    ax, ax ; LOGIC
006D78  99                    CDQ ; ARITH
006D79  33 DB                 XOR    bx, bx ; LOGIC
006D7B  AC                    LODSB  al, byte ptr [si] ; STR
006D7C  3C 20                 CMP    al, 0x20 ; CMP
006D7E  74 FB                 JE     0x6d7b ; CJUMP
006D80  3C 09                 CMP    al, 9 ; CMP
006D82  74 F7                 JE     0x6d7b ; CJUMP
006D84  50                    PUSH   ax ; STACK_PUSH
006D85  3C 2D                 CMP    al, 0x2d ; CMP
006D87  74 04                 JE     0x6d8d ; CJUMP
006D89  3C 2B                 CMP    al, 0x2b ; CMP
006D8B  75 01                 JNE    0x6d8e ; CJUMP
006D8D  AC                    LODSB  al, byte ptr [si] ; STR
006D8E  3C 39                 CMP    al, 0x39 ; CMP
006D90  77 1F                 JA     0x6db1 ; CJUMP
006D92  2C 30                 SUB    al, 0x30 ; ARITH
006D94  72 1B                 JB     0x6db1 ; CJUMP
006D96  D1 E3                 SHL    bx, 1 ; LOGIC
006D98  D1 D2                 RCL    dx, 1 ; LOGIC
006D9A  8B CB                 MOV    cx, bx ; MOV
