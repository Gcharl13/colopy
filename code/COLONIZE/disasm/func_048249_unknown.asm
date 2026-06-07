; ============================================================================
; func_048249_unknown
; Region   : load_image
; Bytes    : file 0x048249..0x048272  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048249  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04824D  56                    PUSH   si                           ; UNKNOWN
04824E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
048253  81 7E 08 E7 03        CMP    word ptr [bp + 8], 0x3e7     ; UNKNOWN
048258  75 12                 JNE    0x4826c                      ; UNKNOWN
04825A  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04825E  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
048262  24 0F                 AND    al, 0xf                      ; UNKNOWN
048264  2A 87 80 88           SUB    al, byte ptr [bx - 0x7780]   ; UNKNOWN
048268  3C 14                 CMP    al, 0x14                     ; UNKNOWN
04826A  EB 1B                 JMP    0x48287                      ; UNKNOWN
04826C  69 5E 08 CA 00        IMUL   bx, word ptr [bp + 8], 0xca  ; UNKNOWN
048271  8A                    DB     0x8A                         ; UNKNOWN (raw)
