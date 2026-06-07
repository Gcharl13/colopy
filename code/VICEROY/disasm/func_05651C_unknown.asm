; ============================================================================
; func_05651C_unknown
; Region   : overlay
; Bytes    : file 0x05651C..0x056549  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05651C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
056520  0B 02                 OR     ax, word ptr [bp + si] ; LOGIC
056522  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056524  E7 06                 OUT    6, ax ; IO
056526  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056528  BE 08 00              MOV    si, 8 ; MOV
05652B  00 BD 0E 00           ADD    byte ptr [di + 0xe], bh ; ARITH
05652F  00 A7 0E 00           ADD    byte ptr [bx + 0xe], ah ; ARITH
056533  00 27                 ADD    byte ptr [bx], ah ; ARITH
056535  0E                    PUSH   cs ; STACK_PUSH
056536  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056538  4F                    DEC    di ; ARITH
056539  0C 00                 OR     al, 0 ; LOGIC
05653B  00 39                 ADD    byte ptr [bx + di], bh ; ARITH
05653D  0C 00                 OR     al, 0 ; LOGIC
05653F  00 2D                 ADD    byte ptr [di], ch ; ARITH
056541  14 00                 ADC    al, 0 ; ARITH
056543  00 17                 ADD    byte ptr [bx], dl ; ARITH
056545  14 00                 ADC    al, 0 ; ARITH
056547  00 CB                 ADD    bl, cl ; ARITH
