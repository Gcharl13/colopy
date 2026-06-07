; ============================================================================
; func_024DEC_unknown
; Region   : load_image
; Bytes    : file 0x024DEC..0x024E3C  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024DEC  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
024DF0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
024DF3  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
024DF6  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
024DF9  16                    PUSH   ss                           ; UNKNOWN
024DFA  50                    PUSH   ax                           ; UNKNOWN
024DFB  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
024E00  83 C4 08              ADD    sp, 8                        ; UNKNOWN
024E03  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
024E06  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
024E09  EB 29                 JMP    0x24e34                      ; UNKNOWN
024E0B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
024E0D  2A E4                 SUB    ah, ah                       ; UNKNOWN
024E0F  50                    PUSH   ax                           ; UNKNOWN
024E10  68 D8 18              PUSH   0x18d8                       ; UNKNOWN
024E13  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
024E18  83 C4 04              ADD    sp, 4                        ; UNKNOWN
024E1B  0B C0                 OR     ax, ax                       ; UNKNOWN
024E1D  74 12                 JE     0x24e31                      ; UNKNOWN
024E1F  8B 46 AE              MOV    ax, word ptr [bp - 0x52]     ; UNKNOWN
024E22  40                    INC    ax                           ; UNKNOWN
024E23  50                    PUSH   ax                           ; UNKNOWN
024E24  FF 76 AE              PUSH   word ptr [bp - 0x52]         ; UNKNOWN
024E27  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
024E2C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
024E2F  EB 03                 JMP    0x24e34                      ; UNKNOWN
024E31  FF 46 AE              INC    word ptr [bp - 0x52]         ; UNKNOWN
024E34  8B 5E AE              MOV    bx, word ptr [bp - 0x52]     ; UNKNOWN
024E37  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
024E3A  75 CF                 JNE    0x24e0b                      ; UNKNOWN
