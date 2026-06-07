; ============================================================================
; func_00F38A_unknown
; Region   : load_image
; Bytes    : file 0x00F38A..0x00F3B8  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F38A  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
00F38E  50                    PUSH   ax ; STACK_PUSH
00F38F  57                    PUSH   di ; STACK_PUSH
00F390  56                    PUSH   si ; STACK_PUSH
00F391  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
00F396  1E                    PUSH   ds ; STACK_PUSH
00F397  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00F39A  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
00F39D  8B DE                 MOV    bx, si ; MOV
00F39F  D1 E3                 SHL    bx, 1 ; LOGIC
00F3A1  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
00F3A4  4A                    DEC    dx ; ARITH
00F3A5  3B F2                 CMP    si, dx ; CMP
00F3A7  7C 03                 JL     0xf3ac ; CJUMP
00F3A9  E9 9C 00              JMP    0xf448 ; JUMP
00F3AC  26 8B 41 02           MOV    ax, word ptr es:[bx + di + 2] ; MOV
00F3B0  26 3B 01              CMP    ax, word ptr es:[bx + di] ; CMP
00F3B3  72 09                 JB     0xf3be ; CJUMP
00F3B5  46                    INC    si ; ARITH
00F3B6  83                    DB     0x83 ; DATA_BYTE
00F3B7  C3                    DB     0xC3 ; DATA_BYTE
