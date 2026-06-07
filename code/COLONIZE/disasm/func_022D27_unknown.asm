; ============================================================================
; func_022D27_unknown
; Region   : load_image
; Bytes    : file 0x022D27..0x022D5B  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022D27  C8 08 01 00           ENTER  0x108, 0                     ; UNKNOWN
022D2B  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
022D2E  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
022D31  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
022D34  8D 86 F8 FE           LEA    ax, [bp - 0x108]             ; UNKNOWN
022D38  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
022D3B  8C 56 FE              MOV    word ptr [bp - 2], ss        ; UNKNOWN
022D3E  6A 00                 PUSH   0                            ; UNKNOWN
022D40  6A 00                 PUSH   0                            ; UNKNOWN
022D42  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
022D45  50                    PUSH   ax                           ; UNKNOWN
022D46  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
022D49  FF 36 1E 0B           PUSH   word ptr [0xb1e]             ; UNKNOWN
022D4D  FF 36 1C 0B           PUSH   word ptr [0xb1c]             ; UNKNOWN
022D51  9A 43 00 2D 45        LCALL  0x452d, 0x43                 ; UNKNOWN
022D56  8A 46 80              MOV    al, byte ptr [bp - 0x80]     ; UNKNOWN
022D59  C9                    LEAVE                               ; UNKNOWN
022D5A  CB                    RETF                                ; UNKNOWN
