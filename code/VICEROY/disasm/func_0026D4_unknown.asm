; ============================================================================
; func_0026D4_unknown
; Region   : load_image
; Bytes    : file 0x0026D4..0x002700  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0026D4  55                    PUSH   bp ; STACK_PUSH
0026D5  8B EC                 MOV    bp, sp ; MOV
0026D7  0E                    PUSH   cs ; STACK_PUSH
0026D8  E8 EB FD              CALL   0x24c6 ; CALL_NEAR
0026DB  C6 06 4A 00 01        MOV    byte ptr [0x4a], 1 ; GLOBAL_LOAD
0026E0  A0 EE 07              MOV    al, byte ptr [0x7ee] ; GLOBAL_LOAD
0026E3  A2 4B 00              MOV    byte ptr [0x4b], al ; GLOBAL_LOAD
0026E6  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
0026E9  A2 4C 00              MOV    byte ptr [0x4c], al ; GLOBAL_LOAD
0026EC  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
0026F1  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
0026F4  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
0026F7  A3 A4 2D              MOV    word ptr [0x2da4], ax ; GLOBAL_LOAD
0026FA  89 16 A6 2D           MOV    word ptr [0x2da6], dx ; GLOBAL_LOAD
0026FE  C9                    LEAVE ; EPILOGUE
0026FF  CB                    RETF ; RETURN
