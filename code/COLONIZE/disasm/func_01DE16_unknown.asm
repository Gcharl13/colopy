; ============================================================================
; func_01DE16_unknown
; Region   : load_image
; Bytes    : file 0x01DE16..0x01DE34  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01DE16  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
01DE1A  56                    PUSH   si                           ; UNKNOWN
01DE1B  6A 64                 PUSH   0x64                         ; UNKNOWN
01DE1D  6A 00                 PUSH   0                            ; UNKNOWN
01DE1F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
01DE22  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01DE25  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
01DE2A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DE2D  50                    PUSH   ax                           ; UNKNOWN
01DE2E  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
01DE33  83                    DB     0x83                         ; UNKNOWN (raw)
