; ============================================================================
; func_02369A_unknown
; Region   : load_image
; Bytes    : file 0x02369A..0x02376C  (210 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02369A  C8 26 01 00           ENTER  0x126, 0                     ; UNKNOWN
02369E  57                    PUSH   di                           ; UNKNOWN
02369F  56                    PUSH   si                           ; UNKNOWN
0236A0  BE 01 00              MOV    si, 1                        ; UNKNOWN
0236A3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0236A6  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
0236A9  50                    PUSH   ax                           ; UNKNOWN
0236AA  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
0236AF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0236B2  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
0236B5  16                    PUSH   ss                           ; UNKNOWN
0236B6  50                    PUSH   ax                           ; UNKNOWN
0236B7  1E                    PUSH   ds                           ; UNKNOWN
0236B8  68 B8 18              PUSH   0x18b8                       ; UNKNOWN
0236BB  9A 0A 00 3A 5B        LCALL  0x5b3a, 0xa                  ; UNKNOWN
0236C0  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
0236C4  16                    PUSH   ss                           ; UNKNOWN
0236C5  50                    PUSH   ax                           ; UNKNOWN
0236C6  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
0236C9  16                    PUSH   ss                           ; UNKNOWN
0236CA  50                    PUSH   ax                           ; UNKNOWN
0236CB  8D 1E BC 18           LEA    bx, [0x18bc]                 ; UNKNOWN
0236CF  2B C0                 SUB    ax, ax                       ; UNKNOWN
0236D1  9A 0E 00 AC 5B        LCALL  0x5bac, 0xe                  ; UNKNOWN
0236D6  0B C0                 OR     ax, ax                       ; UNKNOWN
0236D8  74 03                 JE     0x236dd                      ; UNKNOWN
0236DA  E9 89 00              JMP    0x23766                      ; UNKNOWN
0236DD  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
0236E0  16                    PUSH   ss                           ; UNKNOWN
0236E1  50                    PUSH   ax                           ; UNKNOWN
0236E2  6A 00                 PUSH   0                            ; UNKNOWN
0236E4  6A 01                 PUSH   1                            ; UNKNOWN
0236E6  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
0236EA  16                    PUSH   ss                           ; UNKNOWN
0236EB  50                    PUSH   ax                           ; UNKNOWN
0236EC  B8 08 00              MOV    ax, 8                        ; UNKNOWN
0236EF  99                    CDQ                                 ; UNKNOWN
0236F0  9A 0A 00 D7 5B        LCALL  0x5bd7, 0xa                  ; UNKNOWN
0236F5  0B D0                 OR     dx, ax                       ; UNKNOWN
0236F7  74 6D                 JE     0x23766                      ; UNKNOWN
0236F9  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
0236FC  8B 56 0E              MOV    dx, word ptr [bp + 0xe]      ; UNKNOWN
0236FF  8B F8                 MOV    di, ax                       ; UNKNOWN
023701  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
023704  83 7E 10 00           CMP    word ptr [bp + 0x10], 0      ; UNKNOWN
023708  74 15                 JE     0x2371f                      ; UNKNOWN
02370A  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
02370D  2B 56 F4              SUB    dx, word ptr [bp - 0xc]      ; UNKNOWN
023710  8D 5E 08              LEA    bx, [bp + 8]                 ; UNKNOWN
023713  2B C0                 SUB    ax, ax                       ; UNKNOWN
023715  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
02371A  8B F8                 MOV    di, ax                       ; UNKNOWN
02371C  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02371F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
023722  57                    PUSH   di                           ; UNKNOWN
023723  6A 00                 PUSH   0                            ; UNKNOWN
023725  6A 01                 PUSH   1                            ; UNKNOWN
023727  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
02372B  16                    PUSH   ss                           ; UNKNOWN
02372C  50                    PUSH   ax                           ; UNKNOWN
02372D  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
023730  F7 6E F4              IMUL   word ptr [bp - 0xc]          ; UNKNOWN
023733  9A 0A 00 D7 5B        LCALL  0x5bd7, 0xa                  ; UNKNOWN
023738  0B D0                 OR     dx, ax                       ; UNKNOWN
02373A  74 2A                 JE     0x23766                      ; UNKNOWN
02373C  FF 76 14              PUSH   word ptr [bp + 0x14]         ; UNKNOWN
02373F  FF 76 12              PUSH   word ptr [bp + 0x12]         ; UNKNOWN
023742  6A 00                 PUSH   0                            ; UNKNOWN
023744  6A 01                 PUSH   1                            ; UNKNOWN
023746  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
02374A  16                    PUSH   ss                           ; UNKNOWN
02374B  50                    PUSH   ax                           ; UNKNOWN
02374C  B8 00 03              MOV    ax, 0x300                    ; UNKNOWN
02374F  99                    CDQ                                 ; UNKNOWN
023750  9A 0A 00 D7 5B        LCALL  0x5bd7, 0xa                  ; UNKNOWN
023755  0B D0                 OR     dx, ax                       ; UNKNOWN
023757  74 0D                 JE     0x23766                      ; UNKNOWN
023759  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
02375D  16                    PUSH   ss                           ; UNKNOWN
02375E  50                    PUSH   ax                           ; UNKNOWN
02375F  9A 29 02 AC 5B        LCALL  0x5bac, 0x229                ; UNKNOWN
023764  2B F6                 SUB    si, si                       ; UNKNOWN
023766  8B C6                 MOV    ax, si                       ; UNKNOWN
023768  5E                    POP    si                           ; UNKNOWN
023769  5F                    POP    di                           ; UNKNOWN
02376A  C9                    LEAVE                               ; UNKNOWN
02376B  CB                    RETF                                ; UNKNOWN
