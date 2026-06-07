; ============================================================================
; func_048CE1_unknown
; Region   : load_image
; Bytes    : file 0x048CE1..0x048D55  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048CE1  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
048CE5  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff    ; UNKNOWN
048CEA  83 3E E4 0E 0F        CMP    word ptr [0xee4], 0xf        ; UNKNOWN
048CEF  7F 14                 JG     0x48d05                      ; UNKNOWN
048CF1  81 3E E2 0E A0 00     CMP    word ptr [0xee2], 0xa0       ; UNKNOWN
048CF7  7D 07                 JGE    0x48d00                      ; UNKNOWN
048CF9  C7 46 F8 FE FF        MOV    word ptr [bp - 8], 0xfffe    ; UNKNOWN
048CFE  EB 05                 JMP    0x48d05                      ; UNKNOWN
048D00  C7 46 F8 FD FF        MOV    word ptr [bp - 8], 0xfffd    ; UNKNOWN
048D05  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
048D0A  EB 3E                 JMP    0x48d4a                      ; UNKNOWN
048D0C  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
048D0F  39 06 3E C6           CMP    word ptr [0xc63e], ax        ; UNKNOWN
048D13  7E 3B                 JLE    0x48d50                      ; UNKNOWN
048D15  8D 4E FC              LEA    cx, [bp - 4]                 ; UNKNOWN
048D18  51                    PUSH   cx                           ; UNKNOWN
048D19  8D 4E FE              LEA    cx, [bp - 2]                 ; UNKNOWN
048D1C  51                    PUSH   cx                           ; UNKNOWN
048D1D  50                    PUSH   ax                           ; UNKNOWN
048D1E  0E                    PUSH   cs                           ; UNKNOWN
048D1F  E8 72 FF              CALL   0x48c94                      ; UNKNOWN
048D22  83 C4 06              ADD    sp, 6                        ; UNKNOWN
048D25  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
048D29  7C 1C                 JL     0x48d47                      ; UNKNOWN
048D2B  6A 07                 PUSH   7                            ; UNKNOWN
048D2D  6A 64                 PUSH   0x64                         ; UNKNOWN
048D2F  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
048D32  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
048D35  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
048D3A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
048D3D  0B C0                 OR     ax, ax                       ; UNKNOWN
048D3F  74 06                 JE     0x48d47                      ; UNKNOWN
048D41  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
048D44  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
048D47  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
048D4A  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
048D4E  7C BC                 JL     0x48d0c                      ; UNKNOWN
048D50  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
048D53  C9                    LEAVE                               ; UNKNOWN
048D54  CB                    RETF                                ; UNKNOWN
