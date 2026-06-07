; ============================================================================
; func_04FEE1_unknown
; Region   : load_image
; Bytes    : file 0x04FEE1..0x04FEFE  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04FEE1  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04FEE5  56                    PUSH   si                           ; UNKNOWN
04FEE6  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
04FEEB  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
04FEEE  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04FEF1  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
04FEF4  03 5E FC              ADD    bx, word ptr [bp - 4]        ; UNKNOWN
04FEF7  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
04FEFA  38 87 3C CB           CMP    byte ptr [bx - 0x34c4], al   ; UNKNOWN
