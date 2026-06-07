; ============================================================================
; func_04E0B4_unknown
; Region   : load_image
; Bytes    : file 0x04E0B4..0x04E19F  (235 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E0B4  C8 A2 00 00           ENTER  0xa2, 0                      ; UNKNOWN
04E0B8  57                    PUSH   di                           ; UNKNOWN
04E0B9  56                    PUSH   si                           ; UNKNOWN
04E0BA  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
04E0BD  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04E0C2  2B FF                 SUB    di, di                       ; UNKNOWN
04E0C4  C6 46 AE 40           MOV    byte ptr [bp - 0x52], 0x40   ; UNKNOWN
04E0C8  C6 46 AF 00           MOV    byte ptr [bp - 0x51], 0      ; UNKNOWN
04E0CC  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04E0CF  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04E0D2  50                    PUSH   ax                           ; UNKNOWN
04E0D3  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
04E0D8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E0DB  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04E0DE  50                    PUSH   ax                           ; UNKNOWN
04E0DF  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
04E0E4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E0E7  0B F6                 OR     si, si                       ; UNKNOWN
04E0E9  74 3C                 JE     0x4e127                      ; UNKNOWN
04E0EB  0E                    PUSH   cs                           ; UNKNOWN
04E0EC  E8 AB FF              CALL   0x4e09a                      ; UNKNOWN
04E0EF  56                    PUSH   si                           ; UNKNOWN
04E0F0  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04E0F4  50                    PUSH   ax                           ; UNKNOWN
04E0F5  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04E0FA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E0FD  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04E101  16                    PUSH   ss                           ; UNKNOWN
04E102  50                    PUSH   ax                           ; UNKNOWN
04E103  1E                    PUSH   ds                           ; UNKNOWN
04E104  68 B4 29              PUSH   0x29b4                       ; UNKNOWN
04E107  9A 0A 00 3A 5B        LCALL  0x5b3a, 0xa                  ; UNKNOWN
04E10C  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04E110  16                    PUSH   ss                           ; UNKNOWN
04E111  50                    PUSH   ax                           ; UNKNOWN
04E112  8D 1E B8 29           LEA    bx, [0x29b8]                 ; UNKNOWN
04E116  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
04E11B  A3 E0 0B              MOV    word ptr [0xbe0], ax         ; UNKNOWN
04E11E  0B C0                 OR     ax, ax                       ; UNKNOWN
04E120  75 08                 JNE    0x4e12a                      ; UNKNOWN
04E122  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
04E125  EB 6A                 JMP    0x4e191                      ; UNKNOWN
04E127  BF 01 00              MOV    di, 1                        ; UNKNOWN
04E12A  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
04E12E  74 5F                 JE     0x4e18f                      ; UNKNOWN
04E130  2B F6                 SUB    si, si                       ; UNKNOWN
04E132  FF 36 E0 0B           PUSH   word ptr [0xbe0]             ; UNKNOWN
04E136  6A 50                 PUSH   0x50                         ; UNKNOWN
04E138  68 42 C6              PUSH   0xc642                       ; UNKNOWN
04E13B  9A FA 08 65 5F        LCALL  0x5f65, 0x8fa                ; UNKNOWN
04E140  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04E143  0B C0                 OR     ax, ax                       ; UNKNOWN
04E145  75 0B                 JNE    0x4e152                      ; UNKNOWN
04E147  0B FF                 OR     di, di                       ; UNKNOWN
04E149  74 D7                 JE     0x4e122                      ; UNKNOWN
04E14B  2B FF                 SUB    di, di                       ; UNKNOWN
04E14D  C6 06 42 C6 00        MOV    byte ptr [0xc642], 0         ; UNKNOWN
04E152  1E                    PUSH   ds                           ; UNKNOWN
04E153  68 42 C6              PUSH   0xc642                       ; UNKNOWN
04E156  9A 06 00 FD 5A        LCALL  0x5afd, 6                    ; UNKNOWN
04E15B  1E                    PUSH   ds                           ; UNKNOWN
04E15C  68 42 C6              PUSH   0xc642                       ; UNKNOWN
04E15F  9A 0E 00 46 5B        LCALL  0x5b46, 0xe                  ; UNKNOWN
04E164  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04E167  50                    PUSH   ax                           ; UNKNOWN
04E168  68 42 C6              PUSH   0xc642                       ; UNKNOWN
04E16B  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
04E170  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E173  0B C0                 OR     ax, ax                       ; UNKNOWN
04E175  75 03                 JNE    0x4e17a                      ; UNKNOWN
04E177  BE 01 00              MOV    si, 1                        ; UNKNOWN
04E17A  0B F6                 OR     si, si                       ; UNKNOWN
04E17C  74 B4                 JE     0x4e132                      ; UNKNOWN
04E17E  68 42 C6              PUSH   0xc642                       ; UNKNOWN
04E181  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
04E186  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E189  05 42 C6              ADD    ax, 0xc642                   ; UNKNOWN
04E18C  A3 E2 C6              MOV    word ptr [0xc6e2], ax        ; UNKNOWN
04E18F  2B F6                 SUB    si, si                       ; UNKNOWN
04E191  0B F6                 OR     si, si                       ; UNKNOWN
04E193  74 04                 JE     0x4e199                      ; UNKNOWN
04E195  0E                    PUSH   cs                           ; UNKNOWN
04E196  E8 01 FF              CALL   0x4e09a                      ; UNKNOWN
04E199  8B C6                 MOV    ax, si                       ; UNKNOWN
04E19B  5E                    POP    si                           ; UNKNOWN
04E19C  5F                    POP    di                           ; UNKNOWN
04E19D  C9                    LEAVE                               ; UNKNOWN
04E19E  CB                    RETF                                ; UNKNOWN
