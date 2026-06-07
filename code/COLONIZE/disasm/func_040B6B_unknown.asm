; ============================================================================
; func_040B6B_unknown
; Region   : load_image
; Bytes    : file 0x040B6B..0x040B7F  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040B6B  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
040B6F  57                    PUSH   di                           ; UNKNOWN
040B70  56                    PUSH   si                           ; UNKNOWN
040B71  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040B74  C7 46 F6 FF FF        MOV    word ptr [bp - 0xa], 0xffff  ; UNKNOWN
040B79  6A 00                 PUSH   0                            ; UNKNOWN
040B7B  56                    PUSH   si                           ; UNKNOWN
040B7C  0E                    PUSH   cs                           ; UNKNOWN
040B7D  E8                    DB     0xE8                         ; UNKNOWN (raw)
040B7E  C3                    DB     0xC3                         ; UNKNOWN (raw)
