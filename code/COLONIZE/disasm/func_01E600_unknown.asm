; ============================================================================
; func_01E600_unknown
; Region   : load_image
; Bytes    : file 0x01E600..0x01E610  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E600  55                    PUSH   bp                           ; UNKNOWN
01E601  8B EC                 MOV    bp, sp                       ; UNKNOWN
01E603  56                    PUSH   si                           ; UNKNOWN
01E604  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
01E608  7D 06                 JGE    0x1e610                      ; UNKNOWN
01E60A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
01E60D  5E                    POP    si                           ; UNKNOWN
01E60E  C9                    LEAVE                               ; UNKNOWN
01E60F  CB                    RETF                                ; UNKNOWN
