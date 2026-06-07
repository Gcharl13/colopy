; ============================================================================
; func_022CF4_unknown
; Region   : load_image
; Bytes    : file 0x022CF4..0x022D27  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022CF4  C8 08 01 00           ENTER  0x108, 0                     ; UNKNOWN
022CF8  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
022CFB  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
022CFE  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
022D01  8D 86 F8 FE           LEA    ax, [bp - 0x108]             ; UNKNOWN
022D05  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
022D08  8C 56 FE              MOV    word ptr [bp - 2], ss        ; UNKNOWN
022D0B  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
022D0F  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
022D13  6A 00                 PUSH   0                            ; UNKNOWN
022D15  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
022D18  8D 5E F8              LEA    bx, [bp - 8]                 ; UNKNOWN
022D1B  2B D2                 SUB    dx, dx                       ; UNKNOWN
022D1D  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
022D22  8A 46 80              MOV    al, byte ptr [bp - 0x80]     ; UNKNOWN
022D25  C9                    LEAVE                               ; UNKNOWN
022D26  CB                    RETF                                ; UNKNOWN
