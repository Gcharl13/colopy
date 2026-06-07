; ============================================================================
; func_0033F2_unknown
; Region   : load_image
; Bytes    : file 0x0033F2..0x00341D  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0033F2  55                    PUSH   bp ; STACK_PUSH
0033F3  8B EC                 MOV    bp, sp ; MOV
0033F5  53                    PUSH   bx ; STACK_PUSH
0033F6  52                    PUSH   dx ; STACK_PUSH
0033F7  0B D2                 OR     dx, dx ; LOGIC
0033F9  75 04                 JNE    0x33ff ; CJUMP
0033FB  0B DB                 OR     bx, bx ; LOGIC
0033FD  74 1C                 JE     0x341b ; CJUMP
0033FF  8B 1E E0 2C           MOV    bx, word ptr [0x2ce0] ; GLOBAL_LOAD
003403  D1 E3                 SHL    bx, 1 ; LOGIC
003405  89 87 F4 2C           MOV    word ptr [bx + 0x2cf4], ax ; MOV
003409  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00340C  89 87 CE 2C           MOV    word ptr [bx + 0x2cce], ax ; MOV
003410  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
003413  89 87 E2 2C           MOV    word ptr [bx + 0x2ce2], ax ; MOV
003417  FF 06 E0 2C           INC    word ptr [0x2ce0] ; ARITH
00341B  C9                    LEAVE ; EPILOGUE
00341C  CB                    RETF ; RETURN
