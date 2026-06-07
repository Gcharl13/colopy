; ============================================================================
; func_063644_unknown
; Region   : load_image
; Bytes    : file 0x063644..0x0636DC  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063644  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
063648  53                    PUSH   bx                           ; UNKNOWN
063649  52                    PUSH   dx                           ; UNKNOWN
06364A  50                    PUSH   ax                           ; UNKNOWN
06364B  57                    PUSH   di                           ; UNKNOWN
06364C  56                    PUSH   si                           ; UNKNOWN
06364D  8B 46 16              MOV    ax, word ptr [bp + 0x16]     ; UNKNOWN
063650  2B 46 08              SUB    ax, word ptr [bp + 8]        ; UNKNOWN
063653  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
063656  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
063659  2B 46 08              SUB    ax, word ptr [bp + 8]        ; UNKNOWN
06365C  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
06365F  8B 46 1A              MOV    ax, word ptr [bp + 0x1a]     ; UNKNOWN
063662  0B 46 18              OR     ax, word ptr [bp + 0x18]     ; UNKNOWN
063665  74 0F                 JE     0x63676                      ; UNKNOWN
063667  8B 46 12              MOV    ax, word ptr [bp + 0x12]     ; UNKNOWN
06366A  0B 46 10              OR     ax, word ptr [bp + 0x10]     ; UNKNOWN
06366D  74 07                 JE     0x63676                      ; UNKNOWN
06366F  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1       ; UNKNOWN
063674  EB 05                 JMP    0x6367b                      ; UNKNOWN
063676  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
06367B  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
06367F  75 03                 JNE    0x63684                      ; UNKNOWN
063681  E9 AA 00              JMP    0x6372e                      ; UNKNOWN
063684  8D 5E 14              LEA    bx, [bp + 0x14]              ; UNKNOWN
063687  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
06368A  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
06368D  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
063692  52                    PUSH   dx                           ; UNKNOWN
063693  50                    PUSH   ax                           ; UNKNOWN
063694  9A 06 00 4E 00        LCALL  0x4e, 6                      ; UNKNOWN
063699  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06369C  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
06369F  8D 5E 0C              LEA    bx, [bp + 0xc]               ; UNKNOWN
0636A2  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
0636A5  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
0636A8  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
0636AD  52                    PUSH   dx                           ; UNKNOWN
0636AE  50                    PUSH   ax                           ; UNKNOWN
0636AF  9A 06 00 4E 00        LCALL  0x4e, 6                      ; UNKNOWN
0636B4  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0636B7  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
0636BA  1E                    PUSH   ds                           ; UNKNOWN
0636BB  C4 7E F8              LES    di, ptr [bp - 8]             ; UNKNOWN
0636BE  C5 76 FC              LDS    si, ptr [bp - 4]             ; UNKNOWN
0636C1  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0636C4  0B C0                 OR     ax, ax                       ; UNKNOWN
0636C6  75 02                 JNE    0x636ca                      ; UNKNOWN
0636C8  EB 63                 JMP    0x6372d                      ; UNKNOWN
0636CA  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0636CD  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
0636D0  D1 EA                 SHR    dx, 1                        ; UNKNOWN
0636D2  73 2F                 JAE    0x63703                      ; UNKNOWN
0636D4  0B D2                 OR     dx, dx                       ; UNKNOWN
0636D6  74 04                 JE     0x636dc                      ; UNKNOWN
0636D8  8B CA                 MOV    cx, dx                       ; UNKNOWN
0636DA  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
