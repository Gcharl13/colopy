; ============================================================================
; func_020B60_unknown
; Region   : load_image
; Bytes    : file 0x020B60..0x020B7A  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020B60  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
020B64  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
020B69  74 0F                 JE     0x20b7a                      ; UNKNOWN
020B6B  6A 01                 PUSH   1                            ; UNKNOWN
020B6D  68 6E 18              PUSH   0x186e                       ; UNKNOWN
020B70  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
020B75  83 C4 04              ADD    sp, 4                        ; UNKNOWN
020B78  C9                    LEAVE                               ; UNKNOWN
020B79  CB                    RETF                                ; UNKNOWN
