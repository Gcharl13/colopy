; ============================================================================
; func_0140DC_unknown
; Region   : load_image
; Bytes    : file 0x0140DC..0x014100  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0140DC  55                    PUSH   bp ; STACK_PUSH
0140DD  8B EC                 MOV    bp, sp ; MOV
0140DF  A1 10 45              MOV    ax, word ptr [0x4510] ; GLOBAL_LOAD
0140E2  C1 E0 02              SHL    ax, 2 ; LOGIC
0140E5  03 06 10 45           ADD    ax, word ptr [0x4510] ; ARITH
0140E9  40                    INC    ax ; ARITH
0140EA  A3 10 45              MOV    word ptr [0x4510], ax ; GLOBAL_LOAD
0140ED  80 E4 03              AND    ah, 3 ; LOGIC
0140F0  FF 0E 0E 45           DEC    word ptr [0x450e] ; ARITH
0140F4  75 02                 JNE    0x140f8 ; CJUMP
0140F6  32 E4                 XOR    ah, ah ; LOGIC
0140F8  BA D4 03              MOV    dx, 0x3d4 ; CONST_LOAD
0140FB  B0 0D                 MOV    al, 0xd ; CONST_LOAD
0140FD  EF                    OUT    dx, ax ; IO
0140FE  C9                    LEAVE ; EPILOGUE
0140FF  CB                    RETF ; RETURN
