; ============================================================================
; func_02FC7F_unknown
; Region   : load_image
; Bytes    : file 0x02FC7F..0x02FDA4  (293 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02FC7F  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
02FC83  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02FC87  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02FC8A  2A E4                 SUB    ah, ah                       ; UNKNOWN
02FC8C  50                    PUSH   ax                           ; UNKNOWN
02FC8D  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02FC8F  50                    PUSH   ax                           ; UNKNOWN
02FC90  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
02FC95  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FC98  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02FC9B  0E                    PUSH   cs                           ; UNKNOWN
02FC9C  E8 8C FF              CALL   0x2fc2b                      ; UNKNOWN
02FC9F  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
02FCA4  E9 61 01              JMP    0x2fe08                      ; UNKNOWN
02FCA7  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
02FCAA  83 7E F4 05           CMP    word ptr [bp - 0xc], 5       ; UNKNOWN
02FCAE  7C 03                 JL     0x2fcb3                      ; UNKNOWN
02FCB0  E9 52 01              JMP    0x2fe05                      ; UNKNOWN
02FCB3  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
02FCB8  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02FCBC  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02FCBE  2A E4                 SUB    ah, ah                       ; UNKNOWN
02FCC0  03 46 F4              ADD    ax, word ptr [bp - 0xc]      ; UNKNOWN
02FCC3  48                    DEC    ax                           ; UNKNOWN
02FCC4  48                    DEC    ax                           ; UNKNOWN
02FCC5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02FCC8  8A 4F 01              MOV    cl, byte ptr [bx + 1]        ; UNKNOWN
02FCCB  2A ED                 SUB    ch, ch                       ; UNKNOWN
02FCCD  03 4E F2              ADD    cx, word ptr [bp - 0xe]      ; UNKNOWN
02FCD0  49                    DEC    cx                           ; UNKNOWN
02FCD1  49                    DEC    cx                           ; UNKNOWN
02FCD2  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
02FCD5  51                    PUSH   cx                           ; UNKNOWN
02FCD6  50                    PUSH   ax                           ; UNKNOWN
02FCD7  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02FCDC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FCDF  0B C0                 OR     ax, ax                       ; UNKNOWN
02FCE1  74 35                 JE     0x2fd18                      ; UNKNOWN
02FCE3  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
02FCE6  6A FF                 PUSH   -1                           ; UNKNOWN
02FCE8  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02FCEB  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02FCEE  9A 54 03 D2 14        LCALL  0x14d2, 0x354                ; UNKNOWN
02FCF3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02FCF6  0B C0                 OR     ax, ax                       ; UNKNOWN
02FCF8  7C 1E                 JL     0x2fd18                      ; UNKNOWN
02FCFA  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
02FCFE  9A 69 00 BA 33        LCALL  0x33ba, 0x69                 ; UNKNOWN
02FD03  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02FD06  39 06 78 73           CMP    word ptr [0x7378], ax        ; UNKNOWN
02FD0A  7F 0C                 JG     0x2fd18                      ; UNKNOWN
02FD0C  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
02FD10  8A 47 02              MOV    al, byte ptr [bx + 2]        ; UNKNOWN
02FD13  2A E4                 SUB    ah, ah                       ; UNKNOWN
02FD15  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02FD18  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
02FD1B  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
02FD1E  0E                    PUSH   cs                           ; UNKNOWN
02FD1F  E8 64 DF              CALL   0x2dc86                      ; UNKNOWN
02FD22  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FD25  0A C0                 OR     al, al                       ; UNKNOWN
02FD27  7C 05                 JL     0x2fd2e                      ; UNKNOWN
02FD29  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
02FD2E  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02FD31  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02FD34  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
02FD39  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FD3C  0B C0                 OR     ax, ax                       ; UNKNOWN
02FD3E  74 05                 JE     0x2fd45                      ; UNKNOWN
02FD40  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
02FD45  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
02FD48  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
02FD4B  0E                    PUSH   cs                           ; UNKNOWN
02FD4C  E8 B2 DE              CALL   0x2dc01                      ; UNKNOWN
02FD4F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FD52  0B C0                 OR     ax, ax                       ; UNKNOWN
02FD54  74 05                 JE     0x2fd5b                      ; UNKNOWN
02FD56  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
02FD5B  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
02FD5F  7C 1E                 JL     0x2fd7f                      ; UNKNOWN
02FD61  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02FD64  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02FD68  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02FD6B  2A E4                 SUB    ah, ah                       ; UNKNOWN
02FD6D  50                    PUSH   ax                           ; UNKNOWN
02FD6E  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
02FD73  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FD76  A8 20                 TEST   al, 0x20                     ; UNKNOWN
02FD78  75 05                 JNE    0x2fd7f                      ; UNKNOWN
02FD7A  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
02FD7F  6A 02                 PUSH   2                            ; UNKNOWN
02FD81  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02FD85  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02FD88  2A E4                 SUB    ah, ah                       ; UNKNOWN
02FD8A  50                    PUSH   ax                           ; UNKNOWN
02FD8B  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
02FD90  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FD93  0B C0                 OR     ax, ax                       ; UNKNOWN
02FD95  74 05                 JE     0x2fd9c                      ; UNKNOWN
02FD97  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
02FD9C  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
02FD9F  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
02FDA2  8B CB                 MOV    cx, bx                       ; UNKNOWN
