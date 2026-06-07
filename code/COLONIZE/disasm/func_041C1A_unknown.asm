; ============================================================================
; func_041C1A_unknown
; Region   : load_image
; Bytes    : file 0x041C1A..0x041C2E  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041C1A  55                    PUSH   bp                           ; UNKNOWN
041C1B  8B EC                 MOV    bp, sp                       ; UNKNOWN
041C1D  C7 06 C6 37 00 00     MOV    word ptr [0x37c6], 0         ; UNKNOWN
041C23  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
041C26  A2 C8 37              MOV    byte ptr [0x37c8], al        ; UNKNOWN
041C29  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
041C2C  A2                    DB     0xA2                         ; UNKNOWN (raw)
041C2D  CB                    DB     0xCB                         ; UNKNOWN (raw)
