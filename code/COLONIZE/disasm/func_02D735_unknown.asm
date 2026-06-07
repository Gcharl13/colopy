; ============================================================================
; func_02D735_unknown
; Region   : load_image
; Bytes    : file 0x02D735..0x02D77B  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D735  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
02D739  C7 46 F4 FF FF        MOV    word ptr [bp - 0xc], 0xffff  ; UNKNOWN
02D73E  C7 46 FE 0F 27        MOV    word ptr [bp - 2], 0x270f    ; UNKNOWN
02D743  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
02D748  83 7E 0C FE           CMP    word ptr [bp + 0xc], -2      ; UNKNOWN
02D74C  75 16                 JNE    0x2d764                      ; UNKNOWN
02D74E  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
02D753  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D756  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D759  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
02D75E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D761  89 46 0C              MOV    word ptr [bp + 0xc], ax      ; UNKNOWN
02D764  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
02D769  E9 80 00              JMP    0x2d7ec                      ; UNKNOWN
02D76C  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
02D770  7C 0E                 JL     0x2d780                      ; UNKNOWN
02D772  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
02D775  69 5E F8 CA 00        IMUL   bx, word ptr [bp - 8], 0xca  ; UNKNOWN
02D77A  38                    DB     0x38                         ; UNKNOWN (raw)
