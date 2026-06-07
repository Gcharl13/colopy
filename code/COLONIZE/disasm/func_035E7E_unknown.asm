; ============================================================================
; func_035E7E_unknown
; Region   : load_image
; Bytes    : file 0x035E7E..0x035E9E  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035E7E  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
035E82  56                    PUSH   si                           ; UNKNOWN
035E83  83 3E EF 0A 00        CMP    word ptr [0xaef], 0          ; UNKNOWN
035E88  75 03                 JNE    0x35e8d                      ; UNKNOWN
035E8A  E9 08 01              JMP    0x35f95                      ; UNKNOWN
035E8D  6A 47                 PUSH   0x47                         ; UNKNOWN
035E8F  6A 00                 PUSH   0                            ; UNKNOWN
035E91  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
035E94  2D 93 00              SUB    ax, 0x93                     ; UNKNOWN
035E97  50                    PUSH   ax                           ; UNKNOWN
035E98  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
035E9D  83                    DB     0x83                         ; UNKNOWN (raw)
