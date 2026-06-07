; ============================================================================
; func_06243C_unknown
; Region   : load_image
; Bytes    : file 0x06243C..0x062451  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06243C  C8 3C 00 00           ENTER  0x3c, 0                      ; UNKNOWN
062440  57                    PUSH   di                           ; UNKNOWN
062441  56                    PUSH   si                           ; UNKNOWN
062442  C7 46 C6 01 00        MOV    word ptr [bp - 0x3a], 1      ; UNKNOWN
062447  2B C0                 SUB    ax, ax                       ; UNKNOWN
062449  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
06244C  89 46 CA              MOV    word ptr [bp - 0x36], ax     ; UNKNOWN
06244F  89                    DB     0x89                         ; UNKNOWN (raw)
062450  46                    DB     0x46                         ; UNKNOWN (raw)
