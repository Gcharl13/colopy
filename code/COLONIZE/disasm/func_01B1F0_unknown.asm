; ============================================================================
; func_01B1F0_unknown
; Region   : load_image
; Bytes    : file 0x01B1F0..0x01B20A  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01B1F0  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
01B1F4  57                    PUSH   di                           ; UNKNOWN
01B1F5  56                    PUSH   si                           ; UNKNOWN
01B1F6  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
01B1F9  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01B1FC  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01B1FF  0E                    PUSH   cs                           ; UNKNOWN
01B200  E8 C5 FB              CALL   0x1adc8                      ; UNKNOWN
01B203  83 F8 02              CMP    ax, 2                        ; UNKNOWN
01B206  74 03                 JE     0x1b20b                      ; UNKNOWN
01B208  E9                    DB     0xE9                         ; UNKNOWN (raw)
01B209  C3                    DB     0xC3                         ; UNKNOWN (raw)
