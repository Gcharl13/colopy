; ============================================================================
; func_024A58_unknown
; Region   : load_image
; Bytes    : file 0x024A58..0x024A81  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024A58  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
024A5C  68 D1 18              PUSH   0x18d1                       ; UNKNOWN
024A5F  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
024A62  50                    PUSH   ax                           ; UNKNOWN
024A63  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
024A68  83 C4 04              ADD    sp, 4                        ; UNKNOWN
024A6B  A0 08 0A              MOV    al, byte ptr [0xa08]         ; UNKNOWN
024A6E  00 46 EF              ADD    byte ptr [bp - 0x11], al     ; UNKNOWN
024A71  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
024A74  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
024A77  8D 5E EC              LEA    bx, [bp - 0x14]              ; UNKNOWN
024A7A  E8 F3 FE              CALL   0x24970                      ; UNKNOWN
024A7D  C9                    LEAVE                               ; UNKNOWN
024A7E  C2 04 00              RET    4                            ; UNKNOWN
