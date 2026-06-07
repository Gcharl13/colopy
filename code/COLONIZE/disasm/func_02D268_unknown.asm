; ============================================================================
; func_02D268_unknown
; Region   : load_image
; Bytes    : file 0x02D268..0x02D28F  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D268  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
02D26C  6A 0A                 PUSH   0xa                          ; UNKNOWN
02D26E  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
02D271  50                    PUSH   ax                           ; UNKNOWN
02D272  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02D275  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
02D27A  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02D27D  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
02D280  16                    PUSH   ss                           ; UNKNOWN
02D281  50                    PUSH   ax                           ; UNKNOWN
02D282  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D285  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D288  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
02D28D  C9                    LEAVE                               ; UNKNOWN
02D28E  CB                    RETF                                ; UNKNOWN
