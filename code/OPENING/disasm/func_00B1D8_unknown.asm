; ============================================================================
; func_00B1D8_unknown
; Region   : load_image
; Bytes    : file 0x00B1D8..0x00B219  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B1D8  55                    PUSH   bp ; STACK_PUSH
00B1D9  8B EC                 MOV    bp, sp ; MOV
00B1DB  33 C0                 XOR    ax, ax ; LOGIC
00B1DD  33 D2                 XOR    dx, dx ; LOGIC
00B1DF  8B 1E FA 41           MOV    bx, word ptr [0x41fa] ; GLOBAL_LOAD
00B1E3  83 FB 10              CMP    bx, 0x10 ; CMP
00B1E6  7D 2F                 JGE    0xb217 ; CJUMP
00B1E8  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00B1EB  48                    DEC    ax ; ARITH
00B1EC  C1 E8 04              SHR    ax, 4 ; LOGIC
00B1EF  40                    INC    ax ; ARITH
00B1F0  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00B1F3  C1 E2 0C              SHL    dx, 0xc ; LOGIC
00B1F6  03 D0                 ADD    dx, ax ; ARITH
00B1F8  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
00B1FA  FF 1E BE 39           LCALL  [0x39be] ; LCALL
00B1FE  33 D2                 XOR    dx, dx ; LOGIC
00B200  0A C0                 OR     al, al ; LOGIC
00B202  74 13                 JE     0xb217 ; CJUMP
00B204  8B D3                 MOV    dx, bx ; MOV
00B206  33 C0                 XOR    ax, ax ; LOGIC
00B208  8B 1E FA 41           MOV    bx, word ptr [0x41fa] ; GLOBAL_LOAD
00B20C  FF 06 FA 41           INC    word ptr [0x41fa] ; ARITH
00B210  C1 E3 02              SHL    bx, 2 ; LOGIC
00B213  89 97 8A 5E           MOV    word ptr [bx + 0x5e8a], dx ; MOV
00B217  C9                    LEAVE ; EPILOGUE
00B218  CB                    RETF ; RETURN
