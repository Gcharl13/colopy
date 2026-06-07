; ============================================================================
; func_055760_unknown
; Region   : overlay
; Bytes    : file 0x055760..0x05576B  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

055760  C8 FE 0E 00           ENTER  0xefe, 0 ; PROLOGUE
055764  83 FB 0D              CMP    bx, 0xd ; CMP
055767  75 06                 JNE    0x5576f ; CJUMP
055769  C7                    DB     0xC7 ; DATA_BYTE
05576A  86                    DB     0x86 ; DATA_BYTE
