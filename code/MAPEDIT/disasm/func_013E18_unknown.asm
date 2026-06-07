; ============================================================================
; func_013E18_unknown
; Region   : load_image
; Bytes    : file 0x013E18..0x013E59  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013E18  55                    PUSH   bp ; STACK_PUSH
013E19  8B EC                 MOV    bp, sp ; MOV
013E1B  33 C0                 XOR    ax, ax ; LOGIC
013E1D  33 D2                 XOR    dx, dx ; LOGIC
013E1F  8B 1E F6 44           MOV    bx, word ptr [0x44f6] ; GLOBAL_LOAD
013E23  83 FB 10              CMP    bx, 0x10 ; CMP
013E26  7D 2F                 JGE    0x13e57 ; CJUMP
013E28  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
013E2B  48                    DEC    ax ; ARITH
013E2C  C1 E8 04              SHR    ax, 4 ; LOGIC
013E2F  40                    INC    ax ; ARITH
013E30  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
013E33  C1 E2 0C              SHL    dx, 0xc ; LOGIC
013E36  03 D0                 ADD    dx, ax ; ARITH
013E38  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
013E3A  FF 1E 6C 3C           LCALL  [0x3c6c] ; LCALL
013E3E  33 D2                 XOR    dx, dx ; LOGIC
013E40  0A C0                 OR     al, al ; LOGIC
013E42  74 13                 JE     0x13e57 ; CJUMP
013E44  8B D3                 MOV    dx, bx ; MOV
013E46  33 C0                 XOR    ax, ax ; LOGIC
013E48  8B 1E F6 44           MOV    bx, word ptr [0x44f6] ; GLOBAL_LOAD
013E4C  FF 06 F6 44           INC    word ptr [0x44f6] ; ARITH
013E50  C1 E3 02              SHL    bx, 2 ; LOGIC
013E53  89 97 AC 5A           MOV    word ptr [bx + 0x5aac], dx ; MOV
013E57  C9                    LEAVE ; EPILOGUE
013E58  CB                    RETF ; RETURN
