; ============================================================================
; func_069EB2_unknown
; Region   : load_image
; Bytes    : file 0x069EB2..0x069F47  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069EB2  55                    PUSH   bp                           ; UNKNOWN
069EB3  8B EC                 MOV    bp, sp                       ; UNKNOWN
069EB5  56                    PUSH   si                           ; UNKNOWN
069EB6  57                    PUSH   di                           ; UNKNOWN
069EB7  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
069EBA  8A 44 06              MOV    al, byte ptr [si + 6]        ; UNKNOWN
069EBD  A8 83                 TEST   al, 0x83                     ; UNKNOWN
069EBF  74 59                 JE     0x69f1a                      ; UNKNOWN
069EC1  A8 40                 TEST   al, 0x40                     ; UNKNOWN
069EC3  75 55                 JNE    0x69f1a                      ; UNKNOWN
069EC5  A8 02                 TEST   al, 2                        ; UNKNOWN
069EC7  75 42                 JNE    0x69f0b                      ; UNKNOWN
069EC9  0C 01                 OR     al, 1                        ; UNKNOWN
069ECB  88 44 06              MOV    byte ptr [si + 6], al        ; UNKNOWN
069ECE  8B FE                 MOV    di, si                       ; UNKNOWN
069ED0  81 EF 78 12           SUB    di, 0x1278                   ; UNKNOWN
069ED4  81 C7 18 13           ADD    di, 0x1318                   ; UNKNOWN
069ED8  A8 0C                 TEST   al, 0xc                      ; UNKNOWN
069EDA  75 0A                 JNE    0x69ee6                      ; UNKNOWN
069EDC  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
069EDF  75 05                 JNE    0x69ee6                      ; UNKNOWN
069EE1  56                    PUSH   si                           ; UNKNOWN
069EE2  E8 FF 10              CALL   0x6afe4                      ; UNKNOWN
069EE5  58                    POP    ax                           ; UNKNOWN
069EE6  8B 44 04              MOV    ax, word ptr [si + 4]        ; UNKNOWN
069EE9  89 04                 MOV    word ptr [si], ax            ; UNKNOWN
069EEB  FF 75 02              PUSH   word ptr [di + 2]            ; UNKNOWN
069EEE  50                    PUSH   ax                           ; UNKNOWN
069EEF  33 DB                 XOR    bx, bx                       ; UNKNOWN
069EF1  8A 5C 07              MOV    bl, byte ptr [si + 7]        ; UNKNOWN
069EF4  53                    PUSH   bx                           ; UNKNOWN
069EF5  0E                    PUSH   cs                           ; UNKNOWN
069EF6  E8 AF 08              CALL   0x6a7a8                      ; UNKNOWN
069EF9  83 C4 06              ADD    sp, 6                        ; UNKNOWN
069EFC  0B C0                 OR     ax, ax                       ; UNKNOWN
069EFE  74 11                 JE     0x69f11                      ; UNKNOWN
069F00  3D FF FF              CMP    ax, 0xffff                   ; UNKNOWN
069F03  75 1A                 JNE    0x69f1f                      ; UNKNOWN
069F05  80 4C 06 20           OR     byte ptr [si + 6], 0x20      ; UNKNOWN
069F09  EB 0A                 JMP    0x69f15                      ; UNKNOWN
069F0B  80 4C 06 20           OR     byte ptr [si + 6], 0x20      ; UNKNOWN
069F0F  EB 09                 JMP    0x69f1a                      ; UNKNOWN
069F11  80 4C 06 10           OR     byte ptr [si + 6], 0x10      ; UNKNOWN
069F15  C7 44 02 00 00        MOV    word ptr [si + 2], 0         ; UNKNOWN
069F1A  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
069F1D  EB 24                 JMP    0x69f43                      ; UNKNOWN
069F1F  8A BF 47 12           MOV    bh, byte ptr [bx + 0x1247]   ; UNKNOWN
069F23  80 E7 82              AND    bh, 0x82                     ; UNKNOWN
069F26  80 FF 82              CMP    bh, 0x82                     ; UNKNOWN
069F29  75 0B                 JNE    0x69f36                      ; UNKNOWN
069F2B  8A 7C 06              MOV    bh, byte ptr [si + 6]        ; UNKNOWN
069F2E  F6 C7 82              TEST   bh, 0x82                     ; UNKNOWN
069F31  75 03                 JNE    0x69f36                      ; UNKNOWN
069F33  80 0D 20              OR     byte ptr [di], 0x20          ; UNKNOWN
069F36  48                    DEC    ax                           ; UNKNOWN
069F37  89 44 02              MOV    word ptr [si + 2], ax        ; UNKNOWN
069F3A  8B 1C                 MOV    bx, word ptr [si]            ; UNKNOWN
069F3C  33 C0                 XOR    ax, ax                       ; UNKNOWN
069F3E  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
069F40  43                    INC    bx                           ; UNKNOWN
069F41  89 1C                 MOV    word ptr [si], bx            ; UNKNOWN
069F43  5F                    POP    di                           ; UNKNOWN
069F44  5E                    POP    si                           ; UNKNOWN
069F45  5D                    POP    bp                           ; UNKNOWN
069F46  CB                    RETF                                ; UNKNOWN
