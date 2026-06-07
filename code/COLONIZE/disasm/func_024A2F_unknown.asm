; ============================================================================
; func_024A2F_unknown
; Region   : load_image
; Bytes    : file 0x024A2F..0x024A58  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024A2F  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
024A33  68 CC 18              PUSH   0x18cc                       ; UNKNOWN
024A36  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
024A39  50                    PUSH   ax                           ; UNKNOWN
024A3A  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
024A3F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
024A42  A0 06 0A              MOV    al, byte ptr [0xa06]         ; UNKNOWN
024A45  00 46 EF              ADD    byte ptr [bp - 0x11], al     ; UNKNOWN
024A48  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
024A4B  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
024A4E  8D 5E EC              LEA    bx, [bp - 0x14]              ; UNKNOWN
024A51  E8 1C FF              CALL   0x24970                      ; UNKNOWN
024A54  C9                    LEAVE                               ; UNKNOWN
024A55  C2 04 00              RET    4                            ; UNKNOWN
