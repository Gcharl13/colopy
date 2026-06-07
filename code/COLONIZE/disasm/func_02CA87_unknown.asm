; ============================================================================
; func_02CA87_unknown
; Region   : load_image
; Bytes    : file 0x02CA87..0x02CBD9  (338 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02CA87  C8 12 03 00           ENTER  0x312, 0                     ; UNKNOWN
02CA8B  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
02CA90  8D 86 F0 FC           LEA    ax, [bp - 0x310]             ; UNKNOWN
02CA94  16                    PUSH   ss                           ; UNKNOWN
02CA95  50                    PUSH   ax                           ; UNKNOWN
02CA96  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CA98  A3 B6 40              MOV    word ptr [0x40b6], ax        ; UNKNOWN
02CA9B  50                    PUSH   ax                           ; UNKNOWN
02CA9C  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02CAA0  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02CAA4  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02CAA8  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02CAAC  68 F1 1D              PUSH   0x1df1                       ; UNKNOWN
02CAAF  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
02CAB4  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
02CAB7  0B C0                 OR     ax, ax                       ; UNKNOWN
02CAB9  74 24                 JE     0x2cadf                      ; UNKNOWN
02CABB  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
02CABF  8D 06 FA 1D           LEA    ax, [0x1dfa]                 ; UNKNOWN
02CAC3  2B D2                 SUB    dx, dx                       ; UNKNOWN
02CAC5  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
02CACA  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02CACD  0B C0                 OR     ax, ax                       ; UNKNOWN
02CACF  7F 03                 JG     0x2cad4                      ; UNKNOWN
02CAD1  E9 9E 01              JMP    0x2cc72                      ; UNKNOWN
02CAD4  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
02CAD7  FE C8                 DEC    al                           ; UNKNOWN
02CAD9  A2 1E 3E              MOV    byte ptr [0x3e1e], al        ; UNKNOWN
02CADC  E9 8E 01              JMP    0x2cc6d                      ; UNKNOWN
02CADF  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
02CAE4  8D 86 F0 FC           LEA    ax, [bp - 0x310]             ; UNKNOWN
02CAE8  16                    PUSH   ss                           ; UNKNOWN
02CAE9  50                    PUSH   ax                           ; UNKNOWN
02CAEA  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
02CAEF  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02CAF3  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02CAF7  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02CAFB  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02CAFF  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02CB03  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02CB07  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02CB0B  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02CB0F  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02CB12  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CB14  99                    CDQ                                 ; UNKNOWN
02CB15  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
02CB18  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
02CB1D  6A 00                 PUSH   0                            ; UNKNOWN
02CB1F  68 40 01              PUSH   0x140                        ; UNKNOWN
02CB22  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02CB25  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CB27  99                    CDQ                                 ; UNKNOWN
02CB28  2B DB                 SUB    bx, bx                       ; UNKNOWN
02CB2A  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02CB2F  0E                    PUSH   cs                           ; UNKNOWN
02CB30  E8 68 FE              CALL   0x2c99b                      ; UNKNOWN
02CB33  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
02CB38  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
02CB3D  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CB3F  9A 55 00 8F 5C        LCALL  0x5c8f, 0x55                 ; UNKNOWN
02CB44  A1 B6 40              MOV    ax, word ptr [0x40b6]        ; UNKNOWN
02CB47  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02CB4A  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02CB4F  0B C0                 OR     ax, ax                       ; UNKNOWN
02CB51  74 2B                 JE     0x2cb7e                      ; UNKNOWN
02CB53  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
02CB58  89 86 EE FC           MOV    word ptr [bp - 0x312], ax    ; UNKNOWN
02CB5C  83 F8 20              CMP    ax, 0x20                     ; UNKNOWN
02CB5F  74 66                 JE     0x2cbc7                      ; UNKNOWN
02CB61  7F 6F                 JG     0x2cbd2                      ; UNKNOWN
02CB63  83 F8 1B              CMP    ax, 0x1b                     ; UNKNOWN
02CB66  75 03                 JNE    0x2cb6b                      ; UNKNOWN
02CB68  E9 07 01              JMP    0x2cc72                      ; UNKNOWN
02CB6B  77 11                 JA     0x2cb7e                      ; UNKNOWN
02CB6D  2C 08                 SUB    al, 8                        ; UNKNOWN
02CB6F  74 28                 JE     0x2cb99                      ; UNKNOWN
02CB71  FE C8                 DEC    al                           ; UNKNOWN
02CB73  74 52                 JE     0x2cbc7                      ; UNKNOWN
02CB75  2C 04                 SUB    al, 4                        ; UNKNOWN
02CB77  75 05                 JNE    0x2cb7e                      ; UNKNOWN
02CB79  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
02CB7E  83 3E EA 0E 00        CMP    word ptr [0xeea], 0          ; UNKNOWN
02CB83  75 03                 JNE    0x2cb88                      ; UNKNOWN
02CB85  E9 D2 00              JMP    0x2cc5a                      ; UNKNOWN
02CB88  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
02CB8D  75 03                 JNE    0x2cb92                      ; UNKNOWN
02CB8F  E9 C8 00              JMP    0x2cc5a                      ; UNKNOWN
02CB92  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
02CB97  EB 51                 JMP    0x2cbea                      ; UNKNOWN
02CB99  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02CB9C  2A E4                 SUB    ah, ah                       ; UNKNOWN
02CB9E  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02CBA1  83 C0 04              ADD    ax, 4                        ; UNKNOWN
02CBA4  B9 05 00              MOV    cx, 5                        ; UNKNOWN
02CBA7  99                    CDQ                                 ; UNKNOWN
02CBA8  F7 F9                 IDIV   cx                           ; UNKNOWN
02CBAA  88 16 1E 3E           MOV    byte ptr [0x3e1e], dl        ; UNKNOWN
02CBAE  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02CBB1  0E                    PUSH   cs                           ; UNKNOWN
02CBB2  E8 54 FC              CALL   0x2c809                      ; UNKNOWN
02CBB5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CBB8  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02CBBB  2A E4                 SUB    ah, ah                       ; UNKNOWN
02CBBD  50                    PUSH   ax                           ; UNKNOWN
02CBBE  0E                    PUSH   cs                           ; UNKNOWN
02CBBF  E8 47 FC              CALL   0x2c809                      ; UNKNOWN
02CBC2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02CBC5  EB B7                 JMP    0x2cb7e                      ; UNKNOWN
02CBC7  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02CBCA  2A E4                 SUB    ah, ah                       ; UNKNOWN
02CBCC  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02CBCF  40                    INC    ax                           ; UNKNOWN
02CBD0  EB D2                 JMP    0x2cba4                      ; UNKNOWN
02CBD2  2D 48 01              SUB    ax, 0x148                    ; UNKNOWN
02CBD5  74 C2                 JE     0x2cb99                      ; UNKNOWN
02CBD7  83                    DB     0x83                         ; UNKNOWN (raw)
02CBD8  E8                    DB     0xE8                         ; UNKNOWN (raw)
