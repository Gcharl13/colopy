; ============================================================================
; func_037C26_unknown
; Region   : load_image
; Bytes    : file 0x037C26..0x037C96  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

037C26  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
037C2A  83 3E E6 0E 00        CMP    word ptr [0xee6], 0          ; UNKNOWN
037C2F  75 07                 JNE    0x37c38                      ; UNKNOWN
037C31  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
037C36  75 0A                 JNE    0x37c42                      ; UNKNOWN
037C38  0E                    PUSH   cs                           ; UNKNOWN
037C39  E8 76 CC              CALL   0x348b2                      ; UNKNOWN
037C3C  A3 BA 79              MOV    word ptr [0x79ba], ax        ; UNKNOWN
037C3F  A3 BC 79              MOV    word ptr [0x79bc], ax        ; UNKNOWN
037C42  A1 BA 79              MOV    ax, word ptr [0x79ba]        ; UNKNOWN
037C45  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
037C48  83 F8 0A              CMP    ax, 0xa                      ; UNKNOWN
037C4B  74 0A                 JE     0x37c57                      ; UNKNOWN
037C4D  83 F8 08              CMP    ax, 8                        ; UNKNOWN
037C50  74 05                 JE     0x37c57                      ; UNKNOWN
037C52  83 F8 09              CMP    ax, 9                        ; UNKNOWN
037C55  75 29                 JNE    0x37c80                      ; UNKNOWN
037C57  0E                    PUSH   cs                           ; UNKNOWN
037C58  E8 57 CC              CALL   0x348b2                      ; UNKNOWN
037C5B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
037C5E  0B C0                 OR     ax, ax                       ; UNKNOWN
037C60  74 34                 JE     0x37c96                      ; UNKNOWN
037C62  48                    DEC    ax                           ; UNKNOWN
037C63  74 08                 JE     0x37c6d                      ; UNKNOWN
037C65  48                    DEC    ax                           ; UNKNOWN
037C66  7C 13                 JL     0x37c7b                      ; UNKNOWN
037C68  48                    DEC    ax                           ; UNKNOWN
037C69  7E 32                 JLE    0x37c9d                      ; UNKNOWN
037C6B  EB 0E                 JMP    0x37c7b                      ; UNKNOWN
037C6D  83 3E BA 79 0A        CMP    word ptr [0x79ba], 0xa       ; UNKNOWN
037C72  74 0C                 JE     0x37c80                      ; UNKNOWN
037C74  83 3E BA 79 08        CMP    word ptr [0x79ba], 8         ; UNKNOWN
037C79  74 05                 JE     0x37c80                      ; UNKNOWN
037C7B  C7 46 FE 0F 00        MOV    word ptr [bp - 2], 0xf       ; UNKNOWN
037C80  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
037C85  75 24                 JNE    0x37cab                      ; UNKNOWN
037C87  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
037C8B  75 72                 JNE    0x37cff                      ; UNKNOWN
037C8D  F6 06 FC 3D 01        TEST   byte ptr [0x3dfc], 1         ; UNKNOWN
037C92  74 17                 JE     0x37cab                      ; UNKNOWN
037C94  C9                    LEAVE                               ; UNKNOWN
037C95  CB                    RETF                                ; UNKNOWN
