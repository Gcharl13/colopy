; ============================================================================
; func_01ADC8_unknown
; Region   : load_image
; Bytes    : file 0x01ADC8..0x01ADF0  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01ADC8  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01ADCC  C7 46 FE 14 00        MOV    word ptr [bp - 2], 0x14      ; UNKNOWN
01ADD1  6A 78                 PUSH   0x78                         ; UNKNOWN
01ADD3  6A 78                 PUSH   0x78                         ; UNKNOWN
01ADD5  6A 08                 PUSH   8                            ; UNKNOWN
01ADD7  68 C8 00              PUSH   0xc8                         ; UNKNOWN
01ADDA  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
01ADDF  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01ADE2  0B C0                 OR     ax, ax                       ; UNKNOWN
01ADE4  74 0A                 JE     0x1adf0                      ; UNKNOWN
01ADE6  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
01ADEB  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
01ADEE  C9                    LEAVE                               ; UNKNOWN
01ADEF  CB                    RETF                                ; UNKNOWN
