; ============================================================================
; func_016CF6_unknown
; Region   : load_image
; Bytes    : file 0x016CF6..0x016D24  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016CF6  55                    PUSH   bp ; STACK_PUSH
016CF7  8B EC                 MOV    bp, sp ; MOV
016CF9  57                    PUSH   di ; STACK_PUSH
016CFA  56                    PUSH   si ; STACK_PUSH
016CFB  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
016CFE  33 C0                 XOR    ax, ax ; LOGIC
016D00  99                    CDQ ; ARITH
016D01  33 DB                 XOR    bx, bx ; LOGIC
016D03  AC                    LODSB  al, byte ptr [si] ; STR
016D04  3C 20                 CMP    al, 0x20 ; CMP
016D06  74 FB                 JE     0x16d03 ; CJUMP
016D08  3C 09                 CMP    al, 9 ; CMP
016D0A  74 F7                 JE     0x16d03 ; CJUMP
016D0C  50                    PUSH   ax ; STACK_PUSH
016D0D  3C 2D                 CMP    al, 0x2d ; CMP
016D0F  74 04                 JE     0x16d15 ; CJUMP
016D11  3C 2B                 CMP    al, 0x2b ; CMP
016D13  75 01                 JNE    0x16d16 ; CJUMP
016D15  AC                    LODSB  al, byte ptr [si] ; STR
016D16  3C 39                 CMP    al, 0x39 ; CMP
016D18  77 1F                 JA     0x16d39 ; CJUMP
016D1A  2C 30                 SUB    al, 0x30 ; ARITH
016D1C  72 1B                 JB     0x16d39 ; CJUMP
016D1E  D1 E3                 SHL    bx, 1 ; LOGIC
016D20  D1 D2                 RCL    dx, 1 ; LOGIC
016D22  8B CB                 MOV    cx, bx ; MOV
