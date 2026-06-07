; ============================================================================
; func_048EA5_unknown
; Region   : load_image
; Bytes    : file 0x048EA5..0x048FE7  (322 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048EA5  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
048EA9  C7 46 AA 0A 00        MOV    word ptr [bp - 0x56], 0xa    ; UNKNOWN
048EAE  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
048EB1  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
048EB4  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
048EB7  83 7E 06 10           CMP    word ptr [bp + 6], 0x10      ; UNKNOWN
048EBB  75 05                 JNE    0x48ec2                      ; UNKNOWN
048EBD  C7 46 AC 37 00        MOV    word ptr [bp - 0x54], 0x37   ; UNKNOWN
048EC2  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
048EC5  D1 E3                 SHL    bx, 1                        ; UNKNOWN
048EC7  8B 87 A1 3D           MOV    ax, word ptr [bx + 0x3da1]   ; UNKNOWN
048ECB  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
048ECE  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
048ED2  7D 10                 JGE    0x48ee4                      ; UNKNOWN
048ED4  C7 46 AC 3A 00        MOV    word ptr [bp - 0x54], 0x3a   ; UNKNOWN
048ED9  C7 46 08 08 00        MOV    word ptr [bp + 8], 8         ; UNKNOWN
048EDE  A1 5C 34              MOV    ax, word ptr [0x345c]        ; UNKNOWN
048EE1  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
048EE4  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
048EE8  7C 24                 JL     0x48f0e                      ; UNKNOWN
048EEA  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
048EEE  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
048EF2  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
048EF5  48                    DEC    ax                           ; UNKNOWN
048EF6  48                    DEC    ax                           ; UNKNOWN
048EF7  50                    PUSH   ax                           ; UNKNOWN
048EF8  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
048EFB  83 C0 52              ADD    ax, 0x52                     ; UNKNOWN
048EFE  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
048F02  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
048F05  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
048F0A  83 46 AA 0E           ADD    word ptr [bp - 0x56], 0xe    ; UNKNOWN
048F0E  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
048F12  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
048F16  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
048F19  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
048F1C  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
048F20  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
048F23  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
048F28  83 46 AA 10           ADD    word ptr [bp - 0x56], 0x10   ; UNKNOWN
048F2C  C7 46 A8 00 00        MOV    word ptr [bp - 0x58], 0      ; UNKNOWN
048F31  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
048F35  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
048F39  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
048F3C  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
048F3F  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
048F43  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
048F46  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
048F4B  83 46 AA 04           ADD    word ptr [bp - 0x56], 4      ; UNKNOWN
048F4F  FF 46 A8              INC    word ptr [bp - 0x58]         ; UNKNOWN
048F52  83 7E A8 06           CMP    word ptr [bp - 0x58], 6      ; UNKNOWN
048F56  7C D9                 JL     0x48f31                      ; UNKNOWN
048F58  83 46 AA 0C           ADD    word ptr [bp - 0x56], 0xc    ; UNKNOWN
048F5C  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
048F60  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
048F63  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048F66  50                    PUSH   ax                           ; UNKNOWN
048F67  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
048F6C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
048F6F  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
048F73  7C 56                 JL     0x48fcb                      ; UNKNOWN
048F75  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048F78  50                    PUSH   ax                           ; UNKNOWN
048F79  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
048F7E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
048F81  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048F84  50                    PUSH   ax                           ; UNKNOWN
048F85  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
048F8A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
048F8D  FF 36 5E 34           PUSH   word ptr [0x345e]            ; UNKNOWN
048F91  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048F94  50                    PUSH   ax                           ; UNKNOWN
048F95  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
048F9A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
048F9D  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048FA0  50                    PUSH   ax                           ; UNKNOWN
048FA1  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
048FA6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
048FA9  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
048FAC  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
048FAF  FF B7 35 38           PUSH   word ptr [bx + 0x3835]       ; UNKNOWN
048FB3  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048FB6  50                    PUSH   ax                           ; UNKNOWN
048FB7  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
048FBC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
048FBF  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048FC2  50                    PUSH   ax                           ; UNKNOWN
048FC3  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
048FC8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
048FCB  A0 62 09              MOV    al, byte ptr [0x962]         ; UNKNOWN
048FCE  2A E4                 SUB    ah, ah                       ; UNKNOWN
048FD0  50                    PUSH   ax                           ; UNKNOWN
048FD1  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
048FD4  83 C0 04              ADD    ax, 4                        ; UNKNOWN
048FD7  50                    PUSH   ax                           ; UNKNOWN
048FD8  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
048FDB  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
048FDE  16                    PUSH   ss                           ; UNKNOWN
048FDF  50                    PUSH   ax                           ; UNKNOWN
048FE0  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
048FE5  C9                    LEAVE                               ; UNKNOWN
048FE6  CB                    RETF                                ; UNKNOWN
