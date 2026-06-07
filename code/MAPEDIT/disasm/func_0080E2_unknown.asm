; ============================================================================
; func_0080E2_unknown
; Region   : load_image
; Bytes    : file 0x0080E2..0x0080FB  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0080E2  55                    PUSH   bp ; STACK_PUSH
0080E3  8B EC                 MOV    bp, sp ; MOV
0080E5  50                    PUSH   ax ; STACK_PUSH
0080E6  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
0080E9  0B D2                 OR     dx, dx ; LOGIC
0080EB  74 0F                 JE     0x80fc ; CJUMP
0080ED  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
0080F0  B8 01 00              MOV    ax, 1 ; MOV
0080F3  D3 E0                 SHL    ax, cl ; LOGIC
0080F5  09 06 54 05           OR     word ptr [0x554], ax ; LOGIC
0080F9  C9                    LEAVE ; EPILOGUE
0080FA  CB                    RETF ; RETURN
