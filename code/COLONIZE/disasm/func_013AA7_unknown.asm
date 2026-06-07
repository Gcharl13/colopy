; ============================================================================
; func_013AA7_unknown
; Region   : load_image
; Bytes    : file 0x013AA7..0x013B11  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013AA7  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
013AAB  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
013AAE  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
013AB2  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
013AB7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013ABA  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
013ABD  68 F4 01              PUSH   0x1f4                        ; UNKNOWN
013AC0  2B C0                 SUB    ax, ax                       ; UNKNOWN
013AC2  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
013AC5  50                    PUSH   ax                           ; UNKNOWN
013AC6  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
013ACB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013ACE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
013AD1  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
013AD4  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
013AD9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
013ADC  50                    PUSH   ax                           ; UNKNOWN
013ADD  6A 00                 PUSH   0                            ; UNKNOWN
013ADF  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
013AE4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013AE7  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
013AEA  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
013AED  7F 22                 JG     0x13b11                      ; UNKNOWN
013AEF  6A 03                 PUSH   3                            ; UNKNOWN
013AF1  68 AC 25              PUSH   0x25ac                       ; UNKNOWN
013AF4  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
013AF9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013AFC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
013AFF  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
013B04  83 C4 02              ADD    sp, 2                        ; UNKNOWN
013B07  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
013B0C  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
013B0F  C9                    LEAVE                               ; UNKNOWN
013B10  CB                    RETF                                ; UNKNOWN
