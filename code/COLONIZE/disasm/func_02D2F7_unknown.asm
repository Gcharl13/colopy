; ============================================================================
; func_02D2F7_unknown
; Region   : load_image
; Bytes    : file 0x02D2F7..0x02D321  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D2F7  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
02D2FB  6A 0A                 PUSH   0xa                          ; UNKNOWN
02D2FD  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
02D300  50                    PUSH   ax                           ; UNKNOWN
02D301  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
02D304  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02D307  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
02D30C  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02D30F  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
02D312  16                    PUSH   ss                           ; UNKNOWN
02D313  50                    PUSH   ax                           ; UNKNOWN
02D314  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D317  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D31A  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
02D31F  C9                    LEAVE                               ; UNKNOWN
02D320  CB                    RETF                                ; UNKNOWN
