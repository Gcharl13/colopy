; ============================================================================
; func_01CF6D_unknown
; Region   : load_image
; Bytes    : file 0x01CF6D..0x01CFD7  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01CF6D  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01CF71  83 3E E6 0E 00        CMP    word ptr [0xee6], 0          ; UNKNOWN
01CF76  75 07                 JNE    0x1cf7f                      ; UNKNOWN
01CF78  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
01CF7D  75 0A                 JNE    0x1cf89                      ; UNKNOWN
01CF7F  0E                    PUSH   cs                           ; UNKNOWN
01CF80  E8 45 DE              CALL   0x1adc8                      ; UNKNOWN
01CF83  A3 C6 32              MOV    word ptr [0x32c6], ax        ; UNKNOWN
01CF86  A3 C8 32              MOV    word ptr [0x32c8], ax        ; UNKNOWN
01CF89  A1 C6 32              MOV    ax, word ptr [0x32c6]        ; UNKNOWN
01CF8C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01CF8F  83 F8 06              CMP    ax, 6                        ; UNKNOWN
01CF92  74 05                 JE     0x1cf99                      ; UNKNOWN
01CF94  83 F8 07              CMP    ax, 7                        ; UNKNOWN
01CF97  75 28                 JNE    0x1cfc1                      ; UNKNOWN
01CF99  0E                    PUSH   cs                           ; UNKNOWN
01CF9A  E8 2B DE              CALL   0x1adc8                      ; UNKNOWN
01CF9D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01CFA0  83 F8 08              CMP    ax, 8                        ; UNKNOWN
01CFA3  74 32                 JE     0x1cfd7                      ; UNKNOWN
01CFA5  77 15                 JA     0x1cfbc                      ; UNKNOWN
01CFA7  0A C0                 OR     al, al                       ; UNKNOWN
01CFA9  7C 11                 JL     0x1cfbc                      ; UNKNOWN
01CFAB  2C 02                 SUB    al, 2                        ; UNKNOWN
01CFAD  7E 06                 JLE    0x1cfb5                      ; UNKNOWN
01CFAF  2C 03                 SUB    al, 3                        ; UNKNOWN
01CFB1  74 24                 JE     0x1cfd7                      ; UNKNOWN
01CFB3  EB 07                 JMP    0x1cfbc                      ; UNKNOWN
01CFB5  83 3E C6 32 06        CMP    word ptr [0x32c6], 6         ; UNKNOWN
01CFBA  74 05                 JE     0x1cfc1                      ; UNKNOWN
01CFBC  C7 46 FE 14 00        MOV    word ptr [bp - 2], 0x14      ; UNKNOWN
01CFC1  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
01CFC6  75 16                 JNE    0x1cfde                      ; UNKNOWN
01CFC8  83 7E FE 02           CMP    word ptr [bp - 2], 2         ; UNKNOWN
01CFCC  75 15                 JNE    0x1cfe3                      ; UNKNOWN
01CFCE  F6 06 FC 3D 02        TEST   byte ptr [0x3dfc], 2         ; UNKNOWN
01CFD3  74 09                 JE     0x1cfde                      ; UNKNOWN
01CFD5  C9                    LEAVE                               ; UNKNOWN
01CFD6  CB                    RETF                                ; UNKNOWN
