; ============================================================================
; func_017F13_unknown
; Region   : load_image
; Bytes    : file 0x017F13..0x017F7F  (108 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

017F13  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
017F17  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
017F1C  C7 46 F4 03 00        MOV    word ptr [bp - 0xc], 3       ; UNKNOWN
017F21  8D 46 06              LEA    ax, [bp + 6]                 ; UNKNOWN
017F24  50                    PUSH   ax                           ; UNKNOWN
017F25  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
017F28  A0 A9 08              MOV    al, byte ptr [0x8a9]         ; UNKNOWN
017F2B  98                    CWDE                                ; UNKNOWN
017F2C  50                    PUSH   ax                           ; UNKNOWN
017F2D  50                    PUSH   ax                           ; UNKNOWN
017F2E  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
017F31  50                    PUSH   ax                           ; UNKNOWN
017F32  8D 46 F0              LEA    ax, [bp - 0x10]              ; UNKNOWN
017F35  50                    PUSH   ax                           ; UNKNOWN
017F36  6A 02                 PUSH   2                            ; UNKNOWN
017F38  B8 67 00              MOV    ax, 0x67                     ; UNKNOWN
017F3B  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
017F3E  8B DA                 MOV    bx, dx                       ; UNKNOWN
017F40  9A 02 00 D0 38        LCALL  0x38d0, 2                    ; UNKNOWN
017F45  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
017F48  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
017F4C  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
017F4E  2A E4                 SUB    ah, ah                       ; UNKNOWN
017F50  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
017F53  2A F6                 SUB    dh, dh                       ; UNKNOWN
017F55  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
017F5A  EB 5F                 JMP    0x17fbb                      ; UNKNOWN
017F5C  A1 44 73              MOV    ax, word ptr [0x7344]        ; UNKNOWN
017F5F  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
017F62  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
017F65  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
017F68  75 43                 JNE    0x17fad                      ; UNKNOWN
017F6A  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
017F6E  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
017F72  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
017F76  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
017F7A  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
017F7D  8B C3                 MOV    ax, bx                       ; UNKNOWN
