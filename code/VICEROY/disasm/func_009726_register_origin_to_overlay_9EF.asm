; ============================================================================
; func_009726_unknown
; Region   : load_image
; Bytes    : file 0x009726..0x00975A  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009726  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00972A  FF 36 7A 91           PUSH   word ptr [0x917a] ; PUSH_GLOBAL
00972E  9A 2C 00 EF 09        LCALL  0x9ef, 0x2c ; LCALL
009733  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
009736  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00973A  8A 67 01              MOV    ah, byte ptr [bx + 1] ; MOV
00973D  2A C0                 SUB    al, al ; ARITH
00973F  99                    CDQ ; ARITH
009740  8A 0F                 MOV    cl, byte ptr [bx] ; MOV
009742  2A ED                 SUB    ch, ch ; ARITH
009744  03 C1                 ADD    ax, cx ; ARITH
009746  83 D2 00              ADC    dx, 0 ; ARITH
009749  03 06 80 8D           ADD    ax, word ptr [0x8d80] ; ARITH
00974D  13 16 82 8D           ADC    dx, word ptr [0x8d82] ; ARITH
009751  52                    PUSH   dx ; STACK_PUSH
009752  50                    PUSH   ax ; STACK_PUSH
009753  9A 1A 00 EF 09        LCALL  0x9ef, 0x1a ; LCALL
009758  C9                    LEAVE ; EPILOGUE
009759  CB                    RETF ; RETURN
