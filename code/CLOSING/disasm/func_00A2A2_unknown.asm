; ============================================================================
; func_00A2A2_unknown
; Region   : load_image
; Bytes    : file 0x00A2A2..0x00A2E3  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A2A2  55                    PUSH   bp ; STACK_PUSH
00A2A3  8B EC                 MOV    bp, sp ; MOV
00A2A5  33 C0                 XOR    ax, ax ; LOGIC
00A2A7  33 D2                 XOR    dx, dx ; LOGIC
00A2A9  8B 1E A4 3F           MOV    bx, word ptr [0x3fa4] ; GLOBAL_LOAD
00A2AD  83 FB 10              CMP    bx, 0x10 ; CMP
00A2B0  7D 2F                 JGE    0xa2e1 ; CJUMP
00A2B2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00A2B5  48                    DEC    ax ; ARITH
00A2B6  C1 E8 04              SHR    ax, 4 ; LOGIC
00A2B9  40                    INC    ax ; ARITH
00A2BA  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00A2BD  C1 E2 0C              SHL    dx, 0xc ; LOGIC
00A2C0  03 D0                 ADD    dx, ax ; ARITH
00A2C2  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
00A2C4  FF 1E 68 37           LCALL  [0x3768] ; LCALL
00A2C8  33 D2                 XOR    dx, dx ; LOGIC
00A2CA  0A C0                 OR     al, al ; LOGIC
00A2CC  74 13                 JE     0xa2e1 ; CJUMP
00A2CE  8B D3                 MOV    dx, bx ; MOV
00A2D0  33 C0                 XOR    ax, ax ; LOGIC
00A2D2  8B 1E A4 3F           MOV    bx, word ptr [0x3fa4] ; GLOBAL_LOAD
00A2D6  FF 06 A4 3F           INC    word ptr [0x3fa4] ; ARITH
00A2DA  C1 E3 02              SHL    bx, 2 ; LOGIC
00A2DD  89 97 50 50           MOV    word ptr [bx + 0x5050], dx ; MOV
00A2E1  C9                    LEAVE ; EPILOGUE
00A2E2  CB                    RETF ; RETURN
