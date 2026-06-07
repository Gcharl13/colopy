; ============================================================================
; func_03AE47_unknown
; Region   : load_image
; Bytes    : file 0x03AE47..0x03AE5E  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03AE47  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03AE4B  83 3E 18 3E 00        CMP    word ptr [0x3e18], 0         ; UNKNOWN
03AE50  75 0C                 JNE    0x3ae5e                      ; UNKNOWN
03AE52  6A 00                 PUSH   0                            ; UNKNOWN
03AE54  68 62 23              PUSH   0x2362                       ; UNKNOWN
03AE57  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
03AE5C  C9                    LEAVE                               ; UNKNOWN
03AE5D  CB                    RETF                                ; UNKNOWN
