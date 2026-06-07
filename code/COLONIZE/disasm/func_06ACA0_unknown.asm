; ============================================================================
; func_06ACA0_unknown
; Region   : load_image
; Bytes    : file 0x06ACA0..0x06AD5F  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06ACA0  55                    PUSH   bp                           ; UNKNOWN
06ACA1  8B EC                 MOV    bp, sp                       ; UNKNOWN
06ACA3  83 EC 02              SUB    sp, 2                        ; UNKNOWN
06ACA6  57                    PUSH   di                           ; UNKNOWN
06ACA7  56                    PUSH   si                           ; UNKNOWN
06ACA8  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
06ACAD  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4       ; UNKNOWN
06ACB1  74 1F                 JE     0x6acd2                      ; UNKNOWN
06ACB3  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
06ACB7  74 13                 JE     0x6accc                      ; UNKNOWN
06ACB9  81 7E 0C FF 7F        CMP    word ptr [bp + 0xc], 0x7fff  ; UNKNOWN
06ACBE  77 0C                 JA     0x6accc                      ; UNKNOWN
06ACC0  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
06ACC4  74 0C                 JE     0x6acd2                      ; UNKNOWN
06ACC6  83 7E 0A 40           CMP    word ptr [bp + 0xa], 0x40    ; UNKNOWN
06ACCA  74 06                 JE     0x6acd2                      ; UNKNOWN
06ACCC  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06ACCF  E9 87 00              JMP    0x6ad59                      ; UNKNOWN
06ACD2  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
06ACD5  8B FE                 MOV    di, si                       ; UNKNOWN
06ACD7  81 EF 78 12           SUB    di, 0x1278                   ; UNKNOWN
06ACDB  81 C7 18 13           ADD    di, 0x1318                   ; UNKNOWN
06ACDF  56                    PUSH   si                           ; UNKNOWN
06ACE0  9A 18 06 65 5F        LCALL  0x5f65, 0x618                ; UNKNOWN
06ACE5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06ACE8  56                    PUSH   si                           ; UNKNOWN
06ACE9  E8 40 F3              CALL   0x6a02c                      ; UNKNOWN
06ACEC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06ACEF  F6 46 0A 04           TEST   byte ptr [bp + 0xa], 4       ; UNKNOWN
06ACF3  74 15                 JE     0x6ad0a                      ; UNKNOWN
06ACF5  80 4C 06 04           OR     byte ptr [si + 6], 4         ; UNKNOWN
06ACF9  C6 05 00              MOV    byte ptr [di], 0             ; UNKNOWN
06ACFC  8D 45 01              LEA    ax, [di + 1]                 ; UNKNOWN
06ACFF  89 46 08              MOV    word ptr [bp + 8], ax        ; UNKNOWN
06AD02  C7 46 0C 01 00        MOV    word ptr [bp + 0xc], 1       ; UNKNOWN
06AD07  EB 3A                 JMP    0x6ad43                      ; UNKNOWN
06AD09  90                    NOP                                 ; UNKNOWN
06AD0A  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
06AD0E  75 28                 JNE    0x6ad38                      ; UNKNOWN
06AD10  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
06AD13  9A 82 23 65 5F        LCALL  0x5f65, 0x2382               ; UNKNOWN
06AD18  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06AD1B  89 46 08              MOV    word ptr [bp + 8], ax        ; UNKNOWN
06AD1E  0B C0                 OR     ax, ax                       ; UNKNOWN
06AD20  75 08                 JNE    0x6ad2a                      ; UNKNOWN
06AD22  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
06AD27  EB 2D                 JMP    0x6ad56                      ; UNKNOWN
06AD29  90                    NOP                                 ; UNKNOWN
06AD2A  80 64 06 FB           AND    byte ptr [si + 6], 0xfb      ; UNKNOWN
06AD2E  80 4C 06 08           OR     byte ptr [si + 6], 8         ; UNKNOWN
06AD32  C6 05 00              MOV    byte ptr [di], 0             ; UNKNOWN
06AD35  EB 0C                 JMP    0x6ad43                      ; UNKNOWN
06AD37  90                    NOP                                 ; UNKNOWN
06AD38  FF 06 4C 15           INC    word ptr [0x154c]            ; UNKNOWN
06AD3C  80 64 06 F3           AND    byte ptr [si + 6], 0xf3      ; UNKNOWN
06AD40  C6 05 01              MOV    byte ptr [di], 1             ; UNKNOWN
06AD43  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
06AD46  89 45 02              MOV    word ptr [di + 2], ax        ; UNKNOWN
06AD49  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06AD4C  89 44 04              MOV    word ptr [si + 4], ax        ; UNKNOWN
06AD4F  89 04                 MOV    word ptr [si], ax            ; UNKNOWN
06AD51  C7 44 02 00 00        MOV    word ptr [si + 2], 0         ; UNKNOWN
06AD56  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
06AD59  5E                    POP    si                           ; UNKNOWN
06AD5A  5F                    POP    di                           ; UNKNOWN
06AD5B  8B E5                 MOV    sp, bp                       ; UNKNOWN
06AD5D  5D                    POP    bp                           ; UNKNOWN
06AD5E  CB                    RETF                                ; UNKNOWN
