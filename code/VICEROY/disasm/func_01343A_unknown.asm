; ============================================================================
; func_01343A_unknown
; Region   : load_image
; Bytes    : file 0x01343A..0x01347B  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01343A  55                    PUSH   bp ; STACK_PUSH
01343B  8B EC                 MOV    bp, sp ; MOV
01343D  33 C0                 XOR    ax, ax ; LOGIC
01343F  33 D2                 XOR    dx, dx ; LOGIC
013441  8B 1E 70 27           MOV    bx, word ptr [0x2770] ; GLOBAL_LOAD
013445  83 FB 10              CMP    bx, 0x10 ; CMP
013448  7D 2F                 JGE    0x13479 ; CJUMP
01344A  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
01344D  48                    DEC    ax ; ARITH
01344E  C1 E8 04              SHR    ax, 4 ; LOGIC
013451  40                    INC    ax ; ARITH
013452  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
013455  C1 E2 0C              SHL    dx, 0xc ; LOGIC
013458  03 D0                 ADD    dx, ax ; ARITH
01345A  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
01345C  FF 1E E8 26           LCALL  [0x26e8] ; LCALL
013460  33 D2                 XOR    dx, dx ; LOGIC
013462  0A C0                 OR     al, al ; LOGIC
013464  74 13                 JE     0x13479 ; CJUMP
013466  8B D3                 MOV    dx, bx ; MOV
013468  33 C0                 XOR    ax, ax ; LOGIC
01346A  8B 1E 70 27           MOV    bx, word ptr [0x2770] ; GLOBAL_LOAD
01346E  FF 06 70 27           INC    word ptr [0x2770] ; ARITH
013472  C1 E3 02              SHL    bx, 2 ; LOGIC
013475  89 97 6A A6           MOV    word ptr [bx - 0x5996], dx ; MOV
013479  C9                    LEAVE ; EPILOGUE
01347A  CB                    RETF ; RETURN
