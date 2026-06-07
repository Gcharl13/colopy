; ============================================================================
; func_048B1C_unknown
; Region   : load_image
; Bytes    : file 0x048B1C..0x048B2C  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048B1C  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
048B20  57                    PUSH   di                           ; UNKNOWN
048B21  56                    PUSH   si                           ; UNKNOWN
048B22  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
048B25  D1 E3                 SHL    bx, 1                        ; UNKNOWN
048B27  C4 36 CA 0B           LES    si, ptr [0xbca]              ; UNKNOWN
048B2B  26                    DB     0x26                         ; UNKNOWN (raw)
