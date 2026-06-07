; ============================================================================
; func_02ADC9_unknown
; Region   : load_image
; Bytes    : file 0x02ADC9..0x02ADEC  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02ADC9  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02ADCD  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02ADD2  0E                    PUSH   cs                           ; UNKNOWN
02ADD3  E8 32 FF              CALL   0x2ad08                      ; UNKNOWN
02ADD6  8D 1E 82 1A           LEA    bx, [0x1a82]                 ; UNKNOWN
02ADDA  B8 00 40              MOV    ax, 0x4000                   ; UNKNOWN
02ADDD  0E                    PUSH   cs                           ; UNKNOWN
02ADDE  E8 79 FF              CALL   0x2ad5a                      ; UNKNOWN
02ADE1  A3 24 0B              MOV    word ptr [0xb24], ax         ; UNKNOWN
02ADE4  89 16 26 0B           MOV    word ptr [0xb26], dx         ; UNKNOWN
02ADE8  8B C2                 MOV    ax, dx                       ; UNKNOWN
02ADEA  0B                    DB     0x0B                         ; UNKNOWN (raw)
02ADEB  06                    DB     0x06                         ; UNKNOWN (raw)
