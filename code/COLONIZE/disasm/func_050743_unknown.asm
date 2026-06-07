; ============================================================================
; func_050743_unknown
; Region   : load_image
; Bytes    : file 0x050743..0x0507B2  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

050743  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
050747  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
05074C  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
050750  7C 55                 JL     0x507a7                      ; UNKNOWN
050752  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
050756  74 55                 JE     0x507ad                      ; UNKNOWN
050758  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
05075D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
050760  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
050763  83 E8 04              SUB    ax, 4                        ; UNKNOWN
050766  50                    PUSH   ax                           ; UNKNOWN
050767  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
05076C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05076F  83 F8 4B              CMP    ax, 0x4b                     ; UNKNOWN
050772  7C 05                 JL     0x50779                      ; UNKNOWN
050774  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
050779  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
05077D  7C 22                 JL     0x507a1                      ; UNKNOWN
05077F  6B 5E 0C 1C           IMUL   bx, word ptr [bp + 0xc], 0x1c ; UNKNOWN
050783  8A 87 86 88           MOV    al, byte ptr [bx - 0x777a]   ; UNKNOWN
050787  98                    CWDE                                ; UNKNOWN
050788  8B D8                 MOV    bx, ax                       ; UNKNOWN
05078A  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
05078D  03 D8                 ADD    bx, ax                       ; UNKNOWN
05078F  03 5E 06              ADD    bx, word ptr [bp + 6]        ; UNKNOWN
050792  D1 E3                 SHL    bx, 1                        ; UNKNOWN
050794  81 BF E6 79 80 00     CMP    word ptr [bx + 0x79e6], 0x80 ; UNKNOWN
05079A  7C 05                 JL     0x507a1                      ; UNKNOWN
05079C  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0507A1  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
0507A5  74 06                 JE     0x507ad                      ; UNKNOWN
0507A7  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0507AA  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0507AD  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0507B0  C9                    LEAVE                               ; UNKNOWN
0507B1  CB                    RETF                                ; UNKNOWN
