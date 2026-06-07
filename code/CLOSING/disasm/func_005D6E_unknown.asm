; ============================================================================
; func_005D6E_unknown
; Region   : load_image
; Bytes    : file 0x005D6E..0x005D9C  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005D6E  55                    PUSH   bp ; STACK_PUSH
005D6F  8B EC                 MOV    bp, sp ; MOV
005D71  57                    PUSH   di ; STACK_PUSH
005D72  56                    PUSH   si ; STACK_PUSH
005D73  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005D76  33 C0                 XOR    ax, ax ; LOGIC
005D78  99                    CDQ ; ARITH
005D79  33 DB                 XOR    bx, bx ; LOGIC
005D7B  AC                    LODSB  al, byte ptr [si] ; STR
005D7C  3C 20                 CMP    al, 0x20 ; CMP
005D7E  74 FB                 JE     0x5d7b ; CJUMP
005D80  3C 09                 CMP    al, 9 ; CMP
005D82  74 F7                 JE     0x5d7b ; CJUMP
005D84  50                    PUSH   ax ; STACK_PUSH
005D85  3C 2D                 CMP    al, 0x2d ; CMP
005D87  74 04                 JE     0x5d8d ; CJUMP
005D89  3C 2B                 CMP    al, 0x2b ; CMP
005D8B  75 01                 JNE    0x5d8e ; CJUMP
005D8D  AC                    LODSB  al, byte ptr [si] ; STR
005D8E  3C 39                 CMP    al, 0x39 ; CMP
005D90  77 1F                 JA     0x5db1 ; CJUMP
005D92  2C 30                 SUB    al, 0x30 ; ARITH
005D94  72 1B                 JB     0x5db1 ; CJUMP
005D96  D1 E3                 SHL    bx, 1 ; LOGIC
005D98  D1 D2                 RCL    dx, 1 ; LOGIC
005D9A  8B CB                 MOV    cx, bx ; MOV
